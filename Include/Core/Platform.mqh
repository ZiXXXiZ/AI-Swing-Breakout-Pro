//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : Platform.mqh                                           |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_PLATFORM_MQH
#define AI_SWINGBREAKOUT_CORE_PLATFORM_MQH

#include "Base/BaseObject.mqh"
#include "Config.mqh"
#include "Constants.mqh"
#include "Types.mqh"
#include "Version.mqh"

class CPlatform : public CBaseObject
{
private:
   CConfig *m_config;

public:

   CPlatform()
      : CBaseObject("CPlatform")
   {
      m_config = NULL;
   }

   bool Initialize(CConfig *config)
   {
      if(!CBaseObject::Initialize())
         return false;

      if(config == NULL)
         return false;

      m_config = config;

      return ValidatePlatform();
   }

   void Shutdown()
   {
      m_config = NULL;
      CBaseObject::Shutdown();
   }

   //==============================================================
   // Terminal Info
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
   // Account Info
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
   // Framework Identity
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
   // Config Access
   //==============================================================
   const CConfig* Config() const
   {
      return m_config;
   }

private:

   bool ValidatePlatform()
   {
      if(m_config == NULL)
         return false;

      return m_config.Validate();
   }
};

#endif