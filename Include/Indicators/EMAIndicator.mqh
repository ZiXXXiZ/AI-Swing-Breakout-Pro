//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : EMAIndicator.mqh                                       |
//| Purpose : Reads EMA values from the shared market snapshot       |
//|           (populated by CMarketDataProvider).                    |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_EMAINDICATOR_MQH
#define AI_SWINGBREAKOUT_INDICATORS_EMAINDICATOR_MQH

#include "IndicatorBase.mqh"

class CEMAIndicator : public CIndicatorBase
{
public:
   CEMAIndicator()
      : CIndicatorBase("CEMAIndicator")
   {
   }

   virtual bool Update() override;
};

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CEMAIndicator::Update()
{
   if(!IsReady())
      return false;

   CMarketSnapshot *snap = m_context.Snapshot();
   return (snap.FastEMA > 0.0 && snap.SlowEMA > 0.0);
}

#endif // AI_SWINGBREAKOUT_INDICATORS_EMAINDICATOR_MQH