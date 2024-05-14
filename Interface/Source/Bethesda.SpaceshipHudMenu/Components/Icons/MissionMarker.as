package Components.Icons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MissionMarker extends MovieClip
   {
       
      
      public var onRolloverCallback:Function = null;
      
      public var onRolloutCallback:Function = null;
      
      public function MissionMarker()
      {
         super();
         addEventListener(MouseEvent.ROLL_OVER,this.onRollover);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollout);
      }
      
      public function onRollover(param1:MouseEvent) : *
      {
         if(this.onRolloverCallback != null)
         {
            this.onRolloverCallback();
         }
      }
      
      public function onRollout(param1:MouseEvent) : *
      {
         if(this.onRolloutCallback != null)
         {
            this.onRolloutCallback();
         }
      }
   }
}
