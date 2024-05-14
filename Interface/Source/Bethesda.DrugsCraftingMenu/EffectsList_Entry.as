package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class EffectsList_Entry extends BSContainerEntry
   {
       
      
      public var Effect_mc:MovieClip;
      
      public function EffectsList_Entry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Effect_mc.Text_tf;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1 as String;
      }
   }
}
