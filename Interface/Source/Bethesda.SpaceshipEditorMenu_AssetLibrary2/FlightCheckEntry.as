package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FlightCheckEntry extends BSContainerEntry
   {
      
      private static const MESSAGE_TYPE_NOMINAL:uint = 0;
      
      private static const MESSAGE_TYPE_WARNING:uint = 1;
      
      private static const MESSAGE_TYPE_ERROR:uint = 2;
       
      
      public var Icon_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      public var Body_mc:MovieClip;
      
      public function FlightCheckEntry()
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
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.BSASSERT(param1 != null,"BSContainerEntry: SetEntryText requires a valid Entry!");
         var _loc2_:Object = param1;
         switch(_loc2_.uMessageType)
         {
            case MESSAGE_TYPE_NOMINAL:
               gotoAndStop("Nominal");
               break;
            case MESSAGE_TYPE_WARNING:
               gotoAndStop("Warning");
               break;
            case MESSAGE_TYPE_ERROR:
               gotoAndStop("Error");
               break;
            default:
               gotoAndStop("Error");
         }
         this.SetHeaderText(_loc2_.sHeaderText);
         this.SetBodyText(_loc2_.sBodyText);
      }
      
      private function SetHeaderText(param1:String) : *
      {
         GlobalFunc.SetText(this.HeaderText,param1);
      }
      
      private function SetBodyText(param1:String) : *
      {
         GlobalFunc.SetText(this.BodyText,param1);
      }
      
      override public function onRollover() : void
      {
      }
      
      override public function onRollout() : void
      {
      }
   }
}
