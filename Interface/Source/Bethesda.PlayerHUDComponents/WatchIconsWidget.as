package
{
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.MapMarkerUtils;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class WatchIconsWidget extends MovieClip
   {
      
      internal static const MAX_MARKERS:uint = 48;
      
      internal static const WATCH_RADIUS_MULT_NEAR:Number = 126;
      
      internal static const WATCH_RADIUS_MULT_FAR:Number = 118.5;
      
      internal static const RAD_TO_DEG:Number = 180 / Math.PI;
      
      internal static const ART_PIXEL_OFFSETY:Number = 15;
      
      internal static const RelativeFrameLabels:Array = ["","BelowPlayer","LevelWithPlayer","AbovePlayer"];
      
      internal static const MapMarkerSubCategoryLabels:Array = ["","Undiscovered","Discovered","Targeted"];
       
      
      internal var VisibleMarkersA:Vector.<CompassMarkerWidget>;
      
      internal var MarkersA:Vector.<CompassMarkerWidget>;
      
      private var UsedHazardIDs:Array;
      
      public function WatchIconsWidget()
      {
         var _loc2_:CompassMarkerWidget = null;
         this.VisibleMarkersA = new Vector.<CompassMarkerWidget>();
         this.MarkersA = new Vector.<CompassMarkerWidget>();
         this.UsedHazardIDs = new Array();
         super();
         var _loc1_:uint = 0;
         while(_loc1_ < MAX_MARKERS)
         {
            _loc2_ = new CompassMarkerWidget();
            _loc2_.visible = false;
            _loc2_.name = "CompassMarker" + _loc1_;
            this.MarkersA.push(_loc2_);
            addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function onCompassDataChange(param1:FromClientDataEvent) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:Object = null;
         var _loc7_:CompassMarkerWidget = null;
         var _loc2_:Array = param1.data.aMarkers;
         var _loc3_:Array = new Array();
         var _loc4_:uint = 0;
         while(Boolean(_loc2_) && _loc4_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc4_];
            if(_loc7_ = this.ShouldShowMarkerOnCompass(_loc6_) ? this.GetOrAddMarker(_loc6_) : null)
            {
               if(_loc3_.indexOf(_loc6_.uiHandle,0) < 0)
               {
                  _loc3_.push(_loc6_.uiHandle);
               }
               this.UpdateMarkerData(_loc7_,_loc6_);
            }
            _loc4_++;
         }
         _loc3_ = _loc3_.concat(this.UsedHazardIDs);
         this.HideUnusedMarkers(_loc3_);
         for each(_loc5_ in this.VisibleMarkersA)
         {
            this.UpdateMarkerDirection(_loc5_,param1.data.fDirection);
         }
      }
      
      public function onEnvironmentalDataChange(param1:FromClientDataEvent) : *
      {
         var _loc4_:Object = null;
         var _loc5_:CompassMarkerWidget = null;
         var _loc2_:Object = param1.data.aEnvironmentEffects;
         this.UsedHazardIDs.length = 0;
         var _loc3_:uint = 0;
         while(Boolean(_loc2_) && _loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc5_ = this.ShouldShowMarkerOnCompass(_loc4_) ? this.GetOrAddMarker(_loc4_) : null)
            {
               if(this.UsedHazardIDs.indexOf(_loc4_.uiHandle,0) < 0)
               {
                  this.UsedHazardIDs.push(_loc4_.uiHandle);
               }
               this.UpdateMarkerData(_loc5_,_loc4_);
               _loc5_.MarkerIcon_mc.gotoAndStop(_loc4_.sEffectIcon);
            }
            _loc3_++;
         }
      }
      
      private function GetMarkerIndex(param1:Object) : int
      {
         var _loc2_:int = -1;
         var _loc3_:uint = 0;
         while(_loc2_ < 0 && _loc3_ < this.VisibleMarkersA.length)
         {
            if(this.VisibleMarkersA[_loc3_].handle == param1.uiHandle)
            {
               _loc2_ = int(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function GetOrAddMarker(param1:Object) : CompassMarkerWidget
      {
         var _loc2_:int = this.GetMarkerIndex(param1);
         var _loc3_:CompassMarkerWidget = null;
         if(_loc2_ >= 0)
         {
            _loc3_ = this.VisibleMarkersA[_loc2_];
            if(param1.uiMarkerIconType == MapMarkerUtils.MIT_MARKER_LOCATIONS)
            {
               _loc3_.SetLocation(param1.uMapMarkerType,param1.uMapMarkerCategory,param1.uLocationMarkerState);
            }
         }
         else if(this.MarkersA.length > 0)
         {
            this.VisibleMarkersA.push(this.MarkersA.shift());
            _loc3_ = this.VisibleMarkersA[this.VisibleMarkersA.length - 1];
            if(param1.uiMarkerIconType == MapMarkerUtils.MIT_MARKER_LOCATIONS)
            {
               _loc3_.SetLocation(param1.uMapMarkerType,param1.uMapMarkerCategory,param1.uLocationMarkerState);
            }
            _loc3_.visible = true;
         }
         if(_loc3_ != null)
         {
            _loc3_.isNear = param1.bIsNear;
         }
         return _loc3_;
      }
      
      private function ShouldShowMarkerOnCompass(param1:Object) : Boolean
      {
         return param1.uiHandle != 0;
      }
      
      private function UpdateMarkerData(param1:CompassMarkerWidget, param2:Object) : void
      {
         param1.handle = param2.uiHandle;
         param1.markerIconType = param2.uiMarkerIconType;
         param1.heading = param2.fHeading;
         var _loc3_:String = MapMarkerUtils.GetMajorFrameFromMitMarkerType(param2.uiMarkerIconType);
         if(param1.currentFrameLabel != _loc3_)
         {
            param1.gotoAndStop(MapMarkerUtils.GetMajorFrameFromMitMarkerType(param2.uiMarkerIconType));
         }
         if(param2.uiRelativeMarkerHeightType != 0)
         {
            param1.SetFrame(RelativeFrameLabels[param2.uiRelativeMarkerHeightType],false);
         }
         if(param2.uiMapMarkerSubCategoryType !== null && param2.uiMapMarkerSubCategoryType != 0)
         {
            param1.SetFrame(MapMarkerSubCategoryLabels[param2.uiMapMarkerSubCategoryType],true);
         }
         var _loc4_:Number = param2.fDistanceScale !== null ? Number(param2.fDistanceScale) : 1;
         var _loc5_:Number = param2.fDistanceAlpha !== null ? Number(param2.fDistanceAlpha) : 1;
         param1.SetMarkerScale(_loc4_);
         param1.alpha = _loc5_;
      }
      
      private function UpdateMarkerDirection(param1:CompassMarkerWidget, param2:Number) : void
      {
         var _loc7_:Number = NaN;
         var _loc3_:Point = new Point(0,1);
         var _loc4_:Number = Math.PI - param2;
         var _loc5_:Number = Math.cos(_loc4_) * _loc3_.x - Math.sin(_loc4_) * _loc3_.y;
         var _loc6_:Number = Math.sin(_loc4_) * _loc3_.x + Math.cos(_loc4_) * _loc3_.y;
         _loc3_.x = _loc5_;
         _loc3_.y = _loc6_;
         _loc5_ = Math.cos(param1.heading) * _loc3_.x - Math.sin(param1.heading) * _loc3_.y;
         _loc6_ = Math.sin(param1.heading) * _loc3_.x + Math.cos(param1.heading) * _loc3_.y;
         if(param1.isNear)
         {
            param1.x = _loc5_ * WATCH_RADIUS_MULT_NEAR;
            param1.y = _loc6_ * WATCH_RADIUS_MULT_NEAR + (param1.markerIconType == MapMarkerUtils.MIT_MARKER_LOCATIONS ? 0 : ART_PIXEL_OFFSETY);
         }
         else
         {
            param1.x = _loc5_ * WATCH_RADIUS_MULT_FAR;
            param1.y = _loc6_ * WATCH_RADIUS_MULT_FAR + (param1.markerIconType == MapMarkerUtils.MIT_MARKER_LOCATIONS ? 0 : ART_PIXEL_OFFSETY);
         }
         if(param1.markerIconType === MapMarkerUtils.MIT_MARKER_HAZARD)
         {
            _loc7_ = -(param2 - param1.heading) * RAD_TO_DEG;
            param1.MarkerIcon_mc.rotation = _loc7_;
         }
      }
      
      private function HideUnusedMarkers(param1:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:int = int(this.VisibleMarkersA.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.indexOf(this.VisibleMarkersA[_loc2_].handle,0);
            if(_loc3_ < 0)
            {
               this.VisibleMarkersA[_loc2_].visible = false;
               this.VisibleMarkersA[_loc2_].ClearLocation();
               this.MarkersA.push(this.VisibleMarkersA.splice(_loc2_,1)[0]);
               param1.splice(param1,1);
               _loc2_--;
            }
            _loc2_--;
         }
      }
   }
}
