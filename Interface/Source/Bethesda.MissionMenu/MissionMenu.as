package
{
   import Components.BSButton;
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSTabbedSelection;
   import Shared.AS3.BSTabbedSelectionEvent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Utils.ButtonKeyHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.QuestUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MissionMenu extends IMenu
   {
      
      public static const LERP_DELAY_TIME:Number = 0.2;
      
      public static const MISSION_ANIMATION_DELAY_TIME:Number = 0.25;
      
      public static const MISSION_FADE_IN_TIME:Number = 0.4;
      
      public static const OBJECTIVE_ANIMATION_DELAY_TIME:Number = 0.1;
      
      public static const OBJECTIVE_FADE_IN_TIME:Number = 0.4;
      
      public static const OBJECTIVE_LIST_OFFSET:Number = 300;
      
      public static const KEYBOARD_TAB_BUTTON_OFFSET:Number = 1.25;
      
      private static const SHOW_ITEM_LOCATION_EVENT:String = "MissionMenu_ShowItemLocation";
      
      private static const MissionMenu_PlotToLocation:String = "MissionMenu_PlotToLocation";
      
      private static const MissionMenu_ToggleTrackingQuest:String = "MissionMenu_ToggleTrackingQuest";
      
      private static const MissionMenu_RejectQuest:String = "MissionMenu_RejectQuest";
      
      private static const MissionMenu_SaveOpenedId:String = "MissionMenu_SaveOpenedId";
      
      private static const MissionMenu_SaveCategoryIndex:String = "MissionMenu_SaveCategoryIndex";
      
      private static const MissionMenu_ClearState:String = "MissionMenu_ClearState";
      
      public static const MissionMenu_OnExitMissionMenu:String = "MissionMenu_OnExitMissionMenu";
      
      protected static const TIMELINE_CLOSE_EVENT:String = "TimelineCloseEvent";
      
      public static const MISSION_SELECTION_CHANGE_SOUND:String = "UIMenuMissionsMenuSelectionChange";
      
      public static const MISSION_CATEGORY_CHANGE_SOUND:String = "UIMenuMissionsMenuCategoryChange";
      
      public static const MISSION_SUBTASK_TOGGLE_SOUND:String = "UIMenuMissionsMenuSubtasksToggle";
      
      public static const MISSION_TRACKING_TOGGLE_ON_SOUND:String = "UIMenuMissionsMenuTrackingToggleOn";
      
      public static const MISSION_TRACKING_TOGGLE_OFF_SOUND:String = "UIMenuMissionsMenuTrackingToggleOff";
      
      public static const MISSION_SHOW_ON_MAP_SOUND:String = "UIMenuMissionsMenuShowOnMap";
       
      
      public var UniversalBackButton_mc:BSButton;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var MissionsList_mc:MissionsList;
      
      public var MissionInfo_mc:MissionInfo;
      
      public var TabbedFilterSelection_mc:MissionTabbedSelection;
      
      public var Vignette_mc:MovieClip;
      
      public var PreviewSceneRect_mc:BSAnimating3DSceneRect;
      
      private var ButtonBarRefreshTimer:Timer = null;
      
      private var PreviousMissionIndex:int = -1;
      
      private var bClosing:Boolean = false;
      
      private var QuestData:Array = null;
      
      private var StoredLastOpenedIds:Array = null;
      
      private var StoredLastCategory:uint = 0;
      
      private var InitializedOpenedIds:Boolean = false;
      
      private var bReturningToGame:Boolean = false;
      
      private var FilterInfoA:Array;
      
      private var lastSelectedIndex:int = -1;
      
      private var bCollapsing:Boolean = false;
      
      private var bWithinMiscQuest:Boolean = false;
      
      private var miscQuestIndex:int = 0;
      
      private var scrollPositionAtTracking:int = -1;
      
      private var startingTabButtonYPosition:Number = 0;
      
      private var bWrappedAroundUp:Boolean = false;
      
      private var bSkipSelectionSounds:Boolean = false;
      
      private var KeyHelper:ButtonKeyHelper = null;
      
      private var bButtonBarInitialized:Boolean = false;
      
      private var canReject:Boolean = false;
      
      private var CanTrackOrUntrack:Boolean = false;
      
      private var ShowAllQTsBtnData:ButtonBaseData;
      
      private var ShowOnlyActiveQTsBtnData:ButtonBaseData;
      
      private var ToggleQTDisplayButton:IButton;
      
      private var ShowOnlyActiveQTs:Boolean = true;
      
      public function MissionMenu()
      {
         this.ShowAllQTsBtnData = new ButtonBaseData("$ToggleShowAllQTs",[new UserEventData("Select",this.ToggleQTDisplay)]);
         this.ShowOnlyActiveQTsBtnData = new ButtonBaseData("$ToggleShowOnlyActiveQTs",[new UserEventData("Select",this.ToggleQTDisplay)]);
         super();
         this.PreviewSceneRect_mc.SetBackgroundColor(67504895);
         BS3DSceneRectManager.Register3DSceneRect(this.PreviewSceneRect_mc);
         gotoAndPlay("Open");
         addEventListener(TIMELINE_CLOSE_EVENT,this.OnTimelineCloseEvent);
         this.ButtonBar_mc.visible = false;
         this.PopulateTabs();
         this.MissionsList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onMissionSelectionChange);
         addEventListener(MissionsList.ITEM_ACTIVATED,this.onMissionListItemActivated);
         this.UniversalBackButton_mc.addEventListener(BSButton.BUTTON_CLICKED_EVENT,this.OnCancelEvent);
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "MissionsListEntry";
         this.MissionsList_mc.Configure(_loc1_);
      }
      
      public function get currentFilterIndex() : int
      {
         return this.TabbedFilterSelection_mc.selectedIndex;
      }
      
      public function get currentFilterFlag() : int
      {
         return this.FilterInfoA[this.currentFilterIndex].flag;
      }
      
      private function get ShowOnMapButton() : IButton
      {
         return this.ButtonBar_mc.ShowOnMapButton_mc;
      }
      
      private function get PlotToLocationButton() : IButton
      {
         return this.ButtonBar_mc.PlotToLocationButton_mc;
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get RejectQuestButton() : IButton
      {
         return this.ButtonBar_mc.RejectButton_mc;
      }
      
      private function PopulateButtonBar() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(!this.bButtonBarInitialized)
         {
            _loc1_ = this.KeyHelper.GetButtonNameForEvent("XButton","");
            if(_loc1_.length != 0)
            {
               this.bButtonBarInitialized = true;
               this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
               this.ToggleQTDisplayButton = ButtonFactory.AddToButtonBar("BasicButton",this.ShowOnlyActiveQTs ? this.ShowAllQTsBtnData : this.ShowOnlyActiveQTsBtnData,this.ButtonBar_mc);
               this.ButtonBar_mc.AddButtonWithData(this.ShowOnMapButton,new ButtonBaseData("$SHOWONMAP",[new UserEventData("YButton",this.OnShowOnMapEvent)],false,true));
               this.ButtonBar_mc.AddButtonWithData(this.PlotToLocationButton,new ButtonBaseData("$SET COURSE",[new UserEventData("XButton",this.OnPlotCourseEvent)],false,true));
               this.RejectQuestButton.Visible = this.canReject;
               this.ButtonBar_mc.AddButtonWithData(this.RejectQuestButton,new ButtonBaseData("$REJECT",[new UserEventData("R3",this.OnRejectQuest)],true,this.canReject));
               _loc2_ = "$EXIT HOLD";
               this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",_loc2_,[new UserEventData("Cancel",this.OnCancelEvent),new UserEventData("",this.onCloseSubMenuToGame)]));
               (this.ShowOnMapButton as ButtonBase).RefreshButtonData();
               (this.PlotToLocationButton as ButtonBase).RefreshButtonData();
               (this.RejectQuestButton as ButtonBase).RefreshButtonData();
               (this.BackButton as ButtonBase).RefreshButtonData();
               this.ButtonBar_mc.RefreshButtons();
               this.ButtonBar_mc.redrawDisplayObject();
               this.ButtonBarRefreshTimer = new Timer(60,1);
               this.ButtonBarRefreshTimer.addEventListener(TimerEvent.TIMER,this.handleButtonBarRefreshTimer);
               this.ButtonBarRefreshTimer.start();
               this.onMissionSelectionChange();
            }
         }
      }
      
      private function handleButtonBarRefreshTimer(param1:TimerEvent) : *
      {
         this.ButtonBar_mc.visible = true;
         this.ButtonBarRefreshTimer = null;
      }
      
      private function UpdateRejectData(param1:Boolean) : void
      {
         if(param1 != this.canReject)
         {
            this.canReject = param1;
            this.RejectQuestButton.Visible = param1;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function PopulateTabs() : void
      {
         this.FilterInfoA = new Array();
         this.FilterInfoA.push({
            "text":"$ALL",
            "flag":4294967295
         });
         this.FilterInfoA.push({
            "text":"$Main",
            "flag":1 << QuestUtils.MAIN_QUEST_TYPE
         });
         this.FilterInfoA.push({
            "text":"$Faction",
            "flag":1 << QuestUtils.FACTION_QUEST_TYPE
         });
         this.FilterInfoA.push({
            "text":"$Misc",
            "flag":1 << QuestUtils.MISC_QUEST_TYPE
         });
         this.FilterInfoA.push({
            "text":"$MISSION",
            "flag":1 << QuestUtils.MISSION_QUEST_TYPE
         });
         this.FilterInfoA.push({
            "text":"$Activity",
            "flag":1 << QuestUtils.ACTIVITY_QUEST_TYPE
         });
         this.FilterInfoA.push({
            "text":"$Completed",
            "flag":1 << QuestUtils.COMPLETED_QUEST_TYPE
         });
         this.TabbedFilterSelection_mc.SetTabsData(this.FilterInfoA);
         this.TabbedFilterSelection_mc.addEventListener(BSTabbedSelectionEvent.NAME,this.onFilterChanged);
         this.startingTabButtonYPosition = this.TabbedFilterSelection_mc.LeftButton.y;
      }
      
      private function OnQuestDataUpdate(param1:FromClientDataEvent) : void
      {
         this.QuestData = param1.data.aQuests;
         this.CollapseAllChildren();
         this.lastSelectedIndex = -1;
         this.MissionsList_mc.InitializeEntries(this.QuestData);
         if(this.visible)
         {
            stage.focus = this.MissionsList_mc;
            if(this.QuestData.length > 0 && this.MissionsList_mc.selectedIndex == -1)
            {
               this.MissionsList_mc.selectedIndex = 0;
            }
            if(this.scrollPositionAtTracking)
            {
               this.MissionsList_mc.scrollPosition = this.scrollPositionAtTracking;
            }
            this.scrollPositionAtTracking = -1;
            this.onMissionSelectionChange();
         }
         else
         {
            this.MissionsList_mc.selectedIndex = -1;
         }
         this.InitializeLastState();
      }
      
      public function onStickDataChanged(param1:FromClientDataEvent) : *
      {
         this.MissionInfo_mc.ProcessStickData(param1);
      }
      
      public function onMissionMenuStateData(param1:FromClientDataEvent) : *
      {
         this.StoredLastOpenedIds = param1.data.aOpenQuestIds;
         this.StoredLastCategory = param1.data.uCategoryIndex;
         this.SetQTDisplayFlag(param1.data.bShowOnlyActiveQTs);
         this.InitializeLastState();
      }
      
      public function onFireForgetEvent(param1:FromClientDataEvent) : *
      {
         if(GlobalFunc.HasFireForgetEvent(param1.data,"MissionMenu_TransitionToMap"))
         {
            this.CloseMenu(false);
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("QuestData",this.OnQuestDataUpdate);
         BSUIDataManager.Subscribe("MissionMenuStickData",this.onStickDataChanged);
         BSUIDataManager.Subscribe("MissionMenuStateData",this.onMissionMenuStateData);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFireForgetEvent);
         GlobalFunc.PlayMenuSound("UIMenuMissionsMenuEnter");
         this.KeyHelper = new ButtonKeyHelper();
      }
      
      override protected function OnPlatformChanged(param1:Object) : void
      {
         super.OnPlatformChanged(param1);
         this.TabbedFilterSelection_mc.Configure(CategoryTab,BSTabbedSelection.CENTER_ALIGNED,BSTabbedSelection.DEFAULT_SPACING,uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE ? ["LShoulder","Left"] : ["LShoulder"],uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE ? ["RShoulder","Right"] : ["RShoulder"]);
      }
      
      private function onFilterChanged(param1:BSTabbedSelectionEvent) : *
      {
         this.bSkipSelectionSounds = true;
         this.CollapseAllChildren();
         this.MissionsList_mc.filterMask = this.currentFilterFlag;
         if(this.MissionsList_mc.entryCount > 0)
         {
            this.MissionsList_mc.selectedIndex = 0;
         }
         GlobalFunc.PlayMenuSound(MISSION_CATEGORY_CHANGE_SOUND);
         this.bSkipSelectionSounds = false;
      }
      
      private function CollapseAllChildren() : *
      {
         this.bCollapsing = true;
         if(this.bWithinMiscQuest)
         {
            this.MissionsList_mc.ShowEntryChildren(this.miscQuestIndex,false);
         }
         else
         {
            this.MissionsList_mc.ShowEntryChildren(this.lastSelectedIndex,false);
         }
         this.lastSelectedIndex = -1;
         this.bCollapsing = false;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 == "ReturnToStarMap" && param2 == false)
         {
            this.OnCancelEvent();
            _loc3_ = true;
         }
         else if(param1 == "Missions" && param2 == false)
         {
            this.onCloseSubMenuToGame();
            _loc3_ = true;
         }
         _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         if(!_loc3_)
         {
            _loc3_ = this.TabbedFilterSelection_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function SetQTDisplayFlag(param1:Boolean) : void
      {
         if(this.ShowOnlyActiveQTs != param1)
         {
            this.ShowOnlyActiveQTs = param1;
            this.ToggleQTDisplayButton.SetButtonData(this.ShowOnlyActiveQTs ? this.ShowAllQTsBtnData : this.ShowOnlyActiveQTsBtnData);
         }
      }
      
      private function ToggleQTDisplay() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MissionMenu_ToggleQTDisplay"));
      }
      
      private function GetParentMissionData(param1:Object) : Object
      {
         var _loc3_:uint = 0;
         var _loc2_:* = null;
         if(param1)
         {
            if(MissionsListEntry.IsMission(param1))
            {
               _loc2_ = param1;
            }
            else if(param1.bIsMiscObjective == null || param1.bIsMiscObjective === false)
            {
               _loc3_ = 0;
               while(_loc3_ < this.QuestData.length)
               {
                  if(this.QuestData[_loc3_].uID == param1.uOwnerQuestFormID)
                  {
                     _loc2_ = this.QuestData[_loc3_];
                     break;
                  }
                  _loc3_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function onMissionSelectionChange() : *
      {
         var _loc1_:Object = this.MissionsList_mc.selectedEntry;
         var _loc2_:Boolean = _loc1_ != null ? MissionsListEntry.IsMission(_loc1_) : false;
         var _loc3_:Object = null;
         if(!_loc2_)
         {
            _loc3_ = this.GetParentMissionData(_loc1_);
         }
         if(_loc1_ != null)
         {
            this.CanTrackOrUntrack = !_loc2_;
            if(this.CanTrackOrUntrack)
            {
               if(_loc3_ == null || _loc3_.uID == 0)
               {
                  this.CanTrackOrUntrack = Boolean(_loc1_.bIsMiscObjective) && !_loc1_.bComplete;
               }
               else
               {
                  this.CanTrackOrUntrack = !_loc3_.bComplete;
               }
            }
            this.UpdateRejectData(_loc1_.bCanBeRejected === true && (_loc3_ == null || _loc3_.uID == 0));
            this.ShowOnMapButton.Enabled = MissionsListEntry.CanShowOnMap(_loc1_) != 0;
            this.PlotToLocationButton.Enabled = MissionsListEntry.CanShowOnMap(_loc1_) != 0;
            if(_loc2_ || _loc1_.bIsMiscObjective === true)
            {
               this.MissionInfo_mc.UpdateMissionInfo(this.MissionsList_mc.selectedEntry);
            }
            else if(_loc3_)
            {
               this.MissionInfo_mc.UpdateMissionInfo(_loc3_);
            }
         }
         else
         {
            this.ShowOnMapButton.Enabled = false;
            this.PlotToLocationButton.Enabled = false;
            this.CanTrackOrUntrack = false;
            this.UpdateRejectData(false);
         }
         if(_loc2_)
         {
            this.lastSelectedIndex = this.MissionsList_mc.selectedIndex;
         }
         if(!this.bSkipSelectionSounds)
         {
            GlobalFunc.PlayMenuSound(MISSION_SELECTION_CHANGE_SOUND);
            GlobalFunc.PlayMenuSound(MISSION_SUBTASK_TOGGLE_SOUND);
         }
         this.bSkipSelectionSounds = false;
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         if(this.KeyHelper != null)
         {
            this.KeyHelper.OnControlMapChanged(param1);
         }
         this.PopulateButtonBar();
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.TabbedFilterSelection_mc.LeftButton.y = this.startingTabButtonYPosition + KEYBOARD_TAB_BUTTON_OFFSET;
            this.TabbedFilterSelection_mc.RightButton.y = this.startingTabButtonYPosition + KEYBOARD_TAB_BUTTON_OFFSET;
            this.TabbedFilterSelection_mc.UpdateButtonUserEvents(["Left"],["Right"]);
         }
         else
         {
            this.TabbedFilterSelection_mc.LeftButton.y = this.startingTabButtonYPosition;
            this.TabbedFilterSelection_mc.RightButton.y = this.startingTabButtonYPosition;
            this.TabbedFilterSelection_mc.UpdateButtonUserEvents(["LShoulder","Left"],["RShoulder","Right"]);
         }
      }
      
      private function OnCancelEvent() : void
      {
         this.CloseMenu(false);
      }
      
      private function onCloseSubMenuToGame() : *
      {
         this.CloseMenu(true);
      }
      
      private function CloseMenu(param1:Boolean) : *
      {
         if(!this.bClosing)
         {
            this.bClosing = true;
            this.bReturningToGame = param1;
            if(param1)
            {
               GlobalFunc.StartGameRender();
               BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
            }
            gotoAndPlay("Close");
         }
      }
      
      private function OnTimelineCloseEvent() : void
      {
         this.SaveMissionMenuState();
         GlobalFunc.PlayMenuSound("UIMenuMissionsMenuExit");
         if(this.bReturningToGame)
         {
            GlobalFunc.CloseAllMenus();
         }
         else
         {
            GlobalFunc.CloseMenu("BSMissionMenu");
         }
      }
      
      private function OnShowOnMapEvent() : void
      {
         if(MissionsListEntry.IsMission(this.MissionsList_mc.selectedEntry))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(SHOW_ITEM_LOCATION_EVENT,{
               "questID":this.MissionsList_mc.selectedEntry.uID,
               "objectiveID":-1
            }));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(SHOW_ITEM_LOCATION_EVENT,{
               "questID":this.MissionsList_mc.selectedEntry.uOwnerQuestFormID,
               "objectiveID":this.MissionsList_mc.selectedEntry.uIndex
            }));
         }
         GlobalFunc.PlayMenuSound(MISSION_SHOW_ON_MAP_SOUND);
      }
      
      private function OnPlotCourseEvent() : void
      {
         if(MissionsListEntry.IsMission(this.MissionsList_mc.selectedEntry))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_PlotToLocation,{
               "questID":this.MissionsList_mc.selectedEntry.uID,
               "objectiveID":-1
            }));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_PlotToLocation,{
               "questID":this.MissionsList_mc.selectedEntry.uOwnerQuestFormID,
               "objectiveID":this.MissionsList_mc.selectedEntry.uIndex
            }));
         }
         GlobalFunc.PlayMenuSound(MISSION_SHOW_ON_MAP_SOUND);
      }
      
      private function onMissionListItemActivated() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         if(this.CanTrackOrUntrack)
         {
            _loc1_ = this.MissionsList_mc.selectedEntry;
            if(_loc1_ != null)
            {
               this.bSkipSelectionSounds = true;
               this.MissionsList_mc.StoreCurrentListState();
               if(_loc1_.bIsMiscObjective === true)
               {
                  if(_loc1_.bActive)
                  {
                     GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_OFF_SOUND);
                  }
                  else
                  {
                     GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_ON_SOUND);
                  }
                  this.scrollPositionAtTracking = this.MissionsList_mc.scrollPosition;
                  this.MissionsList_mc.selectedIndex = -1;
                  BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_ToggleTrackingQuest,{
                     "questID":_loc1_.uOwnerQuestFormID,
                     "instanceID":_loc1_.uInstanceID
                  }));
               }
               else
               {
                  _loc2_ = MissionsListEntry.IsMission(_loc1_);
                  if(_loc2_)
                  {
                     if(_loc1_.bActive)
                     {
                        GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_OFF_SOUND);
                     }
                     else
                     {
                        GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_ON_SOUND);
                     }
                     this.scrollPositionAtTracking = this.MissionsList_mc.scrollPosition;
                     BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_ToggleTrackingQuest,{
                        "questID":_loc1_.uID,
                        "instanceID":_loc1_.uInstanceID
                     }));
                  }
                  else
                  {
                     _loc3_ = this.GetParentMissionData(_loc1_);
                     if(_loc3_)
                     {
                        if(_loc3_.bActive)
                        {
                           GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_OFF_SOUND);
                        }
                        else
                        {
                           GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_ON_SOUND);
                        }
                        this.scrollPositionAtTracking = this.MissionsList_mc.scrollPosition;
                        BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_ToggleTrackingQuest,{
                           "questID":_loc3_.uID,
                           "instanceID":_loc3_.uInstanceID
                        }));
                     }
                  }
               }
            }
         }
      }
      
      private function OnRejectQuest() : void
      {
         var _loc1_:* = undefined;
         if(this.canReject)
         {
            _loc1_ = this.MissionsList_mc.selectedEntry;
            if(_loc1_ != null)
            {
               GlobalFunc.PlayMenuSound(MISSION_TRACKING_TOGGLE_OFF_SOUND);
               this.MissionsList_mc.StoreCurrentListState();
               this.bSkipSelectionSounds = true;
               if(_loc1_.bIsMiscObjective === true)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_RejectQuest,{
                     "questID":_loc1_.uOwnerQuestFormID,
                     "instanceID":_loc1_.uInstanceID
                  }));
               }
               else
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_RejectQuest,{
                     "questID":_loc1_.uID,
                     "instanceID":_loc1_.uInstanceID
                  }));
               }
            }
         }
      }
      
      private function onShowButtonBar() : *
      {
         this.ButtonBar_mc.visible = true;
      }
      
      private function SaveMissionMenuState() : *
      {
         var _loc2_:uint = 0;
         BSUIDataManager.dispatchEvent(new Event(MissionMenu_ClearState));
         BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_SaveCategoryIndex,{"uValue":this.TabbedFilterSelection_mc.selectedIndex}));
         var _loc1_:Array = this.MissionsList_mc.GetListOfExpandedQuestIds();
         for each(_loc2_ in _loc1_)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(MissionMenu_SaveOpenedId,{"uValue":_loc2_}));
         }
      }
      
      private function InitializeLastState() : *
      {
         if(!this.InitializedOpenedIds)
         {
            if(this.QuestData != null && this.QuestData.length > 0)
            {
               if(this.StoredLastOpenedIds != null && this.StoredLastOpenedIds.length > 0)
               {
                  this.InitializedOpenedIds = true;
                  this.TabbedFilterSelection_mc.SetSelectedCategoryIndex(this.StoredLastCategory);
                  if(!this.MissionsList_mc.RestorePreviousMissionMenuState(this.StoredLastOpenedIds) && this.TabbedFilterSelection_mc.selectedIndex != 0)
                  {
                     this.TabbedFilterSelection_mc.SetSelectedCategoryIndex(0);
                  }
               }
            }
         }
      }
   }
}
