package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSSlider;
   import Shared.AS3.Data.BSUIDataManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ColorHSB extends BSDisplayObject
   {
      
      private static const SLIDER_MIN_VALUE:Number = 0;
      
      private static const SLIDER_MAX_VALUE:Number = 100;
      
      private static const ShipEditor_OnColorSliderMouseInput:String = "ShipEditor_OnColorSliderMouseInput";
      
      private static const NORMAL:* = "Normal";
      
      private static const ACTIVE:* = "Active";
       
      
      public var Label_mc:MovieClip;
      
      public var Slider_mc:ColorSlider;
      
      private var Type:uint;
      
      public function ColorHSB()
      {
         this.Type = ColorPicker.CONTROL_COUNT;
         super();
         this.Slider_mc.minValue = SLIDER_MIN_VALUE;
         this.Slider_mc.maxValue = SLIDER_MAX_VALUE;
      }
      
      public function get labelText() : TextField
      {
         return this.Label_mc.text_tf;
      }
      
      public function get controlType() : uint
      {
         return this.Type;
      }
      
      public function set controlType(param1:uint) : *
      {
         this.Type = param1;
      }
      
      override public function onAddedToStage() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollover);
         addEventListener(BSSlider.INPUT_CHANGED,this.onInputChange);
      }
      
      public function SetActive(param1:Boolean) : *
      {
         gotoAndStop(param1 ? ACTIVE : NORMAL);
         this.Slider_mc.SetActive(param1);
      }
      
      public function SetValue(param1:Number) : *
      {
         this.Slider_mc.value = param1 * SLIDER_MAX_VALUE;
      }
      
      private function GetValue() : Number
      {
         return this.Slider_mc.value / SLIDER_MAX_VALUE;
      }
      
      public function SetGradientColors(param1:Array) : *
      {
         this.Slider_mc.SetGradientColors(param1);
      }
      
      private function onMouseRollover() : void
      {
         BSUIDataManager.dispatchCustomEvent(ColorPicker.ShipEditor_OnColorPickerControlChanged,{"control":this.Type});
      }
      
      private function onInputChange(param1:Event) : void
      {
         var _loc2_:Number = this.GetValue();
         BSUIDataManager.dispatchCustomEvent(ShipEditor_OnColorSliderMouseInput,{"sliderValue":_loc2_});
      }
   }
}
