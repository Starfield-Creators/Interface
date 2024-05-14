package
{
   import flash.display.MovieClip;
   
   public class DialogueScrollingListEntry extends DialogueEntryBase
   {
       
      
      public var Mask_mc:MovieClip;
      
      public function DialogueScrollingListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         this.Mask_mc.Base_mc.height = Border_mc.height;
      }
   }
}
