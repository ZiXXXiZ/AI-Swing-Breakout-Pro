//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : ErrorHandler.mqh                                       |
//| Version : 2.0.0-alpha.2                                          |
//|                                                                  |
//| Purpose                                                          |
//|   Provides centralized MT5 error lookup services.                |
//|                                                                  |
//| Responsibilities                                                 |
//|   • Translate MT5 error codes                                    |
//|   • Return structured SErrorInfo                                 |
//|   • Classify errors                                               |
//|   • Determine recoverability                                     |
//+------------------------------------------------------------------+
#ifndef __ERRORHANDLER_MQH__
#define __ERRORHANDLER_MQH__

#include "../Base/BaseObject.mqh"

#include "ErrorCodes.mqh"
#include "ErrorInfo.mqh"