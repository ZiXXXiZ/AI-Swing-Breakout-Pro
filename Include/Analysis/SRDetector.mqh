//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Analysis                                               |
//| File    : SRDetector.mqh                                         |
//| Purpose : Dynamic support/resistance detection using Bollinger   |
//|           Bands from CMarketSnapshot — writes results to         |
//|           CAnalysisSnapshot.                                     |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_ANALYSIS_SRDETECTOR_MQH
#define AI_SWINGBREAKOUT_ANALYSIS_SRDETECTOR_MQH

#include "../Framework/Module.mqh"
#include "../Framework/Context.mqh"
#include "../Core/Constants.mqh"      // for CConstants::EPSILON

class CSRDetector : public CModule
{
public:
   CSRDetector()
      : CModule("CSRDetector")
   {
   }

   virtual bool Initialize(CContext *context) override;
   virtual bool Update() override;
   virtual void Shutdown() override;
};

//+------------------------------------------------------------------+
//| Initialize                                                       |
//+------------------------------------------------------------------+
bool CSRDetector::Initialize(CContext *context)
{
   return CModule::Initialize(context);
}

//+------------------------------------------------------------------+
//| Shutdown                                                         |
//+------------------------------------------------------------------+
void CSRDetector::Shutdown()
{
   CModule::Shutdown();
}

//+------------------------------------------------------------------+
//| Update                                                           |
//| Detects support/resistance from Bollinger Bands in the shared    |
//| market snapshot. Writes results into the analysis snapshot.      |
//| Returns true if successful, false if data unavailable.           |
//+------------------------------------------------------------------+
bool CSRDetector::Update()
{
   if(!m_initialized || m_context == NULL)
      return false;

   // Guard: need market snapshot ready
   CMarketSnapshot *market = m_context.Snapshot();
   if(market == NULL || !market.IsReady)
   {
      // If market data isn't ready, analysis isn't either
      CAnalysisSnapshot *analysis = m_context.AnalysisSnapshot();
      if(analysis != NULL)
         analysis.IsReady = false;
      return false;
   }

   // Read Bollinger Bands from market snapshot
   double upper  = market.BBUpper;
   double middle = market.BBMiddle;
   double lower  = market.BBLower;

   // Validate band values — all must be strictly positive
   if(upper <= CConstants::EPSILON || middle <= CConstants::EPSILON || lower <= CConstants::EPSILON)
   {
      CAnalysisSnapshot *analysis = m_context.AnalysisSnapshot();
      if(analysis != NULL)
         analysis.IsReady = false;
      return false;
   }

   // Calculate derived support/resistance metrics
   double resistanceLevel    = upper;                                  // dynamic resistance
   double supportLevel       = lower;                                  // dynamic support
   double resistanceStrength = (upper - middle) / middle;              // upper band width ratio
   double supportStrength    = (middle - lower) / middle;              // lower band width ratio
   double trendBias          = middle;                                 // middle band as trend proxy

   // Write results into analysis snapshot
   CAnalysisSnapshot *analysis = m_context.AnalysisSnapshot();
   if(analysis == NULL)
      return false;

   analysis.SupportLevel      = supportLevel;
   analysis.ResistanceLevel   = resistanceLevel;
   analysis.SupportStrength   = supportStrength;
   analysis.ResistanceStrength = resistanceStrength;
   analysis.TrendBias         = trendBias;
   analysis.IsReady           = true;

   return true;
}

#endif // AI_SWINGBREAKOUT_ANALYSIS_SRDETECTOR_MQH