package Shared.AS3
{
   import Components.Meter;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class BSSlider extends BSDisplayObject
   {
      
      public static const VALUE_CHANGED:String = "Slider::ValueChanged";
      
      public static const INPUT_CHANGED:String = "Slider::InputChanged";
      
      private static const BUMPER_PERCENT:Number = 0.05;
      
      private static const TRIGGER_PERCENT:Number = 0.2;
       
      
      public var SliderBackground_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      private var _iMaxValue:uint = 1;
      
      private var _iMinValue:uint = 0;
      
      private var _iValue:Number = 0;
      
      private var _bSliderEnabled:Boolean = true;
      
      private var _mouseWheelValueChange:Number = 1;
      
      private var _Meter:Meter;
      
      private var _SliderBoundBox:Rectangle;
      
      private var _bIsDragging:Boolean = false;
      
      private var _bDisableRounding:Boolean = false;
      
      public function BSSlider()
      {
         super();
         this._Meter = new Meter(this);
         this._SliderBoundBox = this.SliderBackground_mc.getBounds(this);
      }
      
      public function set disableRounding(param1:Boolean) : *
      {
         this._bDisableRounding = param1;
      }
      
      public function get dragging() : Boolean
      {
         return this._bIsDragging;
      }
      
      public function get minValue() : uint
      {
         return this._iMinValue;
      }
      
      public function set minValue(param1:uint) : *
      {
         this._iMinValue = Math.min(param1,this._iMaxValue);
         if(this.value < this._iMinValue)
         {
            this.value = this._iMinValue;
         }
         SetIsDirty();
      }
      
      public function get value() : Number
      {
         return this._iValue;
      }
      
      public function set value(param1:Number) : *
      {
         var _loc2_:* = undefined;
         if(param1 >= 0)
         {
            _loc2_ = Math.min(Math.max(param1,this.minValue),this.maxValue);
            if(_loc2_ != this._iValue)
            {
               this._iValue = _loc2_;
               dispatchEvent(new CustomEvent(VALUE_CHANGED,this.value,true,true));
               SetIsDirty();
            }
         }
      }
      
      public function get sliderEnabled() : Boolean
      {
         return this._bSliderEnabled;
      }
      
      public function set sliderEnabled(param1:Boolean) : *
      {
         if(param1 != this._bSliderEnabled)
         {
            if(!param1)
            {
               if(this._bIsDragging)
               {
                  stage.removeEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag);
                  stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onValueDrag);
                  this._bIsDragging = false;
               }
            }
            this._bSliderEnabled = param1;
         }
      }
      
      public function valueJump(param1:Number) : *
      {
         if(param1 < 0 && -param1 > this.value)
         {
            this.value = this.minValue;
         }
         else
         {
            this.value += param1;
         }
      }
      
      public function get maxValue() : uint
      {
         return this._iMaxValue;
      }
      
      public function set maxValue(param1:uint) : *
      {
         this._iMaxValue = Math.max(param1,1);
         if(this.value > this._iMaxValue)
         {
            this.value = this._iMaxValue;
         }
         SetIsDirty();
      }
      
      public function get mouseWheelValueChange() : Number
      {
         return this._mouseWheelValueChange;
      }
      
      public function set mouseWheelValueChange(param1:Number) : *
      {
         this._mouseWheelValueChange = param1;
      }
      
      private function get valueRange() : uint
      {
         return this.maxValue - this.minValue;
      }
      
      private function get controllerBumperJumpSize() : uint
      {
         return Math.max(Math.round(BUMPER_PERCENT * this.valueRange),1);
      }
      
      private function get controllerTriggerJumpSize() : uint
      {
         return Math.max(Math.round(TRIGGER_PERCENT * this.valueRange),1);
      }
      
      private function UpdateFromMousePos() : *
      {
         var _loc1_:Number = NaN;
         if(this.sliderEnabled)
         {
            _loc1_ = (this.mouseX - this._SliderBoundBox.left) / this._SliderBoundBox.width;
            if(_loc1_ > 0)
            {
               if(this._bDisableRounding)
               {
                  this.value = _loc1_ * this.valueRange + this.minValue;
               }
               else
               {
                  this.value = Math.round(_loc1_ * this.valueRange) + this.minValue;
               }
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
            else
            {
               this.value = this.minValue;
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
         }
      }
      
      private function onBeginDrag(param1:MouseEvent) : *
      {
         if(this.sliderEnabled)
         {
            this._bIsDragging = true;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onValueDrag);
         }
      }
      
      private function onReleaseDrag(param1:MouseEvent) : *
      {
         if(this._bIsDragging)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onValueDrag);
            this.UpdateFromMousePos();
            this._bIsDragging = false;
         }
      }
      
      private function onValueDrag(param1:MouseEvent) : *
      {
         if(this._bIsDragging)
         {
            this.UpdateFromMousePos();
         }
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         if(this.sliderEnabled)
         {
            this.UpdateFromMousePos();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(this.sliderEnabled && param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.DOWN)
         {
            this.valueJump(-1);
            param1.stopPropagation();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
         else if(this.sliderEnabled && param1.keyCode == Keyboard.RIGHT || param1.keyCode == Keyboard.UP)
         {
            this.valueJump(1);
            param1.stopPropagation();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
      }
      
      private function onMouseWheelHandler(param1:MouseEvent) : *
      {
         if(this.sliderEnabled)
         {
            if(param1.delta < 0)
            {
               this.valueJump(-1 * this._mouseWheelValueChange);
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
            else if(param1.delta > 0)
            {
               this.valueJump(this._mouseWheelValueChange);
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
            param1.stopPropagation();
         }
      }
      
      public function onArrowClickHandler(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = null;
         if(this.sliderEnabled)
         {
            _loc2_ = param1.target as MovieClip;
            if(param1.target == this.LeftArrow_mc)
            {
               this.valueJump(-this.controllerBumperJumpSize);
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
            else if(param1.target == this.RightArrow_mc)
            {
               this.valueJump(this.controllerBumperJumpSize);
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:* = false;
         if(this.sliderEnabled)
         {
            if(!param2)
            {
               if(param1 == "LShoulder")
               {
                  this.valueJump(-this.controllerBumperJumpSize);
                  dispatchEvent(new Event(INPUT_CHANGED,true,true));
                  _loc3_ = true;
               }
               else if(param1 == "RShoulder")
               {
                  this.valueJump(this.controllerBumperJumpSize);
                  dispatchEvent(new Event(INPUT_CHANGED,true,true));
                  _loc3_ = true;
               }
               else if(param1 == "LTrigger")
               {
                  this.valueJump(-this.controllerTriggerJumpSize);
                  dispatchEvent(new Event(INPUT_CHANGED,true,true));
                  _loc3_ = true;
               }
               else if(param1 == "RTrigger")
               {
                  this.valueJump(this.controllerTriggerJumpSize);
                  dispatchEvent(new Event(INPUT_CHANGED,true,true));
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler);
         if(this.LeftArrow_mc)
         {
            this.LeftArrow_mc.addEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
         }
         if(this.RightArrow_mc)
         {
            this.RightArrow_mc.addEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
         }
         this.SliderBackground_mc.addEventListener(MouseEvent.CLICK,this.onClick);
         this.SliderBackground_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onBeginDrag);
         this.Fill_mc.addEventListener(MouseEvent.CLICK,this.onClick);
         this.Fill_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onBeginDrag);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler);
         if(this.LeftArrow_mc)
         {
            this.LeftArrow_mc.removeEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
         }
         if(this.RightArrow_mc)
         {
            this.RightArrow_mc.removeEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
         }
         this.SliderBackground_mc.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.SliderBackground_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBeginDrag);
         this.Fill_mc.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.Fill_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBeginDrag);
      }
      
      override public function redrawDisplayObject() : void
      {
         super.redrawDisplayObject();
         var _loc1_:Number = 100 * (this.value - this.minValue) / this.valueRange;
         this._Meter.SetPercent(_loc1_);
      }
   }
}
