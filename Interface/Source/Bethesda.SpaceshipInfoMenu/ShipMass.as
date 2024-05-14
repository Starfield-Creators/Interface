package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipMass extends BSDisplayObject
   {
       
      
      public var Title_mc:MovieClip;
      
      public var Value_mc:MovieClip;
      
      public function ShipMass()
      {
         super();
      }
      
      private function get TitleText() : TextField
      {
         return this.Title_mc.text_tf;
      }
      
      private function get ValueText() : TextField
      {
         return this.Value_mc.text_tf;
      }
      
      public function SetTitle(param1:String) : void
      {
         GlobalFunc.SetText(this.TitleText,param1);
      }
      
      public function SetValue(param1:String) : void
      {
         GlobalFunc.SetText(this.ValueText,param1);
      }
   }
}
