package Shared.Components.ButtonControls.ButtonData
{
   import Shared.GlobalFunc;
   
   public class ReleaseHoldComboButtonData extends ButtonBaseData
   {
      
      public static const PRESS_AND_RELEASE_EVENT_INDEX:uint = 0;
      
      public static const HOLD_EVENT_INDEX:uint = 1;
       
      
      public var sHoldText:String = "";
      
      public var bPressAndReleaseVisible:Boolean = true;
      
      public function ReleaseHoldComboButtonData(param1:String, param2:String, param3:*, param4:Boolean = true, param5:Boolean = true, param6:String = "", param7:String = "UIMenuGeneralCancel", param8:String = "UIMenuGeneralFocus")
      {
         this.sHoldText = param2;
         if(param3 is Array && param3.length == 2)
         {
            if(param3[HOLD_EVENT_INDEX].sUserEvent != "")
            {
               GlobalFunc.TraceWarning("UserEventData for hold event must be empty - defaults to the same key as PressAndRelease");
               param3[HOLD_EVENT_INDEX].sUserEvent = "";
            }
         }
         else
         {
            GlobalFunc.TraceWarning("aUserEvents must be an array of two user events (1st for press-and-release, 2nd for hold)");
         }
         super(param1,param3,param4,param5,param6,param7,param8);
      }
      
      public function SetPressReleaseEventEnabled(param1:Boolean) : void
      {
         var _loc2_:UserEventData = UserEvents.GetUserEventByIndex(PRESS_AND_RELEASE_EVENT_INDEX);
         if(_loc2_ != null)
         {
            _loc2_.bEnabled = param1;
         }
      }
      
      public function SetHoldEventEnabled(param1:Boolean) : void
      {
         var _loc2_:UserEventData = UserEvents.GetUserEventByIndex(HOLD_EVENT_INDEX);
         if(_loc2_ != null)
         {
            _loc2_.bEnabled = param1;
         }
      }
   }
}
