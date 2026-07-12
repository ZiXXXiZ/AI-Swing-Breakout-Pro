//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Config.mqh                                             |
//| Purpose : Global configuration, enums, and validation             |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_CONFIG_MQH
#define AI_SWINGBREAKOUT_CORE_CONFIG_MQH

#include "Version.mqh"

//==================================================================
// Enumerations
//==================================================================

enum ENUM_MARKET_REGIME
{
   REGIME_UNKNOWN = 0,
   REGIME_TREND,
   REGIME_RANGE,
   REGIME_BREAKOUT,
   REGIME_HIGH_VOLATILITY,
   REGIME_LOW_VOLATILITY
};

enum ENUM_CONFIG_LOG_LEVEL
{
   CONFIG_LOG_ERROR = 0,
   CONFIG_LOG_WARNING,
   CONFIG_LOG_INFO,
   CONFIG_LOG_DEBUG,
   CONFIG_LOG_TRACE
};

enum ENUM_TRADE_DIRECTION
{
   TRADE_BUY_ONLY = 0,
   TRADE_SELL_ONLY,
   TRADE_BOTH
};

//==================================================================
// Constants
//==================================================================

#define INVALID_PRICE      (-1.0)
#define INVALID_HANDLE_ID  (-1)

const ulong MAGIC_NUMBER = 20260001;

//==================================================================
// Configuration Structures
//==================================================================

struct SRiskConfig
{
   double RiskPercent;
   double MaxDailyLossPercent;
   int    MaxOpenPositions;
   double ProbabilityThreshold;
};

struct STradeConfig
{
   bool AllowBuy;
   bool AllowSell;
   bool UseBreakEven;
   bool UsePartialClose;
   bool UseATRTrailing;
   int  MaxSlippagePoints;
};

struct SFilterConfig
{
   bool UseADX;
   bool UseATR;
   bool UseVolume;
   bool UseSpread;
   bool UseSessionFilter;
};

struct SIndicatorConfig
{
   int    FastEMA;
   int    SlowEMA;
   int    ATRPeriod;
   int    ADXPeriod;
   int    VolumeMAPeriod;
   int    BBPeriod;       // ADDED
   double BBDeviation;    // ADDED
};

struct SDashboardConfig
{
   bool ShowDashboard;
   bool ShowStatistics;
};

struct SLogConfig
{
   ENUM_CONFIG_LOG_LEVEL Level;
   bool WriteJournal;
};

//==================================================================
// Configuration Class
//==================================================================

class CConfig
{
public:

   SRiskConfig       Risk;
   STradeConfig      Trade;
   SFilterConfig     Filter;
   SIndicatorConfig  Indicator;
   SDashboardConfig  Dashboard;
   SLogConfig        Log;

   CConfig()
   {
      LoadDefaults();
   }

   void LoadDefaults()
   {
      Risk.RiskPercent           = 1.0;
      Risk.MaxDailyLossPercent   = 5.0;
      Risk.MaxOpenPositions      = 3;
      Risk.ProbabilityThreshold  = 0.70;

      Trade.AllowBuy             = true;
      Trade.AllowSell            = true;
      Trade.UseBreakEven         = true;
      Trade.UsePartialClose      = true;
      Trade.UseATRTrailing       = true;
      Trade.MaxSlippagePoints    = 10;

      Filter.UseADX              = true;
      Filter.UseATR              = true;
      Filter.UseVolume           = true;
      Filter.UseSpread           = true;
      Filter.UseSessionFilter    = true;

      Indicator.FastEMA          = 50;
      Indicator.SlowEMA          = 200;
      Indicator.ATRPeriod        = 14;
      Indicator.ADXPeriod        = 14;
      Indicator.VolumeMAPeriod   = 20;
      Indicator.BBPeriod         = 20;   // ADDED
      Indicator.BBDeviation      = 2.0;  // ADDED

      Dashboard.ShowDashboard    = true;
      Dashboard.ShowStatistics   = true;

      Log.Level                  = CONFIG_LOG_INFO;
      Log.WriteJournal           = true;
   }

   bool Validate()
   {
      if(Risk.RiskPercent <= 0.0) return false;
      if(Risk.MaxDailyLossPercent <= 0.0 || Risk.MaxDailyLossPercent > 100.0) return false;
      if(Risk.MaxOpenPositions < 1) return false;
      if(Risk.ProbabilityThreshold < 0.0 || Risk.ProbabilityThreshold > 1.0) return false;

      if(Indicator.FastEMA >= Indicator.SlowEMA) return false;
      if(Indicator.ATRPeriod < 1) return false;
      if(Indicator.ADXPeriod < 1) return false;
      if(Indicator.VolumeMAPeriod < 1) return false;
      if(Indicator.BBPeriod < 2) return false;      // ADDED
      if(Indicator.BBDeviation <= 0.0) return false; // ADDED

      if(Trade.MaxSlippagePoints < 0) return false;

      return true;
   }
};

#endif