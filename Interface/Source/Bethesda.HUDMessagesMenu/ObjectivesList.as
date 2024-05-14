package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ObjectivesList extends MovieClip
   {
      
      private static const OBJECTIVE_SPACING:uint = 2;
      
      public static const CUE_MOVE_UP_OBJECTIVES:String = "CueMoveUpObjectives";
      
      private static const TRANSITION_TO_ALWAYS_UP:String = "TransitionToAlwaysUp";
      
      private static const HIDE_OBJECTIVE:String = "HideObjective";
      
      private static const HIDE_ALWAYS_UP_OBJECTIVE:String = "HideAlwaysUpObjective";
      
      private static const SHOW_OBJECTIVE_ANIM:String = "ShowObjectiveAnim";
      
      private static const SHOW_NEW_OBJECTIVE_ANIM:String = "ShowNewObjectiveAnim";
      
      private static const SHOW_FAIL_ANIM:String = "ShowFailAnim";
      
      private static const HIDE_FAILED_ANIM:String = "HideFailed";
      
      private static const HIDE_COMPLETED_ANIM:String = "HideCompleted";
      
      public static const OBJECTIVES_FINISHED:String = "ObjectivesFinished";
      
      public static const OBJECTIVES_HIDDEN:String = "ObjectivesHidden";
      
      private static const COMPLETED_OBJECTIVE_MAX_CHARS:uint = 28;
      
      private static const OBJECTIVE_MAX_CHARS:uint = 31;
      
      private static const OBJECTIVE_MOVE_SPEED:uint = 3;
       
      
      protected var ObjectiveEntriesA:Array;
      
      protected var bHidden:Boolean = false;
      
      protected var bCompletedFailedAnimDone:Boolean = false;
      
      protected var bAlwaysUp:Boolean = false;
      
      protected var iStartingMovementIndex:int = -1;
      
      protected var topMovementPosition:Number = 0;
      
      private var NewObjectiveTimer:Timer = null;
      
      public function ObjectivesList()
      {
         this.ObjectiveEntriesA = new Array();
         super();
      }
      
      public function ShowQuestObjectives(param1:Array) : *
      {
         var _loc4_:ObjectivesListEntry = null;
         visible = true;
         this.bHidden = false;
         this.bAlwaysUp = false;
         while(this.ObjectiveEntriesA.length > 0)
         {
            this.removeChild(this.ObjectiveEntriesA[0].Clip);
            this.ObjectiveEntriesA.splice(0,1);
         }
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(!param1[_loc3_].bDormant)
            {
               (_loc4_ = new ObjectivesListEntry()).Create(param1[_loc3_]);
               _loc4_.addEventListener(ObjectivesListEntry.OBJECTIVE_TEXT_HIDDEN_EVENT,this.OnObjectiveListEntryTextHidden);
               this.addChild(_loc4_.Clip);
               _loc4_.SetText(param1[_loc3_].strObjectiveText);
               _loc4_.Clip.y = _loc2_;
               _loc2_ += _loc4_.Clip.height + OBJECTIVE_SPACING;
               this.ObjectiveEntriesA.push(_loc4_);
               if(param1[_loc3_].bAdded)
               {
                  if(this.NewObjectiveTimer != null)
                  {
                     this.NewObjectiveTimer.reset();
                  }
                  else
                  {
                     this.NewObjectiveTimer = new Timer(33,1);
                     this.NewObjectiveTimer.addEventListener(TimerEvent.TIMER,this.handleNewObjectiveTimer);
                  }
                  this.NewObjectiveTimer.start();
                  _loc4_.Clip.gotoAndPlay(SHOW_NEW_OBJECTIVE_ANIM);
               }
               else if(param1[_loc3_].bFailed)
               {
                  _loc4_.Clip.gotoAndPlay(SHOW_FAIL_ANIM);
               }
               else
               {
                  _loc4_.Clip.gotoAndPlay(SHOW_OBJECTIVE_ANIM);
               }
            }
            _loc3_++;
         }
         if(this.ObjectiveEntriesA.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.ObjectiveEntriesA.length)
            {
               this.ObjectiveEntriesA[_loc3_].Clip.addEventListener(CUE_MOVE_UP_OBJECTIVES,this.CueMoveUpObjectives);
               _loc3_++;
            }
         }
         else
         {
            addEventListener(Event.ENTER_FRAME,this.AnimateObjectivesUp,false,0,true);
         }
      }
      
      public function handleNewObjectiveTimer(param1:TimerEvent) : *
      {
         GlobalFunc.PlayMenuSound("UIQuestObjectiveNew");
         this.NewObjectiveTimer = null;
      }
      
      public function PlayShowAnimations() : *
      {
         visible = true;
         this.bHidden = false;
         this.bAlwaysUp = false;
         var _loc1_:uint = 0;
         while(_loc1_ < this.ObjectiveEntriesA.length)
         {
            this.ObjectiveEntriesA[_loc1_].Clip.gotoAndPlay(SHOW_OBJECTIVE_ANIM);
            _loc1_++;
         }
      }
      
      public function UpdateQuestObjectives(param1:Array) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:ObjectivesListEntry = null;
         if(this.ObjectiveEntriesA.length <= 0 || param1.length >= this.ObjectiveEntriesA.length)
         {
            this.ShowQuestObjectives(param1);
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.ObjectiveEntriesA.length)
               {
                  _loc4_ = this.ObjectiveEntriesA[_loc3_];
                  if(param1[_loc2_].uID === _loc4_.UID && param1[_loc2_].uID != 0)
                  {
                     _loc4_.SetText(param1[_loc2_].strObjectiveText);
                     break;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
      }
      
      public function HasVisibleObjectiveEntries() : Boolean
      {
         return this.ObjectiveEntriesA.length > 0;
      }
      
      protected function CueMoveUpObjectives(param1:Event) : *
      {
         var _loc3_:ObjectivesListEntry = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.ObjectiveEntriesA.length != 0)
         {
            addEventListener(Event.ENTER_FRAME,this.AnimateObjectivesUp,false,0,true);
         }
         this.iStartingMovementIndex = -1;
         this.topMovementPosition = 0;
         this.bCompletedFailedAnimDone = false;
         this.bAlwaysUp = false;
         var _loc2_:uint = 0;
         while(_loc2_ < this.ObjectiveEntriesA.length)
         {
            _loc3_ = this.ObjectiveEntriesA[_loc2_];
            _loc3_.Clip.removeEventListener(CUE_MOVE_UP_OBJECTIVES,this.CueMoveUpObjectives);
            if(_loc3_.Completed)
            {
               _loc3_.Clip.gotoAndPlay(HIDE_COMPLETED_ANIM);
               if(this.iStartingMovementIndex == -1)
               {
                  this.iStartingMovementIndex = _loc2_;
                  this.topMovementPosition = 0;
                  _loc4_ = 0;
                  while(_loc4_ < this.iStartingMovementIndex)
                  {
                     this.topMovementPosition += this.ObjectiveEntriesA[_loc4_].Clip.height + OBJECTIVE_SPACING;
                     _loc4_++;
                  }
               }
            }
            else if(_loc3_.Failed)
            {
               _loc3_.Clip.gotoAndPlay(HIDE_FAILED_ANIM);
               if(this.iStartingMovementIndex == -1)
               {
                  this.iStartingMovementIndex = _loc2_;
                  this.topMovementPosition = 0;
                  _loc5_ = 0;
                  while(_loc5_ < this.iStartingMovementIndex)
                  {
                     this.topMovementPosition += this.ObjectiveEntriesA[_loc5_].Clip.height + OBJECTIVE_SPACING;
                     _loc5_++;
                  }
               }
            }
            else if(_loc3_.Dormant)
            {
               this.ObjectiveEntriesA[_loc2_].Clip.gotoAndPlay(HIDE_OBJECTIVE);
            }
            _loc2_++;
         }
      }
      
      protected function AnimateObjectivesUp() : *
      {
         var _loc6_:ObjectivesListEntry = null;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc1_:Boolean = true;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         visible = true;
         this.bHidden = false;
         var _loc5_:uint = this.iStartingMovementIndex != -1 ? uint(this.iStartingMovementIndex) : 0;
         while(_loc5_ < this.ObjectiveEntriesA.length)
         {
            if(!(_loc6_ = this.ObjectiveEntriesA[_loc5_]).Completed && !_loc6_.Failed)
            {
               _loc2_ ||= _loc6_.Clip.y <= this.topMovementPosition;
               _loc7_ = _loc6_.Clip.y;
               if(_loc2_)
               {
                  _loc6_.Clip.y -= _loc3_;
               }
               else
               {
                  _loc6_.Clip.y -= OBJECTIVE_MOVE_SPEED;
               }
               if(_loc6_.Clip.y < this.topMovementPosition)
               {
                  _loc6_.Clip.y = this.topMovementPosition;
               }
               if(_loc6_.Clip.y != _loc7_)
               {
                  _loc1_ = false;
               }
               else
               {
                  _loc1_ ||= _loc6_.Clip.y <= this.topMovementPosition;
               }
               if(!_loc2_ && _loc6_.Clip.y < OBJECTIVE_MOVE_SPEED)
               {
                  _loc2_ = true;
                  _loc3_ = Math.max(_loc6_.Clip.y,this.topMovementPosition);
               }
            }
            else
            {
               _loc4_++;
            }
            _loc5_++;
         }
         if(_loc4_ == this.ObjectiveEntriesA.length)
         {
            _loc1_ = true;
         }
         if(_loc1_ && this.bCompletedFailedAnimDone)
         {
            _loc8_ = 0;
            while(_loc8_ < this.ObjectiveEntriesA.length)
            {
               if(Boolean(this.ObjectiveEntriesA[_loc8_].Completed) || Boolean(this.ObjectiveEntriesA[_loc8_].Failed))
               {
                  this.removeChild(this.ObjectiveEntriesA[_loc8_].Clip);
                  this.ObjectiveEntriesA.splice(_loc8_,1);
               }
               else
               {
                  _loc8_++;
               }
            }
            removeEventListener(Event.ENTER_FRAME,this.AnimateObjectivesUp);
            dispatchEvent(new Event(OBJECTIVES_FINISHED));
         }
      }
      
      public function TransitionToAlwaysUp() : *
      {
         visible = true;
         this.bHidden = false;
         this.bAlwaysUp = true;
         var _loc1_:uint = 0;
         while(_loc1_ < this.ObjectiveEntriesA.length)
         {
            if(!this.ObjectiveEntriesA[_loc1_].Completed && !this.ObjectiveEntriesA[_loc1_].Failed)
            {
               this.ObjectiveEntriesA[_loc1_].Clip.gotoAndPlay(TRANSITION_TO_ALWAYS_UP);
            }
            _loc1_++;
         }
      }
      
      public function AreObjectivesHidden() : Boolean
      {
         return !visible || this.bHidden;
      }
      
      public function AreObjectivesHiding() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.ObjectiveEntriesA.length > 0)
         {
            _loc1_ = this.ObjectiveEntriesA[0].Clip.currentFrameLabel == HIDE_OBJECTIVE || this.ObjectiveEntriesA[0].Clip.currentFrameLabel == HIDE_COMPLETED_ANIM || this.ObjectiveEntriesA[0].Clip.currentFrameLabel == HIDE_FAILED_ANIM;
         }
         return _loc1_;
      }
      
      public function HideObjectives(param1:Boolean = true) : *
      {
         visible = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < this.ObjectiveEntriesA.length)
         {
            if(!this.ObjectiveEntriesA[_loc2_].Completed && !this.ObjectiveEntriesA[_loc2_].Failed)
            {
               this.ObjectiveEntriesA[_loc2_].Clip.gotoAndPlay(this.bAlwaysUp ? HIDE_ALWAYS_UP_OBJECTIVE : HIDE_OBJECTIVE);
            }
            _loc2_++;
         }
      }
      
      private function OnObjectiveListEntryTextHidden(param1:Event) : *
      {
         var _loc2_:* = undefined;
         this.bHidden = true;
         for each(_loc2_ in this.ObjectiveEntriesA)
         {
            if(_loc2_.Clip.currentFrameLabel != HIDE_OBJECTIVE && _loc2_.Clip.currentFrameLabel != HIDE_COMPLETED_ANIM && _loc2_.Clip.currentFrameLabel != HIDE_FAILED_ANIM)
            {
               this.bHidden = false;
               break;
            }
         }
         this.bCompletedFailedAnimDone = true;
         dispatchEvent(new Event(OBJECTIVES_HIDDEN));
      }
   }
}
