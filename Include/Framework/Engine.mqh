//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Engine.mqh                                             |
//| Purpose : Top-level orchestration module. Extension point for    |
//|           engine-specific lifecycle behavior beyond CModule's    |
//|           defaults, once Trading/Risk/AI modules exist to drive. |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH

#include "Module.mqh"
#include "Context.mqh"

//+------------------------------------------------------------------+
//| Class CEngine                                                    |
//| Description:                                                     |
//|   Inherits Initialize(CContext*), Shutdown(), and Context()      |
//|   directly from CModule — no need to redeclare m_context or      |
//|   override those methods here. Previously this class declared    |
//|   its own Initialize(CContext*) alongside CModule's Initialize() |
//|   (no arguments); different parameter lists meant it never       |
//|   actually overrode the base, so CModuleManager's polymorphic    |
//|   call silently invoked the wrong one. Fixed by moving CContext  |
//|   handling into CModule itself. See CHANGELOG.md.                |
//+------------------------------------------------------------------+
class CEngine : public CModule
{
public:

   CEngine(const string name = "CEngine")
      : CModule(name)
   {
   }

   // Extension point: override here once the engine has real
   // per-tick orchestration logic (driving Trading/Risk/AI modules).
   // For now, the inherited CModule::Update() behavior is sufficient.
   virtual bool Update()
   {
      return CModule::Update();
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_ENGINE_MQH