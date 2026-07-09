//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Risk                                                   |
//| File    : RiskManager.mqh                                        |
//| Purpose : Concrete risk manager — validates signals against      |
//|           account limits, calculates position size, and          |
//|           outputs stop‑loss / take‑profit distances in points.   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.7                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_RISK_RISKMANAGER_MQH
#define AI_SWINGBREAKOUT_RISK_RISKMANAGER_MQH

#include "RiskBase.mqh"
#include "../Core/Platform.mqh"
#include "../Core/Config.mqh"
#include "../Core/MathUtils.mqh"

class CRiskManager : public CRiskBase
{
public:
   CRiskManager()
      : CRiskBase("CRiskManager")
   {
   }

   virtual bool        Initialize(CContext *context) override;
   virtual SRiskResult Calculate(const SSignalResult &signal) const override;
   virtual bool        IsTradeAllowed() const override;

private:
   double CalculateLotSize(const double riskPercent,
                           const double stopLossPips) const;
   bool   CheckMaxPositions() const;
   bool   CheckDailyLoss() const;
};

//+------------------------------------------------------------------+
//| Initialize                                                       |
//+------------------------------------------------------------------+
bool CRiskManager::Initialize(CContext *context)
{
   return CRiskBase::Initialize(context);
}

//+------------------------------------------------------------------+
//| IsTradeAllowed (quick account/platform check)                    |
//+------------------------------------------------------------------+
bool CRiskManager::IsTradeAllowed() const
{
   if(m_context == NULL)
      return false;

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
      return false;

   if(!platform.IsTradeAllowed())
      return false;

   if(!CheckDailyLoss())
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Calculate (full risk evaluation)                                 |
//+------------------------------------------------------------------+
SRiskResult CRiskManager::Calculate(const SSignalResult &signal) const
{
   SRiskResult result;

   if(m_context == NULL)
   {
      result.Reason = "Context is NULL";
      return result;
   }

   if(!signal.IsValid)
   {
      result.Reason = "Signal invalid";
      return result;
   }

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
   {
      result.Reason = "Platform not available";
      return result;
   }

   const CConfig *cfg = platform.Config();
   if(cfg == NULL)
   {
      result.Reason = "Config not available";
      return result;
   }

   if(signal.Probability < cfg.Risk.ProbabilityThreshold)
   {
      result.Reason = "Probability below threshold";
      return result;
   }

   if(!CheckMaxPositions())
   {
      result.Reason = "Max positions reached";
      return result;
   }

   if(!CheckDailyLoss())
   {
      result.Reason = "Daily loss limit reached";
      return result;
   }

   // --- Determine stop loss distance (in pips) from ATR snapshot ---
   double stopLossPips = 50.0; // fallback (safe for majors)
   CMarketSnapshot *snap = m_context.Snapshot();
   if(snap != NULL && snap.IsReady && snap.ATR > 0.0)
   {
      double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      if(point > 0.0)
      {
         // ATR is in price units (e.g. 0.00120 for EURUSD).
         // 1 pip = 10 points for a 5‑digit broker, so pips = ATR / point / 10.
         stopLossPips = (snap.ATR / point) / 10.0;
      }
   }

   // --- Calculate lot size based on risk percent and stop distance ---
   double lotSize = CalculateLotSize(cfg.Risk.RiskPercent, stopLossPips);

   // --- Validate and normalize lot size ---
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   if(minLot <= 0.0) minLot = 0.01;
   if(maxLot <= 0.0) maxLot = 100.0;
   if(step  <= 0.0) step  = 0.01;

   lotSize = CMathUtils::Clamp(lotSize, minLot, maxLot);
   lotSize = CMathUtils::RoundToStep(lotSize, step);

   if(lotSize < minLot)
   {
      result.Reason = "Lot size below minimum";
      return result;
   }

   // --- Output distances in points (execution layer handles prices) ---
   // 1 pip = 10 points for 5‑digit broker, TP = 2× SL (1:2 risk/reward)
   result.StopLossDistance   = stopLossPips * 10.0;
   result.TakeProfitDistance = stopLossPips * 10.0 * 2.0;

   result.LotSize   = lotSize;
   result.IsAllowed = true;
   result.Reason    = "";

   return result;
}

//+------------------------------------------------------------------+
//| CalculateLotSize                                                 |
//+------------------------------------------------------------------+
double CRiskManager::CalculateLotSize(const double riskPercent,
                                      const double stopLossPips) const
{
   if(m_context == NULL)
      return 0.0;

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
      return 0.0;

   double balance  = platform.Balance();
   double riskMoney = CMathUtils::PercentOf(balance, riskPercent);

   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double point     = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

   double valuePerPoint = 0.0;
   if(tickSize > 0.0 && tickValue > 0.0)
      valuePerPoint = tickValue / tickSize * point;

   if(valuePerPoint <= 0.0)
      valuePerPoint = 10.0 * point; // approximate for majors

   // Fix: stopLossPoints is now pips * 10 (points), no point multiplication.
   double stopLossPoints = stopLossPips * 10.0;   // pips → points (1 pip = 10 points)
   double lotSize = 0.0;

   if(stopLossPoints > 0.0)
      lotSize = CMathUtils::SafeDivide(riskMoney, valuePerPoint * stopLossPoints, 0.0);

   return lotSize;
}

//+------------------------------------------------------------------+
//| CheckMaxPositions                                                |
//+------------------------------------------------------------------+
bool CRiskManager::CheckMaxPositions() const
{
   if(m_context == NULL)
      return false;

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
      return false;

   const CConfig *cfg = platform.Config();
   if(cfg == NULL)
      return false;

   return (PositionsTotal() < cfg.Risk.MaxOpenPositions);
}

//+------------------------------------------------------------------+
//| CheckDailyLoss                                                   |
//+------------------------------------------------------------------+
bool CRiskManager::CheckDailyLoss() const
{
   if(m_context == NULL)
      return false;

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
      return false;

   const CConfig *cfg = platform.Config();
   if(cfg == NULL)
      return false;

   double balance = platform.Balance();
   double equity  = platform.Equity();

   double lossPercent = 0.0;
   if(balance > 0.0)
      lossPercent = ((balance - equity) / balance) * 100.0;

   return (lossPercent < cfg.Risk.MaxDailyLossPercent);
}

#endif // AI_SWINGBREAKOUT_RISK_RISKMANAGER_MQH