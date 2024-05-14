package fl.motion
{
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Animator extends AnimatorBase
   {
       
      
      public function Animator(param1:XML = null, param2:DisplayObject = null)
      {
         this.motion = new Motion(param1);
         super(param1,param2);
      }
      
      public static function fromXMLString(param1:String, param2:DisplayObject = null) : Animator
      {
         return new Animator(new XML(param1),param2);
      }
      
      public static function matricesEqual(param1:Matrix, param2:Matrix) : Boolean
      {
         return param1.a == param2.a && param1.b == param2.b && param1.c == param2.c && param1.d == param2.d && param1.tx == param2.tx && param1.ty == param2.ty;
      }
      
      override public function set motion(param1:MotionBase) : void
      {
         super.motion = param1;
         var _loc2_:Motion = param1 as Motion;
         if(_loc2_ && _loc2_.source && Boolean(_loc2_.source.transformationPoint))
         {
            this.transformationPoint = _loc2_.source.transformationPoint.clone();
         }
      }
      
      override protected function setTargetState() : void
      {
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
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Matrix = null;
         var _loc14_:Boolean = false;
         var _loc15_:Point = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Matrix = null;
         var _loc22_:Number = NaN;
         var _loc4_:Motion;
         if(!(_loc4_ = param2 as Motion))
         {
            return false;
         }
         var _loc5_:Matrix;
         if(_loc5_ = _loc4_.getMatrix(param1))
         {
            if(!motionArray || !_lastMatrixApplied || !matricesEqual(_loc5_,_lastMatrixApplied))
            {
               this._target.transform.matrix = _loc5_;
               _lastMatrixApplied = _loc5_;
            }
         }
         else
         {
            if(Boolean(motionArray) && _loc4_ != _lastMotionUsed)
            {
               this.transformationPoint = !!_loc4_.motion_internal::transformationPoint ? _loc4_.motion_internal::transformationPoint : new Point(0.5,0.5);
               this.initTransformPointInternal(_loc4_.motion_internal::initialMatrix);
               _lastMotionUsed = _loc4_;
            }
            _loc6_ = _loc4_.getValue(param1,Tweenables.X);
            _loc7_ = _loc4_.getValue(param1,Tweenables.Y);
            _loc8_ = new Point(_loc6_,_loc7_);
            if(this.positionMatrix)
            {
               _loc8_ = this.positionMatrix.transformPoint(_loc8_);
            }
            _loc8_.x += this.targetState.x;
            _loc8_.y += this.targetState.y;
            _loc9_ = _loc4_.getValue(param1,Tweenables.SCALE_X) * this.targetState.scaleX;
            _loc10_ = _loc4_.getValue(param1,Tweenables.SCALE_Y) * this.targetState.scaleY;
            _loc11_ = 0;
            _loc12_ = 0;
            if(this.orientToPath)
            {
               _loc18_ = _loc4_.getValue(param1 + 1,Tweenables.X);
               _loc19_ = _loc4_.getValue(param1 + 1,Tweenables.Y);
               _loc20_ = Math.atan2(_loc19_ - _loc7_,_loc18_ - _loc6_) * (180 / Math.PI);
               if(!isNaN(_loc20_))
               {
                  _loc11_ = _loc20_ + this.targetState.skewX;
                  _loc12_ = _loc20_ + this.targetState.skewY;
               }
            }
            else
            {
               _loc11_ = _loc4_.getValue(param1,Tweenables.SKEW_X) + this.targetState.skewX;
               _loc12_ = _loc4_.getValue(param1,Tweenables.SKEW_Y) + this.targetState.skewY;
            }
            _loc13_ = new Matrix(_loc9_ * Math.cos(_loc12_ * (Math.PI / 180)),_loc9_ * Math.sin(_loc12_ * (Math.PI / 180)),-_loc10_ * Math.sin(_loc11_ * (Math.PI / 180)),_loc10_ * Math.cos(_loc11_ * (Math.PI / 180)),0,0);
            _loc14_ = false;
            if(_loc4_.useRotationConcat(param1))
            {
               _loc21_ = new Matrix();
               _loc22_ = _loc4_.getValue(param1,Tweenables.ROTATION_CONCAT);
               _loc21_.rotate(_loc22_);
               _loc13_.concat(_loc21_);
               _loc14_ = true;
            }
            _loc13_.tx = _loc8_.x;
            _loc13_.ty = _loc8_.y;
            _loc15_ = _loc13_.transformPoint(this.targetState.transformPointInternal);
            _loc16_ = _loc13_.tx - _loc15_.x;
            _loc17_ = _loc13_.ty - _loc15_.y;
            _loc13_.tx += _loc16_;
            _loc13_.ty += _loc17_;
            if(!motionArray || !_lastMatrixApplied || !matricesEqual(_loc13_,_lastMatrixApplied))
            {
               if(!_loc14_)
               {
                  this._target.rotation = _loc12_;
               }
               this._target.transform.matrix = _loc13_;
               if(_loc14_ && this._target.scaleX == 0 && this._target.scaleY == 0)
               {
                  this._target.scaleX = _loc9_;
                  this._target.scaleY = _loc10_;
               }
               _lastMatrixApplied = _loc13_;
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
