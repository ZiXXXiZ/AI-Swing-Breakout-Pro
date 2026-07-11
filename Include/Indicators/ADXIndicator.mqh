//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : ADXIndicator.mqh                                       |
//| Purpose : Reads ADX/DI values from the shared market snapshot    |
//|           and derives the current trend direction.               |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_ADXINDICATOR_MQH
#define AI_SWINGBREAKOUT_INDICATORS_ADXINDICATOR_MQH

#include "IndicatorBase.mqh"

class CADXIndicator : public CIndicatorBase
{
public:
   CADXIndicator()
      : CIndicatorBase("CADXIndicator")
   {
   }

   virtual bool Update() override;
};

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CADXIndicator::Update()
{
   if(!IsReady())
      return false;

   CMarketSnapshot *snap = m_context.Snapshot();

   if(snap.PlusDI > snap.MinusDI)
      snap.TrendDirection = TREND_UP;
   else if(snap.MinusDI > snap.PlusDI)
      snap.TrendDirection = TREND_DOWN;
   else
      snap.TrendDirection = TREND_SIDEWAYS;

   return true;
}

#endif // AI_SWINGBREAKOUT_INDICATORS_ADXINDICATOR_MQH