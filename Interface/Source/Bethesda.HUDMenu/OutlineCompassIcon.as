package
{
   import flash.display.MovieClip;
   
   public class OutlineCompassIcon extends MovieClip
   {
       
      
      public var handle:uint = 0;
      
      public function OutlineCompassIcon()
      {
         super();
      }
      
      public function SetData(param1:Object) : *
      {
         this.handle = param1.uiHandle;
      }
   }
}
