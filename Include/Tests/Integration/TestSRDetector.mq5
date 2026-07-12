//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestSRDetector.mq5                                     |
//| Purpose : Validates CSRDetector analysis module: static readiness,|
//|           live CAnalysisSnapshot population, level order, and     |
//|           gating contract with CMarketSnapshot.                   |
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
//| Global objects (SRDetector requires BollingerBands)              |
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
CSRDetector          g_srDetector;             // test target
CBreakoutSignal      g_signal;
CRiskManager         g_risk;
CTradeExecutor       g_executor;
CPositionTracker     g_tracker;

CDefaultLogFormatter *g_formatter = NULL;
CJournalLogOutput    *g_output    = NULL;

//+------------------------------------------------------------------+
//| Live test state                                                  |
//+------------------------------------------------------------------+
int  g_tickCount           = 0;
bool g_analysisReadyEver   = false;
bool g_supportNonZero      = false;
bool g_resistanceNonZero   = false;
bool g_levelOrderViolation = false;   // true if ResistanceLevel <= SupportLevel when both >0
bool g_gatingViolation     = false;   // true if CAnalysisSnapshot.IsReady while CMarketSnapshot.IsReady false
bool g_summaryPrinted      = false;

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
   Log("=== TestSRDetector Init ===");

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

   //--- Wire engine (BollingerBands required for SRDetector)
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetBollingerBands(GetPointer(g_bollingerBands));
   g_engine.SetAnalysis(GetPointer(g_srDetector));   // test target
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   //------------------------------------------------------------------
   // STATIC TEST — before engine initialization
   //------------------------------------------------------------------
   CTestFramework::Reset();
   CTestFramework::PrintHeader("CSRDetector");

   // T1 — CAnalysisSnapshot.IsReady false before initialization
   CAnalysisSnapshot *analysis = g_context.AnalysisSnapshot();
   CTestFramework::AssertFalse(
      analysis != NULL && analysis.IsReady,
      "T1: CAnalysisSnapshot.IsReady false before engine init");

   //------------------------------------------------------------------
   // ENGINE INITIALIZATION
   //------------------------------------------------------------------
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Collecting live SR data...");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tickCount++;

   g_engine.Update();

   CMarketSnapshot   *market   = g_context.Snapshot();
   CAnalysisSnapshot *analysis = g_context.AnalysisSnapshot();

   if(market == NULL || analysis == NULL)
   {
      Log("[FAIL] Snapshot() or AnalysisSnapshot() returned NULL");
      return;
   }

   //--- Track first time CAnalysisSnapshot.IsReady becomes true
   if(analysis.IsReady && !g_analysisReadyEver)
   {
      g_analysisReadyEver = true;
      Log(StringFormat("[INFO] CAnalysisSnapshot.IsReady became true on tick %d", g_tickCount));
   }

   //--- Track non-zero support/resistance levels
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

   //--- Level order invariant: ResistanceLevel must be > SupportLevel when both > 0
   if(analysis.ResistanceLevel > 0.0 && analysis.SupportLevel > 0.0 &&
      analysis.ResistanceLevel <= analysis.SupportLevel)
   {
      if(!g_levelOrderViolation)
      {
         g_levelOrderViolation = true;
         Log(StringFormat("[FAIL] Level order violation on tick %d — Resistance=%.5f, Support=%.5f",
                          g_tickCount, analysis.ResistanceLevel, analysis.SupportLevel));
      }
   }

   //--- Gating contract: CAnalysisSnapshot.IsReady must never be true when CMarketSnapshot.IsReady is false
   if(analysis.IsReady && !market.IsReady)
   {
      if(!g_gatingViolation)
      {
         g_gatingViolation = true;
         Log(StringFormat("[FAIL] Gating violation on tick %d — Analysis.IsReady true while Market.IsReady false",
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
      // LIVE TESTS — asserted after tick accumulation
      //----------------------------------------------------------------
      CTestFramework::PrintHeader("CSRDetector — Live Checks");

      // T2 — CAnalysisSnapshot.IsReady became true at least once
      CTestFramework::AssertTrue(
         g_analysisReadyEver,
         "T2: CAnalysisSnapshot.IsReady became true at least once");

      // T3 — SupportLevel was non-zero at least once
      CTestFramework::AssertTrue(
         g_supportNonZero,
         "T3: SupportLevel was non-zero at least once");

      // T4 — ResistanceLevel was non-zero at least once
      CTestFramework::AssertTrue(
         g_resistanceNonZero,
         "T4: ResistanceLevel was non-zero at least once");

      // T5 — ResistanceLevel always > SupportLevel when both non-zero
      CTestFramework::AssertFalse(
         g_levelOrderViolation,
         "T5: Level order — ResistanceLevel always > SupportLevel when both non-zero");

      // T6 — CAnalysisSnapshot.IsReady never true when CMarketSnapshot.IsReady false
      CTestFramework::AssertFalse(
         g_gatingViolation,
         "T6: Gating contract — Analysis.IsReady never true when Market.IsReady false");

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