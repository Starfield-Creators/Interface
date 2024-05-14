package
{
   import flash.display.MovieClip;
   
   public class ShipDialogueEntry extends DialogueEntryBase
   {
       
      
      public var Internal_mc:MovieClip;
      
      public function ShipDialogueEntry()
      {
         super();
         stop();
         TextHolder_mc = this.Internal_mc.TextHolder_mc;
         BG_mc = this.Internal_mc.BG_mc;
      }
      
      override public function get animationClip() : MovieClip
      {
         return this.Internal_mc;
      }
   }
}
