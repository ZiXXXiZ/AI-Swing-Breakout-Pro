//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Indicators                                             |
//| File    : ADXIndicator.mqh                                       |
//| Purpose : ADX indicator — average directional movement index,    |
//|           plus/minus DI lines, and derived trend direction.      |
//|           Writes all values into the shared market snapshot.     |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.4                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_INDICATORS_ADXINDICATOR_MQH
#define AI_SWINGBREAKOUT_INDICATORS_ADXINDICATOR_MQH

#include "IndicatorBase.mqh"
#include "../Core/Types.mqh"
#include "../Core/MathUtils.mqh"

//+------------------------------------------------------------------+
//| Class CADXIndicator                                              |
//| Description:                                                     |
//|   Computes the Average Directional Movement Index (ADX), along   |
//|   with the Plus DI and Minus DI lines. Period is set via         |
//|   constructor. On each Update() call the latest values are       |
//|   copied from the indicator handle and written into the shared   |
//|   CMarketSnapshot (ADX, PlusDI, MinusDI, TrendDirection).        |
//|                                                                  |
//|   Trend derivation:                                              |
//|     PlusDI > MinusDI  → TREND_UP                                 |
//|     MinusDI > PlusDI  → TREND_DOWN                               |
//|     otherwise         → TREND_SIDEWAYS                           |
//+------------------------------------------------------------------+
class CADXIndicator : public CIndicatorBase
{
private:
   int             m_period;
   double          m_adx;
   double          m_plusDI;
   double          m_minusDI;
   ETrendDirection m_trend;

public:
   //--------------------------------------------------------------
   // Constructor
   //--------------------------------------------------------------
   CADXIndicator(const int period,
                 const ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
      : CIndicatorBase("CADXIndicator", timeframe)
   {
      m_period  = period;
      m_adx     = 0.0;
      m_plusDI  = 0.0;
      m_minusDI = 0.0;
      m_trend   = TREND_UNKNOWN;
   }

   //--------------------------------------------------------------
   // Accessors
   //--------------------------------------------------------------
   double          ADX()     const { return m_adx; }
   double          PlusDI()  const { return m_plusDI; }
   double          MinusDI() const { return m_minusDI; }
   ETrendDirection Trend()   const { return m_trend; }

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
bool CADXIndicator::CreateHandle()
{
   m_handle = iADX(m_symbol, m_timeframe, m_period);
   return (m_handle != INVALID_HANDLE);
}

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CADXIndicator::Update()
{
   if(!IsReady())
      return false;

   double bufADX[], bufPlusDI[], bufMinusDI[];

   ArraySetAsSeries(bufADX, true);
   ArraySetAsSeries(bufPlusDI, true);
   ArraySetAsSeries(bufMinusDI, true);

   // ADX buffer index 0, PlusDI index 1, MinusDI index 2
   if(CopyBuffer(m_handle, 0, 0, 1, bufADX) < 1)
      return false;
   if(CopyBuffer(m_handle, 1, 0, 1, bufPlusDI) < 1)
      return false;
   if(CopyBuffer(m_handle, 2, 0, 1, bufMinusDI) < 1)
      return false;

   m_adx     = bufADX[0];
   m_plusDI  = bufPlusDI[0];
   m_minusDI = bufMinusDI[0];

   // Determine trend direction
   if(m_plusDI > m_minusDI)
      m_trend = TREND_UP;
   else if(m_minusDI > m_plusDI)
      m_trend = TREND_DOWN;
   else
      m_trend = TREND_SIDEWAYS;

   // Write into the shared market snapshot
   CMarketSnapshot *snap = m_context.Snapshot();
   snap.ADX            = m_adx;
   snap.PlusDI         = m_plusDI;
   snap.MinusDI        = m_minusDI;
   snap.TrendDirection = m_trend;

   return true;
}

//+------------------------------------------------------------------+
//| Shutdown                                                         |
//+------------------------------------------------------------------+
void CADXIndicator::Shutdown()
{
   // Base releases m_handle
   CIndicatorBase::Shutdown();
}

//+------------------------------------------------------------------+
//| IsReady                                                          |
//+------------------------------------------------------------------+
bool CADXIndicator::IsReady() const
{
   return (m_handle != INVALID_HANDLE && BarsCalculated(m_handle) > 0);
}

#endif // AI_SWINGBREAKOUT_INDICATORS_ADXINDICATOR_MQH