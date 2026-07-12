//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestMarketDataProvider.mq5                             |
//| Purpose : Verifies CMarketDataProvider initialization behavior,  |
//|           DataReady flag correctness, and the DataReady->IsReady |
//|           gating contract across the full engine pipeline.       |
//|                                                                  |
//| Test Coverage                                                    |
//|------------------------------------------------------------------|
//| Static (OnInit — before engine initialization):                  |
//|   T1 — DataReady is false before any initialization             |
//|   T2 — IsReady is false before any initialization               |
//|   T3 — Update() returns false when provider is not initialized  |
//|   T4 — DataReady stays false after a failed Update()            |
//|                                                                  |
//| Live (OnDeinit — after tick accumulation):                       |
//|   T5 — DataReady eventually becomes true after provider warmup  |
//|   T6 — IsReady eventually becomes true after DataReady is set   |
//|   T7 — Gating contract: IsReady never true when DataReady false |
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
int  g_tickCount          = 0;
bool g_dataReadyConfirmed = false;  // DataReady ever became true
bool g_isReadyConfirmed   = false;  // IsReady ever became true
bool g_gatingViolation    = false;  // IsReady true while DataReady false
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
   Log("=== TestMarketDataProvider Init ===");

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
   // STATIC TESTS — run before engine initialization.
   //
   // At this point g_marketData has been constructed but not yet
   // initialized by the engine. Its m_initialized flag is false and
   // m_context is NULL. This allows us to verify the defensive guard
   // inside Update() and the snapshot's true initial state.
   //------------------------------------------------------------------
   CTestFramework::Reset();
   CTestFramework::PrintHeader("CMarketDataProvider");

   CMarketSnapshot *snap = g_context.Snapshot();

   // T1 — DataReady is false before any initialization
   CTestFramework::AssertFalse(
      snap.DataReady,
      "T1: DataReady is false before engine initialization");

   // T2 — IsReady is false before any initialization
   CTestFramework::AssertFalse(
      snap.IsReady,
      "T2: IsReady is false before engine initialization");

   // T3 — Update() returns false when provider is not initialized.
   //       CMarketDataProvider::Update() guards with:
   //       if(!m_initialized || m_context == NULL) return false
   //       Neither condition is satisfied before Initialize() is called.
   CTestFramework::AssertFalse(
      g_marketData.Update(),
      "T3: Update() returns false when provider is not initialized");

   // T4 — DataReady stays false after a failed Update().
   //       The guard in Update() returns before touching the snapshot,
   //       so DataReady must remain at its constructor default of false.
   CTestFramework::AssertFalse(
      snap.DataReady,
      "T4: DataReady stays false after failed Update()");

   //------------------------------------------------------------------
   // ENGINE INITIALIZATION — static tests complete.
   // From this point, g_marketData is initialized and owns live handles.
   //------------------------------------------------------------------
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Collecting live gating data...");
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

   //--- Track first tick where DataReady becomes true
   if(snap.DataReady && !g_dataReadyConfirmed)
   {
      g_dataReadyConfirmed = true;
      Log(StringFormat("[INFO] DataReady became true on tick %d", g_tickCount));
   }

   //--- Track first tick where IsReady becomes true
   if(snap.IsReady && !g_isReadyConfirmed)
   {
      g_isReadyConfirmed = true;
      Log(StringFormat("[INFO] IsReady became true on tick %d", g_tickCount));
   }

   //--- Gating invariant check (every tick).
   //    IsReady must never be true when DataReady is false.
   //    A violation means a downstream module set IsReady independently
   //    of the MarketData contract — an architecture defect.
   if(snap.IsReady && !snap.DataReady)
   {
      if(!g_gatingViolation)
      {
         g_gatingViolation = true;
         Log(StringFormat(
            "[FAIL] Gating violation on tick %d — IsReady true while DataReady false",
            g_tickCount));
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
      // LIVE TESTS — asserted after tick accumulation.
      // Statistics from T1-T4 are still held in g_testStatistics.
      // T5-T7 are added here. PrintSummary() reports all 7 together.
      //----------------------------------------------------------------

      // T5 — DataReady eventually became true after provider warmup.
      //       Failure here means CMarketDataProvider::Update() never
      //       successfully read from all four indicator handles.
      CTestFramework::AssertTrue(
         g_dataReadyConfirmed,
         "T5: DataReady became true after provider warmup");

      // T6 — IsReady eventually became true after DataReady was set.
      //       Failure here means the engine pipeline is not propagating
      //       DataReady downstream to the indicator readiness gate.
      CTestFramework::AssertTrue(
         g_isReadyConfirmed,
         "T6: IsReady became true after DataReady was established");

      // T7 — Gating contract held for every tick in the run.
      //       Failure here is an architecture violation: a downstream
      //       module set IsReady without DataReady being true first.
      CTestFramework::AssertFalse(
         g_gatingViolation,
         "T7: Gating contract — IsReady never true when DataReady is false");

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