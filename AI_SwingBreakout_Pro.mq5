//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| File    : AI_SwingBreakout_Pro.mq5                               |
//| Purpose : Composition Root — Stage 7: Full pipeline wired with   |
//|           MarketDataProvider for centralized data acquisition.   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
//| Verified interfaces (read from actual source before writing):    |
//|                                                                  |
//| CPlatform                                                        |
//|   Initialize()       → bool                                      |
//|   Shutdown()         → void                                      |
//|   TerminalName()     → string                                    |
//|   TerminalBuild()    → long                                      |
//|   IsTradeAllowed()   → bool                                      |
//|   Balance()          → double                                    |
//|   IsDemo()           → bool                                      |
//|   IsTester()         → bool                                      |
//|   ProjectName()      → string                                    |
//|   Version()          → string                                    |
//|   Build()            → int                                       |
//|                                                                  |
//| CLogger                                                          |
//|   Configure(ILogFormatter*, ILogOutput*) → bool                  |
//|   Shutdown()         → void                                      |
//|   IsInitialized()    → bool                                      |
//|   NOTE: NO Initialize() — use Configure() only                   |
//|                                                                  |
//| CErrorHandler                                                    |
//|   Clear()            → void                                      |
//|   SetError(...)      → void                                      |
//|   HasError()         → bool                                      |
//|   GetLastError()     → SErrorInfo                                |
//|   NOTE: NO Initialize() or Shutdown()                            |
//|                                                                  |
//| CContext                                                         |
//|   SetPlatform(CPlatform*)          → void                        |
//|   SetLogger(CLogger*)              → void                        |
//|   SetErrorHandler(CErrorHandler*)  → void                        |
//|   IsValid()                        → bool                        |
//|   Snapshot()                       → CMarketSnapshot*            |
//|                                                                  |
//| CModuleManager                                                   |
//|   SetContext(CContext*)  → void                                   |
//|   Register(CModule*)     → bool                                   |
//|   Initialize()           → bool                                   |
//|   Update()               → void                                   |
//|   Shutdown()             → void                                   |
//|   Count()                → int                                    |
//|                                                                  |
//| CEngine                                                          |
//|   SetMarketData(CMarketDataProvider*) → void                      |
//|   SetIndicators(CEMAIndicator*, CATRIndicator*, CADXIndicator*)  |
//|                           → void                                  |
//|   SetSignal(CBreakoutSignal*)  → void                             |
//|   SetRisk(CRiskManager*)       → void                             |
//|   SetPositionTracker(CPositionTracker*) → void                    |
//|   SetExecutor(CTradeExecutor*) → void                             |
//|   Initialize(CContext*)        → bool                             |
//|   Update()                     → bool                             |
//|   Shutdown()                   → void                             |
//|   Context()                    → const CContext*                  |
//|   IsInitialized()              → bool                             |
//|                                                                  |
//| CMarketDataProvider(fastEma, slowEma, atrPeriod, adxPeriod, tf)  |
//|   Initialize(CContext*) → bool                                    |
//|   Update()              → bool                                    |
//|   Shutdown()            → void                                    |
//|                                                                  |
//| CEMAIndicator()                                                  |
//|   Initialize(CContext*) → bool                                    |
//|   Update()              → bool                                    |
//|   Shutdown()            → void                                    |
//|   IsReady()             → bool                                    |
//|                                                                  |
//| CATRIndicator()                                                  |
//|   Initialize(CContext*) → bool                                    |
//|   Update()              → bool                                    |
//|   Shutdown()            → void                                    |
//|   IsReady()             → bool                                    |
//|                                                                  |
//| CADXIndicator()                                                  |
//|   Initialize(CContext*) → bool                                    |
//|   Update()              → bool                                    |
//|   Shutdown()            → void                                    |
//|   IsReady()             → bool                                    |
//|                                                                  |
//| CBreakoutSignal()                                                |
//|   Initialize(CContext*) → bool                                    |
//|   Update()              → bool                                    |
//|   GetResult()           → SSignalResult                           |
//|                                                                  |
//| CRiskManager()                                                   |
//|   Initialize(CContext*) → bool                                    |
//|   Calculate(SSignalResult&) → SRiskResult                         |
//|   IsTradeAllowed()      → bool                                    |
//|                                                                  |
//| CTradeExecutor()                                                 |
//|   Initialize(CContext*)                    → bool                 |
//|   Execute(SSignalResult&, SRiskResult&)    → STradeResult         |
//|   Shutdown()                               → void                 |
//|                                                                  |
//| CPositionTracker()                                               |
//|   Initialize(CContext*)   → bool                                  |
//|   HasActivePosition()     → bool (const)                          |
//|   Shutdown()              → void                                  |
//+------------------------------------------------------------------+
#property copyright "ZiXXXiZ"
#property version   "2.00"

