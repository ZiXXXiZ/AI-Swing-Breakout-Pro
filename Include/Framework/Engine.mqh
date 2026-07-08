//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Engine.mqh                                             |
//| Purpose : Top-level orchestration module. Owns non-owning        |
//|           pointers to Indicators, Signal, Risk, Tracker and     |
//|           Trade Executor modules, executing them in fixed        |
//|           sequence each tick.                                    |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.6                                          |
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
#include "../Trading/TradeExecutor.mqh"
#include "../Trading/PositionTracker.mqh"

class CEngine : public CModule
{
private:
   CEMAIndicator    *m_ema;
   CATRIndicator    *m_atr;
   CADXIndicator    *m_adx;
   CBreakoutSignal  *m_signal;
   CRiskManager     *m_risk;
   CPositionTracker *m_tracker;
   CTradeExecutor   *m_executor;

public:
   CEngine()
      : CModule("CEngine")
   {
      m_ema      = NULL;
      m_atr      = NULL;
      m_adx      = NULL;
      m_signal   = NULL;
      m_risk     = NULL;
      m_tracker  = NULL;
      m_executor = NULL;
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

   void SetPositionTracker(CPositionTracker *tracker)
   {
      m_tracker = tracker;
   }

   void SetExecutor(CTradeExecutor *executor)
   {
      m_executor = executor;
   }

   virtual bool Initialize(CContext *context) override
   {
      if(!CModule::Initialize(context))
         return false;

      if(m_ema      == NULL ||
         m_atr      == NULL ||
         m_adx      == NULL ||
         m_signal   == NULL ||
         m_risk     == NULL ||
         m_tracker  == NULL ||
         m_executor == NULL)
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

      // Primary Guard: Short-circuit if position already exists.
      // Keeps indicators updating to maintain continuity for trailing/metrics,
      // but prevents downstream execution logic from wasting processing cycle budget.
      if(m_tracker != NULL && m_tracker.HasActivePosition())
      {
         return true; // Valid early exit state, not a framework error.
      }

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

      // 4. Execute trade
      STradeResult trade;
      if(!EvaluateExecution(signal, risk, trade))
         return false;

      // Execution failure is not a pipeline error — the executor
      // already populated trade.Reason and trade.ErrorCode.
      return true;
   }

   virtual void Shutdown() override
   {
      m_ema      = NULL;
      m_atr      = NULL;
      m_adx      = NULL;
      m_signal   = NULL;
      m_risk     = NULL;
      m_tracker  = NULL;
      m_executor = NULL;

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

   //--------------------------------------------------------------
   // EvaluateExecution
   // No pre‑call guards — CTradeExecutor::Execute() handles
   // internal validation of signal.IsValid and risk.IsAllowed.
   //--------------------------------------------------------------
   bool EvaluateExecution(const SSignalResult &signal,
                          const SRiskResult   &risk,
                          STradeResult        &result)
   {
      if(m_executor == NULL)
         return false;

      result = m_executor.Execute(signal, risk);
      return true;
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH