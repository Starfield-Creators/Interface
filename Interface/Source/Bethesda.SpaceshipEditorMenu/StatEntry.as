package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class StatEntry extends BSContainerEntry
   {
       
      
      public var textField_mc:MovieClip;
      
      public var ValueText_mc:MovieClip;
      
      public function StatEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.textField_mc.text_tf;
      }
      
      private function get valueTextField() : TextField
      {
         return this.ValueText_mc.text_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         if(this.valueTextField != null && param1.iValue != null)
         {
            GlobalFunc.SetText(this.valueTextField,param1.iValue,true);
         }
      }
   }
}
