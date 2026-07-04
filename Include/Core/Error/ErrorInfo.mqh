//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorInfo.mqh                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_ERRORINFO_MQH
#define AI_SWINGBREAKOUT_CORE_ERRORINFO_MQH

#include "ErrorCodes.mqh"

// DO NOT import LogLevel here (breaks compilation in MQL include graph)

struct SErrorInfo
{
   datetime        Timestamp;
   int             Code;       // avoid enum dependency chain issues
   int             Severity;   // decouple from LogLevel completely

   string          Module;
   string          Function;
   string          Message;
};

#endif