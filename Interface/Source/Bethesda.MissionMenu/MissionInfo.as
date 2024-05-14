package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import Shared.QuestUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   
   public class MissionInfo extends BSDisplayObject
   {
       
      
      public var MissionName_mc:MovieClip;
      
      public var MissionFaction_mc:MovieClip;
      
      public var MissionDescriptionList:MissionDescriptionScrollList;
      
      public var MissionTimeRemaining_mc:MovieClip;
      
      public var MissionFactionIcon_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var Divider_mc:MovieClip;
      
      private const MAX_BG_HEIGHT:Number = 545;
      
      private const EXTRA_BG_HEIGHT_AFTER_CONTAINER_END:Number = 45;
      
      private const NAME_TO_FACTION_Y:* = 26;
      
      private const FACTION_TO_DIVIDER_Y:* = 42;
      
      private const FACTION_ORIG_Y:* = 48;
      
      private const DIVIDER_TO_LIST_Y:* = 20;
      
      private const DIVIDER_TO_TIME_REMAINING_Y:* = 564;
      
      private var bHeld:Boolean = false;
      
      private var bHoldingUp:Boolean = false;
      
      private var ButtonHeldStartTime:Number = 0;
      
      private const TIME_TO_WAIT_BEFORE_CONSIDERED_HELD:Number = 500;
      
      private const HEIGHT_BETWEEN_TIME_REMAINING_AND_DESCRIPTION:Number = 25;
      
      public function MissionInfo()
      {
         super();
      }
      
      public static function GetQuestColorIcon(param1:int, param2:int) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         if(param2 == QuestUtils.ACTIVITY_QUEST_TYPE)
         {
            _loc4_ = getDefinitionByName("ActivitiesColorIcon") as Class;
         }
         else
         {
            switch(param1)
            {
               case FactionUtils.FACTION_BLACKFLEET:
                  _loc4_ = getDefinitionByName("BlackfleetColorIcon") as Class;
                  break;
               case FactionUtils.FACTION_FREESTAR:
                  _loc4_ = getDefinitionByName("FreestarColorIcon") as Class;
                  break;
               case FactionUtils.FACTION_HOUSEVARUUN:
                  _loc4_ = getDefinitionByName("VaruunColorIcon") as Class;
                  break;
               case FactionUtils.FACTION_RYUJININDUSTRIES:
                  _loc4_ = getDefinitionByName("RyujinIndustriesColorIcon") as Class;
                  break;
               case FactionUtils.FACTION_UNITEDCOLONIES:
                  _loc4_ = getDefinitionByName("UnitedColoniesColorIcon") as Class;
                  break;
               case FactionUtils.FACTION_CONSTELLATION:
                  _loc4_ = getDefinitionByName("ConstellationColorIcon") as Class;
                  break;
               default:
                  if(param2 == QuestUtils.MISSION_QUEST_TYPE)
                  {
                     _loc4_ = getDefinitionByName("MissionsColorIcon") as Class;
                  }
                  else
                  {
                     _loc4_ = getDefinitionByName("NoFactionColorIcon") as Class;
                  }
            }
         }
         if(_loc4_ != null)
         {
            _loc3_ = new _loc4_();
         }
         return _loc3_;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         visible = false;
      }
      
      public function ProcessStickData(param1:FromClientDataEvent) : *
      {
         if(Math.abs(param1.data.fRInputY) > 0.1)
         {
            if(!this.bHeld)
            {
               this.ButtonHeldStartTime = getTimer();
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            if((!this.bHoldingUp || !this.bHeld) && param1.data.fRInputY > 0)
            {
               this.bHeld = true;
               this.bHoldingUp = true;
               this.MissionDescriptionList.MoveScroll(MissionDescriptionScrollList.SCROLL_DELTA);
            }
            else if((this.bHoldingUp || !this.bHeld) && param1.data.fRInputY < 0)
            {
               this.bHeld = true;
               this.bHoldingUp = false;
               this.MissionDescriptionList.MoveScroll(-1 * MissionDescriptionScrollList.SCROLL_DELTA);
            }
         }
         else if(this.bHeld)
         {
            this.bHeld = false;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function onEnterFrame(param1:Event) : *
      {
         if(this.bHeld)
         {
            if(getTimer() - this.ButtonHeldStartTime >= this.TIME_TO_WAIT_BEFORE_CONSIDERED_HELD)
            {
               if(this.bHoldingUp)
               {
                  this.MissionDescriptionList.MoveScroll(MissionDescriptionScrollList.SCROLL_DELTA);
               }
               else
               {
                  this.MissionDescriptionList.MoveScroll(-1 * MissionDescriptionScrollList.SCROLL_DELTA);
               }
            }
         }
      }
      
      public function UpdateMissionInfo(param1:Object) : *
      {
         if(param1 == null)
         {
            return;
         }
         visible = true;
         var _loc2_:String = FactionUtils.GetFactionName(param1.iFaction);
         GlobalFunc.SetText(this.MissionFaction_mc.text_tf,FactionUtils.GetFactionName(param1.iFaction));
         GlobalFunc.SetText(this.MissionName_mc.text_tf,param1.sName);
         if(_loc2_.length > 0)
         {
            this.MissionFaction_mc.y = this.MissionName_mc.text_tf.textHeight + this.NAME_TO_FACTION_Y;
         }
         else
         {
            this.MissionFaction_mc.y = this.FACTION_ORIG_Y;
         }
         this.Divider_mc.y = this.MissionFaction_mc.y + this.FACTION_TO_DIVIDER_Y;
         this.MissionDescriptionList.y = this.Divider_mc.y + this.DIVIDER_TO_LIST_Y;
         this.MissionTimeRemaining_mc.y = this.Divider_mc.y + this.DIVIDER_TO_TIME_REMAINING_Y;
         this.MissionDescriptionList.SetData(param1);
         this.UpdateTimeRemainingText(param1.iRemainingTime != null ? int(param1.iRemainingTime) : -1,param1.bComplete);
         this.MissionFactionIcon_mc.removeChildren();
         var _loc3_:MovieClip = GetQuestColorIcon(param1.iFaction,param1.iType);
         this.MissionFactionIcon_mc.addChild(_loc3_);
         if(param1.sDescription.length == 0)
         {
            this.Background_mc.height = this.Divider_mc.y;
            this.Divider_mc.visible = false;
         }
         else
         {
            this.Background_mc.height = this.Divider_mc.y + Math.min(this.MAX_BG_HEIGHT,this.MissionDescriptionList.textHeight + this.EXTRA_BG_HEIGHT_AFTER_CONTAINER_END);
            this.Divider_mc.visible = true;
         }
         this.MissionTimeRemaining_mc.y = this.Background_mc.y + this.Background_mc.height + this.HEIGHT_BETWEEN_TIME_REMAINING_AND_DESCRIPTION;
      }
      
      protected function UpdateTimeRemainingText(param1:int, param2:Boolean) : *
      {
         if(param1 < 0 || param2)
         {
            this.MissionTimeRemaining_mc.visible = false;
         }
         else
         {
            this.MissionTimeRemaining_mc.visible = true;
            GlobalFunc.SetText(this.MissionTimeRemaining_mc.TimeRemaining_tf.text_tf,GlobalFunc.GetQuestTimeRemainingString(param1));
         }
      }
   }
}
