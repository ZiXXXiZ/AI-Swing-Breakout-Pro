//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestIndicatorPipeline.mq5                              |
//| Purpose : Validates that indicator IsReady() gates on DataReady   |
//|           and that snapshot fields populate correctly.            |
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
int  g_tickCount       = 0;
bool g_emaReady        = false;
bool g_atrReady        = false;
bool g_adxReady        = false;
bool g_fastEmaNonZero  = false;
bool g_atrNonZero      = false;
bool g_adxNonZero      = false;
bool g_summaryPrinted  = false;

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
   Log("=== TestIndicatorPipeline Init ===");

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

   //--- Wire engine
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   //------------------------------------------------------------------
   // STATIC TESTS — before engine initialization
   //------------------------------------------------------------------
   CTestFramework::Reset();
   CTestFramework::PrintHeader("Indicator Pipeline — Static Checks");

   // T1 — EMA IsReady() false when DataReady not set
   CTestFramework::AssertFalse(
      g_ema.IsReady(),
      "T1: EMA IsReady() false before engine initialization");

   // T2 — ATR IsReady() false when DataReady not set
   CTestFramework::AssertFalse(
      g_atr.IsReady(),
      "T2: ATR IsReady() false before engine initialization");

   // T3 — ADX IsReady() false when DataReady not set
   CTestFramework::AssertFalse(
      g_adx.IsReady(),
      "T3: ADX IsReady() false before engine initialization");

   //------------------------------------------------------------------
   // ENGINE INITIALIZATION
   //------------------------------------------------------------------
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Collecting live indicator data...");
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

   //--- Track indicator IsReady() first-time success
   if(!g_emaReady && g_ema.IsReady())
   {
      g_emaReady = true;
      Log(StringFormat("[INFO] EMA IsReady() became true on tick %d", g_tickCount));
   }
   if(!g_atrReady && g_atr.IsReady())
   {
      g_atrReady = true;
      Log(StringFormat("[INFO] ATR IsReady() became true on tick %d", g_tickCount));
   }
   if(!g_adxReady && g_adx.IsReady())
   {
      g_adxReady = true;
      Log(StringFormat("[INFO] ADX IsReady() became true on tick %d", g_tickCount));
   }

   //--- Track snapshot field non-zero values
   if(!g_fastEmaNonZero && snap.FastEMA > 0.0)
   {
      g_fastEmaNonZero = true;
      Log(StringFormat("[INFO] FastEMA became non-zero on tick %d (%.5f)", g_tickCount, snap.FastEMA));
   }
   if(!g_atrNonZero && snap.ATR > 0.0)
   {
      g_atrNonZero = true;
      Log(StringFormat("[INFO] ATR became non-zero on tick %d (%.5f)", g_tickCount, snap.ATR));
   }
   if(!g_adxNonZero && snap.ADX > 0.0)
   {
      g_adxNonZero = true;
      Log(StringFormat("[INFO] ADX became non-zero on tick %d (%.5f)", g_tickCount, snap.ADX));
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
      CTestFramework::PrintHeader("Indicator Pipeline — Live Checks");

      // T4 — EMA IsReady() became true after DataReady set
      CTestFramework::AssertTrue(
         g_emaReady,
         "T4: EMA IsReady() became true after DataReady set");

      // T5 — ATR IsReady() became true after DataReady set
      CTestFramework::AssertTrue(
         g_atrReady,
         "T5: ATR IsReady() became true after DataReady set");

      // T6 — ADX IsReady() became true after DataReady set
      CTestFramework::AssertTrue(
         g_adxReady,
         "T6: ADX IsReady() became true after DataReady set");

      // T7 — Snapshot FastEMA was non-zero at least once
      CTestFramework::AssertTrue(
         g_fastEmaNonZero,
         "T7: Snapshot FastEMA was non-zero at least once");

      // T8 — Snapshot ATR was non-zero at least once
      CTestFramework::AssertTrue(
         g_atrNonZero,
         "T8: Snapshot ATR was non-zero at least once");

      // T9 — Snapshot ADX was non-zero at least once
      CTestFramework::AssertTrue(
         g_adxNonZero,
         "T9: Snapshot ADX was non-zero at least once");

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