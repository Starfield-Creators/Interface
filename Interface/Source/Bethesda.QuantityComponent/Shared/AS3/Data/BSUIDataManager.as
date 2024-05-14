package Shared.AS3.Data
{
   import Shared.AS3.Events.CustomEvent;
   import flash.events.Event;
   
   public final class BSUIDataManager extends UsesEventDispatcherBackend
   {
      
      private static var _instance:BSUIDataManager;
       
      
      private var m_DataShuttleConnector:UIDataShuttleConnector;
      
      private var m_TestConnector:UIDataShuttleTestConnector;
      
      private var m_Providers:Object;
      
      public function BSUIDataManager()
      {
         super();
         if(_instance != null)
         {
            throw new Error(this + " is a Singleton. Access using getInstance()");
         }
         this.m_TestConnector = new UIDataShuttleTestConnector();
         this.m_Providers = new Object();
      }
      
      private static function GetInstance() : BSUIDataManager
      {
         if(!_instance)
         {
            _instance = new BSUIDataManager();
         }
         return _instance;
      }
      
      public static function ConnectDataShuttleConnector(param1:UIDataShuttleConnector) : UIDataShuttleConnector
      {
         var _loc3_:UIDataFromClient = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:BSUIDataManager = GetInstance();
         if(_loc2_.m_DataShuttleConnector == null)
         {
            _loc2_.m_DataShuttleConnector = param1;
            _loc3_ = null;
            _loc5_ = new Array();
            for(_loc4_ in _loc2_.m_Providers)
            {
               _loc3_ = _loc2_.m_Providers[_loc4_];
               param1.Watch(_loc4_,false,_loc3_);
            }
            for(_loc4_ in _loc2_.m_Providers)
            {
               _loc3_ = _loc2_.m_Providers[_loc4_];
               if(!_loc3_.isTest)
               {
                  _loc3_.DispatchChange();
               }
            }
         }
         return _loc2_.m_DataShuttleConnector;
      }
      
      public static function InitDataManager(param1:BSUIEventDispatcherBackend) : void
      {
         GetInstance().eventDispatcherBackend = param1;
      }
      
      public static function Subscribe(param1:String, param2:Function, param3:Boolean = false) : Function
      {
         var _loc4_:Boolean = GetInstance().DoesProviderExist(param1);
         var _loc5_:UIDataFromClient;
         if((_loc5_ = BSUIDataManager.GetDataFromClient(param1,true,param3)) != null)
         {
            _loc5_.addEventListener(Event.CHANGE,param2);
            if(_loc4_ && _loc5_.dataReady)
            {
               param2(new FromClientDataEvent(_loc5_));
            }
            return param2;
         }
         throw Error("Couldn\'t subscribe to data provider: " + param1);
      }
      
      public static function Flush(param1:Array) : *
      {
         var _loc5_:UIDataFromClient = null;
         var _loc2_:Number = param1.length;
         var _loc3_:BSUIDataManager = GetInstance();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            (_loc5_ = _loc3_.m_Providers[param1[_loc4_]]).DispatchChange();
            _loc4_++;
         }
      }
      
      public static function Unsubscribe(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:UIDataFromClient;
         if((_loc4_ = BSUIDataManager.GetDataFromClient(param1,true,param3)) != null)
         {
            _loc4_.removeEventListener(Event.CHANGE,param2);
         }
      }
      
      public static function GetDataFromClient(param1:String, param2:Boolean = true, param3:Boolean = false) : UIDataFromClient
      {
         var _loc5_:UIDataShuttleConnector = null;
         var _loc6_:UIDataShuttleTestConnector = null;
         var _loc7_:UIDataFromClient = null;
         var _loc4_:BSUIDataManager;
         if(!(_loc4_ = GetInstance()).DoesProviderExist(param1) && param2)
         {
            _loc5_ = _loc4_.m_DataShuttleConnector;
            _loc6_ = _loc4_.m_TestConnector;
            _loc7_ = null;
            if(_loc5_)
            {
               _loc7_ = _loc5_.Watch(param1,true);
            }
            if(!_loc7_)
            {
               if(param3)
               {
                  _loc7_ = _loc6_.Watch(param1,true);
               }
               else
               {
                  _loc7_ = new UIDataFromClient(new Object());
               }
            }
            _loc4_.m_Providers[param1] = _loc7_;
         }
         return _loc4_.m_Providers[param1];
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         GetInstance().addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         GetInstance().removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:Event) : Boolean
      {
         return GetInstance().dispatchEvent(param1);
      }
      
      public static function dispatchCustomEvent(param1:String, param2:Object = null) : Boolean
      {
         return dispatchEvent(new CustomEvent(param1,param2));
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return GetInstance().hasEventListener(param1);
      }
      
      public static function willTrigger(param1:String) : Boolean
      {
         return GetInstance().willTrigger(param1);
      }
      
      private function DoesProviderExist(param1:String) : Boolean
      {
         return this.m_Providers[param1] != null;
      }
   }
}
