package Shared
{
   public class EnumHelper
   {
      
      private static var Counter:int = 0;
       
      
      public function EnumHelper()
      {
         super();
      }
      
      public static function GetEnum(param1:int = -2147483648) : int
      {
         if(param1 == int.MIN_VALUE)
         {
            param1 = Counter;
         }
         else
         {
            Counter = param1;
         }
         ++Counter;
         return param1;
      }
   }
}
