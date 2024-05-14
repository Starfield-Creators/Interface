package
{
   import Shared.AS3.BSSlider;
   import flash.display.GradientType;
   import flash.display.InterpolationMethod;
   import flash.display.MovieClip;
   import flash.display.SpreadMethod;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class ColorSlider extends BSSlider
   {
      
      private static const SLIDER_COLOR_DEFAULT:uint = 12040119;
      
      private static const SLIDER_COLOR_ACTIVE:uint = 2308933;
       
      
      public var Colors_mc:MovieClip;
      
      public var Outline_mc:MovieClip;
      
      public function ColorSlider()
      {
         super();
      }
      
      private function get colorBody() : MovieClip
      {
         return this.Colors_mc.Body_mc;
      }
      
      private function get sliderArrow() : MovieClip
      {
         return Fill_mc.ArrowBody_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.colorBody.visible = false;
      }
      
      public function SetActive(param1:Boolean) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = param1 ? SLIDER_COLOR_ACTIVE : SLIDER_COLOR_DEFAULT;
         this.Outline_mc.transform.colorTransform = _loc2_;
         this.sliderArrow.transform.colorTransform = _loc2_;
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
         (_loc6_ = new Matrix()).createGradientBox(this.colorBody.width,this.colorBody.height);
         var _loc7_:String = GradientType.LINEAR;
         var _loc8_:String = SpreadMethod.PAD;
         var _loc9_:* = InterpolationMethod.RGB;
         this.Colors_mc.graphics.clear();
         this.Colors_mc.graphics.beginGradientFill(_loc7_,param1,_loc2_,_loc3_,_loc6_,_loc8_,_loc9_);
         this.Colors_mc.graphics.drawRect(0,0,this.colorBody.width,this.colorBody.height);
         this.Colors_mc.graphics.endFill();
      }
   }
}
