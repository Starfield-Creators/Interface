package
{
   import Components.Icons.MapIconsLibrary;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   
   public class MarkerGroupEntry extends BSDisplayObject
   {
      
      public static const StarMapMenu_MarkerGroupEntryClicked:String = "StarMapMenu_MarkerGroupEntryClicked";
      
      public static const StarMapMenu_MarkerGroupEntryHoverChanged:String = "StarMapMenu_MarkerGroupEntryHoverChanged";
      
      public static const StarMapMenu_MarkerGroupEntryHighlighted:String = "StarMapMenu_MarkerGroupEntryHighlighted";
      
      public static const StarMapMenu_MarkerGroupEntryUnhighlighted:String = "StarMapMenu_MarkerGroupEntryUnhighlighted";
      
      private static const QUEST_TEXT_TRUNCATE_LENGTH_LRG:int = 36;
      
      public static const BASE_TINT:uint = EnumHelper.GetEnum(0);
      
      public static const DISABLED_TINT:uint = EnumHelper.GetEnum();
      
      public static const HIGHLIGHT_TINT:uint = EnumHelper.GetEnum();
      
      public static const TINT_COUNT:uint = EnumHelper.GetEnum();
      
      private static const END_POI_PADDING:Number = 10;
      
      public static const MARKER_TYPE_INVALID:uint = EnumHelper.GetEnum(0);
      
      public static const MARKER_TYPE_LANDING:uint = EnumHelper.GetEnum();
      
      public static const MARKER_TYPE_QUEST:uint = EnumHelper.GetEnum();
      
      public static const MARKER_TYPE_OUTPOST:uint = EnumHelper.GetEnum();
      
      public static const MARKER_TYPE_SHIP:uint = EnumHelper.GetEnum();
      
      public static const MARKER_TYPE_LOCATION:uint = EnumHelper.GetEnum();
      
      public static const MARKER_TYPE_PLAYER:uint = EnumHelper.GetEnum();
      
      public static const MARKER_TYPE_UNKNOWN:uint = EnumHelper.GetEnum();
       
      
      public var MarkerText_mc:MovieClip;
      
      public var ObjectiveText_mc:MovieClip;
      
      public var MarkerPOI_mc:MovieClip;
      
      public var MarkerPOIEnd_mc:MovieClip;
      
      public var MarkerHitBox_mc:MovieClip;
      
      public var LandingMarker_mc:MovieClip;
      
      public var MarkerData:Object;
      
      private var LocationClipChild:MovieClip = null;
      
      private var bLoadLocation:Boolean = false;
      
      private var ObjectiveTextInitialY:int;
      
      private const HIGHLIGHTED:String = "highlighted";
      
      private const OVER_TO_IDLE:String = "over_to_idle";
      
      private const IDLE_TO_OVER:String = "idle_to_over";
      
      private const DISABLED:String = "disabled";
      
      private var LastTint:uint;
      
      private var BaseColor:ColorMultiplier;
      
      private var DisabledColor:ColorMultiplier;
      
      private var HighlightColor:ColorMultiplier;
      
      private var ColorA:Array;
      
      private const VERTICAL_TEXT_PADDING:int = 10;
      
      public function MarkerGroupEntry(param1:Object)
      {
         var _loc2_:* = null;
         this.LastTint = BASE_TINT;
         this.BaseColor = new ColorMultiplier();
         this.DisabledColor = new ColorMultiplier();
         this.HighlightColor = new ColorMultiplier();
         super();
         this.DisabledColor.Red = 0.439;
         this.DisabledColor.Green = 0.439;
         this.DisabledColor.Blue = 0.439;
         this.HighlightColor.Red = 1.234;
         this.HighlightColor.Green = 0.82;
         this.HighlightColor.Blue = 0.175;
         this.ColorA = new Array(this.BaseColor,this.DisabledColor,this.HighlightColor);
         this.MarkerData = param1;
         this.ObjectiveTextInitialY = this.ObjectiveText_mc.y;
         GlobalFunc.SetText(this.MarkerText_mc.text_tf,this.MarkerData.nameText + this.MarkerData.extraText);
         GlobalFunc.SetText(this.ObjectiveText_mc.text_tf,"");
         this.MarkerText_mc.text_tf.autoSize = TextFieldAutoSize.LEFT;
         this.ObjectiveText_mc.text_tf.autoSize = TextFieldAutoSize.LEFT;
         if(this.MarkerData.hasQuestTarget)
         {
            this.MarkerPOIEnd_mc.MissionMarker_mc.visible = this.MarkerData.questActive;
            this.MarkerPOIEnd_mc.MissionMarkerInactive_mc.visible = !this.MarkerData.questActive;
            _loc2_ = String(this.MarkerData.sQuestTargetText);
            if(this.IsLargeTextMode() && _loc2_.length > QUEST_TEXT_TRUNCATE_LENGTH_LRG)
            {
               _loc2_ = _loc2_.slice(0,QUEST_TEXT_TRUNCATE_LENGTH_LRG);
               if(_loc2_.charAt(_loc2_.length - 1) == " ")
               {
                  _loc2_ = _loc2_.slice(0,-1);
               }
               _loc2_ += "…";
            }
            GlobalFunc.SetText(this.ObjectiveText_mc.text_tf,_loc2_);
            if(this.ObjectiveText_mc.text_tf.numLines > 1)
            {
               this.ObjectiveText_mc.y = this.ObjectiveTextInitialY - (this.ObjectiveText_mc.text_tf.height - this.ObjectiveText_mc.text_tf.textHeight) - this.VERTICAL_TEXT_PADDING;
            }
            else
            {
               this.ObjectiveText_mc.y = this.ObjectiveTextInitialY;
            }
         }
         else
         {
            this.MarkerPOIEnd_mc.MissionMarker_mc.visible = false;
            this.MarkerPOIEnd_mc.MissionMarkerInactive_mc.visible = false;
         }
         this.MarkerHitBox_mc.width = this.MarkerText_mc.x - this.MarkerHitBox_mc.x + this.MarkerText_mc.text_tf.textWidth;
         this.LandingMarker_mc.visible = this.MarkerData.hasGroupLandingMarker;
      }
      
      public function get markerType() : int
      {
         return this.MarkerData.type;
      }
      
      public function get locationType() : int
      {
         return this.MarkerData.uLocationType;
      }
      
      private function IsLargeTextMode() : Boolean
      {
         return false;
      }
      
      public function get needsLocationLoaded() : Boolean
      {
         return this.bLoadLocation && this.markerType == MARKER_TYPE_LOCATION;
      }
      
      public function get hitboxWidth() : int
      {
         return this.MarkerHitBox_mc.width;
      }
      
      public function get HasLandingMarker() : *
      {
         return this.MarkerData.hasGroupLandingMarker;
      }
      
      public function get HasPlayerMarker() : Boolean
      {
         return this.MarkerData.hasPlayerMarker;
      }
      
      private function get markerDisabled() : Boolean
      {
         var _loc1_:Boolean = false;
         switch(this.MarkerData.type)
         {
            case MARKER_TYPE_LANDING:
            case MARKER_TYPE_QUEST:
            case MARKER_TYPE_OUTPOST:
            case MARKER_TYPE_LOCATION:
            case MARKER_TYPE_UNKNOWN:
               _loc1_ = true;
         }
         return _loc1_ && !this.MarkerData.isLandable;
      }
      
      override public function onAddedToStage() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.OnMarkerGroupEntryClicked);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onRollover);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollout);
      }
      
      public function onRollover(param1:MouseEvent) : *
      {
         if(!this.markerDisabled)
         {
            this.SetTint(HIGHLIGHT_TINT);
            this.SetLandingText(this.MarkerData.nameText);
            GlobalFunc.PlayMenuSound("UIMenuSurfaceMapRollover");
            dispatchEvent(new CustomEvent(StarMapMenu_MarkerGroupEntryHighlighted,{"aEntry":this}));
         }
      }
      
      public function onRollout() : *
      {
         if(!this.markerDisabled)
         {
            this.SetTint(BASE_TINT);
            this.SetLandingText("");
            dispatchEvent(new CustomEvent(StarMapMenu_MarkerGroupEntryUnhighlighted,{"aEntry":this}));
         }
      }
      
      public function ClearLocation() : *
      {
         if(this.LocationClipChild != null)
         {
            this.MarkerPOI_mc.removeChild(this.LocationClipChild);
            this.LocationClipChild = null;
         }
      }
      
      public function LoadLocationIcon(param1:MapIconsLibrary) : *
      {
         if(this.markerType == MARKER_TYPE_LOCATION)
         {
            this.SetLocation(param1,MapMarkerUtils.GetSymbolOrGenericName(this.MarkerData.uLocationType,this.MarkerData.genericType,this.MarkerData.discovered),this.MarkerData.discovered);
         }
      }
      
      public function SetLocation(param1:MapIconsLibrary, param2:String, param3:Boolean) : *
      {
         this.ClearLocation();
         var _loc4_:MovieClip;
         if((_loc4_ = param1.LoadIcon(param2)) != null)
         {
            this.LocationClipChild = _loc4_;
            this.MarkerPOI_mc.addChild(this.LocationClipChild);
            this.LocationClipChild.gotoAndStop(param3 ? "Discovered" : "Undiscovered");
            this.bLoadLocation = false;
         }
         else
         {
            this.bLoadLocation = true;
         }
         if(!this.MarkerData.isLandable)
         {
            this.SetTint(DISABLED_TINT);
         }
      }
      
      public function UpdateColor() : *
      {
         if(!this.markerDisabled && Boolean(this.MarkerData.showHighlight))
         {
            this.SetTint(HIGHLIGHT_TINT);
         }
         else if(this.markerDisabled)
         {
            this.SetTint(DISABLED_TINT);
         }
         else
         {
            this.SetTint(BASE_TINT);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 == "Select")
         {
            this.OnMarkerGroupEntryClicked();
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function OnMarkerGroupEntryClicked() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_MarkerGroupEntryClicked,{"markerHandleBits":this.MarkerData.markerHandleBits}));
      }
      
      public function SetLandingText(param1:String) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_MarkerGroupEntryHoverChanged,{"markerText":param1}));
      }
      
      public function SetTint(param1:uint) : *
      {
         var _loc2_:ColorTransform = null;
         if(this.LastTint != param1)
         {
            _loc2_ = new ColorTransform();
            _loc2_.redMultiplier = this.ColorA[param1].Red;
            _loc2_.greenMultiplier = this.ColorA[param1].Green;
            _loc2_.blueMultiplier = this.ColorA[param1].Blue;
            this.MarkerPOI_mc.transform.colorTransform = _loc2_;
            this.LastTint = param1;
         }
      }
   }
}

class ColorMultiplier
{
    
   
   public var Red:Number = 1;
   
   public var Green:Number = 1;
   
   public var Blue:Number = 1;
   
   public function ColorMultiplier()
   {
      super();
   }
}
