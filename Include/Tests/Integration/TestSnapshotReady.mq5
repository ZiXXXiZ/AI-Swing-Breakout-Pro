//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Tests/Integration                                      |
//| File    : TestSnapshotReady.mq5                                  |
//| Purpose : Verifies CMarketSnapshot.IsReady transitions to true   |
//|           after indicator warmup in the Strategy Tester.         |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.10                                         |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

#include "../Framework/TestFramework.mqh"
#include "../../Framework/Engine.mqh"
#include "../../Core/Logging/DefaultLogFormatter.mqh"
#include "../../Core/Logging/JournalLogOutput.mqh"

//------------------------------------------------------------------
// Global objects
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
bool   g_snapshotPassed    = false;
int    g_snapshotReadyBar  = 0;
bool   g_snapshotFlickered = false;
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
   Log("=== TestSnapshotReady Init ===");

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

   // Initialize engine
   if(!g_engine.Initialize(GetPointer(g_context)))
   {
      Log("FAILED - Engine.Initialize()");
      return INIT_FAILED;
   }

   Log("Engine initialized. Starting ticks...");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_tickCount++;

   // Run full pipeline
   g_engine.Update();

   // Check snapshot readiness
   CMarketSnapshot* snap = g_context.Snapshot();
   if(snap != NULL)
   {
      if(snap.IsReady)
      {
         if(!g_snapshotPassed)
         {
            // First time becoming ready
            g_snapshotPassed = true;
            g_snapshotReadyBar = g_tickCount;
            Log(StringFormat("[PASS] Snapshot.IsReady = true on tick %d", g_tickCount));
         }
         // else: stays true – no flicker test later
      }
      else
      {
         if(g_snapshotPassed)
         {
            // It was ready, now false – flicker
            g_snapshotFlickered = true;
            Log("[FAIL] Snapshot.IsReady flickered to false after being true");
         }
      }
   }
   else
   {
      Log("[FAIL] Snapshot() returned NULL");
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
      PrintFormat("  Snapshot ready:  %s", g_snapshotPassed ? "PASS" : "FAIL");
      if(g_snapshotPassed)
         PrintFormat("  Ready on bar:    %d", g_snapshotReadyBar);
      PrintFormat("  Flicker test:    %s", g_snapshotFlickered ? "FAIL" : "PASS");

      int passed = 0, failed = 0;
      if(g_snapshotPassed)
         passed++;
      else
         failed++;
      if(!g_snapshotFlickered)
         passed++;
      else
         failed++;

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