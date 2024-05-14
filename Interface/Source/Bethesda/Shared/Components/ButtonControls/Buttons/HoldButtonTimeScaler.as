package Shared.Components.ButtonControls.Buttons
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class HoldButtonTimeScaler extends MovieClip
   {
       
      
      public var HoldTime:Number = 0.3;
      
      private var AnimClip:MovieClip;
      
      private var HoldIdleFrame:int = 1;
      
      private var HoldStartFrame:int = 1;
      
      private var HoldEndFrame:int = 1;
      
      private var FrameCounter:int = 0;
      
      public function HoldButtonTimeScaler(param1:MovieClip, param2:String, param3:String, param4:String)
      {
         super();
         this.AnimClip = param1;
         var _loc5_:uint = 1;
         while(_loc5_ < this.AnimClip.currentLabels.length)
         {
            if(this.AnimClip.currentLabels[_loc5_].name == param2)
            {
               this.HoldIdleFrame = this.AnimClip.currentLabels[_loc5_].frame;
            }
            if(this.AnimClip.currentLabels[_loc5_].name == param3)
            {
               this.HoldStartFrame = this.AnimClip.currentLabels[_loc5_].frame;
            }
            if(this.AnimClip.currentLabels[_loc5_].name == param4)
            {
               this.HoldEndFrame = this.AnimClip.currentLabels[_loc5_].frame;
            }
            _loc5_++;
         }
         GlobalFunc.BSASSERT(this.HoldEndFrame > this.HoldStartFrame,"Hold animation has a zero-length animation, or its frame labels are not set up.");
      }
      
      public function PlayScaledHoldAnimation() : void
      {
         this.FrameCounter = 0;
         this.AnimClip.gotoAndStop(this.HoldStartFrame);
         addEventListener(Event.ENTER_FRAME,this.checkFinished);
      }
      
      public function StopScaledHoldAnimation() : void
      {
         this.AnimClip.gotoAndStop(this.HoldIdleFrame);
         removeEventListener(Event.ENTER_FRAME,this.checkFinished);
      }
      
      private function checkFinished() : void
      {
         var _loc1_:int = this.HoldEndFrame - this.HoldStartFrame;
         var _loc2_:int = this.AnimClip.stage != null ? int(Math.floor(this.HoldTime * this.AnimClip.stage.frameRate)) : 30;
         var _loc3_:uint = Math.round(this.FrameCounter * (_loc1_ / _loc2_));
         ++this.FrameCounter;
         if(this.HoldStartFrame + _loc3_ < this.HoldEndFrame)
         {
            if(this.HoldStartFrame + _loc3_ != this.AnimClip.currentFrame)
            {
               this.AnimClip.gotoAndStop(this.HoldStartFrame + _loc3_);
            }
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.checkFinished);
            this.AnimClip.gotoAndPlay(this.HoldEndFrame);
         }
      }
   }
}
