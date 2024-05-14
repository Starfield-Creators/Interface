package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.ViewTypes;
   import aze.motion.EazeTween;
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class GalaxyStarMapMarkers extends BSDisplayObject
   {
      
      private static const MARKER_HIDING_POS:* = -50;
      
      private static const BODIES_PLOTTING_SYMBOL_Y_OFFSET:* = 20;
      
      private static const MAX_SYSTEM_MARKERS:uint = 150;
      
      private static const MAX_BODY_MARKERS:uint = 50;
      
      private static const MAX_OFFSCREEN_MARKERS:uint = 15;
      
      private static const FADE_TYPE_INVALID:uint = 0;
      
      private static const FADE_TYPE_IN:uint = 1;
      
      private static const FADE_TYPE_OUT:uint = 2;
      
      private static const SHIP_ICON_TRAVEL_TIME:Number = 1000;
      
      private static const PLOT_COLOR_VALID:Number = 2794682;
      
      private static const PLOT_COLOR_INVALID:Number = 16711680;
      
      private static const PREVIEW_PLOT_COLOR_VALID:Number = 10066329;
      
      private static const PREVIEW_PLOT_COLOR_INVALID:Number = 12277077;
       
      
      public var ShipIconBase_mc:MovieClip;
      
      public var PlotLines_mc:MovieClip;
      
      public var BodyMarkerContainer_mc:MovieClip;
      
      public var SystemMarkerContainer_mc:MovieClip;
      
      public var OffscreenMarkerContainer_mc:MovieClip;
      
      public var ScreenCenter_mc:MovieClip;
      
      private var plotLines:Shape;
      
      private var previewPlotLines:Shape;
      
      private var shipLocationMarkerListenerActive:Boolean = false;
      
      private var CurrentView:int = 0;
      
      private var BodyLocationID:uint = 0;
      
      private var SystemLocationID:uint = 0;
      
      private var PreviousTime:Number = 0;
      
      private var ShipIconRoutePercentage:Number = 0;
      
      private var TotalValidRouteDistance:Number = 0;
      
      private var PlotLinesInfoA:Vector.<PlotLineInfo>;
      
      private var PlotLinePointsInfoA:Array;
      
      private var PlotPointsInfoA:Array;
      
      private var PreviewPlotLinePointsInfoA:Array;
      
      private var PreviewPlotPointsInfoA:Array;
      
      private var BodiesPlotLinePointsIndicesA:Array;
      
      private var ShowShipLocationMarker:Boolean = false;
      
      private var SystemMarkersA:Array;
      
      private var BodyMarkersA:Array;
      
      private var OffscreenMarkersA:Array;
      
      private var PositionsReceivedEarly:Boolean = false;
      
      private var ViewDirty:Boolean = false;
      
      private var PlotLinesOrMarkersDirty:Boolean = false;
      
      public function GalaxyStarMapMarkers()
      {
         var _loc2_:SystemMarker = null;
         var _loc3_:BodyMarker = null;
         var _loc4_:OffscreenMarker = null;
         this.PlotLinesInfoA = new Vector.<PlotLineInfo>();
         this.PlotLinePointsInfoA = new Array();
         this.PlotPointsInfoA = new Array();
         this.PreviewPlotLinePointsInfoA = new Array();
         this.PreviewPlotPointsInfoA = new Array();
         this.BodiesPlotLinePointsIndicesA = new Array();
         super();
         this.plotLines = new Shape();
         this.previewPlotLines = new Shape();
         this.PlotLines_mc.addChild(this.plotLines);
         this.PlotLines_mc.addChild(this.previewPlotLines);
         this.SystemMarkersA = new Array();
         this.BodyMarkersA = new Array();
         this.OffscreenMarkersA = new Array();
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < MAX_SYSTEM_MARKERS)
         {
            _loc2_ = new SystemMarker();
            this.SystemMarkerContainer_mc.addChild(_loc2_);
            this.SystemMarkersA.push(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_BODY_MARKERS)
         {
            _loc3_ = new BodyMarker();
            this.BodyMarkerContainer_mc.addChild(_loc3_);
            this.BodyMarkersA.push(_loc3_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_OFFSCREEN_MARKERS)
         {
            _loc4_ = new OffscreenMarker();
            this.OffscreenMarkerContainer_mc.addChild(_loc4_);
            this.OffscreenMarkersA.push(_loc4_);
            _loc1_++;
         }
      }
      
      public function QSystemMarker(param1:uint) : SystemMarker
      {
         return this.SystemMarkersA[param1] as SystemMarker;
      }
      
      public function QBodyMarker(param1:uint) : BodyMarker
      {
         return this.BodyMarkersA[param1] as BodyMarker;
      }
      
      public function QOffscreenMarker(param1:uint) : OffscreenMarker
      {
         return this.OffscreenMarkersA[param1] as OffscreenMarker;
      }
      
      private function GetMarkerArray(param1:int) : Array
      {
         return this.CurrentView == ViewTypes.VIEW_GALAXY ? this.SystemMarkersA : this.BodyMarkersA;
      }
      
      private function GetMarkerContainer(param1:int) : MovieClip
      {
         return this.CurrentView == ViewTypes.VIEW_GALAXY ? this.SystemMarkerContainer_mc : this.BodyMarkerContainer_mc;
      }
      
      private function GetLocationID() : uint
      {
         return this.CurrentView == ViewTypes.VIEW_GALAXY ? this.SystemLocationID : this.BodyLocationID;
      }
      
      private function FindIndexForMarker(param1:uint, param2:int) : int
      {
         var _loc6_:* = undefined;
         var _loc3_:int = -1;
         var _loc4_:Array = this.GetMarkerArray(param2);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if((_loc6_ = _loc4_[_loc5_]).bodyID == param1)
            {
               _loc3_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function UpdateCurrentView(param1:int) : void
      {
         var _loc2_:UIDataFromClient = null;
         if(param1 != this.CurrentView)
         {
            this.CurrentView = param1;
            this.ViewDirty = true;
            this.PlotLinesOrMarkersDirty = true;
            SetIsDirty();
            this.SystemMarkerContainer_mc.visible = this.CurrentView == ViewTypes.VIEW_GALAXY;
            this.BodyMarkerContainer_mc.visible = this.CurrentView == ViewTypes.VIEW_SYSTEM;
            this.OffscreenMarkerContainer_mc.visible = true;
            if(this.CurrentView == ViewTypes.VIEW_GALAXY)
            {
               this.ShipIconRoutePercentage = 0;
               if(this.PlotPointsInfoA.length == 0)
               {
                  this.ClearPlotLines();
                  this.HideAllPlotRouteMarkers();
               }
               else
               {
                  addEventListener(Event.ENTER_FRAME,this.UpdateShipLocationMarkerInRoute);
                  this.shipLocationMarkerListenerActive = true;
                  this.PreviousTime = getTimer();
               }
               if(this.PreviewPlotPointsInfoA.length == 0)
               {
                  this.ClearPreviewPlotLines();
                  this.HideAllPreviewPlotRouteMarkers();
               }
            }
            else
            {
               removeEventListener(Event.ENTER_FRAME,this.UpdateShipLocationMarkerInRoute);
               this.shipLocationMarkerListenerActive = false;
               this.HideGalaxyVisuals();
            }
            if(this.PositionsReceivedEarly && this.CurrentView == ViewTypes.VIEW_SYSTEM)
            {
               this.PositionsReceivedEarly = false;
               _loc2_ = BSUIDataManager.GetDataFromClient("StarMapMenuMarkerPositions",false);
               if(_loc2_ != null && _loc2_.data != null)
               {
                  this.ProcessMarkerPositionData(_loc2_.data);
               }
            }
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("StarMapMenuData",function(param1:FromClientDataEvent):*
         {
            if(BodyLocationID != param1.data.uBodyLocationID)
            {
               PlotLinesOrMarkersDirty = true;
               SetIsDirty();
               BodyLocationID = param1.data.uBodyLocationID;
            }
            if(SystemLocationID != param1.data.uSystemLocationID)
            {
               PlotLinesOrMarkersDirty = true;
               SetIsDirty();
               SystemLocationID = param1.data.uSystemLocationID;
            }
            if(param1.data.hasOwnProperty("bShowShipLocationMarker"))
            {
               ShowShipLocationMarker = param1.data.bShowShipLocationMarker;
            }
         });
         BSUIDataManager.Subscribe("StarMapMenuMarkersData",function(param1:FromClientDataEvent):*
         {
            if(CurrentView != ViewTypes.VIEW_GALAXY && param1.data.hasOwnProperty("aMarkersData") && param1.data["aMarkersData"] is Array)
            {
               UpdateMarkers(param1.data["aMarkersData"],GetMarkerArray(CurrentView),GetMarkerContainer(CurrentView));
            }
         });
         BSUIDataManager.Subscribe("StarMapMenuMarkerPositions",function(param1:FromClientDataEvent):*
         {
            PositionsReceivedEarly = ViewTypes.VIEW_SYSTEM != CurrentView;
            if(!PositionsReceivedEarly && param1.data != null)
            {
               ProcessMarkerPositionData(param1.data);
            }
         });
         BSUIDataManager.Subscribe("GalaxyMarkerDefsProvider",function(param1:FromClientDataEvent):*
         {
            UpdateMarkers(param1.data.aMarkerDefs,SystemMarkersA,SystemMarkerContainer_mc);
            UpdatePlotLinesAndMarkers();
            UpdatePlotLinesAndMarkers(true);
         });
         BSUIDataManager.Subscribe("GalaxyMarkersProvider",function(param1:FromClientDataEvent):*
         {
            var _loc4_:Object = null;
            var _loc5_:IMarker = null;
            var _loc2_:Array = param1.data.aMarkerData;
            var _loc3_:uint = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               (_loc5_ = SystemMarkersA[_loc3_] as IMarker).SetPosition(_loc4_.fXCoord,_loc4_.fYCoord,0);
               _loc3_++;
            }
            UpdatePlotLinesAndMarkers();
            UpdatePlotLinesAndMarkers(true);
         });
         BSUIDataManager.Subscribe("StarMapGalaxyFadeEvent",function(param1:FromClientDataEvent):*
         {
            if(param1.data.bFadeMarkers)
            {
               FadeGalaxyMarkers(param1.data.uFadeType,param1.data.fFadeDuration,param1.data.uFadeException);
            }
            if(param1.data.bFadePlotLines)
            {
               FadeGalaxyPlotInfo(param1.data.uFadeType,param1.data.fFadeDuration,param1.data.uFadeException);
            }
         });
         BSUIDataManager.Subscribe("StarMapOffscreenMarkersData",this.UpdateOffscreenMarkers);
      }
      
      private function UpdateOffscreenMarkers(param1:FromClientDataEvent) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:OffscreenMarker = null;
         var _loc7_:OffscreenMarker = null;
         if(param1.data.aOffscreenMarkersDataA != null && param1.data.aOffscreenMarkersDataA is Array)
         {
            _loc2_ = 0;
            while(_loc2_ < this.OffscreenMarkersA.length)
            {
               this.OffscreenMarkersA[_loc2_].SetVisible(false);
               _loc2_++;
            }
            _loc3_ = param1.data.aOffscreenMarkersDataA;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc4_ >= this.OffscreenMarkersA.length)
               {
                  _loc7_ = new OffscreenMarker();
                  this.OffscreenMarkerContainer_mc.addChild(_loc7_);
                  this.OffscreenMarkersA.push(_loc7_);
               }
               _loc5_ = _loc3_[_loc4_];
               (_loc6_ = this.OffscreenMarkersA[_loc4_]).SetData(_loc5_);
               _loc6_.SetVisible(true);
               _loc4_++;
            }
         }
      }
      
      public function HideGalaxyVisuals() : *
      {
         var _loc1_:SystemMarker = null;
         for each(_loc1_ in this.SystemMarkersA)
         {
            _loc1_.FadePlotPointVisuals(1,0,0);
         }
         this.PlotLines_mc.alpha = 0;
         this.ShipIconBase_mc.alpha = 0;
      }
      
      public function FadeGalaxyMarkers(param1:uint, param2:Number, param3:uint) : *
      {
         var _loc6_:SystemMarker = null;
         var _loc4_:Number = param1 == FADE_TYPE_IN ? 0 : 1;
         var _loc5_:Number = param1 == FADE_TYPE_IN ? 1 : 0;
         for each(_loc6_ in this.SystemMarkersA)
         {
            if(_loc6_.bodyID == param3)
            {
               EazeTween.killTweensOf(_loc6_);
               _loc6_.alpha = 1;
               _loc6_.visible = true;
               _loc6_.FadeIcons(_loc4_,_loc5_,param2);
            }
            else
            {
               EazeTween.killTweensOf(_loc6_);
               eaze(_loc6_).apply({"alpha":_loc4_}).to(param2,{"alpha":_loc5_});
            }
         }
      }
      
      public function FadeGalaxyPlotInfo(param1:uint, param2:Number, param3:uint) : *
      {
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc4_:Number = param1 == FADE_TYPE_IN ? 0 : 1;
         var _loc5_:Number = param1 == FADE_TYPE_IN ? 1 : 0;
         if(this.PlotLinePointsInfoA.length > 0 || this.PreviewPlotLinePointsInfoA.length > 0)
         {
            if((_loc6_ = this.FindIndexForMarker(this.SystemLocationID,ViewTypes.VIEW_GALAXY)) >= 0)
            {
               this.SystemMarkersA[_loc6_].FadePlotPointVisuals(_loc4_,_loc5_,param2);
            }
            for each(_loc7_ in this.PlotLinePointsInfoA)
            {
               this.SystemMarkersA[_loc7_.MarkerIndex].FadePlotPointVisuals(_loc4_,_loc5_,param2);
            }
            for each(_loc8_ in this.PreviewPlotLinePointsInfoA)
            {
               this.SystemMarkersA[_loc8_.MarkerIndex].FadePlotPointVisuals(_loc4_,_loc5_,param2);
            }
         }
         EazeTween.killTweensOf(this.PlotLines_mc);
         EazeTween.killTweensOf(this.ShipIconBase_mc);
         eaze(this.PlotLines_mc).apply({"alpha":_loc4_}).to(param2,{"alpha":_loc5_});
         eaze(this.ShipIconBase_mc).apply({"alpha":_loc4_}).to(param2,{"alpha":_loc5_});
      }
      
      override public function redrawDisplayObject() : void
      {
         var _loc1_:UIDataFromClient = null;
         var _loc2_:String = null;
         super.redrawDisplayObject();
         if(this.ViewDirty)
         {
            this.ResetMarkerValues(this.SystemMarkersA);
            this.ResetMarkerValues(this.BodyMarkersA);
            _loc1_ = BSUIDataManager.GetDataFromClient(this.CurrentView == ViewTypes.VIEW_GALAXY ? "GalaxyMarkerDefsProvider" : "StarMapMenuMarkersData",false);
            if(_loc1_ != null)
            {
               _loc2_ = this.CurrentView == ViewTypes.VIEW_GALAXY ? "aMarkerDefs" : "aMarkersData";
               if(_loc1_.data[_loc2_] != null)
               {
                  this.UpdateMarkers(_loc1_.data[_loc2_],this.GetMarkerArray(this.CurrentView),this.GetMarkerContainer(this.CurrentView));
               }
            }
            this.ViewDirty = false;
         }
         if(this.PlotLinesOrMarkersDirty)
         {
            this.UpdatePlotLinesAndMarkers();
            this.UpdatePlotLinesAndMarkers(true);
            this.PlotLinesOrMarkersDirty = false;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:IMarker = null;
         var _loc4_:Array = this.GetMarkerArray(this.CurrentView);
         var _loc5_:Boolean = false;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc3_ = _loc4_[_loc6_];
            if(_loc3_.ProcessUserEvent(param1,param2))
            {
               _loc5_ = true;
               break;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function UpdateMarkers(param1:Array, param2:Array, param3:MovieClip) : *
      {
         var _loc4_:Object = null;
         var _loc5_:IMarker = null;
         SystemNameplate.PreUpdate();
         BodyNameplate.PreUpdate();
         var _loc6_:int = Math.min(param1.length,param2.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = param1[_loc7_];
            (_loc5_ = param2[_loc7_]).Update(_loc4_);
            _loc5_.visible = true;
            _loc7_++;
         }
         while(_loc7_ < param2.length)
         {
            (_loc5_ = param2[_loc7_]).name = "Unused";
            _loc5_.visible = false;
            _loc7_++;
         }
      }
      
      public function ProcessMarkerPositionData(param1:Object) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:IMarker = null;
         if(param1.hasOwnProperty("markerPositionsA") && param1["markerPositionsA"] is Array)
         {
            _loc2_ = param1["markerPositionsA"];
            _loc3_ = this.GetMarkerArray(ViewTypes.VIEW_SYSTEM);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = _loc2_[_loc4_];
               (_loc6_ = _loc3_[_loc4_] as IMarker).SetPosition(_loc5_.xCoord,_loc5_.yCoord,_loc5_.zCoord);
               _loc4_++;
            }
            this.PlotLinesOrMarkersDirty = true;
            SetIsDirty();
         }
      }
      
      public function UpdatePlotLinesAndMarkers(param1:Boolean = false) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:PlotLinePointsInfo = null;
         var _loc11_:Boolean = false;
         var _loc12_:* = undefined;
         var _loc13_:SystemMarker = null;
         var _loc2_:Boolean = false;
         var _loc3_:Array = param1 ? this.PreviewPlotPointsInfoA : this.PlotPointsInfoA;
         var _loc4_:Array = param1 ? this.PreviewPlotLinePointsInfoA : this.PlotLinePointsInfoA;
         if(this.CurrentView != ViewTypes.VIEW_GALAXY)
         {
            _loc2_ = true;
         }
         else if(_loc3_.length == 0)
         {
            if(param1)
            {
               this.PreviewPlotLinePointsInfoA.splice(0,this.PreviewPlotLinePointsInfoA.length);
            }
            else
            {
               this.PlotLinePointsInfoA.splice(0,this.PlotLinePointsInfoA.length);
               this.PlotLinesInfoA.splice(0,this.PlotLinesInfoA.length);
            }
            if(this.PlotLinePointsInfoA.length == 0)
            {
               this.UpdateShipLocationMarker();
            }
            _loc2_ = true;
         }
         if(_loc2_)
         {
            return;
         }
         var _loc5_:Array = new Array();
         var _loc6_:int = -1;
         for each(_loc7_ in _loc3_)
         {
            if((_loc9_ = this.FindIndexForMarker(_loc7_.uSystemID,ViewTypes.VIEW_GALAXY)) > -1 && _loc9_ != _loc6_)
            {
               _loc10_ = new PlotLinePointsInfo(_loc9_,_loc7_.bCanExecuteJump,_loc7_.bPreview);
               _loc5_.push(_loc10_);
               _loc6_ = _loc9_;
            }
         }
         for each(_loc8_ in _loc4_)
         {
            _loc11_ = true;
            for each(_loc12_ in _loc5_)
            {
               if(_loc8_.MarkerIndex == _loc12_.MarkerIndex)
               {
                  _loc11_ = false;
                  break;
               }
            }
            if(_loc11_)
            {
               if((_loc13_ = this.SystemMarkersA[_loc8_.MarkerIndex]) != null)
               {
                  _loc13_.OnRemovedFromRoute();
                  _loc13_.SetPlotPointType(SystemMarker.PLOT_POINT_NONE);
               }
            }
         }
         if(param1)
         {
            this.PreviewPlotLinePointsInfoA = _loc5_;
         }
         else
         {
            this.PlotLinePointsInfoA = _loc5_;
         }
         if(this.CurrentView == ViewTypes.VIEW_GALAXY)
         {
            if(param1 && this.PreviewPlotLinePointsInfoA.length > 0)
            {
               this.DrawPreviewPlotLines();
            }
            else if(this.PlotLinePointsInfoA.length > 0)
            {
               this.DrawPlotLines();
            }
         }
         this.UpdateShipLocationMarkerListener();
      }
      
      private function UpdateShipLocationMarkerListener() : *
      {
         if(!this.shipLocationMarkerListenerActive && this.PlotLinesInfoA.length > 0 && this.PlotLinePointsInfoA.length >= 1)
         {
            addEventListener(Event.ENTER_FRAME,this.UpdateShipLocationMarkerInRoute);
            this.shipLocationMarkerListenerActive = true;
         }
         else if(this.shipLocationMarkerListenerActive && (this.PlotLinesInfoA.length == 0 || this.PlotLinePointsInfoA.length < 1))
         {
            removeEventListener(Event.ENTER_FRAME,this.UpdateShipLocationMarkerInRoute);
            this.shipLocationMarkerListenerActive = false;
         }
      }
      
      public function ResetMarkerValues(param1:Array) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            (param1[_loc2_] as IMarker).ResetValues();
            _loc2_++;
         }
      }
      
      public function DrawPlotLines() : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:uint = 0;
         var _loc11_:SystemMarker = null;
         var _loc12_:uint = 0;
         var _loc13_:SystemMarker = null;
         var _loc14_:* = undefined;
         var _loc15_:PlotLineInfo = null;
         var _loc16_:SystemMarker = null;
         this.plotLines.graphics.clear();
         this.PlotLinesInfoA = new Vector.<PlotLineInfo>();
         this.TotalValidRouteDistance = 0;
         if(this.PlotLinePointsInfoA.length == 0)
         {
            return;
         }
         var _loc1_:int = this.FindIndexForMarker(this.SystemLocationID,ViewTypes.VIEW_GALAXY);
         if(_loc1_ < 0)
         {
            return;
         }
         this.plotLines.graphics.lineStyle(2,PLOT_COLOR_VALID,2,false,"none");
         var _loc4_:SystemMarker = this.SystemMarkersA[_loc1_];
         _loc6_ = new Point(_loc4_.x,_loc4_.y);
         if(this.PlotLinePointsInfoA.length == 1 && _loc1_ == this.PlotLinePointsInfoA[0].MarkerIndex)
         {
            _loc4_.SetPlotPointType(SystemMarker.PLOT_POINT_CIRCLE);
            if(this.PlotLinePointsInfoA[0].CanExecuteJump)
            {
               _loc4_.SetPlotCircleColor(SystemMarker.MARKER_COLOR_VALID_JUMP);
            }
            else
            {
               _loc4_.SetPlotCircleColor(SystemMarker.MARKER_COLOR_INVALID_JUMP);
            }
         }
         else
         {
            _loc10_ = 0;
            if(_loc1_ == this.PlotLinePointsInfoA[0].MarkerIndex)
            {
               _loc10_++;
            }
            _loc11_ = this.SystemMarkersA[this.PlotLinePointsInfoA[_loc10_].MarkerIndex];
            _loc4_.UpdateEndStartRotation(_loc11_.x,_loc11_.y);
            _loc4_.SetPlotPointType(SystemMarker.PLOT_POINT_START_END);
            if(this.PlotLinePointsInfoA[0].CanExecuteJump)
            {
               _loc4_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_VALID_JUMP);
            }
            else
            {
               _loc4_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_INVALID_JUMP);
            }
            _loc12_ = _loc10_;
            while(_loc12_ < this.PlotLinePointsInfoA.length)
            {
               _loc5_ = _loc6_;
               this.setChildIndex(this.plotLines,0);
               if(this.PlotLinePointsInfoA[_loc12_].CanExecuteJump)
               {
                  this.plotLines.graphics.lineStyle(2,PLOT_COLOR_VALID,2,false,"none");
                  _loc3_ = SystemMarker.MARKER_COLOR_VALID_JUMP;
                  _loc2_ = true;
               }
               else
               {
                  this.plotLines.graphics.lineStyle(2,PLOT_COLOR_INVALID,2,false,"none");
                  _loc3_ = SystemMarker.MARKER_COLOR_INVALID_JUMP;
                  _loc2_ = false;
               }
               (_loc4_ = this.SystemMarkersA[this.PlotLinePointsInfoA[_loc12_].MarkerIndex]).SetPlotCircleColor(_loc3_);
               (_loc7_ = (_loc6_ = new Point(_loc4_.x,_loc4_.y)).subtract(_loc5_)).normalize(_loc4_.SystemPlot_mc.height / 2);
               _loc8_ = _loc5_.add(_loc7_);
               _loc9_ = _loc6_.subtract(_loc7_);
               this.plotLines.graphics.moveTo(_loc8_.x,_loc8_.y);
               this.plotLines.graphics.lineTo(_loc9_.x,_loc9_.y);
               if(_loc2_)
               {
                  _loc14_ = Point.distance(_loc8_,_loc9_);
                  this.TotalValidRouteDistance += _loc14_;
                  _loc15_ = new PlotLineInfo(_loc14_,_loc8_,_loc9_);
                  this.PlotLinesInfoA.push(_loc15_);
               }
               if(_loc12_ != this.PlotLinePointsInfoA.length - 1)
               {
                  _loc4_.SetPlotPointType(SystemMarker.PLOT_POINT_CIRCLE);
               }
               _loc12_++;
            }
            (_loc13_ = this.SystemMarkersA[this.PlotLinePointsInfoA[this.PlotLinePointsInfoA.length - 1].MarkerIndex]).SetPlotPointType(SystemMarker.PLOT_POINT_START_END);
            if(this.PlotLinePointsInfoA.length == 1)
            {
               _loc13_.UpdateEndStartRotation(this.ShipIconBase_mc.x,this.ShipIconBase_mc.y);
            }
            else
            {
               _loc16_ = this.SystemMarkersA[this.PlotLinePointsInfoA[this.PlotLinePointsInfoA.length - 2].MarkerIndex];
               _loc13_.UpdateEndStartRotation(_loc16_.x,_loc16_.y);
            }
            if(_loc2_)
            {
               _loc13_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_VALID_JUMP);
            }
            else
            {
               _loc13_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_INVALID_JUMP);
            }
         }
      }
      
      public function DrawPreviewPlotLines() : *
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:uint = 0;
         var _loc9_:SystemMarker = null;
         var _loc10_:uint = 0;
         var _loc11_:SystemMarker = null;
         var _loc12_:* = undefined;
         var _loc13_:PlotLineInfo = null;
         var _loc14_:SystemMarker = null;
         this.previewPlotLines.graphics.clear();
         this.TotalValidRouteDistance = 0;
         if(this.PreviewPlotLinePointsInfoA.length == 0)
         {
            return;
         }
         var _loc1_:int = this.FindIndexForMarker(this.SystemLocationID,ViewTypes.VIEW_GALAXY);
         if(_loc1_ < 0)
         {
            return;
         }
         var _loc2_:SystemMarker = this.SystemMarkersA[_loc1_];
         _loc4_ = new Point(_loc2_.x,_loc2_.y);
         if(this.PreviewPlotLinePointsInfoA.length == 1 && _loc1_ == this.PreviewPlotLinePointsInfoA[0].MarkerIndex)
         {
            _loc2_.SetPlotPointType(SystemMarker.PLOT_POINT_CIRCLE);
            _loc2_.SetPlotCircleColor(SystemMarker.MARKER_COLOR_PREVIEW);
         }
         else
         {
            _loc8_ = 0;
            if(_loc1_ == this.PreviewPlotLinePointsInfoA[0].MarkerIndex)
            {
               _loc8_++;
            }
            _loc9_ = this.SystemMarkersA[this.PreviewPlotLinePointsInfoA[_loc8_].MarkerIndex];
            _loc2_.UpdateEndStartRotation(_loc9_.x,_loc9_.y);
            _loc2_.SetPlotPointType(SystemMarker.PLOT_POINT_START_END);
            _loc2_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_PREVIEW);
            _loc10_ = _loc8_;
            while(_loc10_ < this.PreviewPlotLinePointsInfoA.length)
            {
               _loc3_ = _loc4_;
               this.setChildIndex(this.previewPlotLines,0);
               this.previewPlotLines.graphics.lineStyle(2,PREVIEW_PLOT_COLOR_VALID,2,false,"none");
               _loc2_ = this.SystemMarkersA[this.PreviewPlotLinePointsInfoA[_loc10_].MarkerIndex];
               if(this.PreviewPlotLinePointsInfoA[_loc10_].CanExecuteJump)
               {
                  this.previewPlotLines.graphics.lineStyle(2,PREVIEW_PLOT_COLOR_VALID,2,false,"none");
                  _loc2_.SetPlotCircleColor(SystemMarker.MARKER_COLOR_PREVIEW);
               }
               else
               {
                  this.previewPlotLines.graphics.lineStyle(2,PREVIEW_PLOT_COLOR_INVALID,2,false,"none");
                  _loc2_.SetPlotCircleColor(SystemMarker.MARKER_COLOR_INVALID_PREVIEW);
               }
               (_loc5_ = (_loc4_ = new Point(_loc2_.x,_loc2_.y)).subtract(_loc3_)).normalize(_loc2_.SystemPlot_mc.height / 2);
               _loc6_ = _loc3_.add(_loc5_);
               _loc7_ = _loc4_.subtract(_loc5_);
               this.previewPlotLines.graphics.moveTo(_loc6_.x,_loc6_.y);
               this.previewPlotLines.graphics.lineTo(_loc7_.x,_loc7_.y);
               _loc12_ = Point.distance(_loc6_,_loc7_);
               this.TotalValidRouteDistance += _loc12_;
               _loc13_ = new PlotLineInfo(_loc12_,_loc6_,_loc7_);
               if(_loc10_ != this.PreviewPlotLinePointsInfoA.length - 1)
               {
                  _loc2_.SetPlotPointType(SystemMarker.PLOT_POINT_CIRCLE);
               }
               _loc10_++;
            }
            (_loc11_ = this.SystemMarkersA[this.PreviewPlotLinePointsInfoA[this.PreviewPlotLinePointsInfoA.length - 1].MarkerIndex]).SetPlotPointType(SystemMarker.PLOT_POINT_START_END);
            if(this.PreviewPlotLinePointsInfoA.length == 1)
            {
               _loc11_.UpdateEndStartRotation(this.ShipIconBase_mc.x,this.ShipIconBase_mc.y);
            }
            else
            {
               _loc14_ = this.SystemMarkersA[this.PreviewPlotLinePointsInfoA[this.PreviewPlotLinePointsInfoA.length - 2].MarkerIndex];
               _loc11_.UpdateEndStartRotation(_loc14_.x,_loc14_.y);
            }
            if(this.PreviewPlotLinePointsInfoA[this.PreviewPlotLinePointsInfoA.length - 1].CanExecuteJump)
            {
               _loc11_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_PREVIEW);
            }
            else
            {
               _loc11_.SetStartEndPlotColor(SystemMarker.MARKER_COLOR_INVALID_PREVIEW);
            }
         }
      }
      
      public function ClearPlotLines() : *
      {
         this.plotLines.graphics.clear();
      }
      
      public function ClearPreviewPlotLines() : *
      {
         this.previewPlotLines.graphics.clear();
      }
      
      public function UpdateShipLocationMarker() : *
      {
         var _loc3_:IMarker = null;
         var _loc1_:Array = this.GetMarkerArray(this.CurrentView);
         var _loc2_:int = this.FindIndexForMarker(this.GetLocationID(),this.CurrentView);
         if(_loc2_ > -1 && _loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            this.ShipIconBase_mc.x = _loc3_.x;
            this.ShipIconBase_mc.y = _loc3_.y;
            this.ShipIconBase_mc.y += _loc3_.QHeight() * 0.5 + this.ShipIconBase_mc.height * 0.5;
            this.ShipIconBase_mc.visible = this.ShowShipLocationMarker;
            this.ShipIconBase_mc.rotation = 0;
         }
         else
         {
            this.HideShipLocationMarker();
         }
      }
      
      private function HideShipLocationMarker() : *
      {
         this.ShipIconBase_mc.x = MARKER_HIDING_POS;
         this.ShipIconBase_mc.y = MARKER_HIDING_POS;
         this.ShipIconBase_mc.visible = false;
      }
      
      public function HideAllPlotRouteMarkers() : *
      {
         var _loc1_:SystemMarker = null;
         if(this.SystemMarkersA == null || this.SystemMarkersA.length == 0)
         {
            return;
         }
         var _loc2_:int = this.FindIndexForMarker(this.SystemLocationID,ViewTypes.VIEW_GALAXY);
         if(_loc2_ != -1)
         {
            _loc1_ = this.SystemMarkersA[_loc2_];
            _loc1_.SetPlotPointType(SystemMarker.PLOT_POINT_NONE);
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.PlotLinePointsInfoA.length)
         {
            _loc1_ = this.SystemMarkersA[this.PlotLinePointsInfoA[_loc3_].MarkerIndex];
            _loc1_.SetPlotPointType(SystemMarker.PLOT_POINT_NONE);
            _loc3_++;
         }
      }
      
      public function HideAllPreviewPlotRouteMarkers() : *
      {
         var _loc1_:SystemMarker = null;
         if(this.SystemMarkersA == null || this.SystemMarkersA.length == 0)
         {
            return;
         }
         var _loc2_:int = this.FindIndexForMarker(this.SystemLocationID,ViewTypes.VIEW_GALAXY);
         if(_loc2_ != -1)
         {
            _loc1_ = this.SystemMarkersA[_loc2_];
            _loc1_.SetPlotPointType(SystemMarker.PLOT_POINT_NONE);
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.PreviewPlotLinePointsInfoA.length)
         {
            _loc1_ = this.SystemMarkersA[this.PreviewPlotLinePointsInfoA[_loc3_].MarkerIndex];
            _loc1_.SetPlotPointType(SystemMarker.PLOT_POINT_NONE);
            _loc3_++;
         }
      }
      
      private function UpdateShipLocationMarkerInRoute(param1:Event) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:PlotLineInfo = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc2_:int = this.FindIndexForMarker(this.SystemLocationID,ViewTypes.VIEW_GALAXY);
         if(this.CurrentView != ViewTypes.VIEW_GALAXY || _loc2_ < 0)
         {
            this.UpdateShipLocationMarker();
            return;
         }
         var _loc3_:* = getTimer() - this.PreviousTime;
         this.PreviousTime = getTimer();
         if(this.PlotLinesInfoA.length == 0 || this.PlotLinePointsInfoA.length < 1)
         {
            this.UpdateShipLocationMarker();
            this.UpdateShipLocationMarkerListener();
         }
         else
         {
            this.ShipIconBase_mc.visible = this.TotalValidRouteDistance != 0;
            _loc5_ = _loc4_ = this.ShipIconRoutePercentage * this.TotalValidRouteDistance;
            _loc6_ = 0;
            while(_loc5_ > this.PlotLinesInfoA[_loc6_].LineDistance)
            {
               _loc5_ -= this.PlotLinesInfoA[_loc6_].LineDistance;
               _loc6_ = (_loc6_ + 1) % this.PlotLinesInfoA.length;
            }
            _loc8_ = (_loc7_ = this.PlotLinesInfoA[_loc6_]).LineDistance / SHIP_ICON_TRAVEL_TIME * _loc3_;
            this.ShipIconRoutePercentage = (_loc8_ + _loc4_) / this.TotalValidRouteDistance;
            if((_loc5_ += _loc8_) > _loc7_.LineDistance)
            {
               _loc5_ -= _loc7_.LineDistance;
               _loc6_ = (_loc6_ + 1) % this.PlotLinesInfoA.length;
               _loc7_ = this.PlotLinesInfoA[_loc6_];
            }
            _loc9_ = Quadratic.easeInOut(_loc5_ / _loc7_.LineDistance);
            _loc10_ = Point.interpolate(_loc7_.EndPoint,_loc7_.StartPoint,_loc9_);
            if(_loc9_ < 0.1)
            {
               this.ShipIconBase_mc.alpha = _loc9_ * 10;
            }
            else if(_loc9_ > 0.9)
            {
               this.ShipIconBase_mc.alpha = (1 - _loc9_) * 10;
            }
            else
            {
               this.ShipIconBase_mc.alpha = 1;
            }
            this.ShipIconBase_mc.x = _loc10_.x;
            this.ShipIconBase_mc.y = _loc10_.y;
            this.ShipIconBase_mc.rotation = -(Math.atan2(_loc7_.StartPoint.x - _loc7_.EndPoint.x,_loc7_.StartPoint.y - _loc7_.EndPoint.y) * 180 / Math.PI);
         }
      }
      
      public function SetPlotPoints(param1:Array) : *
      {
         this.PlotPointsInfoA = param1;
         if(this.PlotPointsInfoA.length == 0)
         {
            this.ViewDirty = true;
            this.PlotLinesOrMarkersDirty = true;
            SetIsDirty();
            this.ClearPlotLines();
         }
      }
      
      public function SetPreviewPlotPoints(param1:Array) : *
      {
         this.PreviewPlotPointsInfoA = param1;
         if(this.PreviewPlotPointsInfoA.length == 0)
         {
            this.ViewDirty = true;
            this.PlotLinesOrMarkersDirty = true;
            SetIsDirty();
            this.ClearPreviewPlotLines();
         }
      }
   }
}

class PlotLinePointsInfo
{
    
   
   public var MarkerIndex:uint;
   
   public var CanExecuteJump:Boolean;
   
   public var Preview:Boolean;
   
   public function PlotLinePointsInfo(param1:uint, param2:Boolean, param3:Boolean)
   {
      super();
      this.MarkerIndex = param1;
      this.CanExecuteJump = param2;
      this.Preview = param3;
   }
}

import flash.geom.Point;

class PlotLineInfo
{
    
   
   public var LineDistance:Number;
   
   public var StartPoint:Point;
   
   public var EndPoint:Point;
   
   public function PlotLineInfo(param1:Number, param2:Point, param3:Point)
   {
      super();
      this.LineDistance = param1;
      this.StartPoint = param2;
      this.EndPoint = param3;
   }
}
