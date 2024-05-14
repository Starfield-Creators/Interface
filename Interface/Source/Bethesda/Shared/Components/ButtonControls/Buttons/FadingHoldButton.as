package Shared.Components.ButtonControls.Buttons
{
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class FadingHoldButton extends MinimalButton
   {
      
      protected static const HOLD_IDLE:String = "Idle";
      
      protected static const HOLD_FADE_IN:String = "FadeIn";
      
      protected static const HOLD_FADED_IN:String = "FadedIn";
      
      protected static const HOLD_FADE_OUT:String = "FadeOut";
      
      protected static const HOLD_FADED_OUT:String = "FadedOut";
      
      protected static const HOLD_FINISHED:String = "ButtonHoldComplete";
      
      protected static const START_HOLD:String = "StartHold";
      
      protected static const START_HOLD_IMMEDIATE:String = "StartHoldImmediate";
       
      
      public var HoldMeterAnim_mc:MovieClip;
      
      protected var ButtonShownTime:Timer;
      
      protected var HeldEvent:UserEventData;
      
      public function FadingHoldButton()
      {
         this.ButtonShownTime = new Timer(3000,1);
         super();
         gotoAndStop(HOLD_FADED_OUT);
         addEventListener(MouseEvent.MOUSE_DOWN,this.StartHoldAnim);
         addEventListener(MouseEvent.MOUSE_UP,this.StopHoldAnim);
         this.ButtonShownTime.addEventListener(TimerEvent.TIMER_COMPLETE,this.FadeOut);
      }
      
      override public function get HandlePriority() : int
      {
         return IButtonUtils.BUTTON_PRIORITY_HOLD;
      }
      
      override protected function UpdateColor() : void
      {
         var _loc1_:* = undefined;
         if(bCustomColor)
         {
            super.UpdateColor();
            _loc1_ = new ColorTransform();
            _loc1_.color = uButtonColor;
            this.HoldMeterAnim_mc.transform.colorTransform = _loc1_;
         }
      }
      
      override protected function UpdateButtonText() : void
      {
         super.UpdateButtonText();
         if(Data != null)
         {
            this.HoldMeterAnim_mc.visible = KeyHelper.usingController;
         }
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
               Data.UserEvents.CallForMatchingData(asEventName,function(param1:UserEventData):*
               {
                  if(abPressed)
                  {
                     HeldEvent = param1;
                     if(HeldEvent.bEnabled)
                     {
                        StartHoldAnim(null);
                     }
                  }
                  else
                  {
                     StopHoldAnim(null);
                     HeldEvent = null;
                  }
                  handled = true;
               });
            }
         }
         return handled;
      }
      
      public function CancelHold() : void
      {
         if(this.HeldEvent != null)
         {
            this.ButtonShownTime.reset();
            this.StopHoldAnim(null);
         }
      }
      
      protected function HoldComplete(param1:Event) : *
      {
         if(Enabled)
         {
            if(this.HeldEvent.funcCallback != null)
            {
               this.HeldEvent.funcCallback();
            }
            if(this.HeldEvent.sCodeCallback.length > 0)
            {
               SendEvent(this.HeldEvent);
            }
            GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_COMPLETE_SOUND);
         }
      }
      
      override protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         return true;
      }
      
      protected function StartHoldAnim(param1:Event) : *
      {
         if(currentLabel != HOLD_FADE_IN && currentLabel != HOLD_FADED_IN)
         {
            gotoAndPlay(HOLD_FADE_IN);
         }
         this.ButtonShownTime.reset();
         this.ButtonShownTime.start();
         GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_START_SOUND);
         this.HoldMeterAnim_mc.addEventListener(HOLD_FINISHED,this.HoldComplete);
         this.HoldMeterAnim_mc.gotoAndPlay(currentLabel != HOLD_FADED_IN ? START_HOLD : START_HOLD_IMMEDIATE);
      }
      
      protected function StopHoldAnim(param1:Event) : *
      {
         this.HoldMeterAnim_mc.gotoAndStop(HOLD_IDLE);
         GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_ABORT_SOUND);
      }
      
      protected function FadeOut(param1:TimerEvent) : *
      {
         gotoAndPlay(HOLD_FADE_OUT);
      }
   }
}
