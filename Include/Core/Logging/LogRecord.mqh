//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : LogRecord.mqh                                          |
//| Purpose : Defines a single log record used by the logging        |
//|           subsystem                                              |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
//| Notes:                                                           |
//|   - Plain data structure                                          |
//|   - No business logic                                             |
//|   - Shared by Formatter and Output modules                        |
//|                                                                  |
//|   Function/Line/Symbol/Timeframe/Ticket/ErrorCode were added      |
//|   this cycle — DefaultLogFormatter.mqh already read all six of    |
//|   these fields, but they had never actually been declared here,  |
//|   which would have failed to compile the moment both files were  |
//|   built together. See CHANGELOG.md.                              |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_LOGRECORD_MQH
#define AI_SWINGBREAKOUT_CORE_LOGRECORD_MQH

#include "LogLevel.mqh"

//+------------------------------------------------------------------+
//| Log Record                                                       |
//+------------------------------------------------------------------+
struct SLogRecord
{
public:

   datetime         Timestamp;   // Time of log creation
   ENUM_LOG_LEVEL   Level;       // Log severity
   string           Module;      // Source module
   string           Function;    // Source function (optional)
   int              Line;        // Source line number (optional, 0 = unset)
   string           Message;     // Log message
   string           Symbol;      // Related symbol (optional)
   ENUM_TIMEFRAMES  Timeframe;   // Related timeframe (optional, PERIOD_CURRENT = unset)
   ulong            Ticket;      // Related order/position ticket (optional, 0 = unset)
   int              ErrorCode;   // Related error code (optional, 0 = unset)

   // Constructor
   SLogRecord()
   {
      Timestamp = TimeCurrent();
      Level     = LOG_INFO;
      Module    = "";
      Function  = "";
      Line      = 0;
      Message   = "";
      Symbol    = "";
      Timeframe = PERIOD_CURRENT;
      Ticket    = 0;
      ErrorCode = 0;
   }

   // Reset record
   void Clear()
   {
      Timestamp = 0;
      Level     = LOG_INFO;
      Module    = "";
      Function  = "";
      Line      = 0;
      Message   = "";
      Symbol    = "";
      Timeframe = PERIOD_CURRENT;
      Ticket    = 0;
      ErrorCode = 0;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_LOGRECORD_MQH