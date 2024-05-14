package
{
   import Shared.AS3.ShipPower.MyShipComponentMeter;
   import Shared.GlobalFunc;
   
   public class MyInteractiveShipComponentMeter extends MyShipComponentMeter
   {
       
      
      protected var previousPowerLevel:Number = 0;
      
      protected var wasDamaged:Boolean = false;
      
      protected var wasDestroyed:Boolean = false;
      
      protected var wasPowerEmpty:Boolean = false;
      
      protected var wasRepairing:Boolean = false;
      
      public function MyInteractiveShipComponentMeter()
      {
         super();
      }
      
      private function UpdatePreviousStates() : void
      {
         this.previousPowerLevel = currentPowerLevel;
         this.wasDamaged = isDamaged;
         this.wasDestroyed = isDestroyed;
         this.wasPowerEmpty = isPowerEmpty;
         this.wasRepairing = isRepairing;
      }
      
      private function PlaySounds() : void
      {
         if(this.wasPowerEmpty && currentPowerLevel > 0)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentActivateOn");
         }
         else if(!this.wasPowerEmpty && isPowerEmpty)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentActivateOff");
         }
         if(this.previousPowerLevel < currentPowerLevel)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentPowerLevelIncrease","VEH_Ship_System_PowerLevel",(currentPowerLevel as Number) / MaxPower);
         }
         else if(this.previousPowerLevel > currentPowerLevel)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentPowerLevelDecrease","VEH_Ship_System_PowerLevel",(currentPowerLevel as Number) / MaxPower);
         }
         if(!this.wasDamaged && isDamaged)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentDamaged");
         }
         if(!this.wasDestroyed && isDestroyed)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentDestroyed");
         }
         if(!this.wasRepairing && isRepairing)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentRepairing");
         }
         else if(this.wasRepairing && !isRepairing)
         {
            GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentRepaired");
         }
      }
      
      override public function set ComponentObject(param1:Object) : *
      {
         this.UpdatePreviousStates();
         super.ComponentObject = param1;
         this.PlaySounds();
      }
      
      override public function set PhysicalRepair(param1:Boolean) : *
      {
         this.UpdatePreviousStates();
         super.PhysicalRepair = param1;
         this.PlaySounds();
      }
      
      override public function PlayInvalidActionAnimation() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuPowerAllocComponentPowerLevelMaxed");
         super.PlayInvalidActionAnimation();
      }
      
      override public function SetSelected(param1:Boolean) : *
      {
         if(ActiveSelection_mc.visible != param1)
         {
            ComponentName_mc.gotoAndStop(param1 ? "Black" : "Blue");
         }
         super.SetSelected(param1);
      }
   }
}