//------------------------------------------------------------------
// Core includes
//------------------------------------------------------------------
#include "Include/Core/Platform.mqh"
#include "Include/Core/Logging/Logger.mqh"
#include "Include/Core/Logging/DefaultLogFormatter.mqh"
#include "Include/Core/Logging/JournalLogOutput.mqh"
#include "Include/Core/Error/ErrorHandler.mqh"

//------------------------------------------------------------------
// Framework includes
//------------------------------------------------------------------
#include "Include/Framework/Context.mqh"
#include "Include/Framework/ModuleManager.mqh"
#include "Include/Framework/Engine.mqh"

//------------------------------------------------------------------
// Market Data
//------------------------------------------------------------------
#include "Include/MarketData/MarketDataProvider.mqh"

//------------------------------------------------------------------
// Indicator / Signal / Risk includes
//------------------------------------------------------------------
#include "Include/Indicators/EMAIndicator.mqh"
#include "Include/Indicators/ATRIndicator.mqh"
#include "Include/Indicators/ADXIndicator.mqh"
#include "Include/Signals/BreakoutSignal.mqh"
#include "Include/Risk/RiskManager.mqh"

//------------------------------------------------------------------
// Trading includes
//------------------------------------------------------------------
#include "Include/Trading/TradeExecutor.mqh"
#include "Include/Trading/PositionTracker.mqh"

//------------------------------------------------------------------
// EA input parameters
//------------------------------------------------------------------
input int    InpFastEMA   = 10;    // Fast EMA period
input int    InpSlowEMA   = 50;    // Slow EMA period
input int    InpATRPeriod = 14;    // ATR period
input int    InpADXPeriod = 14;    // ADX period

//------------------------------------------------------------------
// Global objects
//------------------------------------------------------------------
CPlatform       g_platform;
CLogger         g_logger;
CErrorHandler   g_errorHandler;
CContext        g_context;
CModuleManager  g_manager;
CEngine         g_engine;

CMarketDataProvider g_marketData(InpFastEMA, InpSlowEMA, InpATRPeriod, InpADXPeriod, PERIOD_CURRENT);
CEMAIndicator       g_ema;
CATRIndicator       g_atr;
CADXIndicator       g_adx;
CBreakoutSignal     g_signal;
CRiskManager        g_risk;
CTradeExecutor      g_executor;
CPositionTracker    g_tracker;

CDefaultLogFormatter *g_formatter = NULL;
CJournalLogOutput    *g_output    = NULL;

//------------------------------------------------------------------
// Log helper
//------------------------------------------------------------------
void Log(const string msg)
{
   Print("[AISBP] ", msg);
}

