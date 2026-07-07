//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : ILogOutput.mqh                                         |
//| Purpose : Interface for log output targets                       |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
//| Notes                                                            |
//|   - Pure interface                                                |
//|   - No implementation                                             |
//|   - Used by Logger                                                 |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_ILOGOUTPUT_MQH
#define AI_SWINGBREAKOUT_CORE_ILOGOUTPUT_MQH

class ILogOutput
{
public:

   virtual ~ILogOutput() {}

   virtual bool Write(const string &text) = 0;

   virtual void Flush() {}

   virtual void Close() {}
};

#endif // AI_SWINGBREAKOUT_CORE_ILOGOUTPUT_MQH