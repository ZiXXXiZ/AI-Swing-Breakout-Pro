//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : ErrorCodes.mqh                                         |
//| Purpose : Centralized framework error definitions                |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_ERRORCODES_MQH
#define AI_SWINGBREAKOUT_CORE_ERRORCODES_MQH

// PURE standalone enum (NO dependencies allowed here)
enum ENUM_ERROR_CODE
{
   ERR_NONE = 0,

   ERR_INIT_FAILED,
   ERR_NOT_INITIALIZED,

   ERR_INVALID_CONFIG,
   ERR_CONFIG_NULL,

   ERR_NULL_POINTER,
   ERR_INVALID_STATE,

   ERR_TRADING_DISABLED,
   ERR_ORDER_FAILED,

   ERR_TERMINAL_NOT_READY,
   ERR_ACCOUNT_INVALID,

   ERR_UNKNOWN = 99
};

// Error's own severity scale — deliberately separate from
// Core/Logging/LogLevel.mqh's ENUM_LOG_LEVEL. Error must not depend
// on Logging (ADR-012 forbidden-dependency table); this is what lets
// ErrorInfo.mqh drop its include of Logging/LogLevel.mqh entirely.
enum ENUM_ERROR_SEVERITY
{
   ERROR_SEVERITY_INFO = 0,
   ERROR_SEVERITY_WARNING,
   ERROR_SEVERITY_ERROR,
   ERROR_SEVERITY_CRITICAL
};

#endif // AI_SWINGBREAKOUT_CORE_ERRORCODES_MQH