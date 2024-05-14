package
{
   import Shared.AS3.BSStepper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class BodySelector extends MovieClip
   {
       
      
      public var Stepper_mc:MovieClip;
      
      public var LabelText_mc:MovieClip;
      
      private const TYPE_1:uint = 0;
      
      private const TYPE_2:uint = 1;
      
      private var CurrentValue:int = -1;
      
      private var bActive:Boolean = false;
      
      private var Options:Array;
      
      public function BodySelector()
      {
         this.Options = ["$OPTION1","$OPTION2"];
         super();
         this.Stepper_mc.stationaryArrows = true;
         this.Stepper_mc.addEventListener(BSStepper.VALUE_CHANGED,this.onStepperValueChanged);
         this.Stepper_mc.options = this.Options;
      }
      
      public function SetSelectedValue(param1:int) : *
      {
         if(this.CurrentValue != param1)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.COLUMN_SWITCH_SOUND);
         }
         this.CurrentValue = param1;
      }
      
      public function GetSelectedValue() : int
      {
         return this.CurrentValue;
      }
      
      public function SetActive(param1:Boolean) : *
      {
         if(this.bActive != param1)
         {
            if(param1)
            {
               GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
               stage.focus = this.Stepper_mc;
               gotoAndStop("Selected");
            }
            else
            {
               gotoAndStop("Unselected");
            }
         }
         this.bActive = param1;
      }
      
      protected function GetValueIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = int(this.TYPE_1);
               break;
            case 1:
               _loc2_ = int(this.TYPE_2);
         }
         return _loc2_;
      }
      
      protected function onStepperValueChanged() : *
      {
      }
   }
}
