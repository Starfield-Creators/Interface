package fl.motion
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class MatrixTransformer
   {
       
      
      public function MatrixTransformer()
      {
         super();
      }
      
      public static function getScaleX(param1:Matrix) : Number
      {
         return Math.sqrt(param1.a * param1.a + param1.b * param1.b);
      }
      
      public static function setScaleX(param1:Matrix, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = getScaleX(param1);
         if(_loc3_)
         {
            _loc4_ = param2 / _loc3_;
            param1.a *= _loc4_;
            param1.b *= _loc4_;
         }
         else
         {
            _loc5_ = getSkewYRadians(param1);
            param1.a = Math.cos(_loc5_) * param2;
            param1.b = Math.sin(_loc5_) * param2;
         }
      }
      
      public static function getScaleY(param1:Matrix) : Number
      {
         return Math.sqrt(param1.c * param1.c + param1.d * param1.d);
      }
      
      public static function setScaleY(param1:Matrix, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = getScaleY(param1);
         if(_loc3_)
         {
            _loc4_ = param2 / _loc3_;
            param1.c *= _loc4_;
            param1.d *= _loc4_;
         }
         else
         {
            _loc5_ = getSkewXRadians(param1);
            param1.c = -Math.sin(_loc5_) * param2;
            param1.d = Math.cos(_loc5_) * param2;
         }
      }
      
      public static function getSkewXRadians(param1:Matrix) : Number
      {
         return Math.atan2(-param1.c,param1.d);
      }
      
      public static function setSkewXRadians(param1:Matrix, param2:Number) : void
      {
         var _loc3_:Number = getScaleY(param1);
         param1.c = -_loc3_ * Math.sin(param2);
         param1.d = _loc3_ * Math.cos(param2);
      }
      
      public static function getSkewYRadians(param1:Matrix) : Number
      {
         return Math.atan2(param1.b,param1.a);
      }
      
      public static function setSkewYRadians(param1:Matrix, param2:Number) : void
      {
         var _loc3_:Number = getScaleX(param1);
         param1.a = _loc3_ * Math.cos(param2);
         param1.b = _loc3_ * Math.sin(param2);
      }
      
      public static function getSkewX(param1:Matrix) : Number
      {
         return Math.atan2(-param1.c,param1.d) * (180 / Math.PI);
      }
      
      public static function setSkewX(param1:Matrix, param2:Number) : void
      {
         setSkewXRadians(param1,param2 * (Math.PI / 180));
      }
      
      public static function getSkewY(param1:Matrix) : Number
      {
         return Math.atan2(param1.b,param1.a) * (180 / Math.PI);
      }
      
      public static function setSkewY(param1:Matrix, param2:Number) : void
      {
         setSkewYRadians(param1,param2 * (Math.PI / 180));
      }
      
      public static function getRotationRadians(param1:Matrix) : Number
      {
         return getSkewYRadians(param1);
      }
      
      public static function setRotationRadians(param1:Matrix, param2:Number) : void
      {
         var _loc3_:Number = getRotationRadians(param1);
         var _loc4_:Number = getSkewXRadians(param1);
         setSkewXRadians(param1,_loc4_ + param2 - _loc3_);
         setSkewYRadians(param1,param2);
      }
      
      public static function getRotation(param1:Matrix) : Number
      {
         return getRotationRadians(param1) * (180 / Math.PI);
      }
      
      public static function setRotation(param1:Matrix, param2:Number) : void
      {
         setRotationRadians(param1,param2 * (Math.PI / 180));
      }
      
      public static function rotateAroundInternalPoint(param1:Matrix, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Point = new Point(param2,param3);
         _loc5_ = param1.transformPoint(_loc5_);
         param1.tx -= _loc5_.x;
         param1.ty -= _loc5_.y;
         param1.rotate(param4 * (Math.PI / 180));
         param1.tx += _loc5_.x;
         param1.ty += _loc5_.y;
      }
      
      public static function rotateAroundExternalPoint(param1:Matrix, param2:Number, param3:Number, param4:Number) : void
      {
         param1.tx -= param2;
         param1.ty -= param3;
         param1.rotate(param4 * (Math.PI / 180));
         param1.tx += param2;
         param1.ty += param3;
      }
      
      public static function matchInternalPointWithExternal(param1:Matrix, param2:Point, param3:Point) : void
      {
         var _loc4_:Point = param1.transformPoint(param2);
         var _loc5_:Number = param3.x - _loc4_.x;
         var _loc6_:Number = param3.y - _loc4_.y;
         param1.tx += _loc5_;
         param1.ty += _loc6_;
      }
   }
}
