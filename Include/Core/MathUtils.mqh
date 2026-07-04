//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : MathUtils.mqh                                          |
//| Purpose : Mathematical utility functions                         |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_MATHUTILS_MQH
#define AI_SWINGBREAKOUT_CORE_MATHUTILS_MQH

// Project Includes

//+------------------------------------------------------------------+
//| Math Utilities                                                   |
//+------------------------------------------------------------------+
class CMathUtils
{
public:

   //==============================================================
   // Basic Math
   //==============================================================

   static double Abs(const double value)
   {
      return MathAbs(value);
   }

   static double Min(const double a,const double b)
   {
      return MathMin(a,b);
   }

   static double Max(const double a,const double b)
   {
      return MathMax(a,b);
   }

   static double Clamp(const double value,
                       const double minimum,
                       const double maximum)
   {
      if(value < minimum)
         return minimum;

      if(value > maximum)
         return maximum;

      return value;
   }

   static double Lerp(const double start,
                      const double end,
                      const double t)
   {
      return start + (end - start) * t;
   }

   static double Normalize(const double value,
                           const double minimum,
                           const double maximum)
   {
      if(maximum <= minimum)
         return 0.0;

      return (value - minimum) / (maximum - minimum);
   }

   static double Map(const double value,
                     const double inputMin,
                     const double inputMax,
                     const double outputMin,
                     const double outputMax)
   {
      if(inputMax <= inputMin)
         return outputMin;

      return outputMin +
             ((value - inputMin) /
             (inputMax - inputMin)) *
             (outputMax - outputMin);
   }

   static double Round(const double value,
                       const int digits)
   {
      return NormalizeDouble(value,digits);
   }

   static double Floor(const double value)
   {
      return MathFloor(value);
   }

   static double Ceil(const double value)
   {
      return MathCeil(value);
   }

   static int Sign(const double value)
   {
      if(value > 0.0)
         return 1;

      if(value < 0.0)
         return -1;

      return 0;
   }

   static bool IsZero(const double value,
                      const double epsilon = 1e-9)
   {
      return (MathAbs(value) <= epsilon);
   }

