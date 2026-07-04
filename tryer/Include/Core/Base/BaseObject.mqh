//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : BaseObject.mqh                                         |
//| Version : 2.0.0-alpha.2                                          |
//| Author  : OpenAI & Project Team                                  |
//|                                                                  |
//| Purpose:                                                         |
//|   Base class for all framework objects.                          |
//|                                                                  |
//| Design Principles:                                               |
//|   - Minimal responsibilities                                     |
//|   - No logger dependency                                         |
//|   - No configuration dependency                                  |
//|   - No trading logic                                             |
//|   - Safe inheritance                                             |
//+------------------------------------------------------------------+
#ifndef __BASEOBJECT_MQH__
#define __BASEOBJECT_MQH__

class CBaseObject
{
protected:

   string m_className;
   bool   m_initialized;

public:

   // Constructor
   CBaseObject(const string className = "CBaseObject")
   {
      m_className  = className;
      m_initialized = false;
   }

   // Virtual destructor
   virtual ~CBaseObject() {}

   // Initialize object
   virtual bool Initialize()
   {
      m_initialized = true;
      return true;
   }

   // Shutdown object
   virtual void Shutdown()
   {
      m_initialized = false;
   }

   // Returns initialization state
   bool IsInitialized() const
   {
      return m_initialized;
   }

   // Returns class name
   string ClassName() const
   {
      return m_className;
   }

   // Sets class name
   void SetClassName(const string className)
   {
      m_className = className;
   }
};

#endif // __BASEOBJECT_MQH__