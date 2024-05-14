package fl
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import privatePkg.___LayerProp___;
   
   public class Layer
   {
      
      private static const MIN_Z:* = -5000;
      
      private static const MAX_Z:* = 10000;
       
      
      public function Layer()
      {
         super();
      }
      
      public static function getLayerZDepth(param1:DisplayObject, param2:String) : Number
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(!param1 is MovieClip)
         {
            return 0;
         }
         var _loc3_:* = MovieClip(param1);
         if(param2 == "Camera" || param2 == "___camera___instance")
         {
            param2 = "___camera___instance";
            if(_loc5_ = _loc3_.getChildByName(param2))
            {
               return _loc5_.z;
            }
            return 0;
         }
         var _loc4_:*;
         if((_loc4_ = _loc3_.getChildByName(param2)) != undefined && _loc4_ != null)
         {
            if((_loc6_ = _loc3_.getChildByName(param2 + "_prop_")) != undefined && _loc6_ != null)
            {
               return _loc6_.z;
            }
         }
         return 0;
      }
      
      public static function setLayerZDepth(param1:DisplayObject, param2:String, param3:Number) : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(param3 < MIN_Z)
         {
            param3 = MIN_Z;
         }
         else if(param3 > MAX_Z)
         {
            param3 = MAX_Z;
         }
         if(!param1 is MovieClip)
         {
            return;
         }
         var _loc4_:* = MovieClip(param1);
         if(param2 == "Camera" || param2 == "___camera___instance")
         {
            param2 = "___camera___instance";
            if(_loc6_ = _loc4_.getChildByName(param2))
            {
               _loc6_.z = param3;
            }
            return;
         }
         var _loc5_:*;
         if((_loc5_ = _loc4_.getChildByName(param2)) != undefined && _loc5_ != null)
         {
            if((_loc7_ = _loc4_.getChildByName(___propertyContainerName___(param2))) != undefined && _loc7_ != null)
            {
               _loc7_.z = param3;
            }
         }
      }
      
      public static function removeLayer(param1:DisplayObject, param2:String) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(!param1 is MovieClip)
         {
            return;
         }
         var _loc3_:* = MovieClip(param1);
         if(param2 == "Camera")
         {
            param2 = "___camera___instance";
            if(_loc5_ = _loc3_.getChildByName(param2))
            {
               _loc3_.removeChild(_loc5_);
            }
            return;
         }
         var _loc4_:*;
         if((_loc4_ = _loc3_.getChildByName(param2)) != undefined && _loc4_ != null)
         {
            if((_loc6_ = _loc3_.getChildByName(___propertyContainerName___(param2))) != undefined && _loc6_ != null)
            {
               _loc3_.removeChild(_loc4_);
               _loc3_.removeChild(_loc6_);
            }
         }
      }
      
      internal static function ___propertyContainerName___(param1:String) : String
      {
         return param1 + "_prop_";
      }
      
      internal static function ___findHighestLayerIndex___(param1:MovieClip) : Number
      {
         var _loc4_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < param1.numChildren)
         {
            if((_loc4_ = param1.getChildAt(_loc3_))["containerType"] != undefined && _loc4_["containerType"] == 1)
            {
               if(_loc4_["layerIndex"] != undefined && _loc4_["layerIndex"] > _loc2_)
               {
                  _loc2_ = _loc4_["layerIndex"];
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function addNewLayer(param1:DisplayObject, param2:String, param3:Number = 0, param4:Boolean = false) : MovieClip
      {
         var _loc8_:* = undefined;
         var _loc9_:___LayerProp___ = null;
         if(param3 < MIN_Z)
         {
            param3 = MIN_Z;
         }
         else if(param3 > MAX_Z)
         {
            param3 = MAX_Z;
         }
         if(!param1 is MovieClip)
         {
            return null;
         }
         var _loc5_:* = MovieClip(param1);
         if(param2 == "Camera")
         {
            param2 = "___camera___instance";
            if(_loc8_ = _loc5_.getChildByName(param2))
            {
               _loc5_.removeChild(_loc8_);
            }
            return null;
         }
         var _loc6_:* = 2;
         var _loc7_:MovieClip;
         if((_loc7_ = MovieClip(_loc5_.getChildByName(param2))) != null)
         {
            return _loc7_;
         }
         (_loc7_ = new MovieClip()).name = param2;
         _loc7_["containerType"] = _loc6_;
         _loc5_.addChildAt(_loc7_,0);
         if(_loc6_ > 0)
         {
            (_loc9_ = new ___LayerProp___()).name = ___propertyContainerName___(param2);
            _loc9_.z = param3;
            _loc9_["containerType"] = 1;
            _loc9_["isAttachedToCamera"] = param4;
            _loc9_["layerIndex"] = ___findHighestLayerIndex___(_loc5_) + 1;
            _loc9_["layerDepth"] = 0;
            _loc5_.addChildAt(_loc9_,1);
            _loc9_.init();
         }
         return _loc7_;
      }
      
      public static function layersPublishedAsMovieClips(param1:DisplayObject) : Boolean
      {
         var _loc4_:* = undefined;
         if(!param1 is MovieClip)
         {
            return false;
         }
         var _loc2_:* = MovieClip(param1);
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            if((_loc4_ = _loc2_.getChildAt(_loc3_)) is MovieClip && _loc4_["containerType"] != undefined)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}
