package GenesisTerminalKiosk_AssetLibrary_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class MainTimeline extends MovieClip
   {
       
      
      public var ___camera___instance:MovieClip;
      
      public const CAMERA:Number = 0;
      
      public const LAYER_PROPERTIES:Number = 1;
      
      public const LAYER_OBJECT:Number = 2;
      
      public function MainTimeline()
      {
         super();
      }
      
      public function ___applyLayerZdepthAndEffects___() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ != null && _loc2_ is MovieClip && MovieClip(_loc2_).hasOwnProperty("containerType") && MovieClip(_loc2_).containerType == this.LAYER_PROPERTIES)
            {
               _loc2_.executeFrame();
            }
            _loc1_++;
         }
      }
      
      public function ___ordering___(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(!this.___needDepthSorting___())
         {
            return;
         }
         var _loc2_:* = 0;
         while(_loc2_ < numChildren - 1)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ == null || !(_loc3_ is MovieClip) || !MovieClip(_loc3_).hasOwnProperty("containerType") || MovieClip(_loc3_).containerType != this.LAYER_OBJECT)
            {
               _loc2_ += 1;
            }
            else
            {
               _loc4_ = _loc2_;
               _loc5_ = _loc3_;
               _loc6_ = _loc2_ + 1;
               while(_loc6_ < numChildren)
               {
                  if((_loc7_ = getChildAt(_loc6_)) == null || !(_loc7_ is MovieClip) || !MovieClip(_loc7_).hasOwnProperty("containerType") || MovieClip(_loc7_).containerType != this.LAYER_OBJECT)
                  {
                     _loc6_ += 1;
                  }
                  else
                  {
                     _loc8_ = this.___GetPropObj___(_loc3_);
                     _loc9_ = this.___GetPropObj___(_loc7_);
                     if(this.___needSwapping___(_loc8_,_loc9_))
                     {
                        _loc4_ = _loc6_;
                        _loc3_ = _loc7_;
                     }
                     _loc6_ += 1;
                  }
               }
               if(_loc4_ != _loc2_)
               {
                  swapChildren(_loc5_,_loc3_);
               }
               _loc2_ += 1;
            }
         }
      }
      
      public function ___needDepthSorting___() : Boolean
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:DisplayObject = null;
         var _loc1_:* = 0;
         while(_loc1_ < numChildren - 1)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ == null || !(_loc2_ is MovieClip) || !MovieClip(_loc2_).hasOwnProperty("containerType") || MovieClip(_loc2_).containerType != this.LAYER_OBJECT)
            {
               _loc1_ += 1;
            }
            else
            {
               _loc3_ = _loc1_ + 1;
               while(_loc3_ < numChildren)
               {
                  if((_loc6_ = getChildAt(_loc3_)) && _loc6_ is MovieClip && MovieClip(_loc6_).hasOwnProperty("containerType") && MovieClip(_loc6_).containerType == this.LAYER_OBJECT)
                  {
                     break;
                  }
                  _loc3_ += 1;
               }
               if(_loc3_ == numChildren)
               {
                  break;
               }
               _loc4_ = this.___GetPropObj___(_loc2_);
               _loc5_ = this.___GetPropObj___(_loc6_);
               if(this.___needSwapping___(_loc4_,_loc5_))
               {
                  return true;
               }
               _loc1_ = _loc3_;
            }
         }
         return false;
      }
      
      public function ___GetPropObj___(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:* = undefined;
         if(param1["propObjLink"] == undefined)
         {
            _loc2_ = param1.name + "_prop_";
            param1["propObjLink"] = getChildByName(_loc2_);
         }
         return param1["propObjLink"];
      }
      
      public function ___GetDepth___(param1:DisplayObject) : Number
      {
         var _loc2_:Number = param1.z;
         var _loc3_:* = getChildByName("___camera___instance");
         if(_loc3_ && param1 is MovieClip && MovieClip(param1).hasOwnProperty("isAttachedToCamera") && Boolean(MovieClip(param1).isAttachedToCamera))
         {
            _loc2_ += _loc2_ + _loc3_.z;
         }
         return _loc2_;
      }
      
      public function ___needSwapping___(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return false;
         }
         if(!(param1 is MovieClip) || !(param2 is MovieClip))
         {
            return false;
         }
         var _loc3_:* = this.___GetDepth___(param1);
         var _loc4_:* = this.___GetDepth___(param2);
         if(_loc3_ < _loc4_)
         {
            return true;
         }
         if(_loc3_ > _loc4_)
         {
            return false;
         }
         if(param1 is MovieClip && MovieClip(param1).hasOwnProperty("layerIndex") && param2 is MovieClip && MovieClip(param2).hasOwnProperty("layerIndex") && MovieClip(param1).layerIndex < MovieClip(param2).layerIndex)
         {
            return true;
         }
         return false;
      }
      
      public function ___onAdded___(param1:Event) : *
      {
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.target;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:* = _loc2_.parent;
         if(_loc3_ && _loc3_ == this)
         {
            if(_loc2_ is MovieClip)
            {
               _loc4_ = 0;
               while(_loc4_ < numChildren)
               {
                  if((_loc5_ = getChildAt(_loc4_)) != _loc2_)
                  {
                     if(_loc5_ is MovieClip && _loc5_.name == _loc2_.name)
                     {
                        removeChild(_loc2_);
                        break;
                     }
                  }
                  _loc4_++;
               }
            }
         }
         else if(_loc2_ is MovieClip)
         {
            if((_loc6_ = param1.target.parent) is MovieClip && _loc6_.containertype == this.LAYER_OBJECT && _loc6_.parent != null)
            {
               _loc6_.parent[param1.target.name] = param1.target;
            }
         }
      }
   }
}
