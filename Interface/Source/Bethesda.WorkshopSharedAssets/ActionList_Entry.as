package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ActionList_Entry extends BSContainerEntry
   {
       
      
      public var Text_mc:MovieClip;
      
      public function ActionList_Entry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.Text_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return !!param1.action ? String(param1.action) : "";
      }
   }
}
