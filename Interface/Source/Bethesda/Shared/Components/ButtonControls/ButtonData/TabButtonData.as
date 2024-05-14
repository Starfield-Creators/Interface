package Shared.Components.ButtonControls.ButtonData
{
   public class TabButtonData extends ButtonBaseData
   {
       
      
      public var TabIndex:int;
      
      public var Payload:Object;
      
      public function TabButtonData(param1:String, param2:int, param3:*, param4:Object = null, param5:Boolean = true, param6:Boolean = true, param7:String = "UIMenuGeneralTab", param8:String = "UIMenuGeneralCancel", param9:String = "UIMenuGeneralFocus")
      {
         this.TabIndex = param2;
         this.Payload = param4 || {};
         super(String(param4.Text) || param1,param3,param5,param6,param7,param8,param9);
      }
   }
}
