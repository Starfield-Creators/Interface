package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSSlider;
   import Shared.AS3.BSStepper;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class PhotoModeSettingEntry extends BSContainerEntry
   {
      
      public static const VALUE_CHANGE:String = "PhotoModeSettingEntry_ValueChanged";
      
      public static const PMST_SLIDER:int = EnumHelper.GetEnum(0);
      
      public static const PMST_STEPPER:int = EnumHelper.GetEnum();
       
      
      public var Slider_mc:BSSlider;
      
      public var Stepper_mc:BSStepper;
      
      public var Text_mc:MovieClip;
      
      private const SELECTED_CLIP_COLOR:uint = 0;
      
      private const UNSELECTED_CLIP_COLOR:uint = 11711154;
      
      private const DISABLED_SELECTED_CLIP_COLOR:uint = 1710618;
      
      private const DISABLED_UNSELECTED_CLIP_COLOR:uint = 5066061;
      
      private const SLIDER_PERCENT:Number = 100;
      
      private const SUB_SETTING_OFFSET:Number = 30;
      
      private const STEPPER_CHAR_LIMIT:Number = 19;
      
      private const NAME_CHAR_LIMIT:Number = 20;
      
      private var PossibleValues:Array;
      
      private var SettingType:int;
      
      private var SettingID:uint;
      
      private var Category:uint;
      
      private var TextLocation:Number;
      
      private var Disabled:Boolean = false;
      
      private var Selected:Boolean = false;
      
      public function PhotoModeSettingEntry()
      {
         super();
         this.SettingType = -1;
         this.PossibleValues = new Array();
         this.TextLocation = this.Text_mc.x;
         this.Slider_mc.maxValue = this.SLIDER_PERCENT;
         this.Stepper_mc.stationaryArrows = true;
         addEventListener(BSSlider.INPUT_CHANGED,this.onValueChange);
         addEventListener(BSStepper.INPUT_CHANGED,this.onValueChange);
      }
      
      public function get possibleValues() : Array
      {
         return this.PossibleValues;
      }
      
      public function set possibleValues(param1:Array) : *
      {
         this.PossibleValues = param1;
         this.Stepper_mc.options = this.possibleValues;
      }
      
      public function get settingType() : uint
      {
         return this.SettingType;
      }
      
      public function set settingType(param1:uint) : *
      {
         if(this.SettingType != param1)
         {
            this.SettingType = param1;
            this.Slider_mc.visible = this.IsSlider();
            this.Stepper_mc.visible = this.IsStepper();
         }
      }
      
      public function IsSlider() : Boolean
      {
         return this.settingType == PMST_SLIDER;
      }
      
      public function IsStepper() : Boolean
      {
         return this.settingType == PMST_STEPPER;
      }
      
      public function get settingID() : uint
      {
         return this.SettingID;
      }
      
      public function set settingID(param1:uint) : *
      {
         this.SettingID = param1;
      }
      
      public function get category() : uint
      {
         return this.Category;
      }
      
      public function set category(param1:uint) : *
      {
         this.Category = param1;
      }
      
      override public function get selected() : Boolean
      {
         return this.Selected;
      }
      
      public function set selected(param1:Boolean) : *
      {
         this.Selected = param1;
      }
      
      public function get disabled() : Boolean
      {
         return this.Disabled;
      }
      
      public function set disabled(param1:Boolean) : *
      {
         if(this.Disabled != param1)
         {
            this.Disabled = param1;
            this.RefreshRollover();
         }
      }
      
      public function get innerClipValue() : Number
      {
         var _loc1_:Number = 0;
         if(this.IsSlider())
         {
            _loc1_ = this.Slider_mc.value / this.SLIDER_PERCENT;
         }
         else if(this.IsStepper())
         {
            _loc1_ = this.Stepper_mc.index;
         }
         return _loc1_;
      }
      
      public function set innerClipValue(param1:Number) : *
      {
         if(this.IsSlider())
         {
            this.Slider_mc.value = param1 * this.SLIDER_PERCENT;
         }
         else if(this.IsStepper())
         {
            this.Stepper_mc.index = param1;
         }
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.textField;
      }
      
      override public function get selectedFrameLabel() : String
      {
         if(this.Disabled)
         {
            return "selectedDisabled";
         }
         return "selected";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         if(this.Disabled)
         {
            return "unselectedDisabled";
         }
         return "unselected";
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sName;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.settingType = param1.uType;
         this.settingID = param1.uID;
         this.category = param1.uCategory;
         this.disabled = param1.bDisabled;
         this.possibleValues = param1.stepperData.aStepperOptions;
         this.innerClipValue = this.IsSlider() ? Number(param1.sliderData.fValue) : Number(param1.stepperData.uIndex);
         this.Text_mc.x = !!param1.bSubSetting ? this.TextLocation + this.SUB_SETTING_OFFSET : this.TextLocation;
         super.SetEntryText(param1);
         this.SetTextColor();
      }
      
      override public function onRollover() : void
      {
         this.selected = true;
         super.onRollover();
         this.SetTextColor();
      }
      
      override public function onRollout() : void
      {
         this.selected = false;
         super.onRollout();
         this.SetTextColor();
      }
      
      public function onEntryPressed() : *
      {
         if(!this.disabled && this.IsStepper())
         {
            this.Stepper_mc.PressHandler();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(!this.disabled)
         {
            if(this.IsStepper())
            {
               this.Stepper_mc.onKeyDownHandler(param1);
            }
            else if(this.IsSlider())
            {
               this.Slider_mc.onKeyDownHandler(param1);
            }
         }
      }
      
      private function SetTextColor() : void
      {
         if(this.selected)
         {
            this.baseTextField.textColor = this.disabled ? this.DISABLED_SELECTED_CLIP_COLOR : this.SELECTED_CLIP_COLOR;
         }
         else
         {
            this.baseTextField.textColor = this.disabled ? this.DISABLED_UNSELECTED_CLIP_COLOR : this.UNSELECTED_CLIP_COLOR;
         }
      }
      
      private function onValueChange() : *
      {
         dispatchEvent(new CustomEvent(VALUE_CHANGE,{
            "value":this.innerClipValue,
            "id":this.settingID,
            "type":this.settingType
         },true,true));
      }
      
      private function RefreshRollover() : void
      {
         if(this.selected)
         {
            this.onRollover();
         }
         else
         {
            this.onRollout();
         }
      }
   }
}
