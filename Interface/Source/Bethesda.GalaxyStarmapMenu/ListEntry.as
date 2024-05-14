package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ListEntry extends BSContainerEntry
   {
       
      
      public var textField_mc:MovieClip;
      
      public function ListEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.textField_mc.text_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sOutpostName;
      }
   }
}
