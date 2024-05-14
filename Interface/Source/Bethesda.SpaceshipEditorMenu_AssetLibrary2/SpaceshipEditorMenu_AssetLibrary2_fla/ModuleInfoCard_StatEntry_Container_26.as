package SpaceshipEditorMenu_AssetLibrary2_fla
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
   
   public dynamic class ModuleInfoCard_StatEntry_Container_26 extends MovieClip
   {
       
      
      public var Arrow_mc:MovieClip;
      
      public var StatLabel_mc:MovieClip;
      
      public var Value:MovieClip;
      
      public var Value_prop_:MovieClip;
      
      public var StatValue_mc:*;
      
      public const CAMERA:Number = 0;
      
      public const LAYER_PROPERTIES:Number = 1;
      
      public const LAYER_OBJECT:Number = 2;
      
      public function ModuleInfoCard_StatEntry_Container_26()
      {
         super();
         this.__setProp_Value_ModuleInfoCard_StatEntry_Container_Value_obj__0();
         this.__setProp_Value_prop__ModuleInfoCard_StatEntry_Container_Value_prop__0();
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
      
      internal function __setProp_Value_ModuleInfoCard_StatEntry_Container_Value_obj__0() : *
      {
         try
         {
            this.Value["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.Value.containerType = 2;
         try
         {
            this.Value["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_Value_prop__ModuleInfoCard_StatEntry_Container_Value_prop__0() : *
      {
         try
         {
            this.Value_prop_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.Value_prop_.containerType = 1;
         this.Value_prop_.isAttachedToCamera = false;
         this.Value_prop_.isAttachedToMask = false;
         this.Value_prop_.layerDepth = 0;
         this.Value_prop_.layerIndex = 0;
         this.Value_prop_.maskLayerName = "";
         try
         {
            this.Value_prop_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
