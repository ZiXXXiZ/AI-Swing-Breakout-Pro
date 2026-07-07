//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : JournalLogOutput.mqh                                   |
//| Purpose : ILogOutput implementation that writes to the MT5       |
//|           Experts Journal via Print()                            |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_JOURNALLOGOUTPUT_MQH
#define AI_SWINGBREAKOUT_CORE_JOURNALLOGOUTPUT_MQH

#include "Interfaces/ILogOutput.mqh"

//+------------------------------------------------------------------+
//| Journal Log Output                                               |
//+------------------------------------------------------------------+
class CJournalLogOutput : public ILogOutput
{
public:

   //---------------------------------------------------------------
   // Constructor
   //---------------------------------------------------------------
   CJournalLogOutput()
   {
   }

   //---------------------------------------------------------------
   // Destructor
   //---------------------------------------------------------------
   virtual ~CJournalLogOutput()
   {
   }

   //---------------------------------------------------------------
   // Write message
   //---------------------------------------------------------------
   virtual bool Write(const string &text) override
   {
      Print(text);
      return true;
   }

   //---------------------------------------------------------------
   // Flush
   //---------------------------------------------------------------
   virtual void Flush() override
   {
      // MT5 Journal is flushed automatically.
   }

   //---------------------------------------------------------------
   // Close
   //---------------------------------------------------------------
   virtual void Close() override
   {
      // Nothing to close.
   }
};

#endif // AI_SWINGBREAKOUT_CORE_JOURNALLOGOUTPUT_MQH