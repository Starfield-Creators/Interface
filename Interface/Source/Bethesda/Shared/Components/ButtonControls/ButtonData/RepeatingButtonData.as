package Shared.Components.ButtonControls.ButtonData
{
   public class RepeatingButtonData extends ButtonBaseData
   {
      
      public static const DEFAULT_REPEAT_INTERVAL_MS:uint = 150;
       
      
      public var RepeatIntervalMS:Number;
      
      public function RepeatingButtonData(param1:String, param2:*, param3:* = 150, param4:Boolean = true, param5:Boolean = true, param6:String = "", param7:String = "UIMenuGeneralCancel", param8:String = "UIMenuGeneralFocus")
      {
         this.RepeatIntervalMS = param3;
         super(param1,param2,param4,param5,param6,param7,param8);
      }
   }
}
