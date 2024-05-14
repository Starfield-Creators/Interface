package privatePkg
{
   import fl.motion.AdjustColor;
   import fl.motion.Color;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   
   public class ___Camera___ extends MovieClip
   {
       
      
      private var centerX:Number;
      
      private var centerY:Number;
      
      private var camAxisX:Number;
      
      private var camAxisY:Number;
      
      private var camAPIcalled:Boolean;
      
      private var cameraGuide:CameraGuide;
      
      private const MIN_X:* = -10000;
      
      private const MIN_Y:* = -10000;
      
      private const MIN_Z:* = -5000;
      
      private const MAX_X:* = 10000;
      
      private const MAX_Y:* = 10000;
      
      private const MAX_Z:* = 10000;
      
      private const MIN_ZOOM:* = 1;
      
      private const MAX_ZOOM:* = 10000;
      
      private const MIN_RGB:* = 0;
      
      private const MAX_RGB:* = 255;
      
      private const MIN_BRIGHTNESS:* = -100;
      
      private const MAX_BRIGHTNESS:* = 100;
      
      private const MIN_CONTRAST:* = -100;
      
      private const MAX_CONTRAST:* = 100;
      
      private const MIN_SATURATION:* = -100;
      
      private const MAX_SATURATION:* = 100;
      
      private const MIN_HUE:* = -180;
      
      private const MAX_HUE:* = 180;
      
      private const MAX_angle:* = 180;
      
      private const MIN_angle:* = -179;
      
      public var containerType:Number = 0;
      
      public var layerDepth:Number = 0;
      
      public function ___Camera___(param1:Number = 0, param2:Number = 0)
      {
         super();
         visible = false;
         this.cameraGuide = new CameraGuide();
         this.centerX = this.centerY = 0;
         if(param2 <= 0 || param1 <= 0)
         {
            if(parent != null)
            {
               this.centerX = parent.stage.stageWidth / 2;
               this.centerY = parent.stage.stageHeight / 2;
            }
         }
         else
         {
            this.centerX = param1 / 2;
            this.centerY = param2 / 2;
         }
         this.camAxisX = this.centerX;
         this.camAxisY = this.centerY;
         this.camAPIcalled = false;
         if(parent != null)
         {
            this.init();
         }
      }
      
      public function init() : *
      {
         addEventListener(Event.ENTER_FRAME,this.cameraEnterFrame);
         addEventListener(Event.EXIT_FRAME,this.cameraControl);
         addEventListener(Event.REMOVED_FROM_STAGE,this.resetStage);
      }
      
      private function camAPIinit() : *
      {
         this.camAxisX = this.x;
         this.camAxisY = this.y;
         this.camAPIcalled = true;
      }
      
      public function moveBy(param1:Number, param2:Number, param3:Number = 0) : void
      {
         if(!this.camAPIcalled)
         {
            this.camAPIinit();
         }
         var _loc4_:* = this.getCamPosition();
         var _loc5_:Number = this.getRotation() * Math.PI / 180;
         var _loc6_:Number = Math.sin(_loc5_);
         var _loc7_:Number = Math.cos(_loc5_);
         var _loc8_:Number = param1 * _loc7_ + param2 * _loc6_;
         var _loc9_:Number = param2 * _loc7_ - param1 * _loc6_;
         this.camAxisX -= param1;
         this.camAxisY -= param2;
         var _loc10_:Number = _loc4_.x + _loc8_;
         var _loc11_:Number = _loc4_.y + _loc9_;
         this.x = this.centerX - _loc10_;
         this.y = this.centerY - _loc11_;
         if(this.advancedLayersEnabled(parent))
         {
            this["layerDepth"] += param3;
         }
         stage.invalidate();
      }
      
      public function setPosition(param1:Number, param2:Number, param3:Number = 0) : void
      {
         if(!this.camAPIcalled)
         {
            this.camAPIcalled = true;
         }
         if(param1 < this.MIN_X)
         {
            param1 = this.MIN_X;
         }
         else if(param1 > this.MAX_X)
         {
            param1 = this.MAX_X;
         }
         if(param2 < this.MIN_Y)
         {
            param2 = this.MIN_Y;
         }
         else if(param2 > this.MAX_Y)
         {
            param2 = this.MAX_Y;
         }
         if(param3 < this.MIN_Z)
         {
            param3 = this.MIN_Z;
         }
         else if(param3 > this.MAX_Z)
         {
            param3 = this.MAX_Z;
         }
         var _loc4_:Number = this.getRotation() * Math.PI / 180;
         var _loc5_:Number = Math.sin(_loc4_);
         var _loc6_:Number = Math.cos(_loc4_);
         var _loc7_:Number = param1 * _loc6_ + param2 * _loc5_;
         var _loc8_:Number = param2 * _loc6_ - param1 * _loc5_;
         this.x = this.centerX - _loc7_;
         this.y = this.centerY - _loc8_;
         this.camAxisX = this.centerX - param1;
         this.camAxisY = this.centerY - param2;
         if(this.advancedLayersEnabled(parent))
         {
            this["layerDepth"] = param3;
         }
         stage.invalidate();
      }
      
      private function getCamPosition() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["x"] = this.centerX - this.x;
         _loc1_["y"] = this.centerY - this.y;
         _loc1_["z"] = this["layerDepth"];
         return _loc1_;
      }
      
      public function getPosition() : Object
      {
         var _loc1_:Object = new Object();
         if(!this.camAPIcalled)
         {
            _loc1_["x"] = this.centerX - this.x;
            _loc1_["y"] = this.centerY - this.y;
            _loc1_["z"] = this["layerDepth"];
            return _loc1_;
         }
         _loc1_["x"] = this.centerX - this.camAxisX;
         _loc1_["y"] = this.centerY - this.camAxisY;
         _loc1_["z"] = this["layerDepth"];
         return _loc1_;
      }
      
      public function resetPosition() : void
      {
         this.setPosition(0,0,0);
      }
      
      public function zoomBy(param1:Number) : void
      {
         this.setZoom(this.getZoom() * param1 / 100);
      }
      
      public function setZoom(param1:Number) : void
      {
         if(!this.camAPIcalled)
         {
            this.camAPIinit();
         }
         if(param1 < this.MIN_ZOOM)
         {
            param1 = this.MIN_ZOOM;
         }
         else if(param1 > this.MAX_ZOOM)
         {
            param1 = this.MAX_ZOOM;
         }
         this.scaleX = 100 / param1;
         this.scaleY = 100 / param1;
         stage.invalidate();
      }
      
      public function getZoom() : Number
      {
         return 100 / this.scaleX;
      }
      
      public function resetZoom() : void
      {
         this.setZoom(100);
      }
      
      public function rotateBy(param1:Number) : void
      {
         if(!this.camAPIcalled)
         {
            this.camAPIinit();
         }
         this.setRotation(this.getRotation() + param1);
      }
      
      public function setRotation(param1:Number) : void
      {
         if(param1 < this.MIN_angle)
         {
            param1 = this.MIN_angle;
         }
         else if(param1 > this.MAX_angle)
         {
            param1 = this.MAX_angle;
         }
         if(!this.camAPIcalled)
         {
            this.camAPIinit();
         }
         this.rotation = -param1;
         stage.invalidate();
      }
      
      public function getRotation() : Number
      {
         return -this.rotation;
      }
      
      public function resetRotation() : void
      {
         this.setRotation(0);
      }
      
      public function setTint(param1:Number, param2:Number) : void
      {
         var _loc3_:Color = new Color();
         _loc3_.setTint(param1,param2 / 100);
         this.transform.colorTransform = _loc3_;
         stage.invalidate();
      }
      
      public function setTintRGB(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         if(param1 < this.MIN_RGB)
         {
            param1 = this.MIN_RGB;
         }
         if(param1 > this.MAX_RGB)
         {
            param1 = this.MAX_RGB;
         }
         if(param2 < this.MIN_RGB)
         {
            param2 = this.MIN_RGB;
         }
         if(param2 > this.MAX_RGB)
         {
            param2 = this.MAX_RGB;
         }
         if(param3 < this.MIN_RGB)
         {
            param3 = this.MIN_RGB;
         }
         if(param3 > this.MAX_RGB)
         {
            param3 = this.MAX_RGB;
         }
         if(param4 < 0)
         {
            param4 = 0;
         }
         if(param4 > 100)
         {
            param4 = 100;
         }
         var _loc5_:uint = uint((_loc5_ = uint((_loc5_ = uint((_loc5_ = 0) | param1 << 16)) | param2 << 8)) | param3);
         this.setTint(_loc5_,param4);
      }
      
      public function getTint() : Object
      {
         var _loc1_:* = this.getTintRGB();
         var _loc2_:* = new Object();
         _loc2_["percent"] = _loc1_["percent"];
         var _loc3_:uint = 0;
         _loc3_ |= _loc1_["red"] << 16;
         _loc3_ |= _loc1_["green"] << 8;
         _loc3_ |= _loc1_["blue"];
         _loc2_["color"] = _loc3_;
         return _loc2_;
      }
      
      public function getTintRGB() : Object
      {
         var _loc2_:* = undefined;
         var _loc1_:Object = new Object();
         _loc1_["percent"] = 0;
         _loc1_["red"] = 0;
         _loc1_["green"] = 0;
         _loc1_["blue"] = 0;
         if(this.transform != null && this.transform.colorTransform != null)
         {
            _loc2_ = 100 * (1 - this.transform.colorTransform.redMultiplier);
            _loc1_["percent"] = _loc2_;
            _loc1_["red"] = this.transform.colorTransform.redOffset * 100 / _loc2_;
            _loc1_["green"] = this.transform.colorTransform.greenOffset * 100 / _loc2_;
            _loc1_["blue"] = this.transform.colorTransform.blueOffset * 100 / _loc2_;
         }
         return _loc1_;
      }
      
      public function resetTint() : *
      {
         this.setTint(0,0);
      }
      
      public function setColorFilter(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         if(param1 < this.MIN_BRIGHTNESS)
         {
            param1 = this.MIN_BRIGHTNESS;
         }
         else if(param1 > this.MAX_BRIGHTNESS)
         {
            param1 = this.MAX_BRIGHTNESS;
         }
         if(param2 < this.MIN_CONTRAST)
         {
            param2 = this.MIN_CONTRAST;
         }
         else if(param2 > this.MAX_CONTRAST)
         {
            param2 = this.MAX_CONTRAST;
         }
         if(param3 < this.MIN_SATURATION)
         {
            param3 = this.MIN_SATURATION;
         }
         else if(param3 > this.MAX_SATURATION)
         {
            param3 = this.MAX_SATURATION;
         }
         if(param4 < this.MIN_HUE)
         {
            param4 = this.MIN_HUE;
         }
         else if(param4 > this.MAX_HUE)
         {
            param4 = this.MAX_HUE;
         }
         var _loc5_:AdjustColor;
         (_loc5_ = new AdjustColor()).brightness = param1;
         _loc5_.contrast = param2;
         _loc5_.saturation = param3;
         _loc5_.hue = param4;
         var _loc6_:Array = _loc5_.CalculateFinalFlatArray();
         var _loc7_:ColorMatrixFilter = new ColorMatrixFilter(_loc6_);
         this.filters = [_loc7_];
         stage.invalidate();
      }
      
      public function resetColorFilter() : *
      {
         this.filters = null;
      }
      
      public function reset() : *
      {
         this.resetZoom();
         this.resetRotation();
         this.resetPosition();
         this.resetTint();
         this.resetColorFilter();
         this.unpinCamera();
      }
      
      public function setZDepth(param1:Number) : void
      {
         if(param1 < this.MIN_Z)
         {
            param1 = this.MIN_Z;
         }
         else if(param1 > this.MAX_Z)
         {
            param1 = this.MAX_Z;
         }
         if(this.advancedLayersEnabled(parent))
         {
            this["layerDepth"] = param1;
         }
         stage.invalidate();
      }
      
      public function getZDepth() : Number
      {
         if(this.advancedLayersEnabled(parent))
         {
            return this["layerDepth"];
         }
         return 0;
      }
      
      public function resetZDepth() : *
      {
         this.setZDepth(0);
      }
      
      override public function set z(param1:Number) : void
      {
         this["layerDepth"] = param1;
      }
      
      override public function get z() : Number
      {
         return this["layerDepth"];
      }
      
      public function pinCameraToObject(param1:DisplayObject, param2:Number = 0, param3:Number = 0, param4:Number = 0) : *
      {
         this.cameraGuide.AttachGuide(param1,param2,param3,param4);
         this.handlepinCameraToObject();
         stage.invalidate();
      }
      
      public function setPinOffset(param1:Number, param2:Number, param3:Number) : *
      {
         this.cameraGuide.ChangeDelta(param1,param2,param3);
         this.handlepinCameraToObject();
         stage.invalidate();
      }
      
      public function unpinCamera() : *
      {
         this.cameraGuide.DetachGuide();
      }
      
      public function setCameraMask(param1:DisplayObject) : *
      {
         parent.mask = param1;
         if(param1 != null)
         {
            param1.visible = false;
            if(this.advancedLayersEnabled(parent))
            {
               param1["isAttachedToCamera"] = true;
               if(param1.parent != null)
               {
                  param1.parent.removeChild(param1);
               }
               this.parent.addChild(param1);
            }
            else
            {
               this.handleCameraMask();
            }
         }
      }
      
      public function removeCameraMask() : *
      {
         parent.mask = null;
      }
      
      private function getMatrix2DFrom3D(param1:Matrix3D) : Matrix
      {
         var _loc2_:Vector.<Number> = param1.rawData;
         var _loc3_:Matrix = new Matrix();
         _loc3_.a = _loc2_[0];
         _loc3_.b = _loc2_[1];
         _loc3_.tx = _loc2_[12];
         _loc3_.c = _loc2_[4];
         _loc3_.d = _loc2_[5];
         _loc3_.ty = _loc2_[13];
         return _loc3_;
      }
      
      public function getCameraMatrix() : Matrix
      {
         var _loc1_:Matrix = null;
         this.handlepinCameraToObject();
         if(this.transform.matrix3D)
         {
            _loc1_ = this.getMatrix2DFrom3D(this.transform.matrix3D);
         }
         else
         {
            _loc1_ = this.transform.matrix;
         }
         if(_loc1_ != null)
         {
            _loc1_.invert();
            _loc1_.translate(this.centerX,this.centerY);
         }
         return _loc1_;
      }
      
      private function cameraEnterFrame(... rest) : void
      {
         this.handlepinCameraToObject();
         if(!this.advancedLayersEnabled(parent))
         {
            this.handleCameraMask();
         }
      }
      
      private function handlepinCameraToObject() : void
      {
         var _loc1_:* = undefined;
         if(this.cameraGuide.IsAttachedToGuide())
         {
            _loc1_ = this.cameraGuide.GetAttachmentPoint();
            this.x = _loc1_.x;
            this.y = _loc1_.y;
            if(this.advancedLayersEnabled(parent))
            {
               this["layerDepth"] = _loc1_.z;
            }
         }
      }
      
      private function handleCameraMask() : void
      {
         if(parent != null && parent.mask != null)
         {
            parent.mask.x = this.x;
            parent.mask.y = this.y;
         }
      }
      
      private function cameraControl(... rest) : void
      {
         if(!parent)
         {
            return;
         }
         this.checkForAdvancedLayerEnabled(parent);
         var _loc2_:Matrix = this.transform.matrix;
         if(_loc2_ != null && !this.advancedLayersEnabled(parent))
         {
            _loc2_.invert();
            _loc2_.translate(this.centerX,this.centerY);
            parent.transform.matrix = _loc2_;
            parent.filters = this.filters;
            parent.transform.colorTransform = this.transform.colorTransform;
         }
      }
      
      private function resetStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.cameraEnterFrame);
         removeEventListener(Event.FRAME_CONSTRUCTED,this.cameraControl);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.resetStage);
         parent.scaleX = 1;
         parent.scaleY = 1;
         parent.x = 0;
         parent.y = 0;
         if(transform.matrix3D)
         {
            parent.scaleZ = 1;
            parent.z = 0;
            parent.rotationX = 0;
            parent.rotationY = 0;
            parent.rotationZ = 0;
         }
         else
         {
            parent.rotation = 0;
         }
         parent.visible = true;
         parent.filters = [];
         if(parent.transform)
         {
            parent.transform.colorTransform = new ColorTransform();
         }
      }
      
      private function checkForAdvancedLayerEnabled(param1:DisplayObjectContainer) : *
      {
      }
      
      private function advancedLayersEnabled(param1:DisplayObjectContainer) : Boolean
      {
         return true;
      }
   }
}
