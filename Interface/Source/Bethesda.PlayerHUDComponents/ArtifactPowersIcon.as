package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Patterns.TimelineStateMachine;
   import Shared.PowerTypes;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ArtifactPowersIcon extends MovieClip
   {
      
      public static const CUE_OUTRO_COMPLETE:String = "OutroComplete";
      
      private static const STATE_UNEQUIP:uint = 0;
      
      private static const STATE_EQUIP:uint = 1;
      
      private static const STATE_COOLDOWN:uint = 2;
      
      private static const STATE_COOLDOWN_OUTRO:uint = 3;
      
      private static const LABEL_EQUIP:String = "On";
      
      private static const LABEL_UNEQUIP:String = "Off";
      
      private static const LABEL_PERCENT_START:String = "PercentStart";
      
      private static const LABEL_PERCENT_END:String = "PercentEnd";
      
      private static const LABEL_PERCENT_OUTRO:String = "Outro";
       
      
      public var EquippedSpellIcon_mc:MovieClip;
      
      private var percentStartFrame:uint;
      
      private var percentEndFrame:uint;
      
      private var percentAnimTotalFrames:uint;
      
      private var timelineSM:TimelineStateMachine;
      
      private var starbornPowersData:Object = null;
      
      public function ArtifactPowersIcon()
      {
         this.timelineSM = new TimelineStateMachine();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.calculatePercentFrames();
         this.timelineSM.addState(STATE_UNEQUIP,[{
            "state":"*",
            "label":LABEL_UNEQUIP
         }],{"enter":this.onStateEnter});
         this.timelineSM.addState(STATE_EQUIP,[{
            "state":"*",
            "label":LABEL_EQUIP
         }],{
            "enter":this.onEquipStateEnter,
            "exit":this.onEquipStateExit
         });
         this.timelineSM.addState(STATE_COOLDOWN,["*"],{
            "enter":this.enterArtifactCooldown,
            "update":this.updateArtifactCooldown
         });
         this.timelineSM.addState(STATE_COOLDOWN_OUTRO,[{
            "state":STATE_COOLDOWN,
            "label":LABEL_PERCENT_OUTRO
         }],{"enter":this.enterCooldownOutro});
         this.timelineSM.startingState(STATE_UNEQUIP);
         this.EquippedSpellIcon_mc.visible = false;
         this.EquippedSpellIcon_mc.stop();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         BSUIDataManager.Subscribe("HUDStarbornPowersData",this.onStarbornPowersData);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onStarbornPowersData(param1:FromClientDataEvent) : void
      {
         this.starbornPowersData = param1.data;
         if(this.starbornPowersData.bHasSpell)
         {
            if(PowerTypes.IsArtifactPower(this.starbornPowersData.sKey))
            {
               this.EquippedSpellIcon_mc.gotoAndStop(this.starbornPowersData.sKey);
            }
         }
         if(this.starbornPowersData.fCost == 0 && this.starbornPowersData.uCooldown == 0)
         {
            if(this.timelineSM.getCurrentStateId() === STATE_COOLDOWN)
            {
               this.timelineSM.changeState(STATE_COOLDOWN_OUTRO);
            }
            else if(this.starbornPowersData.bHasSpell)
            {
               this.timelineSM.changeState(STATE_EQUIP);
            }
            else
            {
               this.timelineSM.changeState(STATE_UNEQUIP);
            }
         }
         else
         {
            this.timelineSM.changeState(STATE_COOLDOWN);
         }
      }
      
      private function calculatePercentFrames() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:FrameLabel = null;
         var _loc2_:uint = currentLabels.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = currentLabels[_loc1_];
            if(_loc3_.name == "PercentStart")
            {
               this.percentStartFrame = _loc3_.frame;
            }
            else if(_loc3_.name == "PercentStop")
            {
               this.percentEndFrame = _loc3_.frame;
            }
            _loc1_++;
         }
         this.percentAnimTotalFrames = this.percentEndFrame - this.percentStartFrame;
      }
      
      protected function onStateEnter(param1:Object) : void
      {
         gotoAndStop(param1.label);
      }
      
      protected function onEquipStateEnter(param1:Object) : void
      {
         this.EquippedSpellIcon_mc.visible = false;
         if(this.starbornPowersData != null)
         {
            if(Boolean(this.starbornPowersData.bHasSpell) && !PowerTypes.IsArtifactPower(this.starbornPowersData.sKey))
            {
               gotoAndStop(LABEL_EQUIP);
            }
            else
            {
               this.EquippedSpellIcon_mc.visible = true;
               gotoAndStop(LABEL_UNEQUIP);
            }
         }
         else
         {
            gotoAndStop(LABEL_UNEQUIP);
         }
      }
      
      protected function onEquipStateExit(param1:Object) : void
      {
         this.EquippedSpellIcon_mc.visible = false;
      }
      
      protected function enterArtifactCooldown(param1:Object) : void
      {
         gotoAndStop(this.percentStartFrame);
      }
      
      protected function updateArtifactCooldown(param1:Object) : void
      {
         var _loc2_:int = Math.floor(this.starbornPowersData.uCooldown * this.percentAnimTotalFrames / 100) + this.percentStartFrame;
         if(_loc2_ < this.percentStartFrame || _loc2_ > this.percentEndFrame)
         {
            _loc2_ = int(this.percentStartFrame);
         }
         gotoAndStop(_loc2_);
      }
      
      protected function enterCooldownOutro(param1:Object) : void
      {
         gotoAndPlay(LABEL_PERCENT_OUTRO);
         addEventListener(CUE_OUTRO_COMPLETE,this.onOutroComplete);
      }
      
      private function onOutroComplete(param1:Event) : void
      {
         removeEventListener(CUE_OUTRO_COMPLETE,this.onOutroComplete);
         if(this.starbornPowersData != null && Boolean(this.starbornPowersData.bHasSpell))
         {
            this.timelineSM.changeState(STATE_EQUIP);
         }
         else
         {
            this.timelineSM.changeState(STATE_UNEQUIP);
         }
      }
   }
}
