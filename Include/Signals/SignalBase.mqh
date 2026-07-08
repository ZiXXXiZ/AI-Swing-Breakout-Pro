//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Signals                                                |
//| File    : SignalBase.mqh                                         |
//| Purpose : Abstract base class for all signal modules.            |
//|           Owns an SSignalResult and provides a common Reset().   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_SIGNALS_SIGNALBASE_MQH
#define AI_SWINGBREAKOUT_SIGNALS_SIGNALBASE_MQH

#include "../Framework/Module.mqh"
#include "SignalResult.mqh"

//+------------------------------------------------------------------+
//| Class CSignalBase                                                |
//| Description:                                                     |
//|   Abstract base for all signal modules. Inherits CContext        |
//|   injection from CModule. Owns the signal result struct and      |
//|   provides a standard Reset() that clears it back to default.    |
//|   Concrete signal implementations override Update() to read      |
//|   from the market snapshot and populate m_result.                |
//+------------------------------------------------------------------+
class CSignalBase : public CModule
{
protected:
   SSignalResult m_result;

public:
   CSignalBase(const string name = "CSignalBase")
      : CModule(name)
   {
   }

   //--------------------------------------------------------------
   // Initialize
   // Chains to CModule::Initialize(context)
   //--------------------------------------------------------------
   virtual bool Initialize(CContext *context) override
   {
      return CModule::Initialize(context);
   }

   //--------------------------------------------------------------
   // Update
   // Base implementation — subclasses override to evaluate the
   // market snapshot and fill m_result. Default returns the
   // module's initialized state.
   //--------------------------------------------------------------
   virtual bool Update() override
   {
      return CModule::Update();
   }

   //--------------------------------------------------------------
   // GetResult
   // Returns a copy of the last signal evaluation.
   //--------------------------------------------------------------
   virtual SSignalResult GetResult() const
   {
      return m_result;
   }

   //--------------------------------------------------------------
   // Reset
   // Clears m_result back to default-constructed state.
   //--------------------------------------------------------------
   virtual void Reset() override
   {
      m_result = SSignalResult();
   }
};

#endif // AI_SWINGBREAKOUT_SIGNALS_SIGNALBASE_MQH