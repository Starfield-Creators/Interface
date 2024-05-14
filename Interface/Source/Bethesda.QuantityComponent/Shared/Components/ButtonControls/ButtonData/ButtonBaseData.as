package Shared.Components.ButtonControls.ButtonData
{
   import Shared.GlobalFunc;
   
   public class ButtonBaseData extends ButtonData
   {
       
      
      public var sButtonText:String = "";
      
      public var SubstitutionsA:Array;
      
      public var UseHTML:Boolean = false;
      
      public function ButtonBaseData(param1:String, param2:*, param3:Boolean = true, param4:Boolean = true, param5:String = "", param6:String = "UIMenuGeneralCancel", param7:String = "UIMenuGeneralFocus", param8:Array = null, param9:Boolean = true, param10:Boolean = false)
      {
         this.SubstitutionsA = new Array();
         super();
         this.sButtonText = param1;
         if(param2 is UserEventData)
         {
            UserEvents = new UserEventManager([param2]);
         }
         else if(param2 is Array)
         {
            UserEvents = new UserEventManager(param2);
         }
         else
         {
            GlobalFunc.TraceWarning("aUserEvents is not a UserEventData or Array");
         }
         bEnabled = param3;
         bVisible = param4;
         sClickSound = param5;
         sClickFailedSound = param6;
         sRolloverSound = param7;
         if(param8 != null && param8.length > 0)
         {
            this.SubstitutionsA = param8.slice();
         }
         bUsePCKeyOutline = param9;
         this.UseHTML = param10;
      }
   }
}
