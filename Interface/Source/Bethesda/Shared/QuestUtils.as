package Shared
{
   public class QuestUtils
   {
      
      public static const ACTIVITY_QUEST_TYPE:* = EnumHelper.GetEnum(0);
      
      public static const MAIN_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const FACTION_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const MISC_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const MISSION_QUEST_TYPE:* = EnumHelper.GetEnum();
      
      public static const COMPLETED_QUEST_TYPE:* = EnumHelper.GetEnum();
       
      
      public function QuestUtils()
      {
         super();
      }
      
      public static function GetQuestIconLabel(param1:int, param2:int) : String
      {
         if(param2 == ACTIVITY_QUEST_TYPE)
         {
            return "Activities";
         }
         if(param1 == FactionUtils.FACTION_NONE)
         {
            switch(param2)
            {
               case MISC_QUEST_TYPE:
                  return "Misc";
               case MISSION_QUEST_TYPE:
                  return "Missions";
               default:
                  return "None";
            }
         }
         else
         {
            return FactionUtils.GetFactionIconLabel(param1);
         }
      }
   }
}
