package privatePkg
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class ___LayerProp___ extends MovieClip
   {
       
      
      public var containerType:Number = 1;
      
      public var isAttachedToCamera:Boolean = false;
      
      public var isAttachedToMask:Boolean = false;
      
      public var layerDepth:Number = 0;
      
      public var layerIndex:Number = 0;
      
      public var maskLayerName:String;
      
      public var propObjLink:Object;
      
      public function ___LayerProp___()
      {
         super();
         visible = false;
         if(parent != null)
         {
            this.init();
         }
      }
      
      private static function getProjectionMatrix(param1:MovieClip, param2:Number) : Matrix
      {
         var _loc3_:* = MovieClip(param1.parent);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:* = param1.root.transform.perspectiveProjection.focalLength;
         var _loc5_:* = param1.root.transform.perspectiveProjection.projectionCenter;
         var _loc6_:Number = (param2 + _loc4_) / _loc4_;
         var _loc7_:Matrix;
         (_loc7_ = new Matrix()).identity();
         _loc7_.translate(-_loc5_.x,-_loc5_.y);
         _loc7_.scale(1 / _loc6_,1 / _loc6_);
         _loc7_.translate(_loc5_.x,_loc5_.y);
         return _loc7_;
      }
      
      public static function executeFrameHelper(param1:MovieClip) : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(!param1)
         {
            return;
         }
         var _loc2_:* = MovieClip(param1.parent);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:* = getObjLink(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:* = -1;
         if(_loc2_ != param1.root && Boolean(_loc2_.hasOwnProperty("loopMode")))
         {
            if((_loc4_ = graphicFrameSync(_loc2_.currentFrame,_loc3_.totalFrames,_loc2_["firstFrame"],_loc2_["loopMode"])) != _loc3_.currentFrame || _loc4_ != param1.currentFrame)
            {
               if(_loc2_["loopMode"] == 2)
               {
                  param1.gotoAndStop(_loc4_);
                  _loc3_.gotoAndStop(_loc4_);
               }
               else
               {
                  param1.gotoAndPlay(_loc4_);
                  _loc3_.gotoAndPlay(_loc4_);
               }
            }
         }
         else if(_loc3_.currentFrame != _loc2_.currentFrame)
         {
            _loc4_ = _loc2_.currentFrame;
            param1.gotoAndPlay(_loc2_.currentFrame);
            _loc3_.gotoAndPlay(_loc2_.currentFrame);
         }
         if(_loc4_ > 0 && Boolean(param1.isAttachedToMask))
         {
            if((_loc6_ = _loc3_.getChildByName("_mask_obj_instance")) != null)
            {
               _loc6_.gotoAndPlay(_loc4_);
            }
         }
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.numChildren)
         {
            if((_loc7_ = _loc3_.getChildAt(_loc5_)) && Boolean(_loc7_.hasOwnProperty("loopMode")))
            {
               _loc7_.syncFrame();
            }
            _loc5_++;
         }
      }
      
      private static function graphicFrameSync(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:* = param1;
         if(param4 == 0)
         {
            _loc5_ = (param1 + param3 - 2) % param2 + 1;
         }
         else if(param4 == 1)
         {
            if((_loc5_ = param1 + param3 - 1) > param2)
            {
               _loc5_ = param2;
            }
         }
         else if(param4 == 2)
         {
            _loc5_ = param3;
         }
         else if(param4 == 3)
         {
            if((_loc5_ = param3 - param1 + 1) < 0)
            {
               _loc5_ = 0;
            }
         }
         else if(param4 == 4)
         {
            _loc5_ = (param3 + param2 - param1 % param2) % param2 + 1;
         }
         return _loc5_;
      }
      
      private static function applyZDepthAndColorEffectsHelper(param1:MovieClip) : void
      {
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:* = undefined;
         var _loc27_:* = undefined;
         var _loc28_:* = undefined;
         var _loc29_:* = undefined;
         var _loc30_:* = undefined;
         if(!param1 || !param1.parent || !param1.root)
         {
            return;
         }
         var _loc2_:* = MovieClip(param1.parent);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:* = param1.root.transform.perspectiveProjection.focalLength;
         var _loc4_:*;
         if(!(_loc4_ = getObjLink(param1)))
         {
            return;
         }
         _loc4_.filters = param1.filters;
         _loc4_.transform.colorTransform = param1.transform.colorTransform;
         _loc4_.blendMode = param1.blendMode;
         _loc4_.visible = param1.visible;
         var _loc5_:* = _loc2_.getChildByName("___camera___instance");
         var _loc6_:Matrix;
         (_loc6_ = new Matrix()).identity();
         var _loc7_:Matrix;
         (_loc7_ = new Matrix()).identity();
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         if(_loc5_ && !param1.isAttachedToCamera)
         {
            _loc7_ = _loc5_.getCameraMatrix();
            _loc9_ = Number(_loc5_.getZDepth());
         }
         if(!isNaN(param1.z))
         {
            _loc8_ = param1.z;
         }
         if(!isNaN(_loc9_))
         {
            _loc8_ -= _loc9_;
         }
         if(_loc8_ < -_loc3_)
         {
            _loc4_.visible = false;
         }
         else
         {
            _loc4_.visible = true;
            if(param1.layerDepth)
            {
               if(_loc11_ = getProjectionMatrix(param1,param1.layerDepth))
               {
                  _loc11_.invert();
                  _loc6_.concat(_loc11_);
               }
            }
            _loc6_.concat(_loc7_);
            if(_loc10_ = getProjectionMatrix(param1,_loc8_))
            {
               _loc6_.concat(_loc10_);
            }
         }
         _loc4_.transform.matrix = _loc6_;
         if(param1.isAttachedToMask)
         {
            if((_loc12_ = _loc4_.getChildByName("_mask_obj_instance")) != null)
            {
               _loc8_ = -_loc9_;
               _loc6_.invert();
               if(Boolean(param1.maskLayerName) && param1.maskLayerName != "")
               {
                  if(_loc14_ = param1.parent.getChildByName(param1.maskLayerName))
                  {
                     _loc8_ += _loc14_.z;
                  }
                  if(_loc14_ && !param1.isAttachedToCamera)
                  {
                     _loc15_ = _loc4_.transform.colorTransform.alphaMultiplier * _loc14_.transform.colorTransform.alphaMultiplier;
                     _loc16_ = _loc4_.transform.colorTransform.redMultiplier * _loc14_.transform.colorTransform.redMultiplier;
                     _loc17_ = _loc4_.transform.colorTransform.greenMultiplier * _loc14_.transform.colorTransform.greenMultiplier;
                     _loc18_ = _loc4_.transform.colorTransform.blueMultiplier * _loc14_.transform.colorTransform.blueMultiplier;
                     _loc19_ = _loc14_.transform.colorTransform.alphaOffset + _loc4_.transform.colorTransform.alphaOffset * _loc14_.transform.colorTransform.alphaMultiplier;
                     _loc20_ = _loc14_.transform.colorTransform.redOffset + _loc4_.transform.colorTransform.redOffset * _loc14_.transform.colorTransform.redMultiplier;
                     _loc21_ = _loc14_.transform.colorTransform.greenOffset + _loc4_.transform.colorTransform.greenOffset * _loc14_.transform.colorTransform.greenMultiplier;
                     _loc22_ = _loc14_.transform.colorTransform.blueOffset + _loc4_.transform.colorTransform.blueOffset * _loc14_.transform.colorTransform.blueMultiplier;
                     _loc4_.transform.colorTransform = new ColorTransform(_loc16_,_loc17_,_loc18_,_loc15_,_loc20_,_loc21_,_loc22_,_loc19_);
                  }
               }
               _loc13_ = getProjectionMatrix(param1,_loc8_);
               _loc6_.concat(_loc7_);
               _loc6_.concat(_loc13_);
               _loc12_.transform.matrix = _loc6_;
            }
         }
         if(_loc5_ && !param1.isAttachedToCamera)
         {
            _loc4_.filters = _loc4_.filters.concat(_loc5_.filters);
            _loc23_ = _loc4_.transform.colorTransform.alphaMultiplier * _loc5_.transform.colorTransform.alphaMultiplier;
            _loc24_ = _loc4_.transform.colorTransform.redMultiplier * _loc5_.transform.colorTransform.redMultiplier;
            _loc25_ = _loc4_.transform.colorTransform.greenMultiplier * _loc5_.transform.colorTransform.greenMultiplier;
            _loc26_ = _loc4_.transform.colorTransform.blueMultiplier * _loc5_.transform.colorTransform.blueMultiplier;
            _loc27_ = _loc5_.transform.colorTransform.alphaOffset + _loc4_.transform.colorTransform.alphaOffset * _loc5_.transform.colorTransform.alphaMultiplier;
            _loc28_ = _loc5_.transform.colorTransform.redOffset + _loc4_.transform.colorTransform.redOffset * _loc5_.transform.colorTransform.redMultiplier;
            _loc29_ = _loc5_.transform.colorTransform.greenOffset + _loc4_.transform.colorTransform.greenOffset * _loc5_.transform.colorTransform.greenMultiplier;
            _loc30_ = _loc5_.transform.colorTransform.blueOffset + _loc4_.transform.colorTransform.blueOffset * _loc5_.transform.colorTransform.blueMultiplier;
            _loc4_.transform.colorTransform = new ColorTransform(_loc24_,_loc25_,_loc26_,_loc23_,_loc28_,_loc29_,_loc30_,_loc27_);
         }
      }
      
      private static function getObjLink(param1:MovieClip) : MovieClip
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(param1["propObjLink"] == undefined)
         {
            _loc2_ = param1.name;
            _loc3_ = _loc2_.lastIndexOf("_prop_");
            _loc4_ = _loc2_.slice(0,_loc3_);
            if(!(_loc5_ = MovieClip(param1.parent)))
            {
               return undefined;
            }
            param1["propObjLink"] = _loc5_.getChildByName(_loc4_);
         }
         return param1["propObjLink"];
      }
      
      public function init() : *
      {
         addEventListener(Event.ENTER_FRAME,this.enterFrame,false,0,true);
         addEventListener(Event.EXIT_FRAME,this.applyZDepthAndColorEffects,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.resetStage,false,0,true);
      }
      
      private function enterFrame(... rest) : void
      {
         this.executeFrame();
      }
      
      public function executeFrame() : *
      {
         executeFrameHelper(this);
      }
      
      private function applyZDepthAndColorEffects(... rest) : void
      {
         applyZDepthAndColorEffectsHelper(this);
      }
      
      private function resetStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrame);
         removeEventListener(Event.EXIT_FRAME,this.applyZDepthAndColorEffects);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.resetStage);
         var _loc2_:* = this.name;
         var _loc3_:* = _loc2_.lastIndexOf("_prop_");
         var _loc4_:* = _loc2_.slice(0,_loc3_);
         var _loc5_:*;
         if(!(_loc5_ = MovieClip(parent)))
         {
            return;
         }
         var _loc6_:*;
         if((_loc6_ = _loc5_.getChildByName(_loc4_)) && (MovieClip(root).scenes.length > 1 || !parent.parent || currentFrame < MovieClip(parent).totalFrames) && parent == root)
         {
            parent.removeChild(_loc6_);
         }
      }
   }
}
