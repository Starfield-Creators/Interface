package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class StatCategoryEntry extends BSContainerEntry
   {
       
      
      public var Text_mc:MovieClip;
      
      public function StatCategoryEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.Text_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         onRollout();
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sName;
      }
   }
}
