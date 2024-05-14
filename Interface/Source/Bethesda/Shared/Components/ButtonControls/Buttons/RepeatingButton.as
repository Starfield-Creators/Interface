package Shared.Components.ButtonControls.Buttons
{
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.RepeatingButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RepeatingButton extends ButtonBase
   {
       
      
      private var RepeatingTimer:Timer;
      
      private var HeldUserEvent:UserEventData = null;
      
      public function RepeatingButton()
      {
         super();
      }
      
      protected function StartTimer(param1:UserEventData) : *
      {
         this.HeldUserEvent = param1;
         this.RepeatingTimer.reset();
         this.RepeatingTimer.start();
         this.onTimerInterval();
      }
      
      protected function StopTimer() : *
      {
         this.RepeatingTimer.stop();
         this.HeldUserEvent = null;
      }
      
      protected function onTimerInterval() : *
      {
         HandleButtonHit(null,this.HeldUserEvent);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseUp);
         addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      protected function OnMouseDown(param1:MouseEvent) : *
      {
         if(Data.UserEvents.NumUserEvents == 1)
         {
            this.StartTimer(Data.UserEvents.GetUserEventByIndex(0));
         }
      }
      
      protected function OnMouseUp(param1:MouseEvent) : *
      {
         this.StopTimer();
      }
      
      override public function SetButtonData(param1:ButtonData) : void
      {
         if(param1 is RepeatingButtonData)
         {
            if(this.RepeatingTimer != null)
            {
               this.RepeatingTimer.removeEventListener(TimerEvent.TIMER,this.onTimerInterval);
            }
            this.RepeatingTimer = new Timer((param1 as RepeatingButtonData).RepeatIntervalMS);
            this.RepeatingTimer.addEventListener(TimerEvent.TIMER,this.onTimerInterval);
         }
         super.SetButtonData(param1);
      }
      
      override public function set Enabled(param1:Boolean) : void
      {
         super.Enabled = param1;
         if(!bEnabled)
         {
            this.StopTimer();
         }
      }
      
      override protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         return false;
      }
      
      override public function HandleUserEvent(param1:String, param2:Boolean, param3:Boolean) : Boolean
      {
         var asEventName:String = param1;
         var abPressed:Boolean = param2;
         var abHandled:Boolean = param3;
         var handled:Boolean = abHandled;
         if(!handled)
         {
            if(Enabled)
            {
               if(abPressed)
               {
                  Data.UserEvents.CallForMatchingData(asEventName,function(param1:UserEventData):*
                  {
                     StartTimer(param1);
                     handled = true;
                  });
               }
               else
               {
                  Data.UserEvents.CallForMatchingData(asEventName,function(param1:UserEventData):*
                  {
                     StopTimer();
                     handled = true;
                  });
               }
            }
         }
         return handled;
      }
   }
}
