//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestAnalysisPipeline.mq5                               |
//| Purpose : End‑to‑end verification of the full analysis pipeline: |
//|           MarketData → Indicators → BollingerBands → SRDetector  |
//|           with all readiness and gating contracts.               |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../MarketData/MarketDataProvider.mqh"
#include "../../Indicators/BollingerBands.mqh"
#include "../../Analysis/SRDetector.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//+------------------------------------------------------------------+
//| Global objects (full wiring identical to production)             |
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
CBollingerBands      g_bollingerBands;
CSRDetector          g_srDetector;
CBreakoutSignal      g_signal;
CRiskManager         g_risk;
CTradeExecutor       g_executor;
CPositionTracker     g_tracker;

CDefaultLogFormatter *g_formatter = NULL;
CJournalLogOutput    *g_output    = NULL;

//+------------------------------------------------------------------+
//| Live test state (accumulated in OnTick)                          |
//+------------------------------------------------------------------+
int  g_tickCount             = 0;
bool g_engineUpdateOk        = false;
bool g_marketIsReady         = false;
bool g_analysisIsReady       = false;
bool g_gatingViolation       = false;   // Analysis.IsReady true while Market.IsReady false
bool g_bbUpperNonZero        = false;
bool g_bbMiddleNonZero       = false;
bool g_bbLowerNonZero        = false;
bool g_supportNonZero        = false;
bool g_resistanceNonZero     = false;
bool g_summaryPrinted        = false;

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
   Log("=== TestAnalysisPipeline Init ===");

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

   //--- Wire full engine (all modules including BollingerBands and SRDetector)
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetBollingerBands(GetPointer(g_bollingerBands));
   g_engine.SetAnalysis(GetPointer(g_srDetector));
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   //------------------------------------------------------------------
   // ENGINE INITIALIZATION — no static tests, all assertions are live
   //------------------------------------------------------------------
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Collecting full pipeline data...");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tickCount++;

   // Run the full engine update; capture success
   bool updateOk = g_engine.Update();
   if(updateOk && !g_engineUpdateOk)
   {
      g_engineUpdateOk = true;
      Log(StringFormat("[INFO] Engine.Update() returned true on tick %d", g_tickCount));
   }

   CMarketSnapshot   *market   = g_context.Snapshot();
   CAnalysisSnapshot *analysis = g_context.AnalysisSnapshot();

   if(market == NULL || analysis == NULL)
   {
      Log("[FAIL] Snapshot() or AnalysisSnapshot() returned NULL");
      return;
   }

   //--- Market snapshot readiness
   if(market.IsReady && !g_marketIsReady)
   {
      g_marketIsReady = true;
      Log(StringFormat("[INFO] CMarketSnapshot.IsReady became true on tick %d", g_tickCount));
   }

   //--- Analysis snapshot readiness
   if(analysis.IsReady && !g_analysisIsReady)
   {
      g_analysisIsReady = true;
      Log(StringFormat("[INFO] CAnalysisSnapshot.IsReady became true on tick %d", g_tickCount));
   }

   //--- Gating contract: Analysis.IsReady must never be true when Market.IsReady is false
   if(analysis.IsReady && !market.IsReady && !g_gatingViolation)
   {
      g_gatingViolation = true;
      Log(StringFormat("[FAIL] Gating violation on tick %d — Analysis.IsReady true while Market.IsReady false",
                       g_tickCount));
   }

   //--- Bollinger Band field checks
   if(!g_bbUpperNonZero && market.BBUpper > 0.0)
   {
      g_bbUpperNonZero = true;
      Log(StringFormat("[INFO] BBUpper non-zero on tick %d (%.5f)", g_tickCount, market.BBUpper));
   }
   if(!g_bbMiddleNonZero && market.BBMiddle > 0.0)
   {
      g_bbMiddleNonZero = true;
      Log(StringFormat("[INFO] BBMiddle non-zero on tick %d (%.5f)", g_tickCount, market.BBMiddle));
   }
   if(!g_bbLowerNonZero && market.BBLower > 0.0)
   {
      g_bbLowerNonZero = true;
      Log(StringFormat("[INFO] BBLower non-zero on tick %d (%.5f)", g_tickCount, market.BBLower));
   }

   //--- Support / Resistance field checks
   if(!g_supportNonZero && analysis.SupportLevel > 0.0)
   {
      g_supportNonZero = true;
      Log(StringFormat("[INFO] SupportLevel non-zero on tick %d (%.5f)", g_tickCount, analysis.SupportLevel));
   }
   if(!g_resistanceNonZero && analysis.ResistanceLevel > 0.0)
   {
      g_resistanceNonZero = true;
      Log(StringFormat("[INFO] ResistanceLevel non-zero on tick %d (%.5f)", g_tickCount, analysis.ResistanceLevel));
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
      // LIVE TESTS — all 10 assertions based on accumulated state
      //----------------------------------------------------------------
      CTestFramework::Reset();
      CTestFramework::PrintHeader("Analysis Pipeline — Live Checks");

      // T1 — Engine.Update() returned true at least once
      CTestFramework::AssertTrue(
         g_engineUpdateOk,
         "T1: Engine.Update() returned true at least once");

      // T2 — CMarketSnapshot.IsReady became true at least once
      CTestFramework::AssertTrue(
         g_marketIsReady,
         "T2: CMarketSnapshot.IsReady became true at least once");

      // T3 — CAnalysisSnapshot.IsReady became true at least once
      CTestFramework::AssertTrue(
         g_analysisIsReady,
         "T3: CAnalysisSnapshot.IsReady became true at least once");

      // T4 — Gating contract: Analysis.IsReady never true when Market.IsReady false
      CTestFramework::AssertFalse(
         g_gatingViolation,
         "T4: Gating contract — Analysis.IsReady never true when Market.IsReady false");

      // T5 — Snapshot BBUpper was non-zero at least once
      CTestFramework::AssertTrue(
         g_bbUpperNonZero,
         "T5: Snapshot BBUpper was non-zero at least once");

      // T6 — Snapshot BBMiddle was non-zero at least once
      CTestFramework::AssertTrue(
         g_bbMiddleNonZero,
         "T6: Snapshot BBMiddle was non-zero at least once");

      // T7 — Snapshot BBLower was non-zero at least once
      CTestFramework::AssertTrue(
         g_bbLowerNonZero,
         "T7: Snapshot BBLower was non-zero at least once");

      // T8 — SupportLevel was non-zero at least once
      CTestFramework::AssertTrue(
         g_supportNonZero,
         "T8: SupportLevel was non-zero at least once");

      // T9 — ResistanceLevel was non-zero at least once
      CTestFramework::AssertTrue(
         g_resistanceNonZero,
         "T9: ResistanceLevel was non-zero at least once");

      // T10 — Total tick count ≥ 50 (warmup threshold)
      CTestFramework::AssertTrue(
         g_tickCount >= 50,
         "T10: Tick count >= 50");

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