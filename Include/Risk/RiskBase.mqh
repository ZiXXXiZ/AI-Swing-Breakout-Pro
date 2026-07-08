//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Risk                                                   |
//| File    : RiskBase.mqh                                           |
//| Purpose : Abstract base class for all risk evaluation modules.   |
//|           Provides a common interface for trade approval and     |
//|           position sizing.                                       |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_RISK_RISKBASE_MQH
#define AI_SWINGBREAKOUT_RISK_RISKBASE_MQH

#include "../Framework/Module.mqh"
#include "../Signals/SignalResult.mqh"
#include "RiskResult.mqh"

//+------------------------------------------------------------------+
//| Class CRiskBase                                                  |
//| Description:                                                     |
//|   Abstract base for all risk modules. Inherits CContext injection|
//|   from CModule. Concrete risk implementations MUST override      |
//|   Calculate() — it is pure virtual, consistent with the          |
//|   CreateHandle() pattern in CIndicatorBase.                      |
//+------------------------------------------------------------------+
class CRiskBase : public CModule
{
public:
   CRiskBase(const string name = "CRiskBase")
      : CModule(name)
   {
   }

   //--------------------------------------------------------------
   // Initialize
   //--------------------------------------------------------------
   virtual bool Initialize(CContext *context) override
   {
      return CModule::Initialize(context);
   }

   //--------------------------------------------------------------
   // Calculate (pure virtual)
   // Must be implemented by every concrete risk module.
   //--------------------------------------------------------------
   virtual SRiskResult Calculate(const SSignalResult &signal) const = 0;

   //--------------------------------------------------------------
   // IsTradeAllowed
   // Quick check without evaluating a signal. Base returns false;
   // subclasses override with platform/account/time checks.
   //--------------------------------------------------------------
   virtual bool IsTradeAllowed() const
   {
      return false;
   }
};

#endif // AI_SWINGBREAKOUT_RISK_RISKBASE_MQH