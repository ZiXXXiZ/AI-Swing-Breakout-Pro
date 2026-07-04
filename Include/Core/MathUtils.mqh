//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : MathUtils.mqh                                          |
//| Purpose : Stateless mathematical and numeric utility functions   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_MATHUTILS_MQH
#define AI_SWINGBREAKOUT_CORE_MATHUTILS_MQH

#include "Constants.mqh"

//+------------------------------------------------------------------+
//| Class CMathUtils                                                 |
//| Description:                                                     |
//|   Stateless mathematical utility functions used throughout the   |
//|   framework. Covers floating-point comparison, clamping,         |
//|   normalization, basic statistics and safe arithmetic.           |
//|                                                                  |
//| Notes:                                                           |
//|   - Stateless                                                    |
//|   - Static methods only                                          |
//|   - No global variables                                          |
//|   - No hidden side effects                                       |
//|   - Depends only on Core/Constants.mqh                           |
//+------------------------------------------------------------------+
class CMathUtils
{
public:

   //==============================================================
   // Floating Point Comparison
   //==============================================================

   static bool   IsEqual(const double a, const double b);
   static bool   IsEqual(const double a, const double b, const double epsilon);
   static bool   IsZero(const double value);
   static bool   IsZero(const double value, const double epsilon);
   static bool   IsGreater(const double a, const double b);
   static bool   IsGreater(const double a, const double b, const double epsilon);
   static bool   IsLess(const double a, const double b);
   static bool   IsLess(const double a, const double b, const double epsilon);
   static bool   IsGreaterOrEqual(const double a, const double b);
   static bool   IsGreaterOrEqual(const double a, const double b, const double epsilon);
   static bool   IsLessOrEqual(const double a, const double b);
   static bool   IsLessOrEqual(const double a, const double b, const double epsilon);

   //==============================================================
   // Range Utilities
   //==============================================================

   static double Clamp(const double value, const double minValue, const double maxValue);
   static int    ClampInt(const int value, const int minValue, const int maxValue);
   static bool   IsBetween(const double value, const double minValue, const double maxValue);
   static bool   IsBetween(const double value, const double minValue, const double maxValue, const double epsilon);
   static double MapRange(const double value, const double inMin, const double inMax, const double outMin, const double outMax);

   //==============================================================
   // Rounding & Normalization
   //==============================================================

   static double NormalizeToDigits(const double value, const int digits);
   static double RoundToStep(const double value, const double step);
   static int    Sign(const double value);
   static int    Sign(const double value, const double epsilon);

   //==============================================================
   // Safe Arithmetic
   //==============================================================

   static double SafeDivide(const double numerator, const double denominator, const double fallback = 0.0);
   static double SafeSqrt(const double value, const double fallback = 0.0);
   static double SafeLog(const double value, const double fallback = 0.0);
   static double SafeLog10(const double value, const double fallback = 0.0);

   //==============================================================
   // Percentage Utilities
   //==============================================================

   static double PercentOf(const double value, const double percent);
   static double PercentChange(const double oldValue, const double newValue, const double fallback = 0.0);

   //==============================================================
   // Angle Conversion
   //==============================================================

   static double DegreesToRadians(const double degrees);
   static double RadiansToDegrees(const double radians);

   //==============================================================
   // Basic Statistics (array-based)
   //==============================================================

   static double Sum(const double &values[]);
   static double Mean(const double &values[], const double fallback = 0.0);
   static double Min(const double &values[], const double fallback = 0.0);
   static double Max(const double &values[], const double fallback = 0.0);
   static double Variance(const double &values[], const bool sampleVariance = true, const double fallback = 0.0);
   static double StdDev(const double &values[], const bool sampleVariance = true, const double fallback = 0.0);
   static double Median(const double &values[], const double fallback = 0.0);

private:

   //==============================================================
   // Internal Helpers
   //==============================================================

   static void   SortAscending(double &values[]);
};

//+------------------------------------------------------------------+
//| Floating Point Comparison                                        |
//+------------------------------------------------------------------+

