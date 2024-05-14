package Shared.Components.ButtonControls.ButtonData
{
   public class UserEventData
   {
       
      
      public var sUserEvent:String = "";
      
      public var funcCallback:Function = null;
      
      public var sCodeCallback:String = "";
      
      public var bEnabled:Boolean = true;
      
      public var sContextName:String = "";
      
      public function UserEventData(param1:String, param2:Function = null, param3:String = "", param4:Boolean = true)
      {
         super();
         var _loc5_:int;
         if((_loc5_ = param1.indexOf(":")) > -1)
         {
            this.sContextName = param1.substring(0,_loc5_);
            param1 = param1.substring(_loc5_ + 1);
         }
         this.sUserEvent = param1;
         this.funcCallback = param2;
         this.sCodeCallback = param3;
         this.bEnabled = param4;
      }
   }
}
