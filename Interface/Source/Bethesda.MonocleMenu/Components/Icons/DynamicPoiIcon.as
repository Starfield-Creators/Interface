package Components.Icons
{
   import Shared.MapMarkerUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DynamicPoiIcon extends MovieClip
   {
      
      private static var InstanceCounter:int = 0;
      
      private static var MapIconsLoader:MapIconsLibrary = null;
       
      
      private var Child:MovieClip = null;
      
      private var LocationMarkerType:uint = 4294967295;
      
      private var LocationMarkerCategory:uint = 4294967295;
      
      private var LocationMarkerState:uint;
      
      private var LocationMarkerScale:Number = 1.7976931348623157e+308;
      
      private var LocationMarkerFrame:String = "";
      
      private var LoadLocation:Boolean = false;
      
      public function DynamicPoiIcon()
      {
         this.LocationMarkerState = MapMarkerUtils.LMS_UNKNOWN;
         super();
         if(MapIconsLoader == null)
         {
            MapIconsLoader = new MapIconsLibrary();
         }
         MapIconsLoader.addEventListener(MapIconsLibrary.LIBRARY_LOADED,this.OnMapIconLibraryLoaded);
      }
      
      public static function GetSpaceMarkerState(param1:Boolean) : uint
      {
         var _loc2_:uint = MapMarkerUtils.LMS_UNKNOWN;
         if(param1)
         {
            _loc2_ = MapMarkerUtils.LMS_FULL_REVEAL;
         }
         return _loc2_;
      }
      
      public static function GetSpacePOIName(param1:String, param2:Boolean, param3:uint) : String
      {
         var _loc5_:String = null;
         var _loc4_:String = "";
         switch(GetSpaceMarkerState(param2))
         {
            case MapMarkerUtils.LMS_FULL_REVEAL:
               _loc4_ = param1;
               break;
            case MapMarkerUtils.LMS_ONLY_TYPE_KNOWN:
               if((_loc5_ = MapMarkerUtils.GetGenericTypeLocString(param3)) != "")
               {
                  _loc4_ = _loc5_;
               }
               else
               {
                  _loc4_ = param1;
               }
               break;
            case MapMarkerUtils.LMS_UNKNOWN:
            default:
               _loc4_ = "$Unknown Location";
         }
         return _loc4_;
      }
      
      public function get locationType() : uint
      {
         return this.LocationMarkerType;
      }
      
      public function get locationState() : uint
      {
         return this.LocationMarkerState;
      }
      
      public function get needsLocationLoaded() : Boolean
      {
         return this.LoadLocation;
      }
      
      public function OnMapIconLibraryLoaded(param1:Event) : *
      {
         if(this.LoadLocation)
         {
            this.SetLocation(this.LocationMarkerType,this.LocationMarkerCategory,this.LocationMarkerState);
            if(this.LocationMarkerScale != Number.MAX_VALUE)
            {
               this.SetMarkerScale(this.LocationMarkerScale);
            }
            if(this.LocationMarkerFrame != "")
            {
               this.SetFrame(this.LocationMarkerFrame);
            }
         }
      }
      
      public function SetLocation(param1:uint, param2:uint, param3:uint) : *
      {
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         if(this.LocationMarkerType != param1 || this.LocationMarkerCategory != param2 || this.LocationMarkerState != param3 || this.LoadLocation)
         {
            if(this.Child != null)
            {
               this.ClearLocation();
            }
            _loc4_ = "";
            switch(param3)
            {
               case MapMarkerUtils.LMS_FULL_REVEAL:
                  _loc4_ = MapMarkerUtils.GetSymbolName(param1);
                  break;
               case MapMarkerUtils.LMS_ONLY_TYPE_KNOWN:
                  _loc4_ = MapMarkerUtils.GetGenericSymbolName(param1,param2);
                  break;
               case MapMarkerUtils.LMS_UNKNOWN:
                  _loc4_ = MapMarkerUtils.GetUnknownSymbolName(param2);
            }
            if((_loc5_ = MapIconsLoader.LoadIcon(_loc4_)) != null)
            {
               _loc5_.name = _loc4_ + InstanceCounter;
               ++InstanceCounter;
               this.Child = _loc5_;
               if(param3 === MapMarkerUtils.LMS_FULL_REVEAL)
               {
                  this.Child.gotoAndStop("Discovered");
               }
               addChild(this.Child);
               this.LoadLocation = false;
            }
            else
            {
               this.LoadLocation = true;
            }
            this.LocationMarkerState = param3;
            this.LocationMarkerCategory = param2;
            this.LocationMarkerType = param1;
         }
      }
      
      public function ClearLocation() : *
      {
         this.LocationMarkerState = MapMarkerUtils.LMS_UNKNOWN;
         if(this.Child != null)
         {
            removeChild(this.Child);
            this.Child = null;
         }
      }
      
      public function SetMarkerScale(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         this.LocationMarkerScale = param1;
         if(this.Child != null)
         {
            this.Child.scaleX = this.LocationMarkerScale;
            this.Child.scaleY = this.LocationMarkerScale;
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function SetFrame(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         this.LocationMarkerFrame = param1;
         if(Boolean(this.Child) && this.Child.currentFrameLabel != param1)
         {
            this.Child.gotoAndStop(param1);
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}
