package
{
   import HUD.QuestUpdateStates.QuestMessage;
   import Shared.AS3.Patterns.TimelineStateMachine;
   import Shared.GlobalFunc;
   import Shared.QuestUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class QuestText extends MovieClip
   {
      
      public static const STATUS_FADE_OUT:String = "StatusFadeOut";
      
      public static const QUEST_TEXT_HIDDEN_EVENT:String = "QuestTextHiddenEvent";
      
      private static const QUEST_TEXT_MAX_CHARS:uint = 27;
      
      public static const STATE_HIDDEN:String = "Hidden";
      
      public static const STATE_ALWAYS_UP:String = "AlwaysUp";
      
      public static const STATE_NEW_QUEST:String = "NewQuest";
      
      public static const STATE_SHOWN:String = "Shown";
      
      public static const STATE_COMPLETE_QUEST:String = "QuestComplete";
      
      public static const STATE_COMPLETE_OBJECTIVE:String = "ObjectiveComplete";
      
      public static const STATE_FAILED_QUEST:String = "QuestFail";
      
      public static const STATE_LOCATION_FOUND:String = "LocationFound";
      
      public static const FACTION_UPDATE:String = "FactionUpdate";
       
      
      internal var QuestTextClip:MovieClip;
      
      internal var iFaction:int = 0;
      
      internal var iType:int = 0;
      
      internal var ObjectiveCompleteSoundTimer:Timer = null;
      
      protected var QuestUpdateData:Object;
      
      protected var StateMachine:TimelineStateMachine;
      
      private var OnlyShowQuestUpdates:Boolean;
      
      public function QuestText()
      {
         super();
         this.StateMachine = new TimelineStateMachine();
         this.configureStates();
         this.StateMachine.startingState(STATE_HIDDEN);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
      }
      
      public function set onlyShowQuestUpdates(param1:Boolean) : *
      {
         this.OnlyShowQuestUpdates = param1;
         this.changeAnimationStateForAlwaysUp();
      }
      
      public function get onlyShowQuestUpdates() : *
      {
         return this.OnlyShowQuestUpdates;
      }
      
      public function CanShowQuestUpdate() : Boolean
      {
         var _loc1_:* = this.StateMachine.getCurrentStateId();
         return _loc1_ == STATE_ALWAYS_UP;
      }
      
      protected function ShowQuestUpdate(param1:Object) : *
      {
         if(this.QuestTextClip)
         {
            this.QuestTextClip.removeEventListener(STATUS_FADE_OUT,this.onAnimationCompleted);
            this.removeChild(this.QuestTextClip);
            this.QuestTextClip = null;
         }
         if(param1.iRemainingTime >= 0)
         {
            this.QuestTextClip = new QuestTextWidgetTimeRemaining();
         }
         else if(param1.strQuestName.length > QUEST_TEXT_MAX_CHARS)
         {
            this.QuestTextClip = new QuestTextWidgetLong();
         }
         else
         {
            this.QuestTextClip = new QuestTextWidget();
         }
         this.QuestTextClip.addEventListener(STATUS_FADE_OUT,this.onAnimationCompleted);
         this.QuestTextClip.addEventListener(QuestUpdate.HIDE_QUEST_UPDATE,this.onQuestTextHiddenAnimationComplete);
         if(param1.strQuestName.length > QUEST_TEXT_MAX_CHARS)
         {
            GlobalFunc.SetTwoLineText(this.QuestTextClip.QuestTitleText_mc.QuestName_tf,param1.strQuestName,QUEST_TEXT_MAX_CHARS);
         }
         else
         {
            GlobalFunc.SetText(this.QuestTextClip.QuestTitleText_mc.QuestName_tf,param1.strQuestName);
         }
         this.iFaction = param1.iFaction;
         this.iType = param1.iQuestType;
         this.QuestTextClip.FactionIcon_mc.Icons_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.iFaction,this.iType));
         this.QuestTextClip.addEventListener(FACTION_UPDATE,this.OnFactionIconUpdate);
         this.UpdateQuestTimer(param1.iRemainingTime);
         this.addChild(this.QuestTextClip);
      }
      
      public function UpdateQuestTimer(param1:int) : *
      {
         if(this.QuestTextClip.QuestTimeRemaining_mc)
         {
            if(param1 < 0)
            {
               this.QuestTextClip.QuestTimeRemaining_mc.visible = false;
            }
            else
            {
               this.QuestTextClip.QuestTimeRemaining_mc.visible = true;
               GlobalFunc.SetText(this.QuestTextClip.QuestTimeRemaining_mc.QuestTimeRemaining_tf,GlobalFunc.GetQuestTimeRemainingString(param1));
            }
         }
      }
      
      protected function configureStates() : void
      {
         this.StateMachine.addState(STATE_HIDDEN,["*",{
            "state":STATE_SHOWN,
            "label":"ShownToFadeOut"
         },{
            "state":STATE_ALWAYS_UP,
            "label":"AlwaysUpToFadeOut"
         },{
            "state":STATE_NEW_QUEST,
            "label":"ShownToFadeOut"
         },{
            "state":STATE_COMPLETE_QUEST,
            "label":"ShownToFadeOut"
         },{
            "state":STATE_FAILED_QUEST,
            "label":"ShownToFadeOut"
         },{
            "state":STATE_COMPLETE_OBJECTIVE,
            "label":"ShownToFadeOut"
         },{
            "state":STATE_LOCATION_FOUND,
            "label":"ShownToFadeOut"
         }],{
            "enter":this.playStateTransition,
            "exit":this.onExitState
         },[QuestMessage.QUEST_SET_INACTIVE]);
         this.StateMachine.addState(STATE_ALWAYS_UP,[STATE_HIDDEN,STATE_SHOWN,{
            "state":STATE_NEW_QUEST,
            "label":"ShownToAlwaysUp"
         },{
            "state":STATE_COMPLETE_QUEST,
            "label":"ShownToAlwaysUp"
         },{
            "state":STATE_FAILED_QUEST,
            "label":"ShownToAlwaysUp"
         },{
            "state":STATE_COMPLETE_OBJECTIVE,
            "label":"ShownToAlwaysUp"
         },{
            "state":STATE_HIDDEN,
            "label":"HiddenToAlwaysUp"
         }],{
            "enter":this.playStateTransition,
            "exit":this.onExitState
         },[QuestMessage.QUEST_EXPERIENCE_AWARDED]);
         this.StateMachine.addState(STATE_SHOWN,[STATE_HIDDEN,{
            "state":STATE_ALWAYS_UP,
            "label":"AlwaysUpToQuestUpdate"
         }],{
            "enter":this.enterOnQuestUpdated,
            "exit":this.onExitState
         },[QuestMessage.QUEST_SET_ACTIVE,QuestMessage.OBJECTIVE_ADDED,QuestMessage.OBJECTIVE_DISPLAYED,QuestMessage.OBJECTIVE_FAILED,QuestMessage.OBJECTIVE_DORMANT,QuestMessage.HDT_QUEST_TEXT_UPDATED]);
         this.StateMachine.addState(STATE_NEW_QUEST,[{
            "state":STATE_HIDDEN,
            "label":"HiddenToShown"
         },{
            "state":STATE_ALWAYS_UP,
            "label":"ShownToAlwaysUp"
         }],{
            "enter":this.enterOnQuestAdded,
            "exit":this.exitOnQuestAdded
         },[QuestMessage.QUEST_ADDED]);
         this.StateMachine.addState(STATE_COMPLETE_QUEST,[STATE_ALWAYS_UP,{
            "state":STATE_HIDDEN,
            "label":"AlwaysUpToQuestComplete"
         }],{
            "enter":this.enterOnQuestCompleted,
            "exit":this.onExitState
         },[QuestMessage.QUEST_COMPLETED]);
         this.StateMachine.addState(STATE_FAILED_QUEST,[STATE_ALWAYS_UP,{
            "state":STATE_HIDDEN,
            "label":"AlwaysUpToQuestFail"
         }],{
            "enter":this.enterOnQuestFailed,
            "exit":this.onExitState
         },[QuestMessage.QUEST_FAILED]);
         this.StateMachine.addState(STATE_COMPLETE_OBJECTIVE,[{
            "state":STATE_ALWAYS_UP,
            "label":"AlwaysUpToQuestUpdate"
         },{
            "state":STATE_HIDDEN,
            "label":"AlwaysUpToQuestUpdate"
         }],{
            "enter":this.enterOnObjectiveCompleted,
            "exit":this.onExitState
         },[QuestMessage.OBJECTIVE_COMPLETED]);
         this.StateMachine.addState(STATE_LOCATION_FOUND,[{
            "state":STATE_ALWAYS_UP,
            "label":"AlwaysUpToQuestUpdate"
         },{
            "state":STATE_HIDDEN,
            "label":"AlwaysUpToQuestUpdate"
         }],{
            "enter":this.enterOnLocationDiscovered,
            "exit":this.onExitState
         },[QuestMessage.LOCATION_DISCOVERED]);
      }
      
      protected function playStateTransition(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         if(param1.label)
         {
            _loc2_ = String(param1.label);
         }
         else
         {
            if(param1.currentState)
            {
               _loc2_ = String(param1.currentState);
            }
            if(param1.fromState)
            {
               _loc2_ = param1.fromState + "To" + _loc2_;
            }
            if(this.QuestTextClip)
            {
               _loc3_ = GlobalFunc.FrameLabelExists(this.QuestTextClip,_loc2_);
               if(!_loc3_)
               {
                  _loc2_ = null;
                  GlobalFunc.TraceWarning("QuestText Unable to find frame " + _loc2_);
               }
            }
         }
         if(this.QuestTextClip && _loc2_ && _loc2_ !== currentLabel)
         {
            this.QuestTextClip.gotoAndPlay(_loc2_);
            this.QuestTextClip.FactionIcon_mc.Icons_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.iFaction,this.iType));
         }
      }
      
      protected function onExitState(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"");
      }
      
      public function getCurrentStateId() : Object
      {
         return this.StateMachine.getCurrentStateId();
      }
      
      public function processEvent(param1:Object) : void
      {
         this.ShowQuestUpdate(param1);
         this.QuestUpdateData = param1 || {};
         this.StateMachine.processEvent(this.QuestUpdateData.uType);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function changeState(param1:Object) : void
      {
         if(this.StateMachine)
         {
            this.StateMachine.changeState(param1);
            if(!hasEventListener(Event.ENTER_FRAME))
            {
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
         }
      }
      
      public function isHidden() : Boolean
      {
         var _loc1_:* = false;
         if(this.StateMachine)
         {
            _loc1_ = this.StateMachine.getCurrentStateId() == STATE_HIDDEN;
         }
         return _loc1_;
      }
      
      public function isAlwaysUp() : Boolean
      {
         var _loc1_:* = false;
         if(this.StateMachine)
         {
            _loc1_ = this.StateMachine.getCurrentStateId() == STATE_ALWAYS_UP;
         }
         return _loc1_;
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(this.QuestTextClip)
         {
            this.QuestTextClip.FactionIcon_mc.Icons_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.iFaction,this.iType));
         }
      }
      
      protected function onAnimationCompleted(param1:Event) : void
      {
         this.changeAnimationStateForAlwaysUp();
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function changeAnimationStateForAlwaysUp() : void
      {
         if(this.StateMachine)
         {
            if(this.QuestUpdateData && this.QuestUpdateData.bAlwaysUp == true && this.OnlyShowQuestUpdates == false)
            {
               this.StateMachine.changeState(STATE_ALWAYS_UP);
            }
            else
            {
               this.StateMachine.changeState(STATE_HIDDEN);
            }
         }
      }
      
      protected function onQuestTextHiddenAnimationComplete(param1:Event) : void
      {
         if(this.StateMachine.getCurrentStateId() == STATE_HIDDEN)
         {
            dispatchEvent(new Event(QUEST_TEXT_HIDDEN_EVENT));
         }
      }
      
      protected function OnFactionIconUpdate(param1:Event) : *
      {
         this.QuestTextClip.FactionIcon_mc.Icons_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(this.iFaction,this.iType));
      }
      
      public function enterOnQuestAdded(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$MissionNew");
         GlobalFunc.PlayMenuSound("UIQuestMissionNew");
         this.playStateTransition(param1);
      }
      
      public function exitOnQuestAdded(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$MissionAdded");
         GlobalFunc.PlayMenuSound("UIQuestMissionMenuAdd");
      }
      
      public function enterOnQuestCompleted(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$MissionComplete");
         GlobalFunc.PlayMenuSound("UIQuestMissionComplete");
         this.playStateTransition(param1);
      }
      
      public function enterOnQuestFailed(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$MissionFailed");
         this.playStateTransition(param1);
      }
      
      public function enterOnObjectiveCompleted(param1:Object) : void
      {
         if(this.ObjectiveCompleteSoundTimer != null)
         {
            this.ObjectiveCompleteSoundTimer.reset();
         }
         else
         {
            this.ObjectiveCompleteSoundTimer = new Timer(33,1);
            this.ObjectiveCompleteSoundTimer.addEventListener(TimerEvent.TIMER,this.handleObjectiveCompleteSoundTimer);
         }
         this.ObjectiveCompleteSoundTimer.start();
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$MissionUpdate");
         this.playStateTransition(param1);
      }
      
      public function handleObjectiveCompleteSoundTimer(param1:TimerEvent) : *
      {
         GlobalFunc.PlayMenuSound("UIQuestObjectiveComplete");
         this.ObjectiveCompleteSoundTimer = null;
      }
      
      public function enterOnLocationDiscovered(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$LocationDiscovered");
         this.playStateTransition(param1);
      }
      
      public function enterOnQuestUpdated(param1:Object) : void
      {
         GlobalFunc.SetText(this.QuestTextClip.MissionStatusText_mc.MissionStatus_tf,"$MissionUpdate");
         this.playStateTransition(param1);
      }
      
      public function destroy() : void
      {
         if(this.QuestTextClip)
         {
            this.QuestTextClip.removeEventListener(QuestUpdate.HIDE_QUEST_UPDATE,this.onQuestTextHiddenAnimationComplete);
            this.QuestTextClip.removeEventListener(STATUS_FADE_OUT,this.onAnimationCompleted);
            this.removeChild(this.QuestTextClip);
            this.QuestTextClip = null;
         }
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         this.StateMachine.destroy();
         this.StateMachine = null;
         this.QuestUpdateData = null;
      }
   }
}
