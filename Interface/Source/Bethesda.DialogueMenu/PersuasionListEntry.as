package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PersuasionListEntry extends BSContainerEntry
   {
       
      
      public var BG_mc:MovieClip;
      
      public var ColorCode_mc:MovieClip;
      
      public var Mask_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var TextHolder_mc:MovieClip;
      
      public function PersuasionListEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.TextHolder_mc.textField;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sChoiceText;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         this.BG_mc.Base_mc.height = Border_mc.height;
         this.Mask_mc.Base_mc.height = Border_mc.height;
         this.ColorCode_mc.height = Border_mc.height;
         if(param1.iPersuasionPointsGained >= 0)
         {
            GlobalFunc.SetText(this.TextHolder_mc.Points_tf,"+" + param1.iPersuasionPointsGained);
         }
         else
         {
            GlobalFunc.SetText(this.TextHolder_mc.Points_tf,param1.iPersuasionPointsGained.toString());
         }
         if(this.ColorCode_mc.currentFrame != param1.uDifficulty + 1)
         {
            this.ColorCode_mc.gotoAndStop(param1.uDifficulty + 1);
         }
      }
   }
}