bool CMathUtils::IsEqual(const double a, const double b)
{
   return IsEqual(a, b, CConstants::EPSILON);
}

bool CMathUtils::IsEqual(const double a, const double b, const double epsilon)
{
   return (MathAbs(a - b) <= epsilon);
}

bool CMathUtils::IsZero(const double value)
{
   return IsZero(value, CConstants::EPSILON);
}

bool CMathUtils::IsZero(const double value, const double epsilon)
{
   return (MathAbs(value) <= epsilon);
}

bool CMathUtils::IsGreater(const double a, const double b)
{
   return IsGreater(a, b, CConstants::EPSILON);
}

bool CMathUtils::IsGreater(const double a, const double b, const double epsilon)
{
   return ((a - b) > epsilon);
}

bool CMathUtils::IsLess(const double a, const double b)
{
   return IsLess(a, b, CConstants::EPSILON);
}

bool CMathUtils::IsLess(const double a, const double b, const double epsilon)
{
   return ((b - a) > epsilon);
}

bool CMathUtils::IsGreaterOrEqual(const double a, const double b)
{
   return IsGreaterOrEqual(a, b, CConstants::EPSILON);
}

bool CMathUtils::IsGreaterOrEqual(const double a, const double b, const double epsilon)
{
   return (!IsLess(a, b, epsilon));
}

bool CMathUtils::IsLessOrEqual(const double a, const double b)
{
   return IsLessOrEqual(a, b, CConstants::EPSILON);
}

bool CMathUtils::IsLessOrEqual(const double a, const double b, const double epsilon)
{
   return (!IsGreater(a, b, epsilon));
}

//+------------------------------------------------------------------+
//| Range Utilities                                                  |
//+------------------------------------------------------------------+

double CMathUtils::Clamp(const double value, const double minValue, const double maxValue)
{
   if(minValue > maxValue)
      return value;

   if(value < minValue)
      return minValue;

   if(value > maxValue)
      return maxValue;

   return value;
}

int CMathUtils::ClampInt(const int value, const int minValue, const int maxValue)
{
   if(minValue > maxValue)
      return value;

   if(value < minValue)
      return minValue;

   if(value > maxValue)
      return maxValue;

   return value;
}

bool CMathUtils::IsBetween(const double value, const double minValue, const double maxValue)
{
   return IsBetween(value, minValue, maxValue, CConstants::EPSILON);
}

bool CMathUtils::IsBetween(const double value, const double minValue, const double maxValue, const double epsilon)
{
   const double lower = MathMin(minValue, maxValue);
   const double upper = MathMax(minValue, maxValue);

   return (IsGreaterOrEqual(value, lower, epsilon) && IsLessOrEqual(value, upper, epsilon));
}

double CMathUtils::MapRange(const double value, const double inMin, const double inMax, const double outMin, const double outMax)
{
   const double inRange = inMax - inMin;

   if(IsZero(inRange))
      return outMin;

   const double ratio = (value - inMin) / inRange;

   return outMin + (ratio * (outMax - outMin));
}

//+------------------------------------------------------------------+
//| Rounding & Normalization                                         |
//+------------------------------------------------------------------+

double CMathUtils::NormalizeToDigits(const double value, const int digits)
{
   const int safeDigits = ClampInt(digits, 0, 15);

   return NormalizeDouble(value, safeDigits);
}

double CMathUtils::RoundToStep(const double value, const double step)
{
   if(IsZero(step))
      return value;

   const double steps = MathRound(value / step);

   return steps * step;
}

int CMathUtils::Sign(const double value)
{
   return Sign(value, CConstants::EPSILON);
}

int CMathUtils::Sign(const double value, const double epsilon)
{
   if(IsZero(value, epsilon))
      return 0;

   return (value > 0.0) ? 1 : -1;
}

//+------------------------------------------------------------------+
//| Safe Arithmetic                                                  |
//+------------------------------------------------------------------+

double CMathUtils::SafeDivide(const double numerator, const double denominator, const double fallback)
{
   if(IsZero(denominator))
      return fallback;

   return (numerator / denominator);
}

