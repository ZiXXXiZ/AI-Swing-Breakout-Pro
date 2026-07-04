//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorHandler.mqh                                       |
//| Purpose : Central error manager (no logging dependency)         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_ERRORHANDLER_MQH
#define AI_SWINGBREAKOUT_CORE_ERRORHANDLER_MQH

#include "ErrorInfo.mqh"

class CErrorHandler
{
private:
   SErrorInfo m_lastError;
   bool       m_hasError;

public:

   CErrorHandler()
   {
      Clear();
   }

   void Clear()
   {
      m_lastError.Timestamp = 0;
      m_lastError.Code      = 0;
      m_lastError.Severity  = 0;
      m_lastError.Module    = "";
      m_lastError.Function  = "";
      m_lastError.Message   = "";
      m_hasError = false;
   }

   void SetError(int code,
                 int severity,
                 string module,
                 string function,
                 string message)
   {
      m_lastError.Timestamp = TimeCurrent();
      m_lastError.Code      = code;
      m_lastError.Severity  = severity;
      m_lastError.Module    = module;
      m_lastError.Function  = function;
      m_lastError.Message   = message;

      m_hasError = true;
   }

   bool HasError() const
   {
      return m_hasError;
   }

   SErrorInfo GetLastError() const
   {
      return m_lastError;
   }
};

#endif