package
{
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.ShipInfoUtils;
   import flash.display.MovieClip;
   
   public class ShieldThrottleComponent extends MovieClip
   {
       
      
      public var ShieldComponent_mc:ShieldComponent;
      
      public function ShieldThrottleComponent()
      {
         super();
      }
      
      public function get ShipRepairButton() : ButtonBase
      {
         return this.ShieldComponent_mc.ShipRepairButton;
      }
      
      public function OnPlayerShipComponentsUpdate(param1:Object) : *
      {
         var _loc3_:Object = null;
         var _loc2_:Array = param1.componentArray;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.type == ShipInfoUtils.MT_SHIELD)
            {
               this.ShieldComponent_mc.UpdateShieldPower(_loc3_);
               break;
            }
         }
      }
      
      public function Update(param1:Object) : *
      {
         this.ShieldComponent_mc.UpdateShieldHealth(param1);
      }
      
      public function InitiateFarTravel() : *
      {
         this.ShieldComponent_mc.InitiateFarTravel();
      }
      
      public function CompleteFarTravel() : *
      {
         this.ShieldComponent_mc.CompleteFarTravel();
      }
   }
}
