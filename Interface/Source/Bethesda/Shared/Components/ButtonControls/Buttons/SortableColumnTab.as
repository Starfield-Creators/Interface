package Shared.Components.ButtonControls.Buttons
{
   import Shared.AS3.Patterns.TimelineStateMachine;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class SortableColumnTab extends TabTextButton
   {
      
      public static const SORT_NONE:int = -1;
      
      public static const SORT_ASCENDING:int = 0;
      
      public static const SORT_DESCENDING:int = 1;
      
      private static const STATE_OFF:String = "off";
      
      private static const STATE_ASCENDING:String = "up";
      
      private static const STATE_DESCENDING:String = "down";
       
      
      public var SortArrows_mc:MovieClip;
      
      private var sortArrowSM:TimelineStateMachine;
      
      public function SortableColumnTab()
      {
         this.sortArrowSM = new TimelineStateMachine();
         super();
         if(!this.SortArrows_mc)
         {
            GlobalFunc.TraceWarning("SortableColumnTab requires \'SortArrows_mc\' clip on the timeline");
         }
         this.sortArrowSM.addState(STATE_OFF,["*"],{"enter":this.onEnterState},[String(SORT_NONE)]);
         this.sortArrowSM.addState(STATE_ASCENDING,["*"],{"enter":this.onEnterState},[String(SORT_ASCENDING)]);
         this.sortArrowSM.addState(STATE_DESCENDING,["*"],{"enter":this.onEnterState},[String(SORT_DESCENDING)]);
         this.sortArrowSM.startingState(STATE_OFF);
      }
      
      override public function SetSelected(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         super.SetSelected(param1);
         if(param1 == true)
         {
            _loc2_ = Data.Payload;
            if(_loc2_)
            {
               this.sortArrowSM.changeState(_loc2_.SortDirection === SORT_DESCENDING ? STATE_DESCENDING : STATE_ASCENDING);
            }
         }
         else
         {
            this.sortArrowSM.changeState(STATE_OFF);
         }
      }
      
      public function SetSortArrowState(param1:int) : void
      {
         this.sortArrowSM.processEvent(String(param1));
      }
      
      protected function onEnterState(param1:Object) : void
      {
         this.SortArrows_mc.gotoAndStop(param1.currentState);
      }
   }
}
