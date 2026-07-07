//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Logger.mqh                                             |
//| Purpose : Central logging coordinator — manages configuration,   |
//|           coordinates formatter/output, applies level filtering  |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
//| Responsibilities                                                 |
//|   - Manage logging configuration                                 |
//|   - Coordinate formatter/output                                  |
//|   - Apply log level filtering                                    |
//|                                                                  |
//| Does NOT                                                         |
//|   - Format text                                                   |
//|   - Print messages                                                |
//|   - Own formatter/output objects                                  |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_LOGGER_MQH
#define AI_SWINGBREAKOUT_CORE_LOGGER_MQH

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
   // Configure
   // Renamed from a previous "Initialize(ILogFormatter*, ILogOutput*)"
   // — that name collided with CBaseObject::Initialize() (no
   // parameters). Different parameter lists don't override a base
   // virtual method, they hide it as a separate overload; this is
   // the exact same defect class found and fixed in Engine.mqh (see
   // CHANGELOG.md). Renaming avoids the collision outright. Chains
   // to CBaseObject::Initialize() at the end instead of manually
   // setting m_initialized, consistent with every other module.
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

#endif // AI_SWINGBREAKOUT_CORE_LOGGER_MQH