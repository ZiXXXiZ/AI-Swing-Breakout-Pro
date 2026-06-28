//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorCodes.mqh                                         |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose:                                                         |
//|   Common error enumerations used by the framework.               |
//+------------------------------------------------------------------+
#ifndef __ERRORCODES_MQH__
#define __ERRORCODES_MQH__

//+------------------------------------------------------------------+
//| Error Category                                                   |
//+------------------------------------------------------------------+
enum ENUM_ERROR_CATEGORY
{
   ERROR_CATEGORY_UNKNOWN = 0,

   ERROR_CATEGORY_RUNTIME,

   ERROR_CATEGORY_TRADE,

   ERROR_CATEGORY_MARKET,

   ERROR_CATEGORY_NETWORK,

   ERROR_CATEGORY_FILE,

   ERROR_CATEGORY_CONFIGURATION,

   ERROR_CATEGORY_INDICATOR
};

//+------------------------------------------------------------------+
//| Error Severity                                                   |
//+------------------------------------------------------------------+
enum ENUM_ERROR_SEVERITY
{
   ERROR_SEVERITY_INFO = 0,

   ERROR_SEVERITY_WARNING,

   ERROR_SEVERITY_ERROR,

   ERROR_SEVERITY_CRITICAL
};

#endif // __ERRORCODES_MQH__
