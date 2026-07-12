//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : BollingerBands.mqh                                     |
//| Purpose : Bollinger Bands indicator — reads BBUpper/BBMiddle/    |
//|           BBLower from CMarketSnapshot (populated by the         |
//|           CMarketDataProvider). No direct MT5 API calls.         |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_BOLLINGERBANDS_MQH
#define AI_SWINGBREAKOUT_INDICATORS_BOLLINGERBANDS_MQH

#include "IndicatorBase.mqh"

class CBollingerBands : public CIndicatorBase
{
public:
   CBollingerBands()
      : CIndicatorBase("CBollingerBands")
   {
   }

   //--------------------------------------------------------------
   // Public accessors — read directly from the shared snapshot.
   // The snapshot fields are updated every tick by the
   // CMarketDataProvider, so these are always current.
   //--------------------------------------------------------------

   double Upper()
   {
      CMarketSnapshot *snap = (m_context != NULL) ? m_context.Snapshot() : NULL;
      return (snap != NULL) ? snap.BBUpper : 0.0;
   }

   double Middle()
   {
      CMarketSnapshot *snap = (m_context != NULL) ? m_context.Snapshot() : NULL;
      return (snap != NULL) ? snap.BBMiddle : 0.0;
   }

   double Lower()
   {
      CMarketSnapshot *snap = (m_context != NULL) ? m_context.Snapshot() : NULL;
      return (snap != NULL) ? snap.BBLower : 0.0;
   }

   //--------------------------------------------------------------
   // Update — validates that the snapshot contains usable BB values.
   // Matches the pattern of EMAIndicator: IsReady() guards on
   // DataReady, then each field is checked for positivity.
   //--------------------------------------------------------------
   virtual bool Update() override;
};

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CBollingerBands::Update()
{
   if(!IsReady())
      return false;

   CMarketSnapshot *snap = m_context.Snapshot();
   if(snap == NULL)
      return false;

   // All three bands must be non‑zero to consider the indicator ready.
   return (snap.BBUpper  > 0.0 &&
           snap.BBMiddle > 0.0 &&
           snap.BBLower  > 0.0);
}

#endif // AI_SWINGBREAKOUT_INDICATORS_BOLLINGERBANDS_MQH