package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TestOptionList_Entry extends BSContainerEntry
   {
       
      
      public var Name_mc:MovieClip;
      
      public function TestOptionList_Entry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Name_mc.Name_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.name;
      }
   }
}
