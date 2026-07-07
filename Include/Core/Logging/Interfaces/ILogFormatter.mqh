//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : ILogFormatter.mqh                                      |
//| Purpose : Interface for all log formatter implementations        |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
//| Notes                                                            |
//|   - Pure interface                                                |
//|   - No implementation                                             |
//|   - Used by Logger                                                 |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_ILOGFORMATTER_MQH
#define AI_SWINGBREAKOUT_CORE_ILOGFORMATTER_MQH

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

#endif // AI_SWINGBREAKOUT_CORE_ILOGFORMATTER_MQH