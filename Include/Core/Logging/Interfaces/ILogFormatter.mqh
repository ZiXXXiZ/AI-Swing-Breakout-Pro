//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ILogFormatter.mqh                                      |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Defines the interface for all log formatter implementations.   |
//|                                                                  |
//| Notes                                                            |
//|   - Pure interface                                                |
//|   - No implementation                                             |
//|   - Used by Logger                                                 |
//+------------------------------------------------------------------+
#ifndef __ILOGFORMATTER_MQH__
#define __ILOGFORMATTER_MQH__

#include "../LogRecord.mqh"

//+------------------------------------------------------------------+
//| Interface                                                        |
//+------------------------------------------------------------------+
class ILogFormatter
{
public:

   virtual ~ILogFormatter() {}

   virtual string Format(const SLogRecord &record) const = 0;
};

#endif // __ILOGFORMATTER_MQH__
