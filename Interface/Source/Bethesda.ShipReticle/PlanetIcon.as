package
{
   public class PlanetIcon extends FarTravelIconBase
   {
       
      
      private var LastPoi:Boolean = false;
      
      public function PlanetIcon()
      {
         super();
      }
      
      override public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         super.SetTargetLowInfo(param1,param2,param3);
         var _loc4_:Boolean = param3 && Boolean(param1.bHasUndiscoveredPoi);
         if(this.LastPoi != _loc4_)
         {
            Icon_mc.gotoAndStop(_loc4_ ? "POI" : "Normal");
            this.LastPoi = _loc4_;
         }
      }
   }
}
