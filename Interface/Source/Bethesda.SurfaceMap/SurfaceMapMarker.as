package
{
   import Components.Icons.MapIconsLibrary;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class SurfaceMapMarker extends MovieClip
   {
      
      public static const MARKER_HOVER_ON:String = "MARKER_HOVER_ON";
      
      public static const MARKER_HOVER_OFF:String = "MARKER_HOVER_OFF";
      
      public static const SurfaceMapMenu_MarkerClicked:String = "SurfaceMapMenu_MarkerClicked";
       
      
      public var FOV_mc:MovieClip;
      
      public var QuestIcon_mc:QuestMarker;
      
      public var ShipIcon_mc:MovieClip;
      
      public var MarkerContainer_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var BGHover_mc:MovieClip;
      
      public var IndicatorMarker_mc:MovieClip;
      
      public var Nameplate_mc:MovieClip;
      
      public var ObjectiveAtPOI_mc:QuestMarker;
      
      public var QuestTargetText_mc:MovieClip;
      
      public var BodyViewShipIndicator_mc:MovieClip;
      
      public var MarkerStatusText_mc:MovieClip;
      
      private var LocationMarkerState:uint;
      
      private var LocationMarkerType:uint;
      
      private var bLoadLocation:Boolean = false;
      
      private var LocationClipChild:MovieClip = null;
      
      private var markerData:Object;
      
      private const DISCOVERED:String = "Discovered";
      
      private const UNDISCOVERED:String = "Undiscovered";
      
      public function SurfaceMapMarker()
      {
         this.LocationMarkerState = MapMarkerUtils.LMS_UNKNOWN;
         super();
         mouseEnabled = false;
         if(this.QuestTargetText_mc != null)
         {
            this.QuestTargetText_mc.mouseEnabled = false;
            this.QuestTargetText_mc.mouseChildren = false;
         }
         if(this.Nameplate_mc != null)
         {
            this.Nameplate_mc.mouseEnabled = false;
            this.Nameplate_mc.mouseChildren = false;
         }
         if(this.MarkerStatusText_mc != null)
         {
            this.MarkerStatusText_mc.mouseEnabled = false;
            this.MarkerStatusText_mc.mouseChildren = false;
         }
      }
      
      public function set MarkerData(param1:Object) : void
      {
         this.markerData = param1;
      }
      
      public function get MarkerData() : Object
      {
         return this.markerData;
      }
      
      public function get locationType() : uint
      {
         return this.LocationMarkerType;
      }
      
      public function get needsLocationLoaded() : Boolean
      {
         return this.bLoadLocation;
      }
      
      public function get hasQuestTarget() : Boolean
      {
         return this.markerData == null ? false : Boolean(this.markerData.bHasQuestTarget);
      }
      
      public function get text() : String
      {
         return this.markerData == null ? "" : String(this.markerData.sNameText + this.markerData.sExtraText);
      }
      
      public function get handleBits() : int
      {
         return this.markerData == null ? 0 : int(this.markerData.iMarkerHandleBits);
      }
      
      public function get IsLocation() : Boolean
      {
         return this.markerData == null ? false : Boolean(this.markerData.bIsLocation);
      }
      
      public function EnableListeners() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function LoadIcon(param1:MapIconsLibrary, param2:int, param3:int, param4:uint) : *
      {
         if(param2 == MapMarkerUtils.MARKER_QUEST)
         {
            this.SetQuestLocation(this.markerData.bQuestActive);
         }
         else
         {
            this.SetLocation(param1,param2,param3,param4);
         }
      }
      
      public function GetIconRect(param1:DisplayObject) : *
      {
         if(this.markerData.iMarkerType == MapMarkerUtils.MARKER_QUEST)
         {
            return this.LocationClipChild.BoundingRect_mc.getRect(param1);
         }
         if(this.LocationClipChild != null)
         {
            return this.LocationClipChild.getRect(param1);
         }
         if(this.MarkerContainer_mc != null)
         {
            return this.MarkerContainer_mc.getRect(param1);
         }
         if(this.Icon_mc != null)
         {
            return this.Icon_mc.BoundingRect_mc.getRect(param1);
         }
         return getRect(param1);
      }
      
      public function UpdatePosition(param1:Number, param2:Number) : *
      {
         var _loc3_:Point = parent.globalToLocal(new Point(param1,param2));
         x = _loc3_.x;
         y = _loc3_.y;
      }
      
      public function Init(param1:Object) : *
      {
         var _loc2_:Number = NaN;
         this.MarkerData = param1;
         if(this.QuestTargetText_mc != null)
         {
            GlobalFunc.SetText(this.QuestTargetText_mc.text_tf,param1.sQuestTargetText);
            _loc2_ = Number(this.QuestTargetText_mc.text_tf.textWidth);
            this.QuestTargetText_mc.selectedTextBackground_mc.width = _loc2_ + 16;
            this.QuestTargetText_mc.visible = false;
         }
         if(this.Nameplate_mc != null)
         {
            GlobalFunc.SetText(this.Nameplate_mc.text_tf,this.text);
            _loc2_ = Number(this.Nameplate_mc.text_tf.textWidth);
            this.Nameplate_mc.selectedTextBackground_mc.width = _loc2_ + 16;
            this.Nameplate_mc.visible = false;
         }
         if(this.BGHover_mc != null)
         {
            this.BGHover_mc.visible = false;
         }
         if(this.IndicatorMarker_mc != null)
         {
            this.IndicatorMarker_mc.visible = false;
         }
         visible = false;
      }
      
      public function SetLocation(param1:MapIconsLibrary, param2:uint, param3:uint, param4:uint) : *
      {
         var _loc5_:String = "";
         switch(param4)
         {
            case MapMarkerUtils.LMS_FULL_REVEAL:
               _loc5_ = MapMarkerUtils.GetSymbolName(param2);
               break;
            case MapMarkerUtils.LMS_ONLY_TYPE_KNOWN:
               _loc5_ = MapMarkerUtils.GetGenericSymbolName(param2,param3);
               break;
            case MapMarkerUtils.LMS_UNKNOWN:
               _loc5_ = MapMarkerUtils.GetUnknownSymbolName(param3);
         }
         var _loc6_:MovieClip;
         if((_loc6_ = param1.LoadIcon(_loc5_)) != null)
         {
            this.LocationClipChild = _loc6_;
            this.MarkerContainer_mc.addChild(_loc6_);
            if(this.MarkerData != null)
            {
               if(this.MarkerData.bDiscovered)
               {
                  _loc6_.gotoAndStop(this.DISCOVERED);
               }
               else
               {
                  _loc6_.gotoAndStop(this.UNDISCOVERED);
               }
            }
            this.bLoadLocation = false;
         }
         else
         {
            this.bLoadLocation = true;
         }
         if(this.ObjectiveAtPOI_mc != null)
         {
            this.ObjectiveAtPOI_mc.visible = param2 != MapMarkerUtils.MARKER_QUEST && this.hasQuestTarget;
            if(this.markerData.bQuestActive)
            {
               this.ObjectiveAtPOI_mc.gotoAndStop("Active");
            }
            else
            {
               this.ObjectiveAtPOI_mc.gotoAndStop("Inactive");
            }
         }
      }
      
      public function SetQuestLocation(param1:Boolean) : *
      {
         this.ObjectiveAtPOI_mc.visible = false;
         this.LocationClipChild = new QuestMarker();
         this.MarkerContainer_mc.addChild(this.LocationClipChild);
         if(param1)
         {
            this.LocationClipChild.gotoAndStop("Active");
         }
         else
         {
            this.LocationClipChild.gotoAndStop("Inactive");
         }
         this.bLoadLocation = false;
      }
      
      public function ClearLocation() : *
      {
         if(this.LocationClipChild != null)
         {
            this.MarkerContainer_mc.removeChild(this.LocationClipChild);
            this.LocationClipChild = null;
         }
      }
      
      public function SetTint(param1:ColorTransform) : *
      {
         this.MarkerContainer_mc.transform.colorTransform = param1;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(this.IsLocation && param1 == "Select" && param2 == false)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(SurfaceMapMenu_MarkerClicked,{"markerHandleBits":this.handleBits}));
            return true;
         }
         return false;
      }
      
      private function onMouseOver(param1:MouseEvent) : *
      {
         if(this.Nameplate_mc != null)
         {
            this.Nameplate_mc.visible = true;
         }
         if(this.BGHover_mc != null)
         {
            this.BGHover_mc.visible = true;
            this.BGHover_mc.gotoAndPlay(1);
         }
         if(this.QuestTargetText_mc != null && this.hasQuestTarget)
         {
            this.QuestTargetText_mc.visible = true;
         }
         dispatchEvent(new CustomEvent(MARKER_HOVER_ON,{"Marker":this}));
         GlobalFunc.PlayMenuSound("UIMenuSurfaceMapRollover");
      }
      
      private function onMouseOut(param1:MouseEvent) : *
      {
         if(this.Nameplate_mc != null)
         {
            this.Nameplate_mc.visible = false;
         }
         if(this.BGHover_mc != null)
         {
            this.BGHover_mc.visible = false;
         }
         if(this.QuestTargetText_mc != null)
         {
            this.QuestTargetText_mc.visible = false;
         }
         dispatchEvent(new CustomEvent(MARKER_HOVER_OFF,{"Marker":this}));
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         if(this.IsLocation == true)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(SurfaceMapMenu_MarkerClicked,{"markerHandleBits":this.handleBits}));
         }
      }
   }
}
