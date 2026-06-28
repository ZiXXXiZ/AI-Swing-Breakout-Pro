//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : JournalLogOutput.mqh                                   |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Writes formatted log messages to the MT5 Journal.              |
//+------------------------------------------------------------------+
#ifndef __JOURNALLOGOUTPUT_MQH__
#define __JOURNALLOGOUTPUT_MQH__

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

#endif // __JOURNALLOGOUTPUT_MQH__
