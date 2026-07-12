//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestBollingerBands.mq5                                 |
//| Purpose : Validates CBollingerBands module: static readiness,    |
//|           live snapshot field population, and band order.        |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../MarketData/MarketDataProvider.mqh"
#include "../../Indicators/BollingerBands.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//+------------------------------------------------------------------+
//| Global objects (same composition as production, minus SRDetector)|
//+------------------------------------------------------------------+
CPlatform            g_platform;
CLogger              g_logger;
CErrorHandler        g_errorHandler;
CContext             g_context;
CEngine              g_engine;

CMarketDataProvider  g_marketData(10, 50, 14, 14, 20, 2.0, PERIOD_CURRENT);
CEMAIndicator        g_ema;
CATRIndicator        g_atr;
CADXIndicator        g_adx;
CBollingerBands      g_bollingerBands;   // test target
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
bool g_bbUpperNonZero     = false;
bool g_bbMiddleNonZero    = false;
bool g_bbLowerNonZero     = false;
bool g_bandOrderViolation = false;   // true if BBUpper <= BBLower when both >0
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
   Log("=== TestBollingerBands Init ===");

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

   //--- Wire engine (BB only, no SRDetector)
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetBollingerBands(GetPointer(g_bollingerBands));   // test target
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   //------------------------------------------------------------------
   // STATIC TEST — before engine initialization
   //------------------------------------------------------------------
   CTestFramework::Reset();
   CTestFramework::PrintHeader("CBollingerBands");

   // T1 — IsReady() must be false before context is injected
   CTestFramework::AssertFalse(
      g_bollingerBands.IsReady(),
      "T1: CBollingerBands::IsReady() false before engine init");

   //------------------------------------------------------------------
   // ENGINE INITIALIZATION — this will log a warning about missing
   // SRDetector, which is expected and harmless.
   //------------------------------------------------------------------
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Collecting live BB data...");
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
   if(snap == NULL)
   {
      Log("[FAIL] Snapshot() returned NULL");
      return;
   }

   //--- Track first time each BB field becomes non-zero
   if(!g_bbUpperNonZero && snap.BBUpper > 0.0)
   {
      g_bbUpperNonZero = true;
      Log(StringFormat("[INFO] BBUpper non-zero on tick %d (%.5f)", g_tickCount, snap.BBUpper));
   }
   if(!g_bbMiddleNonZero && snap.BBMiddle > 0.0)
   {
      g_bbMiddleNonZero = true;
      Log(StringFormat("[INFO] BBMiddle non-zero on tick %d (%.5f)", g_tickCount, snap.BBMiddle));
   }
   if(!g_bbLowerNonZero && snap.BBLower > 0.0)
   {
      g_bbLowerNonZero = true;
      Log(StringFormat("[INFO] BBLower non-zero on tick %d (%.5f)", g_tickCount, snap.BBLower));
   }

   //--- Band order invariant: BBUpper must be > BBLower when both are non-zero.
   if(snap.BBUpper > 0.0 && snap.BBLower > 0.0 && snap.BBUpper <= snap.BBLower)
   {
      if(!g_bandOrderViolation)
      {
         g_bandOrderViolation = true;
         Log(StringFormat("[FAIL] Band order violation on tick %d — Upper=%.5f, Lower=%.5f",
                          g_tickCount, snap.BBUpper, snap.BBLower));
      }
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

      //----------------------------------------------------------------
      // LIVE TESTS — asserted after tick accumulation
      //----------------------------------------------------------------
      CTestFramework::PrintHeader("CBollingerBands — Live Checks");

      // T2 — BBUpper was non-zero at least once
      CTestFramework::AssertTrue(
         g_bbUpperNonZero,
         "T2: Snapshot BBUpper was non-zero at least once");

      // T3 — BBMiddle was non-zero at least once
      CTestFramework::AssertTrue(
         g_bbMiddleNonZero,
         "T3: Snapshot BBMiddle was non-zero at least once");

      // T4 — BBLower was non-zero at least once
      CTestFramework::AssertTrue(
         g_bbLowerNonZero,
         "T4: Snapshot BBLower was non-zero at least once");

      // T5 — BBUpper was always greater than BBLower when both non-zero
      CTestFramework::AssertFalse(
         g_bandOrderViolation,
         "T5: Band order — BBUpper always > BBLower when both non-zero");

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