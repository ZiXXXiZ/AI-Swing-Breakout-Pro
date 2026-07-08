//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : IndicatorBase.mqh                                      |
//| Purpose : Abstract base class for all indicator modules.         |
//|           Owns the indicator handle lifecycle (create/release)   |
//|           and provides a common IsReady() check. Each subclass   |
//|           implements CreateHandle() for its own indicator type.  |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_INDICATORBASE_MQH
#define AI_SWINGBREAKOUT_INDICATORS_INDICATORBASE_MQH

#include "../Framework/Module.mqh"
#include "../Framework/Context.mqh"

//+------------------------------------------------------------------+
//| Class CIndicatorBase                                             |
//| Description:                                                     |
//|   Abstract base for every indicator module. Inherits CContext    |
//|   injection from CModule. Owns m_handle — creates it via the     |
//|   pure-virtual CreateHandle() on Initialize(), releases it on    |
//|   Shutdown(). Subclasses must not manage the handle themselves.  |
//|                                                                  |
//|   m_period is intentionally absent from this base — each         |
//|   subclass owns its own period member(s), because indicator      |
//|   period semantics differ (EMA has one period; ADX has one but   |
//|   produces three buffers; future indicators may have several).   |
//+------------------------------------------------------------------+
class CIndicatorBase : public CModule
{
protected:

   int             m_handle;
   string          m_symbol;
   ENUM_TIMEFRAMES m_timeframe;

public:

   CIndicatorBase(const string name, const ENUM_TIMEFRAMES timeframe)
      : CModule(name)
   {
      m_handle    = INVALID_HANDLE;
      m_symbol    = "";
      m_timeframe = timeframe;
   }

   //--------------------------------------------------------------
   // Initialize
   // 1. Chain to CModule::Initialize(context) — stores m_context,
   //    sets m_initialized via CBaseObject::Initialize().
   // 2. Read symbol from terminal.
   // 3. Call CreateHandle() — pure virtual, subclass-specific.
   // 4. Roll back via CModule::Shutdown() and return false if
   //    handle creation fails.
   //--------------------------------------------------------------
   virtual bool Initialize(CContext *context) override
   {
      if(!CModule::Initialize(context))
         return false;

      m_symbol = _Symbol;

      if(!CreateHandle())
      {
         CModule::Shutdown();
         return false;
      }

      if(m_handle == INVALID_HANDLE)
      {
         CModule::Shutdown();
         return false;
      }

      return true;
   }

   //--------------------------------------------------------------
   // Shutdown
   // Release handle before clearing base state.
   //--------------------------------------------------------------
   virtual void Shutdown() override
   {
      if(m_handle != INVALID_HANDLE)
      {
         IndicatorRelease(m_handle);
         m_handle = INVALID_HANDLE;
      }

      CModule::Shutdown();
   }

   //--------------------------------------------------------------
   // Update
   // Base implementation — subclasses override to copy buffer
   // values into CMarketSnapshot. Base returns false until the
   // handle is ready (guards against calling CopyBuffer too early).
   //--------------------------------------------------------------
   virtual bool Update() override
   {
      return IsReady();
   }

   //--------------------------------------------------------------
   // IsReady
   // True only when the handle exists and the indicator has
   // calculated at least one bar. Subclasses and CEngine both
   // use this to guard snapshot writes and reads.
   //--------------------------------------------------------------
   virtual bool IsReady() const
   {
      return (m_handle != INVALID_HANDLE && BarsCalculated(m_handle) > 0);
   }

protected:

   //--------------------------------------------------------------
   // CreateHandle (pure virtual)
   // Each subclass calls the appropriate iXxx() function and
   // assigns the result to m_handle. Must return false (not just
   // leave m_handle as INVALID_HANDLE) on failure so Initialize()
   // can distinguish a failed creation from a skipped one.
   //--------------------------------------------------------------
   virtual bool CreateHandle() = 0;
};

#endif // AI_SWINGBREAKOUT_INDICATORS_INDICATORBASE_MQH