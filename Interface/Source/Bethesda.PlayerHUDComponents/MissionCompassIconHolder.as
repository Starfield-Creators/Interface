package
{
   import Shared.MapMarkerUtils;
   
   public class MissionCompassIconHolder extends OutlineCompassIcon
   {
       
      
      public var IconFrames_mc:FloatingTarget;
      
      public function MissionCompassIconHolder()
      {
         super();
      }
      
      override public function SetData(param1:Object) : *
      {
         super.SetData(param1);
         if(MapMarkerUtils.GetMajorFrameFromMitMarkerType(param1.uiMarkerIconType) != this.IconFrames_mc.currentFrameLabel)
         {
            this.IconFrames_mc.gotoAndStop(MapMarkerUtils.GetMajorFrameFromMitMarkerType(param1.uiMarkerIconType));
         }
      }
   }
}
