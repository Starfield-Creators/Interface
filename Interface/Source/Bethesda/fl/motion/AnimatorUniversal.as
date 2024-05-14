package fl.motion
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class AnimatorUniversal extends Animator3D
   {
       
      
      public function AnimatorUniversal()
      {
         super(null,null);
         this._isAnimator3D = false;
      }
      
      override protected function setTargetState() : void
      {
         super.setTargetState();
         this.targetState.scaleX = this._target.scaleX;
         this.targetState.scaleY = this._target.scaleY;
         this.targetState.skewX = MatrixTransformer.getSkewX(this._target.transform.matrix);
         this.targetState.skewY = MatrixTransformer.getSkewY(this._target.transform.matrix);
         this.targetState.bounds = this._target.getBounds(this._target);
         this.initTransformPointInternal(this._target.transform.matrix);
         this.targetState.z = 0;
         this.targetState.rotationX = this.targetState.rotationY = 0;
      }
      
      private function initTransformPointInternal(param1:Matrix) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc2_:Object = this.targetState.bounds;
         if(this.transformationPoint)
         {
            _loc3_ = this.transformationPoint.x * _loc2_.width + _loc2_.left;
            _loc4_ = this.transformationPoint.y * _loc2_.height + _loc2_.top;
            this.targetState.transformPointInternal = new Point(_loc3_,_loc4_);
            _loc5_ = param1.transformPoint(this.targetState.transformPointInternal);
            this.targetState.x = _loc5_.x;
            this.targetState.y = _loc5_.y;
         }
         else
         {
            this.targetState.transformPointInternal = new Point(0,0);
            this.targetState.x = this._target.x;
            this.targetState.y = this._target.y;
         }
      }
      
      override protected function setTimeClassic(param1:int, param2:MotionBase, param3:KeyframeBase) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Matrix = null;
         var _loc13_:Boolean = false;
         var _loc14_:Point = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Matrix = null;
         var _loc21_:Number = NaN;
         if(param2.is3D)
         {
            _lastMatrixApplied = null;
            return setTime3D(param1,param2);
         }
         var _loc4_:Matrix;
         if(_loc4_ = param2.getMatrix(param1))
         {
            if(!motionArray || !_lastMatrixApplied || !Animator.matricesEqual(_loc4_,_lastMatrixApplied))
            {
               this._target.transform.matrix = _loc4_;
               _lastMatrixApplied = _loc4_;
            }
         }
         else
         {
            if(Boolean(motionArray) && param2 != _lastMotionUsed)
            {
               this.transformationPoint = !!param2.motion_internal::transformationPoint ? param2.motion_internal::transformationPoint : new Point(0.5,0.5);
               this.initTransformPointInternal(param2.motion_internal::initialMatrix);
               _lastMotionUsed = param2;
            }
            _loc5_ = param2.getValue(param1,Tweenables.X);
            _loc6_ = param2.getValue(param1,Tweenables.Y);
            _loc7_ = new Point(_loc5_,_loc6_);
            if(this.positionMatrix)
            {
               _loc7_ = this.positionMatrix.transformPoint(_loc7_);
            }
            _loc7_.x += this.targetState.x;
            _loc7_.y += this.targetState.y;
            _loc8_ = param2.getValue(param1,Tweenables.SCALE_X) * this.targetState.scaleX;
            _loc9_ = param2.getValue(param1,Tweenables.SCALE_Y) * this.targetState.scaleY;
            _loc10_ = 0;
            _loc11_ = 0;
            if(this.orientToPath)
            {
               _loc17_ = param2.getValue(param1 + 1,Tweenables.X);
               _loc18_ = param2.getValue(param1 + 1,Tweenables.Y);
               _loc19_ = Math.atan2(_loc18_ - _loc6_,_loc17_ - _loc5_) * (180 / Math.PI);
               if(!isNaN(_loc19_))
               {
                  _loc10_ = _loc19_ + this.targetState.skewX;
                  _loc11_ = _loc19_ + this.targetState.skewY;
               }
            }
            else
            {
               _loc10_ = param2.getValue(param1,Tweenables.SKEW_X) + this.targetState.skewX;
               _loc11_ = param2.getValue(param1,Tweenables.SKEW_Y) + this.targetState.skewY;
            }
            _loc12_ = new Matrix(_loc8_ * Math.cos(_loc11_ * (Math.PI / 180)),_loc8_ * Math.sin(_loc11_ * (Math.PI / 180)),-_loc9_ * Math.sin(_loc10_ * (Math.PI / 180)),_loc9_ * Math.cos(_loc10_ * (Math.PI / 180)),0,0);
            _loc13_ = false;
            if(param2.useRotationConcat(param1))
            {
               _loc20_ = new Matrix();
               _loc21_ = param2.getValue(param1,Tweenables.ROTATION_CONCAT);
               _loc20_.rotate(_loc21_);
               _loc12_.concat(_loc20_);
               _loc13_ = true;
            }
            _loc12_.tx = _loc7_.x;
            _loc12_.ty = _loc7_.y;
            _loc14_ = _loc12_.transformPoint(this.targetState.transformPointInternal);
            _loc15_ = _loc12_.tx - _loc14_.x;
            _loc16_ = _loc12_.ty - _loc14_.y;
            _loc12_.tx += _loc15_;
            _loc12_.ty += _loc16_;
            if(!motionArray || !_lastMatrixApplied || !Animator.matricesEqual(_loc12_,_lastMatrixApplied))
            {
               if(!_loc13_)
               {
                  this._target.rotation = _loc11_;
               }
               this._target.transform.matrix = _loc12_;
               if(_loc13_ && this._target.scaleX == 0 && this._target.scaleY == 0)
               {
                  this._target.scaleX = _loc8_;
                  this._target.scaleY = _loc9_;
               }
               _lastMatrixApplied = _loc12_;
            }
         }
         if(_lastCacheAsBitmapApplied != param3.cacheAsBitmap || !_cacheAsBitmapHasBeenApplied)
         {
            this._target.cacheAsBitmap = param3.cacheAsBitmap;
            _cacheAsBitmapHasBeenApplied = true;
            _lastCacheAsBitmapApplied = param3.cacheAsBitmap;
         }
         return true;
      }
   }
}
