package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.display.MovieClip;
   
   public class MessageBoxButtonEntry extends BSScrollingListEntry
   {
       
      
      public var QuestTarget_mc:MovieClip;
      
      private var OrigTextX:Number;
      
      public function MessageBoxButtonEntry()
      {
         super();
         this.OrigTextX = textField.x;
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         super.SetEntryText(param1,param2);
         if(param1.bHasQuestTarget === true)
         {
            this.QuestTarget_mc.visible = true;
            textField.x = this.QuestTarget_mc.x + this.QuestTarget_mc.width / 2 + 5;
         }
         else
         {
            this.QuestTarget_mc.visible = false;
            textField.x = this.OrigTextX;
         }
      }
   }
}
