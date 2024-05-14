package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ExitConfirmationMessage extends BSDisplayObject
   {
       
      
      public var Icon_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      public var Body_mc:MovieClip;
      
      public function ExitConfirmationMessage()
      {
         super();
      }
      
      private function get HeaderText() : TextField
      {
         return this.Header_mc.text_tf;
      }
      
      private function get BodyText() : TextField
      {
         return this.Body_mc.text_tf;
      }
      
      public function UpdateValues(param1:String, param2:String, param3:String) : *
      {
         gotoAndStop(param1);
         this.SetHeaderText(param2);
         this.SetBodyText(param3);
      }
      
      private function SetHeaderText(param1:String) : *
      {
         GlobalFunc.SetText(this.HeaderText,param1);
      }
      
      private function SetBodyText(param1:String) : *
      {
         GlobalFunc.SetText(this.BodyText,param1);
      }
   }
}
