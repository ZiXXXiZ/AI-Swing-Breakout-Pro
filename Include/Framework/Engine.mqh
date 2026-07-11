//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Engine.mqh                                             |
//| Purpose : Top-level orchestration module with diagnostic prints   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH

#include "Module.mqh"
#include "Context.mqh"
#include "../MarketData/MarketDataProvider.mqh"      // Sprint 012 addition
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
   CEMAIndicator       *m_ema;
   CATRIndicator       *m_atr;
   CADXIndicator       *m_adx;
   CBreakoutSignal     *m_signal;
   CRiskManager        *m_risk;
   CPositionTracker    *m_tracker;
   CTradeExecutor      *m_executor;
   CMarketDataProvider *m_marketData;   // Sprint 012 addition

public:
   CEngine()
      : CModule("CEngine")
   {
      m_ema        = NULL;
      m_atr        = NULL;
      m_adx        = NULL;
      m_signal     = NULL;
      m_risk       = NULL;
      m_tracker    = NULL;
      m_executor   = NULL;
      m_marketData = NULL;               // Sprint 012 addition
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

   void SetMarketData(CMarketDataProvider *marketData)   // Sprint 012 addition
   {
      m_marketData = marketData;
   }

   //--------------------------------------------------------------
   // Initialize — fixed to avoid inconsistent initialized state
   //--------------------------------------------------------------
   virtual bool Initialize(CContext *context) override
   {
      if(context == NULL)      return false;
      if(!context.IsValid())   return false;
      m_context = context;

      if(m_ema        == NULL ||
         m_atr        == NULL ||
         m_adx        == NULL ||
         m_signal     == NULL ||
         m_risk       == NULL ||
         m_tracker    == NULL ||
         m_executor   == NULL ||
         m_marketData == NULL)   // Sprint 012 addition
         return false;

      // Order matters: market data must be initialized first so snapshot fields are available
      if(!m_marketData.Initialize(context)) return false;   // Sprint 012 addition
      if(!m_ema.Initialize(context))        return false;
      if(!m_atr.Initialize(context))        return false;
      if(!m_adx.Initialize(context))        return false;
      if(!m_signal.Initialize(context))     return false;
      if(!m_risk.Initialize(context))       return false;
      if(!m_tracker.Initialize(context))    return false;
      if(!m_executor.Initialize(context))   return false;

      return CBaseObject::Initialize();
   }

   //--------------------------------------------------------------
   // Update — the per‑tick pipeline (with diagnostics)
   //--------------------------------------------------------------
   virtual bool Update() override
   {
      if(!m_initialized)
         return false;

      // 0. Acquire raw market data (Sprint 012 addition)
      if(!m_marketData.Update())
         return false;

      // 1. Update all indicators (now read from snapshot)
      UpdateIndicators();

      // DIAG: Snapshot readiness — every 5 minutes in production
      {
         static datetime lastPrint = 0;
         if(TimeCurrent() - lastPrint > 300)
         {
            PrintFormat("[DIAG] Snapshot.IsReady: %s",
                        m_context.Snapshot().IsReady ? "YES" : "NO");
            lastPrint = TimeCurrent();
         }
      }

      // Primary Guard: Short-circuit if position already exists
      if(m_tracker != NULL && m_tracker.HasActivePosition())
         return true;

      // 2. Evaluate signal
      SSignalResult signal;
      if(!EvaluateSignal(signal))
         return false;

      // DIAG: Signal result — every 5 minutes
      {
         static datetime lastPrint = 0;
         if(TimeCurrent() - lastPrint > 300)
         {
            PrintFormat("[DIAG] Signal.IsValid: %s  Direction: %d  Probability: %.2f",
                        signal.IsValid ? "YES" : "NO",
                        signal.Direction,
                        signal.Probability);
            lastPrint = TimeCurrent();
         }
      }

      if(!signal.IsValid)
         return true;

      // 3. Evaluate risk
      SRiskResult risk;
      if(!EvaluateRisk(signal, risk))
         return false;

      // DIAG: Risk result — every 5 minutes
      {
         static datetime lastPrint = 0;
         if(TimeCurrent() - lastPrint > 300)
         {
            PrintFormat("[DIAG] Risk.IsAllowed: %s  LotSize: %.2f  SL dist: %.0f pts  TP dist: %.0f pts",
                        risk.IsAllowed ? "YES" : "NO",
                        risk.LotSize,
                        risk.StopLossDistance,
                        risk.TakeProfitDistance);
            lastPrint = TimeCurrent();
         }
      }

      if(!risk.IsAllowed)
         return true;

      // 4. Execute trade
      STradeResult trade;
      if(!EvaluateExecution(signal, risk, trade))
         return false;

      return true;
   }

   virtual void Shutdown() override
   {
      m_ema        = NULL;
      m_atr        = NULL;
      m_adx        = NULL;
      m_signal     = NULL;
      m_risk       = NULL;
      m_tracker    = NULL;
      m_executor   = NULL;
      m_marketData = NULL;   // Sprint 012 addition

      CModule::Shutdown();
   }

private:
   void UpdateIndicators()
   {
      bool emaOk = (m_ema != NULL) && m_ema.Update();
      bool atrOk = (m_atr != NULL) && m_atr.Update();
      bool adxOk = (m_adx != NULL) && m_adx.Update();

      if(m_context != NULL)
         m_context.Snapshot().IsReady = (emaOk && atrOk && adxOk);
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