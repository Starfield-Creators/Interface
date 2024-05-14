package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.EnumHelper;
   
   public class ShipStatBase extends BSDisplayObject
   {
      
      protected static const STAT_REACTOR_A:String = "ReactorClassA";
      
      protected static const STAT_REACTOR_B:String = "ReactorClassB";
      
      protected static const STAT_REACTOR_C:String = "ReactorClassC";
      
      protected static const STAT_REACTOR_M:String = "ReactorClassM";
      
      protected static const STAT_MASS:String = "Mass";
      
      protected static const STAT_DAMAGE:String = "Damage";
      
      protected static const STAT_HULL:String = "Hull";
      
      protected static const STAT_CARGO:String = "Cargo";
      
      protected static const STAT_CREW:String = "Crew";
      
      protected static const STAT_JUMP_RANGE:String = "JumpRange";
      
      protected static const STAT_SHIELD:String = "Speed";
      
      protected static const VALUE_EQUAL:String = "equal";
      
      protected static const VALUE_LESS:String = "less";
      
      protected static const VALUE_GREATER:String = "greater";
      
      protected static const VALUE_LESS_INVERTED:String = "less_inverted";
      
      protected static const VALUE_GREATER_INVERTED:String = "greater_inverted";
      
      public static const STAT_TYPE_REACTOR_A:int = EnumHelper.GetEnum(0);
      
      public static const STAT_TYPE_REACTOR_B:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_REACTOR_C:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_REACTOR_M:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_MASS:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_DAMAGE:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_HULL:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_CARGO:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_CREW:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_JUMP_RANGE:int = EnumHelper.GetEnum();
      
      public static const STAT_TYPE_SHIELD:int = EnumHelper.GetEnum();
      
      protected static const PADDING:int = 4;
       
      
      public function ShipStatBase()
      {
         super();
      }
   }
}
