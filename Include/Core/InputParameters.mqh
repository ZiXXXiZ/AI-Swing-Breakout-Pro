//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro v2.0 Institutional Edition       |
//| File    : InputParameters.mqh                                    |
//| Version : 2.0.0-alpha.1                                          |
//| Purpose : Expert Advisor Input Parameters                        |
//+------------------------------------------------------------------+
#ifndef __INPUTPARAMETERS_MQH__
#define __INPUTPARAMETERS_MQH__

//==================================================================
// General
//==================================================================

input group "===== General ====="

input ulong  InpMagicNumber          = 20260001;
input bool   InpEnableTrading        = true;
input bool   InpAllowBuy             = true;
input bool   InpAllowSell            = true;

//==================================================================
// Risk Management
//==================================================================

input group "===== Risk Management ====="

input double InpRiskPercent          = 1.00;
input double InpMaxDailyLoss         = 5.00;
input int    InpMaxOpenPositions     = 3;
input double InpProbabilityThreshold = 0.70;

//==================================================================
// Indicator Settings
//==================================================================

input group "===== Indicators ====="

input int    InpFastEMA              = 50;
input int    InpSlowEMA              = 200;

input int    InpATRPeriod            = 14;
input int    InpADXPeriod            = 14;

input int    InpVolumeMAPeriod       = 20;

//==================================================================
// Filters
//==================================================================

input group "===== Filters ====="

input bool   InpUseATRFilter         = true;
input bool   InpUseADXFilter         = true;
input bool   InpUseVolumeFilter      = true;
input bool   InpUseSpreadFilter      = true;
input bool   InpUseSessionFilter     = true;

//==================================================================
// Trading Sessions
//==================================================================

input group "===== Sessions ====="

input bool   InpTradeLondon          = true;
input bool   InpTradeNewYork         = true;
input bool   InpTradeAsian           = false;

//==================================================================
// Trade Management
//==================================================================

input group "===== Trade Management ====="

input bool   InpUseBreakEven         = true;
input bool   InpUsePartialClose      = true;
input bool   InpUseATRTrailing       = true;

input double InpBreakEvenATR         = 1.00;
input double InpTrailingATR          = 2.00;

//==================================================================
// Spread Protection
//==================================================================

input group "===== Spread Protection ====="

input double InpMaxSpreadPoints      = 30;

//==================================================================
// Dashboard
//==================================================================

input group "===== Dashboard ====="

input bool   InpShowDashboard        = true;
input bool   InpShowStatistics       = true;

//==================================================================
// Logging
//==================================================================

input group "===== Logging ====="

input bool   InpEnableLogging        = true;
input bool   InpWriteJournal         = true;
input bool   InpDebugMode            = false;

#endif