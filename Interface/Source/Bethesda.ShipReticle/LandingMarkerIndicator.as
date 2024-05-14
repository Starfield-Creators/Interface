package
{
   import Components.Icons.BodyViewMarker;
   import Components.Icons.BodyViewPointer;
   import Components.Icons.MapIconsLibrary;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.events.Event;
   
   public class LandingMarkerIndicator extends TargetIconBase
   {
      
      private static var MapIconsLoader:MapIconsLibrary = null;
      
      private static const POINTER_PADDING:Number = 10;
       
      
      public var LandingMarker_mc:BodyViewMarker;
      
      public var Pointer_mc:BodyViewPointer;
      
      public function LandingMarkerIndicator()
      {
         super();
         GlobalFunc.SetText(Name_tf,"");
         GlobalFunc.SetText(Distance_tf,"");
         GlobalFunc.SetText(this.LandingMarker_mc.ObjectiveNameplate_mc.text_tf,"");
         this.LandingMarker_mc.ObjectiveAtPOIInactive_mc.visible = false;
         this.LandingMarker_mc.IndicatorMarker_mc.visible = false;
         this.LandingMarker_mc.MarkerContainer_mc.visible = true;
         this.LandingMarker_mc.BGHover_mc.HighlightPulse.visible = false;
         if(MapIconsLoader == null)
         {
            MapIconsLoader = new MapIconsLibrary();
         }
         MapIconsLoader.addEventListener(MapIconsLibrary.LIBRARY_LOADED,this.OnMapIconLibraryLoaded);
         if(Divider_mc != null)
         {
            Divider_mc.visible = false;
         }
      }
      
      override public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         var _loc5_:Boolean = false;
         super.SetTargetLowInfo(param1,param2,param3);
         this.LandingMarker_mc.MarkerContainer_mc.gotoAndStop(BodyViewMarker.GetMarkerLabel(param1.uMarkerType));
         if(param1.uMarkerType == MapMarkerUtils.INSPECT_MARKER_TYPE_LOCATION)
         {
            this.LandingMarker_mc.SetLocation(MapIconsLoader,MapMarkerUtils.GetSymbolName(param1.uPoiType));
         }
         else
         {
            this.LandingMarker_mc.ClearLocation();
         }
         this.LandingMarker_mc.ObjectiveAtPOI_mc.visible = param1.bHasQuestTarget;
         if(param1.uMarkerType == MapMarkerUtils.INSPECT_MARKER_TYPE_SHIP)
         {
            GlobalFunc.SetText(this.LandingMarker_mc.Nameplate_mc.text_tf,"$PLAYER SHIP");
         }
         else
         {
            GlobalFunc.SetText(this.LandingMarker_mc.Nameplate_mc.text_tf,param1.name);
         }
         this.Pointer_mc.visible = param1.bBehindCelestialBody;
         this.LandingMarker_mc.LandingMarker_mc.visible = param1.isInfoTarget;
         var _loc4_:Boolean;
         if((_loc4_ = Boolean(param1.bLandingAllowed) && !param1.bLandingDisabled) && Boolean(param1.bIsHoverTarget))
         {
            this.LandingMarker_mc.BGHover_mc.visible = true;
            this.LandingMarker_mc.SetTint(BodyViewMarker.HIGHLIGHT_TINT);
         }
         else
         {
            _loc5_ = false;
            switch(param1.uMarkerType)
            {
               case MapMarkerUtils.INSPECT_MARKER_TYPE_LANDING:
               case MapMarkerUtils.INSPECT_MARKER_TYPE_QUEST:
               case MapMarkerUtils.INSPECT_MARKER_TYPE_OUTPOST:
               case MapMarkerUtils.INSPECT_MARKER_TYPE_LOCATION:
               case MapMarkerUtils.INSPECT_MARKER_TYPE_UNKNOWN:
                  _loc5_ = true;
            }
            if(_loc4_ || !_loc5_)
            {
               this.LandingMarker_mc.SetTint(BodyViewMarker.BASE_TINT);
               this.LandingMarker_mc.SetDiscovered(param1.bMarkerDiscovered);
            }
            else
            {
               this.LandingMarker_mc.SetTint(BodyViewMarker.DISABLED_TINT);
            }
            this.LandingMarker_mc.BGHover_mc.gotoAndPlay(1);
         }
         if(_loc4_ && !param1.bMarkerDiscovered)
         {
            this.LandingMarker_mc.BGHover_mc.HighlightPulse.gotoAndStop(BodyViewMarker.GetHighlightHoverFrame(param1.uMarkerType));
            this.LandingMarker_mc.BGHover_mc.HighlightPulse.visible = true;
         }
         else
         {
            this.LandingMarker_mc.BGHover_mc.HighlightPulse.visible = false;
         }
         this.LandingMarker_mc.BGGroupFrame_mc.visible = param1.bIsGroupMarker;
      }
      
      override public function SetTargetHighInfo(param1:Object) : *
      {
         TargetHigh = param1;
         this.Pointer_mc.rotation = param1.rotationZ * (180 / Math.PI);
         var _loc2_:Number = this.LandingMarker_mc.MarkerContainer_mc.width / 2 + POINTER_PADDING;
         this.Pointer_mc.x = -Math.cos(param1.rotationZ) * _loc2_ + this.LandingMarker_mc.x;
         this.Pointer_mc.y = -Math.sin(param1.rotationZ) * _loc2_ + this.LandingMarker_mc.y;
      }
      
      private function OnMapIconLibraryLoaded(param1:Event) : *
      {
         if(this.LandingMarker_mc.needsLocationLoaded())
         {
            this.LandingMarker_mc.SetLocation(MapIconsLoader,this.LandingMarker_mc.locationType());
         }
         MapIconsLoader.removeEventListener(MapIconsLibrary.LIBRARY_LOADED,this.OnMapIconLibraryLoaded);
      }
      
      override protected function TryUpdateName() : Boolean
      {
         return false;
      }
   }
}
