package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.BSGalaxyTypes;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BottomLeftGroup extends BSDisplayObject
   {
      
      public static const ANIMATION_FINISHED:String = "AnimationFinished";
      
      public static const FADE_IN:uint = EnumHelper.GetEnum(0);
      
      public static const FADE_OUT:uint = EnumHelper.GetEnum();
      
      public static const FADE_IN_ENV:uint = EnumHelper.GetEnum();
      
      public static const FADE_OUT_ENV:uint = EnumHelper.GetEnum();
      
      public static const FADE_IN_BIO:uint = EnumHelper.GetEnum();
      
      public static const FADE_OUT_BIO:uint = EnumHelper.GetEnum();
      
      public static const FADE_IN_PLANET:uint = EnumHelper.GetEnum();
      
      public static const FADE_OUT_PLANET:uint = EnumHelper.GetEnum();
      
      public static const NO_ALERT:uint = EnumHelper.GetEnum(0);
      
      public static const BIO_ALERT:uint = EnumHelper.GetEnum();
      
      public static const ENV_ALERT:uint = EnumHelper.GetEnum();
      
      public static const CUSTOM_ALERT:uint = EnumHelper.GetEnum();
      
      public static const QUEUE_ALERT_IF_UNIQUE:uint = EnumHelper.GetEnum(0);
      
      public static const QUEUE_ALERT_ALWAYS:uint = EnumHelper.GetEnum();
      
      internal static const MAX_COMPASS_ENEMY_MARKERS:uint = 16;
      
      internal static const MAX_COMPASS_QUEST_MARKERS:uint = 16;
      
      internal static const FADE_IN_PLANET_INFO_ANIMATION:String = "FadeInPlanetInfo";
      
      internal static const FADE_OUT_PLANET_INFO_ANIMATION:String = "FadeOutPlanetInfo";
      
      internal static const RAD_TO_DEG:Number = 180 / Math.PI;
       
      
      public var DayCycleBase_mc:MovieClip;
      
      public var O2CO2_mc:MovieClip;
      
      public var O2CO2thin_mc:MovieClip;
      
      public var EnemyDetectionAnim_mc:MovieClip;
      
      public var BioCondition_mc:MovieClip;
      
      public var BioAlertBG_mc:MovieClip;
      
      public var BioAlertText:MovieClip;
      
      public var OffPlanet_mc:MovieClip;
      
      public var locationNameBase_mc:MovieClip;
      
      public var BioConditionBase_mc:MovieClip;
      
      public var EnvConditionBase_mc:MovieClip;
      
      public var LocationAlertText:MovieClip;
      
      public var Temperature_mc:MovieClip;
      
      public var Oxygen_mc:MovieClip;
      
      public var Grav_mc:MovieClip;
      
      public var EnvCondition_mc:MovieClip;
      
      public var EnvAlertText:MovieClip;
      
      public var WatchOutline_mc:MovieClip;
      
      public var WatchPointerOutline_mc:MovieClip;
      
      public var WatchIconsWidget_mc:MovieClip;
      
      public var MissionIconsWidget_mc:MovieClip;
      
      public var EnemyIconsWidget_mc:MovieClip;
      
      private var LocalEnvironmentData:Object;
      
      private var PlayerData:Object = null;
      
      private var AlertTimer:Timer;
      
      private var AnimationQueue:Array;
      
      private var PlayingAnimation:Boolean;
      
      private var WasInSpaceship:Boolean = false;
      
      private var WasScanning:Boolean = false;
      
      private var LastLocationName:String = "";
      
      private var PlanetAlertTimeMS:uint;
      
      private var BioAlertTimeMS:uint;
      
      private var EnvAlertTimeMS:uint;
      
      private var IsInCombat:Boolean = false;
      
      private const DETECTION_FULLY_SEEN:uint = 0;
      
      private const DETECTION_FULLY_HIDDEN:uint = 100;
      
      private var PreviousO2:Number = -1;
      
      private var PreviousCO2:Number = -1;
      
      private var CurrentAnimationName:String = "";
      
      private const MIN_HOURS:uint = 0;
      
      private const MAX_HOURS:uint = 24;
      
      private const MIN_HOURS_FRAME:uint = 1;
      
      private const MAX_HOURS_FRAME:uint = 48;
      
      private const MAX_DEGREES:uint = 360;
      
      private const O2CO2_MIN_FRAME:uint = 1;
      
      private const O2CO2_MAX_FRAME:uint = 60;
      
      private const MAX_LOC_CHARS:uint = 21;
      
      private const FADE_OUT_MS:uint = 3000;
      
      private const O2CO2_O2_MIN_SOUND:String = "VOC_Player_O2_Min";
      
      private const O2CO2_CO2_MAX_SOUND:String = "VOC_Player_CO2_Max";
      
      private const O2CO2_CO2_CLEARED_SOUND:String = "VOC_Player_CO2_Cleared";
      
      public function BottomLeftGroup()
      {
         super();
         this.PlayingAnimation = false;
         this.AnimationQueue = new Array();
         this.AlertTimer = new Timer(this.FADE_OUT_MS,1);
         this.PlanetAlertTimeMS = this.FADE_OUT_MS;
         this.BioAlertTimeMS = this.FADE_OUT_MS;
         this.EnvAlertTimeMS = this.FADE_OUT_MS;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.BioAlertText.Alert_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setVerticalAutoSize(this.BioAlertText.Alert_tf,TextFieldEx.VAUTOSIZE_CENTER);
         TextFieldEx.setTextAutoSize(this.EnvAlertText.Alert_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EnvAlertText.Subtext_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function onAddedToStage() : void
      {
         var fadeData:Object;
         super.onAddedToStage();
         fadeData = {
            "uAnimAlert":NO_ALERT,
            "sFrameLabel":"FadeIn"
         };
         this.PlayAnimation(fadeData);
         this.UpdateLocationName("","");
         GlobalFunc.SetText(this.Temperature_mc.Subtitle_tf,"$TEMP");
         GlobalFunc.SetText(this.Oxygen_mc.Subtitle_tf,"$O2");
         GlobalFunc.SetText(this.Grav_mc.Subtitle_tf,"$GRAV");
         this.EnemyIconsWidget_mc.Configure("EnemyCompassIcon",MAX_COMPASS_ENEMY_MARKERS);
         this.MissionIconsWidget_mc.Configure("MissionCompassIconHolder",MAX_COMPASS_QUEST_MARKERS);
         BSUIDataManager.Subscribe("LocalEnvironmentData",function(param1:FromClientDataEvent):*
         {
            var _loc4_:Object = null;
            var _loc5_:Object = null;
            LocalEnvironmentData = param1.data;
            var _loc2_:Boolean = Boolean(LocalEnvironmentData.bInSpaceship) && !LocalEnvironmentData.bIsLanded;
            DayCycleBase_mc.visible = !_loc2_;
            OffPlanet_mc.visible = _loc2_;
            if(LastLocationName != LocalEnvironmentData.sLocationName)
            {
               UpdateLocationName(LocalEnvironmentData.sLocationName,LocalEnvironmentData.sLanguage);
            }
            AdjustO2Meter();
            PlanetAlertTimeMS = param1.data.uAlertTimeMS;
            GlobalFunc.SetText(LocationAlertText.Planet_tf,LocalEnvironmentData.sBodyName);
            var _loc3_:String = "";
            if(LocationAlertText.Planet_tf.numLines == 1)
            {
               if(_loc2_)
               {
                  _loc3_ = "$SHIP";
               }
               else
               {
                  _loc3_ = BSGalaxyTypes.GetBodyTypeLabel(LocalEnvironmentData.uBodyType);
               }
            }
            GlobalFunc.SetText(LocationAlertText.Type_tf,_loc3_);
            GlobalFunc.SetText(Temperature_mc.Temperature_tf,LocalEnvironmentData.fTemperature.toString() + "°");
            GlobalFunc.SetText(Oxygen_mc.Oxygen_tf,LocalEnvironmentData.fOxygenPercent.toString() + "%");
            GlobalFunc.SetText(Grav_mc.Gravity_tf,GlobalFunc.FormatNumberToString(LocalEnvironmentData.fGravity,2,true));
            if(!WasScanning && Boolean(LocalEnvironmentData.bIsScanning))
            {
               PlayAnimation({
                  "uAnimAlert":NO_ALERT,
                  "sFrameLabel":FADE_IN_PLANET_INFO_ANIMATION
               });
            }
            else if(WasScanning && !LocalEnvironmentData.bIsScanning)
            {
               PlayAnimation({
                  "uAnimAlert":NO_ALERT,
                  "sFrameLabel":FADE_OUT_PLANET_INFO_ANIMATION
               });
            }
            else if(WasInSpaceship && !LocalEnvironmentData.bInSpaceship)
            {
               _loc4_ = {
                  "uAnimAlert":NO_ALERT,
                  "sFrameLabel":FADE_IN_PLANET_INFO_ANIMATION
               };
               PlayAnimation(_loc4_);
               _loc5_ = {
                  "uAnimAlert":NO_ALERT,
                  "sFrameLabel":FADE_OUT_PLANET_INFO_ANIMATION
               };
               PlayAnimation(_loc5_);
            }
            WasInSpaceship = LocalEnvironmentData.bInSpaceship;
            WasScanning = LocalEnvironmentData.bIsScanning;
            LastLocationName = LocalEnvironmentData.sLocationName;
         });
         BSUIDataManager.Subscribe("LocalEnvData_Frequent",function(param1:FromClientDataEvent):*
         {
            var _loc2_:uint = GlobalFunc.MapLinearlyToRange(MIN_HOURS_FRAME,MAX_HOURS_FRAME,0,1,param1.data.fLocalPlanetTime,true);
            if(DayCycleBase_mc.DayCycle_mc.currentFrame != _loc2_)
            {
               DayCycleBase_mc.DayCycle_mc.gotoAndStop(_loc2_);
            }
         });
         BSUIDataManager.Subscribe("PlayerData",function(param1:FromClientDataEvent):*
         {
            IsInCombat = param1.data.bIsInCombat;
            UpdateEnemyDetection();
         });
         BSUIDataManager.Subscribe("PlayerFrequentData",function(param1:FromClientDataEvent):*
         {
            PlayerData = param1.data;
            AdjustO2Meter();
            UpdateEnemyDetection();
         });
         BSUIDataManager.Subscribe("HudCompassData",this.onCompassDataChange);
         BSUIDataManager.Subscribe("PersonalEffectsData",this.onPersonalEffectsDataChange);
         BSUIDataManager.Subscribe("PersonalAlertsData",this.onPersonalAlertsDataChange);
         BSUIDataManager.Subscribe("EnvironmentEffectsData",this.onEnvironmentEffectsDataChange);
         BSUIDataManager.Subscribe("EnvironmentAlertsData",this.onEnvironmentAlertsDataChange);
         BSUIDataManager.Subscribe("CustomAlertsData",this.onCustomAlertsDataChange);
      }
      
      private function UpdateLocationName(param1:String, param2:String) : void
      {
         this.locationNameBase_mc.visible = param2 != "ja" && param2 != "zhhans";
         var _loc3_:uint = uint(param1.length);
         var _loc4_:uint = 0;
         while(_loc4_ < this.MAX_LOC_CHARS)
         {
            if(_loc4_ < _loc3_)
            {
               GlobalFunc.SetText(this.locationNameBase_mc.locationName_mc["char" + _loc4_].char_tf,param1.charAt(_loc4_));
            }
            else
            {
               GlobalFunc.SetText(this.locationNameBase_mc.locationName_mc["char" + _loc4_].char_tf,"");
            }
            _loc4_++;
         }
         var _loc5_:uint = Math.max(_loc3_,1);
         if(this.locationNameBase_mc.currentFrame != _loc5_)
         {
            this.locationNameBase_mc.gotoAndStop(_loc5_);
         }
      }
      
      public function AdjustO2Meter() : void
      {
         var _loc1_:Boolean = this.PlayerData != null && this.PlayerData.fMaxO2CO2 != undefined && this.PlayerData.fMaxO2CO2 != 0;
         var _loc2_:Number = _loc1_ ? (this.PlayerData.fMaxO2CO2 > 0 ? this.PlayerData.fOxygen / this.PlayerData.fMaxO2CO2 : 0) : 1;
         var _loc3_:Number = _loc1_ ? this.PlayerData.fCarbonDioxide / this.PlayerData.fMaxO2CO2 : 1;
         var _loc4_:uint = GlobalFunc.MapLinearlyToRange(this.O2CO2_MIN_FRAME,this.O2CO2_MAX_FRAME,1,0,_loc2_,true);
         if(this.O2CO2_mc.O2Anim_mc.currentFrame != _loc4_)
         {
            this.O2CO2_mc.O2Anim_mc.gotoAndStop(_loc4_);
         }
         if(this.O2CO2thin_mc.O2Anim_mc.currentFrame != _loc4_)
         {
            this.O2CO2thin_mc.O2Anim_mc.gotoAndStop(_loc4_);
         }
         var _loc5_:uint = GlobalFunc.MapLinearlyToRange(this.O2CO2_MIN_FRAME,this.O2CO2_MAX_FRAME,0,1,_loc3_,true);
         if(this.O2CO2_mc.CO2Anim_mc.currentFrame != _loc5_)
         {
            this.O2CO2_mc.CO2Anim_mc.gotoAndStop(_loc5_);
         }
         if(this.O2CO2thin_mc.CO2Anim_mc.currentFrame != _loc5_)
         {
            this.O2CO2thin_mc.CO2Anim_mc.gotoAndStop(_loc5_);
         }
         if(this.PreviousO2 != -1 && this.PreviousCO2 != -1)
         {
            if(!GlobalFunc.CloseToNumber(this.PreviousO2,0) && GlobalFunc.CloseToNumber(_loc2_,0))
            {
               GlobalFunc.PlayMenuSound(this.O2CO2_O2_MIN_SOUND);
            }
            if(!GlobalFunc.CloseToNumber(this.PreviousCO2,0) && GlobalFunc.CloseToNumber(_loc3_,0))
            {
               GlobalFunc.PlayMenuSound(this.O2CO2_CO2_CLEARED_SOUND);
            }
            if(!GlobalFunc.CloseToNumber(this.PreviousCO2,1) && GlobalFunc.CloseToNumber(_loc3_,1))
            {
               GlobalFunc.PlayMenuSound(this.O2CO2_CO2_MAX_SOUND);
            }
         }
         this.PreviousO2 = _loc2_;
         this.PreviousCO2 = _loc3_;
      }
      
      public function onCompassDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:Number = this.MAX_DEGREES - param1.data.fDirection * RAD_TO_DEG;
         this.WatchPointerOutline_mc.WatchPointerRotationClip_mc.rotation = _loc2_;
         this.WatchPointerOutline_mc.WatchInertiaRotationClip_mc.rotation = _loc2_;
         this.WatchIconsWidget_mc.onCompassDataChange(param1);
         this.MissionIconsWidget_mc.onDataChange(param1.data.aMissionMarkers,param1.data.fDirection);
         this.EnemyIconsWidget_mc.onDataChange(param1.data.aEnemyMarkers,param1.data.fDirection);
      }
      
      public function onPersonalEffectsDataChange(param1:FromClientDataEvent) : *
      {
         this.BioAlertTimeMS = param1.data.uAlertTimeMS;
         this.BioConditionBase_mc.UpdateEffects(param1.data.aPersonalEffects);
      }
      
      public function onPersonalAlertsDataChange(param1:FromClientDataEvent) : *
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.aPersonalAlerts.length)
         {
            _loc3_ = {
               "uAnimAlert":BIO_ALERT,
               "sFrameLabel":"FadeInBioAlert",
               "sIconID":param1.data.aPersonalAlerts[_loc2_].sEffectIcon,
               "sAlertText":param1.data.aPersonalAlerts[_loc2_].sAlertText,
               "sAlertSubText":param1.data.aPersonalAlerts[_loc2_].sAlertSubText,
               "sExtraSound":"UIAfflictionPainWarningScreenOn"
            };
            if(this.PlayAnimation(_loc3_))
            {
               _loc4_ = {
                  "uAnimAlert":NO_ALERT,
                  "sFrameLabel":"FadeOutBioAlert",
                  "sExtraSound":"UIAfflictionPainWarningScreenOff"
               };
               this.PlayAnimation(_loc4_,QUEUE_ALERT_ALWAYS);
            }
            _loc2_++;
         }
      }
      
      public function onEnvironmentEffectsDataChange(param1:FromClientDataEvent) : *
      {
         this.EnvAlertTimeMS = param1.data.uAlertTimeMS;
         EnvironmentEffectsWidget.uMinPulseTimeMS = param1.data.uEnvIconPulseMinMS;
         EnvironmentEffectsWidget.uMaxPulseTimeMS = param1.data.uEnvIconPulseMaxMS;
         this.EnvConditionBase_mc.UpdateEffects(param1.data.aEnvironmentEffects);
         this.EnvConditionBase_mc.SetPulseSpeedPct(param1.data.fSoakDamagePct,param1.data.bShouldPlayAlertAtFullSoak);
         this.WatchIconsWidget_mc.onEnvironmentalDataChange(param1);
      }
      
      public function onEnvironmentAlertsDataChange(param1:FromClientDataEvent) : *
      {
         var _loc3_:* = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.aEnvironmentAlerts.length)
         {
            _loc3_ = param1.data.aEnvironmentAlerts[_loc2_].bIsPositive === true;
            _loc4_ = _loc3_ ? "FadeInEnvAlert_Positive" : "FadeInEnvAlert";
            _loc5_ = _loc3_ ? "FadeOutEnvAlert_Positive" : "FadeOutEnvAlert";
            _loc6_ = {
               "uAnimAlert":ENV_ALERT,
               "sFrameLabel":_loc4_,
               "sIconID":param1.data.aEnvironmentAlerts[_loc2_].sEffectIcon,
               "sAlertText":param1.data.aEnvironmentAlerts[_loc2_].sAlertText,
               "sAlertSubText":param1.data.aEnvironmentAlerts[_loc2_].sAlertSubText
            };
            if(this.PlayAnimation(_loc6_))
            {
               _loc7_ = {
                  "uAnimAlert":NO_ALERT,
                  "sFrameLabel":_loc5_
               };
               this.PlayAnimation(_loc7_,QUEUE_ALERT_ALWAYS);
            }
            _loc2_++;
         }
      }
      
      public function onCustomAlertsDataChange(param1:FromClientDataEvent) : *
      {
         var _loc3_:Object = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.aAlerts.length)
         {
            _loc3_ = {
               "uAnimAlert":CUSTOM_ALERT,
               "sFrameLabel":param1.data.aAlerts[_loc2_].sAlertText,
               "sIconID":param1.data.aAlerts[_loc2_].sAlertText
            };
            this.PlayAnimation(_loc3_);
            _loc2_++;
         }
      }
      
      private function UpdateEnemyDetection() : *
      {
         var _loc1_:* = this.EnemyDetectionAnim_mc.currentFrame != 1;
         var _loc2_:Boolean = this.IsInCombat && this.PlayerData.uDetectionLevel < this.DETECTION_FULLY_HIDDEN;
         if(_loc1_ && !_loc2_)
         {
            this.EnemyDetectionAnim_mc.gotoAndStop("Off");
         }
         else if(!_loc1_ && _loc2_)
         {
            this.EnemyDetectionAnim_mc.gotoAndPlay("Open");
         }
      }
      
      public function FadeOut() : *
      {
         var _loc1_:Object = {
            "uAnimAlert":NO_ALERT,
            "sFrameLabel":"FadeOut"
         };
         this.PlayAnimation(_loc1_);
      }
      
      private function PlayAnimation(param1:Object, param2:int = 0) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:* = !this.PlayingAnimation;
         if(_loc3_)
         {
            this.PlayingAnimation = true;
            _loc3_ = true;
            switch(param1.uAnimAlert)
            {
               case BIO_ALERT:
                  this.BioCondition_mc.gotoAndStop(param1.sIconID);
                  this.PlayAlertSound(param1.sIconID);
                  GlobalFunc.SetText(this.BioAlertText.Alert_tf,param1.sAlertText);
                  break;
               case ENV_ALERT:
                  this.EnvCondition_mc.gotoAndStop(param1.sIconID);
                  this.PlayAlertSound(param1.sIconID);
                  GlobalFunc.SetText(this.EnvAlertText.Alert_tf,param1.sAlertText);
                  GlobalFunc.SetText(this.EnvAlertText.Subtext_tf,param1.sAlertSubText);
                  break;
               case CUSTOM_ALERT:
                  GlobalFunc.PlayMenuSound("UIWatchAlert_" + param1.sIconID);
            }
            this.CurrentAnimationName = param1.sFrameLabel;
            gotoAndPlay(param1.sFrameLabel);
            addEventListener(ANIMATION_FINISHED,this.AnimationFinished);
            if(param1.sExtraSound != null)
            {
               GlobalFunc.PlayMenuSound(param1.sExtraSound);
            }
         }
         else
         {
            if(param2 == QUEUE_ALERT_ALWAYS)
            {
               _loc3_ = true;
            }
            else
            {
               _loc3_ = this.CurrentAnimationName != param1.sFrameLabel;
               if(_loc3_)
               {
                  _loc4_ = 0;
                  while(_loc4_ < this.AnimationQueue.length)
                  {
                     _loc3_ = this.AnimationQueue[_loc4_].sFrameLabel != param1.sFrameLabel || this.AnimationQueue[_loc4_].sAlertText != param1.sAlertText || this.AnimationQueue[_loc4_].sAlertSubText != param1.sAlertSubText;
                     if(!_loc3_)
                     {
                        break;
                     }
                     _loc4_++;
                  }
               }
            }
            if(_loc3_)
            {
               this.AnimationQueue.push(param1);
            }
         }
         return _loc3_;
      }
      
      private function PlayAlertSound(param1:String) : void
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "HazardEffect_Radiation":
               _loc2_ = "UIHazardRadiationWarningScreen";
               break;
            case "HazardEffect_Thermal":
               _loc2_ = "UIHazardThermalWarningScreen";
               break;
            case "HazardEffect_Airborne":
               _loc2_ = "UIHazardAirborneWarningScreen";
               break;
            case "HazardEffect_Corrosive":
               _loc2_ = "UIHazardCorrosiveWarningScreen";
               break;
            case "HazardEffect_RestoreSoak":
               _loc2_ = "UIHazardSuitSoakRestore_WarningScreen";
               break;
            case "PersonalEffect_CardioRespiratoryCirculatory":
               _loc2_ = "UIHazardDamagePermanent";
               break;
            case "PersonalEffect_SkeletalMuscular":
               _loc2_ = "UIHazardDamagePermanent";
               break;
            case "PersonalEffect_NervousSystem":
               _loc2_ = "UIHazardDamagePermanent";
               break;
            case "PersonalEffect_DigestiveImmune":
               _loc2_ = "UIHazardDamagePermanent";
               break;
            case "PersonalEffect_Misc":
               _loc2_ = "UIHazardDamagePermanent";
         }
         if(_loc2_ != "")
         {
            GlobalFunc.PlayMenuSound(_loc2_);
         }
      }
      
      public function AnimationFinished(param1:CustomEvent) : void
      {
         var _loc2_:uint = 0;
         removeEventListener(ANIMATION_FINISHED,this.AnimationFinished);
         if(this.NeedsTimer(param1.params.animFinished))
         {
            _loc2_ = this.FADE_OUT_MS;
            if(param1.params.animFinished == FADE_IN_BIO)
            {
               _loc2_ = this.BioAlertTimeMS;
            }
            else if(param1.params.animFinished == FADE_IN_ENV)
            {
               _loc2_ = this.EnvAlertTimeMS;
            }
            else if(param1.params.animFinished == FADE_IN_PLANET)
            {
               _loc2_ = this.PlanetAlertTimeMS;
            }
            this.AlertTimer.delay = _loc2_;
            this.AlertTimer.reset();
            this.AlertTimer.start();
            this.AlertTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.PlayNextInQueue);
         }
         else
         {
            this.PlayNextInQueue();
         }
      }
      
      private function NeedsTimer(param1:uint) : Boolean
      {
         return param1 == FADE_IN_BIO || param1 == FADE_IN_ENV || param1 == FADE_IN_PLANET && !this.WasScanning;
      }
      
      private function PlayNextInQueue() : void
      {
         this.PlayingAnimation = false;
         this.CurrentAnimationName = "";
         var _loc1_:Object = this.AnimationQueue.shift();
         if(_loc1_ != null)
         {
            this.PlayAnimation(_loc1_);
         }
      }
   }
}
