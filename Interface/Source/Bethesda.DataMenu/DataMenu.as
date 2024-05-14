package
{
   import Components.ImageFixture;
   import Components.LabeledMeterColorConfig;
   import Components.LabeledMeterMC;
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.QuestUtils;
   import Shared.ShipInfoUtils;
   import Shared.SkillsUtils;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DataMenu extends IMenu
   {
      
      public static const STATE_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const STATE_ATTRIBUTES:uint = EnumHelper.GetEnum();
      
      public static const STATE_INVENTORY:uint = EnumHelper.GetEnum();
      
      public static const STATE_MAP:uint = EnumHelper.GetEnum();
      
      public static const STATE_SHIP:uint = EnumHelper.GetEnum();
      
      public static const STATE_HANGAR:uint = EnumHelper.GetEnum();
      
      public static const STATE_MISSIONS:uint = EnumHelper.GetEnum();
      
      public static const STATE_STATUS:uint = EnumHelper.GetEnum();
      
      public static const STATE_POWERS:uint = EnumHelper.GetEnum();
      
      private static const PERSONAL_EFFECT_ICON_X_OFFSET:int = -6;
      
      private static const PERSONAL_EFFECT_ICON_Y_OFFSET:int = -11;
      
      private static const PERSONAL_EFFECT_ICON_X_STEP:uint = 34;
      
      private static const PERSONAL_EFFECT_ICON_SCALE:Number = 0.9;
      
      private static const ENVIRONMENT_EFFECT_ICON_X_OFFSET:int = 8;
      
      private static const ENVIRONMENT_EFFECT_ICON_Y_OFFSET:int = 0;
      
      private static const ENVIRONMENT_EFFECT_ICON_X_STEP:uint = 37;
      
      private static const ENVIRONMENT_EFFECT_ICON_SCALE:Number = 0.65;
      
      private static const POWER_ICON_SCALE:Number = 0.104;
      
      private static const POWER_ICON_SCALE_LARGE:Number = 0.18;
      
      public static const DEFAULT_NORMAL:uint = 15592941;
      
      public static const DEFAULT_DELTA_POS:uint = 2794425;
      
      public static const DEFAULT_DELTA_NEG:uint = 15146019;
      
      public static const DEFAULT_BACKGROUND:uint = 16777215;
      
      internal static const PATCH_SCALE:Number = 0.35;
      
      internal static const LEVEL_ICON_SCALE:Number = 0.7;
      
      internal static const BUFFER:uint = 45;
      
      private static const PaperDollFadeInDelay:uint = 200;
      
      public static const CONFIG_DEFAULT_DELTA:LabeledMeterColorConfig = new LabeledMeterColorConfig(DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_DELTA_POS,DEFAULT_DELTA_NEG,DEFAULT_DELTA_POS,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_NORMAL,DEFAULT_BACKGROUND);
       
      
      public var Mission_mc:MovieClip;
      
      public var Power_mc:MovieClip;
      
      public var Inventory_mc:MovieClip;
      
      public var Ship_mc:MovieClip;
      
      public var Skill_mc:MovieClip;
      
      public var Map_mc:MovieClip;
      
      public var PlaceHolder_Power:MovieClip;
      
      public var PowerIconHolder_mc:MovieClip;
      
      public var titlePower_mc:MovieClip;
      
      public var titleMission_mc:MovieClip;
      
      public var Inventory_Meter1:MovieClip;
      
      public var PlaceHolder_Weapon:MovieClip;
      
      public var Notification_Inventory:MovieClip;
      
      public var SubMenu_Divider:MovieClip;
      
      public var ShipSubMenu_Divider:MovieClip;
      
      public var SkillsSubMenu_Divider:MovieClip;
      
      public var titleInventory_mc:MovieClip;
      
      public var Skill_Meter1:MovieClip;
      
      public var PlaceHolder_Skill:ImageFixture;
      
      public var titlePoints_mc:MovieClip;
      
      public var SkillPointCount_mc:MovieClip;
      
      public var SkillsSubMenu_Divider2:MovieClip;
      
      public var CombatPatchHighlight_mc:MovieClip;
      
      public var SciencePatchHighlight_mc:MovieClip;
      
      public var TechPatchHighlight_mc:MovieClip;
      
      public var PhysicalPatchHighlight_mc:MovieClip;
      
      public var SocialPatchHighlight_mc:MovieClip;
      
      public var ConstellationIcon_mc:MovieClip;
      
      public var titleSkill_mc:MovieClip;
      
      public var Ship_Meter1:MovieClip;
      
      public var Ship_Meter2:MovieClip;
      
      public var PlaceHolder_Ship:MovieClip;
      
      public var Notification_Ship:MovieClip;
      
      public var titleShip_mc:MovieClip;
      
      public var SubMenu_Map_Sizer:MovieClip;
      
      public var Map_Meter1:MovieClip;
      
      public var TimeGST_mc:MovieClip;
      
      public var TimeLocal_mc:MovieClip;
      
      public var PlaceHolder_Planet:MovieClip;
      
      public var titleMap_mc:MovieClip;
      
      public var Player_Level_Icon:MovieClip;
      
      public var Player_Meter1:MovieClip;
      
      public var Player_Meter2:MovieClip;
      
      public var Player_Name_mc:MovieClip;
      
      public var Dot_Inventory:MovieClip;
      
      public var Dot_Ship:MovieClip;
      
      public var Dot_Skill:MovieClip;
      
      public var Dot_Power:MovieClip;
      
      public var Dot_Mission:MovieClip;
      
      public var Dot_Map:MovieClip;
      
      public var MissionButton_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var PowerClickRect_mc:MovieClip;
      
      public var SkillsClickRect_mc:MovieClip;
      
      public var InventoryClickRect_mc:MovieClip;
      
      public var MissionsClickRect_mc:MovieClip;
      
      public var ShipClickRect_mc:MovieClip;
      
      public var MapClickRect_mc:MovieClip;
      
      public var ObjTitle_mc:MovieClip;
      
      public var PlayerPaperDoll_mc:MovieClip;
      
      public var InventoryPreviewClipMask_mc:MovieClip;
      
      public var InventoryWeaponPreview_mc:MovieClip;
      
      public var ShipPreviewClipMask_mc:MovieClip;
      
      public var ShipPreview_mc:MovieClip;
      
      public var PlanetPreview_mc:MovieClip;
      
      public var FactionIcon_mc:MovieClip;
      
      public var MenuHighlight_mc:MovieClip;
      
      public var Animated3DReveal_mc:MovieClip;
      
      public var MenuHider_mc:MovieClip;
      
      public var PlayerEffectIconHolder_mc:MovieClip;
      
      public var FloatingStatusButtonBar_mc:ButtonBar;
      
      public var ShipLY_mc:MovieClip;
      
      public var ShipClass_mc:MovieClip;
      
      public var ShipCrew_mc:MovieClip;
      
      public var ClockWidget_mc:ClockWidget;
      
      private var SelectionAngles:Dictionary;
      
      private var CurrentState:uint;
      
      private var bHidden:Boolean = false;
      
      private var bInputEnabled:Boolean = true;
      
      private const LEFT_STICK_DEAD_ZONE:Number = 0.1;
      
      private const MOUSE_INPUT_IGNORE_HIGHLIGHT:Number = 320;
      
      private const HIGHLIGHT_ANGLE_OFFSET:Number = 40;
      
      private var LastSelectedSubMenu:uint;
      
      private var SkillPatchLoader:Loader = null;
      
      private var ShipAvailable:Boolean = false;
      
      private var PowersAvailable:Boolean = true;
      
      private var EnvironmentEffectIconsA:Array;
      
      private var PersonalEffectIconsA:Array;
      
      private var ButtonStats:IButton = null;
      
      private var ButtonMainMenu:IButton = null;
      
      private var ButtonPlotCourse:IButton = null;
      
      private var ButtonMainMenuShouldBeVisible:Boolean = true;
      
      private var QuestFaction:int;
      
      private var QuestType:int;
      
      private var FloatingStatusButtonShouldBeVisible:Boolean = false;
      
      private var PlotCourseEnabled:Boolean = false;
      
      private var PlotID:uint = 0;
      
      private var PaperDollFadeIn:Boolean = false;
      
      private var PaperDollFadeImmediate:Boolean = false;
      
      private var PaperDollFadeTimer:Timer;
      
      private var MenuHasBeenOpened:* = false;
      
      private var ClosingMenu:* = false;
      
      public function DataMenu()
      {
         this.ClockWidget_mc = new ClockWidget();
         this.SelectionAngles = new Dictionary();
         this.CurrentState = STATE_NONE;
         this.LastSelectedSubMenu = STATE_NONE;
         this.QuestFaction = FactionUtils.FACTION_NONE;
         this.QuestType = QuestUtils.MISC_QUEST_TYPE;
         this.PaperDollFadeTimer = new Timer(25,1);
         super();
         Extensions.enabled = true;
         this.EnvironmentEffectIconsA = new Array();
         this.PersonalEffectIconsA = new Array();
         this.ButtonBar_mc.Initialize(1,15);
         this.ButtonMainMenu = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SYSTEM",[new UserEventData("Pause",this.onPauseMenu)]),this.ButtonBar_mc);
         this.ButtonStats = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$STATUS",[new UserEventData("YButton",this.onStatusSubMenuSelected)]),this.ButtonBar_mc);
         this.ButtonPlotCourse = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SET COURSE",[new UserEventData("XButton",this.onPlotCourse)]),this.ButtonBar_mc);
         this.ButtonPlotCourse.Enabled = this.PlotCourseEnabled;
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBack,new ButtonBaseData("$BACK",[new UserEventData("Cancel",this.onExitMenu)]));
         this.FloatingStatusButtonBar_mc.AddButtonWithData(this.FloatingStatusButton,new ButtonBaseData("$STATUS",[new UserEventData("YButton",this.onStatusSubMenuSelected)]));
         this.FloatingStatusButton.Visible = false;
         this.ButtonStats.Visible = false;
         this.ButtonBar_mc.RefreshButtons();
         addEventListener("onCloseAnimComplete",this.onFullCloseAnimComplete);
         addEventListener("SetMenuPaperDollInactive",this.onSetMenuPaperDollInactive);
         addEventListener("onCloseShortAnimComplete",this.onCloseForSubMenuComplete);
         addEventListener("onOpenShortAnimComplete",this.onReopenComplete);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.PowerClickRect_mc.addEventListener(MouseEvent.ROLL_OVER,this.onPowersRollOn,false,0,true);
         this.PowerClickRect_mc.addEventListener(MouseEvent.ROLL_OUT,this.ClearLastSubMenuHighlight,false,0,true);
         this.PowerClickRect_mc.addEventListener(MouseEvent.CLICK,this.onPowersSubMenuSelected,false,0,true);
         this.SkillsClickRect_mc.addEventListener(MouseEvent.ROLL_OVER,this.onSkillsRollOn,false,0,true);
         this.SkillsClickRect_mc.addEventListener(MouseEvent.ROLL_OUT,this.ClearLastSubMenuHighlight,false,0,true);
         this.SkillsClickRect_mc.addEventListener(MouseEvent.CLICK,this.onAttributesSubMenuSelected,false,0,true);
         this.InventoryClickRect_mc.addEventListener(MouseEvent.ROLL_OVER,this.onInventoryRollOn,false,0,true);
         this.InventoryClickRect_mc.addEventListener(MouseEvent.ROLL_OUT,this.ClearLastSubMenuHighlight,false,0,true);
         this.InventoryClickRect_mc.addEventListener(MouseEvent.CLICK,this.onInventorySubMenuSelected,false,0,true);
         this.MissionsClickRect_mc.addEventListener(MouseEvent.ROLL_OVER,this.onMissionsRollOn,false,0,true);
         this.MissionsClickRect_mc.addEventListener(MouseEvent.ROLL_OUT,this.ClearLastSubMenuHighlight,false,0,true);
         this.MissionsClickRect_mc.addEventListener(MouseEvent.CLICK,this.onMissionsEvent,false,0,true);
         this.ShipClickRect_mc.addEventListener(MouseEvent.ROLL_OVER,this.onShipRollOn,false,0,true);
         this.ShipClickRect_mc.addEventListener(MouseEvent.ROLL_OUT,this.ClearLastSubMenuHighlight,false,0,true);
         this.ShipClickRect_mc.addEventListener(MouseEvent.CLICK,this.onShipSubMenuSelected,false,0,true);
         this.MapClickRect_mc.addEventListener(MouseEvent.ROLL_OVER,this.onMapRollOn,false,0,true);
         this.MapClickRect_mc.addEventListener(MouseEvent.ROLL_OUT,this.ClearLastSubMenuHighlight,false,0,true);
         this.MapClickRect_mc.addEventListener(MouseEvent.CLICK,this.onMapSubMenuSelected,false,0,true);
         this.SelectionAngles[STATE_POWERS] = [330,30];
         this.SelectionAngles[STATE_ATTRIBUTES] = [30,90];
         this.SelectionAngles[STATE_INVENTORY] = [90,150];
         this.SelectionAngles[STATE_MISSIONS] = [150,210];
         this.SelectionAngles[STATE_SHIP] = [210,270];
         this.SelectionAngles[STATE_MAP] = [270,330];
         this.Inventory_Meter1.SetLabel("$MASS");
         this.Inventory_Meter1.SetMaxValue(210);
         this.Inventory_Meter1.SetColorConfig(CONFIG_DEFAULT_DELTA);
         this.Inventory_Meter1.Max_tf.visible = true;
         this.Inventory_Meter1.Current_tf.visible = false;
         this.Inventory_Meter1.SetMaxTfVisible(true);
         this.Inventory_Meter1.SetLabelPrecision(0);
         this.Inventory_Meter1.SetMode(LabeledMeterMC.MODE_WEIGHT);
         this.Player_Meter1.Max_tf.visible = false;
         this.Player_Meter1.Current_tf.visible = false;
         this.Player_Meter2.SetLabel("$HEALTH");
         this.Player_Meter2.Max_tf.visible = false;
         this.Player_Meter2.Current_tf.visible = false;
         this.Skill_Meter1.SetLabel("$CERTIFICATION");
         this.Skill_Meter1.SetSuffix("%");
         this.Skill_Meter1.SetMaxValue(100);
         this.Skill_Meter1.Max_tf.visible = false;
         this.Skill_Meter1.SetColorConfig(CONFIG_DEFAULT_DELTA);
         var _loc1_:* = this.Skill_Meter1.Current_tf.getTextFormat();
         _loc1_.align = TextFormatAlign.RIGHT;
         this.Skill_Meter1.Current_tf.setTextFormat(_loc1_);
         this.Ship_Meter1.SetLabel("$HULL");
         this.Ship_Meter1.SetMaxValue(100);
         this.Ship_Meter1.SetSuffix("%");
         this.Ship_Meter1.Max_tf.visible = false;
         _loc1_ = this.Ship_Meter1.Current_tf.getTextFormat();
         _loc1_.align = TextFormatAlign.RIGHT;
         this.Ship_Meter1.Current_tf.setTextFormat(_loc1_);
         this.Ship_Meter2.visible = false;
         this.Map_Meter1.SetLabel("$SURVEYED");
         this.Map_Meter1.SetSuffix("%");
         this.Map_Meter1.SetMaxValue(100);
         this.Map_Meter1.Max_tf.visible = false;
         _loc1_ = this.Map_Meter1.Current_tf.getTextFormat();
         _loc1_.align = TextFormatAlign.RIGHT;
         this.Map_Meter1.Current_tf.setTextFormat(_loc1_);
         this.Map_Meter1.SetColorConfig(CONFIG_DEFAULT_DELTA);
         this.ClockWidget_mc.LocalTime_tf = this.TimeLocal_mc.Label_tf;
         this.ClockWidget_mc.GSTime_tf = this.TimeGST_mc.Label_tf;
         this.PlayerPaperDoll_mc.PlayerTextureHolder_mc.SetBackgroundColor(198154);
         BS3DSceneRectManager.Register3DSceneRect(this.PlayerPaperDoll_mc.PlayerTextureHolder_mc);
         this.InventoryWeaponPreview_mc.InventoryTextureHolder_mc.SetBackgroundColor(67504895);
         this.InventoryWeaponPreview_mc.InventoryTextureHolder_mc.SetMask(this.InventoryPreviewClipMask_mc);
         BS3DSceneRectManager.Register3DSceneRect(this.InventoryWeaponPreview_mc.InventoryTextureHolder_mc);
         this.MenuHider_mc.visible = true;
         this.PowerIconHolder_mc.Icon_mc.visible = false;
         this.PlaceHolder_Skill.centerClip = true;
         this.PlanetPreview_mc.PlanetTextureHolder_mc.SetBackgroundColor(67504895);
         BS3DSceneRectManager.Register3DSceneRect(this.PlanetPreview_mc.PlanetTextureHolder_mc);
         GlobalFunc.PlayMenuSound("UIMenuDashboardOpen");
         gotoAndStop("CloseShortAnimFast");
      }
      
      private function get InputEnabled() : Boolean
      {
         return this.bInputEnabled;
      }
      
      private function set InputEnabled(param1:Boolean) : void
      {
         this.bInputEnabled = param1;
      }
      
      private function get ButtonBack() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get FloatingStatusButton() : IButton
      {
         return this.FloatingStatusButtonBar_mc.FloatingStatusButton_mc;
      }
      
      private function onFireForgetEvent(param1:FromClientDataEvent) : void
      {
         if(!this.ClosingMenu && GlobalFunc.HasFireForgetEvent(param1.data,"DataMenu_Open"))
         {
            gotoAndPlay("Open");
            this.MenuHasBeenOpened = true;
         }
      }
      
      private function onSkillsRollOn() : *
      {
         this.SetSubMenuSelectionHighlight(STATE_ATTRIBUTES);
      }
      
      private function onAttributesSubMenuSelected() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SelectedAttributesMenu"));
         }
      }
      
      private function onInventoryRollOn() : *
      {
         this.SetSubMenuSelectionHighlight(STATE_INVENTORY);
      }
      
      private function onInventorySubMenuSelected() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SelectedInventoryMenu"));
         }
      }
      
      private function onMissionsRollOn() : *
      {
         this.SetSubMenuSelectionHighlight(STATE_MISSIONS);
      }
      
      private function onMissionsEvent() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_Missions",true));
         }
      }
      
      private function onShipRollOn() : *
      {
         this.SetSubMenuSelectionHighlight(STATE_SHIP);
      }
      
      private function onShipSubMenuSelected() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SelectedShipMenu"));
         }
      }
      
      private function onMapRollOn() : *
      {
         this.SetSubMenuSelectionHighlight(STATE_MAP);
      }
      
      private function onMapSubMenuSelected() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SelectedMapMenu"));
         }
      }
      
      private function onPowersRollOn() : *
      {
         this.SetSubMenuSelectionHighlight(STATE_POWERS);
      }
      
      private function onPowersSubMenuSelected() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SelectedPowersMenu"));
         }
      }
      
      private function onStatusSubMenuSelected() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_SelectedStatusMenu"));
         }
      }
      
      private function onPlotCourse() : void
      {
         if(this.PlotCourseEnabled)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("DataMenu_PlotToLocation",{"questID":this.PlotID}));
         }
         GlobalFunc.PlayMenuSound("UIMenuMissionsMenuShowOnMap");
      }
      
      private function onPauseMenu() : void
      {
         if(this.InputEnabled)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_OpenPauseMenu"));
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("DataMenuData",this.OnReceivedPayloadData);
         BSUIDataManager.Subscribe("PlayerData",this.OnPlayerDataUpdate);
         BSUIDataManager.Subscribe("PlayerFrequentData",this.OnPlayerFreqDataUpdate);
         BSUIDataManager.Subscribe("DataInventoryProvider",this.WeaponDisplayUpdate);
         BSUIDataManager.Subscribe("DataInventoryProvider",this.PowerDisplayUpdate);
         BSUIDataManager.Subscribe("QuestData",this.OnQuestDataUpdate);
         BSUIDataManager.Subscribe("PersonalEffectsData",this.OnPersonalEffectsDataUpdate);
         BSUIDataManager.Subscribe("EnvironmentEffectsData",this.OnEnvironmentEffectsDataUpdate);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFireForgetEvent);
         this.SkillPatchLoader = new Loader();
         var _loc1_:URLRequest = new URLRequest("SkillPatches.swf");
         var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.SkillPatchLoader.load(_loc1_,_loc2_);
         BSUIDataManager.Subscribe("DataMenuSkillsData",this.OnReceivedSkillData);
         this.PowerIconHolder_mc.Icon_mc.onLoadAttemptComplete = this.onPowerIconLoadAttemptComplete;
      }
      
      private function OnReceivedPayloadData(param1:FromClientDataEvent) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc2_:Object = param1.data;
         var _loc3_:Boolean = this.MenuHider_mc.visible;
         this.MenuHider_mc.visible = _loc2_.bMenuShouldBeHidden;
         if(_loc2_.uiSubMenuState != this.CurrentState)
         {
            _loc7_ = true;
            if(_loc2_.uiSubMenuState != STATE_NONE && !this.bHidden)
            {
               this.HideForSubMenu(_loc2_.bMenuShouldBeHidden);
            }
            else if(_loc2_.uiSubMenuState == STATE_NONE && this.bHidden)
            {
               this.Reopen();
            }
            this.Animated3DReveal_mc.Reveal_mc.visible = _loc2_.uiSubMenuState != STATE_STATUS && this.CurrentState != STATE_STATUS;
            this.CurrentState = _loc2_.uiSubMenuState;
         }
         this.Ship_Meter1.visible = param1.data.ShipAvailable;
         this.ShipPreview_mc.visible = param1.data.ShipAvailable;
         this.titleShip_mc.visible = param1.data.ShipAvailable;
         this.ShipSubMenu_Divider.visible = param1.data.ShipAvailable;
         var _loc4_:Number = _loc2_.fShipHealthPercent * 100;
         this.Ship_Meter1.SetCurrentValue(_loc4_);
         this.Ship_Meter1.SetHealthGainPercent(_loc2_.fShipHealPercent);
         this.Ship_Meter1.Current_tf.x = this.Ship_Meter1.Max_tf.x - BUFFER;
         this.Ship_Meter1.Current_tf.y = this.Ship_Meter1.Max_tf.y;
         TextFieldEx.setVerticalAlign(this.titleShip_mc.Label_tf,TextFieldEx.VALIGN_BOTTOM);
         GlobalFunc.SetText(this.titleShip_mc.Label_tf,_loc2_.sPlayerShipName);
         this.ShipClass_mc.visible = param1.data.ShipAvailable;
         this.ShipCrew_mc.visible = param1.data.ShipAvailable;
         this.ShipLY_mc.visible = param1.data.ShipAvailable;
         if(param1.data.ShipAvailable)
         {
            _loc8_ = "";
            switch(_loc2_.iPowerClass)
            {
               case ShipInfoUtils.REACTOR_M:
                  _loc8_ = "$ShipPower_M";
                  break;
               case ShipInfoUtils.REACTOR_C:
                  _loc8_ = "$ShipPower_C";
                  break;
               case ShipInfoUtils.REACTOR_B:
                  _loc8_ = "$ShipPower_B";
                  break;
               case ShipInfoUtils.REACTOR_A:
               default:
                  _loc8_ = "$ShipPower_A";
            }
            GlobalFunc.SetText(this.ShipClass_mc.Label_tf,"$CLASS");
            GlobalFunc.SetText(this.ShipClass_mc.Label_tf,this.ShipClass_mc.Label_tf.text + " " + _loc8_);
            GlobalFunc.SetText(this.ShipCrew_mc.Label_tf,"$CREW");
            GlobalFunc.SetText(this.ShipCrew_mc.Label_tf,this.ShipCrew_mc.Label_tf.text + " " + _loc2_.iCrew);
            GlobalFunc.SetText(this.ShipLY_mc.Label_tf,"$LY");
            GlobalFunc.SetText(this.ShipLY_mc.Label_tf,_loc2_.iJumpRange + " " + this.ShipLY_mc.Label_tf.text);
         }
         var _loc5_:String = "";
         if(_loc2_.sPlayerLocationName != _loc2_.CurrentSystemBodyInfo.focusedCelestialBodyName)
         {
            _loc5_ = " - " + _loc2_.sPlayerLocationName;
         }
         TextFieldEx.setVerticalAlign(this.titleMap_mc.Label_tf,TextFieldEx.VALIGN_BOTTOM);
         GlobalFunc.SetText(this.titleMap_mc.Label_tf,_loc2_.CurrentSystemBodyInfo.focusedCelestialBodyName + _loc5_);
         this.Map_Meter1.visible = _loc2_.fSurveyPercent > 0;
         var _loc6_:Number = _loc2_.fSurveyPercent * 100;
         this.Map_Meter1.SetCurrentValue(_loc6_);
         this.Map_Meter1.Current_tf.x = this.Map_Meter1.Max_tf.x - BUFFER;
         this.Map_Meter1.Current_tf.y = this.Map_Meter1.Max_tf.y;
         this.PowersAvailable = param1.data.PowersAvailable;
         this.ShipAvailable = param1.data.ShipAvailable;
         this.Dot_Power.visible = this.PowersAvailable && !this.PowerIconHolder_mc.Icon_mc.visible;
      }
      
      private function UpdateEffects() : void
      {
         var _loc1_:Dictionary = new Dictionary();
         this.PlayerEffectIconHolder_mc.removeChildren();
         var _loc2_:* = 0;
         var _loc3_:Number = 0;
         _loc2_ = 0;
         while(_loc2_ < this.PersonalEffectIconsA.length)
         {
            if(!_loc1_[this.PersonalEffectIconsA[_loc2_]])
            {
               _loc3_ = this.AttachPersonalEffectIcon(this.PersonalEffectIconsA[_loc2_] as String,_loc3_);
               _loc1_[this.PersonalEffectIconsA[_loc2_]] = true;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.EnvironmentEffectIconsA.length)
         {
            if(!_loc1_[this.EnvironmentEffectIconsA[_loc2_]])
            {
               _loc3_ = this.AttachEnvironmentEffectIcon(this.EnvironmentEffectIconsA[_loc2_] as String,_loc3_);
               _loc1_[this.EnvironmentEffectIconsA[_loc2_]] = true;
            }
            _loc2_++;
         }
         this.FloatingStatusButtonShouldBeVisible = _loc3_ > 0;
         this.FloatingStatusButton.Visible = !this.bHidden && this.FloatingStatusButtonShouldBeVisible;
         this.FloatingStatusButtonBar_mc.RefreshButtons();
         this.ButtonStats.Visible = !this.bHidden && !this.FloatingStatusButtonShouldBeVisible;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function AttachPersonalEffectIcon(param1:String, param2:Number) : Number
      {
         var _loc3_:MovieClip = new BioCondition();
         if(_loc3_ != null)
         {
            _loc3_.scaleX = PERSONAL_EFFECT_ICON_SCALE;
            _loc3_.scaleY = PERSONAL_EFFECT_ICON_SCALE;
            _loc3_.x = param2 + PERSONAL_EFFECT_ICON_X_OFFSET;
            param2 += PERSONAL_EFFECT_ICON_X_STEP;
            _loc3_.y = PERSONAL_EFFECT_ICON_Y_OFFSET;
            this.PlayerEffectIconHolder_mc.addChild(_loc3_);
            _loc3_.gotoAndStop(param1);
         }
         return param2;
      }
      
      private function AttachEnvironmentEffectIcon(param1:String, param2:Number) : Number
      {
         var _loc3_:MovieClip = new envAlertIcon();
         if(_loc3_ != null)
         {
            _loc3_.scaleX = ENVIRONMENT_EFFECT_ICON_SCALE;
            _loc3_.scaleY = ENVIRONMENT_EFFECT_ICON_SCALE;
            _loc3_.x = param2 + ENVIRONMENT_EFFECT_ICON_X_OFFSET;
            param2 += ENVIRONMENT_EFFECT_ICON_X_STEP;
            _loc3_.y = ENVIRONMENT_EFFECT_ICON_Y_OFFSET;
            this.PlayerEffectIconHolder_mc.addChild(_loc3_);
            _loc3_.gotoAndStop(param1);
         }
         return param2;
      }
      
      private function OnPlayerDataUpdate(param1:FromClientDataEvent) : void
      {
         TextFieldEx.setVerticalAlign(this.Player_Name_mc.Label_tf,TextFieldEx.VALIGN_BOTTOM);
         GlobalFunc.SetText(this.Player_Name_mc.Label_tf,param1.data.sName);
         this.Player_Meter1.SetLabel("$LEVEL");
         this.Player_Meter1.SetLabel(this.Player_Meter1.NameLabel_tf.text + " " + param1.data.uLevel);
         this.Player_Meter1.SetMaxValue(param1.data.fNextLevelXP);
         this.Player_Meter1.SetCurrentValue(param1.data.fLevelXP);
         this.Inventory_Meter1.SetMaxValue(param1.data.fMaxEncumbrance);
         this.Inventory_Meter1.SetCurrentValue(param1.data.fEncumbrance);
         this.Player_Level_Icon.Initialize(param1.data.uLevel,false,LEVEL_ICON_SCALE);
         GlobalFunc.SetText(this.SkillPointCount_mc.Label_tf,param1.data.uSkillPoints);
      }
      
      private function OnPlayerFreqDataUpdate(param1:FromClientDataEvent) : void
      {
         this.Player_Meter2.SetMaxValue(param1.data.fMaxHealth);
         this.Player_Meter2.SetCurrentValue(param1.data.fHealth);
         this.Player_Meter2.SetCurrentDamage(param1.data.fHealthBarDamage);
         this.Player_Meter2.SetHealthGainPercent(param1.data.fHealthGainPct);
      }
      
      private function OnQuestDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc11_:RegExp = null;
         var _loc2_:Array = param1.data.aQuests;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if((_loc5_ = _loc2_[_loc4_]).bActive)
            {
               _loc6_ = 0;
               _loc8_ = 0;
               _loc9_ = false;
               _loc10_ = "";
               _loc8_ = 0;
               while(_loc8_ < _loc5_.aObjectives.length)
               {
                  _loc7_ = _loc5_.aObjectives[_loc8_];
                  if(_loc9_ && _loc7_.bORWithPrevious == false)
                  {
                     break;
                  }
                  if(_loc7_.bActive && !_loc7_.bComplete && !_loc7_.bFailed)
                  {
                     if(_loc9_)
                     {
                        _loc10_ += "\n" + _loc7_.sName;
                        break;
                     }
                     _loc10_ = String(_loc7_.sName);
                     _loc9_ = true;
                     this.PlotCourseEnabled = _loc7_.bCanShowOnMap;
                     this.PlotID = !!_loc7_.bIsMiscObjective ? uint(_loc7_.uOwnerQuestFormID) : uint(_loc5_.uID);
                     this.UpdateButtons();
                  }
                  _loc8_++;
               }
               _loc11_ = /\\n/gi;
               _loc10_ = _loc10_.replace(_loc11_,"");
               _loc3_ = true;
               GlobalFunc.SetText(this.titleMission_mc.Label_mc.Label_tf,_loc5_.sName);
               GlobalFunc.SetText(this.ObjTitle_mc.Label_tf,_loc10_);
               this.QuestFaction = _loc5_.iFaction;
               this.QuestType = _loc5_.iType;
               this.FactionIcon_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(_loc5_.iFaction,_loc5_.iType));
               this.FactionIcon_mc.visible = true;
               this.Dot_Mission.visible = false;
            }
            _loc4_++;
         }
         if(!_loc3_)
         {
            this.QuestFaction = FactionUtils.FACTION_NONE;
            this.QuestType = QuestUtils.MISC_QUEST_TYPE;
            GlobalFunc.SetText(this.titleMission_mc.Label_mc.Label_tf,"");
            GlobalFunc.SetText(this.ObjTitle_mc.Label_tf,"");
            this.FactionIcon_mc.visible = false;
            this.Dot_Mission.visible = true;
            this.PlotCourseEnabled = false;
         }
      }
      
      private function OnPersonalEffectsDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc3_:* = false;
         var _loc4_:* = undefined;
         this.PersonalEffectIconsA.length = 0;
         var _loc2_:* = 0;
         while(_loc2_ < param1.data.aPersonalEffects.length)
         {
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < this.PersonalEffectIconsA.length && !_loc3_)
            {
               _loc3_ = this.PersonalEffectIconsA == param1.data.aPersonalEffects[_loc2_].sEffectIcon;
               _loc4_++;
            }
            if(!_loc3_)
            {
               this.PersonalEffectIconsA.push(param1.data.aPersonalEffects[_loc2_].sEffectIcon);
            }
            _loc2_++;
         }
         this.UpdateEffects();
      }
      
      private function OnEnvironmentEffectsDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc3_:Object = null;
         var _loc4_:* = false;
         var _loc5_:* = undefined;
         this.EnvironmentEffectIconsA.length = 0;
         var _loc2_:* = 0;
         while(_loc2_ < param1.data.aEnvironmentEffects.length)
         {
            _loc3_ = new Object();
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < this.EnvironmentEffectIconsA.length && !_loc4_)
            {
               _loc4_ = this.EnvironmentEffectIconsA == param1.data.aEnvironmentEffects[_loc2_].sEffectIcon;
               _loc5_++;
            }
            if(!_loc4_)
            {
               this.EnvironmentEffectIconsA.push(param1.data.aEnvironmentEffects[_loc2_].sEffectIcon);
            }
            _loc2_++;
         }
         this.UpdateEffects();
      }
      
      private function OnReceivedSkillData(param1:FromClientDataEvent) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc2_:Object = param1.data;
         var _loc3_:uint = 0;
         if(_loc2_.uShowSkillIndex != uint.MAX_VALUE)
         {
            _loc3_ = uint(_loc2_.uShowSkillIndex);
         }
         var _loc4_:Boolean = false;
         while(_loc3_ < _loc2_.SkillsA.length)
         {
            if(_loc2_.SkillsA[_loc3_].uCategory > 0)
            {
               _loc4_ = true;
               break;
            }
            _loc3_++;
         }
         this.CombatPatchHighlight_mc.visible = false;
         this.SciencePatchHighlight_mc.visible = false;
         this.TechPatchHighlight_mc.visible = false;
         this.PhysicalPatchHighlight_mc.visible = false;
         this.SocialPatchHighlight_mc.visible = false;
         this.ConstellationIcon_mc.visible = !_loc4_;
         this.Skill_Meter1.visible = _loc4_;
         this.titleSkill_mc.visible = _loc4_;
         this.SkillsSubMenu_Divider.visible = _loc4_;
         if(_loc4_)
         {
            _loc5_ = _loc2_.SkillsA[_loc3_];
            TextFieldEx.setVerticalAlign(this.titleSkill_mc.Label_tf,TextFieldEx.VALIGN_BOTTOM);
            GlobalFunc.SetText(this.titleSkill_mc.Label_tf,_loc5_.sSkillName);
            this.PlaceHolder_Skill.errorClassName = SkillsUtils.GetFullDefaultSkillPatchName(_loc5_.uCategory);
            this.PlaceHolder_Skill.LoadInternal(SkillsUtils.GetFullSkillPatchImageName(_loc5_.sSkillArtName,_loc5_.uPlayerSkillRank),"DataMenuIconBuffer");
            _loc6_ = Math.min(100,Math.round(_loc5_.fProgressPercent * 100));
            this.Skill_Meter1.SetCurrentValue(_loc6_);
            this.Skill_Meter1.Current_tf.x = this.Skill_Meter1.Max_tf.x - BUFFER;
            this.Skill_Meter1.Current_tf.y = this.Skill_Meter1.Max_tf.y;
            if(_loc5_.bCanRankUp)
            {
               switch(_loc5_.uCategory)
               {
                  case SkillsUtils.COMBAT:
                     this.CombatPatchHighlight_mc.visible = true;
                     this.CombatPatchHighlight_mc.gotoAndStop("Start");
                     break;
                  case SkillsUtils.SCIENCE:
                     this.SciencePatchHighlight_mc.visible = true;
                     this.SciencePatchHighlight_mc.gotoAndStop("Start");
                     break;
                  case SkillsUtils.TECH:
                     this.TechPatchHighlight_mc.visible = true;
                     this.TechPatchHighlight_mc.gotoAndStop("Start");
                     break;
                  case SkillsUtils.PHYSICAL:
                     this.PhysicalPatchHighlight_mc.visible = true;
                     this.PhysicalPatchHighlight_mc.gotoAndStop("Start");
                     break;
                  case SkillsUtils.SOCIAL:
                     this.SocialPatchHighlight_mc.visible = true;
                     this.SocialPatchHighlight_mc.gotoAndStop("Start");
               }
            }
         }
         else
         {
            this.PlaceHolder_Skill.Unload();
         }
      }
      
      private function RotateHighlight(param1:Vector3D) : *
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(this.bHidden)
         {
            this.MenuHighlight_mc.gotoAndStop(1);
         }
         else
         {
            param1.normalize();
            _loc2_ = new Vector3D(0,-1);
            _loc3_ = new Vector3D(1,0);
            _loc4_ = Math.acos(_loc2_.dotProduct(param1)) * (180 / Math.PI);
            if((_loc5_ = Math.acos(_loc3_.dotProduct(param1)) * (180 / Math.PI)) > 90)
            {
               _loc4_ = 360 - _loc4_;
            }
            if((_loc4_ -= this.HIGHLIGHT_ANGLE_OFFSET) < 0)
            {
               _loc4_ += 360;
            }
            _loc6_ = GlobalFunc.MapLinearlyToRange(1,81,0,360,_loc4_,true);
            this.MenuHighlight_mc.gotoAndStop(_loc6_);
         }
      }
      
      public function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Vector3D = new Vector3D(stage.mouseX - stage.stageWidth / 2,stage.mouseY - stage.stageHeight / 2);
         if(_loc2_.length > this.MOUSE_INPUT_IGNORE_HIGHLIGHT)
         {
            this.RotateHighlight(_loc2_);
         }
         else
         {
            this.MenuHighlight_mc.gotoAndStop(1);
         }
      }
      
      public function GetPatchLevelFrame(param1:uint) : String
      {
         switch(param1)
         {
            case 0:
               return "Rank_0";
            case 1:
               return "Rank_1";
            case 2:
               return "Rank_2";
            case 3:
               return "Rank_3";
            case 4:
               return "Rank_4";
            default:
               return "Rank_0";
         }
      }
      
      private function WeaponDisplayUpdate(param1:FromClientDataEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc2_:Object = param1.data.EquippedWeapon;
         if(_loc2_ == null || _loc2_.uFormID == 0 || _loc2_.uHandleID == uint.MAX_VALUE)
         {
            GlobalFunc.SetText(this.titleInventory_mc.Label_tf,"$NO_ITEM_EQUIPPED");
         }
         else
         {
            TextFieldEx.setVerticalAlign(this.titleInventory_mc.Label_tf,TextFieldEx.VALIGN_BOTTOM);
            GlobalFunc.SetText(this.titleInventory_mc.Label_tf,_loc2_.sName);
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.aElementalStats.length)
            {
               _loc3_ += _loc2_.aElementalStats[_loc4_].fValue;
               _loc4_++;
            }
            this.Notification_Inventory.gotoAndStop("None");
         }
      }
      
      private function PowerDisplayUpdate(param1:FromClientDataEvent) : void
      {
         GlobalFunc.SetText(this.titlePower_mc.Label_mc.Label_tf,param1.data.EquippedPowerName);
         var _loc2_:* = param1.data.EquippedPowerName.length != 0;
         if(_loc2_)
         {
            this.PowerIconHolder_mc.Icon_mc.LoadSymbol(param1.data.EquippedPowerImage,"PowersLibrary");
            this.Dot_Power.visible = false;
         }
         else
         {
            GlobalFunc.SetText(this.titlePower_mc.Label_mc.Label_tf,"");
            this.PowerIconHolder_mc.Icon_mc.visible = false;
            this.Dot_Power.visible = this.PowersAvailable;
         }
      }
      
      private function HideForSubMenu(param1:Boolean) : void
      {
         if(param1)
         {
            this.PlayDataMenuAnimation("CloseShortAnimFast");
         }
         else
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.PlayDataMenuAnimation("CloseShort");
         }
         this.ClearLastSubMenuHighlight();
         this.InputEnabled = false;
         this.bHidden = true;
         this.MenuHighlight_mc.gotoAndStop(1);
         this.ButtonMainMenuShouldBeVisible = false;
         this.UpdateButtons();
      }
      
      private function onCloseForSubMenuComplete(param1:Event) : void
      {
         BSUIDataManager.dispatchEvent(new Event("DataMenu_ClosedForSubMenu"));
      }
      
      private function Reopen() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         this.PlayDataMenuAnimation("OpenShort");
         BSUIDataManager.dispatchEvent(new Event("DataMenu_Reopened"));
         this.bHidden = false;
         this.ButtonMainMenuShouldBeVisible = true;
         this.ClearLastSubMenuHighlight();
         this.LastSelectedSubMenu = STATE_NONE;
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            if(this.PowerClickRect_mc.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.LastSelectedSubMenu = STATE_POWERS;
            }
            if(this.SkillsClickRect_mc.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.LastSelectedSubMenu = STATE_ATTRIBUTES;
            }
            if(this.InventoryClickRect_mc.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.LastSelectedSubMenu = STATE_INVENTORY;
            }
            if(this.MissionsClickRect_mc.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.LastSelectedSubMenu = STATE_MISSIONS;
            }
            if(this.ShipClickRect_mc.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.LastSelectedSubMenu = STATE_SHIP;
            }
            if(this.MapClickRect_mc.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.LastSelectedSubMenu = STATE_MAP;
            }
         }
         this.SetSubMenuSelectionHighlight(this.LastSelectedSubMenu,true);
         this.UpdateButtons();
      }
      
      private function onReopenComplete(param1:Event) : void
      {
         this.InputEnabled = true;
      }
      
      private function onExitMenu() : void
      {
         if(!this.ClosingMenu)
         {
            this.Animated3DReveal_mc.Reveal_mc.visible = true;
            this.PlayDataMenuAnimation("Close");
            this.ClosingMenu = true;
            GlobalFunc.StartGameRender();
            this.InputEnabled = false;
            GlobalFunc.PlayMenuSound("UIMenuDashboardClose");
         }
      }
      
      private function onFullCloseAnimComplete(param1:Event) : void
      {
         BSUIDataManager.dispatchEvent(new Event("DataMenu_CloseMenu"));
      }
      
      private function onOpenSubMenu() : *
      {
         switch(this.LastSelectedSubMenu)
         {
            case STATE_POWERS:
               if(this.PowersAvailable)
               {
                  this.onPowersSubMenuSelected();
               }
               break;
            case STATE_ATTRIBUTES:
               this.onAttributesSubMenuSelected();
               break;
            case STATE_INVENTORY:
               this.onInventorySubMenuSelected();
               break;
            case STATE_MISSIONS:
               this.onMissionsEvent();
               break;
            case STATE_SHIP:
               if(this.ShipAvailable)
               {
                  this.onShipSubMenuSelected();
               }
               break;
            case STATE_MAP:
               this.onMapSubMenuSelected();
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(!this.InputEnabled)
         {
            return false;
         }
         var _loc3_:Boolean = false;
         if(!_loc3_ && param1 == "Cancel")
         {
            this.onExitMenu();
            _loc3_ = true;
         }
         if(!_loc3_ && param1 == "Accept")
         {
            this.onOpenSubMenu();
            _loc3_ = true;
         }
         if(!_loc3_ && param1 == "YButton")
         {
            this.onStatusSubMenuSelected();
            _loc3_ = true;
         }
         if(!_loc3_ && param1 == "XButton")
         {
            this.onPlotCourse();
            _loc3_ = true;
         }
         if(!_loc3_ && param1 == "Pause")
         {
            this.onPauseMenu();
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function GetSubMenuClip(param1:uint) : MovieClip
      {
         switch(param1)
         {
            case STATE_POWERS:
               return this.Power_mc;
            case STATE_ATTRIBUTES:
               return this.Skill_mc;
            case STATE_INVENTORY:
               return this.Inventory_mc;
            case STATE_MISSIONS:
               return this.Mission_mc;
            case STATE_SHIP:
               return this.Ship_mc;
            case STATE_MAP:
               return this.Map_mc;
            default:
               return null;
         }
      }
      
      private function UpdateButtons() : *
      {
         this.ButtonStats.Visible = !this.bHidden && !this.FloatingStatusButtonShouldBeVisible;
         this.FloatingStatusButton.Visible = !this.bHidden && this.FloatingStatusButtonShouldBeVisible;
         this.ButtonBack.Visible = !this.bHidden;
         this.ButtonMainMenu.Visible = !this.bHidden && this.ButtonMainMenuShouldBeVisible;
         this.ButtonPlotCourse.Visible = !this.bHidden;
         this.ButtonPlotCourse.Enabled = this.PlotCourseEnabled;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function SetSubMenuSelectionHighlight(param1:uint, param2:Boolean = false) : *
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(param1 == STATE_POWERS && !this.PowersAvailable || param1 == STATE_SHIP && !this.ShipAvailable)
         {
            return;
         }
         if(this.InputEnabled || param2)
         {
            _loc3_ = this.GetSubMenuClip(param1);
            if(_loc3_)
            {
               if(param1 == STATE_MISSIONS)
               {
                  if(this.FactionIcon_mc.visible)
                  {
                     this.FactionIcon_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.QuestFaction,this.QuestType) + "Large");
                  }
                  this.titleMission_mc.gotoAndPlay("highlight");
               }
               else if(param1 == STATE_POWERS)
               {
                  this.setPowerIconScale(POWER_ICON_SCALE_LARGE);
                  this.titlePower_mc.gotoAndPlay("highlight");
               }
               _loc3_.gotoAndPlay("highlight");
               if(this.LastSelectedSubMenu != STATE_NONE && this.LastSelectedSubMenu != param1)
               {
                  if(_loc5_ = this.GetSubMenuClip(this.LastSelectedSubMenu))
                  {
                     if(this.LastSelectedSubMenu == STATE_MISSIONS && this.FactionIcon_mc.visible)
                     {
                        this.FactionIcon_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.QuestFaction,this.QuestType));
                     }
                     else if(this.LastSelectedSubMenu == STATE_POWERS)
                     {
                        this.setPowerIconScale(POWER_ICON_SCALE);
                     }
                     _loc5_.gotoAndStop("Default");
                  }
               }
            }
            GlobalFunc.PlayMenuSound("UIMenuDashboardFocusCircle");
            this.LastSelectedSubMenu = param1;
            this.UpdateButtons();
            if((_loc4_ = this.getDotForSubMenu(param1)) != null)
            {
               _loc4_.gotoAndStop("highlight");
            }
         }
      }
      
      private function ClearLastSubMenuHighlight() : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         if(this.InputEnabled && this.LastSelectedSubMenu != STATE_NONE)
         {
            _loc1_ = this.getDotForSubMenu(this.LastSelectedSubMenu);
            if(_loc1_ != null)
            {
               _loc1_.gotoAndStop("normal");
            }
            this.titlePower_mc.gotoAndStop("normal");
            this.titleMission_mc.gotoAndStop("normal");
            _loc2_ = this.GetSubMenuClip(this.LastSelectedSubMenu);
            if(this.LastSelectedSubMenu == STATE_MISSIONS && this.FactionIcon_mc.visible)
            {
               this.FactionIcon_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.QuestFaction,this.QuestType));
            }
            else if(this.LastSelectedSubMenu == STATE_POWERS)
            {
               if(this.PowerIconHolder_mc.Icon_mc.visible)
               {
                  this.setPowerIconScale(POWER_ICON_SCALE);
               }
            }
            _loc2_.gotoAndStop("Default");
            this.UpdateButtons();
         }
      }
      
      private function onSetMenuPaperDollInactive(param1:Event) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("DataMenu_SetPaperDollActive",{"bActive":false}));
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : Boolean
      {
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         if(!this.InputEnabled)
         {
            return false;
         }
         var _loc6_:Vector3D;
         if((_loc6_ = new Vector3D(param1,param2)).length > this.LEFT_STICK_DEAD_ZONE)
         {
            this.RotateHighlight(_loc6_);
            _loc6_.normalize();
            _loc7_ = new Vector3D(0,-1);
            _loc8_ = new Vector3D(1,0);
            _loc9_ = Math.acos(_loc7_.dotProduct(_loc6_)) * (180 / Math.PI);
            if((_loc10_ = Math.acos(_loc8_.dotProduct(_loc6_)) * (180 / Math.PI)) > 90)
            {
               _loc9_ = 360 - _loc9_;
            }
            _loc11_ = 0;
            while(_loc11_ <= STATE_POWERS)
            {
               _loc12_ = false;
               if(this.SelectionAngles[_loc11_] != null)
               {
                  if(_loc11_ != STATE_POWERS)
                  {
                     _loc12_ = _loc9_ > this.SelectionAngles[_loc11_][0] && _loc9_ <= this.SelectionAngles[_loc11_][1];
                  }
                  else
                  {
                     _loc12_ = _loc9_ > this.SelectionAngles[_loc11_][0] || _loc9_ <= this.SelectionAngles[_loc11_][1];
                  }
                  if(_loc12_)
                  {
                     if(_loc11_ != this.LastSelectedSubMenu)
                     {
                        this.SetSubMenuSelectionHighlight(_loc11_);
                     }
                  }
               }
               _loc11_++;
            }
            return true;
         }
         this.ClearLastSubMenuHighlight();
         this.LastSelectedSubMenu = STATE_NONE;
         this.MenuHighlight_mc.gotoAndStop(1);
         return false;
      }
      
      private function onPowerIconLoadAttemptComplete() : *
      {
         this.setPowerIconScale(POWER_ICON_SCALE);
         this.PowerIconHolder_mc.Icon_mc.visible = true;
      }
      
      private function setPowerIconScale(param1:Number) : *
      {
         this.PowerIconHolder_mc.Icon_mc.scaleX = param1;
         this.PowerIconHolder_mc.Icon_mc.scaleY = param1;
      }
      
      private function getDotForSubMenu(param1:uint) : *
      {
         switch(param1)
         {
            case STATE_INVENTORY:
               return this.Dot_Inventory;
            case STATE_MAP:
               return this.Dot_Map;
            case STATE_SHIP:
               return this.Dot_Ship;
            case STATE_MISSIONS:
               return this.Dot_Mission;
            case STATE_ATTRIBUTES:
               return this.Dot_Skill;
            case STATE_POWERS:
               return this.Dot_Power;
            default:
               return null;
         }
      }
      
      private function PlayDataMenuAnimation(param1:String) : *
      {
         if(this.ClosingMenu)
         {
            return;
         }
         this.PaperDollFadeTimer.reset();
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = true;
         switch(param1)
         {
            case "Open":
            case "OpenShort":
               this.PaperDollFadeTimer.delay = PaperDollFadeInDelay;
               this.PaperDollFadeIn = true;
               this.PaperDollFadeImmediate = false;
               _loc2_ = true;
               break;
            case "Close":
               this.PaperDollFadeTimer.delay = 25;
               this.PaperDollFadeIn = false;
               this.PaperDollFadeImmediate = false;
               _loc2_ = true;
               break;
            case "CloseShort":
               _loc3_ = this.MenuHasBeenOpened;
               if(!_loc3_)
               {
                  BSUIDataManager.dispatchEvent(new Event("DataMenu_ClosedForSubMenu"));
               }
               break;
            case "CloseShortAnimFast":
               this.PaperDollFadeTimer.delay = 25;
               this.PaperDollFadeIn = false;
               this.PaperDollFadeImmediate = true;
               _loc2_ = true;
         }
         if(_loc3_)
         {
            gotoAndPlay(param1);
         }
         if(_loc2_)
         {
            this.PaperDollFadeTimer.start();
         }
         this.PaperDollFadeTimer.addEventListener("timerComplete",this.DispatchDataMenuFade);
      }
      
      private function DispatchDataMenuFade() : *
      {
         this.PaperDollFadeTimer.stop();
         if(!this.PaperDollFadeIn && !this.PaperDollFadeImmediate)
         {
            BSUIDataManager.dispatchEvent(new Event("DataMenu_StartCloseAnim"));
         }
      }
   }
}
