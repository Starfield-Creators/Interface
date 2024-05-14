package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSSlider;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PostBlendSliderListEntry extends BSContainerEntry
   {
      
      private static const INTENSITY_SCALAR:Number = 100;
       
      
      public var Slider_mc:BSSlider;
      
      public var SliderText_mc:MovieClip;
      
      private var MOUSE_WHEEL_VALUE_CHANGE:int = 15;
      
      private var SliderID:uint = 0;
      
      private var sEventName:String = "";
      
      private var sCallback:String = "";
      
      private var uSubType:uint = 4294967295;
      
      private var strCustimizationDataName:String = "";
      
      private var IsColorOption:Boolean = false;
      
      private var Initialized:Boolean = false;
      
      private var JumpAmount:Number = 0;
      
      private var Data:Object = null;
      
      public function PostBlendSliderListEntry()
      {
         super();
         this.Slider_mc.minValue = 0;
         this.Slider_mc.maxValue = 200;
         this.Slider_mc.value = 100;
         this.Slider_mc.mouseWheelValueChange = this.MOUSE_WHEEL_VALUE_CHANGE;
         this.Slider_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollover);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function get isColorOption() : Boolean
      {
         return this.IsColorOption;
      }
      
      public function set subType(param1:uint) : *
      {
         this.uSubType = param1;
      }
      
      public function IsMouseDraggingSlider() : Boolean
      {
         return this.Slider_mc.dragging;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc3_:Number = NaN;
         this.Data = GlobalFunc.CloneObject(param1);
         if(!this.Initialized)
         {
            this.Initialized = true;
            stage.addEventListener(FacePartListEntry.STEPPER_VALUE_CHANGED,this.onPostBlendStepperChange);
         }
         this.IsColorOption = param1.bIsColorOption === true;
         var _loc2_:* = param1.arrayIndex < param1.sliderDataA.length;
         if(_loc2_)
         {
            if(this.IsColorOption)
            {
               this.Slider_mc.maxValue = param1.sliderDataA[param1.arrayIndex].uCount - 1;
               this.Slider_mc.value = param1.sliderDataA[param1.arrayIndex].uInitialValue;
               _loc3_ = Number(param1.sliderDataA[param1.arrayIndex].uCount);
               this.JumpAmount = (this.Slider_mc.maxValue - this.Slider_mc.minValue) / _loc3_;
               GlobalFunc.SetText(this.SliderText_mc.textField,"$COLOR",true);
            }
            else
            {
               this.Slider_mc.maxValue = INTENSITY_SCALAR;
               this.Slider_mc.value = param1.sliderDataA[param1.arrayIndex].fIntensity * INTENSITY_SCALAR;
               this.JumpAmount = (this.Slider_mc.maxValue - this.Slider_mc.minValue) * FacePage.SLIDER_KEY_MOVEMENT_PERCENT;
               GlobalFunc.SetText(this.SliderText_mc.textField,"$INTENSITY",true);
            }
            this.sCallback = param1.sliderDataA[param1.arrayIndex].sCallbackName;
            this.strCustimizationDataName = param1.sliderDataA[param1.arrayIndex].CustimizationName;
            this.uSubType = param1.arrayIndex;
            this.Slider_mc.visible = true;
         }
         else
         {
            this.Slider_mc.visible = false;
         }
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         this.Slider_mc.valueJump(this.MOUSE_WHEEL_VALUE_CHANGE * (param1.delta < 0 ? -1 : 1));
      }
      
      public function onValueChanged() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
         if(this.IsColorOption)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(this.sCallback,{
               "strCustimizationCategory":this.strCustimizationDataName,
               "fSliderValue":this.Slider_mc.value,
               "uSubTypeIndex":this.uSubType
            }));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(this.sCallback,{
               "strCustimizationCategory":this.strCustimizationDataName,
               "fSliderValue":this.sliderValue
            }));
         }
         CharGenMenu.characterDirty = true;
      }
      
      public function get sliderValue() : Number
      {
         return this.IsColorOption ? this.Slider_mc.value : this.Slider_mc.value / 100;
      }
      
      public function set sliderValue(param1:Number) : *
      {
         this.Slider_mc.value = param1;
      }
      
      public function get sliderID() : uint
      {
         return this.SliderID;
      }
      
      override public function onRollover() : void
      {
         FacePage.refining = true;
         this.Slider_mc.addEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
         super.onRollover();
      }
      
      override public function onRollout() : void
      {
         FacePage.refining = false;
         this.Slider_mc.removeEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
         super.onRollout();
      }
      
      public function onPostBlendStepperChange(param1:CustomEvent) : *
      {
         if(param1.params.strDataName == this.strCustimizationDataName && this.Data != null && param1.params.iIndex >= 0 && param1.params.iIndex < this.Data.sliderDataA.length)
         {
            this.uSubType = param1.params.iIndex;
            if(this.IsColorOption)
            {
               this.sliderValue = this.Data.sliderDataA[this.uSubType].uInitialValue;
            }
            else
            {
               this.sliderValue = this.Data.sliderDataA[this.uSubType].fIntensity * INTENSITY_SCALAR;
            }
         }
      }
      
      public function onLeft() : *
      {
         var _loc1_:Number = this.Slider_mc.value;
         if(_loc1_ > this.Slider_mc.minValue)
         {
            _loc1_ -= this.JumpAmount;
            if(_loc1_ < this.Slider_mc.minValue)
            {
               _loc1_ = this.Slider_mc.minValue;
            }
         }
         this.sliderValue = _loc1_;
      }
      
      public function onRight() : *
      {
         var _loc1_:Number = this.Slider_mc.value;
         if(_loc1_ < this.Slider_mc.maxValue)
         {
            _loc1_ += this.JumpAmount;
            if(_loc1_ > this.Slider_mc.maxValue)
            {
               _loc1_ = this.Slider_mc.maxValue;
            }
         }
         this.sliderValue = _loc1_;
      }
   }
}
