//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Platform.mqh                                           |
//| Purpose : Platform abstraction — terminal, account, and          |
//|           framework identity access via CPlatform                |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_PLATFORM_MQH
#define AI_SWINGBREAKOUT_CORE_PLATFORM_MQH

#include "Base/BaseObject.mqh"
#include "Config.mqh"
#include "Constants.mqh"
#include "Types.mqh"
#include "Version.mqh"

//+------------------------------------------------------------------+
//| Class CPlatform                                                  |
//| Description:                                                     |
//|   Platform abstraction layer. Wraps terminal, account, and       |
//|   framework identity access, and owns the framework's default    |
//|   configuration instance.                                        |
//+------------------------------------------------------------------+
class CPlatform : public CBaseObject
{
private:

   CConfig m_config;

public:

   //---------------------------------------------------------------
   // Constructor
   //---------------------------------------------------------------
   CPlatform()
      : CBaseObject("CPlatform")
   {
   }

   //---------------------------------------------------------------
   // Initialize
   //---------------------------------------------------------------
   virtual bool Initialize()
   {
      if(!CBaseObject::Initialize())
         return false;

      m_config.LoadDefaults();

      if(!m_config.Validate())
      {
         CBaseObject::Shutdown();
         return false;
      }

      return true;
   }

   //---------------------------------------------------------------
   // Shutdown
   //---------------------------------------------------------------
   virtual void Shutdown()
   {
      CBaseObject::Shutdown();
   }

   //==============================================================
   // Terminal
   //==============================================================

   string TerminalName() const
   {
      return TerminalInfoString(TERMINAL_NAME);
   }

   long TerminalBuild() const
   {
      return (long)TerminalInfoInteger(TERMINAL_BUILD);
   }

   bool IsTradeAllowed() const
   {
      return (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) != 0);
   }

   //==============================================================
   // Account
   //==============================================================

   double Balance() const
   {
      return AccountInfoDouble(ACCOUNT_BALANCE);
   }

   double Equity() const
   {
      return AccountInfoDouble(ACCOUNT_EQUITY);
   }

   double MarginFree() const
   {
      return AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   }

   bool IsDemo() const
   {
      return (AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO);
   }

   bool IsTester() const
   {
      return (MQLInfoInteger(MQL_TESTER) != 0);
   }

   //==============================================================
   // Framework
   //==============================================================

   string ProjectName() const
   {
      return PROJECT_NAME;
   }

   string Version() const
   {
      return PROJECT_VERSION;
   }

   int Build() const
   {
      return PROJECT_BUILD;
   }

   //==============================================================
   // Configuration
   //==============================================================

   bool ValidateConfig()
   {
      return m_config.Validate();
   }

   // Read-only access for other modules (Risk/Trading/AI) that need
   // to consult framework configuration. MQL5 does not support
   // reference return types (Type&) at all, so this returns a
   // pointer via GetPointer() rather than a reference — the pointer
   // is safe because it targets a member CPlatform already owns, not
   // an externally-injected object of unclear lifetime. Intentionally
   // const — see DECISIONS.md if/when Phase 8 (Adaptive Parameters)
   // needs controlled runtime mutation; that should be added as
   // narrow, explicit setters later, not by widening this to
   // non-const.
   const CConfig *Config() const
   {
      return GetPointer(m_config);
   }
};

#endif // AI_SWINGBREAKOUT_CORE_PLATFORM_MQH