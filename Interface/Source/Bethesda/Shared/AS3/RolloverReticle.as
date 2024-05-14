package Shared.AS3
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.events.Event;
   
   public class RolloverReticle
   {
       
      
      private var ReticleLineShape:Shape;
      
      private var ReticleLineShadow:Shape;
      
      private const LINE_REVEAL_FRAMES:Number = 1;
      
      private var LineAnimFrameCount:uint = 1;
      
      private var UpdatingLineAnim:Boolean;
      
      private var _AnchorX:Number;
      
      private var _AnchorY:Number;
      
      private var ReticleX:Number;
      
      private var ReticleY:Number;
      
      private var ReticleRadius:Number;
      
      private var ParentClip:DisplayObjectContainer = null;
      
      public function RolloverReticle(param1:DisplayObjectContainer)
      {
         this.ReticleLineShape = new Shape();
         this.ReticleLineShadow = new Shape();
         super();
         param1.addChildAt(this.ReticleLineShape,0);
         param1.addChildAt(this.ReticleLineShadow,0);
         this.ParentClip = param1;
      }
      
      public function get AnchorX() : Number
      {
         return this._AnchorX;
      }
      
      public function get AnchorY() : Number
      {
         return this._AnchorY;
      }
      
      private function UpdateReticleLine() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc1_ = this.ReticleX - this.AnchorX;
         _loc2_ = this.ReticleY - this.AnchorY;
         _loc3_ = Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_);
         _loc1_ /= _loc3_;
         _loc2_ /= _loc3_;
         _loc3_ -= this.ReticleRadius;
         var _loc4_:Number = _loc3_ * _loc1_ + this.AnchorX;
         var _loc5_:Number = _loc3_ * _loc2_ + this.AnchorY;
         this.ReticleLineShape.graphics.clear();
         this.ReticleLineShape.graphics.lineStyle(1,16777215,1);
         this.ReticleLineShape.graphics.moveTo(_loc4_,_loc5_);
         this.ReticleLineShape.graphics.lineTo(_loc4_ - _loc1_ * _loc3_ * this.LineAnimFrameCount / this.LINE_REVEAL_FRAMES,_loc5_ - _loc2_ * _loc3_ * this.LineAnimFrameCount / this.LINE_REVEAL_FRAMES);
         this.ReticleLineShape.graphics.endFill();
         this.ReticleLineShadow.graphics.clear();
         this.ReticleLineShadow.graphics.lineStyle(1,0,1);
         this.ReticleLineShadow.graphics.moveTo(_loc4_ + 1,_loc5_ + 1);
         this.ReticleLineShadow.graphics.lineTo(_loc4_ - _loc1_ * _loc3_ * this.LineAnimFrameCount / this.LINE_REVEAL_FRAMES + 1,_loc5_ - _loc2_ * _loc3_ * this.LineAnimFrameCount / this.LINE_REVEAL_FRAMES + 1);
         this.ReticleLineShadow.graphics.endFill();
      }
      
      public function SetAnchor(param1:Number, param2:Number) : *
      {
         this._AnchorX = param1;
         this._AnchorY = param2;
      }
      
      public function SetReticleRadius(param1:Number) : *
      {
         this.ReticleRadius = param1;
      }
      
      public function SetReticleLocation(param1:Number, param2:Number) : *
      {
         this.ReticleX = param1;
         this.ReticleY = param2;
         this.UpdateReticleLine();
      }
      
      public function BeginUpdatingLineAnim() : *
      {
         if(this.UpdatingLineAnim)
         {
            this.ParentClip.removeEventListener(Event.ENTER_FRAME,this.UpdateLineAnimationFrameCount);
         }
         this.LineAnimFrameCount = 0;
         this.ParentClip.addEventListener(Event.ENTER_FRAME,this.UpdateLineAnimationFrameCount);
         this.UpdatingLineAnim = true;
      }
      
      public function EndUpdatingLineAnim() : *
      {
         if(this.UpdatingLineAnim)
         {
            this.ParentClip.removeEventListener(Event.ENTER_FRAME,this.UpdateLineAnimationFrameCount);
         }
         this.UpdatingLineAnim = false;
      }
      
      public function Clear() : *
      {
         this.ReticleLineShape.graphics.clear();
         this.ReticleLineShadow.graphics.clear();
         this.EndUpdatingLineAnim();
      }
      
      private function UpdateLineAnimationFrameCount() : *
      {
         if(this.LineAnimFrameCount == this.LINE_REVEAL_FRAMES)
         {
            this.EndUpdatingLineAnim();
         }
         else
         {
            ++this.LineAnimFrameCount;
         }
         this.UpdateReticleLine();
      }
   }
}
