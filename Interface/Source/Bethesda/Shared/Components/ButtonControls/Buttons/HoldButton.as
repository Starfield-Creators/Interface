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
   
   public class HoldButton extends ButtonBase
   {
      
      public static const HOLD_IDLE:String = "Idle";
      
      public static const HOLD_START:String = "StartHold";
      
      public static const HOLD_COMPLETE:String = "buttonHoldComplete";
      
      public static const HOLD_FINISHED:String = "HoldFinished";
      
      public static const HOLD_END_ANIM_COMPLETE:String = "HoldEndAnimComplete";
       
      
      public var HoldAnimClip_mc:MovieClip;
      
      protected var HoldStartDelayTimer:Timer;
      
      protected var HeldEvent:UserEventData;
      
      protected var FinishingAnimation:Boolean = false;
      
      private var HoldAnimScaler:HoldButtonTimeScaler;
      
      public function HoldButton()
      {
         super();
         this.HoldStartDelayTimer = new Timer(IButtonUtils.DEFAULT_HOLD_START_DELAY_TIME_MS,1);
         this.HoldStartDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHoldStartDelayTimerCompleted);
      }
      
      protected function get HoldAnimationClip_mc() : MovieClip
      {
         return this.HoldAnimClip_mc != null ? this.HoldAnimClip_mc : (KeyHelper != null && KeyHelper.usingController ? ConsoleButtonInstance_mc.HoldAnim_mc : PCButtonInstance_mc.HoldAnim_mc);
      }
      
      public function get Held() : *
      {
         return this.HeldEvent != null && !this.HoldStartDelayTimer.running;
      }
      
      override public function get HandlePriority() : int
      {
         return IButtonUtils.BUTTON_PRIORITY_HOLD;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
      }
      
      override protected function UpdateColor() : void
      {
         var _loc1_:* = undefined;
         if(bCustomColor)
         {
            super.UpdateColor();
            if(this.HoldAnimClip_mc != null)
            {
               _loc1_ = new ColorTransform();
               _loc1_.color = uButtonColor;
               this.HoldAnimClip_mc.transform.colorTransform = _loc1_;
            }
         }
      }
      
      public function CancelHold() : void
      {
         this.HoldStartDelayTimer.reset();
         this.StopHoldAnim();
      }
      
      protected function StartHoldAnim() : *
      {
         this.FinishingAnimation = false;
         if(Enabled)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_START_SOUND);
            if(this.HoldAnimationClip_mc != null)
            {
               this.HoldAnimScaler = new HoldButtonTimeScaler(this.HoldAnimationClip_mc,HOLD_IDLE,HOLD_START,HOLD_COMPLETE);
               this.HoldAnimationClip_mc.addEventListener(HOLD_FINISHED,this.OnHoldFinished);
               this.HoldAnimationClip_mc.addEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
            }
            this.HoldAnimScaler.PlayScaledHoldAnimation();
         }
         else if(Visible && Data.sClickFailedSound.length > 0)
         {
            GlobalFunc.PlayMenuSound(Data.sClickFailedSound);
         }
      }
      
      protected function StopHoldAnim() : *
      {
         if(this.Held)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_ABORT_SOUND);
         }
         this.ResetButtonState();
      }
      
      private function ResetButtonState() : void
      {
         this.FinishingAnimation = false;
         if(this.HoldAnimScaler != null)
         {
            this.HoldAnimScaler.StopScaledHoldAnimation();
            this.HoldAnimScaler = null;
         }
         if(this.HoldAnimClip_mc != null)
         {
            this.HoldAnimClip_mc.removeEventListener(HOLD_FINISHED,this.OnHoldFinished);
            this.HoldAnimClip_mc.removeEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
         }
         this.HeldEvent = null;
         if(PCButtonInstance_mc != null)
         {
            PCButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_FINISHED,this.OnHoldFinished);
            PCButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
         }
         if(ConsoleButtonInstance_mc != null)
         {
            ConsoleButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_FINISHED,this.OnHoldFinished);
            ConsoleButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
         }
      }
      
      private function OnHoldFinished(param1:Event) : *
      {
         this.FinishingAnimation = true;
         if(Enabled)
         {
            this.gotoAndPlay(!!bMouseOverButton ? BUTTON_CLICKED_MOUSE : BUTTON_CLICKED);
            if(Data.sClickSound.length > 0)
            {
               GlobalFunc.PlayMenuSound(Data.sClickSound);
            }
            else
            {
               GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_COMPLETE_SOUND);
            }
         }
         else
         {
            this.gotoAndPlay(!!bMouseOverButton ? DISABLED_CLICK_FAILED_MOUSE : DISABLED_CLICK_FAILED);
            if(Visible && Data.sClickFailedSound.length > 0)
            {
               GlobalFunc.PlayMenuSound(Data.sClickFailedSound);
            }
         }
      }
      
      private function OnHoldEndAnimComplete(param1:Event) : *
      {
         if(this.HeldEvent != null)
         {
            if(Enabled && this.HeldEvent.bEnabled && this.HeldEvent.funcCallback != null)
            {
               this.HeldEvent.funcCallback();
            }
            if(Enabled && this.HeldEvent.bEnabled && this.HeldEvent.sCodeCallback.length > 0)
            {
               SendEvent(this.HeldEvent);
            }
         }
         this.ResetButtonState();
      }
      
      override protected function UpdateButtonText() : void
      {
         super.UpdateButtonText();
         if(PCButtonInstance_mc != null)
         {
            PCButtonInstance_mc.holdArrowVisible = true;
         }
         if(ConsoleButtonInstance_mc != null)
         {
            ConsoleButtonInstance_mc.holdArrowVisible = true;
         }
      }
      
      protected function OnMouseDown(param1:Event) : void
      {
         if(Enabled && Data.UserEvents.NumUserEvents == 1)
         {
            this.HeldEvent = Data.UserEvents.GetUserEventByIndex(0);
            if(this.HeldEvent.bEnabled)
            {
               this.StartHoldAnim();
            }
         }
      }
      
      override protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         if(!this.FinishingAnimation)
         {
            this.StopHoldAnim();
         }
         return true;
      }
      
      override public function HandleUserEvent(param1:String, param2:Boolean, param3:Boolean) : Boolean
      {
         var asEventName:String = param1;
         var abPressed:Boolean = param2;
         var abHandled:Boolean = param3;
         var handled:Boolean = abHandled;
         if(Enabled)
         {
            Data.UserEvents.CallForMatchingData(asEventName,function(param1:UserEventData):*
            {
               if(abPressed)
               {
                  HeldEvent = param1;
                  if(HeldEvent.bEnabled && !FinishingAnimation)
                  {
                     HoldStartDelayTimer.start();
                  }
               }
               else if(HoldStartDelayTimer.running)
               {
                  HoldStartDelayTimer.reset();
                  HeldEvent = null;
               }
               else if(!FinishingAnimation)
               {
                  StopHoldAnim();
                  handled = true;
               }
               else if(FinishingAnimation)
               {
                  handled = true;
               }
            });
         }
         return handled;
      }
      
      private function onHoldStartDelayTimerCompleted() : *
      {
         this.StartHoldAnim();
         this.HoldStartDelayTimer.reset();
      }
   }
}
