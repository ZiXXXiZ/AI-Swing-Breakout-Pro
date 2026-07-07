//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : ErrorHandler.mqh                                       |
//| Purpose : Central error manager — tracks the most recent error.  |
//|           No logging dependency (ADR-012).                       |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
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
      m_hasError = false;
      Clear();
   }

   void Clear()
   {
      m_lastError.Timestamp = 0;
      m_lastError.Code      = ERR_NONE;
      m_lastError.Severity  = ERROR_SEVERITY_INFO;
      m_lastError.Module    = "";
      m_lastError.Function  = "";
      m_lastError.Message   = "";
      m_hasError = false;
   }

   void SetError(ENUM_ERROR_CODE code,
                 ENUM_ERROR_SEVERITY severity,
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

#endif // AI_SWINGBREAKOUT_CORE_ERRORHANDLER_MQH