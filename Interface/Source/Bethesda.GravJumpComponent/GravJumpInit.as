package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class GravJumpInit extends MovieClip
   {
       
      
      public function GravJumpInit()
      {
         super();
      }
      
      protected function PlayInitiate() : *
      {
         GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceZInitiate");
      }
   }
}
