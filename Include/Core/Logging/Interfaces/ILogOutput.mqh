//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ILogOutput.mqh                                         |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Defines the interface for log output targets.                  |
//|                                                                  |
//| Notes                                                            |
//|   - Pure interface                                                |
//|   - No implementation                                             |
//|   - Used by Logger                                                 |
//+------------------------------------------------------------------+
#ifndef __ILOGOUTPUT_MQH__
#define __ILOGOUTPUT_MQH__

class ILogOutput
{
public:

   virtual ~ILogOutput() {}

   virtual bool Write(const string &text) = 0;

   virtual void Flush() {}

   virtual void Close() {}
};

#endif // __ILOGOUTPUT_MQH__