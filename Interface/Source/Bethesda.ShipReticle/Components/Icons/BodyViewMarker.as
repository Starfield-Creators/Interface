package Components.Icons
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   
   public class BodyViewMarker extends MovieClip
   {
      
      public static const FACING_FRAME:String = "facingAlpha";
      
      public static const NOT_FACING_FRAME:String = "notFacingAlpha";
      
      public static const BASE_TINT:uint = EnumHelper.GetEnum(0);
      
      public static const DISABLED_TINT:uint = EnumHelper.GetEnum();
      
      public static const HIGHLIGHT_TINT:uint = EnumHelper.GetEnum();
      
      public static const TINT_COUNT:uint = EnumHelper.GetEnum();
      
      private static const RedMultipliers:Array = new Array(1,0.439,1.234);
      
      private static const GreenMultipliers:Array = new Array(1,0.439,0.82);
      
      private static const BlueMultipliers:Array = new Array(1,0.439,0.175);
      
      private static const QUEST_TEXT_TRUNCATE_LENGTH_LRG:int = 36;
       
      
      public var MarkerContainer_mc:MovieClip;
      
      public var MarkerStatusText_mc:MovieClip;
      
      public var BGHover_mc:MovieClip;
      
      public var BGGroupFrame_mc:MovieClip;
      
      public var LandingMarker_mc:MovieClip;
      
      public var IndicatorMarker_mc:MovieClip;
      
      public var Nameplate_mc:MovieClip;
      
      public var ObjectiveNameplate_mc:MovieClip;
      
      public var ObjectiveAtPOI_mc:MissionMarker_Anim;
      
      public var ObjectiveAtPOIInactive_mc:MissionMarker_inactive;
      
      public var PlayerMarker_mc:MovieClip;
      
      public var BodyViewShipIndicator_mc:MovieClip;
      
      private var sLocationMarkerType:String = "";
      
      private var bLoadLocation:Boolean = false;
      
      private var LocationClipChild:MovieClip = null;
      
      private var ObjectiveNameplateInitialY:int;
      
      public var onMissionIconHoverChangeCallback:Function = null;
      
      private var iMarkerIndex:* = 0;
      
      private var bMarkerHighlighted:Boolean = false;
      
      private var bMissionIconHovered:Boolean = false;
      
      private var bIsDiscovered:Boolean = false;
      
      private const VERTICAL_TEXT_PADDING:int = 10;
      
      private var LastTint:uint;
      
      public function BodyViewMarker()
      {
         this.LastTint = BASE_TINT;
         super();
         this.ObjectiveAtPOI_mc.onRolloverCallback = this.OnMissionIconRollover;
         this.ObjectiveAtPOI_mc.onRolloutCallback = this.OnMissionIconRollout;
         this.ObjectiveAtPOIInactive_mc.onRolloverCallback = this.OnMissionIconRollover;
         this.ObjectiveAtPOIInactive_mc.onRolloutCallback = this.OnMissionIconRollout;
         this.ObjectiveNameplateInitialY = this.ObjectiveNameplate_mc.y;
         this.ObjectiveNameplate_mc.text_tf.autoSize = TextFieldAutoSize.NONE;
      }
      
      public static function GetMarkerLabel(param1:uint) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case MapMarkerUtils.INSPECT_MARKER_TYPE_LANDING:
               _loc2_ = "Landing";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_QUEST:
               _loc2_ = "Quest";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_OUTPOST:
               _loc2_ = "Outpost";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_SHIP:
               _loc2_ = "ShipLanded";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_PLAYER:
               _loc2_ = "Player";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_LOCATION:
               _loc2_ = "Location";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_UNKNOWN:
            default:
               _loc2_ = "Unknown";
         }
         return _loc2_;
      }
      
      public static function GetHighlightHoverFrame(param1:uint) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case MapMarkerUtils.INSPECT_MARKER_TYPE_QUEST:
               _loc2_ = "Objective";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_SHIP:
               _loc2_ = "PlayerShip";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_PLAYER:
               _loc2_ = "Player";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_OUTPOST:
               _loc2_ = "Colony";
               break;
            case MapMarkerUtils.INSPECT_MARKER_TYPE_LOCATION:
            case MapMarkerUtils.INSPECT_MARKER_TYPE_UNKNOWN:
            default:
               _loc2_ = "POI";
         }
         return _loc2_;
      }
      
      public function locationType() : String
      {
         return this.sLocationMarkerType;
      }
      
      public function needsLocationLoaded() : Boolean
      {
         return this.bLoadLocation;
      }
      
      public function SetIsHighlighted(param1:Boolean) : *
      {
         this.bMarkerHighlighted = param1;
      }
      
      public function IsHighlighted() : Boolean
      {
         return this.bMarkerHighlighted || this.bMissionIconHovered;
      }
      
      public function set MarkerIndex(param1:int) : *
      {
         this.iMarkerIndex = param1;
      }
      
      public function get MarkerIndex() : *
      {
         return this.iMarkerIndex;
      }
      
      public function set IsDiscovered(param1:Boolean) : *
      {
         this.bIsDiscovered = param1;
      }
      
      private function IsLargeTextMode() : Boolean
      {
         return false;
      }
      
      public function SetLocation(param1:MapIconsLibrary, param2:String) : *
      {
         var _loc3_:MovieClip = null;
         if(this.sLocationMarkerType != param2 || this.bLoadLocation)
         {
            this.ClearLocation();
            this.sLocationMarkerType = param2;
            _loc3_ = param1.LoadIcon(this.sLocationMarkerType);
            if(_loc3_ != null)
            {
               this.LocationClipChild = _loc3_;
               this.MarkerContainer_mc.addChild(_loc3_);
               this.bLoadLocation = false;
            }
            else
            {
               this.bLoadLocation = true;
            }
         }
      }
      
      public function SetDiscovered(param1:Boolean) : *
      {
         if(this.LocationClipChild != null)
         {
            this.LocationClipChild.gotoAndStop(param1 ? "Discovered" : "Undiscovered");
         }
      }
      
      public function ClearLocation() : *
      {
         if(this.LocationClipChild != null)
         {
            this.MarkerContainer_mc.removeChild(this.LocationClipChild);
            this.LocationClipChild = null;
            this.sLocationMarkerType = "";
         }
      }
      
      public function SetTint(param1:uint) : *
      {
         var _loc2_:ColorTransform = null;
         if(this.LastTint != param1 && param1 < TINT_COUNT)
         {
            _loc2_ = new ColorTransform();
            _loc2_.redMultiplier = RedMultipliers[param1];
            _loc2_.greenMultiplier = GreenMultipliers[param1];
            _loc2_.blueMultiplier = BlueMultipliers[param1];
            this.MarkerContainer_mc.transform.colorTransform = _loc2_;
            this.LastTint = param1;
         }
      }
      
      public function SetObjectiveText(param1:String) : *
      {
         var _loc2_:* = param1;
         if(this.IsLargeTextMode() && _loc2_.length > QUEST_TEXT_TRUNCATE_LENGTH_LRG)
         {
            _loc2_ = _loc2_.slice(0,QUEST_TEXT_TRUNCATE_LENGTH_LRG);
            if(_loc2_.charAt(_loc2_.length - 1) == " ")
            {
               _loc2_ = _loc2_.slice(0,-1);
            }
            _loc2_ += "…";
         }
         GlobalFunc.SetTruncatedMultilineText(this.ObjectiveNameplate_mc.text_tf,_loc2_);
         if(this.ObjectiveNameplate_mc.text_tf.numLines > 1)
         {
            this.ObjectiveNameplate_mc.y = this.ObjectiveNameplateInitialY - (this.ObjectiveNameplate_mc.text_tf.height - this.ObjectiveNameplate_mc.text_tf.textHeight) - this.VERTICAL_TEXT_PADDING;
         }
         else
         {
            this.ObjectiveNameplate_mc.y = this.ObjectiveNameplateInitialY;
         }
      }
      
      public function OnMissionIconRollover() : *
      {
         this.bMissionIconHovered = true;
         this.onMissionIconHoverChangeCallback(this.MarkerIndex);
      }
      
      public function OnMissionIconRollout() : *
      {
         this.bMissionIconHovered = false;
         if(!this.IsHighlighted() && this.LastTint == HIGHLIGHT_TINT)
         {
            this.SetTint(BASE_TINT);
            this.SetDiscovered(this.bIsDiscovered);
            this.BGHover_mc.visible = false;
         }
         this.onMissionIconHoverChangeCallback(this.MarkerIndex);
      }
   }
}
