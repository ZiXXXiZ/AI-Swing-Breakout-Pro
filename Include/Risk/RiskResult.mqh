//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Risk                                                   |
//| File    : RiskResult.mqh                                         |
//| Purpose : Data-only struct for risk evaluation output            |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_RISK_RISKRESULT_MQH
#define AI_SWINGBREAKOUT_RISK_RISKRESULT_MQH

#include "../Core/Types.mqh"

//+------------------------------------------------------------------+
//| Struct SRiskResult                                               |
//| Description:                                                     |
//|   Holds the result of a single risk evaluation cycle. Populated  |
//|   by CRiskBase::Update() in a concrete risk module. Indicates    |
//|   whether a trade is allowed and, if so, the calculated position |
//|   size.                                                          |
//+------------------------------------------------------------------+
struct SRiskResult
{
   double LotSize;
   bool   IsAllowed;
   string Reason;

   SRiskResult()
   {
      LotSize   = 0.0;
      IsAllowed = false;
      Reason    = "";
   }
};

#endif // AI_SWINGBREAKOUT_RISK_RISKRESULT_MQH