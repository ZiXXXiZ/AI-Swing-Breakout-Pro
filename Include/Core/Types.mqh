//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Types.mqh                                              |
//| Purpose : Shared framework enumerations                          |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_TYPES_MQH
#define AI_SWINGBREAKOUT_CORE_TYPES_MQH

//+------------------------------------------------------------------+
//| Log Levels                                                       |
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
//| Trading Session                                                  |
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
//| Order Result                                                     |
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
//| Framework State                                                  |
//+------------------------------------------------------------------+
enum EFrameworkState
{
   FRAMEWORK_UNINITIALIZED = 0,
   FRAMEWORK_INITIALIZING,
   FRAMEWORK_RUNNING,
   FRAMEWORK_STOPPING,
   FRAMEWORK_STOPPED,
   FRAMEWORK_ERROR
};

#endif // AI_SWINGBREAKOUT_CORE_TYPES_MQH