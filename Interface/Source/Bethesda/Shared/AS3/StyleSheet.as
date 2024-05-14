package Shared.AS3
{
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class StyleSheet
   {
       
      
      public function StyleSheet()
      {
         super();
      }
      
      private static function aggregateSheetProperties(param1:Object, param2:Object, param3:Object, param4:Boolean = false) : *
      {
         var _loc8_:XML = null;
         var _loc9_:String = null;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc5_:String = getQualifiedClassName(param2);
         var _loc6_:XML;
         var _loc7_:XMLList = (_loc6_ = describeType(param2))..variable;
         for each(_loc8_ in _loc7_)
         {
            _loc9_ = String(_loc8_.@name);
            _loc10_ = typeof param2[_loc9_];
            _loc11_ = typeof param1[_loc9_];
            if(param1.hasOwnProperty(_loc9_))
            {
               if(_loc10_ == "function")
               {
                  throw new Error("StyleSheet:aggregateSheetProperties - Stylesheet " + _loc5_ + " contains function parameters (prohibited).");
               }
               if(_loc10_ == typeof param1[_loc9_])
               {
                  param3[_loc9_] = param2[_loc9_];
               }
               else if(!param4)
               {
                  trace("WARNING: StyleSheet:aggregateSheetProperties - Stylesheet " + _loc5_ + " : Type mismatch between source (" + _loc10_ + ") and target (" + _loc11_ + ") for property " + _loc9_);
               }
            }
            else if(!param4)
            {
               trace("WARNING: SheetSheet:aggregateSheetProperties - Stylesheet " + _loc5_ + " contains property " + _loc9_ + " which does not exist on target object.");
            }
         }
      }
      
      public static function apply(param1:Object, param2:Boolean = false, ... rest) : *
      {
         var _loc6_:String = null;
         var _loc4_:Object = new Object();
         var _loc5_:* = 0;
         while(_loc5_ < rest.length)
         {
            aggregateSheetProperties(param1,rest[_loc5_],_loc4_,param2);
            _loc5_++;
         }
         for(_loc6_ in _loc4_)
         {
            param1[_loc6_] = _loc4_[_loc6_];
         }
         if(param1.onStyleUpdated is Function)
         {
            param1.onStyleUpdated();
         }
      }
   }
}
