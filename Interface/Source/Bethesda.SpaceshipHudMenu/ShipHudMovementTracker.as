package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   
   public class ShipHudMovementTracker
   {
       
      
      private var TransformClip:MovieClip;
      
      private var TranslationMagnitude:Number;
      
      private var RotationMagnitude:Number;
      
      private var TranslationLerpPercent:Number;
      
      private var RotationLerpPercent:Number;
      
      private var InitialPosition:Vector3D;
      
      private var InitialRotation:Vector3D;
      
      private var LastTransform:Matrix;
      
      public function ShipHudMovementTracker(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         this.InitialPosition = new Vector3D();
         this.InitialRotation = new Vector3D();
         this.LastTransform = new Matrix();
         super();
         this.TransformClip = param1;
         this.TranslationMagnitude = param2;
         this.RotationMagnitude = param3;
         this.TranslationLerpPercent = param4;
         this.RotationLerpPercent = param5;
         this.InitialPosition = new Vector3D(param1.x,param1.y);
         this.InitialRotation = new Vector3D(param1.rotationX,param1.rotationY);
         this.LastTransform = this.TransformClip.transform.matrix;
      }
      
      public function Update(param1:Vector3D) : *
      {
         var _loc2_:Vector3D = new Vector3D(this.TransformClip.rotationX,this.TransformClip.rotationY);
         var _loc3_:Vector3D = this.LerpToTarget(param1,this.RotationMagnitude,this.InitialRotation,_loc2_,this.RotationLerpPercent,true);
         this.TransformClip.rotationX = _loc3_.x;
         this.TransformClip.rotationY = _loc3_.y;
         _loc2_ = new Vector3D(this.TransformClip.x,this.TransformClip.y);
         _loc3_ = this.LerpToTarget(param1,this.TranslationMagnitude,this.InitialPosition,_loc2_,this.TranslationLerpPercent);
         this.LastTransform.tx = _loc3_.x;
         this.LastTransform.ty = _loc3_.y;
         this.TransformClip.transform.matrix = this.LastTransform;
      }
      
      public function Reset() : *
      {
         this.TransformClip.rotationX = this.InitialRotation.x;
         this.TransformClip.rotationY = this.InitialRotation.y;
         this.LastTransform.tx = this.InitialPosition.x;
         this.LastTransform.ty = this.InitialPosition.y;
         this.TransformClip.transform.matrix = this.LastTransform;
      }
      
      private function LerpToTarget(param1:Vector3D, param2:Number, param3:Vector3D, param4:Vector3D, param5:Number, param6:Boolean = false) : Vector3D
      {
         var _loc9_:Number = NaN;
         var _loc7_:Vector3D;
         (_loc7_ = param1.clone()).scaleBy(param2);
         if(param6)
         {
            _loc9_ = _loc7_.x;
            _loc7_.x = _loc7_.y;
            _loc7_.y = _loc9_;
         }
         var _loc8_:* = param3.add(_loc7_);
         return GlobalFunc.VectorLerp(param4,_loc8_,param5);
      }
   }
}
