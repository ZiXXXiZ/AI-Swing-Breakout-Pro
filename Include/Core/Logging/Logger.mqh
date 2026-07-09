//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Logger.mqh                                             |
//| Purpose : Central logging coordinator — manages configuration,   |
//|           coordinates formatter/output, applies level filtering, |
//|           and exposes a simple Log() interface for modules.      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.7                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_LOGGER_MQH
#define AI_SWINGBREAKOUT_CORE_LOGGER_MQH

#include "../Base/BaseObject.mqh"
#include "LogLevel.mqh"
#include "LogRecord.mqh"
#include "Interfaces/ILogFormatter.mqh"
#include "Interfaces/ILogOutput.mqh"

class CLogger : public CBaseObject
{
private:
   bool             m_enabled;
   ENUM_LOG_LEVEL   m_level;
   ILogFormatter   *m_formatter;
   ILogOutput      *m_output;

public:
   CLogger()
      : CBaseObject("CLogger")
   {
      m_enabled  = true;
      m_level    = LOG_INFO;
      m_formatter = NULL;
      m_output    = NULL;
   }

   virtual ~CLogger()
   {
      Shutdown();
   }

   //---------------------------------------------------------------
   // Configure
   //---------------------------------------------------------------
   bool Configure(
      ILogFormatter *formatter,
      ILogOutput *output)
   {
      if(formatter == NULL)
         return false;

      if(output == NULL)
         return false;

      m_formatter = formatter;
      m_output    = output;

      return CBaseObject::Initialize();
   }

   //---------------------------------------------------------------
   // Shutdown
   //---------------------------------------------------------------
   virtual void Shutdown() override
   {
      m_formatter = NULL;
      m_output    = NULL;

      CBaseObject::Shutdown();
   }

   //---------------------------------------------------------------
   // Enable / Disable
   //---------------------------------------------------------------
   void Enable(const bool enable)
   {
      m_enabled = enable;
   }

   bool IsEnabled() const
   {
      return m_enabled;
   }

   //---------------------------------------------------------------
   // Log Level
   //---------------------------------------------------------------
   void SetLevel(const ENUM_LOG_LEVEL level)
   {
      m_level = level;
   }

   ENUM_LOG_LEVEL GetLevel() const
   {
      return m_level;
   }

   //---------------------------------------------------------------
   // Log — Primary API
   // Accepts a fully constructed SLogRecord. Caller populates all
   // fields relevant to the event before passing here.
   // Returns false silently if logging is disabled, not initialized,
   // or level is filtered out.
   //---------------------------------------------------------------
   bool Log(const SLogRecord &record)
   {
      if(!m_enabled || !m_initialized)          return false;
      if(record.Level > m_level)                return false;
      if(m_formatter == NULL || m_output == NULL) return false;

      string formatted = m_formatter.Format(record);
      return m_output.Write(formatted);
   }

   //---------------------------------------------------------------
   // Log — Convenience Overload
   // Constructs a minimal SLogRecord for standard system messages.
   // Extended fields (Symbol, Ticket, ErrorCode, Function, Line,
   // Timeframe) remain at their zero/empty defaults.
   // Delegates to the primary API above.
   //---------------------------------------------------------------
   bool Log(const ENUM_LOG_LEVEL level,
            const string         module,
            const string         message)
   {
      SLogRecord record;
      ZeroMemory(record);
      record.Timestamp = TimeCurrent();
      record.Level     = level;
      record.Module    = module;
      record.Message   = message;

      return this.Log(record);
   }

protected:
   ILogFormatter* Formatter() const
   {
      return m_formatter;
   }

   ILogOutput* Output() const
   {
      return m_output;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_LOGGER_MQH