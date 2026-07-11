//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : ATRIndicator.mqh                                       |
//| Purpose : Reads ATR value from the shared market snapshot        |
//|           (populated by CMarketDataProvider).                    |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.12                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_ATRINDICATOR_MQH
#define AI_SWINGBREAKOUT_INDICATORS_ATRINDICATOR_MQH

#include "IndicatorBase.mqh"

class CATRIndicator : public CIndicatorBase
{
public:
   CATRIndicator()
      : CIndicatorBase("CATRIndicator")
   {
   }

   virtual bool Update() override;
};

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CATRIndicator::Update()
{
   if(!IsReady())
      return false;

   CMarketSnapshot *snap = m_context.Snapshot();
   return (snap.ATR > 0.0);
}

#endif // AI_SWINGBREAKOUT_INDICATORS_ATRINDICATOR_MQH