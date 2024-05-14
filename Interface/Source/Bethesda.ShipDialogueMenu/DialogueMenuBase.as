package
{
   import Components.SWFLoaderClip;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DialogueMenuBase extends IMenu
   {
       
      
      public var DialogueList_mc:BSScrollingContainer;
      
      public var PersuasionList_mc:PersuasionList;
      
      public var PersuasionData_mc:MovieClip;
      
      public var ButtonBar_mc:DialogueButtonBar;
      
      public var PrecognitionData_mc:MovieClip;
      
      public var CrewSkillsWidget_mc:SWFLoaderClip;
      
      protected const ENTER_STATE:int = EnumHelper.GetEnum(0);
      
      protected const EXIT_STATE:int = EnumHelper.GetEnum();
      
      protected const LOOSE_MOUSE_CLICK:int = EnumHelper.GetEnum();
      
      protected const CHOICE_DATA_RECEIVED:int = EnumHelper.GetEnum();
      
      protected const SPEECH_CHALLENGE_DATA_RECEIVED:int = EnumHelper.GetEnum();
      
      protected const LIST_ITEM_PRESS:int = EnumHelper.GetEnum();
      
      protected const LOOSE_ACCEPT_PRESS:int = EnumHelper.GetEnum();
      
      protected const AUTOWIN_PRESS:int = EnumHelper.GetEnum();
      
      protected const CANCEL_PRESS:int = EnumHelper.GetEnum();
      
      protected const AUTO_SKIP:int = EnumHelper.GetEnum();
      
      protected const PERUSASION_RESULT_NONE:int = EnumHelper.GetEnum(0);
      
      protected const PERUSASION_RESULT_WIN:int = EnumHelper.GetEnum();
      
      protected const PERUSASION_RESULT_FAIL:int = EnumHelper.GetEnum();
      
      protected const PERUSASION_RESULT_CRIT_WIN:int = EnumHelper.GetEnum();
      
      protected var m_State:Function;
      
      protected var CrewDataObj:Object = null;
      
      protected var CrewDataSpeaker:String = "";
      
      protected var AutoSkipDialogue:Boolean = false;
      
      protected var bCanExitDialogueState:Boolean = false;
      
      protected var bCanExitMenuState:Boolean = false;
      
      protected var DataInitialized:Boolean = false;
      
      protected var SpeakingToCrew:Boolean = false;
      
      protected var QueueCrewWidgetRefresh:* = false;
      
      protected var IgnoreListInputTimer:Timer;
      
      protected const IGNORE_INPUT_ON_LIST_OPEN_TIME:uint = 1000;
      
      public const EVENT_ON_DIALOGUE_SELECT:String = "DialogueMenu_OnDialogueSelect";
      
      public const EVENT_SKIP_DIALOGUE:String = "DialogueMenu_RequestSkipDialogue";
      
      public const EVENT_CLOSE_MENU:String = "DialogueMenu_RequestExit";
      
      public const EVENT_FINISH_CLOSE_MENU:String = "DialogueMenu_CompleteExit";
      
      public const EVENT_ON_LIST_VISIBILITY_CHANGE:String = "DialogueMenu_OnListVisibilityChange";
      
      public const EVENT_ON_PERSUASION_AUTOWIN:String = "DialogueMenu_OnPersuasionAutoWin";
      
      public const TIMELINE_EVENT_CLOSE_LIST_ANIM_DONE:String = "onListFinishedClosingAnim";
      
      public const TIMELINE_EVENT_CLOSE_DATA_ANIM_DONE:String = "onDataFinishedClosingAnim";
      
      public function DialogueMenuBase()
      {
         var configParams:BSScrollingConfigParams;
         var persuasionButton:ProgressButton;
         this.m_State = this.state_Subtitles;
         super();
         this.DialogueList_mc.visible = false;
         this.DialogueList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemPress);
         this.DialogueList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.playFocusSound);
         this.DialogueList_mc.addEventListener(this.TIMELINE_EVENT_CLOSE_LIST_ANIM_DONE,this.onDialogueListCloseAnimFinished);
         this.DialogueList_mc.Configure(this.GetDialogListParams());
         this.DialogueList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return param1.bCanBeChosen !== false;
         },false);
         this.PersuasionList_mc.visible = false;
         this.PersuasionList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemPress);
         this.PersuasionList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.playFocusSound);
         this.PersuasionList_mc.addEventListener(this.TIMELINE_EVENT_CLOSE_LIST_ANIM_DONE,this.onPersuasionListCloseAnimFinished);
         addEventListener(DialogueEntryBase.EVENT_ON_ROLLOVER,this.onEntryRollover);
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "PersuasionListEntry";
         configParams.MultiLine = true;
         this.PersuasionList_mc.Configure(configParams);
         this.PersuasionData_mc.addEventListener(PersuasionData.CLOSE_PERSUASION_DATA_AFTER_SUCCESS_FAIL,this.onClosePersuasionDataAfterSuccessFailTimer);
         this.PersuasionData_mc.addEventListener(this.TIMELINE_EVENT_CLOSE_DATA_ANIM_DONE,this.onPersuasionDataCloseAnimFinished);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         persuasionButton = this.ButtonBar_mc.Persuasion_AutoWinButton_mc;
         persuasionButton.SetButtonData(new ButtonBaseData("$Persuasion_AutoWin",new UserEventData("XButton",this.onAutoWinClick),false,false));
         this.ButtonBar_mc.AddButton(this.ButtonBar_mc.Persuasion_AutoWinButton_mc);
         this.ButtonBar_mc.CancelButton_mc.SetButtonData(new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.onCancelClick),true,false));
         this.ButtonBar_mc.AddButton(this.ButtonBar_mc.CancelButton_mc);
         this.ButtonBar_mc.RefreshButtons();
         this.IgnoreListInputTimer = new Timer(this.IGNORE_INPUT_ON_LIST_OPEN_TIME);
         this.IgnoreListInputTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onIgnoreInputComplete);
         this.m_State(this.ENTER_STATE);
         BSUIDataManager.Subscribe("DialogueListData",this.onChoiceListUpdate);
         BSUIDataManager.Subscribe("PersuasionListData",this.onPersuasionListUpdate);
         BSUIDataManager.Subscribe("PersuasionPointsData",this.onPersuasionPointsUpdate);
         BSUIDataManager.Subscribe("DialogueData",this.onDataUpdate);
      }
      
      protected function GetDialogListParams() : BSScrollingConfigParams
      {
         return new BSScrollingConfigParams();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.ButtonBar_mc.gotoAndPlay("Open");
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
      }
      
      protected function onChoiceListUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.aChoices.length > 0)
         {
            this.DialogueList_mc.InitializeEntries(param1.data.aChoices);
            this.TransitionToState(this.state_ChoiceList);
         }
      }
      
      protected function onPersuasionListUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.aChoices.length > 0)
         {
            this.PersuasionList_mc.InitializeEntries(param1.data.aChoices);
            this.TransitionToState(this.state_PersuasionList);
         }
      }
      
      protected function onPersuasionPointsUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.uMaxPersuasionScore > 0)
         {
            this.PersuasionData_mc.numTurns = param1.data.uTurnsLeft;
            this.PersuasionData_mc.maxPersuasionScore = param1.data.uMaxPersuasionScore;
            switch(param1.data.uChallengeResult)
            {
               case this.PERUSASION_RESULT_WIN:
                  this.PersuasionData_mc.PlayAutoWinAnim(true);
                  break;
               case this.PERUSASION_RESULT_CRIT_WIN:
                  this.PersuasionData_mc.SetPersuasionScore(param1.data.uMaxPersuasionScore);
                  this.PersuasionData_mc.PlayCriticalSuccessAnim();
                  break;
               case this.PERUSASION_RESULT_FAIL:
                  this.PersuasionData_mc.PlayFailureAnim();
                  break;
               default:
                  this.PersuasionData_mc.SetPersuasionScore(param1.data.uPersuasionScore,param1.data.uPrevAttemptedChoiceValue);
            }
            this.ButtonBar_mc.Persuasion_AutoWinButton_mc.FillPercent = param1.data.fAutoSuccessPct;
            this.ButtonBar_mc.Persuasion_AutoWinButton_mc.Enabled = param1.data.fAutoSuccessPct == 1;
         }
      }
      
      protected function onDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         this.bCanExitDialogueState = param1.data.bCanExitDialogueState;
         this.UpdateCancelButtonState();
         if(this.AutoSkipDialogue != param1.data.bAutoSkip)
         {
            this.AutoSkipDialogue = param1.data.bAutoSkip;
            if(this.AutoSkipDialogue)
            {
               this.m_State(this.AUTO_SKIP);
            }
         }
         _loc2_ = 0;
         _loc3_ = param1.data.CrewmemberData != null && param1.data.CrewmemberData.uType != _loc2_;
         _loc4_ = this.CrewDataSpeaker.length != 0 && this.CrewDataSpeaker != param1.data.sSpeakerName;
         var _loc5_:Boolean;
         if((_loc5_ = _loc3_ && !_loc4_) != this.SpeakingToCrew)
         {
            if(_loc5_)
            {
               this.CrewDataSpeaker = param1.data.sSpeakerName;
               this.CrewDataObj = param1.data.CrewmemberData;
            }
            this.SpeakingToCrew = _loc3_ && !_loc4_;
            if(!this.DataInitialized || !this.SpeakingToCrew)
            {
               this.RefreshCrewWidget();
            }
            else if(!_loc4_)
            {
               this.QueueCrewWidgetRefresh = true;
            }
         }
         if(param1.data.bClosingMenu)
         {
            this.FinishClosingMenu();
         }
         this.DataInitialized = true;
      }
      
      protected function RefreshCrewWidget() : void
      {
         var _loc1_:* = undefined;
         if(this.SpeakingToCrew)
         {
            if(this.CrewSkillsWidget_mc.numChildren == 0)
            {
               _loc1_ = "DialogueCrewSkillsWidget";
               this.CrewSkillsWidget_mc.SWFLoad(_loc1_,this.onCrewSkillsLoad);
            }
         }
         else if(this.CrewSkillsWidget_mc.numChildren > 0)
         {
            this.CrewSkillsWidget_mc.forceUnload();
         }
      }
      
      protected function ProcessCrewWidgetRefresh() : void
      {
         if(this.QueueCrewWidgetRefresh)
         {
            this.RefreshCrewWidget();
            this.QueueCrewWidgetRefresh = false;
         }
      }
      
      protected function UpdateCancelButtonState() : void
      {
         var _loc1_:Boolean = this.bCanExitDialogueState && this.bCanExitMenuState;
         if(this.ButtonBar_mc.CancelButton_mc.Visible != _loc1_)
         {
            this.ButtonBar_mc.CancelButton_mc.Visible = _loc1_;
            this.ButtonBar_mc.CancelButton_mc.Enabled = _loc1_;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      protected function FinishClosingMenu() : *
      {
         BSUIDataManager.dispatchCustomEvent(this.EVENT_FINISH_CLOSE_MENU);
      }
      
      protected function onCrewSkillsLoad(param1:DisplayObject) : void
      {
         if(param1 != null && param1 is CrewSkillsWidget)
         {
            (param1 as CrewSkillsWidget).SetCrewData(this.CrewDataObj);
         }
      }
      
      protected function onEntryRollover(param1:Event) : void
      {
         this.ShowPrecogText();
      }
      
      protected function ShowPrecogText() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:* = null;
         if(this.DialogueList_mc.visible)
         {
            _loc1_ = this.DialogueList_mc.selectedEntry;
         }
         if(_loc1_ != null && _loc1_.sResponseText != null && _loc1_.sResponseText.length > 0)
         {
            _loc2_ = 125;
            GlobalFunc.SetText(this.PrecognitionData_mc.textField_tf,_loc1_.sResponseText,false,false,_loc2_);
            this.PrecognitionData_mc.visible = true;
         }
         else
         {
            this.PrecognitionData_mc.visible = false;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            switch(param1)
            {
               case "Accept":
               case "Cancel":
                  if(stage.focus == null)
                  {
                     this.m_State(this.LOOSE_ACCEPT_PRESS);
                     _loc3_ = true;
                  }
            }
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      protected function onCancelClick() : void
      {
         this.m_State(this.CANCEL_PRESS);
      }
      
      protected function onAutoWinClick() : void
      {
         this.m_State(this.AUTOWIN_PRESS);
         GlobalFunc.PlayMenuSound("UIMenuSpeechChallengeCharismaSpend");
      }
      
      protected function onMouseRelease(param1:MouseEvent) : void
      {
         if(this.m_State == this.state_Subtitles)
         {
            this.m_State(this.LOOSE_MOUSE_CLICK);
         }
      }
      
      protected function onItemPress() : *
      {
         this.m_State(this.LIST_ITEM_PRESS);
      }
      
      protected function playFocusSound() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralFocus");
      }
      
      protected function onDialogueListCloseAnimFinished() : void
      {
         this.DialogueList_mc.visible = false;
      }
      
      protected function onPersuasionListCloseAnimFinished() : void
      {
         this.PersuasionList_mc.visible = false;
      }
      
      protected function onPersuasionDataCloseAnimFinished() : void
      {
         this.PersuasionData_mc.visible = false;
      }
      
      protected function ShowPersuasionDataElems() : void
      {
         if(!this.PersuasionData_mc.visible)
         {
            this.ButtonBar_mc.Persuasion_AutoWinButton_mc.Visible = true;
            this.ButtonBar_mc.RefreshButtons();
            this.PersuasionData_mc.ResetGameElements();
            this.PersuasionData_mc.gotoAndPlay("Open_PersuasionData");
            this.PersuasionData_mc.visible = true;
         }
      }
      
      protected function onClosePersuasionDataAfterSuccessFailTimer(param1:Event) : *
      {
         this.HidePersuasionDataElems();
      }
      
      protected function HidePersuasionDataElems() : void
      {
         this.ButtonBar_mc.Persuasion_AutoWinButton_mc.Visible = false;
         this.ButtonBar_mc.RefreshButtons();
         this.PersuasionData_mc.HidePersuasionDataElements();
      }
      
      protected function TransitionToState(param1:Function) : void
      {
         this.m_State(this.EXIT_STATE);
         this.m_State = param1;
         this.m_State(this.ENTER_STATE);
         if(this.AutoSkipDialogue)
         {
            this.m_State(this.AUTO_SKIP);
         }
      }
      
      protected function state_Subtitles(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_LIST_VISIBILITY_CHANGE,{"isVisible":false});
               this.bCanExitMenuState = false;
               this.UpdateCancelButtonState();
               this.PrecognitionData_mc.visible = false;
               this.ProcessCrewWidgetRefresh();
               break;
            case this.CHOICE_DATA_RECEIVED:
               this.TransitionToState(this.state_ChoiceList);
               break;
            case this.SPEECH_CHALLENGE_DATA_RECEIVED:
               this.TransitionToState(this.state_PersuasionList);
               break;
            case this.LOOSE_MOUSE_CLICK:
            case this.LOOSE_ACCEPT_PRESS:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_SKIP_DIALOGUE);
               break;
            case this.AUTO_SKIP:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_SKIP_DIALOGUE);
               if(!hasEventListener(Event.ENTER_FRAME))
               {
                  addEventListener(Event.ENTER_FRAME,this.spamAutoSkip);
               }
               break;
            case this.EXIT_STATE:
               removeEventListener(Event.ENTER_FRAME,this.spamAutoSkip);
         }
      }
      
      private function spamAutoSkip(param1:Event) : void
      {
         this.m_State(this.AUTO_SKIP);
      }
      
      protected function state_ChoiceList(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.HidePersuasionDataElems();
               this.DialogueList_mc.scrollPosition = 0;
               this.DialogueList_mc.SetInitSelection();
               stage.focus = this.DialogueList_mc;
               this.DialogueList_mc.gotoAndPlay("Open_Dialogue");
               this.DialogueList_mc.visible = true;
               BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_LIST_VISIBILITY_CHANGE,{"isVisible":true});
               this.ShowPrecogText();
               this.bCanExitMenuState = true;
               this.UpdateCancelButtonState();
               this.ProcessCrewWidgetRefresh();
               if(!this.IgnoreListInputTimer.running)
               {
                  this.IgnoreListInputTimer.start();
               }
               break;
            case this.LIST_ITEM_PRESS:
            case this.AUTO_SKIP:
               if(!this.IgnoreListInputTimer.running && Boolean(this.DialogueList_mc.selectedEntry.bCanBeChosen))
               {
                  this.ChoiceListOnListItemPress();
               }
               break;
            case this.CANCEL_PRESS:
               if(!this.IgnoreListInputTimer.running && Boolean(this.ButtonBar_mc.CancelButton_mc.Enabled))
               {
                  BSUIDataManager.dispatchCustomEvent(this.EVENT_CLOSE_MENU);
               }
               break;
            case this.EXIT_STATE:
               this.IgnoreListInputTimer.reset();
               stage.focus = null;
               this.DialogueList_mc.gotoAndPlay("Close_Dialogue");
         }
      }
      
      protected function onIgnoreInputComplete() : void
      {
         this.IgnoreListInputTimer.reset();
      }
      
      protected function ChoiceListOnListItemPress() : *
      {
         BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_DIALOGUE_SELECT,{"selectedIndex":this.DialogueList_mc.selectedEntry.uEntryID});
         this.TransitionToState(this.state_Subtitles);
         if(this.DialogueList_mc.selectedEntry.bIsSpeechChallenge)
         {
            GlobalFunc.PlayMenuSound("UIMenuSpeechChallengeGameStart");
         }
      }
      
      protected function state_PersuasionList(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ShowPersuasionDataElems();
               this.PersuasionList_mc.scrollPosition = 0;
               this.PersuasionList_mc.SetInitSelection();
               stage.focus = this.PersuasionList_mc;
               this.PersuasionList_mc.gotoAndPlay("Open_Persuasion");
               this.PersuasionList_mc.visible = true;
               this.bCanExitMenuState = true;
               this.UpdateCancelButtonState();
               this.ButtonBar_mc.Persuasion_AutoWinButton_mc.Enabled = this.ButtonBar_mc.Persuasion_AutoWinButton_mc.FillPercent == 1;
               this.ButtonBar_mc.RefreshButtons();
               BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_LIST_VISIBILITY_CHANGE,{"isVisible":true});
               this.ProcessCrewWidgetRefresh();
               if(!this.IgnoreListInputTimer.running)
               {
                  this.IgnoreListInputTimer.start();
               }
               break;
            case this.LIST_ITEM_PRESS:
            case this.AUTO_SKIP:
               if(!this.IgnoreListInputTimer.running)
               {
                  this.PersuasionData_mc.QueueTurnsChangeAnim();
                  BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_DIALOGUE_SELECT,{"selectedIndex":this.PersuasionList_mc.selectedEntry.uEntryID});
                  this.TransitionToState(this.state_Subtitles);
               }
               break;
            case this.AUTOWIN_PRESS:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_PERSUASION_AUTOWIN);
               this.PersuasionData_mc.PlayAutoWinAnim(false);
               this.TransitionToState(this.state_Subtitles);
               break;
            case this.CANCEL_PRESS:
               if(!this.IgnoreListInputTimer.running && Boolean(this.ButtonBar_mc.CancelButton_mc.Enabled))
               {
                  this.TransitionToState(this.state_Subtitles);
                  BSUIDataManager.dispatchCustomEvent(this.EVENT_CLOSE_MENU);
               }
               break;
            case this.EXIT_STATE:
               this.IgnoreListInputTimer.reset();
               stage.focus = null;
               this.ButtonBar_mc.Persuasion_AutoWinButton_mc.Enabled = false;
               this.ButtonBar_mc.RefreshButtons();
               this.PersuasionList_mc.gotoAndPlay("Close_Persuasion");
         }
      }
   }
}
