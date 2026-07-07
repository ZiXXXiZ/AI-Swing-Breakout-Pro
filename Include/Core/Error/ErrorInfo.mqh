//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : ErrorInfo.mqh                                          |
//| Purpose : Structured error record used by CErrorHandler          |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_ERRORINFO_MQH
#define AI_SWINGBREAKOUT_CORE_ERRORINFO_MQH

#include "ErrorCodes.mqh"

// No include of Logging/LogLevel.mqh — Severity uses ErrorCodes.mqh's
// own ENUM_ERROR_SEVERITY instead of borrowing Logging's ENUM_LOG_LEVEL.
// This is the ADR-012 decoupling: Error must not depend on Logging.

//==============================================================
struct SErrorInfo
{
   datetime           Timestamp;
   ENUM_ERROR_CODE    Code;
   ENUM_ERROR_SEVERITY Severity;

   string             Module;
   string             Function;
   string             Message;
};

#endif // AI_SWINGBREAKOUT_CORE_ERRORINFO_MQH