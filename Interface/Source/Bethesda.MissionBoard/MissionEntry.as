package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import Shared.QuestUtils;
   import flash.display.MovieClip;
   
   public class MissionEntry extends BSContainerEntry
   {
       
      
      public var Content_mc:MovieClip;
      
      public var FactionSymbol_mc:MovieClip;
      
      public var Accepted_mc:MovieClip;
      
      private const ACCEPTED_OFF:String = "off";
      
      private const ACCEPTED_ON:String = "on";
      
      private const ACCEPTED_SHOW:String = "Show";
      
      private var MissionNameInitialY:int;
      
      public function MissionEntry()
      {
         super();
         this.Accepted_mc.gotoAndStop(this.ACCEPTED_OFF);
         gotoAndStop(this.unselectedFrameLabel);
         this.MissionNameInitialY = this.MissionName.y;
      }
      
      private function get MissionName() : MovieClip
      {
         return this.Content_mc.MissionName_mc;
      }
      
      private function get RewardAmount() : MovieClip
      {
         return this.Content_mc.RewardAmount_mc;
      }
      
      public function SetMissionName(param1:String) : void
      {
         GlobalFunc.SetText(this.MissionName.text_tf,param1);
         this.MissionName.y = this.MissionNameInitialY + Math.round((this.MissionName.text_tf.height - this.MissionName.text_tf.textHeight) * 0.5);
      }
      
      public function SetRewardAmount(param1:String) : void
      {
         GlobalFunc.SetText(this.RewardAmount.text_tf,param1);
      }
      
      override public function get unselectedFrameLabel() : String
      {
         return this.Accepted_mc.currentFrameLabel == this.ACCEPTED_OFF ? "unselected" : "Registered";
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.BSASSERT(param1 != null,"BSContainerEntry: SetEntryText requires a valid Entry!");
         this.SetMissionName(param1.sName);
         this.SetRewardAmount(param1.fCurrencyReward);
         this.FactionSymbol_mc.gotoAndStop(QuestUtils.GetQuestIconLabel(param1.iFaction,QuestUtils.MISSION_QUEST_TYPE));
         if(param1.bAccepted)
         {
            if(this.Accepted_mc.currentFrameLabel == this.ACCEPTED_OFF)
            {
               this.Accepted_mc.gotoAndPlay(this.ACCEPTED_SHOW);
            }
            else
            {
               this.Accepted_mc.gotoAndStop(this.ACCEPTED_ON);
            }
         }
         else
         {
            this.Accepted_mc.gotoAndStop(this.ACCEPTED_OFF);
         }
      }
   }
}
