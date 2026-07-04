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

//+------------------------------------------------------------------+
//| Error Information                                                |
//+------------------------------------------------------------------+
struct SErrorInfo
{
public:

   int     Code;           // MT5 error code
   string  Message;        // Short message
   string  Description;    // Detailed explanation
   bool    Recoverable;    // Can caller retry?

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