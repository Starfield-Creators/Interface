package
{
   import Components.Icons.DynamicPoiIcon;
   import Shared.BSGalaxyTypes;
   import Shared.MapMarkerUtils;
   import flash.display.MovieClip;
   
   public class BodyMarker extends IMarker
   {
      
      private static const UNDISCOVERED_POI_SCALAR:Number = 1.25 / 20;
       
      
      public var poiSelected_mc:MovieClip;
      
      public var SystemPlot_mc:MovieClip;
      
      public var EndPointPlot_mc:MovieClip;
      
      public var EndSystem_mc:MovieClip;
      
      public var SpacePoiMarker_mc:DynamicPoiIcon;
      
      public var UndiscoveredPOIMarker_mc:MovieClip;
      
      private var Nameplate:BodyNameplate;
      
      private var LifeVisual:LifeIcon;
      
      private var IconsTop:BodyIconsAbove;
      
      private var IconsBottom:BodyIconsBelow;
      
      public function BodyMarker()
      {
         super();
         this.Nameplate = new BodyNameplate();
         addChild(this.Nameplate);
         this.LifeVisual = new LifeIcon();
         addChild(this.LifeVisual);
         this.IconsTop = new BodyIconsAbove();
         addChild(this.IconsTop);
         this.IconsBottom = new BodyIconsBelow();
         addChild(this.IconsBottom);
         this.ResetValues();
      }
      
      override public function ResetValues() : void
      {
         this.poiSelected_mc.visible = false;
         this.SystemPlot_mc.visible = false;
         this.EndPointPlot_mc.visible = false;
         this.EndSystem_mc.visible = false;
         this.SpacePoiMarker_mc.scaleX = 0.5;
         this.SpacePoiMarker_mc.scaleY = 0.5;
         this.SpacePoiMarker_mc.visible = false;
         this.UndiscoveredPOIMarker_mc.visible = false;
         this.IconsTop.ResetIcons();
         this.IconsBottom.ResetIcons();
         this.LifeVisual.visible = false;
      }
      
      override public function Update(param1:Object) : void
      {
         var _loc3_:uint = 0;
         this.name = param1.sMarkerText;
         this.Nameplate.Update(param1);
         this.UpdateLifeIcon(param1);
         this.IconsTop.Update(param1,false);
         this.IconsBottom.Update(param1);
         this.UndiscoveredPOIMarker_mc.visible = param1.bHasUndiscoveredPOI;
         var _loc2_:Number = Math.min(1,UNDISCOVERED_POI_SCALAR * param1.fMarkerWidth);
         this.UndiscoveredPOIMarker_mc.scaleX = _loc2_;
         this.UndiscoveredPOIMarker_mc.scaleY = _loc2_;
         this.poiSelected_mc.visible = Boolean(param1.bHasQuestTarget) && Boolean(param1.bIsFocused) && Boolean(param1.bShowDot);
         this.SpacePoiMarker_mc.visible = param1.uBodyType == BSGalaxyTypes.BT_SATELLITE;
         if(this.SpacePoiMarker_mc.visible)
         {
            _loc3_ = !!param1.bMarkerDiscovered ? MapMarkerUtils.LMS_FULL_REVEAL : MapMarkerUtils.LMS_ONLY_TYPE_KNOWN;
            this.SpacePoiMarker_mc.SetLocation(param1.uPoiType,param1.uPoiCategory,_loc3_);
         }
         bodyID = param1.uBodyID;
      }
      
      private function UpdateLifeIcon(param1:Object) : void
      {
         this.LifeVisual.visible = param1.bHasLife;
         this.LifeVisual.x = param1.fMarkerWidth;
         this.LifeVisual.y = -(this.Nameplate.height * 0.7);
      }
   }
}
