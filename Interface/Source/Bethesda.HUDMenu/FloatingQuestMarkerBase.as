package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import Shared.MapMarkerUtils;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class FloatingQuestMarkerBase extends BSDisplayObject
   {
      
      public static const MIN_TEXT_DISTANCE:Number = 10;
      
      public static const MAX_TEXT_DISTANCE:Number = 99;
      
      private static const X_OFFSET:Number = 0;
      
      private static const Y_OFFSET:Number = 15;
      
      private static const SPRITE_BOUND:Number = 60;
      
      private static const STARTING_TEXT_Y:Number = -65;
      
      private static const QUEST_TARGET_DISTANCE_TO_BE_CONSIDERED_CLOSE:Number = 20;
      
      private static const TEXT_HEIGHT_INCREASE:Number = -20;
      
      private static const TEXT_HEIGHT_INCREASE_FOR_CLOSE_MARKERS:Number = -45;
      
      private static const MAX_TEXT_LENGTH:int = 84;
      
      private static const MAX_TEXT_LENGTH_LARGE:int = 43;
       
      
      private var MarkerClips:Array;
      
      private var MaxTextLength:int = 84;
      
      public function FloatingQuestMarkerBase()
      {
         this.MarkerClips = new Array();
         super();
         Extensions.enabled = true;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("HudCompassData",this.OnQuestMarkersUpdated);
      }
      
      private function OnQuestMarkersUpdated(param1:FromClientDataEvent) : *
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:FloatingTarget = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Point = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Point = null;
         var _loc15_:Number = NaN;
         var _loc2_:Array = param1.data.aMissionMarkers;
         var _loc3_:int = 0;
         if(_loc2_ != null && _loc2_.length > 0)
         {
            _loc4_ = new Rectangle(Extensions.visibleRect.left + SPRITE_BOUND + X_OFFSET,Extensions.visibleRect.top + SPRITE_BOUND + Y_OFFSET,Extensions.visibleRect.width - SPRITE_BOUND * 2,Extensions.visibleRect.height - SPRITE_BOUND * 2);
            _loc5_ = new Point(_loc4_.left + _loc4_.width / 2,_loc4_.top + _loc4_.height / 2);
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               if((_loc7_ = this.GetClip(_loc3_)) != null && Boolean(_loc2_[_loc6_].bFloatingMarkerVisible))
               {
                  if(MapMarkerUtils.GetMajorFrameFromMitMarkerType(_loc2_[_loc6_].uiMarkerIconType) != _loc7_.currentFrameLabel)
                  {
                     _loc7_.gotoAndStop(MapMarkerUtils.GetMajorFrameFromMitMarkerType(_loc2_[_loc6_].uiMarkerIconType));
                  }
                  _loc8_ = 1;
                  if(_loc2_[_loc6_].uiMarkerIconType == MapMarkerUtils.MIT_MARKER_QUEST || _loc2_[_loc6_].uiMarkerIconType == MapMarkerUtils.MIT_MARKER_QUEST_DOOR || _loc2_[_loc6_].uiMarkerIconType == MapMarkerUtils.MIT_MARKER_QUEST_OFFPLANET)
                  {
                     if(Boolean(param1.data.bIsHandscannerOpen) || Boolean(param1.data.bIsInSpace))
                     {
                        _loc8_ = 1;
                     }
                     else
                     {
                        _loc8_ = GlobalFunc.MapLinearlyToRange(param1.data.fMinAlpha,1,param1.data.fFloatingMarkerMaxDistance,param1.data.fFloatingMarkerMinDistance,_loc2_[_loc6_].fDistanceToPlayer,true);
                     }
                     _loc7_.alpha = _loc8_;
                     TextFieldEx.setVerticalAlign(_loc7_.Text_mc.Text_tf,TextFieldEx.VALIGN_BOTTOM);
                     if(_loc2_[_loc6_].bShouldShowText === true && _loc2_[_loc6_].strText.length > 0)
                     {
                        GlobalFunc.SetText(_loc7_.Text_mc.Text_tf,_loc2_[_loc6_].strText,false,false,this.MaxTextLength);
                     }
                     else
                     {
                        GlobalFunc.SetText(_loc7_.Text_mc.Text_tf,_loc2_[_loc6_].fDistanceToPlayer >= MIN_TEXT_DISTANCE && _loc2_[_loc6_].fDistanceToPlayer <= MAX_TEXT_DISTANCE ? GlobalFunc.FormatNumberToString(_loc2_[_loc6_].fDistanceToPlayer,0) : "");
                     }
                  }
                  else
                  {
                     GlobalFunc.SetText(_loc7_.Text_mc.Text_tf,"");
                  }
                  _loc9_ = GlobalFunc.Clamp(_loc2_[_loc6_].uScreenX,_loc4_.left,_loc4_.right);
                  _loc10_ = GlobalFunc.Clamp(_loc2_[_loc6_].uScreenY,_loc4_.top,_loc4_.bottom);
                  _loc11_ = new Point(_loc9_,_loc10_);
                  if(_loc2_[_loc6_].bShouldShowText === true)
                  {
                     _loc12_ = 0;
                     _loc13_ = _loc6_ + 1;
                     while(_loc13_ < _loc2_.length)
                     {
                        _loc14_ = new Point(GlobalFunc.Clamp(_loc2_[_loc13_].uScreenX,_loc4_.left,_loc4_.right),GlobalFunc.Clamp(_loc2_[_loc13_].uScreenY,_loc4_.top,_loc4_.bottom));
                        if(Point.distance(_loc11_,_loc14_) <= QUEST_TARGET_DISTANCE_TO_BE_CONSIDERED_CLOSE)
                        {
                           _loc12_++;
                        }
                        _loc13_++;
                     }
                     _loc7_.Text_mc.y = STARTING_TEXT_Y + TEXT_HEIGHT_INCREASE + _loc12_ * TEXT_HEIGHT_INCREASE_FOR_CLOSE_MARKERS;
                  }
                  if(_loc2_[_loc6_].bIsOffscreen)
                  {
                     _loc7_.POIArrows_mc.visible = true;
                     _loc15_ = Math.atan2(_loc10_ - _loc5_.y,_loc9_ - _loc5_.x) * (180 / Math.PI);
                     _loc7_.POIArrows_mc.rotation = _loc15_ + 180;
                  }
                  else
                  {
                     _loc7_.POIArrows_mc.visible = false;
                     _loc7_.Text_mc.visible = true;
                  }
                  _loc7_.x = _loc9_;
                  _loc7_.y = _loc10_;
                  _loc7_.visible = true;
                  _loc3_++;
               }
               _loc6_++;
            }
         }
         while(_loc3_ < this.MarkerClips.length)
         {
            this.MarkerClips[_loc3_].visible = false;
            _loc3_++;
         }
      }
      
      private function GetClip(param1:int) : FloatingTarget
      {
         var _loc2_:FloatingTarget = null;
         if(param1 < this.MarkerClips.length)
         {
            _loc2_ = this.MarkerClips[param1];
         }
         else
         {
            _loc2_ = new FloatingTarget();
            addChild(_loc2_);
            this.MarkerClips.push(_loc2_);
         }
         return _loc2_;
      }
   }
}
