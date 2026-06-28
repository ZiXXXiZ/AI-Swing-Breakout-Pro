//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : DefaultLogFormatter.mqh                                |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Default implementation of the logging formatter.               |
//+------------------------------------------------------------------+
#ifndef __DEFAULTLOGFORMATTER_MQH__
#define __DEFAULTLOGFORMATTER_MQH__

#include "Interfaces/ILogFormatter.mqh"

//+------------------------------------------------------------------+
//| Default Log Formatter                                            |
//+------------------------------------------------------------------+
class CDefaultLogFormatter : public ILogFormatter
{
private:

   //-----------------------------------------------------------------
   // Convert log level to string
   //-----------------------------------------------------------------
   string LevelToString(const ENUM_LOG_LEVEL level) const
   {
      switch(level)
      {
         case LOG_ERROR:   return "ERROR";
         case LOG_WARNING: return "WARNING";
         case LOG_INFO:    return "INFO";
         case LOG_DEBUG:   return "DEBUG";
         default:          return "NONE";
      }
   }

public:

   //-----------------------------------------------------------------
   // Format log record
   //-----------------------------------------------------------------
   virtual string Format(const SLogRecord &record) const override
   {
      string output;

      output += TimeToString(record.Timestamp,
                             TIME_DATE|TIME_SECONDS);

      output += " | ";

      output += LevelToString(record.Level);

      output += " | ";

      output += record.Module;

      if(record.Function != "")
      {
         output += "::";
         output += record.Function;
      }

      if(record.Line > 0)
      {
         output += " (";
         output += IntegerToString(record.Line);
         output += ")";
      }

      if(record.Symbol != "")
      {
         output += " | ";
         output += record.Symbol;
      }

      if(record.Timeframe != PERIOD_CURRENT)
      {
         output += " ";
         output += EnumToString(record.Timeframe);
      }

      if(record.Ticket > 0)
      {
         output += " | Ticket:";
         output += IntegerToString((int)record.Ticket);
      }

      if(record.ErrorCode != 0)
      {
         output += " | Error:";
         output += IntegerToString(record.ErrorCode);
      }

      output += " | ";

      output += record.Message;

      return output;
   }
};

#endif
