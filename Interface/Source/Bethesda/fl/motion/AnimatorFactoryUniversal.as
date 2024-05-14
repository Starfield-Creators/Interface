package fl.motion
{
   public class AnimatorFactoryUniversal extends AnimatorFactoryBase
   {
       
      
      public function AnimatorFactoryUniversal(param1:MotionBase, param2:Array)
      {
         super(param1,param2);
      }
      
      override protected function getNewAnimator() : AnimatorBase
      {
         return new AnimatorUniversal();
      }
   }
}
