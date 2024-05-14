package
{
   import Shared.AS3.IMenu;
   import flash.display.MovieClip;
   
   public class GalaxyMarkerMenu extends IMenu
   {
       
      
      public var ShipIconBase_mc:MovieClip;
      
      public var Markers:Array;
      
      public var MarkerClips:Array;
      
      private var MAX_MARKERS:uint = 200;
      
      public function GalaxyMarkerMenu()
      {
         var _loc2_:Marker = null;
         this.Markers = new Array();
         this.MarkerClips = new Array();
         super();
         var _loc1_:* = 0;
         while(_loc1_ < this.MAX_MARKERS)
         {
            _loc2_ = new Marker();
            _loc2_.visible = false;
            this.MarkerClips.push(_loc2_);
            addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function UpdateMarkers() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this.Markers.length)
         {
            if(this.Markers[_loc2_].x < uint.MAX_VALUE && this.Markers[_loc2_].y < uint.MAX_VALUE)
            {
               this.MarkerClips[_loc1_].visible = true;
               this.MarkerClips[_loc1_].TextField_tf.text = this.Markers[_loc2_].text;
               this.MarkerClips[_loc1_].x = this.Markers[_loc2_].x;
               this.MarkerClips[_loc1_].y = this.Markers[_loc2_].y;
               _loc1_++;
            }
            _loc2_++;
         }
         while(_loc1_ < this.MarkerClips.length)
         {
            this.MarkerClips[_loc1_++].visible = false;
         }
      }
   }
}
