//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : ModuleManager.mqh                                      |
//| Purpose : Registers framework modules and drives their lifecycle |
//|           (Initialize/Update/Shutdown) in registration order     |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_MODULEMANAGER_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_MODULEMANAGER_MQH

#include "Module.mqh"
#include "Context.mqh"

#define MAX_MODULES 64

//+------------------------------------------------------------------+
//| Class CModuleManager                                             |
//| Description:                                                     |
//|   Owns the registry of modules and drives their lifecycle. Does  |
//|   NOT own the modules themselves — registered CModule pointers   |
//|   are not deleted by this class, in Initialize(), Shutdown(), or |
//|   a destructor. The caller that creates a module is responsible  |
//|   for its lifetime. This mirrors CContext's non-owning design.   |
//+------------------------------------------------------------------+
class CModuleManager
{
private:

   CModule  *m_modules[MAX_MODULES];
   int       m_count;
   CContext *m_context;   // non-owning; supplied via SetContext()

public:

   CModuleManager()
   {
      m_count   = 0;
      m_context = NULL;

      for(int i=0;i<MAX_MODULES;i++)
         m_modules[i]=NULL;
   }

   void SetContext(CContext *context)
   {
      m_context = context;
   }

   bool Register(CModule *module)
   {
      if(module==NULL)
         return false;

      if(m_count>=MAX_MODULES)
         return false;

      m_modules[m_count]=module;
      m_count++;

      return true;
   }

   bool Initialize()
   {
      if(m_context == NULL)
         return false;

      if(!m_context.IsValid())
         return false;

      for(int i=0;i<m_count;i++)
      {
         if(!m_modules[i].Initialize(m_context))
            return false;
      }

      return true;
   }

   void Update()
   {
      for(int i=0;i<m_count;i++)
         m_modules[i].Update();
   }

   void Shutdown()
   {
      for(int i=m_count-1;i>=0;i--)
         m_modules[i].Shutdown();
   }

   int Count() const
   {
      return m_count;
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_MODULEMANAGER_MQH