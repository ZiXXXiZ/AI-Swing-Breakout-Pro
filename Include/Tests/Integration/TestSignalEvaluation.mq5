//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestSignalEvaluation.mq5                               |
//| Purpose : Validates CBreakoutSignal behavior in static and       |
//|           live conditions, with manual snapshot setup.           |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../MarketData/MarketDataProvider.mqh"
#include "../../Signals/BreakoutSignal.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//+------------------------------------------------------------------+
//| Global objects                                                   |
//+------------------------------------------------------------------+
CPlatform            g_platform;
CLogger              g_logger;
CErrorHandler        g_errorHandler;
CContext             g_context;
CEngine              g_engine;

CMarketDataProvider  g_marketData(10, 50, 14, 14, PERIOD_CURRENT);
CEMAIndicator        g_ema;
CATRIndicator        g_atr;
CADXIndicator        g_adx;
CBreakoutSignal      g_signal;
CRiskManager         g_risk;
CTradeExecutor       g_executor;
CPositionTracker     g_tracker;

CDefaultLogFormatter *g_formatter = NULL;
CJournalLogOutput    *g_output    = NULL;

//+------------------------------------------------------------------+
//| Live test state                                                  |
//+------------------------------------------------------------------+
int  g_tickCount          = 0;
bool g_signalEvaluated    = false;   // T6: any live valid signal
bool g_gatingViolation    = false;   // T7: IsValid true while IsReady false
bool g_summaryPrinted     = false;

//+------------------------------------------------------------------+
//| Log helper                                                       |
//+------------------------------------------------------------------+
void Log(const string msg)
{
   Print("[TEST] ", msg);
}

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   Log("=== TestSignalEvaluation Init ===");

   //--- Platform
   if(!g_platform.Initialize())
   {
      Log("FAILED - Platform.Initialize()");
      return INIT_FAILED;
   }

   //--- Logger
   g_formatter = new CDefaultLogFormatter();
   g_output    = new CJournalLogOutput();
   if(g_formatter == NULL || g_output == NULL)
   {
      Log("FAILED - Logger heap allocation");
      if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
      if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
      return INIT_FAILED;
   }
   if(!g_logger.Configure(g_formatter, g_output))
   {
      Log("FAILED - Logger.Configure()");
      delete g_formatter; g_formatter = NULL;
      delete g_output;    g_output    = NULL;
      return INIT_FAILED;
   }

   //--- ErrorHandler
   g_errorHandler.Clear();

   //--- Context
   g_context.SetPlatform(GetPointer(g_platform));
   g_context.SetLogger(GetPointer(g_logger));
   g_context.SetErrorHandler(GetPointer(g_errorHandler));
   if(!g_context.IsValid())
   {
      Log("FAILED - Context.IsValid()");
      return INIT_FAILED;
   }

   //--- Wire engine (not yet initialized)
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   //------------------------------------------------------------------
   // STATIC TESTS — Sub-phase A: gate behavior before engine init
   //------------------------------------------------------------------
   CTestFramework::Reset();
   CTestFramework::PrintHeader("Signal Evaluation — Static Gate");

   // Initialize signal module directly with context
   if(!g_signal.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Signal.Initialize()");
      return INIT_FAILED;
   }

   // Ensure snapshot is not ready
   CMarketSnapshot *snap = g_context.Snapshot();
   snap.DataReady = false;
   snap.IsReady   = false;

   // T1 — Signal does not produce a valid result when IsReady = false
   g_signal.Update();                         // internal check will reset result
   SSignalResult res = g_signal.GetResult();
   CTestFramework::AssertFalse(
      res.IsValid,
      "T1: Signal does not produce a valid result when IsReady = false");

   //------------------------------------------------------------------
   // STATIC TESTS — Sub-phase B: deterministic manual snapshot
   //------------------------------------------------------------------
   CTestFramework::PrintHeader("Signal Evaluation — Manual Snapshot");

   // --- BUY setup ---
   snap.FastEMA        = 1950.00;
   snap.SlowEMA        = 1900.00;
   snap.ATR            = 5.00;
   snap.ADX            = 35.00;
   snap.PlusDI         = 30.00;
   snap.MinusDI        = 10.00;
   snap.TrendDirection = TREND_UP;          // required for bullish breakout
   snap.DataReady      = true;
   snap.IsReady        = true;

   g_signal.Update();
   res = g_signal.GetResult();

   // T2 — Signal returns a valid result for strong BUY setup
   CTestFramework::AssertTrue(
      res.IsValid,
      "T2: Valid result for strong BUY setup");

   // T3 — Signal direction is BUY
   CTestFramework::AssertEquals(
      (int)TRADE_DIRECTION_BUY,
      (int)res.Direction,
      "T3: Direction is BUY");

   // --- SELL setup ---
   snap.FastEMA        = 1900.00;
   snap.SlowEMA        = 1950.00;
   snap.ATR            = 5.00;
   snap.ADX            = 35.00;
   snap.PlusDI         = 10.00;
   snap.MinusDI        = 30.00;
   snap.TrendDirection = TREND_DOWN;         // required for bearish breakout
   snap.DataReady      = true;
   snap.IsReady        = true;

   g_signal.Update();
   res = g_signal.GetResult();

   // T4 — Signal returns a valid result for strong SELL setup
   CTestFramework::AssertTrue(
      res.IsValid,
      "T4: Valid result for strong SELL setup");

   // T5 — Signal direction is SELL
   CTestFramework::AssertEquals(
      (int)TRADE_DIRECTION_SELL,
      (int)res.Direction,
      "T5: Direction is SELL");

   //------------------------------------------------------------------
   // ENGINE INITIALIZATION — static tests complete
   //------------------------------------------------------------------
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Collecting live signal data...");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tickCount++;

   g_engine.Update();

   CMarketSnapshot *snap = g_context.Snapshot();
   if(snap == NULL) return;

   SSignalResult res = g_signal.GetResult();

   // T6: track first valid signal in live run
   if(!g_signalEvaluated && res.IsValid)
   {
      g_signalEvaluated = true;
      Log(StringFormat("[INFO] First valid signal on tick %d (Dir=%d, Prob=%.2f)",
                       g_tickCount, res.Direction, res.Probability));
   }

   // T7: gating violation check — signal valid but snapshot not ready
   if(!g_gatingViolation && res.IsValid && !snap.IsReady)
   {
      g_gatingViolation = true;
      Log(StringFormat("[FAIL] Gating violation on tick %d — valid signal while IsReady false",
                       g_tickCount));
   }
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(!g_summaryPrinted)
   {
      g_summaryPrinted = true;

      CTestFramework::PrintHeader("Signal Evaluation — Live Checks");

      // T6 — Signal was evaluated at least once during live run
      CTestFramework::AssertTrue(
         g_signalEvaluated,
         "T6: Signal evaluated at least once during live run");

      // T7 — No signal result was produced on any tick where IsReady = false
      CTestFramework::AssertFalse(
         g_gatingViolation,
         "T7: No gating violation (valid signal while IsReady false)");

      CTestFramework::PrintSummary();
      PrintFormat("[TEST] Ticks processed: %d", g_tickCount);
   }

   //--- Shutdown in reverse initialization order
   g_engine.Shutdown();
   g_logger.Shutdown();
   g_platform.Shutdown();

   if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
   if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
}
//+------------------------------------------------------------------+