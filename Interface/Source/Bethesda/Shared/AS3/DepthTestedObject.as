package Shared.AS3
{
   import flash.display.MovieClip;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   
   public class DepthTestedObject extends MovieClip
   {
      
      private static var FocalLength:Number = 100;
      
      private static var FocalNearZ:Number = FocalLength / 100;
      
      private static var FocalFarZ:Number = FocalLength * 100;
       
      
      public var baseScaleX:Number;
      
      public var baseScaleY:Number;
      
      public var baseScaleZ:Number;
      
      public function DepthTestedObject()
      {
         this.baseScaleX = scaleX;
         this.baseScaleY = scaleY;
         this.baseScaleZ = scaleZ;
         super();
      }
      
      public function SetZ(param1:Number) : void
      {
         var _loc2_:Number = param1 * 2 - 1;
         z = 2 * FocalFarZ * FocalNearZ / (FocalFarZ + FocalNearZ - _loc2_ * (FocalFarZ - FocalNearZ));
         z -= FocalLength;
         var _loc3_:Number = z / FocalLength;
         scaleX = this.baseScaleX + _loc3_;
         scaleY = this.baseScaleY + _loc3_;
         scaleZ = this.baseScaleZ + _loc3_;
         var _loc4_:PerspectiveProjection;
         (_loc4_ = new PerspectiveProjection()).focalLength = FocalLength;
         _loc4_.projectionCenter = new Point(x,y);
         transform.perspectiveProjection = _loc4_;
      }
   }
}
