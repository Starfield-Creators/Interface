package
{
   import Shared.AS3.BSSlider;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class QuantitySection extends MovieClip
   {
      
      public static const QUANTITY_CHANGED:String = "QuantitySection_QuantityChanged";
       
      
      public var Slider_mc:BSSlider;
      
      public var CurrentQuantity_tf:TextField;
      
      public var MaxQuantity_tf:TextField;
      
      public function QuantitySection()
      {
         super();
         this.Slider_mc.minValue = 1;
         addEventListener(BSSlider.VALUE_CHANGED,this.onValueChange);
      }
      
      public function get quantity() : int
      {
         return this.Slider_mc.value;
      }
      
      public function set quantity(param1:int) : void
      {
         this.Slider_mc.value = param1;
      }
      
      public function set minQuantity(param1:uint) : void
      {
         this.Slider_mc.minValue = param1;
      }
      
      private function set maxQuantity(param1:uint) : void
      {
         this.Slider_mc.maxValue = param1;
         GlobalFunc.SetText(this.MaxQuantity_tf,param1.toString());
      }
      
      public function PopulateSection(param1:uint) : void
      {
         this.maxQuantity = param1;
         GlobalFunc.SetText(this.CurrentQuantity_tf,"$$QUANTITY :" + this.quantity);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.Slider_mc.ProcessUserEvent(param1,param2);
      }
      
      private function onValueChange(param1:Event) : void
      {
         dispatchEvent(new Event(QUANTITY_CHANGED,true,true));
         GlobalFunc.SetText(this.CurrentQuantity_tf,"$$QUANTITY :" + this.quantity);
         GlobalFunc.PlayMenuSound("UIMenuQuantity");
      }
   }
}
