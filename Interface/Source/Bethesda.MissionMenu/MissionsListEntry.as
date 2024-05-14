package
{
   import Shared.AS3.BSScrollingTreeEntry;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import Shared.QuestUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   
   public class MissionsListEntry extends BSScrollingTreeEntry
   {
      
      private static var _bLargeTextMode:Boolean = false;
      
      private static const FRAME_LABEL_MISSION:String = "Mission";
      
      private static const FRAME_LABEL_OBJECTIVE:String = "Objective";
      
      private static const FRAME_LABEL_DIVIDER:String = "Divider";
       
      
      public var ObjectiveVisuals_mc:MovieClip;
      
      public var MissionVisuals_mc:MovieClip;
      
      private var _bIsMiscObjective:Boolean = false;
      
      private var _bIsDivider:Boolean = false;
      
      public function MissionsListEntry()
      {
         super();
         Extensions.enabled = true;
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         _bLargeTextMode = param1;
      }
      
      public static function IsMission(param1:Object) : Boolean
      {
         return param1.hasOwnProperty("aObjectives");
      }
      
      public static function CanShowOnMap(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1.hasOwnProperty("aObjectives") && param1.aObjectives.length > 0)
         {
            _loc2_ = Boolean(param1.aObjectives[0].bCanShowOnMap);
         }
         else if(param1.hasOwnProperty("bCanShowOnMap"))
         {
            _loc2_ = Boolean(param1.bCanShowOnMap);
         }
         return _loc2_;
      }
      
      public function get showingMission() : Boolean
      {
         return currentLabel == FRAME_LABEL_MISSION;
      }
      
      public function get trackerIndicator() : MovieClip
      {
         return this.MissionVisuals_mc.TrackIndicator_mc;
      }
      
      public function get factionIcon() : MovieClip
      {
         return this.MissionVisuals_mc.FactionSymbols_mc.Icons_mc;
      }
      
      public function get bIsMiscObjective() : Boolean
      {
         return this._bIsMiscObjective;
      }
      
      public function get bIsDivider() : Boolean
      {
         return this._bIsDivider;
      }
      
      override public function get animationClip() : MovieClip
      {
         return this.showingMission ? this.MissionVisuals_mc : this.ObjectiveVisuals_mc;
      }
      
      override public function get expandAnimName() : String
      {
         return selected ? "openSelected" : super.expandAnimName;
      }
      
      override public function get collapseAnimName() : String
      {
         return selected ? "closeSelected" : super.collapseAnimName;
      }
      
      override public function get expanded() : Boolean
      {
         return CollapseIcon_mc.currentLabel == "openSelected" || CollapseIcon_mc.currentLabel == super.expandAnimName;
      }
      
      private function ShowMission() : void
      {
         gotoAndStop(FRAME_LABEL_MISSION);
      }
      
      private function ShowObjective(param1:Object) : void
      {
         gotoAndStop(FRAME_LABEL_OBJECTIVE);
         if(param1.bIsMiscObjective)
         {
            this.ObjectiveVisuals_mc.TrackIndicator_mc.gotoAndStop(!!param1.bActive ? "MiscTracked" : "Active");
         }
         else if(param1.bComplete)
         {
            this.ObjectiveVisuals_mc.TrackIndicator_mc.gotoAndStop("Completed");
         }
         else if(param1.bFailed)
         {
            this.ObjectiveVisuals_mc.TrackIndicator_mc.gotoAndStop("Fail");
         }
         else
         {
            this.ObjectiveVisuals_mc.TrackIndicator_mc.gotoAndStop("Active");
         }
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:RegExp = null;
         if(param1.bIsDivider === true)
         {
            gotoAndStop(FRAME_LABEL_DIVIDER);
            this._bIsDivider = true;
            return;
         }
         var _loc2_:* = IsMission(param1);
         this._bIsDivider = false;
         if(_loc2_)
         {
            maxCharactersToDisplay = _bLargeTextMode ? 46 : 67;
         }
         else
         {
            maxCharactersToDisplay = _bLargeTextMode ? 56 : 62;
         }
         if(!this.showingMission && _loc2_)
         {
            this.ShowMission();
         }
         else if(!_loc2_)
         {
            this.ShowObjective(param1);
         }
         this._bIsMiscObjective = param1.bIsMiscObjective === true;
         var _loc3_:MovieClip = this.showingMission ? this.MissionVisuals_mc : this.ObjectiveVisuals_mc;
         if(param1.sName != undefined)
         {
            _loc4_ = String(param1.sName);
            _loc5_ = /\\n/gi;
            _loc4_ = _loc4_.replace(_loc5_,"");
            GlobalFunc.SetText(_loc3_.TextField_tf.text_tf,_loc4_,true,false,maxCharactersToDisplay);
         }
         else
         {
            GlobalFunc.SetText(_loc3_.TextField_tf.text_tf,"",true,false,maxCharactersToDisplay);
         }
         if(this.showingMission)
         {
            this.SetFactionIcon(param1);
            this.SetMissionTracked(param1);
         }
         this.UpdateTimeRemainingText(param1.iRemainingTime,param1.bComplete);
      }
      
      private function SetFactionIcon(param1:Object) : void
      {
         var _loc2_:String = "";
         if(param1 != null)
         {
            this.factionIcon.gotoAndStop(QuestUtils.GetQuestIconLabel(param1.iFaction,param1.iType));
         }
         else
         {
            this.factionIcon.gotoAndStop(QuestUtils.GetQuestIconLabel(FactionUtils.FACTION_NONE,QuestUtils.MISC_QUEST_TYPE));
         }
      }
      
      private function SetMissionTracked(param1:Object) : void
      {
         var _loc2_:MovieClip = this.MissionVisuals_mc.TrackIndicator_mc;
         if(_loc2_ != null)
         {
            if(param1 != null && param1.bActive != null)
            {
               _loc2_.gotoAndStop(!!param1.bActive ? "Active" : "Inactive");
            }
            else
            {
               _loc2_.gotoAndStop("Inactive");
            }
         }
      }
      
      override public function onRollover() : void
      {
         if(!this._bIsDivider)
         {
            super.onRollover();
            this.UpdateCollapseIcon();
         }
      }
      
      override public function onRollout() : void
      {
         if(!this._bIsDivider)
         {
            super.onRollout();
            this.UpdateCollapseIcon();
         }
      }
      
      public function UpdateCollapseIcon() : void
      {
         if(CollapseIcon_mc.visible)
         {
            ShowCollapseIcon(this.expanded);
         }
      }
      
      override public function CanBeFocusedInParentEntriesOnly() : Boolean
      {
         return this.bIsMiscObjective;
      }
      
      protected function UpdateTimeRemainingText(param1:int, param2:Boolean) : *
      {
         if(this.showingMission)
         {
            if(param1 < 0 || param2)
            {
               this.MissionVisuals_mc.TimeRemainingLabel_tf.visible = false;
               this.MissionVisuals_mc.TimeRemaining_tf.visible = false;
            }
            else
            {
               this.MissionVisuals_mc.TimeRemainingLabel_tf.visible = true;
               this.MissionVisuals_mc.TimeRemaining_tf.visible = true;
               GlobalFunc.SetText(this.MissionVisuals_mc.TimeRemaining_tf.text_tf,GlobalFunc.GetQuestTimeRemainingString(param1));
            }
         }
      }
      
      override public function IsEntryFocusable() : Boolean
      {
         return this._bIsDivider == false;
      }
   }
}
