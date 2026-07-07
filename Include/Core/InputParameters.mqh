//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : InputParameters.mqh                                    |
//| Purpose : Expert Advisor input parameters                        |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
//| Note: InpMagicNumber (below) and Config.mqh's MAGIC_NUMBER        |
//| constant currently hold the same literal value independently.    |
//| Nothing wires one from the other yet. Flagged as a design item    |
//| for whenever Config is wired from these inputs — not fixed here, |
//| since that's a data-flow decision, not a naming/header cleanup.  |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_INPUTPARAMETERS_MQH
#define AI_SWINGBREAKOUT_CORE_INPUTPARAMETERS_MQH

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

#endif // AI_SWINGBREAKOUT_CORE_INPUTPARAMETERS_MQH