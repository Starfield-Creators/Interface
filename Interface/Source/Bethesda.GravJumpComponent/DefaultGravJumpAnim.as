package
{
   public class DefaultGravJumpAnim extends GravJumpAnim
   {
      
      private static const DEFAULT_END_FRAME:Number = 91;
       
      
      public function DefaultGravJumpAnim()
      {
         super();
      }
      
      override protected function SetEndFrame() : *
      {
         EndFrameTimePercent = (framesLoaded - DEFAULT_END_FRAME) / framesLoaded;
      }
   }
}
