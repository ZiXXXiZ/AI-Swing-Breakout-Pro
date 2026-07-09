//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro Framework                        |
//| Module  : Trading                                                |
//| File    : TradeExecutor.mqh                                      |
//| Purpose : Executes market orders based on signal and risk        |
//|           results. Constructs SL/TP from current price and       |
//|           risk distance (points), then sends order via           |
//|           OrderSend with secondary position guard.               |
//| Author  : ZiXXXiZ                                                |
//| Version : 2.0.0-alpha.7                                          |
//+------------------------------------------------------------------+
#ifndef AI_SWINGBREAKOUT_TRADING_TRADEEXECUTOR_MQH
#define AI_SWINGBREAKOUT_TRADING_TRADEEXECUTOR_MQH

#include "../Framework/Module.mqh"
#include "../Signals/SignalResult.mqh"
#include "../Risk/RiskResult.mqh"
#include "TradeResult.mqh"
#include "../Core/Config.mqh"
#include "../Core/Constants.mqh"
#include "../Core/Logging/LogRecord.mqh"

class CTradeExecutor : public CModule
{
public:
   CTradeExecutor();
   virtual bool     Initialize(CContext *context) override;
   virtual void     Shutdown() override;
   STradeResult     Execute(const SSignalResult &signal,
                            const SRiskResult   &risk);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTradeExecutor::CTradeExecutor()
   : CModule("CTradeExecutor")
{
}

//+------------------------------------------------------------------+
//| Initialize                                                       |
//+------------------------------------------------------------------+
bool CTradeExecutor::Initialize(CContext *context)
{
   return CModule::Initialize(context);
}

//+------------------------------------------------------------------+
//| Shutdown                                                         |
//+------------------------------------------------------------------+
void CTradeExecutor::Shutdown()
{
   CModule::Shutdown();
}

//+------------------------------------------------------------------+
//| Execute                                                          |
//+------------------------------------------------------------------+
STradeResult CTradeExecutor::Execute(const SSignalResult &signal,
                                     const SRiskResult   &risk)
{
   STradeResult result;

   if(!signal.IsValid)
   {
      result.Reason = "Signal is invalid";
      return result;
   }

   if(!risk.IsAllowed)
   {
      result.Reason = "Risk check not passed";
      return result;
   }

   // ================================================================
   // SECONDARY SAFETY GUARD — Defensive Assertion Layer
   // ----------------------------------------------------------------
   // This check is an intentional, decoupled duplicate of the primary
   // filter in CEngine::Update(). It does NOT call CPositionTracker.
   // Rationale: CTradeExecutor must be safe to call independently of
   // engine wiring. If a future developer bypasses CEngine and calls
   // Execute() directly, this guard protects live capital.
   // If this fires, it is a critical architecture anomaly — a duplicate
   // trade request has bypassed the primary performance filter.
   // ================================================================
   int totalPositions = PositionsTotal();
   for(int i = 0; i < totalPositions; i++)
   {
      string positionSymbol = PositionGetSymbol(i);
      if(positionSymbol == _Symbol)
      {
         long magic = PositionGetInteger(POSITION_MAGIC);
         if(magic == MAGIC_NUMBER)
         {
            result.Success   = false;
            result.Ticket    = 0;
            result.ErrorCode = 0; 
            result.Reason    = "Defensive Guard: Open position already exists for this symbol and magic number";
            return result;
         }
      }
   }

   const CPlatform *platform = m_context.Platform();
   if(platform == NULL)
   {
      result.Reason = "Platform not available";
      return result;
   }

   if(!platform.IsTradeAllowed())
   {
      result.Reason = "Terminal trade is not allowed";
      return result;
   }

   // Build trade request
   MqlTradeRequest request = {};
   ZeroMemory(request);

   request.action    = TRADE_ACTION_DEAL;
   request.symbol    = _Symbol;
   request.magic     = MAGIC_NUMBER;   // global constant from Config.mqh

   const CConfig *config = platform.Config();
   request.deviation = (ulong)config.Trade.MaxSlippagePoints;   // from config

   if(signal.Direction == TRADE_DIRECTION_BUY)
   {
      request.type  = ORDER_TYPE_BUY;
      request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   }
   else // TRADE_DIRECTION_SELL
   {
      request.type  = ORDER_TYPE_SELL;
      request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   }

   request.volume = risk.LotSize;

   // --- Construct stop loss and take profit from live price and risk distances ---
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double sl    = 0.0;
   double tp    = 0.0;

   if(signal.Direction == TRADE_DIRECTION_BUY)
   {
      sl = request.price - risk.StopLossDistance   * point;
      tp = request.price + risk.TakeProfitDistance * point;
   }
   else
   {
      sl = request.price + risk.StopLossDistance   * point;
      tp = request.price - risk.TakeProfitDistance * point;
   }

   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(risk.StopLossDistance   > 0.0) request.sl = NormalizeDouble(sl, digits);
   if(risk.TakeProfitDistance > 0.0) request.tp = NormalizeDouble(tp, digits);

   MqlTradeResult tradeResult = {};
   ZeroMemory(tradeResult);

   if(OrderSend(request, tradeResult))
   {
      result.Success   = true;
      result.Ticket    = tradeResult.order;
      result.ErrorCode = 0;
      result.Reason    = "";

      SLogRecord record;
      ZeroMemory(record);
      record.Timestamp = TimeCurrent();
      record.Level     = LOG_INFO;
      record.Module    = "CTradeExecutor";
      record.Symbol    = _Symbol;
      record.Ticket    = result.Ticket;
      record.Message   = StringFormat(
         "Trade executed: Vol=%.2f, Price=%.5f, SL=%.5f, TP=%.5f",
         request.volume, request.price, request.sl, request.tp);

      m_context.Logger().Log(record);
   }
   else
   {
      result.Success   = false;
      result.Ticket    = 0;
      result.ErrorCode = GetLastError();
      result.Reason    = "OrderSend failed";

      SLogRecord record;
      ZeroMemory(record);
      record.Timestamp = TimeCurrent();
      record.Level     = LOG_ERROR;
      record.Module    = "CTradeExecutor";
      record.Symbol    = _Symbol;
      record.ErrorCode = result.ErrorCode;
      record.Message   = "OrderSend failed: " + result.Reason;

      m_context.Logger().Log(record);
   }

   return result;
}

#endif // AI_SWINGBREAKOUT_TRADING_TRADEEXECUTOR_MQH