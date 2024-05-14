package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class QuestRewardsWidget extends MovieClip
   {
      
      public static const SHOW_ITEM_REWARD:String = "SHOW_ITEM_REWARD";
      
      public static const XP_FADED_IN:String = "XP_FADED_IN";
       
      
      public var QuestRewards_mc:MovieClip;
      
      public var QuestRewardsText_mc:MovieClip;
      
      private var Data:Object;
      
      private var uiAnimXP:uint = 0;
      
      public function QuestRewardsWidget()
      {
         super();
      }
      
      public function ShowXPRewards(param1:Object) : *
      {
         if(this.Data != null)
         {
            this.Data = null;
         }
         this.Data = param1;
         this.gotoAndPlay("Intro");
         this.QuestRewards_mc.gotoAndPlay("ShowXP");
         GlobalFunc.PlayMenuSound("UIExperienceUpStart");
         GlobalFunc.SetText(this.QuestRewards_mc.QuestUpdateProgressBar_mc.MaxLevelXP_tf,this.Data.uiMaxForLevel.toString());
         GlobalFunc.SetText(this.QuestRewards_mc.QuestUpdateProgressBar_mc.EarnedXP_tf,this.Data.uiEarnedXP.toString());
         this.uiAnimXP = GlobalFunc.Lerp(1,60,this.Data.fStartPercent);
         this.QuestRewards_mc.QuestUpdateProgressBar_mc.CurrentTotalSlider_mc.gotoAndStop(this.uiAnimXP);
         this.QuestRewards_mc.QuestUpdateProgressBar_mc.EarnedXPSlider_mc.gotoAndStop(this.uiAnimXP);
         this.QuestRewards_mc.addEventListener(XP_FADED_IN,this.ShowXPChange);
      }
      
      private function ShowXPChange() : *
      {
         this.removeEventListener(XP_FADED_IN,this.ShowXPChange);
         this.addEventListener(Event.ENTER_FRAME,this.AnimateXP,false,0,true);
      }
      
      private function AnimateXP() : *
      {
         ++this.uiAnimXP;
         if(this.uiAnimXP > 60 || this.uiAnimXP > GlobalFunc.Lerp(1,60,this.Data.fEndPercent))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.AnimateXP);
            if(this.Data.ItemRewardsA != null && this.Data.ItemRewardsA.length > 0)
            {
               this.QuestRewards_mc.gotoAndPlay("XPToItemReward");
            }
            else
            {
               this.QuestRewards_mc.gotoAndPlay("HideXP");
               this.gotoAndPlay("Outro");
            }
            GlobalFunc.PlayMenuSound("UIExperienceUpStop");
            this.QuestRewards_mc.addEventListener(SHOW_ITEM_REWARD,this.ShowItemRewards);
         }
         else
         {
            this.QuestRewards_mc.QuestUpdateProgressBar_mc.EarnedXPSlider_mc.gotoAndStop(this.uiAnimXP);
         }
      }
      
      private function ShowItemRewards() : *
      {
         if(this.Data.ItemRewardsA != null && this.Data.ItemRewardsA.length > 0)
         {
            this.QuestRewards_mc.gotoAndPlay("ShowItemReward");
            GlobalFunc.SetText(this.QuestRewards_mc.QuestItemRewards_mc.ItemRewardsText_tf,this.Data.ItemRewardsA[0].ItemRewardText);
            this.Data.ItemRewardsA.splice(0,1);
            GlobalFunc.PlayMenuSound("UIQuestMissionRewardItem");
         }
         else
         {
            this.removeEventListener(SHOW_ITEM_REWARD,this.ShowItemRewards);
         }
      }
   }
}
