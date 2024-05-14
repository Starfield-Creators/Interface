package
{
   import HUD.QuestUpdateStates.QuestMessage;
   import HUD.QuestUpdateStates.QuestState;
   import HUD.QuestUpdateStates.QuestStateMachine;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.EnumHelper;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class QuestUpdate extends MovieClip
   {
      
      public static const UPDATE_QUEST_UPDATE_POSITION:String = "UpdateQuestUpdatePosition";
      
      public static const HIDE_QUEST_UPDATE:String = "HIDE_QUEST_UPDATE";
      
      public static const QUEST_REWARD_ANIMATION_FINISHED:String = "QUEST_REWARD_ANIMATION_FINISHED";
      
      public static const WIDGET_SPACER:uint = 2;
      
      public static const MISSION_ACTIVE_BUTTON_X_SPACER:Number = 8;
      
      public static const MISSION_ACTIVE_OFFSET:Number = 5;
       
      
      public var QuestRewardsWidget_mc:MovieClip;
      
      public var ObjectivesList_mc:MovieClip;
      
      public var QuestTextWidgetBase_mc:MovieClip;
      
      public var SetMissionActiveButton_mc:MovieClip;
      
      public var HiddenDataMenuButton_mc:ButtonBase;
      
      private var SetActiveButtonData:ReleaseHoldComboButtonData;
      
      private var SetActiveButtonDataKBM:ReleaseHoldComboButtonData;
      
      private var DataMenuButtonData:ButtonBaseData;
      
      private const SET_MISSION_ACTIVE:String = "HUDNotification_SetMissionActive";
      
      private const MISSION_ACTIVE_UPDATE:String = "HUDNotification_MissionActiveWidgetUpdate";
      
      private const OPEN_DATA_MENU:String = "HUDNotification_OpenDataMenu";
      
      private const OPEN_MISSION_MENU:String = "HUDNotification_OpenMissionMenu";
      
      private const SHOW_MISSION_ACTIVE_WIDGET:String = "ShowMissionActiveWidget";
      
      private const HIDE_MISSION_ACTIVE_WIDGET:String = "HideMissionActiveWidget";
      
      private const TIME_TO_HIDE_WIDGET_AFTER_QUEST_REWARD_MS:Number = 1500;
      
      private const TIME_TO_HIDE_WIDGET_WITH_OBJECTIVE_MS:Number = 3000;
      
      private const TIME_TO_HIDE_WIDGET_MS:Number = 6000;
      
      private const BUTTON_PADDING:uint = 12;
      
      private var QuestUpdateData:Object = null;
      
      private var StageVar:Stage = null;
      
      private var IsTempUpdate:Boolean = true;
      
      private var IsShowingRewards:Boolean = false;
      
      private var OnlyShowQuestUpdates:Boolean = false;
      
      private var MyButtonManager:ButtonManager;
      
      private const NO_BUTTON_SHOWING:uint = EnumHelper.GetEnum(0);
      
      private const MISSION_BUTTON_SHOWING:uint = EnumHelper.GetEnum();
      
      private const PLOT_BUTTON_SHOWING:uint = EnumHelper.GetEnum();
      
      private var ShowingButton:uint;
      
      private var HideQuestUpdateTimer:Timer;
      
      private var ShouldShowObjectivesInNonObjectiveEvents:Boolean = false;
      
      private var LerpPercent:Number = 0;
      
      private var StartingLerpPosition:Point;
      
      private var EndingLerpPosition:Point;
      
      private const PERCENT_INCREASE_TICK:Number = 0.1;
      
      protected var StateMachine:QuestStateMachine;
      
      private var uiController:uint = 4294967295;
      
      public function QuestUpdate(param1:Stage = null, param2:Boolean = false)
      {
         this.SetActiveButtonData = new ReleaseHoldComboButtonData("","$SET MISSION ACTIVE",[new UserEventData("SetMissionActive",this.OpenDataMenu),new UserEventData("",this.SetMissionActive)]);
         this.SetActiveButtonDataKBM = new ReleaseHoldComboButtonData("","$SET MISSION ACTIVE",[new UserEventData("SetMissionActive",this.OpenMissionMenu),new UserEventData("",this.SetMissionActive)]);
         this.DataMenuButtonData = new ButtonBaseData("",new UserEventData("SetMissionActive",this.OpenDataMenu),false,false);
         this.MyButtonManager = new ButtonManager();
         this.ShowingButton = this.NO_BUTTON_SHOWING;
         this.StartingLerpPosition = new Point(0,0);
         this.EndingLerpPosition = new Point(0,0);
         super();
         if(param1)
         {
            this.StageVar = param1;
         }
         else
         {
            this.StageVar = stage;
         }
         this.IsTempUpdate = param2;
         this.StateMachine = new QuestStateMachine(this);
         this.configureStates();
         this.StateMachine.changeStateById(QuestState.STATE_HIDDEN);
         this.QuestRewardsWidget_mc.addEventListener(HIDE_QUEST_UPDATE,this.onQuestHide);
         this.QuestRewardsWidget_mc.addEventListener(QUEST_REWARD_ANIMATION_FINISHED,this.OnQuestRewardAnimationFinished);
         this.QuestTextWidgetBase_mc.addEventListener(HIDE_QUEST_UPDATE,this.onQuestHide);
         this.QuestTextWidgetBase_mc.addEventListener(QuestText.QUEST_TEXT_HIDDEN_EVENT,this.OnQuestTextHidden);
         this.SetActiveButtonData.bPressAndReleaseVisible = false;
         this.SetActiveButtonDataKBM.bPressAndReleaseVisible = false;
         this.SetMissionActiveButton_mc.HoldButton_mc.addEventListener(ButtonBase.BUTTON_REDRAWN_EVENT,this.UpdateButtonBackground);
         this.SetMissionActiveButton_mc.HoldButton_mc.SetButtonData(this.SetActiveButtonData);
         this.MyButtonManager.AddButton(this.SetMissionActiveButton_mc.HoldButton_mc as IButton);
         this.SetMissionActiveButton_mc.HoldButton_mc.alpha = 0;
         this.SetMissionActiveButton_mc.HoldButton_mc.disableRollSounds = true;
         this.HiddenDataMenuButton_mc.SetButtonData(this.DataMenuButtonData);
         this.MyButtonManager.AddButton(this.HiddenDataMenuButton_mc as IButton);
         this.HideQuestUpdateTimer = new Timer(this.TIME_TO_HIDE_WIDGET_MS,1);
         this.HideQuestUpdateTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideQuestUpdateTimerCompleted);
         this.ObjectivesList_mc.addEventListener(ObjectivesList.OBJECTIVES_HIDDEN,this.OnObjectivesHidden);
         (this.SetMissionActiveButton_mc.HoldButton_mc as ButtonBase).justification = IButtonUtils.ICON_FIRST;
      }
      
      public function SetPlatform(param1:uint) : void
      {
         if(this.uiController != param1)
         {
            this.uiController = param1;
            if(this.ShowingButton == this.MISSION_BUTTON_SHOWING)
            {
               if(this.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
               {
                  this.SetMissionActiveButton_mc.HoldButton_mc.SetButtonData(this.SetActiveButtonDataKBM);
               }
               else
               {
                  this.SetMissionActiveButton_mc.HoldButton_mc.SetButtonData(this.SetActiveButtonData);
               }
            }
            else if(this.ShowingButton == this.PLOT_BUTTON_SHOWING)
            {
               this.HiddenDataMenuButton_mc.Enabled = this.uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
            }
         }
      }
      
      public function ShowMissionActiveButton() : void
      {
         if(!this.IsShowingInputButton())
         {
            if(this.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
            {
               this.SetMissionActiveButton_mc.HoldButton_mc.SetButtonData(this.SetActiveButtonDataKBM);
            }
            else
            {
               this.SetMissionActiveButton_mc.HoldButton_mc.SetButtonData(this.SetActiveButtonData);
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(this.MISSION_ACTIVE_UPDATE,{"bIsShowingUpdate":true}));
            this.ShowingButton = this.MISSION_BUTTON_SHOWING;
            this.SetMissionActiveButton_mc.gotoAndPlay(this.SHOW_MISSION_ACTIVE_WIDGET);
            if(!hasEventListener(Event.ENTER_FRAME))
            {
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
         }
      }
      
      public function HideInputButton() : void
      {
         if(this.IsShowingInputButton())
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(this.MISSION_ACTIVE_UPDATE,{"bIsShowingUpdate":false}));
            this.ShowingButton = this.NO_BUTTON_SHOWING;
            this.SetMissionActiveButton_mc.gotoAndPlay(this.HIDE_MISSION_ACTIVE_WIDGET);
            this.HiddenDataMenuButton_mc.Enabled = false;
         }
      }
      
      public function IsShowingInputButton() : Boolean
      {
         return this.ShowingButton != this.NO_BUTTON_SHOWING;
      }
      
      public function CanShowQuestUpdate() : Boolean
      {
         return this.StateMachine.getCurrentStateId() !== QuestState.STATE_ANIMATING || Boolean(this.QuestTextWidgetBase_mc.CanShowQuestUpdate());
      }
      
      public function IsShowingThisQuest(param1:Object) : Boolean
      {
         var _loc2_:* = false;
         if(this.QuestUpdateData)
         {
            if(param1)
            {
               _loc2_ = this.QuestUpdateData.uQuestID == param1.uQuestID;
            }
         }
         else
         {
            _loc2_ = !param1;
         }
         return _loc2_;
      }
      
      public function IsShowingActiveQuest() : Boolean
      {
         var _loc1_:* = false;
         if(this.QuestUpdateData)
         {
            _loc1_ = this.QuestUpdateData.bActiveQuest === true;
         }
         return _loc1_;
      }
      
      public function ShowQuestUpdate(param1:Object) : *
      {
         this.QuestUpdateData = param1;
         if(Boolean(this.QuestUpdateData) && Boolean(this.QuestUpdateData.uType))
         {
            this.HideQuestUpdateTimer.reset();
            if(this.QuestUpdateData.uType == QuestMessage.QUEST_EXPERIENCE_AWARDED)
            {
               this.ShowXPRewards();
            }
            else
            {
               this.StateMachine.processEvent(this.QuestUpdateData);
               this.QuestTextWidgetBase_mc.processEvent(this.QuestUpdateData);
            }
            if(this.QuestUpdateData.uType == QuestMessage.QUEST_SET_INACTIVE)
            {
               if(this.QuestTextWidgetBase_mc.isHidden())
               {
                  dispatchEvent(new Event(HUDMessagesMenu.REMOVE_QUEST_UPDATE));
                  this.StateMachine.changeStateById(QuestState.STATE_HIDDEN,this);
               }
               else
               {
                  this.IsTempUpdate = true;
                  this.HideQuestObjectives();
               }
            }
            else if(this.IsQuestCompleted() || this.IsQuestFailed())
            {
               this.HideQuestObjectives();
               this.CheckQuestState();
            }
            else
            {
               if(this.QuestUpdateData.uType == QuestMessage.QUEST_SET_ACTIVE)
               {
                  this.IsTempUpdate = false;
               }
               if(this.IsObjectiveUpdate() || this.ShouldShowObjectivesInNonObjectiveEvents || this.QuestUpdateData.bIsMiscQuest || Boolean(this.QuestUpdateData.bShowObjectives))
               {
                  this.ShowQuestObjectives();
               }
               else
               {
                  this.ObjectivesList_mc.y = this.QuestTextWidgetBase_mc.y + this.QuestTextWidgetBase_mc.height + WIDGET_SPACER;
                  this.ObjectivesList_mc.UpdateQuestObjectives(this.QuestUpdateData.ObjectiveDataA);
                  this.ObjectivesList_mc.HideObjectives(false);
                  this.PositionRewardsWidget();
                  this.PositionMissionActiveWidget();
               }
               if(this.QuestUpdateData.uType != QuestMessage.QUEST_EXPERIENCE_AWARDED)
               {
                  this.HideQuestUpdateTimer.delay = this.TIME_TO_HIDE_WIDGET_MS;
                  this.HideQuestUpdateTimer.start();
               }
            }
         }
      }
      
      private function IsObjectiveUpdate() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.QuestUpdateData != null)
         {
            if(this.QuestUpdateData.uType == QuestMessage.OBJECTIVE_ADDED || this.QuestUpdateData.uType == QuestMessage.OBJECTIVE_COMPLETED || this.QuestUpdateData.uType == QuestMessage.OBJECTIVE_FAILED || this.QuestUpdateData.uType == QuestMessage.OBJECTIVE_DORMANT || this.QuestUpdateData.uType == QuestMessage.OBJECTIVE_MOVE_TO_TOP || this.QuestUpdateData.uType == QuestMessage.HDT_QUEST_TEXT_UPDATED)
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      private function ShowQuestObjectives() : *
      {
         this.ObjectivesList_mc.y = this.QuestTextWidgetBase_mc.y + this.QuestTextWidgetBase_mc.height + WIDGET_SPACER;
         this.ObjectivesList_mc.ShowQuestObjectives(this.QuestUpdateData.ObjectiveDataA);
         this.ObjectivesList_mc.addEventListener(ObjectivesList.OBJECTIVES_FINISHED,this.CheckQuestState);
         this.PositionRewardsWidget();
         this.PositionMissionActiveWidget();
      }
      
      private function TransitionToAlwaysUp() : *
      {
         this.ObjectivesList_mc.TransitionToAlwaysUp();
         this.PositionRewardsWidget();
         this.PositionMissionActiveWidget();
      }
      
      private function HideQuestObjectives() : *
      {
         this.ObjectivesList_mc.HideObjectives(!this.ObjectivesList_mc.AreObjectivesHidden());
      }
      
      public function UpdateQuest(param1:Object) : *
      {
         if(param1.ObjectiveDataA.length > 0)
         {
            this.ObjectivesList_mc.y = this.QuestTextWidgetBase_mc.y + this.QuestTextWidgetBase_mc.height + WIDGET_SPACER;
            this.ObjectivesList_mc.ShowQuestObjectives(param1.ObjectiveDataA);
            this.PositionRewardsWidget();
            this.PositionMissionActiveWidget();
            this.HideQuestUpdateTimer.reset();
            this.HideQuestUpdateTimer.delay = this.TIME_TO_HIDE_WIDGET_WITH_OBJECTIVE_MS;
            this.HideQuestUpdateTimer.start();
         }
         this.QuestUpdateData = param1;
      }
      
      public function UpdateQuestTimer(param1:Object) : *
      {
         this.QuestUpdateData = param1;
         this.QuestTextWidgetBase_mc.UpdateQuestTimer(param1.iRemainingTime);
      }
      
      public function IsQuestCompleted() : Boolean
      {
         return this.QuestUpdateData != null && this.QuestUpdateData.uType == QuestMessage.QUEST_COMPLETED;
      }
      
      public function IsQuestFailed() : Boolean
      {
         return this.QuestUpdateData != null && this.QuestUpdateData.uType == QuestMessage.QUEST_FAILED;
      }
      
      public function IsQuestActive() : Boolean
      {
         return this.QuestUpdateData != null && Boolean(this.QuestUpdateData.bActiveQuest);
      }
      
      public function CheckQuestState() : *
      {
         if(this.QuestUpdateData != null)
         {
            if(this.QuestUpdateData.uType != QuestMessage.QUEST_EXPERIENCE_AWARDED)
            {
               this.HideQuestUpdateTimer.delay = this.TIME_TO_HIDE_WIDGET_WITH_OBJECTIVE_MS;
               this.HideQuestUpdateTimer.start();
            }
         }
      }
      
      private function onHideQuestUpdateTimerCompleted() : *
      {
         if(this.QuestUpdateData != null)
         {
            if(!this.IsAlwaysUp() || !this.ShouldShowObjectivesInNonObjectiveEvents)
            {
               if(!this.QuestTextWidgetBase_mc.isHidden())
               {
                  this.QuestTextWidgetBase_mc.changeState(QuestText.STATE_HIDDEN);
               }
               this.IsShowingRewards = false;
               this.HideQuestObjectives();
               this.HideInputButton();
            }
            else
            {
               if(!this.QuestTextWidgetBase_mc.isAlwaysUp())
               {
                  this.QuestTextWidgetBase_mc.changeState(QuestText.STATE_ALWAYS_UP);
               }
               this.IsShowingRewards = false;
               this.PositionRewardsWidget();
               this.PositionMissionActiveWidget();
               this.HideInputButton();
            }
         }
      }
      
      private function OnObjectivesHidden() : *
      {
         this.PositionRewardsWidget();
         this.PositionMissionActiveWidget();
         dispatchEvent(new Event(UPDATE_QUEST_UPDATE_POSITION));
      }
      
      public function ShowXPRewards() : *
      {
         if(this.QuestUpdateData != null && this.QuestUpdateData.uType == QuestMessage.QUEST_EXPERIENCE_AWARDED)
         {
            this.IsShowingRewards = true;
            this.PositionRewardsWidget();
            this.QuestRewardsWidget_mc.ShowXPRewards(this.QuestUpdateData);
         }
      }
      
      public function IsAlwaysUp() : Boolean
      {
         return this.QuestUpdateData != null && !(!this.QuestUpdateData.bAlwaysUp || this.OnlyShowQuestUpdates || this.IsTempUpdate || !this.ObjectivesList_mc.HasVisibleObjectiveEntries());
      }
      
      public function ChangeObjectiveListVisibility(param1:Boolean) : *
      {
         if(param1 != this.ShouldShowObjectivesInNonObjectiveEvents)
         {
            this.ShouldShowObjectivesInNonObjectiveEvents = param1;
            if(this.QuestUpdateData != null)
            {
               if(this.CanShowQuestUpdate() || !this.IsObjectiveUpdate())
               {
                  if(this.ShouldShowObjectivesInNonObjectiveEvents)
                  {
                     if(this.IsAlwaysUp())
                     {
                        this.ObjectivesList_mc.TransitionToAlwaysUp();
                     }
                     else
                     {
                        this.ObjectivesList_mc.PlayShowAnimations();
                     }
                     this.PositionRewardsWidget();
                     this.PositionMissionActiveWidget();
                     if(this.IsAlwaysUp() && Boolean(this.QuestTextWidgetBase_mc.isHidden()))
                     {
                        this.QuestTextWidgetBase_mc.changeState(QuestText.STATE_ALWAYS_UP);
                     }
                     this.visible = true;
                  }
                  else
                  {
                     this.HideQuestObjectives();
                     if(this.QuestTextWidgetBase_mc.isAlwaysUp())
                     {
                        this.QuestTextWidgetBase_mc.changeState(QuestText.STATE_HIDDEN);
                     }
                  }
               }
            }
         }
      }
      
      private function PositionRewardsWidget() : *
      {
         this.QuestRewardsWidget_mc.y = this.QuestTextWidgetBase_mc.y + this.QuestTextWidgetBase_mc.height + WIDGET_SPACER + (!!this.ObjectivesList_mc.AreObjectivesHidden() ? 0 : this.ObjectivesList_mc.height);
      }
      
      private function PositionMissionActiveWidget() : *
      {
         this.SetMissionActiveButton_mc.y = this.QuestTextWidgetBase_mc.y + this.QuestTextWidgetBase_mc.height + WIDGET_SPACER + MISSION_ACTIVE_OFFSET + (!!this.ObjectivesList_mc.AreObjectivesHidden() ? 0 : this.ObjectivesList_mc.height);
      }
      
      public function GetVisibleHeight() : uint
      {
         var _loc1_:uint = this.QuestTextWidgetBase_mc.height;
         if(this.QuestTextWidgetBase_mc.isHidden())
         {
            _loc1_ = 0;
         }
         else
         {
            if(!this.ObjectivesList_mc.AreObjectivesHidden())
            {
               _loc1_ += this.ObjectivesList_mc.height;
            }
            if(this.IsShowingRewards)
            {
               _loc1_ += this.QuestRewardsWidget_mc.height;
            }
            if(this.IsShowingInputButton())
            {
               _loc1_ += this.SetMissionActiveButton_mc.height;
            }
         }
         return _loc1_;
      }
      
      private function OnQuestRewardAnimationFinished(param1:Event) : *
      {
         if(this.QuestUpdateData != null)
         {
            this.HideQuestUpdateTimer.delay = this.TIME_TO_HIDE_WIDGET_AFTER_QUEST_REWARD_MS;
            this.HideQuestUpdateTimer.start();
         }
      }
      
      public function onQuestHide(param1:Event) : *
      {
         if(this.IsTempUpdate)
         {
            this.QuestUpdateData = null;
            param1.stopPropagation();
            this.RemoveQuestUpdate();
         }
         else if(this.QuestUpdateData != null)
         {
            if(this.QuestUpdateData.bActiveQuest === true && Boolean(this.ObjectivesList_mc.HasVisibleObjectiveEntries()))
            {
               this.StateMachine.changeStateById(QuestState.STATE_ALWAYS_UP,this);
            }
            else
            {
               this.RemoveQuestUpdate();
            }
         }
      }
      
      private function OnQuestTextHidden(param1:Event) : *
      {
         if(this.QuestUpdateData != null)
         {
            if(this.QuestUpdateData.bActiveQuest == null || this.QuestUpdateData.bActiveQuest == false || !this.ObjectivesList_mc.HasVisibleObjectiveEntries())
            {
               if(hasEventListener(Event.ENTER_FRAME))
               {
                  x = this.EndingLerpPosition.x;
                  y = this.EndingLerpPosition.y;
               }
               dispatchEvent(new Event(HUDMessagesMenu.REMOVE_QUEST_UPDATE));
            }
            else
            {
               this.StateMachine.changeStateById(QuestState.STATE_HIDDEN,this);
            }
         }
      }
      
      private function RemoveQuestUpdate() : *
      {
         if(!this.IsAlwaysUp())
         {
            if(hasEventListener(Event.ENTER_FRAME))
            {
               x = this.EndingLerpPosition.x;
               y = this.EndingLerpPosition.y;
            }
            dispatchEvent(new Event(HUDMessagesMenu.REMOVE_QUEST_UPDATE));
         }
         this.StateMachine.changeStateById(QuestState.STATE_HIDDEN,this);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      public function TranslateToNewPosition(param1:Point) : *
      {
         this.StartingLerpPosition.x = x;
         this.StartingLerpPosition.y = y;
         this.EndingLerpPosition = param1;
         this.LerpPercent = 1;
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      protected function onEnterFrame(param1:Event) : *
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         if(this.LerpPercent > 0)
         {
            this.LerpPercent -= this.PERCENT_INCREASE_TICK;
            if(this.LerpPercent <= 0)
            {
               this.LerpPercent = 0;
            }
            _loc2_ = Point.interpolate(this.StartingLerpPosition,this.EndingLerpPosition,this.LerpPercent);
            x = _loc2_.x;
            y = _loc2_.y;
         }
         if(this.IsShowingInputButton() || this.SetMissionActiveButton_mc.isPlaying)
         {
            _loc3_ = 0;
            if(Boolean(this.SetMissionActiveButton_mc.HoldButton_mc.PCButtonInstance_mc) && Boolean(this.SetMissionActiveButton_mc.HoldButton_mc.PCButtonInstance_mc.visible))
            {
               _loc3_ = Number(this.SetMissionActiveButton_mc.HoldButton_mc.PCButtonInstance_mc.width);
            }
            else if(this.SetMissionActiveButton_mc.HoldButton_mc.ConsoleButtonInstance_mc)
            {
               _loc3_ = Number(this.SetMissionActiveButton_mc.HoldButton_mc.ConsoleButtonInstance_mc.width);
            }
            this.SetMissionActiveButton_mc.HoldButton_mc.alpha = Math.min(this.SetMissionActiveButton_mc.Background_mc.alpha * 2,1);
            this.SetMissionActiveButton_mc.HoldButton_mc.x = this.SetMissionActiveButton_mc.Background_mc.x + MISSION_ACTIVE_BUTTON_X_SPACER + _loc3_;
         }
         if(this.LerpPercent == 0 && !this.IsShowingInputButton() && !this.SetMissionActiveButton_mc.isPlaying)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.SetMissionActiveButton_mc.HoldButton_mc.alpha = 0;
         }
      }
      
      protected function SetMissionActive() : *
      {
         if(Boolean(this.QuestUpdateData) && this.IsShowingInputButton())
         {
            this.HideInputButton();
            BSUIDataManager.dispatchEvent(new CustomEvent(this.SET_MISSION_ACTIVE,{
               "questID":this.QuestUpdateData.uQuestID,
               "instanceID":this.QuestUpdateData.uInstanceID
            }));
            this.IsTempUpdate = false;
            this.QuestUpdateData.bActiveQuest = true;
            this.QuestUpdateData.bAlwaysUp = true;
         }
      }
      
      protected function OpenDataMenu() : *
      {
         if(this.IsShowingInputButton())
         {
            BSUIDataManager.dispatchEvent(new Event(this.OPEN_DATA_MENU));
         }
      }
      
      protected function OpenMissionMenu() : *
      {
         if(this.IsShowingInputButton())
         {
            BSUIDataManager.dispatchEvent(new Event(this.OPEN_MISSION_MENU));
         }
      }
      
      protected function configureStates() : void
      {
         var transitions:* = new Dictionary();
         transitions[QuestMessage.QUEST_ADDED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.QUEST_SET_ACTIVE] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.QUEST_SET_INACTIVE] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.QUEST_COMPLETED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.QUEST_FAILED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.OBJECTIVE_ADDED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.OBJECTIVE_COMPLETED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.OBJECTIVE_DISPLAYED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.OBJECTIVE_FAILED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.OBJECTIVE_DORMANT] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.HDT_QUEST_TEXT_UPDATED] = QuestState.STATE_ANIMATING;
         transitions[QuestMessage.LOCATION_DISCOVERED] = QuestState.STATE_ANIMATING;
         this.StateMachine.addState(new QuestState(QuestState.STATE_HIDDEN,transitions,{"update":function(param1:MovieClip, param2:Object):*
         {
            param1.visible = false;
         }}));
         this.StateMachine.addState(new QuestState(QuestState.STATE_ALWAYS_UP,transitions,{"update":function(param1:MovieClip, param2:Object):*
         {
            param1.visible = true;
         }}));
         transitions = new Dictionary();
         this.StateMachine.addState(new QuestState(QuestState.STATE_ANIMATING,transitions,{"update":function(param1:MovieClip, param2:Object):*
         {
            param1.visible = true;
         }}));
      }
      
      private function UpdateButtonBackground() : *
      {
         this.SetMissionActiveButton_mc.Background_mc.Internal_mc.width = this.SetMissionActiveButton_mc.HoldButton_mc.width + this.BUTTON_PADDING;
      }
   }
}
