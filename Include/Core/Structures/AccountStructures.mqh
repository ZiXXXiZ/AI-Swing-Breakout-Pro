//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : AccountStructures.mqh                                  |
//| Purpose : Account-related shared structures                      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_STRUCTURES_ACCOUNTSTRUCTURES_MQH
#define AI_SWINGBREAKOUT_CORE_STRUCTURES_ACCOUNTSTRUCTURES_MQH

// Project Includes
#include "../Types.mqh"

//+------------------------------------------------------------------+
//| Account Information                                              |
//+------------------------------------------------------------------+
struct SAccountInfo
{
   long      Login;

   string    Name;
   string    Server;
   string    Company;
   string    Currency;

   double    Balance;
   double    Equity;
   double    Credit;
   double    Profit;

   double    Margin;
   double    FreeMargin;
   double    MarginLevel;

   bool      TradeAllowed;
   bool      TradeExpert;
   bool      TradeEnabled;

   int       Leverage;

   void Reset()
   {
      Login         = 0;

      Name          = "";
      Server        = "";
      Company       = "";
      Currency      = "";

      Balance       = 0.0;
      Equity        = 0.0;
      Credit        = 0.0;
      Profit        = 0.0;

      Margin        = 0.0;
      FreeMargin    = 0.0;
      MarginLevel   = 0.0;

      TradeAllowed  = false;
      TradeExpert   = false;
      TradeEnabled  = false;

      Leverage      = 0;
   }

   bool IsValid() const
   {
      return (Login > 0);
   }
};

//+------------------------------------------------------------------+
//| Margin Information                                               |
//+------------------------------------------------------------------+
struct SMarginInfo
{
   double Used;

   double Free;

   double Level;

   double CallLevel;

   double StopOutLevel;

   void Reset()
   {
      Used         = 0.0;
      Free         = 0.0;
      Level        = 0.0;
      CallLevel    = 0.0;
      StopOutLevel = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Account Limits                                                   |
//+------------------------------------------------------------------+
struct SAccountLimits
{
   double MaxLot;

   double MinLot;

   double LotStep;

   double MaxRiskPercent;

   int    MaxOpenPositions;

   void Reset()
   {
      MaxLot           = 0.0;
      MinLot           = 0.0;
      LotStep          = 0.0;

      MaxRiskPercent   = 0.0;

      MaxOpenPositions = 0;
   }
};

//+------------------------------------------------------------------+
//| Daily Account Statistics                                         |
//+------------------------------------------------------------------+
struct SDailyAccountStatistics
{
   double StartBalance;

   double CurrentBalance;

   double DailyProfit;

   double DailyReturnPercent;

   int    Trades;

   void Reset()
   {
      StartBalance      = 0.0;
      CurrentBalance    = 0.0;

      DailyProfit       = 0.0;

      DailyReturnPercent= 0.0;

      Trades            = 0;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_STRUCTURES_ACCOUNTSTRUCTURES_MQH