double CMathUtils::SafeSqrt(const double value, const double fallback)
{
   if(IsLess(value, 0.0))
      return fallback;

   return MathSqrt(value);
}

double CMathUtils::SafeLog(const double value, const double fallback)
{
   if(IsLessOrEqual(value, 0.0))
      return fallback;

   return MathLog(value);
}

double CMathUtils::SafeLog10(const double value, const double fallback)
{
   if(IsLessOrEqual(value, 0.0))
      return fallback;

   return MathLog10(value);
}

//+------------------------------------------------------------------+
//| Percentage Utilities                                             |
//+------------------------------------------------------------------+

double CMathUtils::PercentOf(const double value, const double percent)
{
   return value * (percent / 100.0);
}

double CMathUtils::PercentChange(const double oldValue, const double newValue, const double fallback)
{
   if(IsZero(oldValue))
      return fallback;

   return ((newValue - oldValue) / MathAbs(oldValue)) * 100.0;
}

//+------------------------------------------------------------------+
//| Angle Conversion                                                 |
//+------------------------------------------------------------------+

double CMathUtils::DegreesToRadians(const double degrees)
{
   return degrees * CConstants::DEG_TO_RAD;
}

double CMathUtils::RadiansToDegrees(const double radians)
{
   return radians * CConstants::RAD_TO_DEG;
}

//+------------------------------------------------------------------+
//| Basic Statistics (array-based)                                   |
//+------------------------------------------------------------------+

double CMathUtils::Sum(const double &values[])
{
   const int count = ArraySize(values);

   double total = 0.0;

   for(int i = 0; i < count; i++)
      total += values[i];

   return total;
}

double CMathUtils::Mean(const double &values[], const double fallback)
{
   const int count = ArraySize(values);

   if(count <= 0)
      return fallback;

   return SafeDivide(Sum(values), (double)count, fallback);
}

double CMathUtils::Min(const double &values[], const double fallback)
{
   const int count = ArraySize(values);

   if(count <= 0)
      return fallback;

   double result = values[0];

   for(int i = 1; i < count; i++)
   {
      if(values[i] < result)
         result = values[i];
   }

   return result;
}

double CMathUtils::Max(const double &values[], const double fallback)
{
   const int count = ArraySize(values);

   if(count <= 0)
      return fallback;

   double result = values[0];

   for(int i = 1; i < count; i++)
   {
      if(values[i] > result)
         result = values[i];
   }

   return result;
}

double CMathUtils::Variance(const double &values[], const bool sampleVariance, const double fallback)
{
   const int count = ArraySize(values);

   if(count <= 0)
      return fallback;

   const int denominatorCount = sampleVariance ? (count - 1) : count;

   if(denominatorCount <= 0)
      return fallback;

   const double mean = Mean(values, fallback);

   double sumSquaredDiff = 0.0;

   for(int i = 0; i < count; i++)
   {
      const double diff = values[i] - mean;
      sumSquaredDiff += (diff * diff);
   }

   return SafeDivide(sumSquaredDiff, (double)denominatorCount, fallback);
}

double CMathUtils::StdDev(const double &values[], const bool sampleVariance, const double fallback)
{
   const double variance = Variance(values, sampleVariance, fallback);

   return SafeSqrt(variance, fallback);
}

double CMathUtils::Median(const double &values[], const double fallback)
{
   const int count = ArraySize(values);

   if(count <= 0)
      return fallback;

   double sorted[];
   ArrayResize(sorted, count);
   ArrayCopy(sorted, values);

   SortAscending(sorted);

   const int midIndex = count / 2;

   if((count % 2) == 0)
      return (sorted[midIndex - 1] + sorted[midIndex]) / 2.0;

   return sorted[midIndex];
}

//+------------------------------------------------------------------+
//| Internal Helpers                                                 |
//+------------------------------------------------------------------+

void CMathUtils::SortAscending(double &values[])
{
   ArraySort(values);
}

#endif // AI_SWINGBREAKOUT_CORE_MATHUTILS_MQH