//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro v2.0 Institutional Edition       |
//| File    : Config.mqh                                             |
//| Author  : Project Owner + OpenAI                                 |
//| Version : 2.0.0-alpha                                            |
//| Purpose : Global configuration, enums and validation             |
//+------------------------------------------------------------------+
#ifndef __CONFIG_MQH__
#define __CONFIG_MQH__

#include "Version.mqh"

//==================================================================
// Enumerations
//==================================================================

enum ENUM_SIGNAL_TYPE
{
   SIGNAL_NONE = 0,
   SIGNAL_BUY,
   SIGNAL_SELL
};

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
// Global Configuration Object
//==================================================================

class CConfig
{
private:

   SRiskConfig       m_risk;
   STradeConfig      m_trade;
   SFilterConfig     m_filter;
   SIndicatorConfig  m_indicator;
   SDashboardConfig  m_dashboard;
   SLogConfig        m_log;

public:

   CConfig()
   {
      LoadDefaults();
   }

   //--------------------------------------------------------------

   void LoadDefaults()
   {
      // Risk

      m_risk.RiskPercent           = 1.0;
      m_risk.MaxDailyLossPercent   = 5.0;
      m_risk.MaxOpenPositions      = 3;
      m_risk.ProbabilityThreshold  = 0.70;

      // Trading

      m_trade.AllowBuy             = true;
      m_trade.AllowSell            = true;
      m_trade.UseBreakEven         = true;
      m_trade.UsePartialClose      = true;
      m_trade.UseATRTrailing       = true;

      // Filters

      m_filter.UseADX              = true;
      m_filter.UseATR              = true;
      m_filter.UseVolume           = true;
      m_filter.UseSpread           = true;
      m_filter.UseSessionFilter    = true;

      // Indicators

      m_indicator.FastEMA          = 50;
      m_indicator.SlowEMA          = 200;
      m_indicator.ATRPeriod        = 14;
      m_indicator.ADXPeriod        = 14;
      m_indicator.VolumeMAPeriod   = 20;

      // Dashboard

      m_dashboard.ShowDashboard    = true;
      m_dashboard.ShowStatistics   = true;

      // Logging

      m_log.Level                  = LOG_INFO;
      m_log.WriteJournal           = true;
   }

   //--------------------------------------------------------------

   bool Validate()
   {
      if(m_risk.RiskPercent <= 0.0)
         return false;

      if(m_risk.MaxDailyLossPercent <= 0.0 ||
         m_risk.MaxDailyLossPercent > 100.0)
         return false;

      if(m_risk.MaxOpenPositions < 1)
         return false;

      if(m_risk.ProbabilityThreshold < 0.0 ||
         m_risk.ProbabilityThreshold > 1.0)
         return false;

      if(m_indicator.FastEMA >= m_indicator.SlowEMA)
         return false;

      if(m_indicator.ATRPeriod < 1)
         return false;

      if(m_indicator.ADXPeriod < 1)
         return false;

      return true;
   }

   //--------------------------------------------------------------
   // Getters
   //--------------------------------------------------------------

   const SRiskConfig      &Risk()      const { return m_risk;      }
   const STradeConfig     &Trade()     const { return m_trade;     }
   const SFilterConfig    &Filter()    const { return m_filter;    }
   const SIndicatorConfig &Indicator() const { return m_indicator; }
   const SDashboardConfig &Dashboard() const { return m_dashboard; }
   const SLogConfig       &Log()       const { return m_log;       }
};

#endif