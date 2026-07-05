//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Module.mqh                                             |
//| Purpose : Base contract for all framework modules — standardizes |
//|           CContext injection so every Trading/Risk/AI module     |
//|           gets consistent service access via one virtual chain   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_MODULE_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_MODULE_MQH

#include "../Core/Base/BaseObject.mqh"
#include "Context.mqh"

//+------------------------------------------------------------------+
//| Class CModule                                                    |
//| Description:                                                     |
//|   Base class for every framework module (Engine, and future      |
//|   Trading/Risk/AI modules). Owns no memory — m_context is a      |
//|   non-owning pointer injected by whoever calls Initialize().     |
//|                                                                  |
//|   IMPORTANT: any derived class that needs context during         |
//|   initialization must override Initialize(CContext*) with this   |
//|   EXACT signature. A different parameter list does not override  |
//|   this method — it hides it, and CModuleManager's polymorphic    |
//|   call would silently invoke this base version instead. See      |
//|   CHANGELOG.md, the Engine.mqh signature-hiding fix.              |
//+------------------------------------------------------------------+
class CModule : public CBaseObject
{
protected:

   CContext *m_context;   // non-owning; injected via Initialize()

public:

   CModule(const string name = "CModule")
      : CBaseObject(name)
   {
      m_context = NULL;
   }

   virtual bool Initialize(CContext *context)
   {
      if(context == NULL)
         return false;

      if(!context.IsValid())
         return false;

      m_context = context;

      return CBaseObject::Initialize();
   }

   virtual void Shutdown()
   {
      m_context = NULL;
      CBaseObject::Shutdown();
   }

   virtual bool Update()
   {
      return m_initialized;
   }

   virtual void Reset()
   {
   }

   const CContext *Context() const
   {
      return m_context;
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_MODULE_MQH