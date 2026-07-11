//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestEngineInit.mq5                                     |
//| Purpose : Validates CEngine initialization with various wiring   |
//|           scenarios. Updated for Sprint 012 architecture.        |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../MarketData/MarketDataProvider.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//------------------------------------------------------------------
// Global test infrastructure (shared by all test functions)
//------------------------------------------------------------------
CPlatform           g_platform;
CLogger             g_logger;
CErrorHandler       g_errorHandler;
CContext            g_context;
CDefaultLogFormatter* g_formatter = NULL;
CJournalLogOutput*    g_output    = NULL;

bool g_allPassed = true;
int  g_testsPassed = 0;
int  g_testsFailed = 0;

//------------------------------------------------------------------
// Setup / Teardown helpers
//------------------------------------------------------------------
bool SetupContext()
{
   if(!g_platform.Initialize()) return false;

   g_formatter = new CDefaultLogFormatter();
   g_output    = new CJournalLogOutput();
   if(g_formatter == NULL || g_output == NULL) return false;
   if(!g_logger.Configure(g_formatter, g_output)) return false;

   g_errorHandler.Clear();

   g_context.SetPlatform(GetPointer(g_platform));
   g_context.SetLogger(GetPointer(g_logger));
   g_context.SetErrorHandler(GetPointer(g_errorHandler));
   return g_context.IsValid();
}

void TeardownContext()
{
   g_logger.Shutdown();
   g_platform.Shutdown();
   if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
   if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
}

void LogResult(const string testName, const bool passed)
{
   if(passed)
   {
      PrintFormat("[PASS] %s", testName);
      g_testsPassed++;
   }
   else
   {
      PrintFormat("[FAIL] %s", testName);
      g_testsFailed++;
      g_allPassed = false;
   }
}

//+------------------------------------------------------------------+
//| Test: Valid context, all sub-modules wired                        |
//+------------------------------------------------------------------+
void Test_ValidContextAllSubModules()
{
   Print("--- Test: All sub-modules wired ---");

   CMarketDataProvider marketData(10, 50, 14, 14, PERIOD_CURRENT);
   CEMAIndicator       ema;
   CATRIndicator       atr;
   CADXIndicator       adx;
   CBreakoutSignal     signal;
   CRiskManager        risk;
   CTradeExecutor      executor;
   CPositionTracker    tracker;
   CEngine             engine;

   engine.SetMarketData(GetPointer(marketData));
   engine.SetIndicators(GetPointer(ema), GetPointer(atr), GetPointer(adx));
   engine.SetSignal(GetPointer(signal));
   engine.SetRisk(GetPointer(risk));
   engine.SetExecutor(GetPointer(executor));
   engine.SetPositionTracker(GetPointer(tracker));

   bool result = engine.Initialize(GetPointer(g_context));
   LogResult("All sub-modules wired", result);
   engine.Shutdown();
}

//+------------------------------------------------------------------+
//| Test: No sub-modules wired (all NULL)                            |
//+------------------------------------------------------------------+
void Test_NoSubModulesWired()
{
   Print("--- Test: No sub-modules wired ---");

   CEngine engine;
   // No setters called – all members remain NULL
   bool result = engine.Initialize(GetPointer(g_context));
   // Should fail because NULL guard triggers
   LogResult("No sub-modules wired (should fail)", !result);
   engine.Shutdown();
}

//+------------------------------------------------------------------+
//| Test: Invalid context (NULL context)                             |
//+------------------------------------------------------------------+
void Test_InvalidContext()
{
   Print("--- Test: Invalid context ---");

   CMarketDataProvider marketData(10, 50, 14, 14, PERIOD_CURRENT);
   CEMAIndicator       ema;
   CATRIndicator       atr;
   CADXIndicator       adx;
   CBreakoutSignal     signal;
   CRiskManager        risk;
   CTradeExecutor      executor;
   CPositionTracker    tracker;
   CEngine             engine;

   engine.SetMarketData(GetPointer(marketData));
   engine.SetIndicators(GetPointer(ema), GetPointer(atr), GetPointer(adx));
   engine.SetSignal(GetPointer(signal));
   engine.SetRisk(GetPointer(risk));
   engine.SetExecutor(GetPointer(executor));
   engine.SetPositionTracker(GetPointer(tracker));

   // Pass NULL context
   bool result = engine.Initialize(NULL);
   LogResult("NULL context (should fail)", !result);
   engine.Shutdown();
}

//+------------------------------------------------------------------+
//| OnInit — run all tests                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("=== TestEngineInit (Sprint 012) ===");

   if(!SetupContext())
   {
      Print("[FAIL] Context setup failed");
      return INIT_FAILED;
   }

   Test_ValidContextAllSubModules();
   Test_NoSubModulesWired();
   Test_InvalidContext();

   TeardownContext();

   Print("==============================================");
   PrintFormat("Tests Passed: %d, Failed: %d", g_testsPassed, g_testsFailed);
   Print("==============================================");

   return (g_allPassed ? INIT_SUCCEEDED : INIT_FAILED);
}

//+------------------------------------------------------------------+
//| OnTick (not used)                                                |
//+------------------------------------------------------------------+
void OnTick() { return; }

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {}
//+------------------------------------------------------------------+