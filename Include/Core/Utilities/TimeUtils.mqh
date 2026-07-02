//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : TimeUtils.mqh                                          |
//| Version : 2.0.0-alpha.2                                          |
//| Author  : AI Swing Breakout Team                                 |
//|                                                                  |
//| Purpose                                                          |
//|   Provides stateless time/date utility functions for framework.  |
//|                                                                  |
//| Notes                                                            |
//|   - Static utility class                                         |
//|   - No internal state                                            |
//|   - Thread-safe (stateless)                                      |
//+------------------------------------------------------------------+
#ifndef __TIMEUTILS_MQH__
#define __TIMEUTILS_MQH__

//+------------------------------------------------------------------+
//| Time Utilities                                                   |
//+------------------------------------------------------------------+
class CTimeUtils
{
public:

   //===============================================================
   // Trading Day Helpers
   //===============================================================
   static bool IsWeekend(const datetime value);
   static bool IsTradingDay(const datetime value);

   //===============================================================
   // Date Components
   //===============================================================
   static int Year(const datetime value);
   static int Month(const datetime value);
   static int Day(const datetime value);

   //===============================================================
   // Time Components
   //===============================================================
   static int Hour(const datetime value);
   static int Minute(const datetime value);
   static int Second(const datetime value);
   
   //===============================================================
   // Day Boundaries
   //===============================================================
   static datetime StartOfDay(const datetime value);
   static datetime EndOfDay(const datetime value);

   //===============================================================
   // Formatting
   //===============================================================
   static string FormatDate(const datetime value);
   static string FormatTime(const datetime value);
   static string FormatDateTime(const datetime value);
};

//+------------------------------------------------------------------+
//| Is Weekend                                                       |
//+------------------------------------------------------------------+
bool CTimeUtils::IsWeekend(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return (dt.day_of_week == 0 || dt.day_of_week == 6);
}

//+------------------------------------------------------------------+
//| Is Trading Day                                                   |
//+------------------------------------------------------------------+
bool CTimeUtils::IsTradingDay(const datetime value)
{
   return !IsWeekend(value);
}

//+------------------------------------------------------------------+
//| Year                                                             |
//+------------------------------------------------------------------+
int CTimeUtils::Year(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return dt.year;
}

//+------------------------------------------------------------------+
//| Month                                                            |
//+------------------------------------------------------------------+
int CTimeUtils::Month(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return dt.mon;
}

//+------------------------------------------------------------------+
//| Day                                                              |
//+------------------------------------------------------------------+
int CTimeUtils::Day(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return dt.day;
}

//+------------------------------------------------------------------+
//| Hour                                                             |
//+------------------------------------------------------------------+
int CTimeUtils::Hour(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return dt.hour;
}

//+------------------------------------------------------------------+
//| Minute                                                           |
//+------------------------------------------------------------------+
int CTimeUtils::Minute(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return dt.min;
}

//+------------------------------------------------------------------+
//| Second                                                           |
//+------------------------------------------------------------------+
int CTimeUtils::Second(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   return dt.sec;
}

//+------------------------------------------------------------------+
//| Start Of Day                                                     |
//+------------------------------------------------------------------+
datetime CTimeUtils::StartOfDay(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   dt.hour = 0;
   dt.min  = 0;
   dt.sec  = 0;

   return StructToTime(dt);
}

//+------------------------------------------------------------------+
//| End Of Day                                                       |
//+------------------------------------------------------------------+
datetime CTimeUtils::EndOfDay(const datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value, dt);

   dt.hour = 23;
   dt.min  = 59;
   dt.sec  = 59;

   return StructToTime(dt);
}

//+------------------------------------------------------------------+
//| Format Date                                                      |
//+------------------------------------------------------------------+
string CTimeUtils::FormatDate(const datetime value)
{
   return TimeToString(value, TIME_DATE);
}

//+------------------------------------------------------------------+
//| Format Time                                                      |
//+------------------------------------------------------------------+
string CTimeUtils::FormatTime(const datetime value)
{
   return TimeToString(value, TIME_MINUTES | TIME_SECONDS);
}

//+------------------------------------------------------------------+
//| Format DateTime                                                  |
//+------------------------------------------------------------------+
string CTimeUtils::FormatDateTime(const datetime value)
{
   return TimeToString(value, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
}

#endif // __TIMEUTILS_MQH__