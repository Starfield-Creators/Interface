package Shared.Components.ButtonControls.Utils
{
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.events.EventDispatcher;
   
   public class ButtonKeyHelper extends EventDispatcher
   {
      
      public static const CONTROL_MAP_CHANGE:String = "ControlMapChange";
       
      
      private var EventToNameMappingsA:Array = null;
      
      private var uiController:uint = 0;
      
      public function ButtonKeyHelper()
      {
         super();
      }
      
      public function get usingController() : Boolean
      {
         return this.uiController > PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
         this.EventToNameMappingsA = param1.vMappedEvents;
         if(this.uiController != param1.uiController)
         {
            this.uiController = param1.uiController;
         }
      }
      
      public function GetButtonNameForEvent(param1:String, param2:String = "") : String
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc3_:String = "";
         if(param1 != "")
         {
            _loc4_ = new Array();
            for each(_loc5_ in this.EventToNameMappingsA)
            {
               if(_loc5_.strUserEventName == param1 && (param2 == "" || _loc5_.sContextName.toLowerCase() == param2.toLowerCase()))
               {
                  _loc3_ = String(_loc5_.strButtonName);
                  _loc4_ = _loc5_.aButtonName;
                  break;
               }
            }
            _loc6_ = null;
            if(_loc4_.length > 1)
            {
               _loc6_ = String(GlobalFunc.NameToTextMap[(this.uiController > PlatformUtils.PLATFORM_PC_KB_MOUSE ? "" : "PC") + _loc4_[0]]);
               _loc7_ = 1;
               while(_loc7_ < _loc4_.length)
               {
                  _loc6_ += " + " + GlobalFunc.NameToTextMap[(this.uiController > PlatformUtils.PLATFORM_PC_KB_MOUSE ? "" : "PC") + _loc4_[_loc7_]];
                  _loc7_++;
               }
            }
            else
            {
               _loc6_ = String(GlobalFunc.NameToTextMap[(this.uiController > PlatformUtils.PLATFORM_PC_KB_MOUSE ? "" : "PC") + _loc3_]);
            }
            _loc3_ = _loc6_ != null ? _loc6_ : _loc3_;
         }
         return _loc3_;
      }
      
      public function GetButtonStringForEvents(param1:Array) : String
      {
         var _loc3_:String = null;
         var _loc4_:UserEventData = null;
         var _loc2_:* = this.GetMergedButtonString(param1);
         if(_loc2_ == "")
         {
            _loc3_ = "";
            for each(_loc4_ in param1)
            {
               _loc3_ = this.GetButtonNameForEvent(_loc4_.sUserEvent,_loc4_.sContextName);
               if(_loc3_ != "")
               {
                  if(_loc2_ != "")
                  {
                     _loc2_ += "/";
                  }
                  _loc2_ += _loc3_;
               }
            }
         }
         return _loc2_;
      }
      
      private function GetMergedButtonString(param1:Array) : String
      {
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:UserEventData = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:String = "";
         if(param1.length == 2 || param1.length == 4)
         {
            _loc3_ = new Array();
            _loc4_ = false;
            for each(_loc5_ in param1)
            {
               for each(_loc6_ in this.EventToNameMappingsA)
               {
                  if(_loc6_.strUserEventName == _loc5_.sUserEvent && (_loc5_.sContextName == "" || _loc6_.sContextName.toLowerCase() == _loc5_.sContextName.toLowerCase()))
                  {
                     _loc3_.push(_loc6_.strButtonName);
                     _loc4_ ||= _loc6_.aButtonName.length > 1;
                     break;
                  }
               }
               if(_loc4_)
               {
                  break;
               }
            }
            if(!_loc4_)
            {
               _loc3_.sort();
               _loc7_ = "";
               for each(_loc8_ in _loc3_)
               {
                  _loc7_ += _loc8_;
               }
               _loc2_ = (_loc9_ = String(GlobalFunc.NameToTextMap[(this.uiController > PlatformUtils.PLATFORM_PC_KB_MOUSE ? "" : "PC") + _loc7_])) != null ? _loc9_ : _loc2_;
            }
         }
         return _loc2_;
      }
   }
}
