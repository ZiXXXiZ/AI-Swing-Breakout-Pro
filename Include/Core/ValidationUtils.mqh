//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : ValidationUtils.mqh                                    |
//| Purpose : Stateless validation helpers — pointers, strings,      |
//|           symbols, prices, volumes, handles, array bounds        |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.3                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_VALIDATIONUTILS_MQH
#define AI_SWINGBREAKOUT_CORE_VALIDATIONUTILS_MQH

#include "Constants.mqh"
#include "MathUtils.mqh"

//+------------------------------------------------------------------+
//| Class CValidationUtils                                           |
//| Description:                                                     |
//|   Stateless validation utilities used throughout the framework.  |
//|   Covers pointer/array safety, string/symbol sanity, and         |
//|   broker-data validation (price, volume, handle) built on top    |
//|   of CMathUtils's epsilon-safe comparisons.                      |
//|                                                                  |
//| Notes:                                                           |
//|   - Stateless                                                    |
//|   - Static methods only                                          |
//|   - No global variables                                          |
//|   - No hidden side effects                                       |
//|   - Depends only on Core/Constants.mqh and Core/MathUtils.mqh    |
//|   - Deliberately excludes order/direction-specific validation    |
//|     (e.g. stop-level checks) — that belongs to the future        |
//|     Trading/Risk modules, not Core. See ADR-003.                 |
//|   - IsValidPointer is a template method and is defined inline,   |
//|     not declared-then-defined-outside like CMathUtils — MQL5's   |
//|     template support does not reliably split template member     |
//|     definitions the way it does for ordinary methods.            |
//+------------------------------------------------------------------+
class CValidationUtils
{
public:

   //==============================================================
   // Pointers
   //==============================================================

   template<typename T>
   static bool IsValidPointer(T *ptr)
   {
      return (CheckPointer(ptr) != POINTER_INVALID);
   }

   //==============================================================
   // Strings
   //==============================================================

   static bool IsValidString(const string value)
   {
      return (StringLen(value) > 0);
   }

   //==============================================================
   // Numbers
   //==============================================================

   static bool IsFiniteNumber(const double value)
   {
      return MathIsValidNumber(value);
   }

   static bool IsValidPrice(const double price)
   {
      if(!IsFiniteNumber(price))
         return false;

      return CMathUtils::IsGreater(price, 0.0);
   }

   //==============================================================
   // Arrays
   //==============================================================

   static bool IsValidArraySize(const int size, const int minSize = 1)
   {
      return (size >= minSize);
   }

   static bool IsValidIndex(const int index, const int arraySize)
   {
      return (index >= 0 && index < arraySize);
   }

   //==============================================================
   // Handles / Tickets
   //==============================================================

   static bool IsValidHandle(const int handle)
   {
      return (handle != INVALID_HANDLE);
   }

   static bool IsValidTicket(const ulong ticket)
   {
      return (ticket > 0);
   }

   //==============================================================
   // Broker / Symbol Data
   //==============================================================

   static bool IsValidSymbol(const string symbol)
   {
      if(!IsValidString(symbol))
         return false;

      return (bool)SymbolInfoInteger(symbol, SYMBOL_EXIST);
   }

   static bool IsValidVolume(const string symbol, const double volume)
   {
      if(!IsValidSymbol(symbol))
         return false;

      if(!IsFiniteNumber(volume))
         return false;

      if(!CMathUtils::IsGreater(volume, 0.0))
         return false;

      const double minVol  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
      const double maxVol  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
      const double stepVol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

      if(CMathUtils::IsLess(volume, minVol))
         return false;

      if(CMathUtils::IsGreater(volume, maxVol))
         return false;

      // Confirm volume lands on a valid step from the minimum,
      // reusing CMathUtils::RoundToStep rather than duplicating
      // the rounding logic here.
      if(CMathUtils::IsGreater(stepVol, 0.0))
      {
         const double aligned = minVol + CMathUtils::RoundToStep(volume - minVol, stepVol);

         if(!CMathUtils::IsEqual(volume, aligned, CConstants::VOLUME_EPSILON))
            return false;
      }

      return true;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_VALIDATIONUTILS_MQH