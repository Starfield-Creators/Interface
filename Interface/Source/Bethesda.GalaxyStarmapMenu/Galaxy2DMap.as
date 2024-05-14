package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.BSEaze;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class Galaxy2DMap extends BSDisplayObject
   {
      
      private static const MAX_MARKERS:uint = 200;
      
      private static const LINE_LERP_TIME:Number = 0.5;
       
      
      public var Menu_mc:MovieClip;
      
      public var StarMapHeader_mc:MovieClip;
      
      private var MarkerClips:Array;
      
      private var MapDataA:Array;
      
      private var PlayerSystemID:uint = 0;
      
      private var HoveredSystemID:uint = 0;
      
      private var StaticMapData:Object;
      
      public function Galaxy2DMap()
      {
         var _loc2_:Galaxy2DMapMarker = null;
         this.MarkerClips = new Array();
         this.MapDataA = new Array();
         super();
         var _loc1_:* = 0;
         while(_loc1_ < MAX_MARKERS)
         {
            _loc2_ = new Galaxy2DMapMarker();
            _loc2_.visible = false;
            this.MarkerClips.push(_loc2_);
            this.Menu_mc.Markers_mc.addChild(_loc2_);
            _loc1_++;
         }
         GlobalFunc.SetText(this.StarMapHeader_mc.Header_mc.text_tf,"$STAR MAP");
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.ShowStarMap();
      }
      
      private function findIndexForBody(param1:uint) : int
      {
         var _loc4_:* = undefined;
         var _loc2_:int = -1;
         var _loc3_:* = 0;
         while(_loc3_ < this.MapDataA.length)
         {
            if((_loc4_ = this.MapDataA[_loc3_]).uBodyID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function UpdateMarkerBasedObjects() : *
      {
         var _loc1_:int = this.findIndexForBody(this.PlayerSystemID);
         if(_loc1_ >= 0 && _loc1_ < this.MarkerClips.length)
         {
            this.Menu_mc.ShipIconBase_mc.x = this.MarkerClips[_loc1_].x;
            this.Menu_mc.ShipIconBase_mc.y = this.MarkerClips[_loc1_].y;
            this.Menu_mc.ShipIconBase_mc.y += this.MarkerClips[_loc1_].height * 0.5 + this.Menu_mc.ShipIconBase_mc.height * 0.5;
         }
         var _loc2_:int = this.findIndexForBody(this.HoveredSystemID);
         if(_loc2_ >= 0)
         {
            BSEaze(this.Menu_mc.VericalLine_mc).LerpTo(LINE_LERP_TIME,this.MarkerClips[_loc2_].x,this.Menu_mc.VericalLine_mc.y);
            BSEaze(this.Menu_mc.HorizontalLine_mc).LerpTo(LINE_LERP_TIME,this.Menu_mc.HorizontalLine_mc.x,this.MarkerClips[_loc2_].y);
         }
      }
      
      public function ShowStarMap() : *
      {
         gotoAndPlay("Open");
      }
      
      public function SetMapMarkers(param1:Array) : *
      {
         var _loc3_:Object = null;
         var _loc4_:MovieClip = null;
         this.MapDataA = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < this.MapDataA.length)
         {
            _loc3_ = this.MapDataA[_loc2_];
            (_loc4_ = this.MarkerClips[_loc2_]).x = _loc3_.fCoordsX;
            _loc4_.y = _loc3_.fCoordsY;
            _loc4_.visible = true;
            _loc2_++;
         }
         while(_loc2_ < this.MarkerClips.length)
         {
            this.MarkerClips[_loc2_++].visible = false;
         }
         this.UpdateMarkerBasedObjects();
      }
      
      public function SetPlayerSystem(param1:uint) : *
      {
         this.PlayerSystemID = param1;
         if(this.HoveredSystemID == 0)
         {
            this.HoveredSystemID = this.PlayerSystemID;
         }
         this.UpdateMarkerBasedObjects();
      }
      
      public function SetHoveredSystem(param1:uint) : *
      {
         this.HoveredSystemID = param1;
         this.UpdateMarkerBasedObjects();
      }
   }
}
