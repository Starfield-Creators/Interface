package fl.motion
{
   import flash.filters.BitmapFilter;
   import flash.utils.*;
   
   public class Keyframe extends KeyframeBase
   {
       
      
      public var tweens:Array;
      
      public var tweenScale:Boolean = true;
      
      public var tweenSnap:Boolean = false;
      
      public var tweenSync:Boolean = false;
      
      public function Keyframe(param1:XML = null)
      {
         super(param1);
         this.tweens = [];
         this.parseXML(param1);
      }
      
      private static function splitNumber(param1:String) : Array
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = Number(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function splitUint(param1:String) : Array
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = parseInt(_loc2_[_loc3_]) as uint;
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function splitInt(param1:String) : Array
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = parseInt(_loc2_[_loc3_]) as int;
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function parseXML(param1:XML = null) : KeyframeBase
      {
         var indexString:String;
         var indexValue:int;
         var tweenableNames:Array;
         var tweenableName:String = null;
         var elements:XMLList = null;
         var filtersArray:Array = null;
         var child:XML = null;
         var bgColorStr:String = null;
         var attribute:XML = null;
         var attributeValue:String = null;
         var name:String = null;
         var tweenChildren:XMLList = null;
         var tweenChild:XML = null;
         var tweenName:String = null;
         var filtersChildren:XMLList = null;
         var filterXML:XML = null;
         var filterName:String = null;
         var filterClassName:String = null;
         var filterClass:Object = null;
         var filterInstance:BitmapFilter = null;
         var filterTypeInfo:XML = null;
         var accessorList:XMLList = null;
         var ratios:Array = null;
         var attrib:XML = null;
         var attribName:String = null;
         var accessor:XML = null;
         var attribType:String = null;
         var attribValue:String = null;
         var uintValue:uint = 0;
         var valuesArray:Array = null;
         var xml:XML = param1;
         if(!xml)
         {
            return this;
         }
         indexString = xml.@index.toXMLString();
         indexValue = parseInt(indexString);
         if(indexString)
         {
            this.index = indexValue;
            if(xml.@label.length())
            {
               this.label = xml.@label;
            }
            if(xml.@tweenScale.length())
            {
               this.tweenScale = xml.@tweenScale.toString() == "true";
            }
            if(xml.@tweenSnap.length())
            {
               this.tweenSnap = xml.@tweenSnap.toString() == "true";
            }
            if(xml.@tweenSync.length())
            {
               this.tweenSync = xml.@tweenSync.toString() == "true";
            }
            if(xml.@blendMode.length())
            {
               this.blendMode = xml.@blendMode;
            }
            if(xml.@cacheAsBitmap.length())
            {
               this.cacheAsBitmap = xml.@cacheAsBitmap.toString() == "true";
            }
            if(xml.@opaqueBackground.length())
            {
               bgColorStr = xml.@opaqueBackground.toString();
               if(bgColorStr == "null")
               {
                  this.opaqueBackground = null;
               }
               else
               {
                  this.opaqueBackground = parseInt(bgColorStr);
               }
            }
            if(xml.@visible.length())
            {
               this.visible = xml.@visible.toString() == "true";
            }
            if(xml.@rotateDirection.length())
            {
               this.rotateDirection = xml.@rotateDirection;
            }
            if(xml.@rotateTimes.length())
            {
               this.rotateTimes = parseInt(xml.@rotateTimes);
            }
            if(xml.@orientToPath.length())
            {
               this.orientToPath = xml.@orientToPath.toString() == "true";
            }
            if(xml.@blank.length())
            {
               this.blank = xml.@blank.toString() == "true";
            }
            tweenableNames = ["x","y","scaleX","scaleY","rotation","skewX","skewY"];
            for each(tweenableName in tweenableNames)
            {
               attribute = xml.attribute(tweenableName)[0];
               if(attribute)
               {
                  attributeValue = attribute.toString();
                  if(attributeValue)
                  {
                     this[tweenableName] = Number(attributeValue);
                  }
               }
            }
            elements = xml.elements();
            filtersArray = [];
            for each(child in elements)
            {
               name = String(child.localName());
               if(name == "tweens")
               {
                  tweenChildren = child.elements();
                  for each(tweenChild in tweenChildren)
                  {
                     tweenName = String(tweenChild.localName());
                     if(tweenName == "SimpleEase")
                     {
                        this.tweens.push(new SimpleEase(tweenChild));
                     }
                     else if(tweenName == "CustomEase")
                     {
                        this.tweens.push(new CustomEase(tweenChild));
                     }
                     else if(tweenName == "BezierEase")
                     {
                        this.tweens.push(new BezierEase(tweenChild));
                     }
                     else if(tweenName == "FunctionEase")
                     {
                        this.tweens.push(new FunctionEase(tweenChild));
                     }
                  }
               }
               else if(name == "filters")
               {
                  filtersChildren = child.elements();
                  for each(filterXML in filtersChildren)
                  {
                     filterName = String(filterXML.localName());
                     filterClassName = "flash.filters." + filterName;
                     if(filterName != "AdjustColorFilter")
                     {
                        filterClass = getDefinitionByName(filterClassName);
                        filterInstance = new filterClass();
                        filterTypeInfo = describeType(filterInstance);
                        accessorList = filterTypeInfo.accessor;
                        ratios = [];
                        for each(attrib in filterXML.attributes())
                        {
                           attribName = String(attrib.localName());
                           accessor = accessorList.(@name == attribName)[0];
                           attribType = accessor.@type;
                           attribValue = attrib.toString();
                           if(attribType == "int")
                           {
                              filterInstance[attribName] = parseInt(attribValue);
                           }
                           else if(attribType == "uint")
                           {
                              filterInstance[attribName] = parseInt(attribValue) as uint;
                              uintValue = parseInt(attribValue) as uint;
                           }
                           else if(attribType == "Number")
                           {
                              filterInstance[attribName] = Number(attribValue);
                           }
                           else if(attribType == "Boolean")
                           {
                              filterInstance[attribName] = attribValue == "true";
                           }
                           else if(attribType == "Array")
                           {
                              attribValue = attribValue.substring(1,attribValue.length - 1);
                              valuesArray = null;
                              if(attribName == "ratios" || attribName == "colors")
                              {
                                 valuesArray = splitUint(attribValue);
                              }
                              else if(attribName == "alphas")
                              {
                                 valuesArray = splitNumber(attribValue);
                              }
                              if(attribName == "ratios")
                              {
                                 ratios = valuesArray;
                              }
                              else if(valuesArray)
                              {
                                 filterInstance[attribName] = valuesArray;
                              }
                           }
                           else if(attribType == "String")
                           {
                              filterInstance[attribName] = attribValue;
                           }
                        }
                        if(ratios.length)
                        {
                           filterInstance["ratios"] = ratios;
                        }
                        filtersArray.push(filterInstance);
                     }
                  }
               }
               else if(name == "color")
               {
                  this.color = Color.fromXML(child);
               }
               this.filters = filtersArray;
            }
            return this;
         }
         throw new Error("<Keyframe> is missing the required attribute \"index\".");
      }
      
      public function getTween(param1:String = "") : ITween
      {
         var _loc2_:ITween = null;
         for each(_loc2_ in this.tweens)
         {
            if(_loc2_.target == param1 || _loc2_.target == "rotation" && (param1 == "skewX" || param1 == "skewY") || _loc2_.target == "position" && (param1 == "x" || param1 == "y") || _loc2_.target == "scale" && (param1 == "scaleX" || param1 == "scaleY"))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override protected function hasTween() : Boolean
      {
         return this.getTween() != null;
      }
      
      override public function get tweensLength() : int
      {
         return this.tweens.length;
      }
   }
}
