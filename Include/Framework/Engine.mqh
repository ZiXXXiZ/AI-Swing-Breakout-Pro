//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Engine.mqh                                             |
//| Purpose : Top-level orchestration module with diagnostics.       |
//|           Coordinates MarketData, Indicators, Analysis, Signal,  |
//|           Risk, and Execution in a deterministic pipeline.       |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH

#include "Module.mqh"
#include "Context.mqh"
#include "../MarketData/MarketDataProvider.mqh"
#include "../Indicators/EMAIndicator.mqh"
#include "../Indicators/ATRIndicator.mqh"
#include "../Indicators/ADXIndicator.mqh"
#include "../Indicators/BollingerBands.mqh"          // Sprint 014 addition
#include "../Analysis/SRDetector.mqh"                // Sprint 014 addition
#include "../Signals/BreakoutSignal.mqh"
#include "../Risk/RiskManager.mqh"
#include "../Trading/TradeExecutor.mqh"
#include "../Trading/PositionTracker.mqh"

// Forward declaration — full header will be included in Sprint 015
class CBasketManager;

class CEngine : public CModule
{
private:
   CEMAIndicator       *m_ema;
   CATRIndicator       *m_atr;
   CADXIndicator       *m_adx;
   CBollingerBands     *m_bollingerBands;    // Sprint 014 addition
   CSRDetector         *m_srDetector;        // Sprint 014 addition
   CBasketManager      *m_basketManager;     // reserved — Sprint 015
   CBreakoutSignal     *m_signal;
   CRiskManager        *m_risk;
   CPositionTracker    *m_tracker;
   CTradeExecutor      *m_executor;
   CMarketDataProvider *m_marketData;

public:
   CEngine()
      : CModule("CEngine")
   {
      m_ema             = NULL;
      m_atr             = NULL;
      m_adx             = NULL;
      m_bollingerBands  = NULL;
      m_srDetector      = NULL;
      m_basketManager   = NULL;
      m_signal          = NULL;
      m_risk            = NULL;
      m_tracker         = NULL;
      m_executor        = NULL;
      m_marketData      = NULL;
   }

   // Existing setters
   void SetIndicators(CEMAIndicator *ema,
                      CATRIndicator *atr,
                      CADXIndicator *adx)
   {
      m_ema = ema;
      m_atr = atr;
      m_adx = adx;
   }

   // Sprint 014: separate setter for Bollinger Bands (independent of the triple)
   void SetBollingerBands(CBollingerBands *bb)
   {
      m_bollingerBands = bb;
   }

   void SetAnalysis(CSRDetector *sr)
   {
      m_srDetector = sr;
   }

   void SetBasketManager(CBasketManager *bm)
   {
      m_basketManager = bm;
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

   void SetMarketData(CMarketDataProvider *marketData)
   {
      m_marketData = marketData;
   }

   //--------------------------------------------------------------
   // Initialize — all module pointers validated
   //--------------------------------------------------------------
   virtual bool Initialize(CContext *context) override
   {
      if(context == NULL)      return false;
      if(!context.IsValid())   return false;
      m_context = context;

      // Enforce mandatory modules
      if(m_ema        == NULL ||
         m_atr        == NULL ||
         m_adx        == NULL ||
         m_signal     == NULL ||
         m_risk       == NULL ||
         m_tracker    == NULL ||
         m_executor   == NULL ||
         m_marketData == NULL)
         return false;

      // Bollinger Bands: not mandatory, but warn if missing
      if(m_bollingerBands == NULL)
      {
         if(m_context.Logger() != NULL)
            m_context.Logger().Log(LOG_WARNING,
               "CEngine: BollingerBands not wired — S/R analysis will be degraded",
               "CEngine");
      }

      // SRDetector: not mandatory — analysis may be disabled without blocking the pipeline
      if(m_srDetector == NULL)
      {
         if(m_context.Logger() != NULL)
            m_context.Logger().Log(LOG_WARNING,
               "CEngine: SRDetector not wired — analysis pipeline disabled",
               "CEngine");
      }

      // Initialize all modules in order
      if(!m_marketData.Initialize(context)) return false;
      if(!m_ema.Initialize(context))        return false;
      if(!m_atr.Initialize(context))        return false;
      if(!m_adx.Initialize(context))        return false;
      if(m_bollingerBands != NULL && !m_bollingerBands.Initialize(context)) return false;
      if(m_srDetector != NULL && !m_srDetector.Initialize(context)) return false;
      if(!m_signal.Initialize(context))      return false;
      if(!m_risk.Initialize(context))        return false;
      if(!m_tracker.Initialize(context))     return false;
      if(!m_executor.Initialize(context))    return false;
      // CBasketManager not initialized yet (Sprint 015)

      return CBaseObject::Initialize();
   }

   //--------------------------------------------------------------
   // Update — the per‑tick pipeline (Sprint 014 enhancements)
   //--------------------------------------------------------------
   virtual bool Update() override
   {
      if(!m_initialized)
         return false;

      // 0. Acquire raw market data
      if(!m_marketData.Update())
         return false;

      // 1. Update all indicators (best‑effort, sets IsReady)
      UpdateIndicators();

      // 1.5. Analysis layer (support/resistance detection)
      UpdateAnalysis();

      // DIAG: Snapshot readiness — every 5 minutes in production
      {
         static datetime lastPrint = 0;
         if(TimeCurrent() - lastPrint > 300)
         {
            CMarketSnapshot *snap = m_context.Snapshot();
            PrintFormat("[DIAG] Snapshot.IsReady: %s",
                        snap != NULL && snap.IsReady ? "YES" : "NO");
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

      // 5. Basket update (stub for Sprint 015)
      UpdateBasket();

      return true;
   }

   virtual void Shutdown() override
   {
      m_ema             = NULL;
      m_atr             = NULL;
      m_adx             = NULL;
      m_bollingerBands  = NULL;
      m_srDetector      = NULL;
      m_basketManager   = NULL;
      m_signal          = NULL;
      m_risk            = NULL;
      m_tracker         = NULL;
      m_executor        = NULL;
      m_marketData      = NULL;

      CModule::Shutdown();
   }

private:
   void UpdateIndicators()
   {
      bool emaOk = (m_ema != NULL) && m_ema.Update();
      bool atrOk = (m_atr != NULL) && m_atr.Update();
      bool adxOk = (m_adx != NULL) && m_adx.Update();
      bool bbOk  = (m_bollingerBands != NULL) && m_bollingerBands.Update();

      // Bollinger Bands failure does not invalidate snapshot readiness,
      // but it's logged for diagnostics.
      if(m_context != NULL)
      {
         CMarketSnapshot *snap = m_context.Snapshot();
         if(snap != NULL)
            snap.IsReady = (emaOk && atrOk && adxOk);
      }
   }

   bool UpdateAnalysis()
   {
      if(m_srDetector == NULL)
         return false;

      return m_srDetector.Update();
   }

   void UpdateBasket()
   {
      if(m_basketManager == NULL)
         return;

      // Reserved for Sprint 015 — full basket lifecycle management
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