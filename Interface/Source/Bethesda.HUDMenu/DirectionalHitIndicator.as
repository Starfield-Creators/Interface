package
{
   import flash.display.MovieClip;
   
   public class DirectionalHitIndicator extends MovieClip
   {
      
      public static const ANIM_FINISHED:String = "ANIM_FINISHED";
       
      
      public var Arc_mc:MovieClip;
      
      public function DirectionalHitIndicator()
      {
         super();
         this.Arc_mc.visible = false;
      }
      
      public function showDirection(param1:Number) : void
      {
         this.Arc_mc.rotation = param1;
         this.Arc_mc.visible = true;
         this.Arc_mc.gotoAndPlay(1);
      }
   }
}
