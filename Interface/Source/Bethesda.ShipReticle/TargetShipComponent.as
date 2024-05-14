package
{
   import Shared.AS3.ShipPower.ShipComponentBase;
   
   public class TargetShipComponent extends ShipComponentBase
   {
       
      
      public function TargetShipComponent()
      {
         super();
      }
      
      override public function Update() : *
      {
         visible = componentObject != null && componentObject.damagePhys + componentObject.damageEM >= componentObject.componentMaxPower;
         if(visible)
         {
            super.Update();
         }
      }
   }
}
