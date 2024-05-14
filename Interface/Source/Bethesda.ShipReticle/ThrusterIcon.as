package
{
   import flash.display.MovieClip;
   
   public class ThrusterIcon extends MovieClip
   {
       
      
      public var ThrusterUp_mc:MovieClip;
      
      public var ThrusterDown_mc:MovieClip;
      
      public var ThrusterLeft_mc:MovieClip;
      
      public var ThrusterRight_mc:MovieClip;
      
      public function ThrusterIcon()
      {
         super();
      }
      
      public function OnStickDataUpdate(param1:Object) : *
      {
         visible = param1.throttleMode;
         this.ThrusterLeft_mc.visible = param1.fThrusterModeInputX < 0;
         this.ThrusterRight_mc.visible = param1.fThrusterModeInputX > 0;
         this.ThrusterUp_mc.visible = param1.fThrusterModeInputY > 0;
         this.ThrusterDown_mc.visible = param1.fThrusterModeInputY < 0;
      }
   }
}
