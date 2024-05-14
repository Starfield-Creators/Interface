package
{
   import flash.display.MovieClip;
   
   public class ShieldWaveClip extends MovieClip
   {
       
      
      public var LineHolder_mc:MovieClip;
      
      private var LastFrame:uint = 4294967295;
      
      public function ShieldWaveClip()
      {
         super();
      }
      
      public function UpdateFrame(param1:uint) : *
      {
         if(this.LastFrame != param1)
         {
            gotoAndStop(param1);
            this.LastFrame = param1;
         }
      }
   }
}
