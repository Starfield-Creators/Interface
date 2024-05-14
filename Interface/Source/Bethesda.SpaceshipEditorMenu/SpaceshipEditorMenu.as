package
{
   import Components.SystemUpgrade;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.HoldButton;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.ReleaseHoldComboButton;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   
   public class SpaceshipEditorMenu extends IMenu
   {
      
      public static const ShipBuilder_ShowExitConfirmation:String = "ShipBuilder_ShowExitConfirmation";
      
      public static const ShipBuilder_CloseAllMenus:String = "ShipBuilder_CloseAllMenus";
      
      public static const ShipEditor_OnHintButtonActivated:String = "ShipEditor_OnHintButtonActivated";
      
      public static const HangarShipSelection_RepairShip:String = "HangarShipSelection_RepairShip";
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Crosshair_mc:MovieClip;
      
      public var HangarInfoPanel_mc:MovieClip;
      
      public var FlightCheck_mc:FlightCheck;
      
      public var SystemUpgrade_mc:SystemUpgrade;
      
      public var CostSummary_mc:CostSummary;
      
      public var ShipStatsFooter_mc:ShipStatsFooter;
      
      public var PowerAllocation_mc:PowerAllocation;
      
      public var MessagePopup_mc:MovieClip;
      
      public var ModulePalette_mc:ModulePalette;
      
      public var ModuleInfoCard_mc:ModuleInfoCard;
      
      public var Notifications_mc:Notifications;
      
      public var FloorIndicator_mc:FloorIndicator;
      
      public var ShipRename_mc:ShipRename;
      
      public var ExitConfirmation_mc:ExitConfirmation;
      
      public var ColorPicker_mc:ColorPicker;
      
      public var ReactorStats_mc:ShipStat;
      
      public var EquipmentStat_mc:ShipStat;
      
      public var RepairMeter_mc:HoldButton;
      
      public var ShowingStatsMarker_mc:MovieClip;
      
      public var NoStatsMarker_mc:MovieClip;
      
      public var StatFooterBar_mc:MovieClip;
      
      public var Spinner_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private var activeInfoCard:ModuleInfoCard;
      
      private var testEntries:Array;
      
      private var StaticData:Object;
      
      private var _skillLibrary:SharedLibraryOwner = null;
      
      private var BarButtons:Vector.<IButton>;
      
      private var GamepadCrosshairEnabled:Boolean = false;
      
      private var RepairButtonHintData:ButtonBaseData;
      
      public function SpaceshipEditorMenu()
      {
         this.RepairButtonHintData = new ButtonBaseData("$REPAIR",[new UserEventData("Repair",this.SendRepairEvent)]);
         super();
         this.ButtonBar_mc.RedrawOnFrameEnter = true;
         this.ButtonBar_mc.Initialize(1);
         this.BarButtons = new Vector.<IButton>();
         this._skillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,AttributeIcon.SET_LOADER);
         this.Spinner_mc.visible = false;
      }
      
      private function get ActiveInfoCard() : ModuleInfoCard
      {
         return this.activeInfoCard;
      }
      
      private function get ShipSelector() : ShipNameCallSign
      {
         return this.HangarInfoPanel_mc.ShipSelector_mc;
      }
      
      private function get PowerPanel() : PowerDisplay
      {
         return this.HangarInfoPanel_mc.PowerPanel_mc;
      }
      
      private function get ContentBackground() : MovieClip
      {
         return this.HangarInfoPanel_mc.ContentBackground_mc;
      }
      
      private function set MenuBackgroundVisible(param1:Boolean) : void
      {
         this.Background_mc.Solid_mc.visible = param1;
      }
      
      private function get EditorButtonName() : String
      {
         return "EditorButton";
      }
      
      override protected function onSetSafeRect() : void
      {
         var _loc1_:Rectangle = Extensions.visibleRect;
         var _loc2_:Point = new Point(_loc1_.x,_loc1_.y);
         var _loc3_:Point = this.Background_mc.parent.globalToLocal(_loc2_);
         this.Background_mc.width = _loc1_.width;
         this.Background_mc.height = _loc1_.height;
         this.Background_mc.x = _loc3_.x;
         this.Background_mc.y = _loc3_.y;
         _loc3_ = this.ShipRename_mc.FullscreenBG_mc.globalToLocal(_loc2_);
         this.ShipRename_mc.FullscreenBG_mc.Rect_mc.width = _loc1_.width;
         this.ShipRename_mc.FullscreenBG_mc.Rect_mc.height = _loc1_.height;
         this.ShipRename_mc.FullscreenBG_mc.Rect_mc.x = _loc3_.x;
         this.ShipRename_mc.FullscreenBG_mc.Rect_mc.y = _loc3_.y;
         _loc3_ = this.ExitConfirmation_mc.FullscreenBG_mc.globalToLocal(_loc2_);
         this.ExitConfirmation_mc.FullscreenBG_mc.Rect_mc.width = _loc1_.width;
         this.ExitConfirmation_mc.FullscreenBG_mc.Rect_mc.height = _loc1_.height;
         this.ExitConfirmation_mc.FullscreenBG_mc.Rect_mc.x = _loc3_.x;
         this.ExitConfirmation_mc.FullscreenBG_mc.Rect_mc.y = _loc3_.y;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.SetupRepairMeter();
         BSUIDataManager.Subscribe("StaticData",function(param1:FromClientDataEvent):*
         {
            StaticData = param1.data;
            MenuBackgroundVisible = !StaticData.bCKActive;
            SetCostSummaryVisible(StaticData.bVendorMode);
         });
         BSUIDataManager.Subscribe("GamepadCursorData",function(param1:FromClientDataEvent):*
         {
            GamepadCrosshairEnabled = param1.data.bEnabled;
            UpdateGamepadCrosshair();
         });
         BSUIDataManager.Subscribe("HangarData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            ShowWaitSpinner(_loc2_.bShowSpinner);
            SetHangarMenuVisible(_loc2_.bMenuVisible);
            SetBuilderMenuVisible(!_loc2_.bMenuVisible && Boolean(_loc2_.bShowBuilder));
            CostSummary_mc.visible = Boolean(StaticData.bVendorMode) && (Boolean(_loc2_.bMenuVisible) || Boolean(_loc2_.bShowBuilder));
            CostSummary_mc.TotalCreditsVisible = !_loc2_.bMenuVisible && Boolean(_loc2_.bShowBuilder);
         });
         BSUIDataManager.Subscribe("FloorData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            FloorIndicator_mc.visible = _loc2_.bShowWidget;
            FloorIndicator_mc.ChangeFloor(_loc2_.fCurrentFloor);
         });
         BSUIDataManager.Subscribe("PartEntries",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            var _loc3_:Boolean = Boolean(_loc2_.bShowWidget);
            SetModulePaletteVisible(_loc3_);
            if(_loc3_)
            {
               ModulePalette_mc.Update(_loc2_);
            }
         });
         BSUIDataManager.Subscribe("UpgradeEntries",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            var _loc3_:Boolean = Boolean(_loc2_.bShowWidget);
            SetModulePaletteVisible(_loc3_);
            if(_loc3_)
            {
               ModulePalette_mc.Update(_loc2_);
            }
         });
         BSUIDataManager.Subscribe("ModuleVariant",function(param1:FromClientDataEvent):*
         {
            ModulePalette_mc.SelectedEntryChangeVariant(param1.data.iVariantDirection,param1.data.sVariantName,param1.data.VariantIcon);
         });
         BSUIDataManager.Subscribe("ModuleInfo",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            ModuleInfoCard_mc.UpdateValues(_loc2_,_loc2_.bInBuilderMode);
         });
         BSUIDataManager.Subscribe("ShipBuilderHelpList",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            PopulateButtonBar(_loc2_.aHelpList);
         });
         BSUIDataManager.Subscribe("FlightCheckData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            var _loc3_:* = _loc2_.bShowMessages || _loc2_.bShowWeapons;
            if(_loc3_)
            {
               FlightCheck_mc.UpdateFlightCheck(_loc2_);
            }
            SetFlightCheckVisible(_loc3_);
         });
         BSUIDataManager.Subscribe("SystemUpgradeData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            var _loc3_:* = _loc2_.bShowUpgrades;
            if(_loc3_)
            {
               SystemUpgrade_mc.SetUpgradeableSystems(_loc2_.aSystemEntries,_loc2_.uSelectedSystem);
            }
            SetSystemUpgradeVisible(_loc3_);
         });
         BSUIDataManager.Subscribe("ColorInitializationData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            if(_loc2_.bVisible)
            {
               ColorPicker_mc.Show(_loc2_);
            }
            SetColorPickerVisible(_loc2_.bVisible);
         });
         BSUIDataManager.Subscribe("ShipStats",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            ShipStatsFooter_mc.UpdateValues(_loc2_);
            ReactorStats_mc.SetTitle("$REACTOR");
            ReactorStats_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iReactorPower),_loc2_.iReactorPowerDiff);
            ReactorStats_mc.SetStatType(_loc2_.iReactorClass);
            var _loc3_:Number = _loc2_.iWeaponPower + _loc2_.iEnginePower + _loc2_.iShieldPower;
            var _loc4_:Number = _loc2_.iWeaponPowerDiff + _loc2_.iEnginePowerDiff + _loc2_.iShieldPowerDiff;
            EquipmentStat_mc.SetTitle("$EQUIP POWER");
            EquipmentStat_mc.SetValue(GlobalFunc.FormatNumberToString(_loc3_),_loc4_);
            EquipmentStat_mc.SetStatType(-1);
         });
         BSUIDataManager.Subscribe("NotificationBadgeData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            if(_loc2_.bShowWidget)
            {
               Notifications_mc.UpdateValues(_loc2_);
            }
            Notifications_mc.visible = _loc2_.bShowWidget;
         });
         BSUIDataManager.Subscribe("ExitConfirmationData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            if(_loc2_.bShowExitConfirmation)
            {
               ExitConfirmation_mc.UpdateValues(_loc2_);
            }
            ExitConfirmation_mc.visible = _loc2_.bShowExitConfirmation;
            ButtonBar_mc.visible = !_loc2_.bShowExitConfirmation;
         });
         BSUIDataManager.Subscribe("ShipHangarModuleInfoData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:Object = param1.data;
            ContentBackground.visible = !_loc2_.bShowWidget;
         });
         BSUIDataManager.Subscribe("RepairButtonData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            var _loc3_:TextField = new TextField();
            GlobalFunc.SetText(_loc3_,"$REPAIR");
            RepairButtonHintData.bEnabled = _loc2_.uRepairKitQuantity > 0;
            RepairButtonHintData.sButtonText = _loc3_.text + " (" + _loc2_.uRepairKitQuantity + ")";
            SetupRepairMeter();
            SetHoldMeterVisible(_loc2_.bShowWidget);
         });
         this.SetHangarMenuVisible(false);
         stage.focus = null;
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.UpdateGamepadCrosshair();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.ShipRename_mc.visible)
         {
            _loc3_ = this.ShipRename_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.RepairMeter_mc.visible)
         {
            _loc3_ = this.RepairMeter_mc.HandleUserEvent(param1,param2,false);
         }
         if(!_loc3_ && this.ExitConfirmation_mc.visible)
         {
            _loc3_ = this.ExitConfirmation_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.FlightCheck_mc.visible)
         {
            _loc3_ = this.FlightCheck_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.SystemUpgrade_mc.visible)
         {
            _loc3_ = this.SystemUpgrade_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.PowerPanel.visible)
         {
            _loc3_ = this.PowerPanel.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && (param1 == "Cancel" || param1 == "Exit"))
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:uint) : Boolean
      {
         var _loc7_:Boolean = false;
         if(this.FlightCheck_mc.visible)
         {
            _loc7_ = this.FlightCheck_mc.OnLeftStickInput(param1,param2,param3,param4,param5,param6);
         }
         else if(!_loc7_ && this.ModulePalette_mc.visible)
         {
            _loc7_ = this.ModulePalette_mc.OnLeftStickInput(param1,param2,param3,param4,param5,param6);
         }
         else if(!_loc7_ && this.HangarInfoPanel_mc.visible)
         {
            _loc7_ = this.PowerPanel.OnLeftStickInput(param1,param2,param3,param4,param5,param6);
         }
         else if(!_loc7_ && this.SystemUpgrade_mc.visible)
         {
            _loc7_ = this.SystemUpgrade_mc.OnLeftStickInput(param1,param2,param3,param4,param5);
         }
         return _loc7_;
      }
      
      private function PopulateButtonBar(param1:Array) : void
      {
         var i:int;
         var hint:* = undefined;
         var ClickHoldButtonData:* = undefined;
         var ClickHoldButton:ReleaseHoldComboButton = null;
         var aHintData:Array = param1;
         if(this.BarButtons.length == 0)
         {
            for each(hint in aHintData)
            {
               if(hint.sHoldText != "")
               {
                  ClickHoldButtonData = new ReleaseHoldComboButtonData(hint.sText,hint.sHoldText,[new UserEventData(hint.sEvent,function():void
                  {
                     SendHintButtonClicked(hint.sEvent);
                  }),new UserEventData("",this[hint.sHoldCallback])]);
                  ClickHoldButton = ButtonFactory.AddToButtonBar("ReleaseHoldComboButton",ClickHoldButtonData,this.ButtonBar_mc) as ReleaseHoldComboButton;
                  this.BarButtons.push(ClickHoldButton);
               }
               else
               {
                  this.BarButtons.push(ButtonFactory.AddToButtonBar(this.EditorButtonName,new ButtonBaseData(hint.sText,[new UserEventData(hint.sEvent,null,hint.sEvent)]),this.ButtonBar_mc));
               }
            }
         }
         i = 0;
         while(i < this.BarButtons.length)
         {
            this.BarButtons[i].Enabled = aHintData[i].bDisplayed;
            this.BarButtons[i].Visible = aHintData[i].bDisplayed;
            i++;
         }
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function SetFlightCheckVisible(param1:Boolean) : void
      {
         this.FlightCheck_mc.visible = param1;
         if(param1)
         {
            this.ModulePalette_mc.visible = false;
            this.CostSummary_mc.visible = false;
         }
         else
         {
            this.CostSummary_mc.visible = this.StaticData.bVendorMode;
         }
      }
      
      private function SetModulePaletteVisible(param1:Boolean) : void
      {
         this.ModulePalette_mc.visible = param1;
         if(param1)
         {
            this.FlightCheck_mc.visible = false;
            this.CostSummary_mc.SetOffsetX(this.ModulePalette_mc.width);
         }
         else
         {
            this.CostSummary_mc.SetOffsetX(0);
         }
      }
      
      private function SetCostSummaryVisible(param1:Boolean) : void
      {
         this.CostSummary_mc.visible = param1;
         if(param1)
         {
            this.FlightCheck_mc.visible = false;
            this.ModulePalette_mc.visible = false;
            this.CostSummary_mc.SetOffsetX(0);
         }
      }
      
      private function SetColorPickerVisible(param1:Boolean) : void
      {
         this.ColorPicker_mc.visible = param1;
         if(param1)
         {
            this.CostSummary_mc.visible = false;
         }
         else
         {
            this.CostSummary_mc.visible = this.StaticData.bVendorMode;
         }
      }
      
      private function SetSystemUpgradeVisible(param1:Boolean) : void
      {
         this.SystemUpgrade_mc.visible = param1;
      }
      
      private function SetHangarMenuVisible(param1:Boolean) : void
      {
         this.HangarInfoPanel_mc.visible = param1;
         if(param1)
         {
            this.ButtonBar_mc.x = this.NoStatsMarker_mc.x;
            this.ButtonBar_mc.y = this.NoStatsMarker_mc.y;
         }
      }
      
      private function SetBuilderMenuVisible(param1:Boolean) : void
      {
         this.PowerAllocation_mc.visible = param1;
         this.ReactorStats_mc.visible = param1;
         this.EquipmentStat_mc.visible = param1;
         this.ShipStatsFooter_mc.visible = param1;
         this.StatFooterBar_mc.visible = param1;
         if(param1)
         {
            this.ButtonBar_mc.x = this.ShowingStatsMarker_mc.x;
            this.ButtonBar_mc.y = this.ShowingStatsMarker_mc.y;
         }
      }
      
      private function ShowWaitSpinner(param1:Boolean) : void
      {
         if(this.Background_mc.Solid_mc.visible && this.Spinner_mc.visible && !param1)
         {
            this.MenuBackgroundVisible = false;
         }
         this.Spinner_mc.visible = param1;
         this.Spinner_mc.gotoAndPlay(1);
      }
      
      private function SetupRepairMeter() : void
      {
         this.RepairMeter_mc.SetButtonData(this.RepairButtonHintData);
         this.RepairMeter_mc.RefreshButtonData();
      }
      
      private function SetHoldMeterVisible(param1:Boolean) : void
      {
         this.RepairMeter_mc.Visible = param1;
         this.RepairMeter_mc.alpha = param1 ? 1 : 0;
      }
      
      private function SendRepairEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event(HangarShipSelection_RepairShip));
      }
      
      private function UpdateGamepadCrosshair() : void
      {
         this.Crosshair_mc.visible = this.GamepadCrosshairEnabled && uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
      
      private function OnBuilderExitEvent() : void
      {
         gotoAndPlay("Close");
         GlobalFunc.StartGameRender();
      }
      
      private function SendHintButtonClicked(param1:String) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipEditor_OnHintButtonActivated,{"buttonAction":param1}));
      }
   }
}
