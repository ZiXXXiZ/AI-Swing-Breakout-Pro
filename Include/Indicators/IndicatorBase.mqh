//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : IndicatorBase.mqh                                      |
//| Purpose : Abstract base class for all indicator modules.         |
//|           No longer owns indicator handles — data is read from   |
//|           the shared CMarketSnapshot (populated by               |
//|           CMarketDataProvider).                                   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_INDICATORBASE_MQH
#define AI_SWINGBREAKOUT_INDICATORS_INDICATORBASE_MQH

#include "../Framework/Module.mqh"
#include "../Framework/Context.mqh"

class CIndicatorBase : public CModule
{
public:
   CIndicatorBase(const string name)
      : CModule(name)
   {
   }

   virtual bool Initialize(CContext *context) override
   {
      return CModule::Initialize(context);
   }

   virtual bool Update() override
   {
      return IsReady();
   }

   virtual void Shutdown() override
   {
      CModule::Shutdown();
   }

   virtual bool IsReady() const
   {
      if(m_context == NULL) return false;
      CMarketSnapshot *snap = m_context.Snapshot();
      if(snap == NULL) return false;
      return snap.DataReady;
   }
};

#endif // AI_SWINGBREAKOUT_INDICATORS_INDICATORBASE_MQH