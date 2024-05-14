package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class DialogueEntryBase extends BSContainerEntry
   {
      
      public static const EVENT_ON_ROLLOVER:String = "DialogueScrollingListEntry_OnRollover";
       
      
      public var TextHolder_mc:MovieClip;
      
      public var BG_mc:MovieClip;
      
      private var bCanBeChosen:* = false;
      
      private var bAlreadySaid:* = false;
      
      public function DialogueEntryBase()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.TextHolder_mc.textField;
      }
      
      override public function get selectedFrameLabel() : String
      {
         if(!this.bCanBeChosen)
         {
            return "InvalidChoice_Selected";
         }
         if(this.bAlreadySaid)
         {
            return "AlreadySaid_Selected";
         }
         return "Normal_Selected";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         if(!this.bCanBeChosen)
         {
            return "InvalidChoice_Unselected";
         }
         if(this.bAlreadySaid)
         {
            return "AlreadySaid_Unselected";
         }
         return "Normal_Unselected";
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sChoiceText;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         this.bCanBeChosen = param1.bCanBeChosen;
         this.bAlreadySaid = param1.bWasAlreadySaid;
         this.BG_mc.Base_mc.height = Border_mc.height;
         onRollout();
      }
      
      override public function onRollover() : void
      {
         super.onRollover();
         dispatchEvent(new Event(EVENT_ON_ROLLOVER,true,true));
      }
   }
}
