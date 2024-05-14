package Shared
{
   public class FactionUtils
   {
      
      public static const FACTION_NONE:* = EnumHelper.GetEnum(-1);
      
      public static const FACTION_PARADISO:* = EnumHelper.GetEnum();
      
      public static const FACTION_UNITEDCOLONIES:* = EnumHelper.GetEnum();
      
      public static const FACTION_RYUJININDUSTRIES:* = EnumHelper.GetEnum();
      
      public static const FACTION_HOUSEVARUUN:* = EnumHelper.GetEnum();
      
      public static const FACTION_FREESTAR:* = EnumHelper.GetEnum();
      
      public static const FACTION_BLACKFLEET:* = EnumHelper.GetEnum();
      
      public static const FACTION_CONSTELLATION:* = EnumHelper.GetEnum();
       
      
      public function FactionUtils()
      {
         super();
      }
      
      public static function GetFactionIconLabel(param1:int) : String
      {
         var _loc2_:String = "Constellation";
         switch(param1)
         {
            case FACTION_BLACKFLEET:
               _loc2_ = "BlackFleet";
               break;
            case FACTION_FREESTAR:
               _loc2_ = "FreestarCollective";
               break;
            case FACTION_HOUSEVARUUN:
               _loc2_ = "HouseVa’ruun";
               break;
            case FACTION_RYUJININDUSTRIES:
               _loc2_ = "RyujinIndustries";
               break;
            case FACTION_UNITEDCOLONIES:
               _loc2_ = "UnitedColonies";
               break;
            case FACTION_CONSTELLATION:
               _loc2_ = "Constellation";
               break;
            case FACTION_PARADISO:
            case FACTION_NONE:
            default:
               _loc2_ = "None";
         }
         return _loc2_;
      }
      
      public static function GetFactionName(param1:int) : String
      {
         var _loc2_:String = "$Constellation";
         switch(param1)
         {
            case FactionUtils.FACTION_BLACKFLEET:
               _loc2_ = "$CrimsonFleet";
               break;
            case FactionUtils.FACTION_FREESTAR:
               _loc2_ = "$FreestarCollective";
               break;
            case FactionUtils.FACTION_HOUSEVARUUN:
               _loc2_ = "$HouseVa’ruun";
               break;
            case FactionUtils.FACTION_RYUJININDUSTRIES:
               _loc2_ = "$RyujinIndustries";
               break;
            case FactionUtils.FACTION_UNITEDCOLONIES:
               _loc2_ = "$UnitedColonies";
               break;
            case FactionUtils.FACTION_CONSTELLATION:
               _loc2_ = "$Constellation";
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
   }
}
