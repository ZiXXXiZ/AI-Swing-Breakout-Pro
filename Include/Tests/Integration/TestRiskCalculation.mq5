//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestRiskCalculation.mq5                                |
//| Purpose : Validates CRiskManager::Calculate() fallback logic and |
//|           distance ratio (1:2 risk/reward).                      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.10                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../Risk/RiskManager.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//------------------------------------------------------------------
// Global objects (same wiring as TestSnapshotReady)
//------------------------------------------------------------------
CPlatform           g_platform;
CLogger             g_logger;
CErrorHandler       g_errorHandler;
CContext            g_context;
CEngine             g_engine;

CEMAIndicator       g_ema(10, 50, PERIOD_CURRENT);
CATRIndicator       g_atr(14, PERIOD_CURRENT);
CADXIndicator       g_adx(14, PERIOD_CURRENT);
CBreakoutSignal     g_signal;
CRiskManager        g_risk;
CTradeExecutor      g_executor;
CPositionTracker    g_tracker;

CDefaultLogFormatter* g_formatter = NULL;
CJournalLogOutput*    g_output    = NULL;

//------------------------------------------------------------------
// Test state
//------------------------------------------------------------------
bool   g_tested           = false;
bool   g_isAllowedPassed  = false;
bool   g_lotSizePassed    = false;
bool   g_distanceRatioPassed = false;
int    g_tickCount         = 0;
bool   g_summaryPrinted    = false;

//------------------------------------------------------------------
// Log helper
//------------------------------------------------------------------
void Log(const string msg)
{
   Print("[TEST] ", msg);
}

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   Log("=== TestRiskCalculation Init ===");

   // Platform
   if(!g_platform.Initialize())
   {
      Log("FAILED - Platform.Initialize()");
      return INIT_FAILED;
   }

   // Logger
   g_formatter = new CDefaultLogFormatter();
   g_output    = new CJournalLogOutput();
   if(g_formatter == NULL || g_output == NULL)
   {
      Log("FAILED - Logger heap allocation");
      if(g_formatter != NULL) delete g_formatter;
      if(g_output    != NULL) delete g_output;
      return INIT_FAILED;
   }
   if(!g_logger.Configure(g_formatter, g_output))
   {
      Log("FAILED - Logger.Configure()");
      delete g_formatter; g_formatter = NULL;
      delete g_output;    g_output    = NULL;
      return INIT_FAILED;
   }

   // ErrorHandler – no Initialize
   g_errorHandler.Clear();

   // Context
   g_context.SetPlatform(GetPointer(g_platform));
   g_context.SetLogger(GetPointer(g_logger));
   g_context.SetErrorHandler(GetPointer(g_errorHandler));
   if(!g_context.IsValid())
   {
      Log("FAILED - Context.IsValid()");
      return INIT_FAILED;
   }

   // Wire engine
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetPositionTracker(GetPointer(g_tracker));
   g_engine.SetExecutor(GetPointer(g_executor));

   // Initialize engine (this initializes all sub-modules including g_risk)
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Waiting for first tick...");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tickCount++;

   // Run full pipeline (not strictly needed for this test, but keep consistent)
   g_engine.Update();

   // Run test once on first tick
   if(!g_tested)
   {
      g_tested = true;

      // Build a valid signal that should pass all checks
      SSignalResult signal;
      signal.IsValid     = true;
      signal.Direction   = TRADE_DIRECTION_BUY;  // 1 = BUY
      signal.Probability = 0.80;                 // well above default threshold 0.70

      // Call risk manager directly
      SRiskResult result = g_risk.Calculate(signal);

      // Check IsAllowed
      g_isAllowedPassed = result.IsAllowed;
      if(g_isAllowedPassed)
         Log("[PASS] IsAllowed = true");
      else
         Log(StringFormat("[FAIL] IsAllowed = false, Reason: %s", result.Reason));

      // Check LotSize > 0
      g_lotSizePassed = (result.LotSize > 0.0);
      if(g_lotSizePassed)
         Log(StringFormat("[PASS] LotSize > 0 (%.5f)", result.LotSize));
      else
         Log(StringFormat("[FAIL] LotSize = %.5f (expected > 0)", result.LotSize));

      // Check StopLossDistance > 0 and TP = 2 * SL
      double slDist = result.StopLossDistance;
      double tpDist = result.TakeProfitDistance;
      bool slPositive = (slDist > 0.0);
      bool tpDouble = (MathAbs(tpDist - slDist * 2.0) < 0.01); // 1:2 ratio with tolerance

      g_distanceRatioPassed = slPositive && tpDouble;
      if(g_distanceRatioPassed)
         Log(StringFormat("[PASS] SL dist=%.0f pts, TP dist=%.0f pts (1:2 ratio)", slDist, tpDist));
      else
      {
         if(!slPositive)
            Log(StringFormat("[FAIL] StopLossDistance = %.0f (expected > 0)", slDist));
         else
            Log(StringFormat("[FAIL] TP/SL ratio: SL=%.0f, TP=%.0f (expected TP = 2*SL)", slDist, tpDist));
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

      Print("==============================================");
      Print("[TEST] Test Summary");
      PrintFormat("  Ticks processed: %d", g_tickCount);
      PrintFormat("  IsAllowed:       %s", g_isAllowedPassed ? "PASS" : "FAIL");
      PrintFormat("  LotSize > 0:     %s", g_lotSizePassed ? "PASS" : "FAIL");
      PrintFormat("  Distance ratio:  %s", g_distanceRatioPassed ? "PASS" : "FAIL");

      int passed = 0, failed = 0;
      if(g_isAllowedPassed) passed++; else failed++;
      if(g_lotSizePassed)   passed++; else failed++;
      if(g_distanceRatioPassed) passed++; else failed++;

      PrintFormat("  Total Tests Passed: %d, Failed: %d", passed, failed);
      Print("==============================================");
   }

   // Shutdown in reverse order
   g_engine.Shutdown();
   g_logger.Shutdown();
   g_platform.Shutdown();

   if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
   if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
}
//+------------------------------------------------------------------+