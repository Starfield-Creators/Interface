package Shared
{
   public class ShipInfoUtils
   {
      
      public static const MT_WEAPON:uint = EnumHelper.GetEnum(0);
      
      public static const MT_ENGINE:uint = EnumHelper.GetEnum();
      
      public static const MT_SHIELD:uint = EnumHelper.GetEnum();
      
      public static const MT_GRAV:uint = EnumHelper.GetEnum();
      
      public static const MT_COUNT:uint = EnumHelper.GetEnum();
      
      public static const SH_MODE_FIRST_PERSON:uint = EnumHelper.GetEnum(0);
      
      public static const SH_MODE_THIRD_PERSON:uint = EnumHelper.GetEnum();
      
      public static const SH_MODE_FREE_LOOK:uint = EnumHelper.GetEnum();
      
      public static const SH_MODE_FAR_TRAVEL:uint = EnumHelper.GetEnum();
      
      public static const REACTOR_INVALID:int = EnumHelper.GetEnum(-1);
      
      public static const REACTOR_A:int = EnumHelper.GetEnum();
      
      public static const REACTOR_B:int = EnumHelper.GetEnum();
      
      public static const REACTOR_C:int = EnumHelper.GetEnum();
      
      public static const REACTOR_M:int = EnumHelper.GetEnum();
       
      
      public function ShipInfoUtils()
      {
         super();
      }
      
      public static function GetReactorClassString(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case REACTOR_B:
               _loc2_ = "ReactorClassB";
               break;
            case REACTOR_C:
               _loc2_ = "ReactorClassC";
               break;
            case REACTOR_M:
               _loc2_ = "ReactorClassM";
               break;
            case REACTOR_A:
            default:
               _loc2_ = "ReactorClassA";
         }
         return _loc2_;
      }
   }
}
