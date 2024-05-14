package Shared.AS3.ShipPower
{
   public class MyShipComponentManager extends ShipComponentManager
   {
       
      
      public var ShipPower_mc:ShipPowerMeter;
      
      public function MyShipComponentManager()
      {
         super();
      }
      
      public function UpdateRepairData(param1:Number) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < ComponentMeters.length)
         {
            ComponentMeters[_loc2_].PhysicalRepair = param1 > 0;
            _loc2_++;
         }
      }
      
      public function OnShipComponentUpdate(param1:Object, param2:Array) : *
      {
         ComponentsArray = param2;
         this.ShipPower_mc.ComponentObject = param1;
         UpdateComponentsArray();
      }
   }
}
