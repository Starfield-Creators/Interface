package
{
   import Components.BSButton;
   import Components.LabeledMeterMC;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class StatusMenu extends IMenu
   {
      
      public static const STAT_CATEGORY_EFFECTS:uint = EnumHelper.GetEnum(0);
      
      public static const STAT_CATEGORY_CHARACTER:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_GENERAL:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_EXPLORATION:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_SHIP:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_QUEST:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_COMBAT:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_CRAFTING:uint = EnumHelper.GetEnum();
      
      public static const STAT_CATEGORY_CRIME:uint = EnumHelper.GetEnum();
       
      
      public var Internal_mc:MovieClip;
      
      public var LeftSideBar_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CategoryList_mc:BSScrollingContainer;
      
      public var LevelIcon_mc:MovieClip;
      
      public var PlayerName_mc:MovieClip;
      
      public var PlayerLevel_mc:MovieClip;
      
      public var HealthMeter_mc:MovieClip;
      
      public var XPMeter_mc:LabeledMeterMC;
      
      public var DamageResistance_mc:MovieClip;
      
      public var RightScrollList_mc:StatusMenuScrollList;
      
      private var StatusData:Object;
      
      private var IsInitialSelection:Boolean = true;
      
      private var ButtonBarRefreshTimer:Timer = null;
      
      private var ReturningToGameplay:Boolean = false;
      
      private const LEFT_SCROLL_POSITIONS:Point = new Point(0,560);
      
      private const RIGHT_SCROLL_POSITIONS:Point = new Point(0,560);
      
      private const LEFT_SIDE_MOUSE_WHEEL_THRESHOLDS:Point = new Point(0,600);
      
      private const RIGHT_SIDE_MOUSE_WHEEL_THRESHOLDS:Point = new Point(1363.65,1920);
      
      private const PANEL_TOP_POSITION:Point = new Point(269.25,63.7);
      
      private const PANEL_STARTING_POSITION:Point = new Point(270.25,58.7);
      
      private const MODULAR_ITEM_STARTING_POSITION:Point = new Point(110,1408.95);
      
      private const MODIFIER_HEIGHT:Number = 56.65;
      
      private const LEVEL_ICON_SCALE:Number = 0.6;
      
      public function StatusMenu()
      {
         super();
         Extensions.enabled = true;
         this.LevelIcon_mc = this.Internal_mc.LevelIcon_mc;
         this.PlayerName_mc = this.Internal_mc.PlayerName_mc;
         this.PlayerLevel_mc = this.Internal_mc.PlayerLevel_mc;
         this.HealthMeter_mc = this.Internal_mc.HealthMeter_mc;
         this.XPMeter_mc = this.Internal_mc.XPMeter_mc;
         this.RightScrollList_mc = this.Internal_mc.RightScrollList_mc;
         this.ButtonBar_mc.visible = false;
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         var _loc1_:String = "$EXIT HOLD";
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.onExitMenu),new UserEventData("",this.onReturnToGameplay)]));
         this.ButtonBar_mc.AddButtonWithData(this.ScrollButton,new ButtonBaseData("$SCROLL",new UserEventData("RightStick",null),true,false));
         this.ButtonBar_mc.RefreshButtons();
         this.ButtonBarRefreshTimer = new Timer(60,1);
         this.ButtonBarRefreshTimer.addEventListener(TimerEvent.TIMER,this.handleButtonBarRefreshTimer);
         this.ButtonBarRefreshTimer.start();
         this.LeftSideBar_mc.UniversalBackButton_mc.addEventListener(BSButton.BUTTON_CLICKED_EVENT,this.onExitMenu);
         var _loc2_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc2_.VerticalSpacing = 5;
         _loc2_.EntryClassName = "StatCategoryEntry";
         _loc2_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.CategoryList_mc.Configure(_loc2_);
         this.CategoryList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnCategoryChange);
         TextFieldEx.setTextAutoSize(this.PlayerName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.PlayerLevel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get ScrollButton() : IButton
      {
         return this.ButtonBar_mc.ScrollButton_mc;
      }
      
      public function get PlayerName_tf() : TextField
      {
         return this.PlayerName_mc.Text_tf;
      }
      
      public function get PlayerLevel_tf() : TextField
      {
         return this.PlayerLevel_mc.Text_tf;
      }
      
      private function handleButtonBarRefreshTimer(param1:TimerEvent) : *
      {
         this.ButtonBar_mc.visible = true;
         this.ButtonBarRefreshTimer = null;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("PlayerStatusData",this.OnReceivedPayloadData);
         BSUIDataManager.Subscribe("PlayerData",this.OnPlayerDataUpdate);
         BSUIDataManager.Subscribe("PlayerFrequentData",this.OnPlayerFrequentDataUpdate);
         this.RightScrollList_mc.IsLeftSidePanel = false;
         this.RightScrollList_mc.PanelTopPosition = this.PANEL_TOP_POSITION.y;
         this.RightScrollList_mc.PanelStartingPosition = this.PANEL_STARTING_POSITION.y;
         this.RightScrollList_mc.ModularItemStartingPosition = this.MODULAR_ITEM_STARTING_POSITION.y;
         this.RightScrollList_mc.ScrollBoundPositions = this.RIGHT_SCROLL_POSITIONS;
         this.RightScrollList_mc.MouseWheelThresholds = this.RIGHT_SIDE_MOUSE_WHEEL_THRESHOLDS;
         this.RightScrollList_mc.CheckScrollBar();
         this.XPMeter_mc.SetLabel("");
         this.XPMeter_mc.Max_tf.textColor = 7368817;
         this.XPMeter_mc.scaleX = 0.8;
         this.XPMeter_mc.scaleY = 0.8;
      }
      
      private function OnCategoryChange() : void
      {
         var addEffectGroup:Function = null;
         var effectGroup:Object = null;
         var backgroundPerk:Object = null;
         var trait:Object = null;
         if(!this.IsInitialSelection)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         }
         else
         {
            this.IsInitialSelection = false;
         }
         this.RightScrollList_mc.ClearList();
         switch(this.CategoryList_mc.selectedEntry.uCategory)
         {
            case STAT_CATEGORY_EFFECTS:
               if(this.StatusData.aEffectGroups.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$STATUS_EFFECTS");
                  this.RightScrollList_mc.AddDivider();
                  addEffectGroup = function(param1:Object):void
                  {
                     var _loc3_:Object = null;
                     var _loc4_:* = undefined;
                     var _loc5_:* = undefined;
                     var _loc6_:* = false;
                     RightScrollList_mc.AddEffectGroupHeader(param1);
                     var _loc2_:uint = 0;
                     while(_loc2_ < param1.aEffects.length)
                     {
                        _loc3_ = param1.aEffects[_loc2_];
                        _loc4_ = !_loc3_.bHideName && _loc3_.sName.length > 0;
                        _loc5_ = _loc3_.sDescription.length > 0;
                        if(_loc4_ || _loc5_)
                        {
                           _loc6_ = _loc2_ == param1.aEffects.length - 1;
                           RightScrollList_mc.AddActiveEffect(_loc3_,!_loc6_);
                        }
                        _loc2_++;
                     }
                     RightScrollList_mc.AddDivider();
                  };
                  for each(effectGroup in this.StatusData.aEffectGroups)
                  {
                     if(effectGroup.bHasAfflictions)
                     {
                        addEffectGroup(effectGroup);
                     }
                  }
                  for each(effectGroup in this.StatusData.aEffectGroups)
                  {
                     if(!effectGroup.bHasAfflictions)
                     {
                        addEffectGroup(effectGroup);
                     }
                  }
               }
               break;
            case STAT_CATEGORY_CHARACTER:
               this.RightScrollList_mc.AddHeader("$DAMAGE RESISTANCES");
               this.RightScrollList_mc.AddDivider();
               this.RightScrollList_mc.AddDamageResistances(this.StatusData.DamageResistanceStats);
               this.RightScrollList_mc.AddDivider();
               if(this.StatusData.aBackgroundPerks.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$BACKGROUND");
                  this.RightScrollList_mc.AddDivider();
                  for each(backgroundPerk in this.StatusData.aBackgroundPerks)
                  {
                     this.RightScrollList_mc.AddTrait(backgroundPerk);
                  }
                  this.RightScrollList_mc.AddDivider();
               }
               if(this.StatusData.aTraits.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$TRAITSHEADER");
                  this.RightScrollList_mc.AddDivider();
                  for each(trait in this.StatusData.aTraits)
                  {
                     this.RightScrollList_mc.AddTrait(trait);
                  }
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_GENERAL:
               if(this.StatusData.aGeneralInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$GENERAL");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aGeneralInfo);
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_EXPLORATION:
               if(this.StatusData.aExplorationInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$EXPLORATION");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aExplorationInfo);
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_COMBAT:
               if(this.StatusData.aCombatInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$COMBAT");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aCombatInfo);
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_CRAFTING:
               if(this.StatusData.aCraftingInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$CRAFTING");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aCraftingInfo);
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_QUEST:
               if(this.StatusData.aQuestInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$QUEST");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aQuestInfo);
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_SHIP:
               if(this.StatusData.aShipInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$SHIP");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aShipInfo);
                  this.RightScrollList_mc.AddDivider();
               }
               break;
            case STAT_CATEGORY_CRIME:
               if(this.StatusData.aCrimeInfo.length > 0)
               {
                  this.RightScrollList_mc.AddHeader("$CRIME");
                  this.RightScrollList_mc.AddDivider();
                  this.RightScrollList_mc.AddMiscEntries(this.StatusData.aCrimeInfo);
                  this.RightScrollList_mc.AddDivider();
               }
         }
         this.RightScrollList_mc.CheckScrollBar();
      }
      
      private function OnReceivedPayloadData(param1:FromClientDataEvent) : void
      {
         if(param1.data)
         {
            this.StatusData = param1.data;
            if(this.StatusData.aCategories)
            {
               this.CategoryList_mc.InitializeEntries(this.StatusData.aCategories);
               stage.focus = this.CategoryList_mc;
               this.CategoryList_mc.selectedIndex = 0;
            }
         }
      }
      
      private function OnPlayerDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         GlobalFunc.SetText(this.PlayerName_tf,_loc2_.sName);
         GlobalFunc.SetText(this.PlayerLevel_tf,"$$LEVEL " + _loc2_.uLevel);
         this.XPMeter_mc.SetCurrentValue(_loc2_.fLevelXP);
         this.XPMeter_mc.SetMaxValue(_loc2_.fNextLevelXP);
         this.LevelIcon_mc.Initialize(_loc2_.uLevel,false,this.LEVEL_ICON_SCALE);
      }
      
      private function OnPlayerFrequentDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.HealthMeter_mc.gotoAndStop(GlobalFunc.MapLinearlyToRange(1,this.HealthMeter_mc.totalFrames,0,_loc2_.fMaxHealth,_loc2_.fHealth,true));
         GlobalFunc.SetText(this.HealthMeter_mc.HPAmount_tf,String(GlobalFunc.RoundDecimal(_loc2_.fHealth,0)) + "/" + String(GlobalFunc.RoundDecimal(_loc2_.fMaxHealth,0)));
      }
      
      private function onExitMenu() : void
      {
         gotoAndPlay("off");
      }
      
      private function onReturnToGameplay() : void
      {
         GlobalFunc.StartGameRender();
         this.ReturningToGameplay = true;
         gotoAndPlay("off");
      }
      
      private function OnCloseMenuFadeOutComplete() : *
      {
         if(this.ReturningToGameplay)
         {
            GlobalFunc.CloseAllMenus();
         }
         else
         {
            GlobalFunc.CloseMenu("StatusMenu");
         }
      }
      
      public function OnRightStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : *
      {
         this.RightScrollList_mc.onStickDataChanged(param2);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.RightScrollList_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
   }
}