   static bool IsEqual(const double a,
                       const double b,
                       const double epsilon = 1e-9)
   {
      return (MathAbs(a - b) <= epsilon);
   }
};

   //==============================================================
   // Price Math
   //==============================================================

   static double NormalizePrice(const double price,
                                const int digits)
   {
      return NormalizeDouble(price, digits);
   }

   static double NormalizeVolume(const double volume,
                                 const double lotStep)
   {
      if(lotStep <= 0.0)
         return volume;

      return MathFloor(volume / lotStep) * lotStep;
   }

   static double PointsToPrice(const double points,
                               const double point)
   {
      return points * point;
   }

   static double PriceToPoints(const double priceDifference,
                               const double point)
   {
      if(point <= 0.0)
         return 0.0;

      return priceDifference / point;
   }

   static double PipsToPrice(const double pips,
                             const double point,
                             const int digits)
   {
      if(digits == 3 || digits == 5)
         return pips * point * 10.0;

      return pips * point;
   }

   static double PriceToPips(const double priceDifference,
                             const double point,
                             const int digits)
   {
      if(point <= 0.0)
         return 0.0;

      if(digits == 3 || digits == 5)
         return priceDifference / (point * 10.0);

      return priceDifference / point;
   }

   static double Spread(const double ask,
                        const double bid)
   {
      return ask - bid;
   }

   static double SpreadPoints(const double ask,
                              const double bid,
                              const double point)
   {
      if(point <= 0.0)
         return 0.0;

      return (ask - bid) / point;
   }

   static double MidPrice(const double bid,
                          const double ask)
   {
      return (bid + ask) * 0.5;
   }

   static double Distance(const double price1,
                          const double price2)
   {
      return MathAbs(price1 - price2);
   }

   static bool IsValidPrice(const double price)
   {
      return (price > 0.0);
   }

   static bool IsValidSpread(const double ask,
                             const double bid)
   {
      return (ask >= bid && bid > 0.0);
   }

   static double RiskRewardRatio(const double entry,
                                 const double stopLoss,
                                 const double takeProfit)
   {
      double risk = MathAbs(entry - stopLoss);

      if(risk <= 0.0)
         return 0.0;

      double reward = MathAbs(takeProfit - entry);

      return reward / risk;
   }
   
      //==============================================================
   // Statistics
   //==============================================================

   static double Sum(const double &values[])
   {
      double sum = 0.0;
      int count = ArraySize(values);

      for(int i = 0; i < count; i++)
         sum += values[i];

      return sum;
   }

   static double Mean(const double &values[])
   {
      int count = ArraySize(values);

      if(count == 0)
         return 0.0;

      return Sum(values) / count;
   }

   static double MinValue(const double &values[])
   {
      int count = ArraySize(values);

      if(count == 0)
         return 0.0;

      double result = values[0];

      for(int i = 1; i < count; i++)
      {
         if(values[i] < result)
            result = values[i];
      }

      return result;
   }

   static double MaxValue(const double &values[])
   {
      int count = ArraySize(values);

      if(count == 0)
         return 0.0;

      double result = values[0];

      for(int i = 1; i < count; i++)
      {
         if(values[i] > result)
            result = values[i];
      }

      return result;
   }

   static double Range(const double &values[])
   {
      if(ArraySize(values) == 0)
         return 0.0;

      return MaxValue(values) - MinValue(values);
   }

   static double Variance(const double &values[])
   {
      int count = ArraySize(values);

      if(count <= 1)
         return 0.0;

      double mean = Mean(values);
      double sum = 0.0;

      for(int i = 0; i < count; i++)
      {
         double diff = values[i] - mean;
         sum += diff * diff;
      }

      return sum / (count - 1);      // Sample variance
   }

   static double StandardDeviation(const double &values[])
   {
      return MathSqrt(Variance(values));
   }

   static double Median(double &values[])
   {
      int count = ArraySize(values);

      if(count == 0)
         return 0.0;

      ArraySort(values);

      if((count % 2) == 0)
         return (values[count/2 - 1] + values[count/2]) * 0.5;

      return values[count/2];
   }

   static double ZScore(const double value,
                        const double mean,
                        const double standardDeviation)
   {
      if(standardDeviation <= 0.0)
         return 0.0;

      return (value - mean) / standardDeviation;
   }

   static double NormalizeScore(const double value,
                                const double minimum,
                                const double maximum)
   {
      if(maximum <= minimum)
         return 0.0;

      return Clamp((value - minimum) /
                   (maximum - minimum),
                   0.0,
                   1.0);
   }
   
   //==============================================================
   // Trading & Risk Math
   //==============================================================

   static double PercentChange(const double oldValue,
                               const double newValue)
   {
      if(oldValue == 0.0)
         return 0.0;

      return ((newValue - oldValue) / oldValue) * 100.0;
   }

   static double DrawdownPercent(const double peakEquity,
                                 const double currentEquity)
   {
      if(peakEquity <= 0.0)
         return 0.0;

      return ((peakEquity - currentEquity) / peakEquity) * 100.0;
   }

   static double RiskAmount(const double accountBalance,
                            const double riskPercent)
   {
      return accountBalance * (riskPercent / 100.0);
   }

   static double RewardAmount(const double riskAmount,
                              const double riskRewardRatio)
   {
      return riskAmount * riskRewardRatio;
   }

   static double ProfitFactor(const double grossProfit,
                              const double grossLoss)
   {
      if(grossLoss <= 0.0)
         return 0.0;

      return grossProfit / grossLoss;
   }

   static double Expectancy(const double winRatePercent,
                            const double averageWin,
                            const double averageLoss)
   {
      double winRate  = winRatePercent / 100.0;
      double lossRate = 1.0 - winRate;

      return (winRate * averageWin) -
             (lossRate * averageLoss);
   }

   static double BreakEvenWinRate(const double riskRewardRatio)
   {
      if(riskRewardRatio <= 0.0)
         return 100.0;

      return 100.0 / (1.0 + riskRewardRatio);
   }

   static double PositionSize(const double accountBalance,
                              const double riskPercent,
                              const double stopLossPoints,
                              const double valuePerPoint)
   {
      if(stopLossPoints <= 0.0)
         return 0.0;

      if(valuePerPoint <= 0.0)
         return 0.0;

      double riskAmount =
         RiskAmount(accountBalance, riskPercent);

      return riskAmount /
             (stopLossPoints * valuePerPoint);
   }

   static double BreakEvenPrice(const double entryPrice,
                                const double commissionPerLot,
                                const double swapCost)
   {
      return entryPrice +
             commissionPerLot +
             swapCost;
   }

   static double WinRate(const int wins,
                         const int totalTrades)
   {
      if(totalTrades <= 0)
         return 0.0;

      return ((double)wins /
              (double)totalTrades) * 100.0;
   }

   static double LossRate(const int losses,
                          const int totalTrades)
   {
      if(totalTrades <= 0)
         return 0.0;

      return ((double)losses /
              (double)totalTrades) * 100.0;
   }

   static double RecoveryFactor(const double netProfit,
                                const double maxDrawdown)
   {
      if(maxDrawdown <= 0.0)
         return 0.0;

      return netProfit / maxDrawdown;
   }

   static double RiskOfRuin(const double winRatePercent,
                            const double riskRewardRatio)
   {
      double p = winRatePercent / 100.0;
      double q = 1.0 - p;

      if(riskRewardRatio <= 0.0)
         return 100.0;

      double edge =
         (p * riskRewardRatio) - q;

      if(edge <= 0.0)
         return 100.0;

      return 0.0;
   }
   
      //==============================================================
   // Validation & Safe Math
   //==============================================================

   static bool IsPositive(const double value)
   {
      return (value > 0.0);
   }

   static bool IsNegative(const double value)
   {
      return (value < 0.0);
   }

   static bool IsInRange(const double value,
                         const double minimum,
                         const double maximum)
   {
      return (value >= minimum && value <= maximum);
   }

   static bool IsValidNumber(const double value)
   {
      return MathIsValidNumber(value);
   }

   static bool IsFinite(const double value)
   {
      return MathIsValidNumber(value);
   }

   static double SafeDivide(const double numerator,
                            const double denominator,
                            const double defaultValue = 0.0)
   {
      if(IsZero(denominator))
         return defaultValue;

      return numerator / denominator;
   }

   static double SafeSqrt(const double value)
   {
      if(value < 0.0)
         return 0.0;

      return MathSqrt(value);
   }

   static double SafeLog(const double value)
   {
      if(value <= 0.0)
         return 0.0;

      return MathLog(value);
   }

   static double SafeExp(const double value)
   {
      return MathExp(value);
   }

   static double Square(const double value)
   {
      return value * value;
   }

   static double Cube(const double value)
   {
      return value * value * value;
   }

   static double Average(const double a,
                         const double b)
   {
      return (a + b) * 0.5;
   }

   static double Percentage(const double value,
                            const double percent)
   {
      return value * percent / 100.0;
   }

   static double InversePercentage(const double part,
                                   const double total)
   {
      return SafeDivide(part * 100.0, total);
   }

   static double Clamp01(const double value)
   {
      return Clamp(value, 0.0, 1.0);
   }

   static double Clamp100(const double value)
   {
      return Clamp(value, 0.0, 100.0);
   }
   

   #endif // AI_SWINGBREAKOUT_CORE_MATHUTILS_MQH   