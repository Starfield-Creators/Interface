package Shared
{
   import aze.motion.EazeTween;
   import aze.motion.easing.Quadratic;
   
   public final class EazeCommon
   {
       
      
      private var CurrentTween:EazeTween;
      
      public function EazeCommon(param1:EazeTween)
      {
         super();
         this.CurrentTween = param1;
      }
      
      public function get eaze() : EazeTween
      {
         return this.CurrentTween;
      }
      
      public function Delay(param1:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.delay(param1);
         return this;
      }
      
      public function Chain(param1:Object) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.chain(param1);
         return this;
      }
      
      public function Blink(param1:Number = 1, param2:Number = 0.001, param3:Number = 0.001) : EazeCommon
      {
         return this.Show(param1).Delay(param2).Hide().Delay(param3).Show(param1);
      }
      
      public function Show(param1:Number = 1) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.apply({
            "alpha":param1,
            "visible":true
         });
         return this;
      }
      
      public function Hide() : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.apply({
            "alpha":0,
            "visible":false
         });
         return this;
      }
      
      public function Flash(param1:Boolean = false) : EazeCommon
      {
         if(param1)
         {
            GlobalFunc.PlayMenuSound("UIMenuStarmapRolloverFlash");
         }
         return this.Blink().Blink();
      }
      
      public function PlaySound(param1:String) : EazeCommon
      {
         GlobalFunc.PlayMenuSound(param1);
         return this;
      }
      
      public function FadeOut(param1:Number, param2:Number = 0) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeOut).apply({
            "alpha":1,
            "visible":true
         }).to(param1,{"alpha":param2});
         return this.Hide();
      }
      
      public function FadeIn(param1:Number, param2:Number = 1) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeIn).apply({
            "alpha":0,
            "visible":true
         }).to(param1,{"alpha":param2});
         return this;
      }
      
      public function LerpTo(param1:Number, param2:Number, param3:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).to(param1,{
            "x":param2,
            "y":param3
         });
         return this;
      }
      
      public function ExpandClipWidthFromZero(param1:Number, param2:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).apply({"width":0}).to(param1,{"width":param2});
         return this;
      }
      
      public function ExpandClipHeightFromZero(param1:Number, param2:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).apply({"height":0}).to(param1,{"height":param2});
         return this;
      }
      
      public function ExpandClipFromZero(param1:Number, param2:Number, param3:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).apply({
            "width":0,
            "height":0
         }).to(param1,{
            "width":param2,
            "height":param3
         });
         return this;
      }
      
      public function ExpandClip(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).apply({
            "width":param2,
            "height":param3
         }).to(param1,{
            "width":param4,
            "height":param5
         });
         return this;
      }
      
      public function ExpandClipWidth(param1:Number, param2:Number, param3:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).apply({"width":param2}).to(param1,{"width":param3});
         return this;
      }
      
      public function ExpandClipHeight(param1:Number, param2:Number, param3:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).apply({"height":param2}).to(param1,{"height":param3});
         return this;
      }
      
      public function ContractClip(param1:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).to(param1,{
            "width":0,
            "height":0
         });
         return this;
      }
      
      public function ContractClipWidth(param1:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).to(param1,{"width":0});
         return this;
      }
      
      public function ContractClipHeight(param1:Number) : EazeCommon
      {
         this.CurrentTween = this.CurrentTween.easing(Quadratic.easeInOut).to(param1,{"height":0});
         return this;
      }
   }
}
