//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : LogLevel.mqh                                           |
//| Version : 2.0.0-alpha.2                                          |
//| Author  : OpenAI & Project Team                                  |
//|                                                                  |
//| Purpose:                                                         |
//|   Defines the logging severity levels used throughout the         |
//|   AI Swing Breakout Pro framework.                               |
//|                                                                  |
//| Notes:                                                           |
//|   - Zero dependencies                                            |
//|   - Shared by all framework modules                              |
//|   - Ordered by severity for runtime filtering                    |
//+------------------------------------------------------------------+
#ifndef __LOGLEVEL_MQH__
#define __LOGLEVEL_MQH__

//+------------------------------------------------------------------+
//| Logging Levels                                                   |
//|                                                                  |
//| Lower values represent higher severity.                          |
//| Logger implementations can filter messages by comparing          |
//| numeric values.                                                  |
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVEL
{
   LOG_NONE = 0,      // Logging disabled

   LOG_ERROR = 1,     // Critical errors

   LOG_WARNING = 2,   // Warning conditions

   LOG_INFO = 3,      // General information

   LOG_DEBUG = 4      // Debug information
};

#endif // __LOGLEVEL_MQH__
