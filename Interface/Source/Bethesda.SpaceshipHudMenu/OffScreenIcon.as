package
{
   import Components.Icons.DynamicPoiIcon;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class OffScreenIcon extends TargetIconFrameContainer
   {
      
      private static const NEUTRAL_FACTION_FRAME_LABEL:String = "Neutral";
      
      private static const ALLY_FACTION_FRAME_LABEL:String = "Ally";
      
      private static const ENEMY_FACTION_FRAME_LABEL:String = "Enemy";
      
      private static const SELECTED_FRAME_LABEL:String = "Selected";
      
      private static const UNSELECTED_FRAME_LABEL:String = "Unselected";
       
      
      public var FactionWrapper_mc:MovieClip;
      
      public var QuestMarker_mc:MovieClip;
      
      public var PoiIcon_mc:DynamicPoiIcon;
      
      public var PlanetIcon_mc:MovieClip;
      
      private var SelectedState_mc:MovieClip;
      
      private var LastInfoTarget:Boolean = false;
      
      private var LastMonocleMode:Boolean = false;
      
      private var LastFactionFrame:String = "";
      
      private var LastTargetType:uint;
      
      private var HitAnimEnding:Boolean = false;
      
      private var ReverseAnim:Boolean = false;
      
      public function OffScreenIcon()
      {
         this.LastTargetType = TargetIconFrameContainer.TT_COUNT;
         super();
         this.SelectedState_mc = this.FactionWrapper_mc.SelectedState_mc;
      }
      
      override public function SetCombatValues(param1:Object) : *
      {
         super.SetCombatValues(param1);
         var _loc2_:MovieClip = this.SelectedState_mc.HitAnim_mc;
         if(param1.damagingPlayer)
         {
            if(_loc2_.currentFrameLabel == "Off")
            {
               _loc2_.gotoAndPlay("Anim");
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.HitAnimEnding = false;
            }
            else if(this.HitAnimEnding)
            {
               this.ReverseAnim = true;
               this.HitAnimEnding = false;
               stop();
            }
         }
      }
      
      override public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         var _loc4_:String = null;
         super.SetTargetLowInfo(param1,param2,param3);
         if(this.LastTargetType != param1.uTargetType)
         {
            gotoAndStop(param1.uTargetType + 1);
            this.LastTargetType = param1.uTargetType;
         }
         if(param1.hostile)
         {
            this.GoToFactionFrame(ENEMY_FACTION_FRAME_LABEL);
         }
         else if(param1.bAlly)
         {
            this.GoToFactionFrame(ALLY_FACTION_FRAME_LABEL);
         }
         else
         {
            this.GoToFactionFrame(NEUTRAL_FACTION_FRAME_LABEL);
         }
         if(this.LastInfoTarget != param1.isInfoTarget)
         {
            _loc4_ = !!param1.isInfoTarget ? SELECTED_FRAME_LABEL : UNSELECTED_FRAME_LABEL;
            this.SelectedState_mc.gotoAndStop(_loc4_);
            this.LastInfoTarget = param1.isInfoTarget;
         }
         this.SelectedState_mc.ReticleShipHailIcon_mc.visible = param1.uTargetType == TT_HAILING;
         this.QuestMarker_mc.visible = param1.bHasQuestTarget;
         this.PoiIcon_mc.alpha = !this.QuestMarker_mc.visible && !param1.bIsCelestialParentBody && Boolean(param1.bHasUndiscoveredPoi) ? 1 : 0;
         if(this.PoiIcon_mc.alpha > 0 && this.PoiIcon_mc.visible)
         {
            this.PoiIcon_mc.SetLocation(param1.uPoiType,param1.uPoiCategory,DynamicPoiIcon.GetSpaceMarkerState(param1.bMarkerDiscovered));
         }
         this.PlanetIcon_mc.alpha = param1.bIsCelestialParentBody && param3 && !this.QuestMarker_mc.visible && this.PoiIcon_mc.alpha == 0 && param1.uTargetType == TT_PLANET ? 1 : 0;
      }
      
      private function onEnterFrame() : *
      {
         var _loc1_:MovieClip = this.SelectedState_mc.HitAnim_mc;
         if(_loc1_.currentFrameLabel == "Reset")
         {
            this.HitAnimEnding = true;
            this.ReverseAnim = false;
            _loc1_.play();
         }
         else if(this.ReverseAnim)
         {
            _loc1_.prevFrame();
         }
         else if(_loc1_.currentFrameLabel == "Off")
         {
            this.HitAnimEnding = false;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      override public function SetTargetHighInfo(param1:Object) : *
      {
         super.SetTargetHighInfo(param1);
         var _loc2_:Number = param1.angleToCrosshair + 180;
         rotation = _loc2_;
         if(this.PoiIcon_mc.alpha > 0 && this.PoiIcon_mc.visible)
         {
            this.PoiIcon_mc.rotation = -_loc2_;
         }
      }
      
      private function GoToFactionFrame(param1:String) : *
      {
         if(this.LastFactionFrame != param1)
         {
            this.FactionWrapper_mc.gotoAndStop(param1);
            this.LastFactionFrame = param1;
         }
      }
   }
}
