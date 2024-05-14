package Shared.AS3.QuickContainer
{
   import Components.LabeledMeterMC;
   
   public class CapacityMeterManager
   {
       
      
      public var CapacityDisplay:LabeledMeterMC;
      
      private var AdditionalCapacity:Number = 0;
      
      private var CurrentCapacity:Number = 0;
      
      private var MaxCapacity:Number = 0;
      
      private var UpdatedOnce:Boolean = false;
      
      public function CapacityMeterManager(param1:LabeledMeterMC)
      {
         super();
         this.CapacityDisplay = param1;
      }
      
      public function SetCurrCapacity(param1:Number) : void
      {
         if(this.CurrentCapacity != param1)
         {
            this.CurrentCapacity = param1;
            if(this.UpdatedOnce)
            {
               this.CapacityDisplay.SetTargetCurrentValue(param1,this.AdditionalCapacity);
            }
            else
            {
               this.CapacityDisplay.SetCurrentValue(param1,this.AdditionalCapacity);
               this.UpdatedOnce = true;
            }
         }
      }
      
      public function SetMaxCapacity(param1:Number) : void
      {
         if(this.MaxCapacity != param1)
         {
            this.MaxCapacity = param1;
            this.CapacityDisplay.SetMaxValue(param1);
         }
      }
      
      public function SetSuffix(param1:String) : *
      {
         this.CapacityDisplay.SetSuffix(param1);
      }
      
      public function SetAdditionalCapacity(param1:Number) : void
      {
         if(this.AdditionalCapacity != param1)
         {
            this.AdditionalCapacity = param1;
            this.CapacityDisplay.SetTargetCurrentValue(this.CurrentCapacity,param1);
         }
      }
   }
}
