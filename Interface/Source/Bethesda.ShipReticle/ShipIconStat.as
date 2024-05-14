package
{
   import flash.display.MovieClip;
   
   public class ShipIconStat extends ShipStatBase
   {
       
      
      public var Icon_mc:MovieClip;
      
      private var LastFrame:String = "";
      
      public function ShipIconStat()
      {
         super();
      }
      
      public function SetFrame(param1:String) : *
      {
         if(this.LastFrame != param1)
         {
            this.Icon_mc.gotoAndStop(param1);
            this.LastFrame = param1;
         }
      }
   }
}
