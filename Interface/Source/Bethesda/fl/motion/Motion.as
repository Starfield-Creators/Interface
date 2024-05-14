package fl.motion
{
   import flash.filters.*;
   import flash.geom.ColorTransform;
   import flash.utils.*;
   
   public class Motion extends MotionBase
   {
      
      private static var typeCache:Object = {};
       
      
      public var source:Source;
      
      private var _keyframesCompact:Array;
      
      public function Motion(param1:XML = null)
      {
         var _loc2_:Keyframe = null;
         super();
         this.keyframes = [];
         this.parseXML(param1);
         if(!this.source)
         {
            this.source = new Source();
         }
         if(this.duration == 0)
         {
            _loc2_ = this.getNewKeyframe() as Keyframe;
            _loc2_.index = 0;
            this.addKeyframe(_loc2_);
         }
      }
      
      public static function fromXMLString(param1:String) : Motion
      {
         var _loc2_:XML = new XML(param1);
         return new Motion(_loc2_);
      }
      
      public static function interpolateFilters(param1:Array, param2:Array, param3:Number) : Array
      {
         var _loc6_:BitmapFilter = null;
         var _loc7_:BitmapFilter = null;
         var _loc8_:BitmapFilter = null;
         if(param1.length != param2.length)
         {
            return null;
         }
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = param2[_loc5_];
            if(_loc8_ = interpolateFilter(_loc6_,_loc7_,param3))
            {
               _loc4_.push(_loc8_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function interpolateFilter(param1:BitmapFilter, param2:BitmapFilter, param3:Number) : BitmapFilter
      {
         var _loc8_:XML = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:uint = 0;
         var _loc24_:Number = NaN;
         var _loc25_:int = 0;
         var _loc26_:Number = NaN;
         var _loc27_:uint = 0;
         var _loc28_:Number = NaN;
         var _loc29_:int = 0;
         var _loc30_:uint = 0;
         var _loc31_:Number = NaN;
         if(!param2 || param1["constructor"] != param2["constructor"])
         {
            return param1;
         }
         if(param3 > 1)
         {
            param3 = 1;
         }
         else if(param3 < 0)
         {
            param3 = 0;
         }
         var _loc4_:Number = 1 - param3;
         var _loc5_:BitmapFilter = param1.clone();
         var _loc6_:XML;
         var _loc7_:XMLList = (_loc6_ = getTypeInfo(param1)).accessor;
         for each(_loc8_ in _loc7_)
         {
            _loc9_ = String(_loc8_.@name.toString());
            if((_loc10_ = _loc8_.@type) == "Number" || _loc10_ == "int")
            {
               _loc5_[_loc9_] = param1[_loc9_] * _loc4_ + param2[_loc9_] * param3;
               continue;
            }
            if(_loc10_ != "uint")
            {
               continue;
            }
            switch(_loc9_)
            {
               case "color":
               case "highlightColor":
               case "shadowColor":
                  _loc11_ = uint(param1[_loc9_]);
                  _loc12_ = uint(param2[_loc9_]);
                  _loc13_ = Color.interpolateColor(_loc11_,_loc12_,param3);
                  _loc5_[_loc9_] = _loc13_;
                  break;
               default:
                  _loc5_[_loc9_] = param1[_loc9_] * _loc4_ + param2[_loc9_] * param3;
                  break;
            }
         }
         if(param1 is GradientGlowFilter || param1 is GradientBevelFilter)
         {
            _loc14_ = [];
            _loc15_ = [];
            _loc16_ = [];
            _loc17_ = int(param1["ratios"].length);
            _loc18_ = int(param2["ratios"].length);
            _loc19_ = Math.max(_loc17_,_loc18_);
            _loc20_ = 0;
            while(_loc20_ < _loc19_)
            {
               _loc21_ = Math.min(_loc20_,_loc17_ - 1);
               _loc22_ = Number(param1["ratios"][_loc21_]);
               _loc23_ = uint(param1["colors"][_loc21_]);
               _loc24_ = Number(param1["alphas"][_loc21_]);
               _loc25_ = Math.min(_loc20_,_loc18_ - 1);
               _loc26_ = Number(param2["ratios"][_loc25_]);
               _loc27_ = uint(param2["colors"][_loc25_]);
               _loc28_ = Number(param2["alphas"][_loc25_]);
               _loc29_ = _loc22_ * _loc4_ + _loc26_ * param3;
               _loc30_ = Color.interpolateColor(_loc23_,_loc27_,param3);
               _loc31_ = _loc24_ * _loc4_ + _loc28_ * param3;
               _loc14_[_loc20_] = _loc29_;
               _loc15_[_loc20_] = _loc30_;
               _loc16_[_loc20_] = _loc31_;
               _loc20_++;
            }
            _loc5_["colors"] = _loc15_;
            _loc5_["alphas"] = _loc16_;
            _loc5_["ratios"] = _loc14_;
         }
         return _loc5_;
      }
      
      private static function getTypeInfo(param1:*) : XML
      {
         var _loc2_:String = "";
         if(param1 is String)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = getQualifiedClassName(param1);
         }
         if(_loc2_ in typeCache)
         {
            return typeCache[_loc2_];
         }
         if(param1 is String)
         {
            param1 = getDefinitionByName(param1);
         }
         return typeCache[_loc2_] = describeType(param1);
      }
      
      public function get keyframesCompact() : Array
      {
         var _loc1_:KeyframeBase = null;
         this._keyframesCompact = [];
         for each(_loc1_ in this.keyframes)
         {
            if(_loc1_)
            {
               this._keyframesCompact.push(_loc1_);
            }
         }
         return this._keyframesCompact;
      }
      
      public function set keyframesCompact(param1:Array) : void
      {
         var _loc2_:KeyframeBase = null;
         this._keyframesCompact = param1.concat();
         this.keyframes = [];
         for each(_loc2_ in this._keyframesCompact)
         {
            this.addKeyframe(_loc2_);
         }
      }
      
      override public function getColorTransform(param1:int) : ColorTransform
      {
         var _loc7_:Keyframe = null;
         var _loc8_:ColorTransform = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:ColorTransform = null;
         var _loc3_:Keyframe = this.getCurrentKeyframe(param1,"color") as Keyframe;
         if(!_loc3_ || !_loc3_.color)
         {
            return null;
         }
         var _loc4_:ColorTransform = _loc3_.color;
         var _loc5_:Number = param1 - _loc3_.index;
         var _loc6_:ITween = _loc3_.getTween("color") || _loc3_.getTween("alpha") || _loc3_.getTween();
         if(_loc5_ == 0 || !_loc6_)
         {
            _loc2_ = _loc4_;
         }
         else if(_loc6_)
         {
            if(!(_loc7_ = this.getNextKeyframe(param1,"color") as Keyframe) || !_loc7_.color)
            {
               _loc2_ = _loc4_;
            }
            else
            {
               _loc8_ = _loc7_.color;
               _loc9_ = _loc7_.index - _loc3_.index;
               _loc10_ = _loc6_.getValue(_loc5_,0,1,_loc9_);
               _loc2_ = Color.interpolateTransform(_loc4_,_loc8_,_loc10_);
            }
         }
         return _loc2_;
      }
      
      override public function getFilters(param1:Number) : Array
      {
         var _loc7_:Keyframe = null;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Array = null;
         var _loc3_:Keyframe = this.getCurrentKeyframe(param1,"filters") as Keyframe;
         if(!_loc3_ || _loc3_.filters && !_loc3_.filters.length)
         {
            return [];
         }
         var _loc4_:Array = _loc3_.filters;
         var _loc5_:Number = param1 - _loc3_.index;
         var _loc6_:ITween = _loc3_.getTween("filters") || _loc3_.getTween();
         if(_loc5_ == 0 || !_loc6_)
         {
            _loc2_ = _loc4_;
         }
         else if(_loc6_)
         {
            if(!(_loc7_ = this.getNextKeyframe(param1,"filters") as Keyframe) || !_loc7_.filters.length)
            {
               _loc2_ = _loc4_;
            }
            else
            {
               _loc8_ = _loc7_.filters;
               _loc9_ = _loc7_.index - _loc3_.index;
               _loc10_ = _loc6_.getValue(_loc5_,0,1,_loc9_);
               _loc2_ = interpolateFilters(_loc4_,_loc8_,_loc10_);
            }
         }
         return _loc2_;
      }
      
      override protected function findTweenedValue(param1:Number, param2:String, param3:KeyframeBase, param4:Number, param5:Number) : Number
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc6_:Keyframe;
         if(!(_loc6_ = param3 as Keyframe))
         {
            return NaN;
         }
         var _loc7_:ITween;
         if(!(_loc7_ = _loc6_.getTween(param2) || _loc6_.getTween()) || !_loc6_.tweenScale && (param2 == Tweenables.SCALE_X || param2 == Tweenables.SCALE_Y) || _loc6_.rotateDirection == RotateDirection.NONE && (param2 == Tweenables.ROTATION || param2 == Tweenables.SKEW_X || param2 == Tweenables.SKEW_Y))
         {
            return param5;
         }
         var _loc8_:String = param2;
         if(_loc7_.target == "")
         {
            _loc8_ = "";
         }
         var _loc9_:Keyframe;
         if(!(_loc9_ = this.getNextKeyframe(param1,_loc8_) as Keyframe) || _loc9_.blank)
         {
            return param5;
         }
         _loc10_ = _loc9_.getValue(param2);
         if(isNaN(_loc10_))
         {
            _loc10_ = param5;
         }
         _loc11_ = _loc10_ - param5;
         if(param2 == Tweenables.SKEW_X || param2 == Tweenables.SKEW_Y || param2 == Tweenables.ROTATION)
         {
            if(_loc6_.rotateDirection == RotateDirection.AUTO)
            {
               if((_loc11_ %= 360) > 180)
               {
                  _loc11_ -= 360;
               }
               else if(_loc11_ < -180)
               {
                  _loc11_ += 360;
               }
            }
            else if(_loc6_.rotateDirection == RotateDirection.CW)
            {
               if(_loc11_ < 0)
               {
                  _loc11_ = _loc11_ % 360 + 360;
               }
               _loc11_ += _loc6_.rotateTimes * 360;
            }
            else
            {
               if(_loc11_ > 0)
               {
                  _loc11_ = _loc11_ % 360 - 360;
               }
               _loc11_ -= _loc6_.rotateTimes * 360;
            }
         }
         _loc12_ = _loc9_.index - _loc6_.index;
         return _loc7_.getValue(param4,param5,_loc11_,_loc12_);
      }
      
      private function parseXML(param1:XML) : Motion
      {
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         if(!param1)
         {
            return this;
         }
         if(param1.@duration.length())
         {
            this.duration = parseInt(param1.@duration);
         }
         var _loc2_:XMLList = param1.elements();
         var _loc3_:Number = 0;
         while(_loc3_ < _loc2_.length())
         {
            if((_loc4_ = _loc2_[_loc3_]).localName() == "source")
            {
               _loc5_ = _loc4_.children()[0];
               this.source = new Source(_loc5_);
            }
            else if(_loc4_.localName() == "Keyframe")
            {
               this.addKeyframe(this.getNewKeyframe(_loc4_));
            }
            _loc3_++;
         }
         return this;
      }
      
      override protected function getNewKeyframe(param1:XML = null) : KeyframeBase
      {
         return new Keyframe(param1);
      }
   }
}