//------------------------------------------------------------------
// Cleanup helper
//------------------------------------------------------------------
void InitFailedCleanup()
{
   g_manager.Shutdown();
   g_logger.Shutdown();
   g_platform.Shutdown();
   if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
   if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
}

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   Log("=== AI Swing Breakout Pro — Stage 7 Init ===");

   //---------------------------------------------------------------
   // Stage 1 — Platform
   //---------------------------------------------------------------
   if(!g_platform.Initialize())
   {
      Log("FAILED — Platform.Initialize()");
      return INIT_FAILED;
   }

   Log("OK — Platform: "
       + g_platform.TerminalName()
       + " Build " + IntegerToString(g_platform.TerminalBuild()));
   Log("     Balance: " + DoubleToString(g_platform.Balance(), 2));
   Log("     IsDemo: " + (g_platform.IsDemo() ? "Yes" : "No"));
   Log("     IsTester: " + (g_platform.IsTester() ? "Yes" : "No"));
   Log("     TradeAllowed: " + (g_platform.IsTradeAllowed() ? "Yes" : "No"));

   //---------------------------------------------------------------
   // Stage 2 — Logger
   //---------------------------------------------------------------
   g_formatter = new CDefaultLogFormatter();
   g_output    = new CJournalLogOutput();

   if(g_formatter == NULL || g_output == NULL)
   {
      Log("FAILED — Logger heap allocation");
      if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
      if(g_output    != NULL) { delete g_output;    g_output    = NULL; }
      g_platform.Shutdown();
      return INIT_FAILED;
   }

   if(!g_logger.Configure(g_formatter, g_output))
   {
      Log("FAILED — Logger.Configure()");
      delete g_formatter; g_formatter = NULL;
      delete g_output;    g_output    = NULL;
      g_platform.Shutdown();
      return INIT_FAILED;
   }

   Log("OK — Logger configured. IsInitialized: "
       + (g_logger.IsInitialized() ? "true" : "false"));

   //---------------------------------------------------------------
   // Stage 3 — ErrorHandler
   //---------------------------------------------------------------
   g_errorHandler.Clear();

   Log("OK — ErrorHandler ready. HasError: "
       + (g_errorHandler.HasError() ? "true" : "false"));

   //---------------------------------------------------------------
   // Stage 4 — Context
   //---------------------------------------------------------------
   g_context.SetPlatform(GetPointer(g_platform));
   g_context.SetLogger(GetPointer(g_logger));
   g_context.SetErrorHandler(GetPointer(g_errorHandler));

   if(!g_context.IsValid())
   {
      Log("FAILED — Context.IsValid()");
      g_logger.Shutdown();
      g_platform.Shutdown();
      delete g_formatter; g_formatter = NULL;
      delete g_output;    g_output    = NULL;
      return INIT_FAILED;
   }

   Log("OK — Context valid (Platform + Logger + ErrorHandler)");

   //---------------------------------------------------------------
   // Stage 5 — Wire Engine
   //---------------------------------------------------------------
   g_engine.SetMarketData(GetPointer(g_marketData));
   g_engine.SetIndicators(GetPointer(g_ema),
                          GetPointer(g_atr),
                          GetPointer(g_adx));
   g_engine.SetSignal(GetPointer(g_signal));
   g_engine.SetRisk(GetPointer(g_risk));
   g_engine.SetExecutor(GetPointer(g_executor));
   g_engine.SetPositionTracker(GetPointer(g_tracker));

   Log("OK — Engine wired (MarketData + EMA + ATR + ADX + Signal + Risk + Executor + Tracker)");

   //---------------------------------------------------------------
   // Stage 6 — ModuleManager + Register only CEngine
   //---------------------------------------------------------------
   g_manager.SetContext(GetPointer(g_context));

   if(!g_manager.Register(GetPointer(g_engine)))
   {
      Log("FAILED — Register(engine)");
      InitFailedCleanup();
      return INIT_FAILED;
   }

   Log("OK — Engine registered. Count: " + IntegerToString(g_manager.Count()));

   if(!g_manager.Initialize())
   {
      Log("FAILED — Manager.Initialize()");
      InitFailedCleanup();
      return INIT_FAILED;
   }

   Log("OK — Manager initialized.");
   Log("     Engine.IsInitialized: "
       + (g_engine.IsInitialized() ? "true" : "false"));

   // Signature-hiding guard
   if(g_engine.Context() == NULL)
   {
      Log("FAILED — Engine.Context() is NULL after Initialize()");
      InitFailedCleanup();
      return INIT_FAILED;
   }

   Log("OK — Engine.Context() valid");

   Log("=== Stage 7 Init Complete ===");
   Log("Framework: "
       + g_platform.ProjectName()
       + " v" + g_platform.Version()
       + " build " + IntegerToString(g_platform.Build()));

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
   g_manager.Update();
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Log("=== Stage 7 Deinit (reason=" + IntegerToString(reason) + ") ===");

   g_manager.Shutdown();
   Log("OK — Manager shutdown");

   g_errorHandler.Clear();
   Log("OK — ErrorHandler cleared");

   g_logger.Shutdown();
   g_platform.Shutdown();

   if(g_formatter != NULL) { delete g_formatter; g_formatter = NULL; }
   if(g_output    != NULL) { delete g_output;    g_output    = NULL; }

   Print("[AISBP] Stage 7 shutdown complete.");
}
//+------------------------------------------------------------------+