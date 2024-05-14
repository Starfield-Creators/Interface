package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSSlider;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class FacePartSliderListEntry extends BSContainerEntry
   {
       
      
      public var Slider_mc:BSSlider;
      
      public var SliderText_mc:MovieClip;
      
      private var MOUSE_WHEEL_VALUE_CHANGE:int = 15;
      
      private var SliderID:uint = 0;
      
      private var sEventName:String = "";
      
      private var bSuppressValueChangedUpdate:Boolean = false;
      
      public function FacePartSliderListEntry()
      {
         super();
         this.Slider_mc.minValue = 0;
         this.Slider_mc.maxValue = 200;
         this.Slider_mc.value = 100;
         this.Slider_mc.mouseWheelValueChange = this.MOUSE_WHEEL_VALUE_CHANGE;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function IsMouseDraggingSlider() : Boolean
      {
         return this.Slider_mc.dragging;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.bSuppressValueChangedUpdate = true;
         if(param1.ZeroToOne)
         {
            this.Slider_mc.value = param1.Value * 100;
            this.Slider_mc.maxValue = 100;
         }
         else
         {
            this.Slider_mc.value = param1.Value * 100 + 100;
            this.Slider_mc.maxValue = 200;
         }
         this.SliderID = param1.ID;
         GlobalFunc.SetText(this.SliderText_mc.textField,param1.UILocalizedName,true,true);
         this.bSuppressValueChangedUpdate = false;
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         this.Slider_mc.valueJump(this.MOUSE_WHEEL_VALUE_CHANGE * (param1.delta < 0 ? -1 : 1));
      }
      
      public function onValueChanged() : *
      {
         if(!this.bSuppressValueChangedUpdate)
         {
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
            BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetSlider",{
               "uSliderIndex":this.sliderID,
               "fSliderValue":this.sliderValue
            }));
            CharGenMenu.characterDirty = true;
         }
      }
      
      public function get sliderValue() : Number
      {
         return (this.Slider_mc.value - 100) / 100;
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
         this.Slider_mc.addEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
         this.Slider_mc.sliderEnabled = true;
         super.onRollover();
      }
      
      override public function onRollout() : void
      {
         this.Slider_mc.removeEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
         this.Slider_mc.sliderEnabled = false;
         super.onRollout();
      }
      
      public function onLeft() : *
      {
         var _loc1_:Number = this.Slider_mc.value;
         if(_loc1_ > this.Slider_mc.minValue)
         {
            _loc1_ -= (this.Slider_mc.maxValue - this.Slider_mc.minValue) * FacePage.SLIDER_KEY_MOVEMENT_PERCENT;
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
            _loc1_ += (this.Slider_mc.maxValue - this.Slider_mc.minValue) * FacePage.SLIDER_KEY_MOVEMENT_PERCENT;
            if(_loc1_ > this.Slider_mc.maxValue)
            {
               _loc1_ = this.Slider_mc.maxValue;
            }
         }
         this.sliderValue = _loc1_;
      }
   }
}
