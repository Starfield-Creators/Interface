package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   
   public class ShipDialogueMenu extends DialogueMenuBase
   {
       
      
      private var ClosingMenu:Boolean = false;
      
      private var ShipDialogueList_mc:ShipDialogueList;
      
      private var bPlayingIncomingSound:Boolean = false;
      
      public function ShipDialogueMenu()
      {
         super();
         DialogueList_mc.visible = true;
         this.ShipDialogueList_mc = DialogueList_mc as ShipDialogueList;
         this.ShipDialogueList_mc.addEventListener(ShipDialogueList.ON_ENTRY_CLOSE_ANIM_FINISH,this.OnCloseAnimFinished);
         this.ShipDialogueList_mc.addEventListener(ShipDialogueList.ON_LIST_CLOSE_ANIM_FINISH,this.OnFinishCloseMenu);
      }
      
      override protected function GetDialogListParams() : BSScrollingConfigParams
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "ShipDialogueEntry";
         _loc1_.MultiLine = true;
         return _loc1_;
      }
      
      override protected function ChoiceListOnListItemPress() : *
      {
         this.ShipDialogueList_mc.TriggerCloseAnimation();
      }
      
      override protected function FinishClosingMenu() : *
      {
         this.ClosingMenu = true;
         this.ShipDialogueList_mc.TriggerCloseAnimation();
         if(this.bPlayingIncomingSound)
         {
            GlobalFunc.PlayMenuSound("UICockpitHUDNotificationHailTransmissionIncoming_Stop");
            this.bPlayingIncomingSound = false;
         }
      }
      
      private function OnCloseAnimFinished() : *
      {
         if(this.ClosingMenu)
         {
            if(this.ShipDialogueList_mc.visible)
            {
               this.ShipDialogueList_mc.gotoAndPlay("rollOff");
            }
            else
            {
               this.ShipDialogueList_mc.OnRollOffComplete();
            }
         }
         else
         {
            super.ChoiceListOnListItemPress();
         }
      }
      
      private function OnFinishCloseMenu() : *
      {
         super.FinishClosingMenu();
      }
      
      override protected function onDataUpdate(param1:FromClientDataEvent) : void
      {
         super.onDataUpdate(param1);
         this.ShipDialogueList_mc.SetTitleText(param1.data.sSpeakerName);
         this.ShipDialogueList_mc.IncomingTextInternal_mc.visible = !param1.data.bSpeakerInSameCell;
      }
      
      override protected function onDialogueListCloseAnimFinished() : void
      {
      }
      
      override protected function state_Subtitles(param1:int) : *
      {
         switch(param1)
         {
            case ENTER_STATE:
               GlobalFunc.PlayMenuSound("UICockpitHUDNotificationHailTransmissionIncoming");
               this.bPlayingIncomingSound = true;
         }
         super.state_Subtitles(param1);
      }
      
      override protected function state_ChoiceList(param1:int) : *
      {
         switch(param1)
         {
            case ENTER_STATE:
               GlobalFunc.PlayMenuSound("UICockpitHUDNotificationHailTransmissionIncoming_Stop");
               this.bPlayingIncomingSound = false;
         }
         super.state_ChoiceList(param1);
      }
   }
}
