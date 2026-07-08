//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Risk                                                   |
//| File    : RiskManager.mqh                                        |
//| Purpose : Concrete risk manager — validates signals against      |
//|           account limits and calculates position size.           |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_RISK_RISKMANAGER_MQH
#define AI_SWINGBREAKOUT_RISK_RISKMANAGER_MQH

#include "RiskBase.mqh"
#include "../Core/Platform.mqh"
#include "../Core/Config.mqh"
#include "../Core/MathUtils.mqh"
#include "../Core/ValidationUtils.mqh"

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

   // Terminal trade permission
   if(!platform.IsTradeAllowed())
      return false;

   // Daily loss check (even without a signal)
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

   // 1. Validate signal
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

   // 2. Probability threshold
   if(signal.Probability < cfg.Risk.ProbabilityThreshold)
   {
      result.Reason = "Probability below threshold";
      return result;
   }

   // 3. Max positions
   if(!CheckMaxPositions())
   {
      result.Reason = "Max positions reached";
      return result;
   }

   // 4. Daily loss
   if(!CheckDailyLoss())
   {
      result.Reason = "Daily loss limit reached";
      return result;
   }

   // 5. Calculate lot size (we need stop loss pips; this could come from
   //    ATR snapshot in a more advanced version. For now we'll assume a
   //    default stop loss distance, or it could be read from a config value.
   //    The RiskBase spec expects us to have a stop loss distance to pass.
   //    We'll use a simple default of 50 pips for now; future tasks will
   //    integrate ATR-based stops from the snapshot.
   double stopLossPips = 50.0; // placeholder — will be ATR-based later
   double lotSize = CalculateLotSize(cfg.Risk.RiskPercent, stopLossPips);

   // 6. Validate lot size against broker symbol limits
   lotSize = CMathUtils::RoundToStep(lotSize, SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP));

   if(!CValidationUtils::IsValidVolume(_Symbol, lotSize))
   {
   result.Reason = "Lot size invalid for symbol";
   return result;
   }

   // 7. Final result
   result.LotSize   = lotSize;
   result.IsAllowed = true;
   result.Reason    = "";

   return result;
}

//+------------------------------------------------------------------+
//| CalculateLotSize                                                 |
//|   RiskPercent is a percentage of balance (e.g. 1.0 = 1%)         |
//|   stopLossPips is the stop distance in pips (10 = 10 pips for    |
//|   5-digit broker, 1 pip = 10 points).                            |
//|   Returns raw lot size (unrounded).                              |
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

   // Get tick value for the symbol (in account currency per lot per point)
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double point     = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

   // If broker reports tick value and size, calculate value per point
   double valuePerPoint = 0.0;
   if(tickSize > 0.0 && tickValue > 0.0)
      valuePerPoint = tickValue / tickSize * point;

   // Fallback if tick data is unavailable: assume 1 lot = $10 per pip (forex)
   if(valuePerPoint <= 0.0)
      valuePerPoint = 10.0 * point;   // approximate for major forex pairs

   double stopLossPoints = stopLossPips * point * 10.0; // 1 pip = 10 points (5-digit)
   double lotSize = 0.0;

   if(stopLossPoints > 0.0)
      lotSize = CMathUtils::SafeDivide(riskMoney, (valuePerPoint * stopLossPoints / point), 0.0);

   // Alternative simpler formula if tick data not reliable:
   // lotSize = riskMoney / (stopLossPips * 10.0); // approximate for $1/pip mini lots

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

   int maxPositions = cfg.Risk.MaxOpenPositions;

   // PositionsTotal() includes all symbols — we assume all trades
   // are on the current symbol for this EA.
   int currentPositions = PositionsTotal();

   return (currentPositions < maxPositions);
}

//+------------------------------------------------------------------+
//| CheckDailyLoss                                                   |
//|   Compares today's closed P&L against the max daily loss percent |
//|   of starting balance. For simplicity we use the current balance |
//|   vs. the day's starting balance; a more rigorous implementation |
//|   would track start-of-day balance explicitly.                   |
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

   double balance        = platform.Balance();
   double equity         = platform.Equity();
   double maxLossPercent = cfg.Risk.MaxDailyLossPercent;

   // Approximate today's loss by comparing equity to balance.
   // A real implementation would store start-of-day balance.
   double lossPercent = 0.0;
   if(balance > 0.0)
      lossPercent = ((balance - equity) / balance) * 100.0;

   return (lossPercent < maxLossPercent);
}

#endif // AI_SWINGBREAKOUT_RISK_RISKMANAGER_MQH