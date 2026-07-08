//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : ATRIndicator.mqh                                       |
//| Purpose : Average True Range indicator — reads ATR period from   |
//|           config, writes value into shared market snapshot        |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_ATRINDICATOR_MQH
#define AI_SWINGBREAKOUT_INDICATORS_ATRINDICATOR_MQH

#include "IndicatorBase.mqh"
#include "../Core/Types.mqh"
#include "../Core/MathUtils.mqh"

//+------------------------------------------------------------------+
//| Class CATRIndicator                                              |
//| Description:                                                     |
//|   Computes the Average True Range for the chart symbol and       |
//|   timeframe. The period is set via constructor and is immutable. |
//|   On each Update() call the latest ATR value is copied from the  |
//|   indicator handle and written into CMarketSnapshot.ATR.         |
//+------------------------------------------------------------------+
class CATRIndicator : public CIndicatorBase
{
private:
   int    m_period;
   double m_value;

public:
   //--------------------------------------------------------------
   // Constructor
   //--------------------------------------------------------------
   CATRIndicator(const int period,
                 const ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
      : CIndicatorBase("CATRIndicator", timeframe)
   {
      m_period = period;
      m_value  = 0.0;
   }

   //--------------------------------------------------------------
   // Accessors
   //--------------------------------------------------------------
   double Value() const { return m_value; }

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
bool CATRIndicator::CreateHandle()
{
   m_handle = iATR(m_symbol, m_timeframe, m_period);
   return (m_handle != INVALID_HANDLE);
}

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CATRIndicator::Update()
{
   if(!IsReady())
      return false;

   double buf[];
   ArraySetAsSeries(buf, true);

   if(CopyBuffer(m_handle, 0, 0, 1, buf) < 1)
      return false;

   m_value = buf[0];

   // Write directly into the shared market snapshot
   CMarketSnapshot *snap = m_context.Snapshot();
   snap.ATR = m_value;

   return true;
}

//+------------------------------------------------------------------+
//| Shutdown                                                         |
//+------------------------------------------------------------------+
void CATRIndicator::Shutdown()
{
   // Base releases m_handle
   CIndicatorBase::Shutdown();
}

//+------------------------------------------------------------------+
//| IsReady                                                          |
//+------------------------------------------------------------------+
bool CATRIndicator::IsReady() const
{
   return (m_handle != INVALID_HANDLE && BarsCalculated(m_handle) > 0);
}

#endif // AI_SWINGBREAKOUT_INDICATORS_ATRINDICATOR_MQH