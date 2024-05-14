package Shared.Components.ButtonControls.ButtonData
{
   public class UserEventManager
   {
       
      
      private var UserEventsA:Array;
      
      private var sUserEventKey:String = "";
      
      public function UserEventManager(param1:Array)
      {
         var _loc2_:UserEventData = null;
         this.UserEventsA = new Array();
         super();
         for each(_loc2_ in param1)
         {
            this.UserEventsA.push(_loc2_);
         }
         this.BuildUserEventKey();
      }
      
      public function get userEvents() : Array
      {
         return this.UserEventsA;
      }
      
      public function get UserEventKey() : *
      {
         return this.sUserEventKey;
      }
      
      public function get ContextName() : String
      {
         return this.NumUserEvents > 0 ? String(this.UserEventsA[0].sContextName) : "";
      }
      
      public function get NumUserEvents() : *
      {
         return this.UserEventsA.length;
      }
      
      public function CallForMatchingData(param1:String, param2:Function) : *
      {
         var _loc3_:UserEventData = null;
         for each(_loc3_ in this.UserEventsA)
         {
            if(_loc3_.sUserEvent == param1)
            {
               param2(_loc3_);
            }
         }
      }
      
      public function BuildUserEventKey() : void
      {
         var _loc2_:UserEventData = null;
         var _loc3_:String = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.UserEventsA)
         {
            _loc1_.push(_loc2_.sUserEvent);
         }
         _loc1_.sort();
         this.sUserEventKey = "";
         for each(_loc3_ in _loc1_)
         {
            this.sUserEventKey += _loc3_;
         }
      }
      
      public function GetUserEventByIndex(param1:int) : UserEventData
      {
         return this.UserEventsA[param1];
      }
   }
}
