//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : Logger.mqh                                             |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Central logging coordinator.                                   |
//|                                                                  |
//| Responsibilities                                                 |
//|   • Manage logging configuration                                 |
//|   • Coordinate formatter/output                                  |
//|   • Apply log level filtering                                    |
//|                                                                  |
//| Does NOT                                                         |
//|   • Format text                                                   |
//|   • Print messages                                                |
//|   • Own formatter/output objects                                  |
//+------------------------------------------------------------------+
#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

#include "../Base/BaseObject.mqh"

#include "LogLevel.mqh"
#include "LogRecord.mqh"

#include "Interfaces/ILogFormatter.mqh"
#include "Interfaces/ILogOutput.mqh"

//+------------------------------------------------------------------+
//| Logger                                                           |
//+------------------------------------------------------------------+
class CLogger : public CBaseObject
{
private:

   bool             m_enabled;
   ENUM_LOG_LEVEL   m_level;

   ILogFormatter   *m_formatter;
   ILogOutput      *m_output;

public:

   //---------------------------------------------------------------
   // Constructor
   //---------------------------------------------------------------
   CLogger()
      : CBaseObject("CLogger")
   {
      m_enabled  = true;
      m_level    = LOG_INFO;

      m_formatter = NULL;
      m_output    = NULL;
   }

   //---------------------------------------------------------------
   // Destructor
   //---------------------------------------------------------------
   virtual ~CLogger()
   {
      Shutdown();
   }

   //---------------------------------------------------------------
   // Initialize
   //---------------------------------------------------------------
   virtual bool Initialize(
      ILogFormatter *formatter,
      ILogOutput *output)
   {
      if(formatter == NULL)
         return false;

      if(output == NULL)
         return false;

      m_formatter = formatter;
      m_output    = output;

      m_initialized = true;

      return true;
   }

   //---------------------------------------------------------------
   // Shutdown
   //---------------------------------------------------------------
   virtual void Shutdown() override
   {
      m_formatter = NULL;
      m_output    = NULL;

      m_initialized = false;
   }

   //---------------------------------------------------------------
   // Enable / Disable
   //---------------------------------------------------------------
   void Enable(const bool enable)
   {
      m_enabled = enable;
   }

   //---------------------------------------------------------------
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

   //---------------------------------------------------------------
   ENUM_LOG_LEVEL GetLevel() const
   {
      return m_level;
   }

protected:

   //---------------------------------------------------------------
   // Helpers for Stage 2
   //---------------------------------------------------------------
   ILogFormatter* Formatter() const
   {
      return m_formatter;
   }

   //---------------------------------------------------------------
   ILogOutput* Output() const
   {
      return m_output;
   }
};

#endif // __LOGGER_MQH__