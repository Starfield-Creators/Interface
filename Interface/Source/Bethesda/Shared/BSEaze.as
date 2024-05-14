package Shared
{
   import aze.motion.EazeTween;
   
   public function BSEaze(param1:*) : EazeCommon
   {
      if(param1 is EazeTween)
      {
         return new EazeCommon(param1);
      }
      if(param1 is Object)
      {
         return new EazeCommon(new EazeTween(param1));
      }
      throw new Error("Unexpected type received into BSEaze");
   }
}
