package
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   
   public class MiniCategoryButtonData extends ButtonBaseData
   {
       
      
      public var CategoryIndex:int;
      
      public var Payload:MiniCategoryData;
      
      public function MiniCategoryButtonData(param1:int, param2:*, param3:MiniCategoryData = null, param4:Boolean = true, param5:Boolean = true, param6:String = "UIMenuGeneralTab", param7:String = "UIMenuGeneralCancel", param8:String = "UIMenuGeneralFocus")
      {
         this.CategoryIndex = param1;
         this.Payload = param3;
         super("",param2,param4,param5,param6,param7,param8);
      }
   }
}
