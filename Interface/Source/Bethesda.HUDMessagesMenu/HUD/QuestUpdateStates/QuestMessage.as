package HUD.QuestUpdateStates
{
   import Shared.EnumHelper;
   
   public class QuestMessage
   {
      
      public static const INVALID:uint = EnumHelper.GetEnum(0);
      
      public static const QUEST_SET_ACTIVE:uint = EnumHelper.GetEnum();
      
      public static const QUEST_SET_INACTIVE:uint = EnumHelper.GetEnum();
      
      public static const QUEST_ADDED:uint = EnumHelper.GetEnum();
      
      public static const QUEST_COMPLETED:uint = EnumHelper.GetEnum();
      
      public static const QUEST_FAILED:uint = EnumHelper.GetEnum();
      
      public static const HDT_QUEST_TEXT_UPDATED:uint = EnumHelper.GetEnum();
      
      public static const QUEST_TIMER_UPDATED:uint = EnumHelper.GetEnum();
      
      public static const OBJECTIVE_ADDED:uint = EnumHelper.GetEnum();
      
      public static const OBJECTIVE_COMPLETED:uint = EnumHelper.GetEnum();
      
      public static const OBJECTIVE_FAILED:uint = EnumHelper.GetEnum();
      
      public static const OBJECTIVE_DISPLAYED:uint = EnumHelper.GetEnum();
      
      public static const OBJECTIVE_DORMANT:uint = EnumHelper.GetEnum();
      
      public static const OBJECTIVE_MOVE_TO_TOP:uint = EnumHelper.GetEnum();
      
      public static const SET_MODE:uint = EnumHelper.GetEnum();
      
      public static const SHOW_SUBTITLE:uint = EnumHelper.GetEnum();
      
      public static const HIDE_SUBTITLE:uint = EnumHelper.GetEnum();
      
      public static const UPDATE_HUD_OPACITY:uint = EnumHelper.GetEnum();
      
      public static const SHOW_HIT_MARKER:uint = EnumHelper.GetEnum();
      
      public static const LOCATION_DISCOVERED:uint = EnumHelper.GetEnum();
      
      public static const SHOW_LOCATION:uint = EnumHelper.GetEnum();
      
      public static const QUEST_EXPERIENCE_AWARDED:uint = EnumHelper.GetEnum();
      
      public static const QUEST_REJECTED:uint = EnumHelper.GetEnum();
       
      
      public function QuestMessage()
      {
         super();
      }
   }
}
