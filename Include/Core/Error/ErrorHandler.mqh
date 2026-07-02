//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorHandler.mqh                                       |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Provides centralized MT5 error lookup services.                |
//|                                                                  |
//| Responsibilities                                                 |
//|   • Translate MT5 error codes                                    |
//|   • Return structured SErrorInfo                                 |
//|   • Classify errors                                              |
//|   • Determine recoverability                                     |
//+------------------------------------------------------------------+
#ifndef __ERRORHANDLER_MQH__
#define __ERRORHANDLER_MQH__

#include "../Base/BaseObject.mqh"
#include "ErrorCodes.mqh"
#include "ErrorInfo.mqh"

//+------------------------------------------------------------------+
//| Error Handler                                                    |
//+------------------------------------------------------------------+
class CErrorHandler : public CBaseObject
{
public:

   //===============================================================
   // Constructor
   //===============================================================
   CErrorHandler() : CBaseObject("CErrorHandler") {}

   //===============================================================
   // Error Lookup
   //===============================================================
   static bool GetErrorInfo(const int code, SErrorInfo &info);
};

//+------------------------------------------------------------------+
//| Get Error Info                                                   |
//+------------------------------------------------------------------+
bool CErrorHandler::GetErrorInfo(const int code, SErrorInfo &info)
{
   info.Clear();
   info.Code = code;

   // Known MT5 errors
   switch(code)
   {
      // Trade Errors (10001-10100)
      case 10001:
         info.Message      = "Invalid ticket";
         info.Description  = "Order ticket is invalid or does not exist";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = false;
         return true;

      case 10002:
         info.Message      = "Trade is disabled";
         info.Description  = "Trading is disabled in the terminal";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = true;
         return true;

      case 10004:
         info.Message      = "Trade timeout";
         info.Description  = "Trade server did not respond within timeout";
         info.Category     = ERROR_CATEGORY_NETWORK;
         info.Severity     = ERROR_SEVERITY_WARNING;
         info.Recoverable  = true;
         return true;

      case 10006:
         info.Message      = "Invalid stops";
         info.Description  = "Stop loss or take profit values are invalid";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = true;
         return true;

      case 10009:
         info.Message      = "Insufficient margin";
         info.Description  = "Account does not have enough margin for trade";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = false;
         return true;

      case 10012:
         info.Message      = "Invalid volume";
         info.Description  = "Order volume is invalid or outside limits";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = true;
         return true;

      case 10013:
         info.Message      = "Invalid price";
         info.Description  = "Order price is invalid";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = true;
         return true;

      case 10014:
         info.Message      = "Invalid order";
         info.Description  = "Order parameters are invalid";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = true;
         return true;

      case 10015:
         info.Message      = "Position already exists";
         info.Description  = "Attempt to open duplicate position";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_WARNING;
         info.Recoverable  = false;
         return true;

      case 10016:
         info.Message      = "Order locked";
         info.Description  = "Order is locked by another operation";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_WARNING;
         info.Recoverable  = true;
         return true;

      // Market Errors (10100-10200)
      case 10018:
         info.Message      = "Market is closed";
         info.Description  = "Market is not open for trading";
         info.Category     = ERROR_CATEGORY_MARKET;
         info.Severity     = ERROR_SEVERITY_WARNING;
         info.Recoverable  = true;
         return true;

      case 4756:
         info.Message      = "Trade context busy";
         info.Description  = "Trade context is busy with another operation";
         info.Category     = ERROR_CATEGORY_TRADE;
         info.Severity     = ERROR_SEVERITY_WARNING;
         info.Recoverable  = true;
         return true;

      default:
         // Unknown error
         info.Message      = "Unknown error";
         info.Description  = "Error code not recognized";
         info.Category     = ERROR_CATEGORY_UNKNOWN;
         info.Severity     = ERROR_SEVERITY_ERROR;
         info.Recoverable  = true;
         return false;
   }
}

#endif // __ERRORHANDLER_MQH__