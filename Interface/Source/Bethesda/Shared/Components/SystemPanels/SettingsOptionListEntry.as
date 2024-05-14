package Shared.Components.SystemPanels
{
   import Shared.AS3.BSCheckBox;
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSSlider;
   import Shared.AS3.BSStepper;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class SettingsOptionListEntry extends BSContainerEntry
   {
      
      public static const VALUE_CHANGE:String = "SettingsOptionEntry_ValueChanged";
      
      public static const CHECKBOX_ON_VALUE:Number = 1;
      
      public static const CHECKBOX_OFF_VALUE:Number = 0;
      
      public static const SDT_SLIDER:int = EnumHelper.GetEnum(0);
      
      public static const SDT_STEPPER:int = EnumHelper.GetEnum();
      
      public static const SDT_LARGE_STEPPER:int = EnumHelper.GetEnum();
      
      public static const SDT_CHECKBOX:int = EnumHelper.GetEnum();
      
      public static const SDT_LINK:int = EnumHelper.GetEnum();
       
      
      public var Slider_mc:BSSlider;
      
      public var Stepper_mc:BSStepper;
      
      public var LargeStepper_mc:BSStepper;
      
      public var CheckBox_mc:BSCheckBox;
      
      public var Text_mc:MovieClip;
      
      public var SliderValueText_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      private const SLIDER_PERCENT:Number = 100;
      
      private const SUB_SETTING_OFFSET:Number = 30;
      
      private const LARGE_STEPPER_CHAR_LIMIT:Number = 19;
      
      private var StepperOptions:Array;
      
      private var SettingType:int = -1;
      
      private var SettingID:uint;
      
      private var Category:uint;
      
      private var Enabled:Boolean = true;
      
      private var TextLocation:Number;
      
      public function SettingsOptionListEntry()
      {
         super();
         this.TextLocation = this.baseTextField.x;
         this.Slider_mc.maxValue = this.SLIDER_PERCENT;
         this.Stepper_mc.stationaryArrows = true;
         this.LargeStepper_mc.stationaryArrows = true;
         this.LargeStepper_mc.characterLimit = this.LARGE_STEPPER_CHAR_LIMIT;
         addEventListener(BSSlider.INPUT_CHANGED,this.onSliderValueChange);
         addEventListener(BSStepper.INPUT_CHANGED,this.onStepperValueChange);
         addEventListener(BSCheckBox.INPUT_CHANGED,this.onCheckboxValueChange);
      }
      
      public function get stepperOptions() : Array
      {
         return this.StepperOptions;
      }
      
      public function set stepperOptions(param1:Array) : void
      {
         this.StepperOptions = param1;
         this.Stepper_mc.options = this.stepperOptions;
         this.LargeStepper_mc.options = this.stepperOptions;
      }
      
      public function get settingType() : uint
      {
         return this.SettingType;
      }
      
      public function set settingType(param1:uint) : void
      {
         if(this.SettingType != param1)
         {
            this.SettingType = param1;
            this.Slider_mc.visible = this.IsSlider();
            this.Stepper_mc.visible = this.IsStepper();
            this.LargeStepper_mc.visible = this.IsLargeStepper();
            this.CheckBox_mc.visible = this.IsCheckBox();
         }
      }
      
      private function get sliderValueText_tf() : TextField
      {
         return this.SliderValueText_mc.Text_tf;
      }
      
      public function IsSlider() : Boolean
      {
         return this.settingType == SDT_SLIDER;
      }
      
      public function IsStepper() : Boolean
      {
         return this.settingType == SDT_STEPPER;
      }
      
      public function IsLargeStepper() : Boolean
      {
         return this.settingType == SDT_LARGE_STEPPER;
      }
      
      public function IsCheckBox() : Boolean
      {
         return this.settingType == SDT_CHECKBOX;
      }
      
      public function IsLink() : Boolean
      {
         return this.settingType == SDT_LINK;
      }
      
      public function get settingID() : uint
      {
         return this.SettingID;
      }
      
      public function set settingID(param1:uint) : void
      {
         this.SettingID = param1;
      }
      
      public function get category() : uint
      {
         return this.Category;
      }
      
      public function set category(param1:uint) : void
      {
         this.Category = param1;
      }
      
      public function get settingValue() : Number
      {
         var _loc1_:Number = 0;
         switch(this.settingType)
         {
            case SDT_SLIDER:
               _loc1_ = this.Slider_mc.value / this.SLIDER_PERCENT;
               break;
            case SDT_STEPPER:
               _loc1_ = this.Stepper_mc.index;
               break;
            case SDT_LARGE_STEPPER:
               _loc1_ = this.LargeStepper_mc.index;
               break;
            case SDT_CHECKBOX:
               _loc1_ = this.CheckBox_mc.checked ? CHECKBOX_ON_VALUE : CHECKBOX_OFF_VALUE;
         }
         return _loc1_;
      }
      
      public function set settingValue(param1:Number) : void
      {
         switch(this.settingType)
         {
            case SDT_SLIDER:
               this.Slider_mc.value = param1 * this.SLIDER_PERCENT;
               break;
            case SDT_STEPPER:
               this.Stepper_mc.index = param1;
               break;
            case SDT_LARGE_STEPPER:
               this.LargeStepper_mc.index = param1;
               break;
            case SDT_CHECKBOX:
               this.CheckBox_mc.checked = param1 == CHECKBOX_ON_VALUE;
         }
      }
      
      public function get settingEnabled() : Boolean
      {
         return this.Enabled;
      }
      
      public function set settingEnabled(param1:Boolean) : void
      {
         if(param1 != this.Enabled)
         {
            this.Enabled = param1;
            this.Slider_mc.sliderEnabled = this.Enabled;
            this.Stepper_mc.stepperEnabled = this.Enabled;
            this.LargeStepper_mc.stepperEnabled = this.Enabled;
            this.CheckBox_mc.checkboxEnabled = this.Enabled;
         }
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.textField;
      }
      
      override public function get selectedFrameLabel() : String
      {
         return this.settingEnabled ? "selected" : "disabled_Selected";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         return this.settingEnabled ? "unselected" : "disabled_Unselected";
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sText;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.settingEnabled = param1.bEnabled !== false;
         this.settingType = param1.uType;
         this.settingID = param1.uID;
         this.category = param1.uCategory;
         this.stepperOptions = param1.stepperData.aStepperOptions;
         switch(this.settingType)
         {
            case SDT_SLIDER:
               this.settingValue = param1.sliderData.fValue;
               break;
            case SDT_STEPPER:
            case SDT_LARGE_STEPPER:
               this.settingValue = param1.stepperData.uIndex;
               break;
            case SDT_CHECKBOX:
               this.settingValue = !!param1.checkBoxData.bChecked ? CHECKBOX_ON_VALUE : CHECKBOX_OFF_VALUE;
         }
         this.baseTextField.x = !!param1.bSubSetting ? this.TextLocation + this.SUB_SETTING_OFFSET : this.TextLocation;
         if(this.IsSlider())
         {
            GlobalFunc.SetText(this.sliderValueText_tf,param1.sliderData.sDisplayValue);
         }
         super.SetEntryText(param1);
         this.onRollout();
      }
      
      override public function onRollover() : void
      {
         super.onRollover();
         this.SliderValueText_mc.visible = this.IsSlider();
      }
      
      override public function onRollout() : void
      {
         super.onRollout();
         this.SliderValueText_mc.visible = false;
      }
      
      public function onEntryPressed() : void
      {
         if(this.IsCheckBox())
         {
            this.CheckBox_mc.PressHandler();
         }
         else if(this.IsLink())
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.dispatchValueChange();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(this.IsStepper())
         {
            this.Stepper_mc.onKeyDownHandler(param1);
         }
         else if(this.IsLargeStepper())
         {
            this.LargeStepper_mc.onKeyDownHandler(param1);
         }
         else if(this.IsSlider())
         {
            this.Slider_mc.onKeyDownHandler(param1);
         }
      }
      
      private function dispatchValueChange() : void
      {
         dispatchEvent(new CustomEvent(VALUE_CHANGE,{
            "value":this.settingValue,
            "id":this.settingID,
            "type":this.settingType
         },true,true));
      }
      
      private function onSliderValueChange() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralSlider");
         this.dispatchValueChange();
      }
      
      private function onStepperValueChange() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralColumn");
         this.dispatchValueChange();
      }
      
      private function onCheckboxValueChange() : void
      {
         GlobalFunc.PlayMenuSound(!!this.settingValue ? GlobalFunc.OK_SOUND : GlobalFunc.CANCEL_SOUND);
         this.dispatchValueChange();
      }
   }
}
