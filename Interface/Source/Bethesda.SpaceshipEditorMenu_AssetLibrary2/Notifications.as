package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class Notifications extends BSDisplayObject
   {
      
      private static const ERROR:* = "Error";
      
      private static const WARNING:* = "Warning";
      
      private static const NOMINAL:* = "Nominal";
       
      
      public var NotificationText_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public function Notifications()
      {
         super();
      }
      
      private function get NotificationText() : TextField
      {
         return this.NotificationText_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
      }
      
      public function UpdateValues(param1:Object) : *
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:uint = uint(param1.uNumErrors);
         var _loc3_:uint = uint(param1.uNumWarnings);
         if(_loc2_ > 0)
         {
            _loc4_ = _loc2_ == 1 ? "$ERROR" : "$ERRORS";
            GlobalFunc.SetText(this.NotificationText,_loc4_);
            GlobalFunc.SetText(this.NotificationText,GlobalFunc.FormatNumberToString(_loc2_) + " " + this.NotificationText.text);
            gotoAndStop(ERROR);
         }
         else if(_loc3_ > 0)
         {
            _loc5_ = _loc3_ == 1 ? "$WARNING" : "$WARNINGS";
            GlobalFunc.SetText(this.NotificationText,_loc5_);
            GlobalFunc.SetText(this.NotificationText,GlobalFunc.FormatNumberToString(_loc3_) + " " + this.NotificationText.text);
            gotoAndStop(WARNING);
         }
         else
         {
            GlobalFunc.SetText(this.NotificationText,"$Nominal");
            gotoAndStop(NOMINAL);
         }
      }
   }
}
