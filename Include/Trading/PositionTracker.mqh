//+------------------------------------------------------------------+

//| Project : AI Swing Breakout Pro Framework                        |

//| Module  : Trading                                                |

//| File    : PositionTracker.mqh                                    |

//| Purpose : Implements state verification of active terminal       |

//|           positions filtered by symbol and magic number.         |

//| Author  : ZiXXXiZ                                                |

//| Version : 2.0.0-alpha.6                                          |

//+------------------------------------------------------------------+

#ifndef AI_SWINGBREAKOUT_TRADING_POSITIONTRACKER_MQH

#define AI_SWINGBREAKOUT_TRADING_POSITIONTRACKER_MQH

#include "../Framework/Module.mqh"

#include "../Core/Config.mqh"

#include "../Core/Constants.mqh"

class CPositionTracker : public CModule

{

public:

   CPositionTracker();

   virtual bool   Initialize(CContext *context) override;

   virtual void   Shutdown() override;

   bool           HasActivePosition() const;

};

//+------------------------------------------------------------------+

//| Constructor                                                      |

//+------------------------------------------------------------------+

CPositionTracker::CPositionTracker()

   : CModule("CPositionTracker")

{

}

//+------------------------------------------------------------------+

//| Initialize                                                       |

//+------------------------------------------------------------------+

bool CPositionTracker::Initialize(CContext *context)

{

   return CModule::Initialize(context);

}

//+------------------------------------------------------------------+

//| Shutdown                                                         |

//+------------------------------------------------------------------+

void CPositionTracker::Shutdown()

{

   CModule::Shutdown();

}

//+------------------------------------------------------------------+

//| HasActivePosition                                                |

//+------------------------------------------------------------------+

bool CPositionTracker::HasActivePosition() const

{

   int totalPositions = PositionsTotal();

   

   for(int i = 0; i < totalPositions; i++)

   {

      // PositionGetSymbol automatically selects the position for further tracking properties

      string positionSymbol = PositionGetSymbol(i);

      if(positionSymbol == _Symbol)

      {

         long magic = PositionGetInteger(POSITION_MAGIC);

         if(magic == MAGIC_NUMBER)

         {

            return true;

         }

      }

   }

   

   return false;

}

#endif // AI_SWINGBREAKOUT_TRADING_POSITIONTRACKER_MQH