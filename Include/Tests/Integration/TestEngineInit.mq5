//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestEngineInit.mq5                                     |
//| Purpose : Integration test — Engine wires and initialises all    |
//|           sub-modules without null pointer crash. Verifies       |
//|           IsInitialized() is consistent with Initialize() return.|
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.10                                         |
//+------------------------------------------------------------------+
#property script_show_inputs false

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//--- Forward declarations
void Test_ValidContextAllSubModules();
void Test_NoSubModulesWired();
void Test_InvalidContext();

//+------------------------------------------------------------------+
//| Script entry point                                               |
//+------------------------------------------------------------------+
void OnStart()
{
   CTestFramework::Reset();
   CTestFramework::PrintHeader("CEngine — Initialization");

   Test_ValidContextAllSubModules();
   Test_NoSubModulesWired();
   Test_InvalidContext();

   CTestFramework::PrintSummary();
   Sleep(500);   // flush Journal output before script unloads
}

//+------------------------------------------------------------------+
//| Test 1 — Valid context, all sub-modules wired                    |
//| Expected: Initialize returns true, all modules IsInitialized     |
//+------------------------------------------------------------------+
void Test_ValidContextAllSubModules()
{
   CPlatform            platform;
   CDefaultLogFormatter formatter;
   CJournalLogOutput    output;
   CLogger              logger;
   CErrorHandler        errorHandler;
   CContext             context;

   platform.Initialize();
   logger.Configure(GetPointer(formatter), GetPointer(output));

   context.SetPlatform(GetPointer(platform));
   context.SetLogger(GetPointer(logger));
   context.SetErrorHandler(GetPointer(errorHandler));

   CEMAIndicator    ema(10, 50, PERIOD_CURRENT);
   CATRIndicator    atr(14, PERIOD_CURRENT);
   CADXIndicator    adx(14, PERIOD_CURRENT);
   CBreakoutSignal  signal;
   CRiskManager     risk;
   CPositionTracker tracker;
   CTradeExecutor   executor;
   CEngine          engine;

   engine.SetIndicators(GetPointer(ema), GetPointer(atr), GetPointer(adx));
   engine.SetSignal(GetPointer(signal));
   engine.SetRisk(GetPointer(risk));
   engine.SetPositionTracker(GetPointer(tracker));
   engine.SetExecutor(GetPointer(executor));

   bool initResult = engine.Initialize(GetPointer(context));

   CTestFramework::AssertTrue(initResult,               "T1: Engine.Initialize returns true");
   CTestFramework::AssertTrue(engine.IsInitialized(),   "T1: Engine.IsInitialized is true");
   CTestFramework::AssertTrue(ema.IsInitialized(),      "T1: EMAIndicator.IsInitialized");
   CTestFramework::AssertTrue(atr.IsInitialized(),      "T1: ATRIndicator.IsInitialized");
   CTestFramework::AssertTrue(adx.IsInitialized(),      "T1: ADXIndicator.IsInitialized");
   CTestFramework::AssertTrue(signal.IsInitialized(),   "T1: BreakoutSignal.IsInitialized");
   CTestFramework::AssertTrue(risk.IsInitialized(),     "T1: RiskManager.IsInitialized");
   CTestFramework::AssertTrue(tracker.IsInitialized(),  "T1: PositionTracker.IsInitialized");
   CTestFramework::AssertTrue(executor.IsInitialized(), "T1: TradeExecutor.IsInitialized");

   engine.Shutdown();
}

//+------------------------------------------------------------------+
//| Test 2 — Valid context, no sub-modules wired                     |
//| Expected: Initialize returns false, IsInitialized is false       |
//+------------------------------------------------------------------+
void Test_NoSubModulesWired()
{
   CPlatform            platform;
   CDefaultLogFormatter formatter;
   CJournalLogOutput    output;
   CLogger              logger;
   CErrorHandler        errorHandler;
   CContext             context;

   platform.Initialize();
   logger.Configure(GetPointer(formatter), GetPointer(output));

   context.SetPlatform(GetPointer(platform));
   context.SetLogger(GetPointer(logger));
   context.SetErrorHandler(GetPointer(errorHandler));

   CEngine engine;   // no sub-modules wired

   bool initResult = engine.Initialize(GetPointer(context));

   CTestFramework::AssertFalse(initResult,             "T2: Engine.Initialize returns false");
   CTestFramework::AssertFalse(engine.IsInitialized(), "T2: Engine.IsInitialized is false");
}

//+------------------------------------------------------------------+
//| Test 3 — Invalid context (no services wired)                     |
//| Expected: Initialize returns false, IsInitialized is false       |
//+------------------------------------------------------------------+
void Test_InvalidContext()
{
   CContext emptyContext;   // no Platform / Logger / ErrorHandler

   CEMAIndicator    ema(10, 50, PERIOD_CURRENT);
   CATRIndicator    atr(14, PERIOD_CURRENT);
   CADXIndicator    adx(14, PERIOD_CURRENT);
   CBreakoutSignal  signal;
   CRiskManager     risk;
   CPositionTracker tracker;
   CTradeExecutor   executor;
   CEngine          engine;

   engine.SetIndicators(GetPointer(ema), GetPointer(atr), GetPointer(adx));
   engine.SetSignal(GetPointer(signal));
   engine.SetRisk(GetPointer(risk));
   engine.SetPositionTracker(GetPointer(tracker));
   engine.SetExecutor(GetPointer(executor));

   bool initResult = engine.Initialize(GetPointer(emptyContext));

   CTestFramework::AssertFalse(initResult,             "T3: Engine.Initialize returns false");
   CTestFramework::AssertFalse(engine.IsInitialized(), "T3: Engine.IsInitialized is false");
}