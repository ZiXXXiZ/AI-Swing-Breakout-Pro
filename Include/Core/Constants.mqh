//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Core                                                   |
//| File    : Constants.mqh                                          |
//| Purpose : Global immutable framework constants                   |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.2                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_CORE_CONSTANTS_MQH
#define AI_SWINGBREAKOUT_CORE_CONSTANTS_MQH

//+------------------------------------------------------------------+
//| Class CConstants                                                 |
//| Description:                                                     |
//|   Defines immutable constants shared across the framework.       |
//|                                                                  |
//| Notes:                                                           |
//|   - Stateless                                                    |
//|   - Header-only                                                  |
//|   - No dependencies                                              |
//+------------------------------------------------------------------+
class CConstants
{
public:

   //==============================================================
   // Framework
   //==============================================================

   static const string FRAMEWORK_NAME;
   static const string AUTHOR;
   static const string COPYRIGHT;

   //==============================================================
   // Floating Point
   //==============================================================

   static const double EPSILON;
   static const double PRICE_EPSILON;
   static const double VOLUME_EPSILON;

   //==============================================================
   // Mathematical
   //==============================================================

   static const double PI;
   static const double TWO_PI;
   static const double HALF_PI;
   static const double DEG_TO_RAD;
   static const double RAD_TO_DEG;
   static const double E;
   static const double SQRT2;
   static const double SQRT3;

   //==============================================================
   // Time
   //==============================================================

   static const int SECONDS_PER_MINUTE;
   static const int MINUTES_PER_HOUR;
   static const int HOURS_PER_DAY;
   static const int DAYS_PER_WEEK;
   static const int MONTHS_PER_YEAR;

   //==============================================================
   // Trading Defaults
   //==============================================================

   static const long INVALID_MAGIC;
   static const ulong INVALID_TICKET;
   static const ulong INVALID_POSITION;

   static const int DEFAULT_SLIPPAGE_POINTS;

   //==============================================================
   // Risk Defaults
   //==============================================================

   static const double DEFAULT_RISK_PERCENT;
   static const double MIN_RISK_PERCENT;
   static const double MAX_RISK_PERCENT;
   static const double MAX_DRAWDOWN_PERCENT;

   //==============================================================
   // Logging
   //==============================================================

   static const int MAX_LOG_MESSAGE_LENGTH;
};

//------------------------------------------------------------------
// Framework
//------------------------------------------------------------------

const string CConstants::FRAMEWORK_NAME = "AI Swing Breakout Pro";
const string CConstants::AUTHOR         = "ZiXXXiZ";
const string CConstants::COPYRIGHT      = "Copyright © 2026";

//------------------------------------------------------------------
// Floating Point
//------------------------------------------------------------------

const double CConstants::EPSILON         = 1e-9;
const double CConstants::PRICE_EPSILON   = 1e-8;
const double CConstants::VOLUME_EPSILON  = 1e-8;

//------------------------------------------------------------------
// Mathematical
//------------------------------------------------------------------

const double CConstants::PI         = 3.14159265358979323846;
const double CConstants::TWO_PI     = 6.28318530717958647692;
const double CConstants::HALF_PI    = 1.57079632679489661923;
const double CConstants::DEG_TO_RAD = CConstants::PI / 180.0;
const double CConstants::RAD_TO_DEG = 180.0 / CConstants::PI;
const double CConstants::E          = 2.71828182845904523536;
const double CConstants::SQRT2      = 1.41421356237309504880;
const double CConstants::SQRT3      = 1.73205080756887729353;

//------------------------------------------------------------------
// Time
//------------------------------------------------------------------

const int CConstants::SECONDS_PER_MINUTE = 60;
const int CConstants::MINUTES_PER_HOUR   = 60;
const int CConstants::HOURS_PER_DAY      = 24;
const int CConstants::DAYS_PER_WEEK      = 7;
const int CConstants::MONTHS_PER_YEAR    = 12;

//------------------------------------------------------------------
// Trading
//------------------------------------------------------------------

const long  CConstants::INVALID_MAGIC            = -1;
const ulong CConstants::INVALID_TICKET           = 0;
const ulong CConstants::INVALID_POSITION         = 0;
const int   CConstants::DEFAULT_SLIPPAGE_POINTS  = 10;

//------------------------------------------------------------------
// Risk
//------------------------------------------------------------------

const double CConstants::DEFAULT_RISK_PERCENT    = 1.0;
const double CConstants::MIN_RISK_PERCENT        = 0.01;
const double CConstants::MAX_RISK_PERCENT        = 10.0;
const double CConstants::MAX_DRAWDOWN_PERCENT    = 30.0;

//------------------------------------------------------------------
// Logging
//------------------------------------------------------------------

const int CConstants::MAX_LOG_MESSAGE_LENGTH = 1024;

#endif // AI_SWINGBREAKOUT_CORE_CONSTANTS_MQH