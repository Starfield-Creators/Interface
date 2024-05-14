package
{
   import Shared.AS3.BSDisplayObject;
   import flash.display.MovieClip;
   
   public class MapContainer extends BSDisplayObject
   {
       
      
      public var CursorTrackerBottom_mc:MovieClip;
      
      public var CursorTrackerLeft_mc:MovieClip;
      
      public var CursorTrackerRight_mc:MovieClip;
      
      public var CursorTrackerTop_mc:MovieClip;
      
      public var SideScrollBottom_mc:MovieClip;
      
      public var SideScrollLeft_mc:MovieClip;
      
      public var SideScrollRight_mc:MovieClip;
      
      public var SideScrollTop_mc:MovieClip;
      
      public var MarkersContainer_mc:SurfaceMarkerContainer;
      
      public var Mask_mc:MovieClip;
      
      public var ZoomMeter_mc:MovieClip;
      
      public function MapContainer()
      {
         super();
      }
      
      public function InitMapContainer(param1:int, param2:int) : void
      {
         this.MarkersContainer_mc.Init(param1,param2,this.Mask_mc,this.ZoomMeter_mc);
      }
   }
}
