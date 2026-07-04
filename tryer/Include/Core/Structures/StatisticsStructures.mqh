//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : StatisticsStructures.mqh                               |
//| Purpose : Statistics and performance structures                  |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_STRUCTURES_STATISTICSSTRUCTURES_MQH
#define AI_SWINGBREAKOUT_CORE_STRUCTURES_STATISTICSSTRUCTURES_MQH

// Project Includes
#include "../Types.mqh"

//+------------------------------------------------------------------+
//| Trade Statistics                                                 |
//+------------------------------------------------------------------+
struct STradeStatistics
{
   int      TotalTrades;
   int      WinningTrades;
   int      LosingTrades;

   double   WinRate;

   double   GrossProfit;
   double   GrossLoss;
   double   NetProfit;

   double   ProfitFactor;

   double   AverageWin;
   double   AverageLoss;

   void Reset()
   {
      TotalTrades   = 0;
      WinningTrades = 0;
      LosingTrades  = 0;

      WinRate       = 0.0;

      GrossProfit   = 0.0;
      GrossLoss     = 0.0;
      NetProfit     = 0.0;

      ProfitFactor  = 0.0;

      AverageWin    = 0.0;
      AverageLoss   = 0.0;
   }

   bool IsValid() const
   {
      return (TotalTrades >= 0);
   }
};

//+------------------------------------------------------------------+
//| Performance Metrics                                              |
//+------------------------------------------------------------------+
struct SPerformanceMetrics
{
   double SharpeRatio;
   double SortinoRatio;

   double RecoveryFactor;

   double Expectancy;

   double MaxDrawdown;

   double CAGR;

   void Reset()
   {
      SharpeRatio   = 0.0;
      SortinoRatio  = 0.0;

      RecoveryFactor= 0.0;

      Expectancy    = 0.0;

      MaxDrawdown   = 0.0;

      CAGR          = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Timer Information                                                |
//+------------------------------------------------------------------+
struct STimerInfo
{
   datetime StartTime;
   datetime EndTime;

   ulong    ElapsedMilliseconds;

   void Reset()
   {
      StartTime = 0;
      EndTime   = 0;

      ElapsedMilliseconds = 0;
   }
};

//+------------------------------------------------------------------+
//| Backtest Statistics                                              |
//+------------------------------------------------------------------+
struct SBacktestStatistics
{
   datetime StartDate;
   datetime EndDate;

   int      TotalBars;

   int      TotalTicks;

   double   InitialDeposit;

   double   FinalBalance;

   double   TotalReturn;

   void Reset()
   {
      StartDate      = 0;
      EndDate        = 0;

      TotalBars      = 0;
      TotalTicks     = 0;

      InitialDeposit = 0.0;
      FinalBalance   = 0.0;
      TotalReturn    = 0.0;
   }
};

//+------------------------------------------------------------------+
//| Benchmark Result                                                 |
//+------------------------------------------------------------------+
struct SBenchmarkResult
{
   string TestName;

   ulong  ExecutionTimeMS;

   int    Iterations;

   bool   Passed;

   void Reset()
   {
      TestName        = "";

      ExecutionTimeMS = 0;

      Iterations      = 0;

      Passed          = false;
   }
};

#endif // AI_SWINGBREAKOUT_CORE_STRUCTURES_STATISTICSSTRUCTURES_MQH