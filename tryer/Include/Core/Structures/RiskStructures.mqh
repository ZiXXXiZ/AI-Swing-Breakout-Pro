//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : RiskStructures.mqh                                     |
//| Purpose : Risk-related shared structures                         |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_STRUCTURES_RISKSTRUCTURES_MQH
#define AI_SWINGBREAKOUT_CORE_STRUCTURES_RISKSTRUCTURES_MQH

// Project Includes
#include "../Types.mqh"

//+------------------------------------------------------------------+
//| Risk Metrics                                                     |
//+------------------------------------------------------------------+
struct SRiskMetrics
{
   double RiskPercent;
   double RiskAmount;

   double RewardAmount;

   double RiskRewardRatio;

   double PositionSize;

   double StopLossPoints;
   double TakeProfitPoints;

   void Reset()
   {
      RiskPercent      = 0.0;
      RiskAmount       = 0.0;

      RewardAmount     = 0.0;

      RiskRewardRatio  = 0.0;

      PositionSize     = 0.0;

      StopLossPoints   = 0.0;
      TakeProfitPoints = 0.0;
   }

   bool IsValid() const
   {
      return (RiskPercent >= 0.0 &&
              PositionSize >= 0.0 &&
              StopLossPoints >= 0.0);
   }
};

//+------------------------------------------------------------------+
//| Validation Result                                                |
//+------------------------------------------------------------------+
struct SValidationResult
{
   bool   Valid;

   int    ErrorCode;

   string Message;

   void Reset()
   {
      Valid     = true;
      ErrorCode = 0;
      Message   = "";
   }

   void SetError(const int code,const string message)
   {
      Valid     = false;
      ErrorCode = code;
      Message   = message;
   }

   void SetSuccess()
   {
      Valid     = true;
      ErrorCode = 0;
      Message   = "";
   }
};

//+------------------------------------------------------------------+
//| Drawdown Information                                             |
//+------------------------------------------------------------------+
struct SDrawdownInfo
{
   double CurrentDrawdown;
   double MaximumDrawdown;

   double PeakEquity;
   double CurrentEquity;

   void Reset()
   {
      CurrentDrawdown = 0.0;
      MaximumDrawdown = 0.0;

      PeakEquity      = 0.0;
      CurrentEquity   = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Position Sizing                                                  |
//+------------------------------------------------------------------+
struct SPositionSizing
{
   double RiskPercent;

   double StopLossPoints;

   double AccountBalance;

   double AccountEquity;

   double LotSize;

   void Reset()
   {
      RiskPercent    = 0.0;

      StopLossPoints = 0.0;

      AccountBalance = 0.0;
      AccountEquity  = 0.0;

      LotSize        = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Daily Risk                                                       |
//+------------------------------------------------------------------+
struct SDailyRisk
{
   int    TotalTrades;

   int    WinningTrades;

   int    LosingTrades;

   double DailyProfit;

   double DailyLoss;

   double DailyDrawdown;

   void Reset()
   {
      TotalTrades   = 0;

      WinningTrades = 0;
      LosingTrades  = 0;

      DailyProfit   = 0.0;
      DailyLoss     = 0.0;

      DailyDrawdown = 0.0;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_STRUCTURES_RISKSTRUCTURES_MQH