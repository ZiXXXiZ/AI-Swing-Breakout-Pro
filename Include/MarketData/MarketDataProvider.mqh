//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : MarketData                                             |
//| File    : MarketDataProvider.mqh                                 |
//| Purpose : Centralized market data acquisition — owns indicator   |
//|           handles for EMA, ATR, ADX, populates the shared        |
//|           CMarketSnapshot with raw values each tick.             |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.11                                         |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_MARKETDATA_MARKETDATAPROVIDER_MQH
#define AI_SWINGBREAKOUT_MARKETDATA_MARKETDATAPROVIDER_MQH

#include "../Framework/Module.mqh"
#include "../Framework/Context.mqh"

class CMarketDataProvider : public CModule
{
private:
   int               m_fastEmaPeriod;
   int               m_slowEmaPeriod;
   int               m_atrPeriod;
   int               m_adxPeriod;
   ENUM_TIMEFRAMES   m_timeframe;

   int               m_handleFastEMA;
   int               m_handleSlowEMA;
   int               m_handleATR;
   int               m_handleADX;

public:
   CMarketDataProvider(const int fastEmaPeriod,
                       const int slowEmaPeriod,
                       const int atrPeriod,
                       const int adxPeriod,
                       const ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
      : CModule("CMarketDataProvider")
   {
      m_fastEmaPeriod = fastEmaPeriod;
      m_slowEmaPeriod = slowEmaPeriod;
      m_atrPeriod     = atrPeriod;
      m_adxPeriod     = adxPeriod;
      m_timeframe     = timeframe;

      m_handleFastEMA = INVALID_HANDLE;
      m_handleSlowEMA = INVALID_HANDLE;
      m_handleATR     = INVALID_HANDLE;
      m_handleADX     = INVALID_HANDLE;
   }

   virtual bool Initialize(CContext *context) override;
   virtual bool Update() override;
   virtual void Shutdown() override;
};

//+------------------------------------------------------------------+
//| Initialize                                                       |
//+------------------------------------------------------------------+
bool CMarketDataProvider::Initialize(CContext *context)
{
   if(!CModule::Initialize(context))
      return false;

   // Create handles — must be done after chart attachment (gotcha #6)
   m_handleFastEMA = iMA(_Symbol, m_timeframe, m_fastEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   if(m_handleFastEMA == INVALID_HANDLE) { Shutdown(); return false; }

   m_handleSlowEMA = iMA(_Symbol, m_timeframe, m_slowEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   if(m_handleSlowEMA == INVALID_HANDLE) { Shutdown(); return false; }

   m_handleATR = iATR(_Symbol, m_timeframe, m_atrPeriod);
   if(m_handleATR == INVALID_HANDLE) { Shutdown(); return false; }

   m_handleADX = iADX(_Symbol, m_timeframe, m_adxPeriod);
   if(m_handleADX == INVALID_HANDLE) { Shutdown(); return false; }

   return true;
}

//+------------------------------------------------------------------+
//| Update                                                           |
//+------------------------------------------------------------------+
bool CMarketDataProvider::Update()
{
   if(!m_initialized || m_context == NULL)
      return false;

   CMarketSnapshot *snap = m_context.Snapshot();
   if(snap == NULL)
      return false;

   // Reset readiness flags for new tick
   snap.IsReady   = false;
   snap.DataReady = false;

   double bufFast[], bufSlow[], bufATR[], bufADX[], bufPlusDI[], bufMinusDI[];
   ArraySetAsSeries(bufFast, true);
   ArraySetAsSeries(bufSlow, true);
   ArraySetAsSeries(bufATR, true);
   ArraySetAsSeries(bufADX, true);
   ArraySetAsSeries(bufPlusDI, true);
   ArraySetAsSeries(bufMinusDI, true);

   bool success = true;

   // Fast EMA
   if(CopyBuffer(m_handleFastEMA, 0, 0, 1, bufFast) < 1)
      success = false;
   else
      snap.FastEMA = bufFast[0];

   // Slow EMA
   if(CopyBuffer(m_handleSlowEMA, 0, 0, 1, bufSlow) < 1)
      success = false;
   else
      snap.SlowEMA = bufSlow[0];

   // ATR
   if(CopyBuffer(m_handleATR, 0, 0, 1, bufATR) < 1)
      success = false;
   else
      snap.ATR = bufATR[0];

   // ADX (three buffers: 0=ADX, 1=+DI, 2=-DI)
   if(CopyBuffer(m_handleADX, 0, 0, 1, bufADX) < 1 ||
      CopyBuffer(m_handleADX, 1, 0, 1, bufPlusDI) < 1 ||
      CopyBuffer(m_handleADX, 2, 0, 1, bufMinusDI) < 1)
      success = false;
   else
   {
      snap.ADX     = bufADX[0];
      snap.PlusDI  = bufPlusDI[0];
      snap.MinusDI = bufMinusDI[0];
   }

   // Spread and Volume (no handle needed)
   snap.Spread = (double)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   snap.Volume = (double)iVolume(_Symbol, m_timeframe, 0);

   snap.DataReady = success;

   return success;
}

//+------------------------------------------------------------------+
//| Shutdown                                                         |
//+------------------------------------------------------------------+
void CMarketDataProvider::Shutdown()
{
   if(m_handleFastEMA != INVALID_HANDLE) { IndicatorRelease(m_handleFastEMA); m_handleFastEMA = INVALID_HANDLE; }
   if(m_handleSlowEMA != INVALID_HANDLE) { IndicatorRelease(m_handleSlowEMA); m_handleSlowEMA = INVALID_HANDLE; }
   if(m_handleATR     != INVALID_HANDLE) { IndicatorRelease(m_handleATR);     m_handleATR     = INVALID_HANDLE; }
   if(m_handleADX     != INVALID_HANDLE) { IndicatorRelease(m_handleADX);     m_handleADX     = INVALID_HANDLE; }

   CModule::Shutdown();
}

#endif // AI_SWINGBREAKOUT_MARKETDATA_MARKETDATAPROVIDER_MQH