//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro v2.0 Institutional Edition       |
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

enum ENUM_LOG_LEVEL
{
   LOG_ERROR = 0,
   LOG_WARNING,
   LOG_INFO,
   LOG_DEBUG,
   LOG_TRACE
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
   int FastEMA;
   int SlowEMA;
   int ATRPeriod;
   int ADXPeriod;
   int VolumeMAPeriod;
};

struct SDashboardConfig
{
   bool ShowDashboard;
   bool ShowStatistics;
};

struct SLogConfig
{
   ENUM_LOG_LEVEL Level;
   bool WriteJournal;
};

//==================================================================
// Configuration Class
//==================================================================

class CConfig
{
public:

   // DIRECT ACCESS (MQL SAFE)
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

      Dashboard.ShowDashboard    = true;
      Dashboard.ShowStatistics   = true;

      Log.Level                  = LOG_INFO;
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

      return true;
   }
};

#endif