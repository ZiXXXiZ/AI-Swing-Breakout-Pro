//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : MarketStructures.mqh                                   |
//| Purpose : Market-related shared structures                       |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_STRUCTURES_MARKETSTRUCTURES_MQH
#define AI_SWINGBREAKOUT_CORE_STRUCTURES_MARKETSTRUCTURES_MQH

// Project Includes
#include "../Types.mqh"

//+------------------------------------------------------------------+
//| Market Tick                                                      |
//+------------------------------------------------------------------+
struct SMarketTick
{
   datetime Time;

   double   Bid;
   double   Ask;
   double   Last;

   ulong    Volume;

   void Reset()
   {
      Time   = 0;

      Bid    = 0.0;
      Ask    = 0.0;
      Last   = 0.0;

      Volume = 0;
   }

   double Spread() const
   {
      return (Ask - Bid);
   }

   bool IsValid() const
   {
      return (Bid > 0.0 && Ask >= Bid);
   }
};

//+------------------------------------------------------------------+
//| Bar Data                                                         |
//+------------------------------------------------------------------+
struct SBarData
{
   datetime Time;

   double Open;
   double High;
   double Low;
   double Close;

   long TickVolume;
   long RealVolume;

   int Spread;

   void Reset()
   {
      Time       = 0;

      Open       = 0.0;
      High       = 0.0;
      Low        = 0.0;
      Close      = 0.0;

      TickVolume = 0;
      RealVolume = 0;

      Spread     = 0;
   }

   bool IsBullish() const
   {
      return (Close > Open);
   }

   bool IsBearish() const
   {
      return (Close < Open);
   }

   double BodySize() const
   {
      return MathAbs(Close - Open);
   }

   double Range() const
   {
      return (High - Low);
   }
};

//+------------------------------------------------------------------+
//| Symbol Information                                               |
//+------------------------------------------------------------------+
struct SSymbolInfo
{
   string Symbol;

   int    Digits;

   double Point;

   double TickSize;
   double TickValue;

   double MinLot;
   double MaxLot;
   double LotStep;

   bool   Tradable;

   void Reset()
   {
      Symbol    = "";

      Digits    = 0;

      Point     = 0.0;

      TickSize  = 0.0;
      TickValue = 0.0;

      MinLot    = 0.0;
      MaxLot    = 0.0;
      LotStep   = 0.0;

      Tradable  = false;
   }
};

//+------------------------------------------------------------------+
//| Symbol State                                                     |
//+------------------------------------------------------------------+
struct SSymbolState
{
   string Symbol;

   bool Selected;
   bool Visible;
   bool Synchronized;
   bool Tradable;

   void Reset()
   {
      Symbol       = "";

      Selected     = false;
      Visible      = false;
      Synchronized = false;
      Tradable     = false;
   }
};

//+------------------------------------------------------------------+
//| Session Information                                              |
//+------------------------------------------------------------------+
struct SSessionInfo
{
   ESessionType Session;

   datetime OpenTime;
   datetime CloseTime;

   bool IsOpen;

   void Reset()
   {
      Session   = SESSION_UNKNOWN;

      OpenTime  = 0;
      CloseTime = 0;

      IsOpen    = false;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_STRUCTURES_MARKETSTRUCTURES_MQH