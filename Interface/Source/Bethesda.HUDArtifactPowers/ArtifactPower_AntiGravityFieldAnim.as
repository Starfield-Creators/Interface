package
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
   
   public dynamic class ArtifactPower_AntiGravityFieldAnim extends MovieClip
   {
       
      
      public var AGF10:MovieClip;
      
      public var AGF10_prop_:MovieClip;
      
      public var AGF11:MovieClip;
      
      public var AGF11_prop_:MovieClip;
      
      public var AGF5:MovieClip;
      
      public var AGF5_prop_:MovieClip;
      
      public var AGF6:MovieClip;
      
      public var AGF6_prop_:MovieClip;
      
      public var AGF7:MovieClip;
      
      public var AGF7_prop_:MovieClip;
      
      public var AGF8:MovieClip;
      
      public var AGF8_prop_:MovieClip;
      
      public var AGF9:MovieClip;
      
      public var AGF9_prop_:MovieClip;
      
      public const CAMERA:Number = 0;
      
      public const LAYER_PROPERTIES:Number = 1;
      
      public const LAYER_OBJECT:Number = 2;
      
      public function ArtifactPower_AntiGravityFieldAnim()
      {
         super();
         this.__setProp_AGF6_ArtifactPower_AntiGravityFieldAnim_AGF6_obj__0();
         this.__setProp_AGF6_prop__ArtifactPower_AntiGravityFieldAnim_AGF6_prop__0();
         this.__setProp_AGF5_ArtifactPower_AntiGravityFieldAnim_AGF5_obj__0();
         this.__setProp_AGF5_prop__ArtifactPower_AntiGravityFieldAnim_AGF5_prop__0();
         this.__setProp_AGF7_ArtifactPower_AntiGravityFieldAnim_AGF7_obj__0();
         this.__setProp_AGF7_prop__ArtifactPower_AntiGravityFieldAnim_AGF7_prop__0();
         this.__setProp_AGF10_ArtifactPower_AntiGravityFieldAnim_AGF10_obj__0();
         this.__setProp_AGF10_prop__ArtifactPower_AntiGravityFieldAnim_AGF10_prop__0();
         this.__setProp_AGF9_ArtifactPower_AntiGravityFieldAnim_AGF9_obj__0();
         this.__setProp_AGF9_prop__ArtifactPower_AntiGravityFieldAnim_AGF9_prop__0();
         this.__setProp_AGF8_ArtifactPower_AntiGravityFieldAnim_AGF8_obj__0();
         this.__setProp_AGF8_prop__ArtifactPower_AntiGravityFieldAnim_AGF8_prop__0();
         this.__setProp_AGF11_ArtifactPower_AntiGravityFieldAnim_AGF11_obj__0();
         this.__setProp_AGF11_prop__ArtifactPower_AntiGravityFieldAnim_AGF11_prop__0();
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
      
      internal function __setProp_AGF6_ArtifactPower_AntiGravityFieldAnim_AGF6_obj__0() : *
      {
         try
         {
            this.AGF6["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF6.containerType = 2;
         try
         {
            this.AGF6["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF6_prop__ArtifactPower_AntiGravityFieldAnim_AGF6_prop__0() : *
      {
         try
         {
            this.AGF6_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF6_prop_.containerType = 1;
         this.AGF6_prop_.isAttachedToCamera = false;
         this.AGF6_prop_.isAttachedToMask = false;
         this.AGF6_prop_.layerDepth = 0;
         this.AGF6_prop_.layerIndex = 6;
         this.AGF6_prop_.maskLayerName = "";
         try
         {
            this.AGF6_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF5_ArtifactPower_AntiGravityFieldAnim_AGF5_obj__0() : *
      {
         try
         {
            this.AGF5["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF5.containerType = 2;
         try
         {
            this.AGF5["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF5_prop__ArtifactPower_AntiGravityFieldAnim_AGF5_prop__0() : *
      {
         try
         {
            this.AGF5_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF5_prop_.containerType = 1;
         this.AGF5_prop_.isAttachedToCamera = false;
         this.AGF5_prop_.isAttachedToMask = false;
         this.AGF5_prop_.layerDepth = 0;
         this.AGF5_prop_.layerIndex = 5;
         this.AGF5_prop_.maskLayerName = "";
         try
         {
            this.AGF5_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF7_ArtifactPower_AntiGravityFieldAnim_AGF7_obj__0() : *
      {
         try
         {
            this.AGF7["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF7.containerType = 2;
         try
         {
            this.AGF7["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF7_prop__ArtifactPower_AntiGravityFieldAnim_AGF7_prop__0() : *
      {
         try
         {
            this.AGF7_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF7_prop_.containerType = 1;
         this.AGF7_prop_.isAttachedToCamera = false;
         this.AGF7_prop_.isAttachedToMask = false;
         this.AGF7_prop_.layerDepth = 0;
         this.AGF7_prop_.layerIndex = 4;
         this.AGF7_prop_.maskLayerName = "";
         try
         {
            this.AGF7_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF10_ArtifactPower_AntiGravityFieldAnim_AGF10_obj__0() : *
      {
         try
         {
            this.AGF10["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF10.containerType = 2;
         try
         {
            this.AGF10["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF10_prop__ArtifactPower_AntiGravityFieldAnim_AGF10_prop__0() : *
      {
         try
         {
            this.AGF10_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF10_prop_.containerType = 1;
         this.AGF10_prop_.isAttachedToCamera = false;
         this.AGF10_prop_.isAttachedToMask = false;
         this.AGF10_prop_.layerDepth = 0;
         this.AGF10_prop_.layerIndex = 3;
         this.AGF10_prop_.maskLayerName = "";
         try
         {
            this.AGF10_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF9_ArtifactPower_AntiGravityFieldAnim_AGF9_obj__0() : *
      {
         try
         {
            this.AGF9["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF9.containerType = 2;
         try
         {
            this.AGF9["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF9_prop__ArtifactPower_AntiGravityFieldAnim_AGF9_prop__0() : *
      {
         try
         {
            this.AGF9_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF9_prop_.containerType = 1;
         this.AGF9_prop_.isAttachedToCamera = false;
         this.AGF9_prop_.isAttachedToMask = false;
         this.AGF9_prop_.layerDepth = 0;
         this.AGF9_prop_.layerIndex = 2;
         this.AGF9_prop_.maskLayerName = "";
         try
         {
            this.AGF9_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF8_ArtifactPower_AntiGravityFieldAnim_AGF8_obj__0() : *
      {
         try
         {
            this.AGF8["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF8.containerType = 2;
         try
         {
            this.AGF8["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF8_prop__ArtifactPower_AntiGravityFieldAnim_AGF8_prop__0() : *
      {
         try
         {
            this.AGF8_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF8_prop_.containerType = 1;
         this.AGF8_prop_.isAttachedToCamera = false;
         this.AGF8_prop_.isAttachedToMask = false;
         this.AGF8_prop_.layerDepth = 0;
         this.AGF8_prop_.layerIndex = 1;
         this.AGF8_prop_.maskLayerName = "";
         try
         {
            this.AGF8_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF11_ArtifactPower_AntiGravityFieldAnim_AGF11_obj__0() : *
      {
         try
         {
            this.AGF11["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF11.containerType = 2;
         try
         {
            this.AGF11["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_AGF11_prop__ArtifactPower_AntiGravityFieldAnim_AGF11_prop__0() : *
      {
         try
         {
            this.AGF11_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.AGF11_prop_.containerType = 1;
         this.AGF11_prop_.isAttachedToCamera = false;
         this.AGF11_prop_.isAttachedToMask = false;
         this.AGF11_prop_.layerDepth = 0;
         this.AGF11_prop_.layerIndex = 0;
         this.AGF11_prop_.maskLayerName = "";
         try
         {
            this.AGF11_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
