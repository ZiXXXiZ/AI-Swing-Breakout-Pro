//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Signals                                                |
//| File    : SignalResult.mqh                                       |
//| Purpose : Data-only struct for signal evaluation output.         |
//|           No business logic — pure data container.               |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_SIGNALS_SIGNALRESULT_MQH
#define AI_SWINGBREAKOUT_SIGNALS_SIGNALRESULT_MQH

#include "../Core/Types.mqh"

//+------------------------------------------------------------------+
//| Struct SSignalResult                                             |
//| Description:                                                     |
//|   Holds the result of a single signal evaluation. Populated by   |
//|   CSignalBase::Update() in a concrete signal module. Read by     |
//|   Risk modules (through CContext or directly) to decide whether  |
//|   to allow a trade.                                              |
//+------------------------------------------------------------------+
struct SSignalResult
{
   ETradeDirection Direction;   // Buy, Sell, or None
   ESignalStrength Strength;    // Signal strength classification
   double          Probability; // 0.0 – 1.0 confidence estimate
   bool            IsValid;     // True if the signal is actionable

   SSignalResult()
   {
      Direction   = TRADE_DIRECTION_NONE;
      Strength    = SIGNAL_NONE;
      Probability = 0.0;
      IsValid     = false;
   }
};

#endif // AI_SWINGBREAKOUT_SIGNALS_SIGNALRESULT_MQH