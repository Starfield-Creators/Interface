package Shared
{
   public class ColorUtils
   {
      
      public static const HUE_DEGREES:uint = 60;
      
      public static const HUE_MAX:uint = 360;
      
      public static const RGB_MAX:uint = 255;
      
      private static const RED_SHIFT:uint = 16;
      
      private static const GREEN_SHIFT:uint = 8;
      
      private static const GREEN_HUE:uint = 2;
      
      private static const BLUE_HUE:uint = 4;
       
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function HexToRGB(param1:uint) : RGB
      {
         var _loc2_:RGB = new RGB();
         _loc2_.r = param1 >> RED_SHIFT & 255;
         _loc2_.g = param1 >> GREEN_SHIFT & 255;
         _loc2_.b = param1 & 255;
         return _loc2_;
      }
      
      public static function HexToHSB(param1:uint) : HSB
      {
         var _loc2_:RGB = HexToRGB(param1);
         return RGBToHSB(_loc2_);
      }
      
      public static function RGBToHex(param1:Object) : uint
      {
         return RGBValuesToHex(param1.r,param1.g,param1.b);
      }
      
      public static function RGBValuesToHex(param1:uint, param2:uint, param3:uint) : uint
      {
         return uint(param1 << RED_SHIFT | param2 << GREEN_SHIFT | param3);
      }
      
      public static function HSBToHex(param1:Object) : uint
      {
         return HSBValuesToHex(param1.h,param1.s,param1.b);
      }
      
      public static function HSBValuesToHex(param1:uint, param2:uint, param3:uint) : uint
      {
         var _loc4_:RGB = HSBValuesToRGB(param1,param2,param3);
         return RGBToHex(_loc4_);
      }
      
      public static function RGBToHSB(param1:Object) : HSB
      {
         return RGBValuesToHSB(param1.r,param1.g,param1.b);
      }
      
      public static function RGBValuesToHSB(param1:uint, param2:uint, param3:uint) : HSB
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc4_:HSB = new HSB();
         var _loc5_:uint = Math.min(param1,param2,param3);
         var _loc6_:uint;
         var _loc7_:uint = uint((_loc6_ = Math.max(param1,param2,param3)) - _loc5_);
         var _loc8_:Number = _loc6_ / RGB_MAX * 100;
         _loc4_.b = Math.round(_loc8_);
         if(_loc6_ == 0)
         {
            _loc4_.s = 0;
            _loc4_.h = 0;
         }
         else
         {
            _loc9_ = _loc7_ / _loc6_ * 100;
            _loc4_.s = Math.round(_loc9_);
            if(_loc7_ == 0)
            {
               _loc4_.h = 0;
            }
            else
            {
               _loc10_ = 0;
               if(param1 == _loc6_)
               {
                  _loc10_ = (param2 - param3) / _loc7_;
               }
               else if(param2 == _loc6_)
               {
                  _loc10_ = GREEN_HUE + (param3 - param1) / _loc7_;
               }
               else
               {
                  _loc10_ = BLUE_HUE + (param1 - param2) / _loc7_;
               }
               if((_loc10_ *= HUE_DEGREES) < 0)
               {
                  _loc10_ += HUE_MAX;
               }
               _loc4_.h = Math.round(_loc10_);
            }
         }
         return _loc4_;
      }
      
      public static function HSBToRGB(param1:Object) : RGB
      {
         return HSBValuesToRGB(param1.h,param1.s,param1.b);
      }
      
      public static function HSBValuesToRGB(param1:uint, param2:uint, param3:uint) : RGB
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc4_:RGB = new RGB();
         var _loc5_:Number = param2 / 100;
         var _loc6_:Number = param3 / 100;
         if(param2 == 0)
         {
            _loc4_.r = Math.round(_loc6_ * RGB_MAX);
            _loc4_.g = Math.round(_loc6_ * RGB_MAX);
            _loc4_.b = Math.round(_loc6_ * RGB_MAX);
         }
         else
         {
            _loc7_ = param1 / HUE_DEGREES;
            _loc8_ = Math.floor(_loc7_);
            _loc9_ = _loc7_ - _loc8_;
            _loc10_ = _loc6_ * (1 - _loc5_);
            _loc11_ = _loc6_ * (1 - _loc5_ * _loc9_);
            _loc12_ = _loc6_ * (1 - _loc5_ * (1 - _loc9_));
            switch(_loc8_)
            {
               case 0:
                  _loc4_.r = Math.round(_loc6_ * RGB_MAX);
                  _loc4_.g = Math.round(_loc12_ * RGB_MAX);
                  _loc4_.b = Math.round(_loc10_ * RGB_MAX);
                  break;
               case 1:
                  _loc4_.r = Math.round(_loc11_ * RGB_MAX);
                  _loc4_.g = Math.round(_loc6_ * RGB_MAX);
                  _loc4_.b = Math.round(_loc10_ * RGB_MAX);
                  break;
               case 2:
                  _loc4_.r = Math.round(_loc10_ * RGB_MAX);
                  _loc4_.g = Math.round(_loc6_ * RGB_MAX);
                  _loc4_.b = Math.round(_loc12_ * RGB_MAX);
                  break;
               case 3:
                  _loc4_.r = Math.round(_loc10_ * RGB_MAX);
                  _loc4_.g = Math.round(_loc11_ * RGB_MAX);
                  _loc4_.b = Math.round(_loc6_ * RGB_MAX);
                  break;
               case 4:
                  _loc4_.r = Math.round(_loc12_ * RGB_MAX);
                  _loc4_.g = Math.round(_loc10_ * RGB_MAX);
                  _loc4_.b = Math.round(_loc6_ * RGB_MAX);
                  break;
               default:
                  _loc4_.r = Math.round(_loc6_ * RGB_MAX);
                  _loc4_.g = Math.round(_loc10_ * RGB_MAX);
                  _loc4_.b = Math.round(_loc11_ * RGB_MAX);
            }
         }
         return _loc4_;
      }
      
      public static function UIntToHex(param1:uint) : String
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc2_:String = "";
         var _loc3_:uint = param1;
         var _loc4_:uint = "0".charCodeAt(0);
         var _loc5_:uint = "A".charCodeAt(0);
         while(_loc3_ != 0)
         {
            if((_loc6_ = _loc3_ % 16) >= 10)
            {
               _loc7_ = uint(_loc5_ + _loc6_ - 10);
            }
            else
            {
               _loc7_ = _loc4_ + _loc6_;
            }
            _loc2_ = String.fromCharCode(_loc7_) + _loc2_;
            _loc3_ /= 16;
         }
         return _loc2_;
      }
   }
}

class HSB
{
    
   
   public var h:uint;
   
   public var s:uint;
   
   public var b:uint;
   
   public function HSB(param1:uint = 0, param2:uint = 0, param3:uint = 0)
   {
      super();
      this.h = param1;
      this.s = param2;
      this.b = param3;
   }
}

class RGB
{
    
   
   public var r:uint;
   
   public var g:uint;
   
   public var b:uint;
   
   public function RGB(param1:uint = 0, param2:uint = 0, param3:uint = 0)
   {
      super();
      this.r = param1;
      this.g = param2;
      this.b = param3;
   }
}
