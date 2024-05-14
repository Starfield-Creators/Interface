package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.HoldButton;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.ShipInfoUtils;
   import fl.motion.AnimatorFactoryUniversal;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.*;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   
   public class SpaceshipHudMenu extends IMenu
   {
      
      public static const ShipHud_Deselect:String = "ShipHud_Deselect";
      
      public static const ShipHud_SetTargetMode:String = "ShipHud_SetTargetMode";
      
      public static const ShipHud_CloseMenu:String = "ShipHud_CloseMenu";
      
      public static const ShipHud_FireWeapon:String = "ShipHud_FireWeapon";
      
      public static const ShipHud_OpenPhotoMode:String = "ShipHud_OpenPhotoMode";
      
      private static const POWER_POS_MAGNITUDE:uint = 14;
      
      private static const SHIELD_POS_MAGNITUDE:uint = 14;
      
      private static const POWER_ROT_MAGNITUDE:uint = 4;
      
      private static const SHIELD_ROT_MAGNITUDE:uint = 4;
      
      private static const POWER_POS_LERP_PERCENT:Number = 0.067;
      
      private static const SHIELD_POS_LERP_PERCENT:Number = 0.067;
      
      private static const POWER_ROT_LERP_PERCENT:Number = 0.067;
      
      private static const SHIELD_ROT_LERP_PERCENT:Number = 0.067;
      
      private static const STATE_IDLE:uint = EnumHelper.GetEnum(0);
      
      private static const STATE_TARGET:uint = EnumHelper.GetEnum();
      
      private static const STATE_HAIL_ACCEPTED:uint = EnumHelper.GetEnum();
      
      private static const STATE_HAIL_SCENE:uint = EnumHelper.GetEnum();
      
      private static const STATE_HAIL_DIALOGUE_SCENE:uint = EnumHelper.GetEnum();
      
      private static const COMPONENT_METER_TICK_COUNT:uint = 12;
      
      private static const SAFE_RECT_3D_PADDING_X:uint = 50;
      
      private static const SAFE_RECT_3D_PADDING_Y:uint = 25;
       
      
      public var __animFactory_ShipHudQuickContainer_mcaf1:AnimatorFactoryUniversal;
      
      public var __animArray_ShipHudQuickContainer_mcaf1:Array;
      
      public var ____motion_ShipHudQuickContainer_mcaf1_mat3DVec__:Vector.<Number>;
      
      public var ____motion_ShipHudQuickContainer_mcaf1_matArray__:Array;
      
      public var __motion_ShipHudQuickContainer_mcaf1:MotionBase;
      
      public var DebugText_tf:TextField;
      
      public var DebugButtonHints_tf:TextField;
      
      public var PowerAllocationComponentWrapper_mc:MovieClip;
      
      public var ShieldComponentWrapper_mc:MovieClip;
      
      public var GetUpButton_mc:HoldButton;
      
      public var Reticle_mc:ShipReticle;
      
      public var StarbornGravJumpComponent_mc:GravJumpComponent;
      
      public var GravJumpComponent_mc:GravJumpComponent;
      
      public var Alerts_mc:MovieClip;
      
      public var ShipHudQuickContainer_mc:MovieClip;
      
      public var HailComponent_mc:HailComponent;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var ScanDetails_mc:MovieClip;
      
      private var CurrentGravJumpComponent:GravJumpComponent;
      
      private var DeselectButtonData:ButtonBaseData;
      
      private var ExitTargetComputerButtonData:ButtonBaseData;
      
      private var PhotoModeButtonData:ButtonBaseData;
      
      private var AltButtonDataPC:ButtonBaseData;
      
      private var TargetPanelLeftRightButtonDataPC:ButtonBaseData;
      
      private var DeselectButton:IButton;
      
      private var ExitTargetComputerButton:IButton;
      
      private var PhotoModeButton:IButton;
      
      private var MonocleButton:IButton;
      
      private var AltButton:IButton;
      
      private var TargetPanelControlButton:IButton;
      
      private var _dataSubscriptionKeyword:String = "ShipHudData";
      
      private var _SpaceshipHudInfoDataPayload:Object = null;
      
      private var TargetsLowFreqDataPayload:Object = null;
      
      private var TargetOnlyData:Object;
      
      private var ReticleTransformInputDir:Vector3D;
      
      private var Trackers:Array;
      
      private var HudMode:uint;
      
      private var MyButtonManager:ButtonManager;
      
      private var ShipRepairButton:IButton = null;
      
      private var TargetState:uint;
      
      private var GetUpButtonHintData:ButtonBaseData;
      
      private var GetUpButtonHintDataKBM:ButtonBaseData;
      
      private var _usingKBM:Boolean = false;
      
      private var LeftStickHeld:Boolean = false;
      
      private var RightStickHeld:Boolean = false;
      
      private var LastLeftStickDirection:String = "None";
      
      private var LastRightStickDirection:String = "None";
      
      private var WasTargetModeActive:Boolean = false;
      
      private var ButtonAlpha:Number = 0;
      
      private var ButtonAlphaInitialized:Boolean = false;
      
      private var WeaponMap:Object;
      
      public function SpaceshipHudMenu()
      {
         var button:IButton = null;
         this.DeselectButtonData = new ButtonBaseData("$DESELECT",new UserEventData("Cancel",this.onDeselectTargetPressed),true,false);
         this.ExitTargetComputerButtonData = new ButtonBaseData("$Exit Targeting",new UserEventData("Cancel",this.onExitTargetComputerPressed));
         this.PhotoModeButtonData = new ButtonBaseData("$PHOTOMODE",new UserEventData("PhotoMode",this.onOpenPhotoMode),false,false);
         this.AltButtonDataPC = new ButtonBaseData("$Swap System Controls",new UserEventData("AltHold",null),false,false);
         this.ReticleTransformInputDir = new Vector3D();
         this.Trackers = new Array();
         this.HudMode = ShipInfoUtils.SH_MODE_FIRST_PERSON;
         this.MyButtonManager = new ButtonManager();
         this.TargetState = STATE_IDLE;
         this.GetUpButtonHintData = new ButtonBaseData("",new UserEventData("Cancel",null,ShipHud_CloseMenu));
         this.GetUpButtonHintDataKBM = new ButtonBaseData("",new UserEventData("SelectTarget",null,ShipHud_CloseMenu));
         this.WeaponMap = {
            "RTrigger":0,
            "LTrigger":1,
            "YButton":2
         };
         super();
         this.Reticle_mc.ScanClip = this.ScanDetailsClip;
         this.GetUpButton_mc.SetButtonData(this.GetUpButtonHintData);
         this.MyButtonManager.AddButton(this.StarbornGravJumpComponent_mc.CancelButton_mc);
         this.MyButtonManager.AddButton(this.GravJumpComponent_mc.CancelButton_mc);
         this.MyButtonManager.AddButton(this.PowerAllocationComponentClip.DPadButton_mc);
         this.MyButtonManager.AddButton(this.PowerAllocationComponentClip.UpButton_mc);
         this.MyButtonManager.AddButton(this.PowerAllocationComponentClip.DownButton_mc);
         this.ShipRepairButton = this.ShieldComponentClip.ShipRepairButton;
         this.MyButtonManager.AddButton(this.ShipRepairButton);
         addEventListener(LockOnIndicator.LOCK_ON_PRESSED,this.onTargetComputerPressed);
         this.HailComponent_mc.addEventListener(HailComponent.HAIL_ACCEPTED,function():*
         {
            SetTargetState(STATE_HAIL_ACCEPTED);
         });
         this.ScanDetailsClip.addEventListener(ScanDetails.ON_TOGGLE_SCAN_DETAILS_EVENT,this.QuickContainerClip.OnMonocleModeChange);
         this.Reticle_mc.addEventListener(ShipReticle.Reticle_FarTravelInitiate,this.PowerAllocationComponentClip.InitiateFarTravel);
         this.Reticle_mc.addEventListener(ShipReticle.Reticle_FarTravelInitiate,this.ShieldComponentClip.InitiateFarTravel);
         this.Reticle_mc.addEventListener(ShipReticle.Reticle_FarTravelInitiate,this.InitiateFarTravel);
         this.Reticle_mc.addEventListener(ShipReticle.Reticle_FarTravelComplete,this.PowerAllocationComponentClip.CompleteFarTravel);
         this.Reticle_mc.addEventListener(ShipReticle.Reticle_FarTravelComplete,this.ShieldComponentClip.CompleteFarTravel);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER);
         this.ExitTargetComputerButton = ButtonFactory.AddToButtonBar("BasicButton",this.ExitTargetComputerButtonData,this.ButtonBar_mc) as IButton;
         this.DeselectButton = ButtonFactory.AddToButtonBar("BasicButton",this.DeselectButtonData,this.ButtonBar_mc) as IButton;
         this.PhotoModeButton = ButtonFactory.AddToButtonBar("BasicButton",this.PhotoModeButtonData,this.ButtonBar_mc) as IButton;
         this.MonocleButton = ButtonFactory.AddToButtonBar("BasicButton",this.Reticle_mc.MonocleButton,this.ButtonBar_mc) as IButton;
         this.AltButton = ButtonFactory.AddToButtonBar("BasicButton",this.AltButtonDataPC,this.ButtonBar_mc) as IButton;
         this.TargetPanelLeftRightButtonDataPC = this.Reticle_mc.GetCurrentTargetPanelLeftRightButtonHintData(false);
         this.TargetPanelControlButton = ButtonFactory.AddToButtonBar("BasicButton",this.TargetPanelLeftRightButtonDataPC,this.ButtonBar_mc) as IButton;
         this.ButtonBar_mc.RefreshButtons();
         this.ButtonAlpha = 0;
         this.GetUpButton_mc.alpha = this.ButtonAlpha;
         this.ButtonBar_mc.alpha = this.ButtonAlpha;
         if(this.__animFactory_ShipHudQuickContainer_mcaf1 == null)
         {
            this.__animArray_ShipHudQuickContainer_mcaf1 = new Array();
            this.__motion_ShipHudQuickContainer_mcaf1 = new MotionBase();
            this.__motion_ShipHudQuickContainer_mcaf1.duration = 2;
            this.__motion_ShipHudQuickContainer_mcaf1.overrideTargetTransform();
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("blendMode",["normal","normal"]);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("cacheAsBitmap",[false,false]);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("opaqueBackground",[null,null]);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("visible",[true,true]);
            this.__motion_ShipHudQuickContainer_mcaf1.motion_internal::spanStart = 0;
            this.____motion_ShipHudQuickContainer_mcaf1_matArray__ = new Array();
            this.____motion_ShipHudQuickContainer_mcaf1_matArray__.push(new Matrix(1,0,0,1,1270,260));
            this.____motion_ShipHudQuickContainer_mcaf1_matArray__.push(null);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("matrix",this.____motion_ShipHudQuickContainer_mcaf1_matArray__);
            this.__animArray_ShipHudQuickContainer_mcaf1.push(this.__motion_ShipHudQuickContainer_mcaf1);
            this.__motion_ShipHudQuickContainer_mcaf1 = new MotionBase();
            this.__motion_ShipHudQuickContainer_mcaf1.duration = 1;
            this.__motion_ShipHudQuickContainer_mcaf1.overrideTargetTransform();
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("opaqueBackground",[null]);
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("visible",[false]);
            this.__motion_ShipHudQuickContainer_mcaf1.is3D = true;
            this.__motion_ShipHudQuickContainer_mcaf1.motion_internal::spanStart = 2;
            this.____motion_ShipHudQuickContainer_mcaf1_matArray__ = new Array();
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[0] = 0.996179;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[1] = -0.010622;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[2] = -0.086692;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[3] = 0;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[4] = 0.003042;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[5] = 0.996195;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[6] = -0.087103;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[7] = 0;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[8] = 0.087288;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[9] = 0.086506;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[10] = 0.99242;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[11] = 0;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[12] = 1504.463623;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[13] = -434.982178;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[14] = 28.072668;
            this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__[15] = 1;
            this.____motion_ShipHudQuickContainer_mcaf1_matArray__.push(new Matrix3D(this.____motion_ShipHudQuickContainer_mcaf1_mat3DVec__));
            this.__motion_ShipHudQuickContainer_mcaf1.addPropertyArray("matrix3D",this.____motion_ShipHudQuickContainer_mcaf1_matArray__);
            this.__animArray_ShipHudQuickContainer_mcaf1.push(this.__motion_ShipHudQuickContainer_mcaf1);
            this.__animFactory_ShipHudQuickContainer_mcaf1 = new AnimatorFactoryUniversal(null,this.__animArray_ShipHudQuickContainer_mcaf1);
            this.__animFactory_ShipHudQuickContainer_mcaf1.addTargetInfo(this,"ShipHudQuickContainer_mc",0,true,0,true,null,-1);
         }
      }
      
      private function get QuickContainerClip() : ShipHudQuickContainer
      {
         return this.ShipHudQuickContainer_mc.Internal_mc;
      }
      
      private function get PowerAllocationComponentClip() : PowerAllocationComponent
      {
         return this.PowerAllocationComponentWrapper_mc.PowerAllocationComponent_mc;
      }
      
      private function get ShieldComponentClip() : ShieldThrottleComponent
      {
         return this.ShieldComponentWrapper_mc.ShieldComponent_mc;
      }
      
      private function get ScanDetailsClip() : ScanDetails
      {
         return this.ScanDetails_mc.Internal_mc;
      }
      
      private function set buttonAlpha(param1:Number) : void
      {
         this.ButtonAlpha = param1;
         this.ButtonAlphaInitialized = true;
      }
      
      private function SetHudMode(param1:uint) : *
      {
         if(this.HudMode != param1)
         {
            switch(param1)
            {
               case ShipInfoUtils.SH_MODE_FIRST_PERSON:
                  gotoAndStop("FirstPerson");
                  this.buttonAlpha = 1;
                  break;
               case ShipInfoUtils.SH_MODE_THIRD_PERSON:
                  gotoAndStop("ThirdPerson");
                  this.buttonAlpha = 1;
                  break;
               case ShipInfoUtils.SH_MODE_FREE_LOOK:
                  gotoAndStop("FreeLook");
                  this.buttonAlpha = 0;
                  break;
               default:
                  GlobalFunc.TraceWarning("Unknown ship hud mode given: " + param1);
            }
            this.HudMode = param1;
            this.ResetTrackerPositions();
         }
      }
      
      private function ResetTrackerPositions() : *
      {
         var _loc1_:ShipHudMovementTracker = null;
         for each(_loc1_ in this.Trackers)
         {
            _loc1_.Reset();
         }
      }
      
      private function UpdateHudMovement() : *
      {
         var _loc1_:ShipHudMovementTracker = null;
         for each(_loc1_ in this.Trackers)
         {
            _loc1_.Update(this.ReticleTransformInputDir);
         }
      }
      
      private function onEnterFrame() : *
      {
         this.UpdateHudMovement();
         this.GetUpButton_mc.Visible = this.GetUpButton_mc.Held;
         this.UpdateButtons();
         if(!this.ButtonAlphaInitialized)
         {
            this.buttonAlpha = 1;
         }
         this.GetUpButton_mc.alpha = this.ButtonAlpha;
         this.ButtonBar_mc.alpha = this.ButtonAlpha;
      }
      
      private function InitializeTrackers() : *
      {
         this.Trackers.splice();
         this.Trackers.push(new ShipHudMovementTracker(this.PowerAllocationComponentClip,POWER_POS_MAGNITUDE,POWER_ROT_MAGNITUDE,POWER_POS_LERP_PERCENT,POWER_ROT_LERP_PERCENT));
         this.Trackers.push(new ShipHudMovementTracker(this.ShieldComponentClip,SHIELD_POS_MAGNITUDE,SHIELD_ROT_MAGNITUDE,SHIELD_POS_LERP_PERCENT,SHIELD_ROT_LERP_PERCENT));
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.InitializeTrackers();
         BSUIDataManager.Subscribe("ShipHudData",function(param1:FromClientDataEvent):*
         {
            SpaceshipHudInfoDataPayload = param1.data;
            CurrentGravJumpComponent = !!SpaceshipHudInfoDataPayload.bStarbornShip ? StarbornGravJumpComponent_mc : GravJumpComponent_mc;
            RefreshView();
            PowerAllocationComponentClip.UpdateShipHudData(SpaceshipHudInfoDataPayload);
            CurrentGravJumpComponent.SetGravDriveHudData(SpaceshipHudInfoDataPayload);
            Alerts_mc.SetStateAndMessage(SpaceshipHudInfoDataPayload.uiAlertMessageType,SpaceshipHudInfoDataPayload.sAlertMessageText,SpaceshipHudInfoDataPayload.bAlertMessageEnemyMissile);
            QuickContainerClip.UpdatePlayerData(SpaceshipHudInfoDataPayload);
         });
         BSUIDataManager.Subscribe("TargetLowFrequencyProvider",function(param1:FromClientDataEvent):*
         {
            TargetsLowFreqDataPayload = param1.data;
            QuickContainerClip.UpdateTargetData(TargetsLowFreqDataPayload);
            Reticle_mc.UpdateLowFrequencyData(TargetsLowFreqDataPayload);
            HailComponent_mc.UpdateData(TargetsLowFreqDataPayload);
            var _loc2_:Object = TargetsLowFreqDataPayload.iInfoTargetIndex != -1 ? TargetsLowFreqDataPayload.targetArray.dataA[TargetsLowFreqDataPayload.iInfoTargetIndex] : null;
            UpdateState();
         });
         BSUIDataManager.Subscribe("TargetHighFrequencyProvider",function(param1:FromClientDataEvent):*
         {
            Reticle_mc.UpdateHighFrequencyData(param1.data);
            QuickContainerClip.UpdateTargetHigh(param1.data);
         });
         BSUIDataManager.Subscribe("TargetCombatValuesProvider",function(param1:FromClientDataEvent):*
         {
            Reticle_mc.UpdateCombatValuesData(param1.data);
         });
         BSUIDataManager.Subscribe("InfoTargetProvider",function(param1:FromClientDataEvent):*
         {
            TargetOnlyData = param1.data;
            Reticle_mc.UpdateTargetOnlyData(param1.data);
            QuickContainerClip.UpdateTargetOnlyData(param1.data);
            if(!TargetOnlyData.bTargetModeActive && WasTargetModeActive)
            {
               ProcessUserEvent(LastLeftStickDirection,false);
               ProcessUserEvent(LastRightStickDirection,false);
               LeftStickHeld = false;
               RightStickHeld = false;
            }
            WasTargetModeActive = TargetOnlyData.bTargetModeActive;
         });
         BSUIDataManager.Subscribe("PlayerShipComponentsProvider",function(param1:FromClientDataEvent):*
         {
            PowerAllocationComponentClip.OnShipComponentUpdate(param1.data.PowerComponent,param1.data.componentArray);
            ShieldComponentClip.OnPlayerShipComponentsUpdate(param1.data);
            Reticle_mc.OnPlayerShipComponentsUpdate(param1.data);
            if(CurrentGravJumpComponent != null)
            {
               CurrentGravJumpComponent.GetGravDrivePowered(param1.data.componentArray);
            }
         });
         BSUIDataManager.Subscribe("StickDataProvider",function(param1:FromClientDataEvent):*
         {
            RefreshStickData(param1.data);
            Reticle_mc.OnStickDataUpdate(param1.data);
         });
         BSUIDataManager.Subscribe("TargetShipInventoryData",function(param1:FromClientDataEvent):*
         {
            QuickContainerClip.OnItemsChanged(param1.data);
            ScanDetailsClip.UpdateInventoryData(param1.data,SpaceshipHudInfoDataPayload);
         });
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override protected function onSetSafeRect() : void
      {
         this.ResetTrackerPositions();
         this.Reticle_mc.UpdateSafeRect(SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.PowerAllocationComponentClip,"BL",SafeX + SAFE_RECT_3D_PADDING_X,SafeY + SAFE_RECT_3D_PADDING_Y,true);
         GlobalFunc.LockToSafeRect(this.ShieldComponentClip,"BR",SafeX + SAFE_RECT_3D_PADDING_X,SafeY + SAFE_RECT_3D_PADDING_Y,true);
         GlobalFunc.LockToSafeRect(this.ScanDetailsClip,"L",SafeX,SafeY,true);
         this.InitializeTrackers();
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         super.OnControlMapChanged(param1);
         if(IsControllerValueValid())
         {
            _loc2_ = this._usingKBM;
            this._usingKBM = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
            if(this._usingKBM != _loc2_)
            {
               this.GetUpButton_mc.CancelHold();
               if(this._usingKBM)
               {
                  this.GetUpButton_mc.SetButtonData(this.GetUpButtonHintDataKBM);
               }
               else
               {
                  this.GetUpButton_mc.SetButtonData(this.GetUpButtonHintData);
               }
            }
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function UpdateState() : *
      {
         var _loc1_:Object = this.TargetsLowFreqDataPayload.iInfoTargetIndex != -1 ? this.TargetsLowFreqDataPayload.targetArray.dataA[this.TargetsLowFreqDataPayload.iInfoTargetIndex] : null;
         if(this.TargetsLowFreqDataPayload.bPlayerInDialogueScene)
         {
            this.SetTargetState(STATE_HAIL_DIALOGUE_SCENE);
         }
         else if(this.TargetsLowFreqDataPayload.bPlayerInScene)
         {
            this.SetTargetState(STATE_HAIL_SCENE);
         }
         else if(_loc1_ != null && this.TargetState != STATE_HAIL_ACCEPTED)
         {
            this.SetTargetState(STATE_TARGET);
         }
         else if(_loc1_ == null)
         {
            this.SetTargetState(STATE_IDLE);
         }
      }
      
      private function SetTargetState(param1:uint) : *
      {
         if(this.TargetState != param1)
         {
            if(this.TargetState == STATE_HAIL_DIALOGUE_SCENE)
            {
               GlobalFunc.PlayMenuSound(HailComponent.HAIL_CLOSE_SOUND);
            }
            else if(param1 == STATE_HAIL_DIALOGUE_SCENE)
            {
               GlobalFunc.PlayMenuSound(HailComponent.HAIL_OPEN_SOUND);
            }
            this.TargetState = param1;
         }
      }
      
      private function UpdateButtonState(param1:IButton, param2:Boolean, param3:Boolean) : Boolean
      {
         var _loc4_:Boolean = false;
         if(param1.Visible != param2)
         {
            param1.Visible = param2;
            _loc4_ = true;
         }
         if(param1.Enabled != param3)
         {
            param1.Enabled = param3;
            _loc4_ = true;
         }
         return _loc4_;
      }
      
      private function UpdateTargetButtons() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:Boolean = false;
         if(this.TargetOnlyData != null)
         {
            _loc2_ = Boolean(this.TargetOnlyData.bTargetModeActive);
            _loc1_ = this.UpdateButtonState(this.ExitTargetComputerButton,this.TargetOnlyData.bTargetModeActive,this.TargetOnlyData.bTargetModeActive) || _loc1_;
         }
         else
         {
            _loc1_ = this.UpdateButtonState(this.ExitTargetComputerButton,false,false) || _loc1_;
         }
         return _loc1_;
      }
      
      private function UpdateButtons() : *
      {
         var _loc1_:Boolean = this.Reticle_mc.MonocleModeActive;
         var _loc2_:Boolean = false;
         switch(this.TargetState)
         {
            case STATE_IDLE:
               this.Reticle_mc.SetTargetButtonEnabled(true);
               break;
            case STATE_TARGET:
            case STATE_HAIL_SCENE:
               this.Reticle_mc.SetTargetButtonEnabled(this.TargetOnlyData != null && !this.TargetOnlyData.bTargetModeActive);
               break;
            case STATE_HAIL_ACCEPTED:
            case STATE_HAIL_DIALOGUE_SCENE:
               this.Reticle_mc.SetTargetButtonEnabled(true);
         }
         _loc2_ = this.UpdateButtonState(this.PhotoModeButton,_loc1_,_loc1_ && Boolean(this.SpaceshipHudInfoDataPayload.bPhotoModeAllowed)) || _loc2_;
         _loc2_ = this.UpdateButtonState(this.MonocleButton,_loc1_,true) || _loc2_;
         _loc2_ = this.UpdateTargetButtons() || _loc2_;
         _loc2_ = this.UpdateButtonState(this.ShipRepairButton,!_loc1_ && Boolean(this.SpaceshipHudInfoDataPayload.bAllowRepair),!_loc1_ && this.SpaceshipHudInfoDataPayload.uNumRepairItems > 0) || _loc2_;
         var _loc3_:Boolean = this._usingKBM && Boolean(this.TargetOnlyData.bTargetModeActive);
         _loc2_ = this.UpdateButtonState(this.AltButton,_loc3_,_loc3_) || _loc2_;
         var _loc4_:ButtonBaseData = this.Reticle_mc.GetCurrentTargetPanelLeftRightButtonHintData(this.SpaceshipHudInfoDataPayload.bAltHeld);
         if(this.TargetPanelLeftRightButtonDataPC != _loc4_)
         {
            this.TargetPanelControlButton.SetButtonData(_loc4_);
            this.TargetPanelLeftRightButtonDataPC = _loc4_;
            _loc2_ = true;
         }
         _loc2_ = this.UpdateButtonState(this.TargetPanelControlButton,_loc3_,_loc3_) || _loc2_;
         if(_loc2_)
         {
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function get SpaceshipHudInfoDataPayload() : Object
      {
         return this._SpaceshipHudInfoDataPayload;
      }
      
      private function set SpaceshipHudInfoDataPayload(param1:Object) : void
      {
         if(this._SpaceshipHudInfoDataPayload != param1)
         {
            this._SpaceshipHudInfoDataPayload = param1;
            SetIsDirty();
         }
      }
      
      private function RefreshWholeShip() : *
      {
         this.ShieldComponentClip.Update(this.SpaceshipHudInfoDataPayload);
         this.SetHudMode(this.SpaceshipHudInfoDataPayload.shipHudMode);
         this.Reticle_mc.Update(this.SpaceshipHudInfoDataPayload,this.ReticleTransformInputDir);
      }
      
      private function RefreshShipComponents() : *
      {
         if(this.SpaceshipHudInfoDataPayload.gravJumpCalculatedPercentage > 0 || Boolean(this.SpaceshipHudInfoDataPayload.bGravJumpAnimStarted))
         {
            if(!this.CurrentGravJumpComponent.WasGravJumping)
            {
               GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceALong");
               this.Reticle_mc.SetState(ShipReticle.STATE_CLOSED_TRAVEL);
               this.HailComponent_mc.Hide(true);
            }
         }
         else if(this.CurrentGravJumpComponent.WasGravJumping)
         {
            this.Reticle_mc.SetState(ShipReticle.STATE_MAIN);
         }
         this.CurrentGravJumpComponent.RefreshGravJumpComponent(this.SpaceshipHudInfoDataPayload);
         if(this.StarbornGravJumpComponent_mc == this.CurrentGravJumpComponent)
         {
            this.GravJumpComponent_mc.Disable();
         }
         else if(this.GravJumpComponent_mc == this.CurrentGravJumpComponent)
         {
            this.StarbornGravJumpComponent_mc.Disable();
         }
      }
      
      private function RefreshStickData(param1:Object) : *
      {
         this.ReticleTransformInputDir.x = param1.fReticleTransformInputX;
         this.ReticleTransformInputDir.y = param1.fReticleTransformInputY;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0.3;
         if(param1.boostActive)
         {
            _loc2_ = 0.7;
            _loc3_ = 1;
         }
         this.ReticleTransformInputDir.z = GlobalFunc.MapLinearlyToRange(_loc2_,_loc3_,0,1,param1.throttle,true);
      }
      
      public function RefreshView() : *
      {
         this.RefreshWholeShip();
         this.RefreshShipComponents();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:* = false;
         var _loc3_:Boolean = false;
         if(!this.Reticle_mc.FarTraveling && !this.SpaceshipHudInfoDataPayload.bGravJumpAnimStarted)
         {
            _loc4_ = !this.SpaceshipHudInfoDataPayload.bDialogueActive && Boolean(this.TargetOnlyData.canBeHailed) && this.TargetsLowFreqDataPayload.iInfoTargetIndex >= 0;
            _loc5_ = !this.SpaceshipHudInfoDataPayload.bOtherEventEnabledActivation;
            if(!_loc4_ && !this.TargetOnlyData.bTargetModeActive && !this.SpaceshipHudInfoDataPayload.bGravJumpInitiated && !_loc5_)
            {
               _loc3_ = this.GetUpButton_mc.HandleUserEvent(param1,param2,_loc3_);
            }
            if(!_loc3_)
            {
               _loc3_ = this.HailComponent_mc.ProcessUserEvent(param1,param2);
            }
            if(!_loc3_)
            {
               _loc3_ = this.QuickContainerClip.ProcessUserEvent(param1,param2);
            }
            if(!_loc3_)
            {
               _loc3_ = this.Reticle_mc.ProcessUserEvent(param1,param2);
            }
            if(!_loc3_)
            {
               _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
            if(!_loc3_)
            {
               _loc3_ = this.MyButtonManager.ProcessUserEvent(param1,param2);
            }
         }
         return _loc3_;
      }
      
      private function GetStickDirection(param1:Number, param2:Number) : String
      {
         var _loc3_:String = "None";
         if(Math.abs(param1) > Math.abs(param2))
         {
            if(param1 > 0)
            {
               _loc3_ = "Right";
            }
            else
            {
               _loc3_ = "Left";
            }
         }
         else if(param2 > 0)
         {
            _loc3_ = "Down";
         }
         else
         {
            _loc3_ = "Up";
         }
         return _loc3_;
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : Boolean
      {
         var _loc7_:String = null;
         var _loc6_:Boolean = false;
         if(this.TargetOnlyData.bTargetModeActive)
         {
            _loc6_ = true;
            _loc7_ = "None";
            if(param4)
            {
               this.LeftStickHeld = true;
            }
            if(param5)
            {
               this.LeftStickHeld = false;
            }
            if(this.LeftStickHeld)
            {
               _loc7_ = this.GetStickDirection(param1,param2);
            }
            if(this.LastLeftStickDirection != _loc7_)
            {
               if(this.LastLeftStickDirection != "None")
               {
                  this.ProcessUserEvent("Select" + this.LastLeftStickDirection,false);
               }
               if(_loc7_ != "None")
               {
                  this.ProcessUserEvent("Select" + _loc7_,true);
               }
               this.LastLeftStickDirection = _loc7_;
            }
         }
         return _loc6_;
      }
      
      private function onDeselectTargetPressed() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipHud_Deselect));
      }
      
      private function onTargetComputerPressed() : *
      {
         this.SetTargetMode(true);
      }
      
      private function onExitTargetComputerPressed() : *
      {
         this.SetTargetMode(false);
      }
      
      private function SetTargetMode(param1:Boolean) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_SetTargetMode,{"bValue":param1}));
      }
      
      private function onOpenPhotoMode() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipHud_OpenPhotoMode));
      }
      
      private function InitiateFarTravel() : *
      {
         this.HailComponent_mc.Hide(true);
      }
   }
}
