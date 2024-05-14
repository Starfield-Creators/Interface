package Shared
{
   public class TextUtils
   {
       
      
      public function TextUtils()
      {
         super();
      }
      
      public static function TruncateNumericText(param1:Number, param2:Number = 3, param3:String = "+") : String
      {
         var _loc6_:* = undefined;
         var _loc4_:*;
         var _loc5_:Number = (_loc4_ = param1.toString()).length;
         if(param3)
         {
            param2 -= param3.length;
         }
         if(_loc5_ > param2)
         {
            _loc6_ = 0;
            _loc4_ = "";
            _loc6_ = 0;
            while(_loc6_ < param2)
            {
               _loc4_ += "9";
               _loc6_++;
            }
            _loc4_ += param3;
         }
         return _loc4_;
      }
      
      public static function TrimString(param1:String) : String
      {
         return param1.replace(/^\s+|\s+$/g,"");
      }
   }
}
