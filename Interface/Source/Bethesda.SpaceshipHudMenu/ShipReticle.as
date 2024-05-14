package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.DataProviderUtils;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Patterns.BaseStateMachine;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.HoldButton;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.ShipInfoUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import scaleform.gfx.Extensions;
   
   public class ShipReticle extends BSDisplayObject
   {
      
      private static const X_Y_MAGNITUDE:uint = 20;
      
      private static const Z_MAGNITUDE:Number = 0.1;
      
      private static const ROTATION_MAGNITUDE:uint = 4;
      
      private static const RETICLE_MOVEMENT_LERP_SPEED:Number = 0.1;
      
      private static const RETICLE_SCALE_LERP_SPEED:Number = 0.1;
      
      private static const RETICLE_ROT_LERP_SPEED:Number = 0.1;
      
      private static const GROUP_ENUM_TO_NAME:Array = ["Right","Left","Top"];
      
      private static const WEAPON_LABEL_PADDING:Number = 10;
      
      private static const BOOST_OFFSET:Number = -35;
      
      private static const ON_LONG_ANIM_FINISHED_EVENT:String = "Reticle_OnLongAnimFinished";
      
      private static const WEAPON_FULL_FRAME:uint = 1;
      
      private static const WEAPON_EMPTY_FRAME:uint = 100;
      
      private static const AIM_ASSIST_INTERPOLATION_TIME_S:Number = 0.75;
      
      private static const ROLL_INDICATOR_MAX_ANGLE:Number = 25;
      
      private static const ROLL_INDICATOR_ROTATION_PERCENT_PER_FRAME:Number = 0.15;
      
      private static const RETICLE_RADIUS:Number = 250;
      
      private static const RETICLE_RADIUS_SQR:Number = RETICLE_RADIUS * RETICLE_RADIUS;
      
      private static const NUM_WEAPONS_PER_GROUP:uint = 1;
      
      private static const NUM_WEAPON_GROUPS:uint = 3;
      
      private static const OVERLAP_HORIZONTAL_PARTITIONS:uint = 3;
      
      private static const OVERLAP_VERTICAL_PARTITIONS:uint = 6;
      
      public static const ShipHud_Land:String = "ShipHud_Land";
      
      public static const ShipHud_Map:String = "ShipHud_Map";
      
      public static const ShipHud_LandingMarkerMap:String = "ShipHud_LandingMarkerMap";
      
      public static const ShipHud_FarTravel:String = "ShipHud_FarTravel";
      
      public static const Reticle_FarTravelInitiate:String = "Reticle_FarTravelInitiate";
      
      public static const Reticle_FarTravelComplete:String = "Reticle_FarTravelComplete";
      
      public static const ShipHud_BodyViewMarkerDimensions:String = "ShipHud_BodyViewMarkerDimensions";
      
      public static const ShipHud_Target:String = "ShipHud_Target";
      
      private static const ShipHud_OnMonocleToggle:String = "ShipHud_OnMonocleToggle";
      
      private static const MinRectIntersectPercent:Number = 0.1;
      
      private static const MaxRectIntersectPercent:Number = 0.3;
      
      private static const MinRectIntersectAlpha:Number = 1;
      
      private static const MaxRectIntersectAlpha:Number = 0;
      
      private static const MinBlockingAlpha:Number = 0.3;
      
      private static const BODY_VIEW_VERTICAL_SPACING:Number = 25;
      
      private static const COMPONENT_DAMAGED_SOUND:String = "UICockpitShipDamageComponentDamaged";
      
      private static const COMPONENT_OFFLINE_SOUND:String = "UICockpitShipDamageComponentOffline";
      
      public static const STATE_CLOSED_LANDED:uint = EnumHelper.GetEnum();
      
      public static const STATE_CLOSED_RESEATED:uint = EnumHelper.GetEnum();
      
      public static const STATE_CLOSED_TRAVEL:uint = EnumHelper.GetEnum();
      
      public static const STATE_MAIN:uint = EnumHelper.GetEnum();
      
      public static const STATE_MONOCLE:uint = EnumHelper.GetEnum();
      
      public static const STATE_FAR_TRAVEL:uint = EnumHelper.GetEnum();
      
      public static const STATE_TARGETING:uint = EnumHelper.GetEnum();
      
      private static var INDICATOR_CLIPS:Array = new Array();
      
      private static var HIDE_CLASSES:Array = new Array();
      
      private static const NAME_PLATE_X:Number = -136.3;
      
      private static const NAME_PLATE_Y:Number = -310;
      
      private static const ALERT_OPEN:String = "Open";
      
      private static const ALERT_CLOSE:* = "Close";
      
      private static const WEAPON_NORMAL:* = "Normal";
      
      private static const WEAPON_DAMAGED:* = "Damaged";
       
      
      public var ShipReticle_mc:MovieClip;
      
      public var BodyViewMarker_mc:MovieClip;
      
      public var IndicatorButtonBar_mc:ButtonBar;
      
      public var ScanClip:ScanDetails;
      
      private var ReticleTransformInputDir:Vector3D;
      
      private var OriginalReticleLocation:Vector3D;
      
      private var GlobalHeadingPosition:Point;
      
      private var AimAssistPosition:Point;
      
      private var LastFriendly:Boolean = false;
      
      private var ShowAimAssist:Boolean = false;
      
      private var AimAssistTimeTracker:Number = 0;
      
      private var CurrentInfoTargetID:uint = 0;
      
      private var ShipHudMode:uint;
      
      private var InitiatingFarTravel:Boolean = false;
      
      private var Playing:Boolean = true;
      
      private var MonocleMode:Boolean = false;
      
      private var TargetMonocleMode:Boolean = false;
      
      private var ShowIcons:Boolean = false;
      
      private var CanClearIcons:Boolean = false;
      
      private var TargetOnlyDirty:Boolean = false;
      
      private var LowFreqDirty:Boolean = false;
      
      private var CombatValuesDirty:Boolean = false;
      
      private var HighFreqDirty:Boolean = false;
      
      private var MonocleDirty:Boolean = false;
      
      private var GravJumpInitiated:Boolean = false;
      
      private var LatestPayloadData:Object;
      
      private var HighFreqTargetData:Object;
      
      private var LowFreqTargetData:Object;
      
      private var CombatValuesData:Object;
      
      private var TargetOnlyData:Object;
      
      private var ShipComponentData:Object;
      
      private var MapButtonHintData:ButtonBaseData;
      
      private var LandingMarkerMapButtonHintData:ButtonBaseData;
      
      private var LandButtonHintData:ButtonBaseData;
      
      private var LandButton:ReticleBaseButton;
      
      private var LastLandButtonData:ButtonBaseData;
      
      private var SelectTargetButtonData:ButtonBaseData;
      
      private var SelectTargetButton:ReticleBaseButton;
      
      private var Weapon0ButtonData:ButtonBaseData;
      
      private var Weapon1ButtonData:ButtonBaseData;
      
      private var Weapon2ButtonData:ButtonBaseData;
      
      private var WeaponButtonData:Array;
      
      private var BoostButtonData:ButtonBaseData;
      
      private var _monocleButton:ButtonBaseData;
      
      private var OffScreenIndicators:Object;
      
      private var OnScreenIndicators:Array;
      
      private var OffScreenIndicatorArray:Array;
      
      private var OnScreenIndicatorArrays:Array;
      
      private var Initialized:Boolean = false;
      
      private var HoveringOnLandingMarker:Boolean = false;
      
      private var TargetReticleRotation:Number = 0;
      
      private var TargetComponentIndicators:Array;
      
      private var LastTargetIndicatorCount:int = 0;
      
      private var LastInfoTargetIndex:int = -1;
      
      private var LowFreqChanges:Array;
      
      private var CombatValuesChanges:Array;
      
      private var SafeRectTop:Number;
      
      private var SafeRectBottom:Number;
      
      private var SafeRectLeft:Number;
      
      private var SafeRectRight:Number;
      
      private var SafeRectXMid:Number;
      
      private var SafeRectYMid:Number;
      
      private var LastLockTargetLockStrengthFrame:int = 0;
      
      private var LastAPBarFrame:int = 0;
      
      private var LastTargetModeActive:Boolean = false;
      
      private var LastEngineDamaged:Boolean = false;
      
      private var LastShieldDamaged:Boolean = false;
      
      private var LastGravDamaged:Boolean = false;
      
      private var LastHullDamaged:Boolean = false;
      
      private var LastFarTravling:Boolean = false;
      
      private var LastTargetModeAllowed:Boolean = false;
      
      private var FarTravelID:uint = 4294967295;
      
      private var HullAlertThreshold:Number;
      
      private var SystemAlertThreshold:Number;
      
      private var UpdateCounter:uint = 0;
      
      private var OverlapPartitions:Array;
      
      private var StateMachine:BaseStateMachine;
      
      private var QueuedState:uint = 4294967295;
      
      private var HeadingReticle_mc:MovieClip;
      
      private var ThrottleComponent_mc:ThrottleComponent;
      
      private var BoostComponent_mc:BoostComponent;
      
      private var LockOn_mc:LockOnIndicator;
      
      private var ThrusterIcon_mc:MovieClip;
      
      private var SpeedName_mc:SpeedLabel;
      
      private var ButtonBar_mc:ButtonBar;
      
      private var RollIndicator_mc:MovieClip;
      
      private var LeadCircle_mc:MovieClip;
      
      private var ContrabandWarning_mc:ContrabandDisplay;
      
      private var MaxTurnRate_mc:TurnRateSweetSpotIndicator;
      
      private var TargetPanel_mc:TargetPanel;
      
      private var TargetLockCircle_mc:MovieClip;
      
      private var APBarAlpha_mc:MovieClip;
      
      private var APBarFill_mc:MovieClip;
      
      private var AlertEng_mc:MovieClip;
      
      private var AlertGrav_mc:MovieClip;
      
      private var AlertShield_mc:MovieClip;
      
      private var AlertHull_mc:MovieClip;
      
      private var BoostButton_mc:ButtonBase;
      
      public function ShipReticle()
      {
         var i:*;
         var weapIndex:int;
         var j:uint = 0;
         this.ReticleTransformInputDir = new Vector3D();
         this.OriginalReticleLocation = new Vector3D();
         this.GlobalHeadingPosition = new Point();
         this.AimAssistPosition = new Point();
         this.ShipHudMode = ShipInfoUtils.SH_MODE_FIRST_PERSON;
         this.MapButtonHintData = new ButtonBaseData("$OPEN_PLANET_MAP",new UserEventData("XButton",this.onMapPressed));
         this.LandingMarkerMapButtonHintData = new ButtonBaseData("$OPEN_PLANET_MAP",new UserEventData("XButton",this.onLandingMarkerMapPressed));
         this.LandButtonHintData = new ButtonBaseData("$LAND",new UserEventData("XButton",this.onLandPressed));
         this.SelectTargetButtonData = new ButtonBaseData("$SELECT TARGET",new UserEventData("SelectTarget",this.onTargetPressed));
         this.Weapon0ButtonData = new ButtonBaseData("",new UserEventData("WeaponGroup1",null));
         this.Weapon1ButtonData = new ButtonBaseData("",new UserEventData("WeaponGroup2",null));
         this.Weapon2ButtonData = new ButtonBaseData("",new UserEventData("WeaponGroup3",null));
         this.WeaponButtonData = new Array(this.Weapon0ButtonData,this.Weapon1ButtonData,this.Weapon2ButtonData);
         this.BoostButtonData = new ButtonBaseData("$BOOST",new UserEventData("Boosters",null));
         this._monocleButton = new ButtonBaseData("$Exit Monocle",new UserEventData("SHMonocle",this.onMonoclePressed));
         this.OffScreenIndicators = new Object();
         this.OnScreenIndicators = new Array();
         this.OffScreenIndicatorArray = new Array();
         this.OnScreenIndicatorArrays = new Array();
         this.TargetComponentIndicators = new Array();
         this.LowFreqChanges = new Array();
         this.CombatValuesChanges = new Array();
         this.OverlapPartitions = new Array();
         this.StateMachine = new BaseStateMachine();
         super();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(FarTravelIconBase.FAR_TRAVEL_INITIATE_JUMP,function():*
         {
            SetState(STATE_FAR_TRAVEL);
            FarTravelID = TargetOnlyData.uniqueID;
         },true);
         this.HeadingReticle_mc = this.ShipReticle_mc.HeadingIndicator_mc.Reticle_mc;
         this.ThrottleComponent_mc = this.ShipReticle_mc.ThrottleComponent_mc;
         this.BoostComponent_mc = this.ShipReticle_mc.BoostComponent_mc;
         this.LockOn_mc = this.ShipReticle_mc.LockOn_mc;
         this.ThrusterIcon_mc = this.ShipReticle_mc.ThrusterIcon_mc;
         this.SpeedName_mc = this.ShipReticle_mc.SpeedName_mc;
         this.ButtonBar_mc = this.ShipReticle_mc.ButtonBar_mc;
         this.RollIndicator_mc = this.ShipReticle_mc.RollIndicator_mc;
         this.LeadCircle_mc = this.ShipReticle_mc.LeadCircle_mc.Internal_mc;
         this.ContrabandWarning_mc = this.ShipReticle_mc.ContrabandWarning_mc;
         this.MaxTurnRate_mc = this.ShipReticle_mc.MaxTurnRate_mc;
         this.TargetPanel_mc = this.ShipReticle_mc.TargetPanel_mc;
         this.TargetLockCircle_mc = this.ShipReticle_mc.TargetLockCircle_mc;
         this.APBarAlpha_mc = this.ShipReticle_mc.APBar_mc;
         this.APBarFill_mc = this.ShipReticle_mc.APBar_mc.Internal_mc;
         this.AlertEng_mc = this.ShipReticle_mc.AlertEng_mc;
         this.AlertGrav_mc = this.ShipReticle_mc.AlertGrav_mc;
         this.AlertShield_mc = this.ShipReticle_mc.AlertShield_mc;
         this.AlertHull_mc = this.ShipReticle_mc.AlertHull_mc;
         this.BoostButton_mc = this.ShipReticle_mc.BoostName_mc.Button_mc;
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER);
         this.LandButton = ButtonFactory.AddToButtonBar("ReticleBaseButton",this.LandButtonHintData,this.ButtonBar_mc) as ReticleBaseButton;
         this.SelectTargetButton = ButtonFactory.AddToButtonBar("ReticleBaseButton",this.SelectTargetButtonData,this.ButtonBar_mc) as ReticleBaseButton;
         this.LastLandButtonData = this.LandButtonHintData;
         this.ButtonBar_mc.RefreshButtons();
         this.ConfigureStates();
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_ACTIVATOR] = ActivatorIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_STAR] = CelestialIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_HAILING] = HailingIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_LOOT] = LootIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_POI] = POIIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_SHIP] = ShipTargetIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_STATION] = StationIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_PLANET] = PlanetIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_DESTRUCTIBLE] = DestructibleObjectIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_QUEST] = QuestIcon;
         INDICATOR_CLIPS[TargetIconFrameContainer.TT_LANDING_MARKER] = LandingMarkerIndicator;
         GlobalFunc.SetText(this.AlertEng_mc.SystemName_mc.Text_tf,"$ENGINES");
         GlobalFunc.SetText(this.AlertShield_mc.SystemName_mc.Text_tf,"$SHIELDS");
         GlobalFunc.SetText(this.AlertGrav_mc.SystemName_mc.Text_tf,"$GRAV");
         GlobalFunc.SetText(this.AlertHull_mc.SystemName_mc.Text_tf,"$HULL");
         TargetIconBase.ButtonBar_mc = this.IndicatorButtonBar_mc;
         this.IndicatorButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.InitPreallocatedIndicators();
         this.OverlapPartitions = new Array(OVERLAP_HORIZONTAL_PARTITIONS);
         i = 0;
         while(i < OVERLAP_HORIZONTAL_PARTITIONS)
         {
            this.OverlapPartitions[i] = new Array();
            j = 0;
            while(j < OVERLAP_VERTICAL_PARTITIONS)
            {
               this.OverlapPartitions[i][j] = new Array();
               j++;
            }
            i++;
         }
         this.ShipReticle_mc.WeaponRight1Name_mc.Button_mc.justification = IButtonUtils.ICON_FIRST;
         this.ShipReticle_mc.WeaponTop1Name_mc.Button_mc.justification = IButtonUtils.ICON_FIRST;
         this.BoostButton_mc.justification = IButtonUtils.ICON_FIRST;
         this.BoostButton_mc.SetButtonData(this.BoostButtonData);
         this.BoostComponent_mc.SetBoostButton(this.BoostButton_mc);
         weapIndex = 0;
         while(weapIndex < GROUP_ENUM_TO_NAME.length)
         {
            this.ShipReticle_mc["Weapon" + GROUP_ENUM_TO_NAME[weapIndex] + "1Name_mc"].Button_mc.StoreButtonData(this.WeaponButtonData[weapIndex]);
            weapIndex++;
         }
      }
      
      public function get MonocleButton() : ButtonBaseData
      {
         return this._monocleButton;
      }
      
      public function get MonocleModeActive() : Boolean
      {
         return this.MonocleMode;
      }
      
      public function get FarTraveling() : Boolean
      {
         return this.QueuedState == STATE_FAR_TRAVEL || this.StateMachine.getCurrentStateId() == STATE_FAR_TRAVEL;
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         var _loc3_:ButtonBase = null;
         super.OnControlMapChanged(param1);
         var _loc2_:* = param1.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
         if(_loc2_)
         {
            this.BoostButton_mc.x = this.BoostButton_mc.PCButton_mc.width + BOOST_OFFSET;
         }
         else
         {
            this.BoostButton_mc.x = this.BoostButton_mc.ConsoleButton_mc.width + BOOST_OFFSET;
         }
         this.AlignWeaponButton(this.ShipReticle_mc.WeaponRight1Name_mc,_loc2_);
         this.AlignWeaponButton(this.ShipReticle_mc.WeaponLeft1Name_mc,_loc2_);
         this.AlignWeaponButton(this.ShipReticle_mc.WeaponTop1Name_mc,_loc2_);
         _loc3_ = this.ShipReticle_mc.WeaponTop1Name_mc.Button_mc;
         var _loc4_:Rectangle = _loc3_.getBounds(this);
         _loc3_.x -= (_loc4_.left + _loc4_.right) / 2;
         this.SpeedName_mc.OnControlMapChanged(param1);
      }
      
      private function AlignWeaponButton(param1:MovieClip, param2:Boolean) : *
      {
         var _loc3_:ButtonBase = param1.Button_mc;
         var _loc4_:MovieClip;
         var _loc5_:Rectangle = (_loc4_ = param2 ? _loc3_.PCButton_mc : _loc3_.ConsoleButton_mc).getBounds(this);
         param1.Background_mc.width = _loc4_.width;
         var _loc6_:Number = Number(param1.Background_mc.width);
         if(_loc3_.justification == IButtonUtils.ICON_FIRST)
         {
            _loc3_.x = _loc6_;
         }
         else
         {
            _loc3_.x = -_loc6_;
         }
         param1.Background_mc.x = _loc5_.x;
      }
      
      private function InitPreallocatedIndicators() : *
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:Class = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         HIDE_CLASSES.push(OffScreenIcon);
         for each(_loc1_ in INDICATOR_CLIPS)
         {
            HIDE_CLASSES.push(_loc1_);
            this.OnScreenIndicators.push(new Object());
            this.OnScreenIndicatorArrays.push(new Array());
         }
         _loc2_ = numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is TargetIconBase)
            {
               _loc4_ = Object(_loc3_).constructor;
               if((_loc5_ = INDICATOR_CLIPS.indexOf(_loc4_)) >= 0)
               {
                  (_loc3_ as TargetIconBase).InitButtonData();
                  _loc3_.parent.removeChild(_loc3_);
                  (_loc6_ = this.OnScreenIndicators[_loc5_])[_loc4_.toString() + _loc2_] = _loc3_;
               }
               else
               {
                  GlobalFunc.TraceWarning("Failed to find index of: " + _loc4_.toString());
               }
            }
            _loc2_--;
         }
      }
      
      private function ConfigureStates() : *
      {
         this.StateMachine.addState(STATE_MAIN,["*"]);
         this.StateMachine.addState(STATE_CLOSED_LANDED,[],{"exit":this.PlayLongIntro});
         this.StateMachine.addState(STATE_CLOSED_RESEATED,[],{"exit":this.PlayShortIntro});
         this.StateMachine.addState(STATE_CLOSED_TRAVEL,[{"state":STATE_MAIN}],{
            "enter":this.PlayClose,
            "exit":this.PlayInstantIntro
         });
         this.StateMachine.addState(STATE_MONOCLE,[{"state":STATE_MAIN}],{
            "enter":this.PlayMonocleOpen,
            "exit":this.PlayMonocleClose
         });
         this.StateMachine.addState(STATE_FAR_TRAVEL,[{"state":STATE_MAIN}],{
            "enter":this.PlayFarTravelOpen,
            "exit":this.PlayFarTravelClose
         });
         this.StateMachine.addState(STATE_TARGETING,[{"state":STATE_MAIN}],{
            "enter":this.PlayTargetingOpen,
            "exit":this.PlayTargetingClose
         });
      }
      
      override public function onAddedToStage() : void
      {
         var bodyViewData:Object;
         var bodyViewBounds:Rectangle = null;
         super.onAddedToStage();
         this.OriginalReticleLocation.x = this.ShipReticle_mc.x;
         this.OriginalReticleLocation.y = this.ShipReticle_mc.y;
         this.GravJumpInitiated = false;
         bodyViewBounds = this.BodyViewMarker_mc.BGHover_mc.getBounds(stage);
         bodyViewData = {
            "fWidth":bodyViewBounds.width / root.stage.stageWidth,
            "fHeight":bodyViewBounds.height / root.stage.stageHeight,
            "fSpacingWidth":BODY_VIEW_VERTICAL_SPACING / root.stage.stageHeight,
            "fSpacingHeight":BODY_VIEW_VERTICAL_SPACING / root.stage.stageWidth
         };
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_BodyViewMarkerDimensions,bodyViewData));
         BSUIDataManager.Subscribe("FireForgetEventData",function(param1:FromClientDataEvent):*
         {
            if(GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnHailAccepted") || GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnHailShip"))
            {
               if(StateMachine.getCurrentStateId() == STATE_MONOCLE)
               {
                  SetState(STATE_MAIN);
               }
            }
            if(GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnGravJumpInitiated"))
            {
               GravJumpInitiated = true;
               if(StateMachine.getCurrentStateId() == STATE_MONOCLE)
               {
                  SetState(STATE_MAIN);
               }
            }
            if(GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnGravJumpCompleted"))
            {
               GravJumpInitiated = false;
            }
         });
      }
      
      private function onEnterFrame() : *
      {
         if(this.Playing)
         {
            switch(this.ShipReticle_mc.currentFrameLabel)
            {
               case "LongOpenFinish":
                  this.Playing = false;
                  this.ShowIcons = true;
                  BSUIDataManager.dispatchEvent(new Event(ON_LONG_ANIM_FINISHED_EVENT,true,false));
                  break;
               case "ShortOpenFinish":
               case "InstantOpenFinish":
               case "FarTravelDownFinish":
               case "MonocleCloseFinish":
               case "TargetingOpenFinish":
               case "TargetingCloseFinish":
                  this.Playing = false;
                  this.ShowIcons = true;
                  break;
               case "MonocleOpenFinish":
                  this.Playing = false;
                  this.SetMonocleMode(true);
                  break;
               case "CloseFinish":
               case "FarTravelUpFinish":
                  if(this.InitiatingFarTravel)
                  {
                     this.InitiatingFarTravel = false;
                     BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_FarTravel,{"uValue":this.FarTravelID}));
                  }
                  this.Playing = false;
            }
         }
         if(!this.Playing && this.QueuedState != uint.MAX_VALUE)
         {
            this.SetState(this.QueuedState);
         }
         this.RefreshTargets();
      }
      
      public function SetMonocleMode(param1:Boolean) : *
      {
         if(this.MonocleMode != param1 && !(this.GravJumpInitiated && !this.MonocleMode))
         {
            this.MonocleMode = param1;
            this.MonocleDirty = true;
            this.ScanClip.SetCanOpen(this.MonocleMode);
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_OnMonocleToggle,{"bValue":this.MonocleMode}));
         }
      }
      
      public function Update(param1:Object, param2:Vector3D) : *
      {
         this.ReticleTransformInputDir = param2;
         this.ShipHudMode = param1.uSavedShipHudMode;
         this.LatestPayloadData = param1;
         if(Boolean(this.LatestPayloadData.bReadyForBootSequence) && !this.Initialized)
         {
            this.Initialized = true;
            if(this.LatestPayloadData.showLongIntro)
            {
               this.StateMachine.startingState(STATE_CLOSED_LANDED);
            }
            else
            {
               this.StateMachine.startingState(STATE_CLOSED_RESEATED);
            }
            this.StateMachine.changeState(STATE_MAIN);
         }
         if(this.LatestPayloadData.weaponGroupTargetHitID != uint.MAX_VALUE)
         {
            this.LeadCircle_mc.HitIndicator_mc.gotoAndPlay(!!this.LatestPayloadData.bDealtShieldDamage ? "ShieldStart" : "HullStart");
         }
         this.ContrabandWarning_mc.UpdateDisplay(this.LatestPayloadData);
         this.BoostComponent_mc.ShipHudDataUpdate(this.LatestPayloadData);
         this.LockOn_mc.UpdateShipHudData(this.LatestPayloadData);
         this.HullAlertThreshold = this.LatestPayloadData.fHullAlertThreshold;
         WeaponButton.SystemAlertThreshold = 1 - this.LatestPayloadData.fSystemAlertThreshold;
         var _loc3_:* = this.LatestPayloadData.shipHealth < this.LatestPayloadData.fHullAlertThreshold;
         if(this.LastHullDamaged != _loc3_)
         {
            this.AlertHull_mc.gotoAndPlay(_loc3_ ? ALERT_OPEN : ALERT_CLOSE);
            this.LastHullDamaged = _loc3_;
         }
         if(this.LastFarTravling != this.LatestPayloadData.bIsFarTraveling)
         {
            if(!this.LatestPayloadData.bIsFarTraveling)
            {
               this.SetState(ShipReticle.STATE_MAIN);
            }
            this.LastFarTravling = this.LatestPayloadData.bIsFarTraveling;
         }
         this.UpdateReticleButton();
      }
      
      private function MergeArrayWithChanges(param1:Object, param2:Array, param3:Boolean) : *
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc4_:Array = param1.arrayActionsA;
         var _loc5_:Array = param1.updatedindicesA;
         if(param3)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc9_ = _loc4_[_loc7_];
               _loc10_ = 0;
               switch(_loc9_.uType)
               {
                  case DataProviderUtils.ACA_CLEAR:
                     param3 = false;
                     _loc7_ = _loc4_.length;
                     break;
                  case DataProviderUtils.ACA_INSERT:
                     _loc6_ = 0;
                     while(_loc6_ < param2.length)
                     {
                        if(param2[_loc6_] >= _loc9_.uFirstValue)
                        {
                           ++param2[_loc6_];
                        }
                        _loc6_++;
                     }
                     break;
                  case DataProviderUtils.ACA_REMOVE:
                     _loc6_ = 0;
                     while(_loc6_ < param2.length)
                     {
                        if(param2[_loc6_] > _loc9_.uFirstValue)
                        {
                           --param2[_loc6_];
                        }
                        else if(param2[_loc6_] == _loc9_.uFirstValue)
                        {
                           param2.splice(_loc6_,1);
                           _loc6_--;
                        }
                        _loc6_++;
                     }
                     break;
                  case DataProviderUtils.ACA_RESIZE:
                     break;
               }
               _loc7_++;
            }
            _loc8_ = param2.length;
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc11_ = false;
               _loc6_ = 0;
               while(_loc6_ < _loc8_ && !_loc11_)
               {
                  if(param2[_loc6_] == _loc5_[_loc7_])
                  {
                     _loc11_ = true;
                  }
                  _loc6_++;
               }
               if(!_loc11_)
               {
                  param2.push(_loc5_[_loc7_]);
               }
               _loc7_++;
            }
         }
         if(!param3)
         {
            param2.splice(0);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               param2.push(_loc5_[_loc6_]);
               _loc6_++;
            }
         }
      }
      
      public function UpdateLowFrequencyData(param1:Object) : *
      {
         this.LowFreqTargetData = param1;
         this.MergeArrayWithChanges(this.LowFreqTargetData.targetArray,this.LowFreqChanges,this.LowFreqDirty);
         this.LockOn_mc.UpdateLowFrequency(this.LowFreqTargetData);
         this.UpdateReticleButton();
         this.LowFreqDirty = true;
      }
      
      public function UpdateCombatValuesData(param1:Object) : *
      {
         this.CombatValuesData = param1;
         this.MergeArrayWithChanges(this.CombatValuesData.targetArray,this.CombatValuesChanges,this.CombatValuesDirty);
         this.CombatValuesDirty = true;
      }
      
      private function UpdateReticleButton() : *
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:ButtonBaseData = null;
         var _loc5_:* = false;
         if(this.LatestPayloadData != null && this.LowFreqTargetData != null)
         {
            _loc1_ = this.LowFreqTargetData.iHoverTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iHoverTargetIndex] : null;
            _loc2_ = this.LowFreqTargetData.iInfoTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iInfoTargetIndex] : null;
            _loc3_ = _loc1_ != null && _loc1_.uTargetType == TargetIconFrameContainer.TT_LANDING_MARKER;
            if(this.HoveringOnLandingMarker != _loc3_)
            {
               this.TargetOnlyDirty = true;
               this.HoveringOnLandingMarker = _loc3_;
            }
            if(this.HoveringOnLandingMarker)
            {
               _loc4_ = !!_loc1_.bIsGroupMarker ? this.LandingMarkerMapButtonHintData : this.LandButtonHintData;
               if(this.LastLandButtonData != _loc4_)
               {
                  this.LandButton.SetButtonData(_loc4_);
                  this.LastLandButtonData = _loc4_;
               }
               this.LandButton.Visible = _loc1_.bLandingAllowed;
               this.LandButton.Enabled = !_loc1_.bLandingDisabled && this.LandButton.Visible;
            }
            else if(_loc2_ != null)
            {
               if(this.LastLandButtonData != this.MapButtonHintData)
               {
                  this.LandButton.SetButtonData(this.MapButtonHintData);
                  this.LastLandButtonData = this.MapButtonHintData;
               }
               _loc5_ = _loc2_.uTargetType == TargetIconFrameContainer.TT_PLANET;
               this.LandButton.Visible = _loc5_ && Boolean(_loc2_.bLandingAllowed);
               this.LandButton.Enabled = _loc5_ && !_loc2_.bLandingDisabled && this.LandButton.Visible;
            }
            else
            {
               this.LandButton.Visible = false;
               this.LandButton.Enabled = false;
            }
            this.SelectTargetButton.Visible = !this.LandButton.Visible && this.SelectTargetButton.Enabled && _loc2_ == null && Boolean(this.LatestPayloadData.isInCombat);
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      public function UpdateHighFrequencyData(param1:Object) : *
      {
         this.HighFreqTargetData = param1;
         this.HighFreqDirty = true;
      }
      
      public function UpdateTargetOnlyData(param1:Object) : *
      {
         this.TargetOnlyData = param1;
         this.LockOn_mc.UpdateTargetOnly(this.TargetOnlyData);
         if(this.TargetOnlyData.bTargetModeActive != (this.StateMachine.getCurrentStateId() == STATE_TARGETING))
         {
            this.SetState(!!this.TargetOnlyData.bTargetModeActive ? STATE_TARGETING : STATE_MAIN);
            if(!this.TargetOnlyData.bTargetModeActive)
            {
               this.TargetMonocleMode = false;
               this.ScanClip.SetCanOpen(false);
            }
         }
         this.TargetPanel_mc.UpdateTargetOnlyData(this.TargetOnlyData);
         this.TargetOnlyDirty = true;
      }
      
      private function UpdateAPBar() : *
      {
         var _loc1_:int = Math.round(GlobalFunc.MapLinearlyToRange(1,this.APBarFill_mc.framesLoaded,0,1,this.LatestPayloadData.fAPBarPercent,true)) as int;
         if(this.LastAPBarFrame != _loc1_ || this.LastTargetModeAllowed != this.LatestPayloadData.bTargetModeAllowed || this.LastTargetModeActive != this.TargetOnlyData.bTargetModeActive)
         {
            this.APBarFill_mc.gotoAndStop(_loc1_);
            if(this.LowFreqTargetData.iInfoTargetIndex == -1 || !this.LatestPayloadData.bTargetModeAllowed || this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iInfoTargetIndex].uTargetType != TargetIconFrameContainer.TT_SHIP)
            {
               this.APBarAlpha_mc.gotoAndStop("Hidden");
            }
            else if(_loc1_ == this.APBarFill_mc.framesLoaded && !this.TargetOnlyData.bTargetModeActive)
            {
               this.APBarAlpha_mc.gotoAndPlay("FadeOut");
            }
            else if(_loc1_ == 1 && this.LastAPBarFrame != 0)
            {
               this.APBarAlpha_mc.gotoAndPlay("Filling");
            }
            else if(this.LastAPBarFrame == this.APBarFill_mc.framesLoaded || this.LastAPBarFrame == 1 || Boolean(this.TargetOnlyData.bTargetModeActive))
            {
               this.APBarAlpha_mc.gotoAndStop("Filling");
            }
            this.LastAPBarFrame = _loc1_;
            this.LastTargetModeActive = this.TargetOnlyData.bTargetModeActive;
            this.LastTargetModeAllowed = this.LatestPayloadData.bTargetModeAllowed;
         }
      }
      
      public function OnPlayerShipComponentsUpdate(param1:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         this.ShipComponentData = param1;
         var _loc2_:Array = [0,0,0];
         if(param1.hasOwnProperty("componentArray") && param1.componentArray is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.componentArray.length)
            {
               _loc5_ = param1.componentArray[_loc4_];
               switch(_loc5_.type)
               {
                  case ShipInfoUtils.MT_WEAPON:
                     if(_loc5_.weaponGroup >= 0 && _loc5_.weaponGroup < NUM_WEAPON_GROUPS)
                     {
                        _loc6_ = uint(_loc5_.weaponGroup);
                        if(_loc2_[_loc6_] < NUM_WEAPONS_PER_GROUP)
                        {
                           this.UpdateWeaponGroup(_loc5_,_loc6_,_loc2_[_loc6_],true);
                           ++_loc2_[_loc6_];
                        }
                        else
                        {
                           GlobalFunc.TraceWarning("Too many weapons in weapon group: " + _loc6_);
                        }
                     }
                     break;
                  default:
                     this.UpdateComponentAlert(_loc5_);
                     break;
               }
               _loc4_++;
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc7_ = int(_loc2_[_loc3_]);
            while(_loc7_ < NUM_WEAPONS_PER_GROUP)
            {
               this.UpdateWeaponGroup(null,_loc3_,_loc7_,false);
               _loc7_++;
            }
            _loc3_++;
         }
      }
      
      public function SetState(param1:uint) : *
      {
         this.QueuedState = uint.MAX_VALUE;
         if(this.StateMachine.getCurrentStateId() != param1)
         {
            if(!this.Playing)
            {
               if(this.StateMachine.getCurrentStateId() != STATE_MAIN && param1 != STATE_MAIN)
               {
                  this.StateMachine.changeState(STATE_MAIN);
                  this.QueuedState = param1;
               }
               else
               {
                  this.StateMachine.changeState(param1);
               }
            }
            else
            {
               this.QueuedState = param1;
            }
         }
      }
      
      private function PlayFarTravelOpen() : *
      {
         dispatchEvent(new Event(Reticle_FarTravelInitiate));
         switch(this.ShipHudMode)
         {
            case ShipInfoUtils.SH_MODE_FIRST_PERSON:
               this.ShipReticle_mc.gotoAndPlay("FarTravelUp");
               this.InitiatingFarTravel = true;
               this.Playing = true;
               break;
            case ShipInfoUtils.SH_MODE_THIRD_PERSON:
               this.PlayClose();
               this.InitiatingFarTravel = true;
               break;
            default:
               GlobalFunc.TraceWarning("Failed to initiate far travel animation because of unknown hud mode: " + this.ShipHudMode);
         }
      }
      
      private function PlayFarTravelClose() : *
      {
         dispatchEvent(new Event(Reticle_FarTravelComplete));
         switch(this.ShipHudMode)
         {
            case ShipInfoUtils.SH_MODE_FIRST_PERSON:
               this.ShipReticle_mc.gotoAndPlay("FarTravelDown");
               this.Playing = true;
               break;
            case ShipInfoUtils.SH_MODE_THIRD_PERSON:
               this.ShipReticle_mc.gotoAndPlay("InstantOpen");
               this.Playing = true;
               break;
            default:
               GlobalFunc.TraceWarning("Unknown hud mode when exiting far travel: " + this.ShipHudMode);
         }
      }
      
      private function PlayLongIntro() : *
      {
         this.Playing = true;
         this.ShipReticle_mc.gotoAndPlay("LongOpen");
         GlobalFunc.PlayMenuSound("UICockpitHUDABootSequenceALong");
      }
      
      private function PlayShortIntro() : *
      {
         this.Playing = true;
         this.ShipReticle_mc.gotoAndPlay("ShortOpen");
         GlobalFunc.PlayMenuSound("UICockpitHUDABootSequenceBShort");
      }
      
      private function PlayInstantIntro() : *
      {
         this.Playing = true;
         this.ShipReticle_mc.gotoAndPlay("InstantOpen");
         GlobalFunc.PlayMenuSound("UICockpitHUDABootSequenceCInstant");
      }
      
      private function PlayClose() : *
      {
         this.Playing = true;
         this.ShowIcons = false;
         this.ShipReticle_mc.gotoAndPlay("Close");
      }
      
      private function PlayMonocleOpen() : *
      {
         this.Playing = true;
         this.ShipReticle_mc.gotoAndPlay("MonocleOpen");
         GlobalFunc.PlayMenuSound("UICockpitHUDMonocleOpen");
      }
      
      private function PlayMonocleClose() : *
      {
         this.Playing = true;
         this.SetMonocleMode(false);
         this.ShipReticle_mc.gotoAndPlay("MonocleClose");
         GlobalFunc.PlayMenuSound("UICockpitHUDMonocleClose");
      }
      
      private function PlayTargetingOpen() : *
      {
         this.Playing = true;
         this.ShipReticle_mc.gotoAndPlay("TargetingOpen");
      }
      
      private function PlayTargetingClose() : *
      {
         this.Playing = true;
         this.SetMonocleMode(false);
         this.ShipReticle_mc.gotoAndPlay("TargetingClose");
      }
      
      public function OnStickDataUpdate(param1:Object) : *
      {
         var _loc2_:Number = Number(param1.shipDirectionCrosshairX);
         var _loc3_:Number = Number(param1.shipDirectionCrosshairY);
         this.GlobalHeadingPosition.x = GlobalFunc.MapLinearlyToRange(Extensions.visibleRect.x,Extensions.visibleRect.x + Extensions.visibleRect.width,-1,1,_loc2_,true);
         this.GlobalHeadingPosition.y = GlobalFunc.MapLinearlyToRange(Extensions.visibleRect.y,Extensions.visibleRect.y + Extensions.visibleRect.height,-1,1,_loc3_,true);
         this.AimAssistPosition.x = GlobalFunc.MapLinearlyToRange(Extensions.visibleRect.x,Extensions.visibleRect.x + Extensions.visibleRect.width,0,1,param1.AimAssistCrosshairX,true);
         this.AimAssistPosition.y = GlobalFunc.MapLinearlyToRange(Extensions.visibleRect.y,Extensions.visibleRect.y + Extensions.visibleRect.height,0,1,param1.AimAssistCrosshairY,true);
         if(this.LastFriendly != param1.bTargetFriendly)
         {
            if(param1.bTargetFriendly)
            {
               this.LeadCircle_mc.gotoAndStop("Friendly");
            }
            else
            {
               this.LeadCircle_mc.gotoAndStop(!!param1.bShowAimAssist ? "Locked" : "Unlocked");
            }
         }
         else if(!this.ShowAimAssist && param1.bShowAimAssist != param1.bShowAimAssist)
         {
            this.LeadCircle_mc.gotoAndStop(!!param1.bShowAimAssist ? "Locked" : "Unlocked");
         }
         this.LastFriendly = param1.bTargetFriendly;
         this.ShowAimAssist = param1.bShowAimAssist;
         this.TargetReticleRotation = param1.fAdjustedRoll * ROLL_INDICATOR_MAX_ANGLE;
         this.ThrottleComponent_mc.OnStickDataUpdate(param1);
         this.BoostComponent_mc.OnStickDataUpdate(param1);
         this.ThrusterIcon_mc.OnStickDataUpdate(param1);
         this.SpeedName_mc.OnStickDataUpdate(param1);
         this.MaxTurnRate_mc.OnStickDataUpdate(param1);
      }
      
      public function UpdateWeaponGroup(param1:Object, param2:int, param3:int, param4:Boolean) : *
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         _loc6_ = (_loc5_ = String(GROUP_ENUM_TO_NAME[param2])) + (param3 + 1);
         var _loc7_:MovieClip;
         if(_loc7_ = this.ShipReticle_mc["Ammo" + _loc6_ + "_mc"])
         {
            _loc7_.visible = param4;
         }
         var _loc8_:MovieClip;
         if(_loc8_ = this.ShipReticle_mc["Ammo" + _loc6_ + "Outline_mc"])
         {
            _loc8_.visible = param4;
         }
         var _loc9_:MovieClip;
         (_loc9_ = this.ShipReticle_mc["Weapon" + _loc6_ + "Name_mc"]).visible = param4;
         if(param4)
         {
            _loc10_ = param1.componentPower + param1.uBonusPower;
            if(_loc7_)
            {
               _loc11_ = int(_loc7_.Fill_mc.currentFrame);
               _loc12_ = _loc10_ == 0 ? 0 : Number(param1.componentRechargePercent);
               _loc13_ = Math.round(GlobalFunc.MapLinearlyToRange(WEAPON_EMPTY_FRAME,WEAPON_FULL_FRAME,0,1,_loc12_,true)) as int;
               if(_loc11_ != _loc13_)
               {
                  _loc7_.Fill_mc.gotoAndStop(_loc13_);
                  if(_loc13_ == WEAPON_FULL_FRAME)
                  {
                     GlobalFunc.PlayMenuSound("UICockpitHUDWeaponChargeReady");
                  }
                  else if(_loc13_ == WEAPON_EMPTY_FRAME)
                  {
                     GlobalFunc.PlayMenuSound("UICockpitHUDWeaponChargeDepleted");
                  }
               }
            }
            _loc9_.Button_mc.UpdateWeaponComponent(param1);
         }
      }
      
      public function UpdateComponentAlert(param1:Object) : *
      {
         var _loc2_:Number = NaN;
         _loc2_ = 1 - (param1.damagePhys + param1.damageEM) / param1.componentMaxPower;
         var _loc3_:* = _loc2_ <= this.SystemAlertThreshold;
         switch(param1.type)
         {
            case ShipInfoUtils.MT_ENGINE:
               if(this.LastEngineDamaged != _loc3_)
               {
                  this.AlertEng_mc.gotoAndPlay(_loc3_ ? ALERT_OPEN : ALERT_CLOSE);
                  this.LastEngineDamaged = _loc3_;
                  if(_loc3_)
                  {
                     GlobalFunc.PlayMenuSound(COMPONENT_OFFLINE_SOUND);
                  }
               }
               break;
            case ShipInfoUtils.MT_SHIELD:
               if(this.LastShieldDamaged != _loc3_)
               {
                  this.AlertShield_mc.gotoAndPlay(_loc3_ ? ALERT_OPEN : ALERT_CLOSE);
                  this.LastShieldDamaged = _loc3_;
                  if(_loc3_)
                  {
                     GlobalFunc.PlayMenuSound(COMPONENT_OFFLINE_SOUND);
                  }
               }
               break;
            case ShipInfoUtils.MT_GRAV:
               if(this.LastGravDamaged != _loc3_)
               {
                  this.AlertGrav_mc.gotoAndPlay(_loc3_ ? ALERT_OPEN : ALERT_CLOSE);
                  this.LastGravDamaged = _loc3_;
                  if(_loc3_)
                  {
                     GlobalFunc.PlayMenuSound(COMPONENT_OFFLINE_SOUND);
                  }
               }
               break;
            case ShipInfoUtils.MT_COUNT:
               break;
            default:
               GlobalFunc.TraceWarning("Unhandled component type: " + param1.type);
         }
      }
      
      private function UpdateMovement() : *
      {
         var _loc1_:Vector3D = null;
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc5_:Number = NaN;
         _loc1_ = new Vector3D(this.ShipReticle_mc.x,this.ShipReticle_mc.y);
         _loc2_ = this.ReticleTransformInputDir.clone();
         _loc2_.y = -_loc2_.y;
         _loc2_.scaleBy(X_Y_MAGNITUDE);
         _loc3_ = this.OriginalReticleLocation.add(_loc2_);
         var _loc4_:Vector3D = GlobalFunc.VectorLerp(_loc1_,_loc3_,RETICLE_MOVEMENT_LERP_SPEED);
         this.ShipReticle_mc.x = _loc4_.x;
         this.ShipReticle_mc.y = _loc4_.y;
         _loc5_ = 1 + Z_MAGNITUDE * this.ReticleTransformInputDir.z;
         var _loc6_:Number = GlobalFunc.Lerp(this.ShipReticle_mc.scaleX,_loc5_,RETICLE_SCALE_LERP_SPEED);
         this.ShipReticle_mc.scaleX = _loc6_;
         this.ShipReticle_mc.scaleY = _loc6_;
         var _loc7_:Number = ROTATION_MAGNITUDE * this.ReticleTransformInputDir.x;
         this.ShipReticle_mc.rotationZ = GlobalFunc.Lerp(this.ShipReticle_mc.rotationZ,_loc7_,RETICLE_ROT_LERP_SPEED);
         var _loc8_:Point = this.HeadingReticle_mc.parent.globalToLocal(this.GlobalHeadingPosition);
         var _loc9_:Point = this.HeadingReticle_mc.parent.globalToLocal(this.AimAssistPosition);
         var _loc10_:Number = 1 / stage.frameRate;
         if(this.ShowAimAssist && this.AimAssistTimeTracker < AIM_ASSIST_INTERPOLATION_TIME_S)
         {
            this.AimAssistTimeTracker += _loc10_;
         }
         else if(!this.ShowAimAssist && this.AimAssistTimeTracker > 0)
         {
            if(this.CurrentInfoTargetID != this.TargetOnlyData.UniqueID)
            {
               this.AimAssistTimeTracker = 0;
               this.CurrentInfoTargetID = this.TargetOnlyData.UniqueID;
            }
            else
            {
               this.AimAssistTimeTracker -= _loc10_;
            }
         }
         this.AimAssistTimeTracker = GlobalFunc.Clamp(this.AimAssistTimeTracker,0,AIM_ASSIST_INTERPOLATION_TIME_S);
         var _loc11_:Number = this.AimAssistTimeTracker / AIM_ASSIST_INTERPOLATION_TIME_S;
         this.HeadingReticle_mc.x = _loc8_.x;
         this.HeadingReticle_mc.y = _loc8_.y;
         this.LeadCircle_mc.x = _loc8_.x * (1 - _loc11_) + _loc9_.x * _loc11_;
         this.LeadCircle_mc.y = _loc8_.y * (1 - _loc11_) + _loc9_.y * _loc11_;
         var _loc12_:Number = this.RollIndicator_mc.Rotation_mc.rotation * (1 - ROLL_INDICATOR_ROTATION_PERCENT_PER_FRAME) + this.TargetReticleRotation * ROLL_INDICATOR_ROTATION_PERCENT_PER_FRAME;
         this.RollIndicator_mc.Rotation_mc.rotation = GlobalFunc.Clamp(_loc12_,-ROLL_INDICATOR_MAX_ANGLE,ROLL_INDICATOR_MAX_ANGLE);
      }
      
      private function RefreshTargets() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Boolean = false;
         var _loc8_:Point = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Boolean = false;
         var _loc15_:IButton = null;
         this.UpdateMovement();
         if(this.ShowIcons && this.LatestPayloadData != null && this.HighFreqTargetData != null && this.LowFreqTargetData != null && this.TargetOnlyData != null && (this.HighFreqDirty || this.TargetOnlyDirty || this.LowFreqDirty || this.CombatValuesDirty || this.MonocleDirty))
         {
            this.UpdateAPBar();
            if(this.LowFreqTargetData.targetArray.dataA.length != this.HighFreqTargetData.targetArray.length)
            {
               GlobalFunc.TraceWarning("Target data array length mismatch");
            }
            _loc1_ = new Array();
            ++this.UpdateCounter;
            if(this.LowFreqDirty)
            {
               _loc2_ = 0;
               while(_loc2_ < this.LowFreqChanges.length)
               {
                  this.HighFreqTargetData.targetArray[this.LowFreqChanges[_loc2_]].LowDirty = true;
                  _loc2_++;
               }
            }
            if(this.CombatValuesDirty)
            {
               _loc2_ = 0;
               while(_loc2_ < this.CombatValuesChanges.length)
               {
                  this.HighFreqTargetData.targetArray[this.CombatValuesChanges[_loc2_]].CombatDirty = true;
                  _loc2_++;
               }
            }
            _loc2_ = 0;
            while(_loc2_ < this.HighFreqTargetData.targetArray.length)
            {
               _loc4_ = this.LowFreqTargetData.targetArray.dataA[_loc2_];
               _loc5_ = this.HighFreqTargetData.targetArray[_loc2_];
               _loc6_ = this.CombatValuesData.targetArray.dataA[_loc2_];
               _loc7_ = false;
               if(_loc6_.onScreen)
               {
                  _loc7_ = (_loc8_ = this.RefreshOnScreenIcon(_loc4_,_loc5_,_loc6_,_loc1_)) != null && _loc8_.x * _loc8_.x + _loc8_.y * _loc8_.y > RETICLE_RADIUS_SQR;
               }
               if(!_loc6_.onScreen || _loc7_)
               {
                  this.RefreshOffScreenIcon(_loc4_,_loc5_,_loc6_);
               }
               if(_loc4_.isInfoTarget)
               {
                  this.RefreshTargetedComponents(_loc5_);
               }
               _loc2_++;
            }
            if(this.LowFreqDirty)
            {
               _loc2_ = 0;
               while(_loc2_ < this.LowFreqChanges.length)
               {
                  this.HighFreqTargetData.targetArray[this.LowFreqChanges[_loc2_]].LowDirty = false;
                  _loc2_++;
               }
            }
            if(this.CombatValuesDirty)
            {
               _loc2_ = 0;
               while(_loc2_ < this.CombatValuesChanges.length)
               {
                  this.HighFreqTargetData.targetArray[this.CombatValuesChanges[_loc2_]].CombatDirty = false;
                  _loc2_++;
               }
            }
            this.UpdateAllIndicatorVisibility();
            this.HideOverlappingClips(_loc1_);
            if(this.LastInfoTargetIndex != this.LowFreqTargetData.iInfoTargetIndex)
            {
               if(this.LowFreqTargetData.iInfoTargetIndex == -1)
               {
                  this.RefreshTargetedComponents(null);
               }
               this.LastInfoTargetIndex = this.LowFreqTargetData.iInfoTargetIndex;
            }
            _loc3_ = this.LowFreqTargetData.iInfoTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iInfoTargetIndex] : null;
            if(_loc3_ != null)
            {
               _loc9_ = this.CombatValuesData.targetArray.dataA[this.LowFreqTargetData.iInfoTargetIndex];
               this.ScanClip.Update(_loc3_,_loc9_,this.TargetOnlyData,this.LatestPayloadData,this.ShipComponentData);
               if(this.TargetOnlyData.bTargetModeActive)
               {
                  _loc10_ = this.HighFreqTargetData.targetArray[this.LowFreqTargetData.iInfoTargetIndex];
                  _loc11_ = Math.round(GlobalFunc.MapLinearlyToRange(1,this.TargetLockCircle_mc.framesLoaded,0,1,_loc10_.fTargetMaxAnglePercent,true)) as int;
                  if(this.LastLockTargetLockStrengthFrame != _loc11_)
                  {
                     this.TargetLockCircle_mc.gotoAndStop(_loc11_);
                     this.LastLockTargetLockStrengthFrame = _loc11_;
                  }
               }
            }
            else
            {
               _loc12_ = this.LowFreqTargetData.iHoverTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iHoverTargetIndex] : null;
               _loc13_ = this.LowFreqTargetData.iHoverTargetIndex >= 0 ? this.CombatValuesData.targetArray.dataA[this.LowFreqTargetData.iHoverTargetIndex] : null;
               this.ScanClip.Update(_loc12_,_loc13_,this.TargetOnlyData,this.LatestPayloadData,this.ShipComponentData);
               _loc14_ = false;
               _loc2_ = 0;
               while(_loc2_ < this.IndicatorButtonBar_mc.MyButtonManager.NumButtons)
               {
                  _loc15_ = this.IndicatorButtonBar_mc.MyButtonManager.GetButtonByIndex(_loc2_) as IButton;
                  _loc14_ = _loc14_ || _loc15_.Visible || _loc15_.Enabled;
                  _loc15_.Visible = false;
                  _loc15_.Enabled = false;
                  if(_loc15_ is HoldButton)
                  {
                     (_loc15_ as HoldButton).CancelHold();
                  }
                  _loc2_++;
               }
               if(_loc14_)
               {
                  this.IndicatorButtonBar_mc.RefreshButtons();
               }
            }
            this.TargetOnlyDirty = false;
            this.LowFreqDirty = false;
            this.CombatValuesDirty = false;
            this.HighFreqDirty = false;
            this.MonocleDirty = false;
            this.CanClearIcons = true;
         }
         else if(this.CanClearIcons && (this.LatestPayloadData == null || !this.LatestPayloadData.bPaused))
         {
            ++this.UpdateCounter;
            this.UpdateAllIndicatorVisibility();
            this.CanClearIcons = false;
         }
      }
      
      private function RefreshTargetedComponents(param1:Object) : *
      {
         var _loc4_:TargetComponentIndicator = null;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            while(_loc2_ < param1.TargetComponentsA.length)
            {
               if(_loc2_ >= this.TargetComponentIndicators.length)
               {
                  this.TargetComponentIndicators.push(new TargetComponentIndicator());
                  addChild(this.TargetComponentIndicators[_loc2_]);
               }
               (_loc4_ = this.TargetComponentIndicators[_loc2_]).visible = true;
               _loc4_.Update(param1.TargetComponentsA[_loc2_]);
               _loc2_++;
            }
         }
         var _loc3_:int = _loc2_;
         while(_loc2_ < this.LastTargetIndicatorCount)
         {
            this.TargetComponentIndicators[_loc2_].visible = false;
            _loc2_++;
         }
         this.LastTargetIndicatorCount = _loc3_;
      }
      
      private function RefreshOnScreenIcon(param1:Object, param2:Object, param3:Object, param4:Array) : Point
      {
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:TargetIconBase = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Rectangle = null;
         var _loc14_:Boolean = false;
         var _loc15_:Point = null;
         var _loc5_:Point = null;
         if(param1.bAllowedOnScreen)
         {
            _loc6_ = uint(param1.uTargetType);
            _loc8_ = (_loc7_ = Boolean(param1.isInfoTarget)) && Boolean(this.TargetOnlyData.bTargetModeActive);
            (_loc9_ = this.GetClip(this.OnScreenIndicators[_loc6_],this.OnScreenIndicatorArrays[_loc6_],INDICATOR_CLIPS[_loc6_],param1.uniqueID,this) as TargetIconBase).SetUpdateFrame(this.UpdateCounter);
            _loc9_.TrySetAsStaticIndicator(_loc8_);
            _loc10_ = Boolean(param1.bWasInfoTarget) || this.HoveringOnLandingMarker && _loc7_;
            _loc11_ = !this.HoveringOnLandingMarker && _loc7_;
            _loc12_ = this.MonocleDirty || !_loc9_.Initialized || this.TargetOnlyDirty && (_loc11_ || _loc10_);
            _loc9_.SetLatestPayloadData(this.LatestPayloadData);
            if(_loc12_ || param2.LowDirty === true)
            {
               _loc9_.SetTargetLowInfo(param1,_loc11_ ? this.TargetOnlyData : null,this.MonocleMode);
            }
            if(_loc12_ || param2.CombatDirty === true)
            {
               _loc9_.SetCombatValues(param3);
            }
            _loc9_.SetTargetHighInfo(param2);
            _loc9_.SetBlockedClipAlpha(1,true);
            if(_loc9_.GetShowAsSelected())
            {
               param4.push(_loc9_);
            }
            if(!_loc8_)
            {
               _loc5_ = GlobalFunc.ConvertScreenPercentsToLocalPoint(param2.screenPositionX,param2.screenPositionY,this);
               _loc9_.x = _loc5_.x;
               _loc9_.y = _loc5_.y;
               _loc9_.UpdatePositionAdjustedBounds();
               if(_loc12_)
               {
                  _loc14_ = (_loc13_ = _loc9_.GetPositionAdjustedBounds()).x < this.SafeRectLeft || _loc13_.x + _loc13_.width > this.SafeRectRight || _loc13_.y < this.SafeRectTop || _loc13_.y + _loc13_.height > this.SafeRectBottom;
                  _loc9_.UpdateOnScreenStatus(!_loc14_);
                  if(_loc14_)
                  {
                     this.SnapIndicatorToEdge(param2,_loc9_);
                     _loc9_.UpdatePositionAdjustedBounds();
                  }
               }
            }
            else
            {
               _loc5_ = new Point();
               _loc9_.x = NAME_PLATE_X;
               _loc9_.y = NAME_PLATE_Y;
            }
            if(_loc7_)
            {
               _loc15_ = _loc9_.GetButtonBarPosition(this);
               this.IndicatorButtonBar_mc.x = _loc15_.x;
               this.IndicatorButtonBar_mc.y = _loc15_.y;
            }
         }
         return _loc5_;
      }
      
      private function RefreshOffScreenIcon(param1:Object, param2:Object, param3:Object) : *
      {
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:OffScreenIcon = null;
         var _loc7_:TargetIconBase = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Point = null;
         if(param1.bAllowedOffScreen)
         {
            _loc4_ = Boolean(param1.isInfoTarget);
            _loc5_ = uint(param1.uTargetType);
            (_loc6_ = this.GetClip(this.OffScreenIndicators,this.OffScreenIndicatorArray,OffScreenIcon,param1.uniqueID,this.ShipReticle_mc.OffScreenIndicatorParent_mc) as OffScreenIcon).SetUpdateFrame(this.UpdateCounter);
            _loc7_ = _loc4_ && !param3.onScreen ? this.GetClip(this.OnScreenIndicators[_loc5_],this.OnScreenIndicatorArrays[_loc5_],INDICATOR_CLIPS[_loc5_],param1.uniqueID,this) as TargetIconBase : null;
            _loc8_ = Boolean(param1.bWasInfoTarget) || this.HoveringOnLandingMarker && _loc4_;
            _loc9_ = !this.HoveringOnLandingMarker && _loc4_;
            if((_loc10_ = this.MonocleDirty || !_loc6_.Initialized || this.TargetOnlyDirty && (_loc9_ || _loc8_)) || param2.LowDirty === true)
            {
               _loc6_.SetTargetLowInfo(param1,_loc4_ ? this.TargetOnlyData : null,this.MonocleMode);
               if(_loc7_ != null)
               {
                  _loc7_.SetLatestPayloadData(this.LatestPayloadData);
                  _loc7_.SetTargetLowInfo(param1,_loc4_ ? this.TargetOnlyData : null,this.MonocleMode);
               }
            }
            if(_loc10_ || param2.CombatDirty === true)
            {
               _loc6_.SetCombatValues(param3);
               if(_loc7_ != null)
               {
                  _loc7_.SetCombatValues(param3);
               }
            }
            _loc6_.SetTargetHighInfo(param2);
            if(_loc7_ != null)
            {
               _loc7_.SetUpdateFrame(this.UpdateCounter);
               _loc7_.SetTargetHighInfo(param2);
               this.SnapIndicatorToEdge(param2,_loc7_);
               _loc7_.UpdateOnScreenStatus(false);
               _loc11_ = _loc7_.GetButtonBarPosition(this);
               this.IndicatorButtonBar_mc.x = _loc11_.x;
               this.IndicatorButtonBar_mc.y = _loc11_.y;
            }
         }
      }
      
      private function SnapIndicatorToEdge(param1:Object, param2:TargetIconBase) : *
      {
         var _loc4_:Number = NaN;
         var _loc3_:Rectangle = param2.GetLocalBounds();
         _loc4_ = param1.angleToCrosshair * Math.PI / 180;
         var _loc5_:Number = Math.sin(_loc4_);
         var _loc6_:Number = -Math.cos(_loc4_);
         var _loc7_:Number = Number.POSITIVE_INFINITY;
         var _loc8_:Number = Number.POSITIVE_INFINITY;
         if(_loc5_ != 0)
         {
            _loc7_ = _loc5_ < 0 ? (this.SafeRectLeft - _loc3_.x) / _loc5_ : (this.SafeRectRight - _loc3_.width - _loc3_.x) / _loc5_;
         }
         if(_loc6_ != 0)
         {
            _loc8_ = _loc6_ < 0 ? (this.SafeRectTop - _loc3_.y) / _loc6_ : (this.SafeRectBottom - _loc3_.height - _loc3_.y) / _loc6_;
         }
         if(_loc7_ < _loc8_)
         {
            param2.x = _loc7_ * _loc5_;
            param2.y = _loc7_ * _loc6_;
         }
         else
         {
            param2.x = _loc8_ * _loc5_;
            param2.y = _loc8_ * _loc6_;
         }
      }
      
      private function HideOverlappingClips(param1:Array) : *
      {
         var doublePart:int;
         var xInd:int;
         var i:int = 0;
         var j:int = 0;
         var bounds:Rectangle = null;
         var leftRight:Point = null;
         var topBottom:Point = null;
         var k:int = 0;
         var xArray:Array = null;
         var yInd:int = 0;
         var xyArray:Array = null;
         var clipI:TargetIconBase = null;
         var boundsI:Rectangle = null;
         var clipJ:TargetIconBase = null;
         var boundsJ:Rectangle = null;
         var intersection:Rectangle = null;
         var areaI:* = undefined;
         var areaJ:* = undefined;
         var smallBound:* = undefined;
         var intersectionArea:* = undefined;
         var overlapPercent:* = undefined;
         var aVisibleIcons:Array = param1;
         var getPartitionLowerAndUpper:Function = function(param1:Number, param2:Number, param3:Number, param4:uint):Point
         {
            var _loc5_:Point;
            (_loc5_ = new Point()).x = Math.floor(param1 / param3);
            if(_loc5_.x < 0)
            {
               _loc5_.x = 0;
            }
            _loc5_.y = Math.floor((param1 + param2) / param3);
            if(_loc5_.y >= param4)
            {
               _loc5_.y = param4 - 1;
            }
            if(_loc5_.y - _loc5_.x > 1)
            {
               GlobalFunc.TraceWarning("Partitions too small");
            }
            return _loc5_;
         };
         var horizontalIncrement:Number = (this.SafeRectRight - this.SafeRectLeft) / OVERLAP_HORIZONTAL_PARTITIONS;
         var verticalIncrement:Number = (this.SafeRectBottom - this.SafeRectTop) / OVERLAP_VERTICAL_PARTITIONS;
         i = 0;
         while(i < OVERLAP_HORIZONTAL_PARTITIONS)
         {
            j = 0;
            while(j < OVERLAP_VERTICAL_PARTITIONS)
            {
               this.OverlapPartitions[i][j] = new Array();
               j++;
            }
            i++;
         }
         doublePart = 0;
         i = 0;
         while(i < aVisibleIcons.length)
         {
            bounds = aVisibleIcons[i].GetPositionAdjustedBounds();
            leftRight = getPartitionLowerAndUpper(bounds.x - this.SafeRectLeft,bounds.width,horizontalIncrement,OVERLAP_HORIZONTAL_PARTITIONS);
            topBottom = getPartitionLowerAndUpper(bounds.y - this.SafeRectTop,bounds.height,verticalIncrement,OVERLAP_VERTICAL_PARTITIONS);
            j = leftRight.x;
            while(j <= leftRight.y)
            {
               k = topBottom.x;
               while(k <= topBottom.y)
               {
                  this.OverlapPartitions[j][k].push(aVisibleIcons[i]);
                  k++;
               }
               j++;
            }
            i++;
         }
         xInd = 0;
         while(xInd < this.OverlapPartitions.length)
         {
            xArray = this.OverlapPartitions[xInd];
            yInd = 0;
            while(yInd < xArray.length)
            {
               xyArray = xArray[yInd];
               if(xyArray.length > 1)
               {
                  i = 0;
                  while(i < xyArray.length)
                  {
                     xyArray[i].UpdateBSV();
                     i++;
                  }
                  xyArray.sort(TargetIconBase.Compare);
                  i = 0;
                  while(i < xyArray.length)
                  {
                     clipI = xyArray[i];
                     if(clipI.alpha >= MinBlockingAlpha)
                     {
                        boundsI = clipI.GetPositionAdjustedBounds();
                        j = i + 1;
                        while(j < xyArray.length)
                        {
                           clipJ = xyArray[j];
                           if(clipJ.BlockedAlpha > MaxRectIntersectAlpha)
                           {
                              boundsJ = clipJ.GetPositionAdjustedBounds();
                              intersection = boundsI.intersection(boundsJ);
                              if(!intersection.isEmpty())
                              {
                                 areaI = boundsI.width * boundsI.height;
                                 areaJ = boundsJ.width * boundsJ.height;
                                 smallBound = Math.min(areaI,areaJ);
                                 intersectionArea = intersection.width * intersection.height;
                                 overlapPercent = GlobalFunc.Clamp(intersectionArea / smallBound,MinRectIntersectPercent,MaxRectIntersectPercent);
                                 clipJ.SetBlockedClipAlpha(GlobalFunc.MapLinearlyToRange(MinRectIntersectAlpha,MaxRectIntersectAlpha,MinRectIntersectPercent,MaxRectIntersectPercent,overlapPercent,true),false);
                              }
                           }
                           j++;
                        }
                     }
                     i++;
                  }
               }
               yInd++;
            }
            xInd++;
         }
      }
      
      private function IsTargetMoving(param1:Object) : Boolean
      {
         return !GlobalFunc.CloseToNumber(param1.leadingPointScreenPositionX,param1.screenPositionX) || !GlobalFunc.CloseToNumber(param1.leadingPointScreenPositionY,param1.screenPositionY);
      }
      
      private function GetClip(param1:Object, param2:Array, param3:Class, param4:uint, param5:MovieClip) : MovieClip
      {
         var _loc7_:String = null;
         var _loc8_:TargetIconFrameContainer = null;
         var _loc6_:TargetIconFrameContainer = null;
         if((_loc6_ = param1[param4]) != null)
         {
            if(!_loc6_.visible)
            {
               _loc6_.ResetInitialized();
               param2.push(_loc6_);
               param5.addChild(_loc6_);
            }
         }
         else
         {
            if(!_loc6_)
            {
               for(_loc7_ in param1)
               {
                  if(!(_loc8_ = param1[_loc7_]).visible)
                  {
                     _loc6_ = _loc8_;
                     delete param1[_loc7_];
                     param1[param4] = _loc6_;
                     _loc6_.ResetInitialized();
                     param2.push(_loc6_);
                     param5.addChild(_loc6_);
                     break;
                  }
               }
            }
            if(!_loc6_)
            {
               _loc6_ = new param3();
               param1[param4] = _loc6_;
               param2.push(_loc6_);
               param5.addChild(_loc6_);
            }
         }
         _loc6_.visible = true;
         return _loc6_;
      }
      
      private function UpdateAllIndicatorVisibility() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:TargetIconFrameContainer = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         _loc3_ = int(this.OffScreenIndicatorArray.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = this.OffScreenIndicatorArray[_loc3_];
            if(_loc2_.visible && !_loc2_.UpdatedThisFrame(this.UpdateCounter))
            {
               _loc2_.visible = false;
               _loc2_.parent.removeChild(_loc2_);
               this.OffScreenIndicatorArray.splice(_loc3_,1);
            }
            _loc3_--;
         }
         for each(_loc4_ in this.OnScreenIndicatorArrays)
         {
            _loc3_ = _loc4_.length - 1;
            while(_loc3_ >= 0)
            {
               _loc2_ = _loc4_[_loc3_];
               if(_loc2_.visible && !_loc2_.UpdatedThisFrame(this.UpdateCounter))
               {
                  _loc2_.visible = false;
                  _loc2_.parent.removeChild(_loc2_);
                  _loc4_.splice(_loc3_,1);
               }
               _loc3_--;
            }
         }
      }
      
      public function OnLongOpenFinish() : *
      {
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.IndicatorButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.LockOn_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.TargetPanel_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !param2)
         {
            if(param1 == "Cancel" && this.StateMachine.getCurrentStateId() == STATE_MONOCLE)
            {
               this.SetState(STATE_MAIN);
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function onMapPressed() : *
      {
         var _loc1_:Object = this.LowFreqTargetData != null && this.LowFreqTargetData.iInfoTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iInfoTargetIndex] : null;
         if(_loc1_ != null && _loc1_.bLandingAllowed && !_loc1_.bLandingDisabled)
         {
            BSUIDataManager.dispatchEvent(new Event(ShipHud_Map));
         }
      }
      
      private function onLandingMarkerMapPressed() : *
      {
         var _loc1_:Object = this.LowFreqTargetData != null && this.LowFreqTargetData.iHoverTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iHoverTargetIndex] : null;
         if(_loc1_ != null && _loc1_.bLandingAllowed && !_loc1_.bLandingDisabled && _loc1_.uTargetType == TargetIconFrameContainer.TT_LANDING_MARKER)
         {
            BSUIDataManager.dispatchEvent(new Event(ShipHud_LandingMarkerMap));
         }
      }
      
      private function onLandPressed() : *
      {
         var _loc1_:Object = this.LowFreqTargetData != null && this.LowFreqTargetData.iHoverTargetIndex >= 0 ? this.LowFreqTargetData.targetArray.dataA[this.LowFreqTargetData.iHoverTargetIndex] : null;
         if(_loc1_ != null && _loc1_.bLandingAllowed && !_loc1_.bLandingDisabled && _loc1_.uTargetType == TargetIconFrameContainer.TT_LANDING_MARKER)
         {
            BSUIDataManager.dispatchEvent(new Event(ShipHud_Land));
         }
      }
      
      private function onTargetPressed() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipHud_Target));
      }
      
      private function onMonoclePressed() : *
      {
         if(this.StateMachine.getCurrentStateId() == STATE_TARGETING)
         {
            this.TargetMonocleMode = !this.TargetMonocleMode;
            this.ScanClip.SetCanOpen(this.TargetMonocleMode);
         }
         else if(this.StateMachine.getCurrentStateId() != STATE_MONOCLE && !this.GravJumpInitiated)
         {
            this.SetState(STATE_MONOCLE);
         }
         else if(this.StateMachine.getCurrentStateId() == STATE_MONOCLE)
         {
            this.SetState(STATE_MAIN);
         }
      }
      
      public function SetTargetButtonEnabled(param1:Boolean) : *
      {
         if(this.SelectTargetButton.Enabled != param1)
         {
            this.SelectTargetButton.Enabled = param1;
            this.UpdateReticleButton();
         }
      }
      
      public function UpdateSafeRect(param1:Number, param2:Number) : *
      {
         var _loc3_:Rectangle = Extensions.visibleRect;
         this.SafeRectBottom = _loc3_.height / 2 - param2;
         this.SafeRectTop = -this.SafeRectBottom;
         this.SafeRectRight = _loc3_.width / 2 - param1;
         this.SafeRectLeft = -this.SafeRectRight;
      }
      
      public function GetCurrentTargetPanelLeftRightButtonHintData(param1:Boolean) : ButtonBaseData
      {
         return this.TargetPanel_mc.GetCurrentLeftRightButtonHintData(param1);
      }
   }
}
