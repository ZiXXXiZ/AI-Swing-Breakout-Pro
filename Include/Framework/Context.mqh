//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Context.mqh                                            |
//| Purpose : Shared service locator — bundles Platform, Logger, and |
//|           ErrorHandler for injection into Framework modules      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.11                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH

#include "../Core/Platform.mqh"
#include "../Core/Logging/Logger.mqh"
#include "../Core/Error/ErrorHandler.mqh"
#include "../Core/Types.mqh"

//+------------------------------------------------------------------+
//| Class CMarketSnapshot                                            |
//| Description:                                                     |
//|   Shared read/write buffer for all indicator output values.      |
//|   Indicators write into this class during Update(); Signal and   |
//|   Risk modules read from it via CContext::Snapshot().            |
//|   Stored by value inside CContext — no heap allocation.          |
//|                                                                  |
//|   Must be a class (not struct) — MQL5 does not support           |
//|   pointer-to-struct or reference return types, both of which     |
//|   are required to give Indicator modules write access through     |
//|   CContext. GetPointer() works on class instances only.          |
//|                                                                  |
//|   IsReady must be set true by the Indicator module only after    |
//|   every field has been populated for the current bar. Signal and |
//|   Risk modules must check IsReady before consuming any field.    |
//+------------------------------------------------------------------+
class CMarketSnapshot
{
public:

   // EMA
   double          FastEMA;
   double          SlowEMA;

   // ATR
   double          ATR;

   // ADX
   double          ADX;
   double          PlusDI;
   double          MinusDI;

   // Trend
   ETrendDirection TrendDirection;

   // Market conditions
   double          Spread;
   double          Volume;

   // Validity flags
   bool            DataReady;   // set true by CMarketDataProvider when all raw fields are populated
   bool            IsReady;     // set true by CEngine when all indicator business logic is complete

   CMarketSnapshot()
   {
      FastEMA        = 0.0;
      SlowEMA        = 0.0;
      ATR            = 0.0;
      ADX            = 0.0;
      PlusDI         = 0.0;
      MinusDI        = 0.0;
      TrendDirection = TREND_UNKNOWN;
      Spread         = 0.0;
      Volume         = 0.0;
      DataReady      = false;
      IsReady        = false;
   }
};

//+------------------------------------------------------------------+
//| Class CContext                                                   |
//| Description:                                                     |
//|   Non-owning bundle of shared services (Platform, Logger,        |
//|   ErrorHandler). Constructed and wired by the composition root   |
//|   (main EA), then injected into every CModule via Initialize().  |
//|   CContext does not create or delete the services it holds.      |
//|   Also owns the shared CMarketSnapshot written by Indicators     |
//|   and read by Signal and Risk modules each tick.                 |
//+------------------------------------------------------------------+
class CContext
{
private:

   CPlatform        *m_platform;
   CLogger          *m_logger;
   CErrorHandler    *m_errorHandler;

   CMarketSnapshot   m_snapshot;

public:

   CContext()
   {
      m_platform     = NULL;
      m_logger       = NULL;
      m_errorHandler = NULL;
   }

   //--------------------------------------------------------------
   // Setters (composition-root use only)
   //--------------------------------------------------------------

   void SetPlatform(CPlatform *platform)
   {
      m_platform = platform;
   }

   void SetLogger(CLogger *logger)
   {
      m_logger = logger;
   }

   void SetErrorHandler(CErrorHandler *handler)
   {
      m_errorHandler = handler;
   }

   //--------------------------------------------------------------
   // Getters
   // Marked const so CModule::Context() can safely return a
   // const CContext* — modules can use every service reachable
   // through these getters, but cannot call SetPlatform/SetLogger/
   // SetErrorHandler to rewire the shared context out from under
   // the rest of the framework.
   //--------------------------------------------------------------

   CPlatform* Platform() const
   {
      return m_platform;
   }

   CLogger* Logger() const
   {
      return m_logger;
   }

   CErrorHandler* ErrorHandler() const
   {
      return m_errorHandler;
   }

   //--------------------------------------------------------------
   // Validation
   // Does NOT check snapshot readiness — use CMarketSnapshot::IsReady
   // for that. IsValid() only confirms the three shared services are
   // wired (Platform / Logger / ErrorHandler).
   //--------------------------------------------------------------

   bool IsValid() const
   {
      return (m_platform != NULL &&
              m_logger != NULL &&
              m_errorHandler != NULL);
   }

   //--------------------------------------------------------------
   // Market Snapshot
   // Returns a non-const pointer via GetPointer() — Indicator modules
   // need write access to populate fields each tick. Signal and Risk
   // modules must check Snapshot().IsReady before reading any field.
   // CMarketSnapshot is a class (not struct) specifically because
   // MQL5 GetPointer() requires a class instance.
   //--------------------------------------------------------------

   CMarketSnapshot* Snapshot()
   {
      return GetPointer(m_snapshot);
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH