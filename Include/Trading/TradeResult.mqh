//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Trading                                                |
//| File    : TradeResult.mqh                                        |
//| Purpose : Data-only struct for trade execution result             |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.5                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_TRADING_TRADERESULT_MQH
#define AI_SWINGBREAKOUT_TRADING_TRADERESULT_MQH

//+------------------------------------------------------------------+
//| Struct STradeResult                                              |
//| Description:                                                     |
//|   Holds the result of a single trade execution attempt.          |
//|   Populated by the trade executor after sending an order.        |
//|   No business logic — pure data container.                       |
//+------------------------------------------------------------------+
struct STradeResult
{
   bool   Success;
   ulong  Ticket;
   int    ErrorCode;
   string Reason;

   STradeResult()
   {
      Success   = false;
      Ticket    = 0;
      ErrorCode = 0;
      Reason    = "";
   }
};

#endif // AI_SWINGBREAKOUT_TRADING_TRADERESULT_MQH