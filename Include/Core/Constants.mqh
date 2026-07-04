//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Types.mqh                                              |
//| Purpose : Shared framework types, aliases and enumerations       |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_TYPES_MQH
#define AI_SWINGBREAKOUT_CORE_TYPES_MQH

//+------------------------------------------------------------------+
//| Type Aliases                                                     |
//+------------------------------------------------------------------+

typedef ulong   Ticket;
typedef ulong   PositionId;
typedef long    MagicNumber;

typedef double  Price;
typedef double  Volume;
typedef double  Points;
typedef double  Percentage;

//+------------------------------------------------------------------+
//| Log Level                                                        |
//+------------------------------------------------------------------+

enum ELogLevel
{
   LOG_LEVEL_TRACE = 0,
   LOG_LEVEL_DEBUG,
   LOG_LEVEL_INFO,
   LOG_LEVEL_WARNING,
   LOG_LEVEL_ERROR,
   LOG_LEVEL_CRITICAL,
   LOG_LEVEL_NONE
};

//+------------------------------------------------------------------+
//| Trade Direction                                                  |
//+------------------------------------------------------------------+

enum ETradeDirection
{
   TRADE_DIRECTION_NONE = 0,
   TRADE_DIRECTION_BUY,
   TRADE_DIRECTION_SELL,
   TRADE_DIRECTION_BOTH
};

//+------------------------------------------------------------------+
//| Trend Direction                                                  |
//+------------------------------------------------------------------+

enum ETrendDirection
{
   TREND_UNKNOWN = 0,
   TREND_UP,
   TREND_DOWN,
   TREND_SIDEWAYS
};

//+------------------------------------------------------------------+
//| Signal Strength                                                  |
//+------------------------------------------------------------------+

enum ESignalStrength
{
   SIGNAL_NONE = 0,

   SIGNAL_VERY_WEAK,
   SIGNAL_WEAK,

   SIGNAL_MODERATE,

   SIGNAL_STRONG,
   SIGNAL_VERY_STRONG
};

//+------------------------------------------------------------------+
//| Position State                                                   |
//+------------------------------------------------------------------+

enum EPositionState
{
   POSITION_STATE_NONE = 0,

   POSITION_STATE_PENDING,

   POSITION_STATE_OPEN,

   POSITION_STATE_PARTIAL,

   POSITION_STATE_CLOSED,

   POSITION_STATE_ERROR
};

//+------------------------------------------------------------------+
//| Risk Mode                                                        |
//+------------------------------------------------------------------+

enum ERiskMode
{
   RISK_FIXED_LOT = 0,

   RISK_FIXED_MONEY,

   RISK_PERCENT_BALANCE,

   RISK_PERCENT_EQUITY,

   RISK_DYNAMIC
};

//+------------------------------------------------------------------+
//| Trade Session                                                    |
//+------------------------------------------------------------------+

enum ESessionType
{
   SESSION_UNKNOWN = 0,

   SESSION_ASIA,

   SESSION_LONDON,

   SESSION_NEW_YORK,

   SESSION_OVERLAP
};

//+------------------------------------------------------------------+
//| Order Execution Result                                           |
//+------------------------------------------------------------------+

enum EOrderExecutionResult
{
   ORDER_RESULT_UNKNOWN = 0,

   ORDER_RESULT_SUCCESS,

   ORDER_RESULT_REJECTED,

   ORDER_RESULT_TIMEOUT,

   ORDER_RESULT_INVALID,

   ORDER_RESULT_NO_CONNECTION,

   ORDER_RESULT_ERROR
};

//+------------------------------------------------------------------+
//| Trade Signal                                                     |
//+------------------------------------------------------------------+
struct STradeSignal
{
   datetime          Time;
   string            Symbol;

   ETradeDirection   Direction;
   ESignalStrength   Strength;

   Price             EntryPrice;
   Price             StopLoss;
   Price             TakeProfit;

   double            Confidence;
   bool              Valid;

   STradeSignal()
   {
      Time        = 0;
      Symbol      = "";

      Direction   = TRADE_DIRECTION_NONE;
      Strength    = SIGNAL_NONE;

      EntryPrice  = 0.0;
      StopLoss    = 0.0;
      TakeProfit  = 0.0;

      Confidence  = 0.0;
      Valid       = false;
   }
};

//+------------------------------------------------------------------+
//| Risk Metrics                                                     |
//+------------------------------------------------------------------+
struct SRiskMetrics
{
   double RiskPercent;
   double RiskAmount;

   double RewardAmount;

   double RiskRewardRatio;

   double PositionSize;

   double StopLossPoints;
   double TakeProfitPoints;

   SRiskMetrics()
   {
      RiskPercent      = 0.0;
      RiskAmount       = 0.0;

      RewardAmount     = 0.0;

      RiskRewardRatio  = 0.0;

      PositionSize     = 0.0;

      StopLossPoints   = 0.0;
      TakeProfitPoints = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Price Range                                                      |
//+------------------------------------------------------------------+
struct SPriceRange
{
   Price Low;
   Price High;

   SPriceRange()
   {
      Low  = 0.0;
      High = 0.0;
   }

   double Width() const
   {
      return High - Low;
   }

   bool IsValid() const
   {
      return (High >= Low);
   }
};

//+------------------------------------------------------------------+
//| Time Range                                                       |
//+------------------------------------------------------------------+
struct STimeRange
{
   datetime Start;
   datetime End;

   STimeRange()
   {
      Start = 0;
      End   = 0;
   }

   int DurationSeconds() const
   {
      return (int)(End - Start);
   }

   bool IsValid() const
   {
      return (End >= Start);
   }
};

//+------------------------------------------------------------------+
//| Indicator Value                                                  |
//+------------------------------------------------------------------+
struct SIndicatorValue
{
   string Name;

   double Current;
   double Previous;

   datetime Time;

   bool Valid;

   SIndicatorValue()
   {
      Name     = "";

      Current  = 0.0;
      Previous = 0.0;

      Time     = 0;

      Valid    = false;
   }
};

//+------------------------------------------------------------------+
//| Symbol Information                                               |
//+------------------------------------------------------------------+
struct SSymbolInfo
{
   string Symbol;

   int Digits;

   double Point;

   double TickSize;
   double TickValue;

   double LotStep;
   double MinLot;
   double MaxLot;

   bool Tradable;

   SSymbolInfo()
   {
      Symbol    = "";

      Digits    = 0;

      Point     = 0.0;

      TickSize  = 0.0;
      TickValue = 0.0;

      LotStep   = 0.0;
      MinLot    = 0.0;
      MaxLot    = 0.0;

      Tradable  = false;
   }
};

//+------------------------------------------------------------------+
//| Trade Statistics                                                 |
//+------------------------------------------------------------------+
struct STradeStatistics
{
   int TotalTrades;

   int WinningTrades;
   int LosingTrades;

   double WinRate;

   double GrossProfit;
   double GrossLoss;

   double NetProfit;

   double ProfitFactor;

   double MaxDrawdown;

   STradeStatistics()
   {
      TotalTrades   = 0;

      WinningTrades = 0;
      LosingTrades  = 0;

      WinRate       = 0.0;

      GrossProfit   = 0.0;
      GrossLoss     = 0.0;

      NetProfit     = 0.0;

      ProfitFactor  = 0.0;

      MaxDrawdown   = 0.0;
   }
};
