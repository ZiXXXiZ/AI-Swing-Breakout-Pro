//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Risk                                                   |
//| File    : RiskResult.mqh                                         |
//| Purpose : Data-only struct for risk evaluation output.           |
//|           Distances are in points, not absolute prices —         |
//|           the execution layer constructs SL/TP from current      |
//|           price and these distances.                             |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.7                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_RISK_RISKRESULT_MQH
#define AI_SWINGBREAKOUT_RISK_RISKRESULT_MQH

#include "../Core/Types.mqh"

//+------------------------------------------------------------------+
//| Struct SRiskResult                                               |
//| Description:                                                     |
//|   Holds the result of a single risk evaluation cycle. Populated  |
//|   by CRiskBase::Update() in a concrete risk module. Indicates    |
//|   whether a trade is allowed, the calculated position size, and  |
//|   the stop‑loss / take‑profit distances in points (always        |
//|   positive). The execution layer is responsible for converting   |
//|   these distances to absolute price levels at order time.        |
//+------------------------------------------------------------------+
struct SRiskResult
{
   double LotSize;
   double StopLossDistance;   // SL distance in points (positive)
   double TakeProfitDistance; // TP distance in points (positive)
   bool   IsAllowed;
   string Reason;

   SRiskResult()
   {
      LotSize            = 0.0;
      StopLossDistance   = 0.0;
      TakeProfitDistance = 0.0;
      IsAllowed          = false;
      Reason             = "";
   }
};

#endif // AI_SWINGBREAKOUT_RISK_RISKRESULT_MQH