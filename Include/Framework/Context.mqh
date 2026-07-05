//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Context.mqh                                            |
//| Purpose : Shared service locator — bundles Platform, Logger, and |
//|           ErrorHandler for injection into Framework modules      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH

#include "../Core/Platform.mqh"
#include "../Core/Logging/Logger.mqh"
#include "../Core/Error/ErrorHandler.mqh"

//+------------------------------------------------------------------+
//| Class CContext                                                   |
//| Description:                                                     |
//|   Non-owning bundle of shared services (Platform, Logger,        |
//|   ErrorHandler). Constructed and wired by the composition root   |
//|   (main EA), then injected into every CModule via Initialize().  |
//|   CContext does not create or delete the services it holds.      |
//+------------------------------------------------------------------+
class CContext
{
private:

   CPlatform     *m_platform;
   CLogger       *m_logger;
   CErrorHandler *m_errorHandler;

public:

   CContext()
   {
      m_platform     = NULL;
      m_logger       = NULL;
      m_errorHandler = NULL;
   }

   //--------------------------------------------------------------
   // Setters (composition-root use only)
   //--------------------------------------------------------------

   void SetPlatform(CPlatform *platform)
   {
      m_platform = platform;
   }

   void SetLogger(CLogger *logger)
   {
      m_logger = logger;
   }

   void SetErrorHandler(CErrorHandler *handler)
   {
      m_errorHandler = handler;
   }

   //--------------------------------------------------------------
   // Getters
   // Marked const so CModule::Context() can safely return a
   // const CContext* — modules can use every service reachable
   // through these getters, but cannot call SetPlatform/SetLogger/
   // SetErrorHandler to rewire the shared context out from under
   // the rest of the framework.
   //--------------------------------------------------------------

   CPlatform* Platform() const
   {
      return m_platform;
   }

   CLogger* Logger() const
   {
      return m_logger;
   }

   CErrorHandler* ErrorHandler() const
   {
      return m_errorHandler;
   }

   //--------------------------------------------------------------
   // Validation
   //--------------------------------------------------------------

   bool IsValid() const
   {
      return (m_platform != NULL &&
              m_logger != NULL &&
              m_errorHandler != NULL);
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH