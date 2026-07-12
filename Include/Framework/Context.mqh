//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Framework                                              |
//| File    : Context.mqh                                            |
//| Purpose : Shared service locator — bundles Platform, Logger, and |
//|           ErrorHandler for injection into Framework modules      |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.13                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH
#define AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH

#include "../Core/Platform.mqh"
#include "../Core/Logging/Logger.mqh"
#include "../Core/Error/ErrorHandler.mqh"
#include "../Core/Types.mqh"

class CMarketSnapshot
{
public:
   double          FastEMA;
   double          SlowEMA;
   double          ATR;
   double          ADX;
   double          PlusDI;
   double          MinusDI;
   ETrendDirection TrendDirection;
   double          Spread;
   double          Volume;
   bool            DataReady;
   bool            IsReady;

   // Bollinger Bands
   double          BBUpper;
   double          BBMiddle;
   double          BBLower;

   CMarketSnapshot()
   {
      FastEMA        = 0.0;
      SlowEMA        = 0.0;
      ATR            = 0.0;
      ADX            = 0.0;
      PlusDI         = 0.0;
      MinusDI        = 0.0;
      TrendDirection = TREND_UNKNOWN;
      Spread         = 0.0;
      Volume         = 0.0;
      DataReady      = false;
      IsReady        = false;

      BBUpper        = 0.0;
      BBMiddle       = 0.0;
      BBLower        = 0.0;
   }
};

class CContext
{
private:
   CPlatform        *m_platform;
   CLogger          *m_logger;
   CErrorHandler    *m_errorHandler;
   CMarketSnapshot   m_snapshot;

public:
   CContext()
   {
      m_platform     = NULL;
      m_logger       = NULL;
      m_errorHandler = NULL;
   }

   void SetPlatform(CPlatform *platform)           { m_platform = platform; }
   void SetLogger(CLogger *logger)                 { m_logger = logger; }
   void SetErrorHandler(CErrorHandler *handler)    { m_errorHandler = handler; }

   CPlatform* Platform() const                     { return m_platform; }
   CLogger* Logger() const                         { return m_logger; }
   CErrorHandler* ErrorHandler() const              { return m_errorHandler; }

   bool IsValid() const
   {
      return (m_platform != NULL && m_logger != NULL && m_errorHandler != NULL);
   }

   CMarketSnapshot* Snapshot()
   {
      return GetPointer(m_snapshot);
   }
};

#endif // AI_SWINGBREAKOUT_FRAMEWORK_CONTEXT_MQH