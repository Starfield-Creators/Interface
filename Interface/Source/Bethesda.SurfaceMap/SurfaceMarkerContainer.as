package
{
   import Components.Icons.MapIconsLibrary;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SurfaceMarkerContainer extends BSDisplayObject
   {
      
      public static const SurfaceMapMenu_TryPlaceCustomMarker:String = "SurfaceMapMenu_TryPlaceCustomMarker";
       
      
      public var PlayerMarker_mc:SurfaceMapMarker;
      
      public var ShipMarker_mc:SurfaceMapMarker;
      
      public var CustomMarker_mc:SurfaceMapMarker;
      
      private var iNWCellX:int = 0;
      
      private var iSECellX:int = 0;
      
      private var MapIconsLoader:MapIconsLibrary;
      
      private var MarkerDataListA:Array;
      
      private var MarkerClipsA:Array;
      
      private var Mask:MovieClip;
      
      private var ZoomMeter:MovieClip;
      
      private var LastMarkerPositions:Array = null;
      
      private const MOVEMENT_DELTA_X:Number = 40;
      
      private const MOVEMENT_DELTA_Y:Number = 40;
      
      private const CELL_WIDTH:Number = 100;
      
      private const MARKER_EDGE_PADDING:* = 20;
      
      private const OFFSCREEN_MARKER_SCALE:* = 0.5;
      
      private const GRID_COLOR:uint = 4613532;
      
      private const GRID_ALPHA:Number = 0.33;
      
      private var bGridGenerated:Boolean = false;
      
      private var CurrentHoveredMarker:SurfaceMapMarker = null;
      
      public function SurfaceMarkerContainer()
      {
         this.MarkerClipsA = new Array();
         super();
         this.MapIconsLoader = new MapIconsLibrary();
         this.MapIconsLoader.addEventListener(MapIconsLibrary.LIBRARY_LOADED,this.OnMapIconLibraryLoaded);
      }
      
      public function get NWCellX() : int
      {
         return this.iNWCellX;
      }
      
      public function get SECellX() : int
      {
         return this.iSECellX;
      }
      
      public function get Scale() : Number
      {
         return scaleX;
      }
      
      public function set Scale(param1:Number) : void
      {
         scaleX = scaleY = param1;
      }
      
      override public function onAddedToStage() : void
      {
         this.PlayerMarker_mc.mouseEnabled = false;
         this.PlayerMarker_mc.mouseChildren = false;
         this.ShipMarker_mc.addEventListener(SurfaceMapMarker.MARKER_HOVER_ON,this.OnMarkerHoverOn);
         this.ShipMarker_mc.addEventListener(SurfaceMapMarker.MARKER_HOVER_OFF,this.OnMarkerHoverOff);
         BSUIDataManager.Subscribe("SurfaceMapDisplayInfo",this.OnUpdateMapDisplay);
         BSUIDataManager.Subscribe("SurfaceMarkerList",this.OnReceivedMarkerList);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function Init(param1:int, param2:int, param3:MovieClip, param4:MovieClip) : *
      {
         var _loc8_:SurfaceMapMarker = null;
         this.iNWCellX = param1;
         this.iSECellX = param2;
         this.Mask = param3;
         this.ZoomMeter = param4;
         if(this.Scale != 1)
         {
            this.Scale = 1;
            this.SetMarkerScale(this.PlayerMarker_mc,1);
            this.SetMarkerScale(this.ShipMarker_mc,1);
            this.SetMarkerScale(this.CustomMarker_mc,1);
            for each(_loc8_ in this.MarkerClipsA)
            {
               this.SetMarkerScale(_loc8_,1);
            }
         }
         var _loc5_:int = this.iNWCellX * this.CELL_WIDTH;
         var _loc6_:int = this.iSECellX * this.CELL_WIDTH;
         var _loc7_:Shape;
         (_loc7_ = new Shape()).graphics.beginFill(this.GRID_COLOR,0.25);
         _loc7_.graphics.drawRect(_loc5_,_loc5_,_loc6_ - _loc5_,_loc6_ - _loc5_);
         _loc7_.graphics.endFill();
         addChildAt(_loc7_,0);
         if(this.LastMarkerPositions != null && this.LastMarkerPositions.length == this.MarkerClipsA.length)
         {
            this.SetMarkerPositions(this.LastMarkerPositions);
         }
      }
      
      public function OnReceivedMarkerList(param1:FromClientDataEvent) : *
      {
         var _loc3_:Object = null;
         var _loc4_:SurfaceMapMarker = null;
         var _loc5_:uint = 0;
         this.CustomMarker_mc.visible = false;
         this.ShipMarker_mc.visible = false;
         this.PlayerMarker_mc.visible = true;
         this.PlayerMarker_mc.FOV_mc.rotation = param1.data.fPlayerHeading;
         this.MarkerDataListA = param1.data.aSurfaceMarkersDataA;
         this.DeleteExistingMarkers();
         var _loc2_:* = 0;
         while(_loc2_ < this.MarkerDataListA.length)
         {
            _loc3_ = this.MarkerDataListA[_loc2_];
            if(_loc3_.iMarkerType == MapMarkerUtils.MARKER_PLAYER_LOCATION)
            {
               this.PlayerMarker_mc.Init(_loc3_);
               this.MarkerClipsA.push(this.PlayerMarker_mc);
               this.SetMarkerScale(this.PlayerMarker_mc,1 / this.Scale);
            }
            else if(_loc3_.iMarkerType == MapMarkerUtils.MARKER_SHIP_PLAYER)
            {
               this.ShipMarker_mc.Init(_loc3_);
               this.ShipMarker_mc.EnableListeners();
               this.MarkerClipsA.push(this.ShipMarker_mc);
               this.SetMarkerScale(this.ShipMarker_mc,1 / this.Scale);
               this.ShipMarker_mc.Icon_mc.Icon_mc.gotoAndStop("Discovered");
               if(this.ShipMarker_mc.ObjectiveAtPOI_mc != null)
               {
                  this.ShipMarker_mc.ObjectiveAtPOI_mc.visible = _loc3_.bHasQuestTarget;
                  if(_loc3_.bQuestActive)
                  {
                     this.ShipMarker_mc.ObjectiveAtPOI_mc.gotoAndStop("Active");
                  }
                  else
                  {
                     this.ShipMarker_mc.ObjectiveAtPOI_mc.gotoAndStop("Inactive");
                  }
               }
            }
            else if(_loc3_.iMarkerType == MapMarkerUtils.MARKER_PLAYER_SET)
            {
               this.CustomMarker_mc.Init(_loc3_);
               this.CustomMarker_mc.EnableListeners();
               this.MarkerClipsA.push(this.CustomMarker_mc);
               this.SetMarkerScale(this.CustomMarker_mc,1 / this.Scale);
            }
            else
            {
               (_loc4_ = new SurfaceMapMarker()).EnableListeners();
               _loc4_.addEventListener(SurfaceMapMarker.MARKER_HOVER_ON,this.OnMarkerHoverOn);
               _loc4_.addEventListener(SurfaceMapMarker.MARKER_HOVER_OFF,this.OnMarkerHoverOff);
               this.MarkerClipsA.push(_loc4_);
               _loc4_.name = _loc3_.sNameText;
               addChild(_loc4_);
               _loc4_.Init(_loc3_);
               _loc5_ = Boolean(_loc3_.bDiscovered) || Boolean(_loc3_.bScanned) ? MapMarkerUtils.LMS_FULL_REVEAL : MapMarkerUtils.LMS_ONLY_TYPE_KNOWN;
               _loc4_.LoadIcon(this.MapIconsLoader,_loc3_.iMarkerType,_loc3_.iMarkerGenericType,_loc5_);
               this.SetMarkerScale(_loc4_,1 / this.Scale);
            }
            _loc2_++;
         }
         this.PrioritizeMarkers();
         if(this.LastMarkerPositions != null && this.LastMarkerPositions.length == this.MarkerClipsA.length)
         {
            this.SetMarkerPositions(this.LastMarkerPositions);
         }
      }
      
      public function OnMapIconLibraryLoaded(param1:Event) : *
      {
         var _loc3_:MovieClip = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.MarkerDataListA.length && _loc2_ < this.MarkerClipsA.length)
         {
            _loc3_ = this.MarkerClipsA[_loc2_] as MovieClip;
            if(_loc3_.needsLocationLoaded())
            {
               _loc3_.SetLocation(this.MapIconsLoader,_loc3_.locationType());
            }
            _loc2_++;
         }
         this.UpdateOffscreenMarkers();
      }
      
      private function PrioritizeMarkers() : void
      {
         setChildIndex(this.ShipMarker_mc,numChildren - 1);
         setChildIndex(this.PlayerMarker_mc,numChildren - 1);
      }
      
      private function DeleteExistingMarkers() : void
      {
         var _loc2_:SurfaceMapMarker = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.MarkerClipsA.length)
         {
            _loc2_ = this.MarkerClipsA[_loc1_] as SurfaceMapMarker;
            if(_loc2_ != this.PlayerMarker_mc && _loc2_ != this.ShipMarker_mc && _loc2_ != this.CustomMarker_mc)
            {
               removeChild(_loc2_);
            }
            _loc1_++;
         }
         this.MarkerClipsA.length = 0;
         this.CurrentHoveredMarker = null;
      }
      
      private function OnUpdateMapDisplay(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = null;
         if(this.ZoomMeter != null)
         {
            _loc2_ = param1.data;
            this.ZoomMeter.FillBar_mc.scaleX = (_loc2_.fCurrentZoomLevel - _loc2_.fMinZoomLevel) / (_loc2_.fMaxZoomLevel - _loc2_.fMinZoomLevel);
         }
      }
      
      private function SetMarkerScale(param1:MovieClip, param2:Number) : *
      {
         param1.scaleX = param1.scaleY = param2;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(this.CurrentHoveredMarker != null)
         {
            return this.CurrentHoveredMarker.ProcessUserEvent(param1,param2);
         }
         if(param1 == "Select" && param2 == false)
         {
            _loc3_ = new Point(stage.mouseX,stage.mouseY);
            _loc4_ = this.globalToLocal(_loc3_);
            BSUIDataManager.dispatchEvent(new CustomEvent(SurfaceMapMenu_TryPlaceCustomMarker,{
               "fPosX":_loc4_.x,
               "fPosY":_loc4_.y
            }));
            return true;
         }
         return false;
      }
      
      private function OnMarkerHoverOn(param1:CustomEvent) : void
      {
         this.CurrentHoveredMarker = param1.params.Marker;
         setChildIndex(this.CurrentHoveredMarker,numChildren - 1);
      }
      
      private function OnMarkerHoverOff(param1:CustomEvent) : void
      {
         if(param1.params.Marker == this.CurrentHoveredMarker)
         {
            this.CurrentHoveredMarker = null;
         }
         this.PrioritizeMarkers();
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         if(this.CurrentHoveredMarker == null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(SurfaceMapMenu_TryPlaceCustomMarker,{
               "fPosX":param1.stageX,
               "fPosY":param1.stageY
            }));
         }
      }
      
      private function UpdateOffscreenMarkers() : void
      {
         var _loc3_:SurfaceMapMarker = null;
         var _loc4_:Rectangle = null;
         var _loc5_:* = false;
         var _loc6_:String = null;
         var _loc7_:OffscreenSurfaceMarker = null;
         var _loc8_:DisplayObject = null;
         if(this.Scale <= 0 || this.Mask == null)
         {
            return;
         }
         var _loc1_:Rectangle = this.Mask.getRect(this);
         _loc1_.x += this.MARKER_EDGE_PADDING;
         _loc1_.y += this.MARKER_EDGE_PADDING;
         _loc1_.width -= this.MARKER_EDGE_PADDING * 2;
         _loc1_.height -= this.MARKER_EDGE_PADDING * 2;
         var _loc2_:uint = 0;
         for(; _loc2_ < this.MarkerClipsA.length; _loc2_++)
         {
            _loc3_ = this.MarkerClipsA[_loc2_] as SurfaceMapMarker;
            if(_loc3_.hasQuestTarget || _loc3_ == this.ShipMarker_mc || _loc3_ == this.PlayerMarker_mc || _loc3_.MarkerData.iMarkerType == MapMarkerUtils.MARKER_QUEST)
            {
               _loc4_ = _loc3_.GetIconRect(this);
               _loc5_ = !_loc1_.containsRect(_loc4_);
               _loc3_.visible = !_loc5_;
               _loc6_ = "OffscreenMarker" + _loc2_;
               if((_loc8_ = getChildByName(_loc6_)) == null)
               {
                  if(_loc3_.visible)
                  {
                     _loc7_ = null;
                     continue;
                  }
                  (_loc7_ = new OffscreenSurfaceMarker()).name = _loc6_;
                  if(_loc3_ == this.PlayerMarker_mc)
                  {
                     _loc7_.gotoAndStop("PlayerIcon");
                  }
                  else if(_loc3_ == this.ShipMarker_mc)
                  {
                     _loc7_.gotoAndStop("ShipIcon");
                     _loc7_.MarkerData = _loc3_.MarkerData;
                     _loc7_.EnableListeners();
                     _loc7_.addEventListener(SurfaceMapMarker.MARKER_HOVER_ON,this.OnMarkerHoverOn);
                     _loc7_.addEventListener(SurfaceMapMarker.MARKER_HOVER_OFF,this.OnMarkerHoverOff);
                     _loc7_.ShipIcon_mc.Icon_mc.gotoAndStop("Discovered");
                  }
                  else
                  {
                     _loc7_.gotoAndStop("QuestIcon");
                     if(_loc3_.MarkerData.bQuestActive)
                     {
                        _loc7_.QuestIcon_mc.gotoAndStop("Active");
                     }
                     else
                     {
                        _loc7_.QuestIcon_mc.gotoAndStop("Inactive");
                     }
                  }
                  addChildAt(_loc7_,numChildren);
               }
               else
               {
                  _loc7_ = _loc8_ as OffscreenSurfaceMarker;
               }
               _loc7_.visible = _loc5_;
               if(_loc5_)
               {
                  this.SetMarkerScale(_loc7_,this.OFFSCREEN_MARKER_SCALE);
                  _loc7_.x = GlobalFunc.Clamp(_loc3_.x,_loc1_.x,_loc1_.x + _loc1_.width);
                  _loc7_.y = GlobalFunc.Clamp(_loc3_.y,_loc1_.y,_loc1_.y + _loc1_.height);
               }
            }
            else
            {
               this.SetMarkerScale(_loc3_,1 / this.Scale);
            }
         }
      }
      
      public function SetMarkerPositions(param1:Array) : *
      {
         var _loc3_:Object = null;
         var _loc4_:SurfaceMapMarker = null;
         this.LastMarkerPositions = param1;
         var _loc2_:* = 0;
         while(_loc2_ < this.MarkerClipsA.length)
         {
            _loc3_ = param1[_loc2_];
            if((_loc4_ = this.MarkerClipsA[_loc2_] as SurfaceMapMarker) != null && _loc3_ != null)
            {
               _loc4_.visible = Boolean(_loc3_.bShowMarker) && Boolean(this.MarkerDataListA[_loc2_].bVisible);
               if(_loc3_.bShowMarker)
               {
                  _loc4_.UpdatePosition(_loc3_.fPosX,_loc3_.fPosY);
               }
            }
            _loc2_++;
         }
         this.UpdateOffscreenMarkers();
      }
   }
}
