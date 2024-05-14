package Components.StarMapWidgets
{
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SystemViewHolder extends MovieClip
   {
      
      private static const FOCUS_SYSTEM_TIME:* = 0.5;
      
      private static const FOCUS_PLANET_TIME:* = 1;
      
      private static const SYSTEM_START_SCALE:* = 0.05;
       
      
      public var SystemID:uint = 0;
      
      public var SystemView_mc:SystemView;
      
      private var InitialStageX:Number = 0;
      
      private var DefaultSunSize:Number = 0;
      
      public function SystemViewHolder()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
      }
      
      private function onStageInit(param1:Event) : *
      {
         this.InitialStageX = this.SystemView_mc.x;
         this.DefaultSunSize = this.SystemView_mc.Body_mc.width;
      }
      
      public function UpdateSystemView(param1:Object, param2:uint) : *
      {
         this.SystemID = param1.bodyID;
         this.SystemView_mc.scaleX = SYSTEM_START_SCALE;
         this.SystemView_mc.scaleY = SYSTEM_START_SCALE;
         this.SystemView_mc.UpdateInfo(param1,this.DefaultSunSize,param2);
      }
      
      public function FocusBody(param1:uint, param2:Number) : *
      {
         if(param1 == 0 || param1 == this.SystemID)
         {
            if(this.SystemID != 0)
            {
               this.SystemView_mc.FocusBody(this.SystemID,param2,FOCUS_SYSTEM_TIME);
               this.PanToBody(this.SystemID,param2,FOCUS_SYSTEM_TIME);
            }
         }
         else
         {
            this.SystemView_mc.FocusBody(param1,param2,FOCUS_PLANET_TIME);
            this.PanToBody(param1,param2,FOCUS_PLANET_TIME);
         }
      }
      
      private function PanToBody(param1:uint, param2:Number, param3:Number) : *
      {
         var _loc4_:Number = this.InitialStageX;
         if(param1 != 0 && param1 != this.SystemID)
         {
            _loc4_ -= this.SystemView_mc.GetChildBodyTargetXRecursive(param1);
         }
         eaze(this.SystemView_mc).easing(Quadratic.easeInOut).to(param3,{
            "x":_loc4_ * param2,
            "scaleX":param2,
            "scaleY":param2
         });
      }
      
      public function SetBodyHighlight(param1:uint) : void
      {
         this.SystemView_mc.ShowHighlight(param1);
      }
   }
}
