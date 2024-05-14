package
{
   import Components.Icons.MissionMarker;
   import flash.display.MovieClip;
   
   public class MissionIconContainer extends MovieClip
   {
       
      
      public var Nameplate_mc:QuestTargetNameplate;
      
      public var ObjectiveAtPOI_mc:MissionMarker;
      
      public var ObjectiveAtPOIInactive_mc:MissionMarker;
      
      private const ACTIVE:int = 1;
      
      private const INACTIVE:int = 2;
      
      private var bMissionIconHovered:Boolean = false;
      
      private var bMissionIconVisible:Boolean = false;
      
      private var missionData:* = null;
      
      public function MissionIconContainer()
      {
         super();
         this.ObjectiveAtPOI_mc.onRolloverCallback = this.OnMissionIconRollover;
         this.ObjectiveAtPOI_mc.onRolloutCallback = this.OnMissionIconRollout;
         this.ObjectiveAtPOIInactive_mc.onRolloverCallback = this.OnMissionIconRollover;
         this.ObjectiveAtPOIInactive_mc.onRolloutCallback = this.OnMissionIconRollout;
      }
      
      public function Update(param1:Object) : void
      {
         this.missionData = param1;
         this.bMissionIconVisible = param1.bMarkerVisible;
         this.ObjectiveAtPOI_mc.visible = param1.bQuestActive;
         this.ObjectiveAtPOIInactive_mc.visible = !param1.bQuestActive;
         this.UpdateMissionText(param1);
      }
      
      public function OnMissionIconRollover() : *
      {
         this.bMissionIconHovered = true;
         this.UpdateMissionText(this.missionData);
      }
      
      public function OnMissionIconRollout() : *
      {
         this.bMissionIconHovered = false;
         this.UpdateMissionText(this.missionData);
      }
      
      private function UpdateMissionText(param1:Object) : *
      {
         var _loc2_:Object = new Object();
         _loc2_.sMarkerText = param1.sQuestTargetText;
         _loc2_.bForceHideText = param1.bForceHideText;
         _loc2_.bShowHighlight = param1.bShowHighlight;
         _loc2_.bMarkerVisible = this.bMissionIconVisible || this.bMissionIconHovered;
         _loc2_.uPoiCategory = 0;
         _loc2_.bMarkerDiscovered = true;
         this.Nameplate_mc.Update(_loc2_);
      }
   }
}
