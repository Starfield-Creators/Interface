package
{
   import Shared.EnumHelper;
   
   public class ShipCrewUtils
   {
      
      public static const CREW_TYPE_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const CREW_TYPE_CREW:uint = EnumHelper.GetEnum();
      
      public static const CREW_TYPE_ELITE:uint = EnumHelper.GetEnum();
      
      public static const CREW_TYPE_COMPANION:uint = EnumHelper.GetEnum();
      
      public static const ASSIGNMENT_TYPE_SHIP:uint = EnumHelper.GetEnum(0);
      
      public static const ASSIGNMENT_TYPE_OUTPOST:uint = EnumHelper.GetEnum();
      
      public static const ASSIGNMENT_TYPE_MISC:uint = EnumHelper.GetEnum();
      
      public static const ASSIGNMENT_TYPE_UNASSIGNED:uint = EnumHelper.GetEnum();
      
      public static const ASSIGNMENT_TYPE_COUNT:uint = EnumHelper.GetEnum();
      
      public static const ASSIGNMENT_TYPE_FLAG_SHIP:uint = AssignmentTypeToFlag(ASSIGNMENT_TYPE_SHIP);
      
      public static const ASSIGNMENT_TYPE_FLAG_OUTPOST:uint = AssignmentTypeToFlag(ASSIGNMENT_TYPE_OUTPOST);
      
      public static const ASSIGNMENT_TYPE_FLAG_MISC:uint = AssignmentTypeToFlag(ASSIGNMENT_TYPE_MISC);
      
      public static const ASSIGNMENT_TYPE_FLAG_UNASSIGNED:uint = AssignmentTypeToFlag(ASSIGNMENT_TYPE_UNASSIGNED);
      
      public static const ASSIGNMENT_TYPE_FLAG_ALL:uint = ASSIGNMENT_TYPE_FLAG_SHIP | ASSIGNMENT_TYPE_FLAG_OUTPOST | ASSIGNMENT_TYPE_FLAG_MISC | ASSIGNMENT_TYPE_FLAG_UNASSIGNED;
       
      
      public function ShipCrewUtils()
      {
         super();
      }
      
      public static function AssignmentTypeToLocString(param1:uint) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case ASSIGNMENT_TYPE_SHIP:
               _loc2_ = "$Ship";
               break;
            case ASSIGNMENT_TYPE_OUTPOST:
               _loc2_ = "$Outpost";
               break;
            case ASSIGNMENT_TYPE_UNASSIGNED:
               _loc2_ = "$Unassigned";
               break;
            default:
               _loc2_ = "$Unknown";
         }
         return _loc2_;
      }
      
      public static function AssignmentTypeToFlag(param1:uint) : *
      {
         return 1 << param1;
      }
   }
}
