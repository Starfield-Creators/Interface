package Components
{
   import Shared.GlobalFunc;
   import aze.motion.EazeTween;
   import aze.motion.eaze;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Meter extends EventDispatcher
   {
      
      public static const CHANGE_EVENT:String = "OnChange_Meter";
       
      
      private var Full:Number = 0;
      
      private var Empty:Number = 0;
      
      private var PercentPerFrame:Number = 1;
      
      private var _CurrentPercent:Number = 100;
      
      private var TargetPercent:Number = 100;
      
      private var FillSpeed:Number = 50;
      
      private var EmptySpeed:Number = 50;
      
      private var MeterMovieClip:MovieClip;
      
      private var CurrentAnimation:EazeTween;
      
      public function Meter(param1:MovieClip)
      {
         var _loc3_:* = undefined;
         super();
         this.MeterMovieClip = param1;
         var _loc2_:* = this.MeterMovieClip.currentLabels;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.name == "Empty")
            {
               this.Empty = _loc3_.frame;
            }
            else if(_loc3_.name == "Full")
            {
               this.Full = _loc3_.frame;
            }
         }
         this.PercentPerFrame = (this.Full - this.Empty) / 100;
         if(this.PercentPerFrame < 0)
         {
            this.PercentPerFrame *= -1;
         }
      }
      
      public function get CurrentPercent() : Number
      {
         return this._CurrentPercent;
      }
      
      public function set CurrentPercent(param1:Number) : void
      {
         this._CurrentPercent = param1;
      }
      
      public function get visible() : Boolean
      {
         return this.MeterMovieClip.visible;
      }
      
      public function set visible(param1:Boolean) : *
      {
         this.MeterMovieClip.visible = param1;
      }
      
      public function SetPercent(param1:Number) : void
      {
         if(this.CurrentAnimation)
         {
            this.CurrentAnimation.kill();
            this.CurrentAnimation = null;
         }
         this.CurrentPercent = Math.min(100,Math.max(param1,0));
         this.TargetPercent = this.CurrentPercent;
         this.MeterMovieClip.gotoAndStop(this.GetFrameForPercent(this.CurrentPercent));
         dispatchEvent(new Event(CHANGE_EVENT));
      }
      
      public function GetPercent(param1:Boolean = true) : Number
      {
         return param1 ? this.CurrentPercent : this.TargetPercent;
      }
      
      public function SetTargetPercent(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 != this.CurrentPercent)
         {
            this.TargetPercent = Math.min(100,Math.max(param1,0));
            _loc2_ = this.TargetPercent - this.CurrentPercent;
            _loc3_ = _loc2_ > 0 ? _loc2_ / this.FillSpeed : -_loc2_ / this.EmptySpeed;
            this.CurrentAnimation = eaze(this).to(_loc3_,{"CurrentPercent":this.TargetPercent}).onUpdate(this.AnimationUpdate).onComplete(this.DoneAnimating);
         }
      }
      
      public function SetFillSpeed(param1:Number) : void
      {
         this.FillSpeed = param1;
      }
      
      public function SetEmptySpeed(param1:Number) : void
      {
         this.EmptySpeed = param1;
      }
      
      private function AnimationUpdate() : void
      {
         var _loc1_:* = this.GetFrameForPercent(this.CurrentPercent);
         if(_loc1_ != this.MeterMovieClip.currentFrame)
         {
            this.MeterMovieClip.gotoAndStop(_loc1_);
         }
         dispatchEvent(new Event(CHANGE_EVENT));
      }
      
      private function DoneAnimating() : void
      {
         this.CurrentAnimation.kill();
         this.CurrentAnimation = null;
      }
      
      private function GetFrameForPercent(param1:Number) : int
      {
         return Math.round(GlobalFunc.MapLinearlyToRange(this.Empty,this.Full,0,100,param1,true));
      }
   }
}
