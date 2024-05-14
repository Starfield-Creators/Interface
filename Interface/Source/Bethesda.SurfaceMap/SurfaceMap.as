package
{
   import Components.PlanetInfoCard.PlanetInfoCard;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class SurfaceMap extends BSDisplayObject
   {
       
      
      public var Location_mc:MovieClip;
      
      public var Coordinates_mc:MovieClip;
      
      public var Map_mc:MapContainer;
      
      public var PlanetData_mc:PlanetInfoCard;
      
      public function SurfaceMap()
      {
         super();
      }
      
      private function set LocationText(param1:String) : *
      {
         GlobalFunc.SetText(this.Location_mc.text_tf,param1);
      }
      
      override public function onAddedToStage() : void
      {
         BSUIDataManager.Subscribe("SurfaceMapInfo",function(param1:FromClientDataEvent):*
         {
            Map_mc.InitMapContainer(param1.data.iNWCellX,param1.data.iSECellX);
         });
         BSUIDataManager.Subscribe("SurfaceMapBodyInfoProvider",function(param1:FromClientDataEvent):*
         {
            PlanetData_mc.SetBodyInfo(param1.data);
         });
         this.PlanetData_mc.SetUseTraitIcons(true);
         this.PlanetData_mc.SetNoScanMode();
         this.PlanetData_mc.Open();
      }
      
      public function SetFocus() : void
      {
         stage.focus = this.Map_mc.MarkersContainer_mc;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.Map_mc.MarkersContainer_mc.ProcessUserEvent(param1,param2);
      }
      
      public function OnSetSafeRect(param1:Rectangle) : void
      {
         this.Map_mc.Mask_mc.width = param1.width;
         this.Map_mc.Mask_mc.x = -param1.width / 2;
      }
   }
}
