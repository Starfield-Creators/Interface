package Shared.AS3
{
   import Shared.AS3.Events.CustomEvent;
   import flash.display.GradientType;
   import flash.display.InterpolationMethod;
   import flash.display.MovieClip;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Matrix;
   
   public class BSColorSlider extends BSDisplayObject
   {
      
      public static const VALUE_CHANGED:String = "BSColorSlider_ValueChanged";
      
      public static const INPUT_CHANGED:String = "BSColorSlider_InputChanged";
       
      
      public var Slider_mc:BSSlider;
      
      public var Colors_mc:MovieClip;
      
      public function BSColorSlider()
      {
         super();
         addEventListener(BSSlider.INPUT_CHANGED,this.onInputChange);
         addEventListener(BSSlider.VALUE_CHANGED,this.onValueChange);
      }
      
      public function get value() : Number
      {
         return this.Slider_mc.value;
      }
      
      public function set value(param1:Number) : void
      {
         this.Slider_mc.value = param1;
      }
      
      public function set maxValue(param1:Number) : void
      {
         this.Slider_mc.maxValue = param1;
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         this.Slider_mc.onKeyDownHandler(param1);
      }
      
      public function SetGradientColors(param1:Array) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Number = 255 / param1.length;
         var _loc5_:int = 0;
         while(_loc5_ <= param1.length)
         {
            _loc2_.push(1);
            _loc3_.push(_loc4_ * _loc5_);
            _loc5_++;
         }
         var _loc6_:Matrix;
         (_loc6_ = new Matrix()).createGradientBox(this.Colors_mc.Border_mc.width,this.Colors_mc.Border_mc.height);
         var _loc7_:String = GradientType.LINEAR;
         var _loc8_:String = SpreadMethod.PAD;
         var _loc9_:* = InterpolationMethod.RGB;
         this.Colors_mc.graphics.clear();
         this.Colors_mc.graphics.beginGradientFill(_loc7_,param1,_loc2_,_loc3_,_loc6_,_loc8_,_loc9_);
         this.Colors_mc.graphics.drawRect(0,0,this.Colors_mc.Border_mc.width,this.Colors_mc.Border_mc.height);
         this.Colors_mc.graphics.endFill();
      }
      
      private function onInputChange(param1:Event) : void
      {
         dispatchEvent(new Event(INPUT_CHANGED,true,true));
      }
      
      private function onValueChange(param1:CustomEvent) : void
      {
         dispatchEvent(new CustomEvent(VALUE_CHANGED,this.value,true,true));
      }
   }
}
