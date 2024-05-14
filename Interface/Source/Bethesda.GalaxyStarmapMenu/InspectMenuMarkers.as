package
{
   import Components.Icons.BodyViewMarker;
   import Components.Icons.BodyViewPointer;
   import Components.Icons.MapIconsLibrary;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class InspectMenuMarkers extends BSDisplayObject
   {
      
      private static const MARKER_GROUP_ROLLOUT_BUFFER:Number = 2;
      
      private static const INVALID_GROUP_MARKER_ID:* = -1;
      
      private static const INVALID_GROUP_INDEX:uint = uint.MAX_VALUE;
      
      private static const MARKER_HIDING_POS:* = -50;
      
      private static const POINTER_PADDING:Number = 20;
      
      private static const POINTER_ICON_PADDING:Number = 60;
      
      private static const POINTER_OFFSET:Number = 0;
       
      
      public var MarkerGroupContainer_mc:MarkerGroupContainer;
      
      private var hasValidLandingLocation:Boolean = false;
      
      private var MarkerDataListA:Array;
      
      private var MarkerDataGroupListA:Array;
      
      private var MarkerClipsA:Array;
      
      private var PointerClipsA:Array;
      
      private var landingLoc:Object;
      
      private var MapIconsLoader:MapIconsLibrary;
      
      private var HighlightedGroupMarkerID:int = -1;
      
      private var rolloutBufferFrameCheck:Number = 0;
      
      public function InspectMenuMarkers()
      {
         this.MarkerClipsA = new Array();
         this.PointerClipsA = new Array();
         this.landingLoc = {
            "latitude":null,
            "longitude":null
         };
         super();
         this.MapIconsLoader = new MapIconsLibrary();
         this.MapIconsLoader.addEventListener(MapIconsLibrary.LIBRARY_LOADED,this.OnMapIconLibraryLoaded);
      }
      
      public function get HasValidLandingLocation() : Boolean
      {
         return this.hasValidLandingLocation;
      }
      
      private function IsLargeTextMode() : Boolean
      {
         return false;
      }
      
      private function CreateMarker() : BodyViewMarker
      {
         var _loc1_:BodyViewMarker = new BodyViewMarker();
         this.MarkerClipsA.push(_loc1_);
         addChild(_loc1_);
         _loc1_.onMissionIconHoverChangeCallback = this.UpdateVisibleMissionText;
         _loc1_.visible = false;
         var _loc2_:BodyViewPointer = new BodyViewPointer();
         this.PointerClipsA.push(_loc2_);
         addChild(_loc2_);
         _loc2_.visible = false;
         return _loc1_;
      }
      
      override public function onAddedToStage() : void
      {
         this.MarkerGroupContainer_mc.addEventListener(MouseEvent.ROLL_OUT,this.OnMarkerGroupContainerMouseRollOut);
         BSUIDataManager.Subscribe("StarMapMenuBodyPOIDefs",function(param1:FromClientDataEvent):*
         {
            SetMarkerList(param1.data.markersA);
            var _loc2_:UIDataFromClient = BSUIDataManager.GetDataFromClient("StarMapMenuBodyPOIPositions",false);
            ProcessMarkerPositionData(_loc2_.data.markersA);
         });
         BSUIDataManager.Subscribe("StarMapMenuBodyPOIPositions",function(param1:FromClientDataEvent):*
         {
            if(MarkerDataListA.length == param1.data.markersA.length)
            {
               ProcessMarkerPositionData(param1.data.markersA);
            }
         });
         BSUIDataManager.Subscribe("StarMapMenuBodyPOIGroups",function(param1:FromClientDataEvent):*
         {
            SetMarkerGroupList(param1.data.markerGroupsA);
         });
      }
      
      public function OnMarkerGroupContainerMouseRollOut(param1:Event) : *
      {
         this.MarkerGroupContainer_mc.visible = false;
         this.HighlightedGroupMarkerID = INVALID_GROUP_MARKER_ID;
         this.SetMarkerList(this.MarkerDataListA,false);
      }
      
      public function OnMapIconLibraryLoaded(param1:Event) : *
      {
         var _loc3_:BodyViewMarker = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.MarkerDataListA.length && _loc2_ < this.MarkerClipsA.length)
         {
            _loc3_ = this.MarkerClipsA[_loc2_] as BodyViewMarker;
            if(_loc3_.needsLocationLoaded())
            {
               _loc3_.SetLocation(this.MapIconsLoader,_loc3_.locationType());
            }
            _loc2_++;
         }
         this.MarkerGroupContainer_mc.LoadEntryIcons(this.MapIconsLoader);
      }
      
      public function SetMarkerList(param1:Array, param2:Boolean = true) : *
      {
         var _loc3_:Object = null;
         var _loc7_:* = undefined;
         var _loc8_:BodyViewMarker = null;
         var _loc9_:MovieClip = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         this.MarkerDataListA = param1;
         var _loc4_:String = "";
         var _loc5_:*;
         if((_loc5_ = this.MarkerDataListA[0]) != null && _loc5_.type == MapMarkerUtils.INSPECT_MARKER_TYPE_LANDING)
         {
            _loc3_ = _loc5_;
         }
         var _loc6_:uint = 0;
         _loc6_ = 0;
         while(_loc6_ < this.MarkerDataListA.length)
         {
            _loc7_ = this.MarkerDataListA[_loc6_];
            if((_loc8_ = this.MarkerClipsA[_loc6_] as BodyViewMarker) == null)
            {
               _loc8_ = this.CreateMarker();
            }
            _loc8_.MarkerIndex = _loc6_;
            _loc9_ = this.PointerClipsA[_loc6_] as MovieClip;
            _loc8_.name = "Marker: " + _loc7_.nameText;
            _loc9_.name = "Pointer: " + _loc7_.nameText;
            _loc8_.SetIsHighlighted(_loc7_.showHighlight);
            _loc8_.IsDiscovered = _loc7_.discovered;
            if(!_loc7_.isVisible || this.MarkerGroupContainer_mc.visible && this.HighlightedGroupMarkerID != _loc7_.markerHandleBits)
            {
               _loc8_.visible = false;
               _loc9_.visible = false;
            }
            else
            {
               _loc11_ = (_loc10_ = this.GetMarkerGroupIndex(_loc7_.markerHandleBits)) != INVALID_GROUP_INDEX;
               _loc12_ = this.MarkerGroupContainer_mc.visible && this.HighlightedGroupMarkerID == _loc7_.markerHandleBits || _loc11_ && _loc8_.IsHighlighted() && param2;
               _loc8_.ClearLocation();
               _loc8_.MarkerContainer_mc.gotoAndStop(BodyViewMarker.GetMarkerLabel(_loc7_.type));
               if(_loc7_.type == MapMarkerUtils.INSPECT_MARKER_TYPE_LOCATION)
               {
                  _loc8_.SetLocation(this.MapIconsLoader,MapMarkerUtils.GetSymbolOrGenericName(_loc7_.uLocationType,_loc7_.genericType,_loc7_.discovered));
               }
               _loc8_.SetTint(BodyViewMarker.BASE_TINT);
               _loc8_.LandingMarker_mc.visible = false;
               _loc8_.ObjectiveAtPOI_mc.visible = false;
               _loc8_.ObjectiveAtPOIInactive_mc.visible = false;
               _loc8_.BGHover_mc.visible = false;
               _loc8_.BGGroupFrame_mc.visible = false;
               _loc8_.BodyViewShipIndicator_mc.visible = false;
               _loc8_.IndicatorMarker_mc.visible = false;
               _loc8_.visible = true;
               _loc8_.SetObjectiveText("");
               if(_loc7_.type == MapMarkerUtils.INSPECT_MARKER_TYPE_SHIP)
               {
                  GlobalFunc.SetText(_loc8_.Nameplate_mc.text_tf,"$PLAYER SHIP");
               }
               else
               {
                  GlobalFunc.SetText(_loc8_.Nameplate_mc.text_tf,_loc7_.nameText + _loc7_.extraText);
               }
               if(this.IsLargeTextMode())
               {
                  GlobalFunc.TruncateSingleLineText(_loc8_.Nameplate_mc.text_tf);
               }
               _loc8_.PlayerMarker_mc.visible = _loc7_.hasPlayerMarker;
               if(Boolean(_loc7_.hasQuestTarget) || _loc11_ && this.IsMarkerGroupPropertySet(_loc10_,"hasQuestTarget"))
               {
                  _loc8_.IndicatorMarker_mc.visible = false;
                  if(Boolean(_loc7_.questActive) || _loc11_ && this.IsMarkerGroupPropertySet(_loc10_,"questActive"))
                  {
                     _loc8_.ObjectiveAtPOI_mc.visible = true;
                     _loc8_.ObjectiveAtPOIInactive_mc.visible = false;
                  }
                  else
                  {
                     _loc8_.ObjectiveAtPOI_mc.visible = false;
                     _loc8_.ObjectiveAtPOIInactive_mc.visible = true;
                  }
                  if(_loc8_.IsHighlighted())
                  {
                     _loc8_.SetObjectiveText(_loc7_.sQuestTargetText);
                  }
               }
               _loc8_.MarkerContainer_mc.visible = _loc7_.shouldShowIcon;
               if(_loc7_.type == MapMarkerUtils.INSPECT_MARKER_TYPE_LANDING)
               {
                  _loc8_.LandingMarker_mc.visible = !_loc7_.shouldShowIcon;
                  this.landingLoc.latitude = _loc7_.latitude;
                  this.landingLoc.longitude = _loc7_.longitude;
                  this.hasValidLandingLocation = _loc7_.isLandable;
               }
               if(_loc11_)
               {
                  _loc8_.LandingMarker_mc.visible = this.IsMarkerGroupPropertySet(_loc10_,"showHighlight");
                  _loc8_.BodyViewShipIndicator_mc.visible = this.GetMarkerGroupHasShip(_loc10_);
                  _loc8_.BGHover_mc.visible = false;
                  _loc8_.BGGroupFrame_mc.visible = !this.IsSinglePOIWithShipMarker(_loc10_);
                  _loc8_.BGGroupFrame_mc.gotoAndStop("Diamond");
               }
               if(_loc12_)
               {
                  _loc8_.visible = false;
                  this.HighlightedGroupMarkerID = _loc7_.markerHandleBits;
                  if(this.MarkerGroupContainer_mc.visible)
                  {
                     this.UpdateMarkerGroupContainerPosition(_loc8_.x,_loc8_.y);
                  }
                  else
                  {
                     this.ShowMarkerGroupContainer(_loc10_,_loc8_.x,_loc8_.y);
                     _loc13_ = 0;
                     while(_loc13_ < _loc6_)
                     {
                        (this.MarkerClipsA[_loc13_] as BodyViewMarker).visible = false;
                        (this.PointerClipsA[_loc13_] as MovieClip).visible = false;
                        _loc13_++;
                     }
                  }
               }
               else if(Boolean(_loc7_.isLandable) && _loc8_.IsHighlighted())
               {
                  _loc8_.SetTint(BodyViewMarker.HIGHLIGHT_TINT);
                  if(_loc11_)
                  {
                     _loc8_.BGHover_mc.visible = false;
                     _loc8_.BGGroupFrame_mc.visible = !this.IsSinglePOIWithShipMarker(_loc10_);
                  }
                  else
                  {
                     _loc8_.BGHover_mc.visible = true;
                     _loc8_.BGHover_mc.HighlightPulse.gotoAndStop(BodyViewMarker.GetHighlightHoverFrame(_loc7_.type));
                     _loc8_.BGGroupFrame_mc.visible = false;
                  }
                  _loc4_ = String(_loc7_.nameText);
               }
               else
               {
                  _loc14_ = false;
                  switch(_loc7_.type)
                  {
                     case MapMarkerUtils.INSPECT_MARKER_TYPE_LANDING:
                     case MapMarkerUtils.INSPECT_MARKER_TYPE_QUEST:
                     case MapMarkerUtils.INSPECT_MARKER_TYPE_OUTPOST:
                     case MapMarkerUtils.INSPECT_MARKER_TYPE_LOCATION:
                     case MapMarkerUtils.INSPECT_MARKER_TYPE_UNKNOWN:
                        _loc14_ = true;
                  }
                  _loc15_ = Boolean(_loc7_.isLandable) || !_loc14_;
                  if(Boolean(_loc7_.discovered) && _loc15_)
                  {
                     _loc8_.SetDiscovered(true);
                     _loc8_.SetTint(BodyViewMarker.BASE_TINT);
                  }
                  else if(!_loc7_.discovered && _loc15_)
                  {
                     _loc8_.SetDiscovered(false);
                  }
                  else
                  {
                     _loc8_.SetTint(BodyViewMarker.DISABLED_TINT);
                  }
                  if(_loc11_)
                  {
                     _loc8_.BGHover_mc.visible = false;
                     _loc8_.BGGroupFrame_mc.visible = !this.IsSinglePOIWithShipMarker(_loc10_);
                  }
                  else
                  {
                     _loc8_.BGGroupFrame_mc.visible = false;
                  }
               }
            }
            _loc6_++;
         }
         if(!this.MarkerGroupContainer_mc.visible)
         {
            this.SetLandingText(_loc4_);
         }
         while(_loc6_ < this.MarkerClipsA.length)
         {
            (_loc8_ = this.MarkerClipsA[_loc6_] as BodyViewMarker).visible = false;
            _loc8_.x = MARKER_HIDING_POS;
            _loc8_.y = MARKER_HIDING_POS;
            _loc8_.ClearLocation();
            _loc8_.name = "Unused Marker " + _loc6_;
            (_loc9_ = this.PointerClipsA[_loc6_] as MovieClip).visible = false;
            _loc9_.x = MARKER_HIDING_POS;
            _loc9_.y = MARKER_HIDING_POS;
            _loc9_.name = "Unused Pointer " + _loc6_;
            _loc6_++;
         }
      }
      
      public function ProcessMarkerPositionData(param1:Array) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:MovieClip = null;
         var _loc6_:BodyViewMarker = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(param1.length != this.MarkerDataListA.length)
         {
            GlobalFunc.TraceWarning("Marker Position data does not match Marker list length.");
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length && _loc2_ < this.MarkerDataListA.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = this.MarkerDataListA[_loc2_];
            _loc5_ = this.PointerClipsA[_loc2_] as MovieClip;
            if((_loc6_ = this.MarkerClipsA[_loc2_] as BodyViewMarker) == null)
            {
               break;
            }
            if(_loc3_.facingCamera)
            {
               _loc6_.gotoAndStop(BodyViewMarker.FACING_FRAME);
               _loc5_.visible = false;
               _loc6_.Nameplate_mc.visible = true;
               _loc6_.x = _loc3_.xPos;
               _loc6_.y = _loc3_.yPos;
               _loc6_.alpha = 1;
               _loc6_.scaleY = 1;
               _loc6_.scaleX = 1;
            }
            else
            {
               _loc7_ = Math.cos(_loc3_.edgeAngle) as Number;
               _loc8_ = Math.sin(_loc3_.edgeAngle) as Number;
               _loc6_.gotoAndStop(BodyViewMarker.NOT_FACING_FRAME);
               _loc5_.visible = _loc6_.visible;
               _loc6_.Nameplate_mc.visible = false;
               _loc6_.x = _loc3_.xEdgePos;
               _loc6_.y = _loc3_.yEdgePos;
               _loc6_.x += _loc7_ * POINTER_ICON_PADDING;
               _loc6_.y += _loc8_ * POINTER_ICON_PADDING;
               _loc5_.x = _loc3_.xEdgePos;
               _loc5_.y = _loc3_.yEdgePos;
               _loc5_.x += _loc7_ * POINTER_PADDING;
               _loc5_.y += _loc8_ * POINTER_PADDING;
               _loc5_.rotation = _loc3_.edgeAngle * (180 / Math.PI);
               _loc6_.alpha = 0.75;
               _loc6_.scaleY = 0.5;
               _loc6_.scaleX = 0.5;
            }
            if(this.MarkerGroupContainer_mc.visible && this.HighlightedGroupMarkerID == _loc4_.markerHandleBits)
            {
               this.UpdateMarkerGroupContainerPosition(_loc3_.xPos,_loc3_.yPos);
            }
            _loc2_++;
         }
      }
      
      public function SetMarkerGroupList(param1:Array) : *
      {
         var _loc2_:* = undefined;
         this.MarkerDataGroupListA = param1;
         if(this.HighlightedGroupMarkerID != INVALID_GROUP_MARKER_ID)
         {
            _loc2_ = this.GetMarkerGroupIndex(this.HighlightedGroupMarkerID);
            this.UpdateMarkerGroupContainer(_loc2_);
         }
      }
      
      public function UpdateMarkerGroupContainer(param1:uint) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:DisplayObject = null;
         var _loc6_:* = undefined;
         if(param1 != INVALID_GROUP_INDEX)
         {
            _loc2_ = new Array();
            _loc3_ = this.MarkerDataGroupListA[param1].markersA;
            for each(_loc4_ in _loc3_)
            {
               (_loc6_ = new MarkerGroupEntry(_loc4_)).LoadLocationIcon(this.MapIconsLoader);
               _loc6_.UpdateColor();
               _loc2_.push(_loc6_);
            }
            _loc5_ = parent.parent.getChildByName("ButtonHintBar_mc");
            this.MarkerGroupContainer_mc.Populate(_loc2_,_loc5_);
         }
      }
      
      public function ShowMarkerGroupContainer(param1:uint, param2:int, param3:int) : *
      {
         if(this.MarkerGroupContainer_mc.visible)
         {
            return;
         }
         this.UpdateMarkerGroupContainerPosition(param2,param3);
         this.UpdateMarkerGroupContainer(param1);
         this.MarkerGroupContainer_mc.visible = true;
         this.rolloutBufferFrameCheck = 0;
         stage.addEventListener(Event.ENTER_FRAME,this.CheckMouseOutsideGroupContainer);
      }
      
      public function UpdateMarkerGroupContainerPosition(param1:int, param2:int) : *
      {
         this.MarkerGroupContainer_mc.x = param1;
         this.MarkerGroupContainer_mc.y = param2;
      }
      
      private function UpdateVisibleMissionText(param1:int) : *
      {
         var _loc2_:BodyViewMarker = this.MarkerClipsA[param1];
         var _loc3_:* = this.MarkerDataListA[param1];
         if(_loc2_ != null && _loc3_ != null)
         {
            if(_loc2_.IsHighlighted())
            {
               _loc2_.SetObjectiveText(_loc3_.sQuestTargetText);
            }
            else
            {
               _loc2_.SetObjectiveText("");
            }
         }
      }
      
      private function CheckMouseOutsideGroupContainer(param1:Event) : *
      {
         if(!this.MarkerGroupContainer_mc.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            stage.removeEventListener(Event.ENTER_FRAME,this.CheckMouseOutsideGroupContainer);
            this.OnMarkerGroupContainerMouseRollOut(param1);
         }
         else if(this.rolloutBufferFrameCheck >= MARKER_GROUP_ROLLOUT_BUFFER)
         {
            stage.removeEventListener(Event.ENTER_FRAME,this.CheckMouseOutsideGroupContainer);
         }
         else
         {
            ++this.rolloutBufferFrameCheck;
         }
      }
      
      public function GetMarkerGroupIndex(param1:uint) : uint
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc2_:uint = uint.MAX_VALUE;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         while(_loc4_ < this.MarkerDataGroupListA.length && !_loc3_)
         {
            _loc5_ = this.MarkerDataGroupListA[_loc4_].markersA;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length && !_loc3_)
            {
               if((_loc7_ = _loc5_[_loc6_]).markerHandleBits == param1)
               {
                  _loc3_ = true;
                  _loc2_ = _loc4_;
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function IsMarkerGroupPropertySet(param1:uint, param2:String) : Boolean
      {
         var _loc5_:Object = null;
         var _loc3_:* = false;
         var _loc4_:Array = this.MarkerDataGroupListA[param1].markersA;
         for each(_loc5_ in _loc4_)
         {
            if(Boolean(_loc5_.hasOwnProperty(param2)) && _loc5_[param2] == true)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function GetMarkerGroupHasShip(param1:uint) : Boolean
      {
         var _loc4_:Object = null;
         var _loc2_:* = false;
         var _loc3_:Array = this.MarkerDataGroupListA[param1].markersA;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.type == MapMarkerUtils.INSPECT_MARKER_TYPE_SHIP)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public function Reset() : *
      {
         this.hasValidLandingLocation = false;
         this.MarkerGroupContainer_mc.visible = false;
      }
      
      public function SetLandingText(param1:String) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(MarkerGroupEntry.StarMapMenu_MarkerGroupEntryHoverChanged,{"markerText":param1}));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MarkerGroupContainer_mc.ProcessUserEvent(param1,param2);
      }
      
      private function IsSinglePOIWithShipMarker(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = this.MarkerDataGroupListA[param1].markersA;
         if(_loc3_.length == 2)
         {
            _loc2_ = this.GetMarkerGroupHasShip(param1);
         }
         return _loc2_;
      }
   }
}
