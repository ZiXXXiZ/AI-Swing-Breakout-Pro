//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : TestErrorHandler.mqh                                   |
//| Purpose : Manual smoke test for CErrorHandler, run as a script.  |
//|           Rewritten against the current SetError/HasError/       |
//|           GetLastError/Clear API — the previous version tested   |
//|           a GetErrorInfo(code, info) lookup method and Category/ |
//|           Recoverable fields that no longer exist anywhere in    |
//|           the current CErrorHandler/SErrorInfo design.           |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#property script_show_inputs

#include "ErrorHandler.mqh"

void OnStart()
{
   CErrorHandler errorHandler;

   // Fresh handler should report no error.
   Print("Initial HasError (expect false): ", errorHandler.HasError());

   // Set an error and confirm it's retrievable.
   errorHandler.SetError(
      ERR_INVALID_CONFIG,
      ERROR_SEVERITY_ERROR,
      "TestErrorHandler",
      "OnStart",
      "Simulated invalid configuration for smoke test"
   );

   Print("After SetError, HasError (expect true): ", errorHandler.HasError());

   SErrorInfo info = errorHandler.GetLastError();

   Print("Code        : ", EnumToString(info.Code));
   Print("Severity    : ", EnumToString(info.Severity));
   Print("Module      : ", info.Module);
   Print("Function    : ", info.Function);
   Print("Message     : ", info.Message);
   Print("Timestamp   : ", TimeToString(info.Timestamp, TIME_DATE|TIME_SECONDS));

   // Clear and confirm state resets.
   errorHandler.Clear();

   Print("After Clear, HasError (expect false): ", errorHandler.HasError());

   SErrorInfo cleared = errorHandler.GetLastError();

   Print("Code after Clear (expect ERR_NONE): ", EnumToString(cleared.Code));
}