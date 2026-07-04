//+------------------------------------------------------------------+
//| TestErrorHandler.mq5                                             |
//+------------------------------------------------------------------+
#property script_show_inputs

#include <Core/Error/ErrorHandler.mqh>

void OnStart()
{
   CErrorHandler errorHandler;

   SErrorInfo info;

   // Known error
   if(errorHandler.GetErrorInfo(4756, info))
   {
      Print("Known Error");
      Print("Code        : ", info.Code);
      Print("Message     : ", info.Message);
      Print("Category    : ", EnumToString(info.Category));
      Print("Severity    : ", EnumToString(info.Severity));
      Print("Recoverable : ", info.Recoverable);
   }

   // Unknown error
   if(!errorHandler.GetErrorInfo(99999, info))
   {
      Print("Unknown Error");
      Print("Code        : ", info.Code);
      Print("Message     : ", info.Message);
   }
}