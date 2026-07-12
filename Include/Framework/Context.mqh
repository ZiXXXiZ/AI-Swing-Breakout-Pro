//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Context.mqh                                            |
//| Purpose : Shared service locator — bundles Platform, Logger,     |
//|           ErrorHandler, and snapshots for injection into         |
//|           Framework modules.                                     |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
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

   // Bollinger Bands
   double          BBUpper;
   double          BBMiddle;
   double          BBLower;

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

      BBUpper        = 0.0;
      BBMiddle       = 0.0;
      BBLower        = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Class CAnalysisSnapshot                                          |
//| Description:                                                     |
//|   Dedicated container for derived analysis outputs (support/     |
//|   resistance levels, trend bias, etc.). Populated by the         |
//|   Analysis layer (CSRDetector) and read by Signal modules.       |
//|   Stored by value inside CContext — no heap allocation.          |
//|                                                                  |
//|   IsReady must be set true by CSRDetector after all calculations |
//|   are complete. Signal modules must check it before consuming    |
//|   any field.                                                     |
//+------------------------------------------------------------------+
class CAnalysisSnapshot
{
public:
   double   SupportLevel;
   double   ResistanceLevel;
   double   SupportStrength;
   double   ResistanceStrength;
   double   TrendBias;
   bool     IsReady;

   CAnalysisSnapshot()
   {
      SupportLevel      = 0.0;
      ResistanceLevel   = 0.0;
      SupportStrength   = 0.0;
      ResistanceStrength = 0.0;
      TrendBias         = 0.0;
      IsReady           = false;
   }
};

//+------------------------------------------------------------------+
//| Class CContext                                                   |
//| Description:                                                     |
//|   Non-owning bundle of shared services (Platform, Logger,        |
//|   ErrorHandler). Constructed and wired by the composition root   |
//|   (main EA), then injected into every CModule via Initialize().  |
//|   CContext does not create or delete the services it holds.      |
//|   Also owns the shared CMarketSnapshot and CAnalysisSnapshot     |
//|   by value, accessible via non‑const pointers for write access   |
//|   by the appropriate modules.                                    |
//+------------------------------------------------------------------+
class CContext
{
private:

   CPlatform           *m_platform;
   CLogger             *m_logger;
   CErrorHandler       *m_errorHandler;

   CMarketSnapshot      m_snapshot;
   CAnalysisSnapshot    m_analysisSnapshot;

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
   // or CAnalysisSnapshot::IsReady for that. IsValid() only confirms
   // the three shared services are wired (Platform / Logger /
   // ErrorHandler).
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

   //--------------------------------------------------------------
   // Analysis Snapshot
   // Returns a non-const pointer — the Analysis layer (CSRDetector)
   // needs write access to populate fields. Signal modules access
   // it via const CContext* and therefore cannot write through
   // this pointer, enforcing the read-only contract for consumers.
   //--------------------------------------------------------------

   CAnalysisSnapshot* AnalysisSnapshot()
   {
      return GetPointer(m_analysisSnapshot);
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH