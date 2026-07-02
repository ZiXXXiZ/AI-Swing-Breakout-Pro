//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorInfo.mqh                                          |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Represents a structured framework error.                       |
//+------------------------------------------------------------------+
#ifndef __ERRORINFO_MQH__
#define __ERRORINFO_MQH__

#include "ErrorCodes.mqh"

//+------------------------------------------------------------------+
//| Error Information                                                |
//+------------------------------------------------------------------+
struct SErrorInfo
{
public:

   int                    Code;           // MT5 error code
   string                 Message;        // Short message
   string                 Description;    // Detailed explanation
   ENUM_ERROR_CATEGORY    Category;       // Error category
   ENUM_ERROR_SEVERITY    Severity;       // Error severity
   bool                   Recoverable;    // Can caller retry?

   //---------------------------------------------------------------
   // Constructor
   //---------------------------------------------------------------
   SErrorInfo()
   {
      Clear();
   }

   //---------------------------------------------------------------
   // Reset
   //---------------------------------------------------------------
   void Clear()
   {
      Code         = 0;
      Message      = "";
      Description  = "";
      Category     = ERROR_CATEGORY_UNKNOWN;
      Severity     = ERROR_SEVERITY_INFO;
      Recoverable  = true;
   }

   //---------------------------------------------------------------
   // Is error valid?
   //---------------------------------------------------------------
   bool IsValid() const
   {
      return (Code != 0);
   }
};

#endif // __ERRORINFO_MQH__