//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Engine.mqh                                             |
//| Purpose : Top-level orchestration module. Owns non-owning        |
//|           pointers to Indicators, Signal, and Risk modules,      |
//|           executing them in fixed sequence each tick.            |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH

#include "Module.mqh"
#include "Context.mqh"
#include "../Indicators/EMAIndicator.mqh"
#include "../Indicators/ATRIndicator.mqh"
#include "../Indicators/ADXIndicator.mqh"
#include "../Signals/BreakoutSignal.mqh"
#include "../Risk/RiskManager.mqh"

class CEngine : public CModule
{
private:
   CEMAIndicator   *m_ema;
   CATRIndicator   *m_atr;
   CADXIndicator   *m_adx;
   CBreakoutSignal *m_signal;
   CRiskManager    *m_risk;

public:
   CEngine()
      : CModule("CEngine")
   {
      m_ema    = NULL;
      m_atr    = NULL;
      m_adx    = NULL;
      m_signal = NULL;
      m_risk   = NULL;
   }

   void SetIndicators(CEMAIndicator *ema,
                      CATRIndicator *atr,
                      CADXIndicator *adx)
   {
      m_ema = ema;
      m_atr = atr;
      m_adx = adx;
   }

   void SetSignal(CBreakoutSignal *signal)
   {
      m_signal = signal;
   }

   void SetRisk(CRiskManager *risk)
   {
      m_risk = risk;
   }

   virtual bool Initialize(CContext *context) override
   {
      if(!CModule::Initialize(context))
         return false;

      if(m_ema    == NULL ||
         m_atr    == NULL ||
         m_adx    == NULL ||
         m_signal == NULL ||
         m_risk   == NULL)
         return false;

      return true;
   }

   //--------------------------------------------------------------
   // Update — the per‑tick pipeline
   //--------------------------------------------------------------
   virtual bool Update() override
   {
      if(!m_initialized)
         return false;

      // 1. Update all indicators (best-effort, no abort)
      UpdateIndicators();

      // 2. Evaluate signal (guards on snapshot.IsReady internally)
      SSignalResult signal;
      if(!EvaluateSignal(signal))
         return false;

      if(!signal.IsValid)
         return true;   // no actionable signal

      // 3. Evaluate risk
      SRiskResult risk;
      if(!EvaluateRisk(signal, risk))
         return false;

      if(!risk.IsAllowed)
         return true;   // rejected — not an error

      // 4. Execution placeholder (Stage 7)

      return true;
   }

   virtual void Shutdown() override
   {
      m_ema    = NULL;
      m_atr    = NULL;
      m_adx    = NULL;
      m_signal = NULL;
      m_risk   = NULL;

      CModule::Shutdown();
   }

private:
   //--------------------------------------------------------------
   // UpdateIndicators — runs all three; failures logged but not
   // propagated. Signal module will detect missing data via
   // snapshot.IsReady.
   //--------------------------------------------------------------
   void UpdateIndicators()
   {
      if(m_ema != NULL) m_ema.Update();
      if(m_atr != NULL) m_atr.Update();
      if(m_adx != NULL) m_adx.Update();
   }

   bool EvaluateSignal(SSignalResult &result)
   {
      if(m_signal == NULL) return false;
      if(!m_signal.Update()) return false;
      result = m_signal.GetResult();
      return true;
   }

   bool EvaluateRisk(const SSignalResult &signal, SRiskResult &result)
   {
      if(m_risk == NULL) return false;
      result = m_risk.Calculate(signal);
      return true;
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH