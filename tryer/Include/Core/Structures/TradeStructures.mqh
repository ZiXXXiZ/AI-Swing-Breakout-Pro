//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : TradeStructures.mqh                                    |
//| Purpose : Trading-related shared structures                      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_STRUCTURES_TRADESTRUCTURES_MQH
#define AI_SWINGBREAKOUT_CORE_STRUCTURES_TRADESTRUCTURES_MQH

// Project Includes
#include "../Types.mqh"

//+------------------------------------------------------------------+
//| Trade Signal                                                     |
//+------------------------------------------------------------------+
struct STradeSignal
{
   datetime         Time;
   string           Symbol;

   ETradeDirection  Direction;
   ESignalStrength  Strength;

   double           EntryPrice;
   double           StopLoss;
   double           TakeProfit;

   double           Confidence;

   bool             Valid;

   void Reset()
   {
      Time        = 0;
      Symbol      = "";

      Direction   = TRADE_DIRECTION_NONE;
      Strength    = SIGNAL_NONE;

      EntryPrice  = 0.0;
      StopLoss    = 0.0;
      TakeProfit  = 0.0;

      Confidence  = 0.0;

      Valid       = false;
   }
};

//+------------------------------------------------------------------+
//| Position Information                                             |
//+------------------------------------------------------------------+
struct SPositionInfo
{
   ulong             Ticket;
   string            Symbol;

   long              Magic;

   ETradeDirection   Direction;

   double            Volume;

   double            OpenPrice;

   double            StopLoss;
   double            TakeProfit;

   double            CurrentPrice;

   double            Profit;

   datetime          OpenTime;

   void Reset()
   {
      Ticket       = 0;
      Symbol       = "";

      Magic        = 0;

      Direction    = TRADE_DIRECTION_NONE;

      Volume       = 0.0;

      OpenPrice    = 0.0;

      StopLoss     = 0.0;
      TakeProfit   = 0.0;

      CurrentPrice = 0.0;

      Profit       = 0.0;

      OpenTime     = 0;
   }
};

//+------------------------------------------------------------------+
//| Order Request                                                    |
//+------------------------------------------------------------------+
struct SOrderRequest
{
   string            Symbol;

   ETradeDirection   Direction;

   double            Volume;

   double            EntryPrice;

   double            StopLoss;

   double            TakeProfit;

   int               Slippage;

   long              Magic;

   string            Comment;

   void Reset()
   {
      Symbol      = "";

      Direction   = TRADE_DIRECTION_NONE;

      Volume      = 0.0;

      EntryPrice  = 0.0;

      StopLoss    = 0.0;

      TakeProfit  = 0.0;

      Slippage    = 0;

      Magic       = 0;

      Comment     = "";
   }
};

//+------------------------------------------------------------------+
//| Order Execution Result                                           |
//+------------------------------------------------------------------+
struct SExecutionResult
{
   bool              Success;

   ulong             Ticket;

   int               Retcode;

   string            Message;

   void Reset()
   {
      Success = false;

      Ticket  = 0;

      Retcode = 0;

      Message = "";
   }
};

//+------------------------------------------------------------------+
//| Price Levels                                                     |
//+------------------------------------------------------------------+
struct SPriceLevels
{
   double Entry;
   double StopLoss;
   double TakeProfit;
   double BreakEven;

   void Reset()
   {
      Entry      = 0.0;
      StopLoss   = 0.0;
      TakeProfit = 0.0;
      BreakEven  = 0.0;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_STRUCTURES_TRADESTRUCTURES_MQH