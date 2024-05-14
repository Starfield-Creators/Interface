package
{
   import Components.Icons.DynamicPoiIcon;
   import Shared.AS3.BSDisplayObject;
   import flash.display.MovieClip;
   
   public class CompassMarkerWidget extends BSDisplayObject
   {
       
      
      public var MarkerIcon_mc:MovieClip;
      
      public var PoiIcon_mc:DynamicPoiIcon;
      
      public var handle:uint = 0;
      
      public var heading:Number = 0;
      
      public var markerIconType:uint = 0;
      
      public var isNear:Boolean = false;
      
      public function CompassMarkerWidget()
      {
         super();
      }
      
      public function get locationType() : uint
      {
         return this.PoiIcon_mc.locationType;
      }
      
      public function get locationState() : uint
      {
         return this.PoiIcon_mc.locationState;
      }
      
      public function get needsLocationLoaded() : Boolean
      {
         return this.PoiIcon_mc.needsLocationLoaded;
      }
      
      public function SetLocation(param1:uint, param2:uint, param3:uint) : *
      {
         this.PoiIcon_mc.SetLocation(param1,param2,param3);
      }
      
      public function ClearLocation() : *
      {
         this.PoiIcon_mc.ClearLocation();
      }
      
      public function SetMarkerScale(param1:Number) : *
      {
         if(!this.PoiIcon_mc.SetMarkerScale(param1) && this.MarkerIcon_mc != null)
         {
            this.MarkerIcon_mc.scaleX = param1;
            this.MarkerIcon_mc.scaleY = param1;
         }
      }
      
      public function SetFrame(param1:String, param2:Boolean) : *
      {
         var _loc3_:Boolean = false;
         if(param2)
         {
            _loc3_ = this.PoiIcon_mc.SetFrame(param1);
         }
         if(!_loc3_ && this.MarkerIcon_mc && this.MarkerIcon_mc.currentFrameLabel != param1)
         {
            this.MarkerIcon_mc.gotoAndStop(param1);
         }
      }
   }
}
