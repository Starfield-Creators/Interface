package
{
   import HUD.QuestUpdateStates.QuestMessage;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import scaleform.gfx.Extensions;
   
   public class HUDMessagesMenu extends IMenu
   {
      
      public static const REMOVE_QUEST_UPDATE:String = "RemoveQuestUpdate";
       
      
      public var Messages_mc:Messages;
      
      public var QuestUpdate_mc:MovieClip;
      
      public var XPGroup_mc:XPGroup;
      
      public var BottomCenterGroup_mc:MovieClip;
      
      public var SkillChallengeFlyout_mc:SkillChallengeFlyout;
      
      public var Location_mc:LocationTextWidget;
      
      public var LevelUpHolder_mc:MovieClip;
      
      private var QuestUpdateDataA:Array;
      
      private var QuestUpdatesA:Array;
      
      private var StartingQuestUpdatePosition:Point;
      
      private var ShowingQuestObjectives:Boolean = false;
      
      private const MAX_NUMBER_OF_QUESTS:int = 8;
      
      private const TALL_ASPECT_RATIO:Number = 1.6;
      
      public function HUDMessagesMenu()
      {
         this.QuestUpdateDataA = new Array();
         this.QuestUpdatesA = new Array();
         this.StartingQuestUpdatePosition = new Point(0,0);
         super();
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.Messages_mc,"R",SafeX,SafeY,true);
         GlobalFunc.LockToSafeRect(this.BottomCenterGroup_mc,"BC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.XPGroup_mc,"CC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.Location_mc,"CC",SafeX,SafeY);
         GlobalFunc.LockToSafeRect(this.LevelUpHolder_mc,"TC",SafeX,SafeY);
         var _loc1_:int = 0;
         while(_loc1_ < this.QuestUpdatesA.length)
         {
            GlobalFunc.LockToSafeRect(this.QuestUpdatesA[_loc1_],"L",SafeX,SafeY);
            _loc1_++;
         }
         Extensions.enabled = true;
         var _loc2_:Number = Extensions.visibleRect.width / Extensions.visibleRect.height;
         this.BottomCenterGroup_mc.SubtitleText_mc.tallAspectRatio = GlobalFunc.CloseToNumber(_loc2_,this.TALL_ASPECT_RATIO);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.StartingQuestUpdatePosition.x = this.QuestUpdate_mc.x;
         this.StartingQuestUpdatePosition.y = this.QuestUpdate_mc.y;
         (this as MovieClip).removeChild(this.QuestUpdate_mc);
         this.QuestUpdate_mc = null;
         BSUIDataManager.Subscribe("HudModeData",function(param1:FromClientDataEvent):*
         {
            if(param1.data.ModeVisibilityA.length == HUDUtils.MODE_COUNT)
            {
               SetActiveQuestUpdateVisiblity(param1.data.ModeVisibilityA[HUDUtils.QUEST_UPDATES].bVisible);
               Messages_mc.visible = !param1.data.bDisableHUDMessagesForVideo && Boolean(param1.data.ModeVisibilityA[HUDUtils.MESSAGES].bVisible);
               XPGroup_mc.adjustVertically = param1.data.ModeVisibilityA[HUDUtils.XP_GROUP_ADJUST_VERTICALLY].bVisible;
               XPGroup_mc.SetVisible(param1.data.ModeVisibilityA[HUDUtils.XP_GROUP].bVisible);
               BottomCenterGroup_mc.SubtitleText_mc.adjustVertically = param1.data.ModeVisibilityA[HUDUtils.BOTTOM_CENTER_GROUP_ADJUST_VERTICALLY].bVisible;
               BottomCenterGroup_mc.visible = param1.data.ModeVisibilityA[HUDUtils.BOTTOM_CENTER_GROUP].bVisible;
               Location_mc.SetVisible(param1.data.ModeVisibilityA[HUDUtils.LOCATION].bVisible);
               LevelUpHolder_mc.visible = param1.data.ModeVisibilityA[HUDUtils.LEVEL_UP_PROMPT].bVisible;
            }
         });
         BSUIDataManager.Subscribe("QuestUpdateData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:int = 0;
            var _loc3_:* = false;
            var _loc4_:int = 0;
            if(param1.data.QuestUpdatesA.length > 0)
            {
               QuestUpdateDataA = QuestUpdateDataA.concat(param1.data.QuestUpdatesA);
               _loc2_ = 0;
               while(_loc2_ < param1.data.QuestUpdatesA.length)
               {
                  if(param1.data.QuestUpdatesA[_loc2_].uType == QuestMessage.QUEST_SET_ACTIVE || param1.data.QuestUpdatesA[_loc2_].uType == QuestMessage.QUEST_SET_INACTIVE)
                  {
                     _loc3_ = param1.data.QuestUpdatesA[_loc2_].uType == QuestMessage.QUEST_SET_ACTIVE;
                     _loc4_ = 0;
                     while(_loc4_ < QuestUpdateDataA.length)
                     {
                        if(QuestUpdateDataA[_loc4_].uQuestID == param1.data.QuestUpdatesA[_loc2_].uQuestID)
                        {
                           if(QuestUpdateDataA[_loc4_].uType == QuestMessage.QUEST_SET_ACTIVE && !_loc3_ || QuestUpdateDataA[_loc4_].uType == QuestMessage.QUEST_SET_INACTIVE && _loc3_)
                           {
                              QuestUpdateDataA.splice(_loc4_,1);
                           }
                           else if(QuestUpdateDataA[_loc4_].uType == QuestMessage.QUEST_SET_ACTIVE && HasAlwaysUpQuest(QuestUpdateDataA[_loc4_]))
                           {
                              QuestUpdateDataA.splice(_loc4_,1);
                           }
                           else
                           {
                              QuestUpdateDataA[_loc4_].bActiveQuest = _loc3_;
                              QuestUpdateDataA[_loc4_].bAlwaysUp = _loc3_;
                           }
                        }
                        _loc4_++;
                     }
                  }
                  _loc2_++;
               }
               addEventListener(Event.ENTER_FRAME,showQuestUpdates);
            }
         });
         BSUIDataManager.Subscribe("HUDOpacityData",function(param1:FromClientDataEvent):*
         {
            var _loc3_:MovieClip = null;
            var _loc2_:int = 0;
            while(_loc2_ < numChildren)
            {
               _loc3_ = getChildAt(_loc2_) as MovieClip;
               if(_loc3_)
               {
                  _loc3_.alpha = param1.data.fHUDOpacity;
               }
               _loc2_++;
            }
         });
         BSUIDataManager.Subscribe("FireForgetEventData",function(param1:FromClientDataEvent):*
         {
            if(GlobalFunc.HasFireForgetEvent(param1.data,"MonocleMenu_Opened") || GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnMonocleToggle_Opened"))
            {
               UpdateQuestUpdateObjectiveLists(true);
            }
            else if(GlobalFunc.HasFireForgetEvent(param1.data,"MonocleMenu_Closed") || GlobalFunc.HasFireForgetEvent(param1.data,"ShipHud_OnMonocleToggle_Closed"))
            {
               UpdateQuestUpdateObjectiveLists(false);
            }
         });
      }
      
      private function IsBlockingQuestUpdateShown() : Boolean
      {
         var _loc1_:* = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.QuestUpdatesA.length)
         {
            if(!this.QuestUpdatesA[_loc2_].CanShowQuestUpdate())
            {
               _loc1_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function HasAlwaysUpQuest(param1:Object) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.QuestUpdatesA.length)
         {
            if(Boolean(this.QuestUpdatesA[_loc3_].IsShowingThisQuest(param1)) && Boolean(this.QuestUpdatesA[_loc3_].IsAlwaysUp()))
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function showQuestUpdates(param1:Event) : void
      {
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:MovieClip = null;
         var _loc10_:String = null;
         var _loc11_:MovieClip = null;
         var _loc2_:Array = new Array();
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:QuestUpdate = null;
         var _loc6_:Boolean = false;
         for each(_loc7_ in this.QuestUpdateDataA)
         {
            if(_loc7_.uType != QuestMessage.QUEST_SET_INACTIVE && _loc7_.uType != QuestMessage.QUEST_EXPERIENCE_AWARDED)
            {
               if(_loc6_ || this.IsBlockingQuestUpdateShown())
               {
                  _loc6_ = true;
                  _loc2_.push(_loc7_);
                  continue;
               }
            }
            switch(_loc7_.uType)
            {
               case QuestMessage.QUEST_SET_ACTIVE:
               case QuestMessage.QUEST_ADDED:
               case QuestMessage.QUEST_COMPLETED:
               case QuestMessage.QUEST_FAILED:
               case QuestMessage.OBJECTIVE_ADDED:
               case QuestMessage.OBJECTIVE_COMPLETED:
               case QuestMessage.OBJECTIVE_FAILED:
               case QuestMessage.OBJECTIVE_DORMANT:
               case QuestMessage.OBJECTIVE_MOVE_TO_TOP:
                  _loc8_ = true;
                  if((_loc5_ = this.FindQuestUpdate(_loc7_)) != null)
                  {
                     if(_loc5_.CanShowQuestUpdate())
                     {
                        if(_loc7_.uType != QuestMessage.QUEST_ADDED)
                        {
                           _loc5_.ShowQuestUpdate(_loc7_);
                           if(this.CanShowMissionActiveWidget(_loc7_))
                           {
                              _loc5_.ShowMissionActiveButton();
                           }
                        }
                        _loc8_ = false;
                     }
                  }
                  else
                  {
                     _loc8_ = false;
                     if(this.QuestUpdatesA.length < this.MAX_NUMBER_OF_QUESTS)
                     {
                        (_loc9_ = new QuestUpdate(stage,_loc7_.bActiveQuest == null || _loc7_.bActiveQuest == false)).addEventListener(REMOVE_QUEST_UPDATE,this.OnRemoveQuestUpdateEvent);
                        _loc9_.addEventListener(QuestUpdate.UPDATE_QUEST_UPDATE_POSITION,this.UpdatePositions);
                        _loc9_.ChangeObjectiveListVisibility(this.ShowingQuestObjectives);
                        this.addChild(_loc9_);
                        _loc10_ = _loc7_.strQuestName + "_" + _loc7_.uDisplayedQuestID + "_" + _loc9_.name;
                        _loc9_.name = _loc10_;
                        _loc11_ = this.QuestUpdatesA.length > 0 ? this.QuestUpdatesA[this.QuestUpdatesA.length - 1] : null;
                        this.QuestUpdatesA.push(_loc9_);
                        if(_loc11_)
                        {
                           _loc9_.x = _loc11_.x;
                           _loc9_.y = _loc11_.y + _loc11_.GetVisibleHeight();
                        }
                        else
                        {
                           _loc9_.x = this.StartingQuestUpdatePosition.x;
                           _loc9_.y = this.StartingQuestUpdatePosition.y;
                        }
                        GlobalFunc.LockToSafeRect(_loc9_,"L",SafeX,SafeY);
                        (_loc9_ as QuestUpdate).ShowQuestUpdate(_loc7_);
                        if(this.CanShowMissionActiveWidget(_loc7_))
                        {
                           (_loc9_ as QuestUpdate).ShowMissionActiveButton();
                        }
                     }
                  }
                  if(_loc8_)
                  {
                     _loc2_.push(_loc7_);
                  }
                  break;
               case QuestMessage.QUEST_SET_INACTIVE:
                  if((_loc5_ = this.FindQuestUpdate(_loc7_)) != null)
                  {
                     if(_loc5_.CanShowQuestUpdate())
                     {
                        _loc5_.ShowQuestUpdate(_loc7_);
                     }
                     else if(_loc5_.IsShowingActiveQuest())
                     {
                        _loc2_.push(_loc7_);
                     }
                  }
                  break;
               case QuestMessage.QUEST_EXPERIENCE_AWARDED:
                  if((_loc5_ = this.FindQuestUpdate(_loc7_)) != null)
                  {
                     _loc5_.ShowQuestUpdate(_loc7_);
                  }
                  else
                  {
                     _loc2_.push(_loc7_);
                  }
                  break;
               case QuestMessage.HDT_QUEST_TEXT_UPDATED:
                  if(_loc7_.bActiveQuest)
                  {
                     if((_loc5_ = this.FindQuestUpdate(_loc7_)) != null)
                     {
                        _loc5_.ShowQuestUpdate(_loc7_);
                     }
                     else
                     {
                        _loc2_.push(_loc7_);
                     }
                  }
                  break;
               case QuestMessage.QUEST_TIMER_UPDATED:
                  if((_loc5_ = this.FindQuestUpdate(_loc7_)) != null)
                  {
                     if(_loc5_.CanShowQuestUpdate())
                     {
                        _loc5_.UpdateQuestTimer(_loc7_);
                     }
                     else
                     {
                        _loc2_.push(_loc7_);
                     }
                  }
                  break;
               case QuestMessage.QUEST_REJECTED:
                  if((_loc5_ = this.FindQuestUpdate(_loc7_)) != null)
                  {
                     this.RemoveQuestUpdate(_loc5_);
                  }
                  break;
            }
         }
         this.QuestUpdateDataA.splice(0,this.QuestUpdateDataA.length);
         this.QuestUpdateDataA = this.QuestUpdateDataA.concat(_loc2_);
         if(this.QuestUpdateDataA.length == 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.showQuestUpdates);
         }
      }
      
      private function SetActiveQuestUpdateVisiblity(param1:Boolean) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.QuestUpdatesA.length)
         {
            if(this.QuestUpdatesA[_loc2_].IsShowingActiveQuest())
            {
               this.QuestUpdatesA[_loc2_].visible = param1;
            }
            _loc2_++;
         }
      }
      
      private function FindQuestUpdate(param1:Object) : QuestUpdate
      {
         var _loc2_:QuestUpdate = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.QuestUpdatesA.length)
         {
            if(this.QuestUpdatesA[_loc3_].IsShowingThisQuest(param1))
            {
               _loc2_ = this.QuestUpdatesA[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function CanShowMissionActiveWidget(param1:Object) : Boolean
      {
         if(param1.bActiveQuest)
         {
            return false;
         }
         if(param1.uType != QuestMessage.QUEST_ADDED && (param1.uType != QuestMessage.OBJECTIVE_ADDED || !param1.bIsMiscQuest))
         {
            return false;
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.QuestUpdatesA.length && !_loc2_)
         {
            if(this.QuestUpdatesA[_loc3_].IsShowingInputButton())
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         return !_loc2_;
      }
      
      private function OnRemoveQuestUpdateEvent(param1:Event) : *
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         this.RemoveQuestUpdate(_loc2_);
      }
      
      private function UpdateQuestUpdateObjectiveLists(param1:Boolean) : *
      {
         this.ShowingQuestObjectives = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.QuestUpdatesA.length)
         {
            this.QuestUpdatesA[_loc2_].ChangeObjectiveListVisibility(this.ShowingQuestObjectives);
            _loc2_++;
         }
         if(param1)
         {
            this.UpdatePositions();
         }
      }
      
      private function UpdatePositions() : *
      {
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.QuestUpdatesA.length)
         {
            if(_loc1_ > 0)
            {
               _loc2_ = _loc1_ - 1;
               _loc3_ = new Point(this.QuestUpdatesA[_loc2_].x,this.QuestUpdatesA[_loc2_].y);
               this.QuestUpdatesA[_loc1_].x = this.QuestUpdatesA[_loc2_].x;
               this.QuestUpdatesA[_loc1_].y = this.QuestUpdatesA[_loc2_].y + this.QuestUpdatesA[_loc2_].GetVisibleHeight();
               GlobalFunc.LockToSafeRect(this.QuestUpdatesA[_loc1_],"L",SafeX,SafeY);
            }
            _loc1_++;
         }
      }
      
      private function RemoveQuestUpdate(param1:MovieClip) : *
      {
         var _loc4_:int = 0;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.QuestUpdatesA.length)
         {
            if(this.QuestUpdatesA[_loc3_] == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != -1)
         {
            _loc4_ = _loc2_ + 1;
            _loc5_ = this.StartingQuestUpdatePosition;
            if(_loc4_ - 2 >= 0)
            {
               _loc5_ = new Point(this.QuestUpdatesA[_loc4_ - 2].x,this.QuestUpdatesA[_loc4_ - 2].y + this.QuestUpdatesA[_loc4_ - 2].GetVisibleHeight());
            }
            while(_loc4_ < this.QuestUpdatesA.length)
            {
               _loc6_ = new Point(this.QuestUpdatesA[_loc4_].x,this.QuestUpdatesA[_loc4_].y);
               this.QuestUpdatesA[_loc4_].x = _loc5_.x;
               this.QuestUpdatesA[_loc4_].y = _loc5_.y;
               GlobalFunc.LockToSafeRect(this.QuestUpdatesA[_loc4_],"L",SafeX,SafeY);
               _loc7_ = new Point(this.QuestUpdatesA[_loc4_].x,this.QuestUpdatesA[_loc4_].y);
               _loc5_ = new Point(_loc7_.x,_loc7_.y);
               _loc5_.y += this.QuestUpdatesA[_loc4_].GetVisibleHeight();
               this.QuestUpdatesA[_loc4_].x = _loc6_.x;
               this.QuestUpdatesA[_loc4_].y = _loc6_.y;
               this.QuestUpdatesA[_loc4_].TranslateToNewPosition(_loc7_);
               _loc4_++;
            }
            this.QuestUpdatesA.splice(_loc2_,1);
         }
         (this as MovieClip).removeChild(param1);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < this.QuestUpdatesA.length)
         {
            if(this.QuestUpdatesA[_loc4_].IsShowingInputButton())
            {
               _loc3_ = Boolean(this.QuestUpdatesA[_loc4_].ProcessUserEvent(param1,param2));
            }
            _loc4_++;
         }
         if(!_loc3_ && Boolean(this.LevelUpHolder_mc.LevelUpWidget_mc.shown))
         {
            _loc3_ = Boolean(this.LevelUpHolder_mc.LevelUpWidget_mc.ProcessUserEvent(param1,param2));
         }
         return _loc3_;
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.QuestUpdatesA.length)
         {
            this.QuestUpdatesA[_loc2_].SetPlatform(this.uiController);
            _loc2_++;
         }
      }
   }
}
