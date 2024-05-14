package Shared.AS3.QuickContainer
{
   import Components.LabeledMeterColorConfig;
   import Components.LabeledMeterMC;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ContainerData extends MovieClip
   {
      
      private static const WEIGHT_EPSILON:Number = 0.001;
       
      
      public var CapacityDisplay_mc:LabeledMeterMC;
      
      public var CreditsHeader_tf:TextField;
      
      public var Credits_tf:TextField;
      
      private var CapacityDisplayManager:CapacityMeterManager;
      
      public function ContainerData()
      {
         super();
         this.CapacityDisplayManager = new CapacityMeterManager(this.CapacityDisplay_mc);
         this.CapacityDisplayManager.SetSuffix(" KG");
         this.CapacityDisplay_mc.SetMode(LabeledMeterMC.MODE_WEIGHT);
         this.CapacityDisplay_mc.SetColorConfig(LabeledMeterColorConfig.CONFIG_DEFAULT_WEIGHT);
      }
      
      public function ShowCredits(param1:Boolean) : void
      {
         this.CreditsHeader_tf.visible = param1;
         this.Credits_tf.visible = param1;
      }
      
      public function SetWeightPrecision(param1:uint) : *
      {
         this.CapacityDisplay_mc.SetLabelPrecision(param1);
      }
      
      public function SetCurrCapacity(param1:Number) : void
      {
         this.CapacityDisplayManager.SetCurrCapacity(param1);
      }
      
      public function SetMaxCapacity(param1:Number) : void
      {
         this.CapacityDisplayManager.SetMaxCapacity(param1);
      }
      
      public function SetCapacityLabel(param1:String) : void
      {
         this.CapacityDisplay_mc.SetLabel(param1);
      }
      
      public function SetAdditionalCapacity(param1:Number) : void
      {
         this.CapacityDisplayManager.SetAdditionalCapacity(param1);
      }
      
      public function UpdateAdditionalCapacityFromItem(param1:Object) : void
      {
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         if(param1 != null)
         {
            _loc2_ = Number(param1.fWeight);
            _loc3_ = uint(param1.uCount);
         }
         _loc2_ *= _loc3_;
         this.SetAdditionalCapacity(_loc2_);
      }
      
      public function SetCredits(param1:uint = 0) : void
      {
         if(this.Credits_tf != null)
         {
            GlobalFunc.SetText(this.Credits_tf,param1.toString());
         }
      }
      
      public function UpdateData(param1:Number, param2:Number, param3:uint = 0) : void
      {
         this.SetCredits(param3);
         this.SetMaxCapacity(param2);
         this.SetCurrCapacity(param1);
      }
   }
}
