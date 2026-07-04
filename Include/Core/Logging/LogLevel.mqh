//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : LogLevel.mqh                                           |
//| Purpose : Logging severity levels                                |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_LOGLEVEL_MQH
#define AI_SWINGBREAKOUT_CORE_LOGLEVEL_MQH

//==============================================================
// Logging Levels
//==============================================================
enum ENUM_LOG_LEVEL
{
   LOG_ERROR = 0,
   LOG_WARNING,
   LOG_INFO,
   LOG_DEBUG,
   LOG_TRACE
};

#endif // AI_SWINGBREAKOUT_CORE_LOGLEVEL_MQH