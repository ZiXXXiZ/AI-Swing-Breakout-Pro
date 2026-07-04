//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorCodes.mqh                                         |
//| Purpose : Centralized framework error definitions                |
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

#endif