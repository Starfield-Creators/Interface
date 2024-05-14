package Shared.Components.ButtonControls.ButtonData
{
   public class PipButtonData extends ButtonBaseData
   {
       
      
      public var PipIndex:int;
      
      public function PipButtonData(param1:int, param2:*, param3:Boolean = true, param4:Boolean = true, param5:String = "UIMenuGeneralTab", param6:String = "UIMenuGeneralCancel", param7:String = "UIMenuGeneralFocus")
      {
         this.PipIndex = param1;
         super("",param2,param3,param4,param5,param6,param7);
      }
   }
}
