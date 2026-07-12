//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestFullPipeline.mq5                                   |
//| Purpose : Integration capstone — wires the complete composition   |
//|           root and validates the full engine pipeline ordering    |
//|           contract across multiple ticks.                         |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../MarketData/MarketDataProvider.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//+------------------------------------------------------------------+
//| Global objects — full composition root                           |
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
bool g_updateReturnedTrue = false;   // T1
bool g_dataReadyEverTrue  = false;   // T2
bool g_isReadyEverTrue    = false;   // T3
bool g_gatingViolation    = false;   // T4
bool g_fastEmaNonZero     = false;   // T5
bool g_atrNonZero         = false;   // T6
bool g_adxNonZero         = false;   // T7
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
   Log("=== TestFullPipeline Init ===");

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

   //--- Wire engine with full composition
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   //--- Initialize engine (and thus all sub-modules)
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Running full pipeline ticks...");

   // Initialize test framework statistics (no static assertions here)
   CTestFramework::Reset();

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tickCount++;

   //--- Execute full pipeline
   bool updateOk = g_engine.Update();

   // T1: track if Update ever returned true
   if(updateOk && !g_updateReturnedTrue)
   {
      g_updateReturnedTrue = true;
      Log(StringFormat("[INFO] Engine.Update() returned true on tick %d", g_tickCount));
   }

   //--- Snapshot state
   CMarketSnapshot *snap = g_context.Snapshot();
   if(snap == NULL)
      return; // should never happen

   // T2: DataReady ever true
   if(snap.DataReady && !g_dataReadyEverTrue)
   {
      g_dataReadyEverTrue = true;
      Log(StringFormat("[INFO] DataReady became true on tick %d", g_tickCount));
   }

   // T3: IsReady ever true
   if(snap.IsReady && !g_isReadyEverTrue)
   {
      g_isReadyEverTrue = true;
      Log(StringFormat("[INFO] IsReady became true on tick %d", g_tickCount));
   }

   // T4: Gating violation — IsReady true while DataReady false (check every tick)
   if(!g_gatingViolation && snap.IsReady && !snap.DataReady)
   {
      g_gatingViolation = true;
      Log(StringFormat(
         "[FAIL] Gating violation on tick %d — IsReady true but DataReady false",
         g_tickCount));
   }

   // T5-T7: Snapshot field non-zero tracking
   if(!g_fastEmaNonZero && snap.FastEMA > 0.0)
   {
      g_fastEmaNonZero = true;
      Log(StringFormat("[INFO] FastEMA non-zero on tick %d (%.5f)", g_tickCount, snap.FastEMA));
   }
   if(!g_atrNonZero && snap.ATR > 0.0)
   {
      g_atrNonZero = true;
      Log(StringFormat("[INFO] ATR non-zero on tick %d (%.5f)", g_tickCount, snap.ATR));
   }
   if(!g_adxNonZero && snap.ADX > 0.0)
   {
      g_adxNonZero = true;
      Log(StringFormat("[INFO] ADX non-zero on tick %d (%.5f)", g_tickCount, snap.ADX));
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

      CTestFramework::PrintHeader("Full Pipeline — Live Assertions");

      // T1 — Engine.Update() returned true at least once
      CTestFramework::AssertTrue(
         g_updateReturnedTrue,
         "T1: Engine.Update() returned true at least once");

      // T2 — DataReady became true at least once
      CTestFramework::AssertTrue(
         g_dataReadyEverTrue,
         "T2: DataReady became true at least once");

      // T3 — IsReady became true at least once
      CTestFramework::AssertTrue(
         g_isReadyEverTrue,
         "T3: IsReady became true at least once");

      // T4 — No gating violation (IsReady true while DataReady false)
      CTestFramework::AssertFalse(
         g_gatingViolation,
         "T4: Gating violation — IsReady never true while DataReady false");

      // T5 — FastEMA non-zero at least once
      CTestFramework::AssertTrue(
         g_fastEmaNonZero,
         "T5: Snapshot FastEMA non-zero at least once");

      // T6 — ATR non-zero at least once
      CTestFramework::AssertTrue(
         g_atrNonZero,
         "T6: Snapshot ATR non-zero at least once");

      // T7 — ADX non-zero at least once
      CTestFramework::AssertTrue(
         g_adxNonZero,
         "T7: Snapshot ADX non-zero at least once");

      // T8 — Tick count minimum threshold
      CTestFramework::AssertTrue(
         g_tickCount >= 50,
         "T8: Total tick count >= 50");

      CTestFramework::PrintSummary();
      PrintFormat("[TEST] Ticks processed: %d", g_tickCount);
   }

   //--- Shutdown in reverse order
   g_engine.Shutdown();
   g_logger.Shutdown();
   g_platform.Shutdown();

   if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
   if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
}
//+------------------------------------------------------------------+