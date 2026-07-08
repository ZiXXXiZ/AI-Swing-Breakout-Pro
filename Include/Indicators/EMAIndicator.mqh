//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : EMAIndicator.mqh                                       |
//| Purpose : Dual-EMA indicator — fast and slow exponential moving  |
//|           averages, writes values into the shared market snapshot|
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_EMAINDICATOR_MQH
#define AI_SWINGBREAKOUT_INDICATORS_EMAINDICATOR_MQH

#include "IndicatorBase.mqh"
#include "../Core/Types.mqh"
#include "../Core/MathUtils.mqh"

//+------------------------------------------------------------------+
//| Class CEMAIndicator                                              |
//| Description:                                                     |
//|   Computes two exponential moving averages (fast and slow) from  |
//|   the chart symbol and timeframe. Periods are set via constructor|
//|   (immutable after construction). On each Update() call the      |
//|   latest values are copied from the indicator handles and written|
//|   directly into CMarketSnapshot.FastEMA / SlowEMA.               |
//+------------------------------------------------------------------+
class CEMAIndicator : public CIndicatorBase
{
private:
   int    m_fastPeriod;
   int    m_slowPeriod;
   int    m_handleFast;
   int    m_handleSlow;
   double m_fastValue;
   double m_slowValue;

public:
   //--------------------------------------------------------------
   // Constructor
   //--------------------------------------------------------------
   CEMAIndicator(const int fastPeriod,
                 const int slowPeriod,
                 const ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
      : CIndicatorBase("CEMAIndicator", timeframe)
   {
      m_fastPeriod = fastPeriod;
      m_slowPeriod = slowPeriod;
      m_handleFast = INVALID_HANDLE;
      m_handleSlow = INVALID_HANDLE;
      m_fastValue  = 0.0;
      m_slowValue  = 0.0;
   }

   //--------------------------------------------------------------
   // Accessors
   //--------------------------------------------------------------
   double FastValue() const { return m_fastValue; }
   double SlowValue() const { return m_slowValue; }

   //--------------------------------------------------------------
   // Overrides
   //--------------------------------------------------------------
   virtual bool Update() override;
   virtual void Shutdown() override;
   virtual bool IsReady() const override;

protected:
   virtual bool CreateHandle() override;
};

//+------------------------------------------------------------------+
//| CreateHandle                                                     |
//+------------------------------------------------------------------+
bool CEMAIndicator::CreateHandle()
{
   m_handleFast = iMA(m_symbol, m_timeframe, m_fastPeriod, 0, MODE_EMA, PRICE_CLOSE);
   m_handleSlow = iMA(m_symbol, m_timeframe, m_slowPeriod, 0, MODE_EMA, PRICE_CLOSE);

   // Base IsReady() checks m_handle — point it at the fast handle
   m_handle = m_handleFast;

   return (m_handleFast != INVALID_HANDLE && m_handleSlow != INVALID_HANDLE);
}

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CEMAIndicator::Update()
{
   // Both handles must exist and have calculated data
   if(!IsReady())
      return false;

   double bufFast[], bufSlow[];

   ArraySetAsSeries(bufFast, true);
   ArraySetAsSeries(bufSlow, true);

   if(CopyBuffer(m_handleFast, 0, 0, 1, bufFast) < 1)
      return false;

   if(CopyBuffer(m_handleSlow, 0, 0, 1, bufSlow) < 1)
      return false;

   m_fastValue = bufFast[0];
   m_slowValue = bufSlow[0];

   // Write directly into the shared market snapshot
   CMarketSnapshot *snap = m_context.Snapshot();
   snap.FastEMA = m_fastValue;
   snap.SlowEMA = m_slowValue;

   return true;
}

//+------------------------------------------------------------------+
//| Shutdown                                                         |
//+------------------------------------------------------------------+
void CEMAIndicator::Shutdown()
{
   if(m_handleSlow != INVALID_HANDLE)
   {
      IndicatorRelease(m_handleSlow);
      m_handleSlow = INVALID_HANDLE;
   }

   // Base releases m_handle (which points to m_handleFast)
   CIndicatorBase::Shutdown();
}

//+------------------------------------------------------------------+
//| IsReady                                                          |
//+------------------------------------------------------------------+
bool CEMAIndicator::IsReady() const
{
   return (m_handleFast != INVALID_HANDLE &&
           m_handleSlow != INVALID_HANDLE &&
           BarsCalculated(m_handleFast) > 0 &&
           BarsCalculated(m_handleSlow) > 0);
}

#endif // AI_SWINGBREAKOUT_INDICATORS_EMAINDICATOR_MQH