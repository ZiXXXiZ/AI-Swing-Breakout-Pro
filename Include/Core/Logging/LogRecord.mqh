//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : LogRecord.mqh                                          |
//| Version : 2.0.0-alpha.2                                          |
//| Author  : OpenAI & Project Team                                  |
//|                                                                  |
//| Purpose:                                                         |
//|   Defines a single log record used by the logging subsystem.     |
//|                                                                  |
//| Notes:                                                           |
//|   - Plain data structure                                          |
//|   - No business logic                                             |
//|   - Shared by Formatter and Output modules                        |
//+------------------------------------------------------------------+
#ifndef __LOGRECORD_MQH__
#define __LOGRECORD_MQH__

#include "LogLevel.mqh"

//+------------------------------------------------------------------+
//| Log Record                                                       |
//+------------------------------------------------------------------+
struct SLogRecord
{
public:

   datetime        Timestamp;      // Time of log creation
   ENUM_LOG_LEVEL  Level;          // Log severity
   string          Module;         // Source module
   string          Message;        // Log message

   // Constructor
   SLogRecord()
   {
      Timestamp = TimeCurrent();
      Level     = LOG_INFO;
      Module    = "";
      Message   = "";
   }

   // Reset record
   void Clear()
   {
      Timestamp = 0;
      Level     = LOG_INFO;
      Module    = "";
      Message   = "";
   }
};

#endif // __LOGRECORD_MQH__
