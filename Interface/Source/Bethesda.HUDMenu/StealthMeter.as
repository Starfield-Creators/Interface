package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class StealthMeter extends BSDisplayObject
   {
      
      private static const LOWEST_DETECTION_LEVEL:Number = -20;
      
      public static const STEALTH_PERCENT_MODIFIER:Number = 0.7;
      
      public static const PCSM_HIDDEN:uint = EnumHelper.GetEnum(0);
      
      public static const PCSM_DETECTED:uint = EnumHelper.GetEnum();
      
      public static const PCSM_CAUTION:uint = EnumHelper.GetEnum();
      
      public static const PCSM_EVADING:uint = EnumHelper.GetEnum();
      
      public static const PCSM_DANGER:uint = EnumHelper.GetEnum();
      
      public static const PCSM_COUNT:uint = EnumHelper.GetEnum();
       
      
      public var StealthMeter_BG:MovieClip;
      
      public var StealthSecondaryColor_BG:MovieClip;
      
      public var StealthText:MovieClip;
      
      public var StealthPointsBar:MovieClip;
      
      public var StealthinessPips:MovieClip;
      
      internal var LastPercent:Number = 0;
      
      internal var LastSneakMode:uint;
      
      internal var LastSecondarySneakMode:uint;
      
      internal var LastSneaking:Boolean = false;
      
      internal var CurrentPercent:Number = 0;
      
      private const HIDDEN_STATE:String = "Hidden";
      
      private const CAUTION_STATE:String = "Caution";
      
      private const DETECTED_STATE:String = "Detected";
      
      private const DANGER_STATE:String = "Danger";
      
      private const HIDDEN_FADE_IN_STATE:String = "Hidden_FadeIn";
      
      private const CAUTION_FADE_IN_STATE:String = "Caution_FadeIn";
      
      private const DETECTED_FADE_IN_STATE:String = "Detected_FadeIn";
      
      private const DANGER_FADE_IN_STATE:String = "Danger_FadeIn";
      
      private const EVADE_FADE_IN_STATE:String = "Evade_FadeIn";
      
      private const ANIM_STATE_NONE:uint = EnumHelper.GetEnum(0);
      
      private const ANIM_STATE_ENTER_MODE_CHANGE:uint = EnumHelper.GetEnum();
      
      private const ANIM_STATE_MODE_CHANGE_FILLING_UP:uint = EnumHelper.GetEnum();
      
      private const ANIM_STATE_MODE_CHANGE_EMPTYING_TO_NEW_SECONDARY:uint = EnumHelper.GetEnum();
      
      private const ANIM_STATE_ENTER_SECONDARY_MODE_CHANGE:uint = EnumHelper.GetEnum();
      
      private const ANIM_STATE_SECONDARY_MODE_CHANGE_EMPTYING:uint = EnumHelper.GetEnum();
      
      private const ANIM_SPEED:Number = 8;
      
      private const HIDDEN_STATE_ANIM_SPEED_FACTOR:Number = 5;
      
      private var CurrentAnimationState:uint;
      
      private var StartMode:uint;
      
      private var TargetMode:uint;
      
      private var TargetSecondaryMode:uint;
      
      private var TargetPercent:Number = 0;
      
      private var CurrentlyInCombat:Boolean = false;
      
      private var bEasing:Boolean = false;
      
      private const MIN_SPEED:Number = 1;
      
      private const SPEED_FACTOR:Number = 10;
      
      private const LEFT_BAR_POINTS:Point = new Point(0,0);
      
      private const RIGHT_BAR_POINTS:Point = new Point(0,0);
      
      public function StealthMeter()
      {
         this.LastSneakMode = PCSM_COUNT;
         this.LastSecondarySneakMode = PCSM_COUNT;
         this.CurrentAnimationState = this.ANIM_STATE_NONE;
         this.StartMode = PCSM_COUNT;
         this.TargetMode = PCSM_COUNT;
         this.TargetSecondaryMode = PCSM_COUNT;
         super();
         this.LastPercent = 0;
         visible = false;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("HUDStealthData",this.SetStealthMeter);
      }
      
      private function ModifyCurrentPercent(param1:Number) : *
      {
         this.CurrentPercent += param1;
         this.CurrentPercent = GlobalFunc.Clamp(this.CurrentPercent,0,100);
         this.SetStealthPointsBarPercent(this.CurrentPercent);
      }
      
      private function StartModeAnimation(param1:uint) : *
      {
         this.CurrentAnimationState = param1;
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function StartEasingAnimation() : *
      {
         this.bEasing = true;
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function AreSneakModesEqual(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:* = false;
         if((param1 == PCSM_CAUTION || param1 == PCSM_EVADING) && (param2 == PCSM_CAUTION || param2 == PCSM_EVADING))
         {
            _loc3_ = true;
         }
         else
         {
            _loc3_ = param1 == param2;
         }
         return _loc3_;
      }
      
      private function onEnterFrame(param1:Event) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!visible)
         {
            return;
         }
         if(this.CurrentAnimationState != this.ANIM_STATE_NONE)
         {
            switch(this.CurrentAnimationState)
            {
               case this.ANIM_STATE_ENTER_MODE_CHANGE:
                  if(!this.AreSneakModesEqual(this.LastSecondarySneakMode,this.TargetMode))
                  {
                     this.CurrentAnimationState = this.ANIM_STATE_MODE_CHANGE_EMPTYING_TO_NEW_SECONDARY;
                  }
                  else
                  {
                     this.CurrentAnimationState = this.ANIM_STATE_MODE_CHANGE_FILLING_UP;
                     this.UpdateSecondaryMeter(this.TargetMode);
                  }
                  break;
               case this.ANIM_STATE_MODE_CHANGE_EMPTYING_TO_NEW_SECONDARY:
                  this.ModifyCurrentPercent(-this.ANIM_SPEED);
                  if(this.CurrentPercent <= 0)
                  {
                     this.CurrentAnimationState = this.ANIM_STATE_MODE_CHANGE_FILLING_UP;
                     this.UpdateMeters(this.StartMode);
                     this.UpdateSecondaryMeter(this.TargetMode);
                     this.LastSecondarySneakMode = this.TargetMode;
                  }
                  break;
               case this.ANIM_STATE_MODE_CHANGE_FILLING_UP:
                  this.ModifyCurrentPercent(this.ANIM_SPEED);
                  if(this.CurrentPercent >= 100)
                  {
                     this.LastSneakMode = this.TargetMode;
                     this.LastSecondarySneakMode = this.TargetSecondaryMode;
                     this.UpdateMeters(this.TargetMode);
                     this.UpdateSecondaryMeter(this.TargetSecondaryMode);
                     this.CurrentPercent = 0;
                     this.SetStealthPointsBarPercent(this.CurrentPercent);
                     this.CurrentAnimationState = this.ANIM_STATE_NONE;
                     this.TargetMode = PCSM_COUNT;
                     this.TargetSecondaryMode = PCSM_COUNT;
                     this.StartMode = PCSM_COUNT;
                     if(this.CurrentPercent != this.LastPercent)
                     {
                        this.bEasing = true;
                     }
                  }
                  break;
               case this.ANIM_STATE_ENTER_SECONDARY_MODE_CHANGE:
                  this.CurrentAnimationState = this.ANIM_STATE_SECONDARY_MODE_CHANGE_EMPTYING;
                  break;
               case this.ANIM_STATE_SECONDARY_MODE_CHANGE_EMPTYING:
                  this.ModifyCurrentPercent(-this.ANIM_SPEED);
                  if(this.CurrentPercent <= 0)
                  {
                     this.LastSneakMode = this.TargetMode;
                     this.LastSecondarySneakMode = this.TargetSecondaryMode;
                     this.UpdateMeters(this.LastSneakMode);
                     this.UpdateSecondaryMeter(this.TargetSecondaryMode);
                     this.CurrentPercent = 0;
                     this.SetStealthPointsBarPercent(this.CurrentPercent);
                     this.CurrentAnimationState = this.ANIM_STATE_NONE;
                     this.TargetMode = PCSM_COUNT;
                     this.TargetSecondaryMode = PCSM_COUNT;
                     this.StartMode = PCSM_COUNT;
                     if(this.CurrentPercent != this.LastPercent)
                     {
                        this.bEasing = true;
                     }
                  }
            }
         }
         else if(this.bEasing)
         {
            if(this.CurrentPercent == this.LastPercent)
            {
               this.SetStealthPointsBarPercent(this.CurrentPercent);
               this.bEasing = false;
               return;
            }
            _loc2_ = this.LastPercent - this.CurrentPercent;
            _loc3_ = Math.floor(Math.abs(_loc2_) / this.SPEED_FACTOR) + 1;
            _loc3_ = Math.min(_loc3_,this.MIN_SPEED) * (this.LastSneakMode == PCSM_HIDDEN ? this.HIDDEN_STATE_ANIM_SPEED_FACTOR : 1);
            this.CurrentPercent += _loc2_ > 0 ? _loc3_ : -_loc3_;
            if(_loc2_ > 0)
            {
               if(this.CurrentPercent >= this.LastPercent)
               {
                  this.CurrentPercent = this.LastPercent;
                  this.bEasing = false;
               }
            }
            else if(this.CurrentPercent <= this.LastPercent)
            {
               this.CurrentPercent = this.LastPercent;
               this.bEasing = false;
            }
            this.SetStealthPointsBarPercent(this.CurrentPercent);
         }
         if(!this.bEasing && this.CurrentAnimationState == this.ANIM_STATE_NONE || visible == false)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function SetStealthPointsBarPercent(param1:Number) : *
      {
         this.StealthPointsBar.gotoAndStop((this.StealthPointsBar.totalFrames - 1) * (param1 / 100));
      }
      
      private function UpdateMeters(param1:uint) : *
      {
         switch(param1)
         {
            case PCSM_HIDDEN:
               this.StealthText.gotoAndPlay(this.HIDDEN_FADE_IN_STATE);
               this.StealthMeter_BG.gotoAndStop(this.HIDDEN_STATE);
               break;
            case PCSM_CAUTION:
               this.StealthText.gotoAndPlay(this.CAUTION_FADE_IN_STATE);
               this.StealthMeter_BG.gotoAndStop(this.CAUTION_STATE);
               break;
            case PCSM_EVADING:
               this.StealthText.gotoAndPlay(this.EVADE_FADE_IN_STATE);
               this.StealthMeter_BG.gotoAndStop(this.CAUTION_STATE);
               break;
            case PCSM_DETECTED:
               this.StealthText.gotoAndPlay(this.DETECTED_FADE_IN_STATE);
               this.StealthMeter_BG.gotoAndStop(this.DETECTED_STATE);
               break;
            case PCSM_DANGER:
               this.StealthText.gotoAndPlay(this.DANGER_FADE_IN_STATE);
               this.StealthMeter_BG.gotoAndStop(this.DANGER_STATE);
               break;
            default:
               GlobalFunc.TraceWarning("Unhandled sneak mode: " + param1);
         }
      }
      
      private function UpdateSecondaryMeter(param1:uint) : *
      {
         switch(param1)
         {
            case PCSM_HIDDEN:
               this.StealthSecondaryColor_BG.gotoAndStop(this.HIDDEN_STATE);
               break;
            case PCSM_CAUTION:
            case PCSM_EVADING:
               this.StealthSecondaryColor_BG.gotoAndStop(this.CAUTION_STATE);
               break;
            case PCSM_DETECTED:
               this.StealthSecondaryColor_BG.gotoAndStop(this.DETECTED_STATE);
               break;
            case PCSM_DANGER:
               this.StealthSecondaryColor_BG.gotoAndStop(this.DANGER_STATE);
               break;
            default:
               GlobalFunc.TraceWarning("Unhandled sneak mode: " + param1);
         }
      }
      
      private function IsCurrentlyAnimatingModeChange() : Boolean
      {
         return this.CurrentAnimationState == this.ANIM_STATE_ENTER_MODE_CHANGE || this.CurrentAnimationState == this.ANIM_STATE_MODE_CHANGE_EMPTYING_TO_NEW_SECONDARY || this.CurrentAnimationState == this.ANIM_STATE_MODE_CHANGE_FILLING_UP;
      }
      
      private function ForceState(param1:Number, param2:uint, param3:uint) : *
      {
         this.bEasing = false;
         this.CurrentPercent = param1;
         this.TargetMode = PCSM_COUNT;
         this.TargetSecondaryMode = PCSM_COUNT;
         this.StartMode = PCSM_COUNT;
         this.LastSneakMode = param2;
         this.LastSecondarySneakMode = param3;
         this.UpdateMeters(this.LastSneakMode);
         this.UpdateSecondaryMeter(this.LastSecondarySneakMode);
         this.SetStealthPointsBarPercent(param1);
      }
      
      public function SetStealthMeter(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         var _loc3_:* = this.LastSneaking != _loc2_.bSneaking;
         var _loc4_:* = "";
         visible = _loc2_.bSneaking === true && _loc2_.bShowMeter === true;
         this.StealthinessPips.visible = _loc2_.bShowSoundLevels === true;
         var _loc5_:Number = Number(_loc2_.fPercent);
         if(_loc2_.fLowestDetectionLevel == 0)
         {
            _loc2_.fLowestDetectionLevel = LOWEST_DETECTION_LEVEL;
         }
         if(visible)
         {
            switch(_loc2_.uSneakMode)
            {
               case PCSM_HIDDEN:
                  _loc5_ = GlobalFunc.MapLinearlyToRange(0,100,_loc2_.fLowestDetectionLevel,0,_loc2_.fSecondaryPercent,false);
                  break;
               case PCSM_CAUTION:
               case PCSM_EVADING:
                  if(_loc2_.uNextSneakMode == PCSM_DANGER || _loc2_.uNextSneakMode == PCSM_DETECTED)
                  {
                     if(_loc2_.bIsInCombat)
                     {
                        _loc5_ = 100 - _loc2_.fSecondaryPercent / _loc2_.fLowestDetectionLevel * 100;
                     }
                     else
                     {
                        _loc5_ = 100 - _loc5_;
                     }
                  }
            }
            if(_loc3_)
            {
               this.ForceState(_loc5_,_loc2_.uSneakMode,_loc2_.uNextSneakMode);
               this.CurrentlyInCombat = _loc2_.bIsInCombat;
            }
            else if(this.CurrentAnimationState == this.ANIM_STATE_NONE && this.CurrentPercent != _loc5_)
            {
               this.StartEasingAnimation();
            }
            if(!this.AreSneakModesEqual(this.LastSneakMode,_loc2_.uSneakMode) && !this.AreSneakModesEqual(this.TargetMode,_loc2_.uSneakMode))
            {
               if((this.LastSneakMode == PCSM_DETECTED || this.TargetMode == PCSM_DETECTED) && _loc2_.uSneakMode == PCSM_HIDDEN)
               {
                  _loc3_ = true;
               }
               else if((this.LastSneakMode == PCSM_CAUTION || this.TargetMode == PCSM_CAUTION) && _loc2_.uSneakMode == PCSM_HIDDEN && (!_loc2_.bIsInCombat && !this.CurrentlyInCombat))
               {
                  _loc3_ = true;
               }
               if(_loc3_)
               {
                  this.LastSneakMode = _loc2_.uSneakMode;
                  this.LastSecondarySneakMode = _loc2_.uNextSneakMode;
                  this.UpdateMeters(this.LastSneakMode);
                  this.UpdateSecondaryMeter(this.LastSecondarySneakMode);
                  this.CurrentPercent = _loc5_ == 0 ? 0 : 100;
                  this.SetStealthPointsBarPercent(this.CurrentPercent);
               }
               else
               {
                  this.StartMode = this.LastSneakMode;
                  this.TargetMode = _loc2_.uSneakMode;
                  this.TargetSecondaryMode = _loc2_.uNextSneakMode;
                  this.StartModeAnimation(this.ANIM_STATE_ENTER_MODE_CHANGE);
                  this.bEasing = false;
               }
               this.CurrentlyInCombat = _loc2_.bIsInCombat;
            }
            else if(this.IsCurrentlyAnimatingModeChange())
            {
               this.TargetSecondaryMode = _loc2_.uNextSneakMode;
            }
            else if(!this.AreSneakModesEqual(this.LastSecondarySneakMode,_loc2_.uNextSneakMode) && !this.AreSneakModesEqual(this.TargetSecondaryMode,_loc2_.uNextSneakMode))
            {
               this.TargetMode = _loc2_.uSneakMode;
               this.TargetSecondaryMode = _loc2_.uNextSneakMode;
               this.StartModeAnimation(this.ANIM_STATE_ENTER_SECONDARY_MODE_CHANGE);
               this.bEasing = false;
            }
            if(_loc2_.fMaxStealthinessRating > 0)
            {
               this.StealthinessPips.gotoAndStop((this.StealthinessPips.totalFrames - 1) * (_loc2_.fStealthinessRating / _loc2_.fMaxStealthinessRating));
            }
         }
         this.LastPercent = _loc5_;
         this.LastSneaking = _loc2_.bSneaking;
         this.LastSneakMode = _loc2_.uSneakMode;
      }
   }
}
