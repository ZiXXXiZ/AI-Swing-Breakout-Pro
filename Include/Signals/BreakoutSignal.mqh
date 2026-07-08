//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Signals                                                |
//| File    : BreakoutSignal.mqh                                     |
//| Purpose : Concrete swing breakout signal — evaluates EMA, ADX,   |
//|           and trend alignment to produce a directional signal.   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_SIGNALS_BREAKOUTSIGNAL_MQH
#define AI_SWINGBREAKOUT_SIGNALS_BREAKOUTSIGNAL_MQH

#include "../Core/Platform.mqh"
#include "../Core/Config.mqh"
#include "SignalBase.mqh"
#include "../Core/MathUtils.mqh"

class CBreakoutSignal : public CSignalBase
{
public:
   CBreakoutSignal()
      : CSignalBase("CBreakoutSignal")
   {
   }

   virtual bool Update() override;

private:
   bool   IsBullishBreakout(const CMarketSnapshot *snap, const CConfig *cfg) const;
   bool   IsBearishBreakout(const CMarketSnapshot *snap, const CConfig *cfg) const;
   double CalculateProbability(const CMarketSnapshot *snap) const;
   ESignalStrength MapStrength(const double probability) const;
};

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CBreakoutSignal::Update()
{
   // CContext::Snapshot() returns a value member pointer — never NULL,
   // so no NULL check needed.
   CMarketSnapshot *snap = m_context.Snapshot();
   if(!snap.IsReady)
   {
      m_result.IsValid = false;
      return false;
   }

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
   {
      m_result.IsValid = false;
      return false;
   }

   const CConfig *cfg = platform.Config();
   if(cfg == NULL)
   {
      m_result.IsValid = false;
      return false;
   }

   if(!cfg.Trade.AllowBuy && !cfg.Trade.AllowSell)
   {
      m_result.IsValid = false;
      return false;
   }

   // Evaluate breakout direction — ensure mutual exclusivity.
   bool bullish = false, bearish = false;

   if(IsBullishBreakout(snap, cfg))
      bullish = true;
   else if(IsBearishBreakout(snap, cfg))   // else if prevents both true
      bearish = true;

   if(!bullish && !bearish)
   {
      m_result.IsValid = false;
      return true;
   }

   double prob = CalculateProbability(snap);

   if(prob < cfg.Risk.ProbabilityThreshold)
   {
      m_result.IsValid = false;
      return true;
   }

   m_result.Probability = prob;
   m_result.Strength    = MapStrength(prob);
   m_result.Direction   = bullish ? TRADE_DIRECTION_BUY : TRADE_DIRECTION_SELL;
   m_result.IsValid     = true;

   return true;
}

//+------------------------------------------------------------------+
//| IsBullishBreakout                                                |
//+------------------------------------------------------------------+
bool CBreakoutSignal::IsBullishBreakout(const CMarketSnapshot *snap, const CConfig *cfg) const
{
   return (snap.FastEMA > snap.SlowEMA)             &&
          (snap.TrendDirection == TREND_UP)          &&
          (snap.ADX > 25.0)                          &&
          (snap.PlusDI > snap.MinusDI)               &&
          (cfg.Trade.AllowBuy);
}

//+------------------------------------------------------------------+
//| IsBearishBreakout                                                |
//+------------------------------------------------------------------+
bool CBreakoutSignal::IsBearishBreakout(const CMarketSnapshot *snap, const CConfig *cfg) const
{
   return (snap.FastEMA < snap.SlowEMA)             &&
          (snap.TrendDirection == TREND_DOWN)        &&
          (snap.ADX > 25.0)                          &&
          (snap.MinusDI > snap.PlusDI)               &&
          (cfg.Trade.AllowSell);
}

//+------------------------------------------------------------------+
//| CalculateProbability                                             |
//+------------------------------------------------------------------+
double CBreakoutSignal::CalculateProbability(const CMarketSnapshot *snap) const
{
   double prob = CMathUtils::MapRange(snap.ADX, 25.0, 50.0, 0.5, 1.0);
   prob = CMathUtils::Clamp(prob, 0.0, 1.0);
   return prob;
}

//+------------------------------------------------------------------+
//| MapStrength                                                      |
//+------------------------------------------------------------------+
ESignalStrength CBreakoutSignal::MapStrength(const double probability) const
{
   if(probability >= 0.8)  return SIGNAL_VERY_STRONG;
   if(probability >= 0.6)  return SIGNAL_STRONG;
   if(probability >= 0.4)  return SIGNAL_MODERATE;
   if(probability >= 0.2)  return SIGNAL_WEAK;
   return SIGNAL_VERY_WEAK;
}

#endif // AI_SWINGBREAKOUT_SIGNALS_BREAKOUTSIGNAL_MQH