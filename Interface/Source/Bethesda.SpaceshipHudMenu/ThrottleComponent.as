package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ThrottleComponent extends MovieClip
   {
      
      private static const THROTTLE_WIDTH_LERP_PERCENT:Number = 0.167;
      
      private static const THROTTLE_BAR_MAX_WIDTH:Number = 37;
      
      private static const THROTTLE_BAR_MIN_MAX_WIDTH:Number = 2;
      
      private static const THROTTLE_BAR_MIN_WIDTH:Number = 1;
      
      private static const SMALL_BAR_INDICES:Array = new Array(1,4,9,13,22);
      
      private static const EXPONENTIAL_DECAY_PERCENT:Number = 0.01;
       
      
      public var ThrottleMeter_mc:MovieClip;
      
      public var ThrottleGuide_mc:MovieClip;
      
      public var ThrottleBars:Array;
      
      public var ThrottleMaxWidths:Array;
      
      public var ThrottleScales:Array;
      
      private var StickData:Object = null;
      
      private var LastFrame:int = 0;
      
      private var LastThrottleWidth:Number = -1;
      
      private var LastThrottleWidths:Array;
      
      private var LastAdjThrottle:Number = -1;
      
      private var LastBoost:Boolean = false;
      
      private var LastThrottle:Number = -1;
      
      private var NumLerpFrames:Number;
      
      private var FrameCounter:int = 0;
      
      public function ThrottleComponent()
      {
         var _loc3_:* = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this.ThrottleBars = new Array();
         this.ThrottleMaxWidths = new Array();
         this.ThrottleScales = new Array();
         this.LastThrottleWidths = new Array();
         super();
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = this.GetThrottleBar(_loc1_);
         while(_loc2_ != null)
         {
            this.ThrottleBars.push(_loc2_);
            this.ThrottleMaxWidths.push(_loc2_.width);
            _loc2_.gotoAndPlay(Math.round(Math.random() * _loc2_.totalFrames + 1));
            _loc1_++;
            _loc2_ = this.GetThrottleBar(_loc1_);
         }
         _loc1_ = 0;
         while(_loc1_ < this.ThrottleBars.length)
         {
            _loc3_ = SMALL_BAR_INDICES.indexOf(_loc1_) != -1;
            _loc4_ = GlobalFunc.MapLinearlyToRange(Math.PI / 2,1.5 * Math.PI,1,this.ThrottleBars.length,_loc1_,true);
            _loc5_ = Math.sin(_loc4_) * (_loc3_ ? 0.8 : 1);
            this.ThrottleScales.push(_loc5_);
            this.LastThrottleWidths.push(-1);
            _loc1_++;
         }
         this.NumLerpFrames = Math.log(EXPONENTIAL_DECAY_PERCENT) / Math.log(1 - THROTTLE_WIDTH_LERP_PERCENT);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.LastAdjThrottle != this.StickData.adjustedThrottle || this.LastBoost != this.StickData.boostActive || this.LastThrottle != this.StickData.throttle)
         {
            this.LastAdjThrottle = this.StickData.adjustedThrottle;
            this.LastBoost = this.StickData.boostActive;
            this.LastThrottle = this.StickData.throttle;
            this.FrameCounter = 0;
         }
         if(this.StickData != null && this.FrameCounter < this.NumLerpFrames)
         {
            if(this.StickData.throttle > 1 && Boolean(this.StickData.boostActive))
            {
               this.LastThrottleWidth = -1;
               _loc1_ = 0;
               while(_loc1_ < this.ThrottleBars.length)
               {
                  _loc2_ = this.ThrottleBars[_loc1_];
                  _loc2_.width = GlobalFunc.Lerp(_loc2_.width,this.ThrottleMaxWidths[_loc1_],THROTTLE_WIDTH_LERP_PERCENT);
                  _loc1_++;
               }
            }
            else
            {
               _loc3_ = THROTTLE_BAR_MAX_WIDTH * this.StickData.adjustedThrottle;
               if(_loc3_ < THROTTLE_BAR_MIN_MAX_WIDTH)
               {
                  _loc3_ = THROTTLE_BAR_MIN_MAX_WIDTH;
               }
               if(this.LastThrottleWidth != _loc3_)
               {
                  this.LastThrottleWidth = _loc3_;
                  _loc1_ = 0;
                  while(_loc1_ < this.ThrottleBars.length)
                  {
                     _loc4_ = _loc3_ > this.ThrottleMaxWidths[_loc1_] ? Number(this.ThrottleMaxWidths[_loc1_]) : _loc3_;
                     this.LastThrottleWidths[_loc1_] = GlobalFunc.MapLinearlyToRange(1,_loc4_,-1,THROTTLE_BAR_MIN_WIDTH,this.ThrottleScales[_loc1_],true);
                     _loc1_++;
                  }
               }
               _loc1_ = 0;
               while(_loc1_ < this.ThrottleBars.length)
               {
                  _loc2_ = this.ThrottleBars[_loc1_];
                  _loc2_.width = GlobalFunc.Lerp(_loc2_.width,this.LastThrottleWidths[_loc1_],THROTTLE_WIDTH_LERP_PERCENT);
                  _loc1_++;
               }
            }
            ++this.FrameCounter;
         }
      }
      
      public function GetThrottleBar(param1:uint) : MovieClip
      {
         return this.ThrottleMeter_mc["ThrottleBar" + (param1 + 1) + "_mc"];
      }
      
      public function OnStickDataUpdate(param1:Object) : *
      {
         var _loc2_:int = GlobalFunc.MapLinearlyToRange(1,this.ThrottleGuide_mc.framesLoaded,0,1,param1.throttle,true);
         if(this.LastFrame != _loc2_)
         {
            this.ThrottleGuide_mc.gotoAndStop(_loc2_);
            this.LastFrame = _loc2_;
         }
         this.StickData = param1;
      }
   }
}
