package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class EnvironmentEffectsWidget extends MovieClip
   {
      
      public static var uMinPulseTimeMS:uint = 0;
      
      public static var uMaxPulseTimeMS:uint = 0;
       
      
      public var PulseHolder_mc:MovieClip;
      
      private var ConditionClipsA:Array;
      
      private const MAX_CONDITIONS:uint = 4;
      
      private const INACTIVE_FRAME:uint = 1;
      
      private var PulseSpeedPct:Number = 1;
      
      private var PulseLerp:Number = 0;
      
      private var PulseIncreasing:Boolean = true;
      
      public function EnvironmentEffectsWidget()
      {
         var _loc2_:MovieClip = null;
         this.ConditionClipsA = new Array();
         super();
         var _loc1_:uint = 0;
         while(_loc1_ < this.MAX_CONDITIONS)
         {
            _loc2_ = this.PulseHolder_mc["EnvCondition" + _loc1_ + "_mc"];
            GlobalFunc.BSASSERT(_loc2_ != null,"Missing condition clip in EnvironmentEffectsWidget");
            this.ConditionClipsA.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function UpdateEffects(param1:Array) : *
      {
         var _loc3_:MovieClip = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length && _loc2_ < this.MAX_CONDITIONS)
         {
            if(!this.IsIconInUse(_loc2_,param1[_loc2_].sEffectIcon) && this.ConditionClipsA[_loc2_].currentFrameLabel != param1[_loc2_].sEffectIcon)
            {
               this.ConditionClipsA[_loc2_].gotoAndStop(param1[_loc2_].sEffectIcon);
               this.ConditionClipsA[_loc2_].sEffectIcon = param1[_loc2_].sEffectIcon;
            }
            _loc2_++;
         }
         while(_loc2_ < this.MAX_CONDITIONS)
         {
            if(this.ConditionClipsA[_loc2_].currentFrame != this.INACTIVE_FRAME)
            {
               this.ConditionClipsA[_loc2_].gotoAndStop(this.INACTIVE_FRAME);
               this.ConditionClipsA[_loc2_].sEffectIcon = "";
            }
            _loc2_++;
         }
      }
      
      private function IsIconInUse(param1:uint, param2:String) : Boolean
      {
         var _loc3_:* = false;
         var _loc4_:uint = 0;
         while(_loc4_ <= param1 && !_loc3_)
         {
            _loc3_ = this.ConditionClipsA[_loc4_].sEffectIcon == param2;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function SetPulseSpeedPct(param1:Number, param2:Boolean) : void
      {
         if(param1 >= 0 && param1 <= 1)
         {
            if(param1 == 0 && !param2 || param1 == 1)
            {
               removeEventListener(Event.ENTER_FRAME,this.onPulseUpdate);
               this.PulseHolder_mc.alpha = 1;
            }
            else if(param1 < 1 && !hasEventListener(Event.ENTER_FRAME))
            {
               addEventListener(Event.ENTER_FRAME,this.onPulseUpdate);
            }
            this.PulseSpeedPct = param1;
         }
      }
      
      private function onPulseUpdate() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:Number = GlobalFunc.Lerp(uMinPulseTimeMS,uMaxPulseTimeMS,this.PulseSpeedPct);
         var _loc2_:Number = _loc1_ > 0 ? 1000 / (30 * _loc1_) : 0;
         if(this.PulseIncreasing)
         {
            this.PulseLerp += _loc2_;
            if(this.PulseLerp >= 1)
            {
               this.PulseLerp = 1;
               this.PulseIncreasing = false;
               _loc3_ = 0;
               while(_loc3_ < this.MAX_CONDITIONS)
               {
                  if(this.ConditionClipsA[_loc3_].currentFrame != this.INACTIVE_FRAME)
                  {
                     this.PlayIconPulseSound(this.ConditionClipsA[_loc3_].sEffectIcon);
                  }
                  _loc3_++;
               }
            }
         }
         else
         {
            this.PulseLerp -= _loc2_;
            if(this.PulseLerp <= 0)
            {
               this.PulseLerp = 0;
               this.PulseIncreasing = true;
            }
         }
         this.PulseHolder_mc.alpha = GlobalFunc.Lerp(0,1,this.PulseLerp);
      }
      
      private function PlayIconPulseSound(param1:String) : void
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "HazardEffect_Radiation":
               _loc2_ = "UIHazardRadiationWarningIcon";
               break;
            case "HazardEffect_Thermal":
               _loc2_ = "UIHazardThermalWarningIcon";
               break;
            case "HazardEffect_Airborne":
               _loc2_ = "UIHazardAirborneWarningIcon";
               break;
            case "HazardEffect_Corrosive":
               _loc2_ = "UIHazardCorrosiveWarningIcon";
               break;
            case "HazardEffect_RestoreSoak":
               _loc2_ = "UIHazardSuitSoakRestore_Icon";
         }
         if(_loc2_ != "")
         {
            GlobalFunc.PlayMenuSound(_loc2_);
         }
      }
   }
}
