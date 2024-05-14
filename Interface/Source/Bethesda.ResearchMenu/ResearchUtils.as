package
{
   import Shared.EnumHelper;
   
   public class ResearchUtils
   {
      
      public static const NO_STATE:int = EnumHelper.GetEnum(-1);
      
      public static const LOADING_STATE:int = EnumHelper.GetEnum();
      
      public static const MAIN_LANDING_STATE:int = EnumHelper.GetEnum();
      
      public static const CATEGORY_PAGE_STATE:int = EnumHelper.GetEnum();
      
      public static const PROJECT_PAGE_STATE:int = EnumHelper.GetEnum();
      
      public static const MATERIAL_SELECTION_STATE:int = EnumHelper.GetEnum();
      
      public static const SUDDEN_DEV_STATE:int = EnumHelper.GetEnum();
      
      public static const COMPLETE_POPUP_STATE:int = EnumHelper.GetEnum();
      
      public static const MATERIAL_SORT_DEFAULT:int = EnumHelper.GetEnum(0);
      
      public static const MATERIAL_SORT_NAME:int = EnumHelper.GetEnum();
      
      public static const MATERIAL_SORT_INPUT:int = EnumHelper.GetEnum();
      
      public static const PROJECT_SORT_DEFAULT:int = EnumHelper.GetEnum(0);
      
      public static const PROJECT_SORT_NAME:int = EnumHelper.GetEnum();
      
      public static const PROJECT_SORT_STATE:int = EnumHelper.GetEnum();
      
      public static const PROJECT_FILTER_CAN_PROGRESS:int = EnumHelper.GetEnum(0);
      
      public static const PROJECT_FILTER_NONE:int = EnumHelper.GetEnum();
      
      public static const PROJECT_FILTER_HIDE_COMPLETED:int = EnumHelper.GetEnum();
      
      public static const PROJECT_FILTER_CAN_COMPLETE:int = EnumHelper.GetEnum();
      
      public static const RESEARCH_FILTER_CAN_CONTRIBUTE:int = EnumHelper.GetEnum();
      
      public static const PROJECT_FILTER_COMPLETED_ONLY:int = EnumHelper.GetEnum();
      
      public static const PROJECT_FILTER_UNLOCKED_ONLY:int = EnumHelper.GetEnum();
      
      public static const PROJECT_FILTER_COUNT:int = EnumHelper.GetEnum();
      
      public static const CATEGORY_PRESSED:String = "CategoryPressed";
      
      public static const PROJECT_PRESSED:String = "ProjectPressed";
      
      public static const SHOW_VOLUME_POPUP:String = "ShowVolumePopup";
      
      public static const CLOSE_POPUP:String = "ClosePopup";
      
      public static const VOLUME_POPUP_ACCEPT:String = "VolumePopupAccept";
      
      public static const REFRESH_BUTTON_BAR:String = "RefreshButtonBar";
      
      public static const CATEGORY_CHANGED:String = "CategoryChanged";
      
      public static const BUTTON_SPACING:uint = 10;
      
      public static const CATEGORY_LIST_SPACING:uint = 8;
      
      public static const PROJECT_LIST_SPACING:uint = 3;
      
      public static const MATERIAL_LIST_SPACING:uint = 3;
      
      public static const NUMBER_PADDING:uint = 3;
      
      public static const MAX_MATERIALS:uint = 12;
      
      public static const TREE_COLUMNS:Number = 1;
      
      public static const TREE_ROWS:Number = 5;
      
      public static const TREE_COLUMNS_SPACING:Number = 0;
      
      public static const TREE_ROWS_SPACING:Number = 3;
      
      public static const CLOSE_FRAME_LABEL:String = "Close";
      
      public static const OFF_FRAME_LABEL:String = "Off";
      
      public static const ON_FRAME_LABEL:String = "On";
      
      public static const OPEN_FRAME_LABEL:String = "Open";
      
      public static const COMPLETED_FRAME_LABEL:String = "Completed";
      
      public static const IN_PROGRESS_FRAME_LABEL:String = "InProgress";
      
      public static const MATERIAL_AVAILABLE_FRAME_LABEL:String = "MaterialAvailable";
      
      public static const NOT_STARTED_FRAME_LABEL:String = "NotStarted";
      
      public static const BLOCKED_FRAME_LABEL:String = "Blocked";
      
      public static const REQUIRED_FRAME_LABEL:String = "Required";
      
      public static const NONE_FRAME_LABEL:String = "None";
      
      public static const MENU_OPEN_SOUND:String = "UIMenuCraftingResearchMenuOpen";
      
      public static const MENU_CLOSE_SOUND:String = "UIMenuCraftingResearchMenuClose";
      
      public static const TITLE_SOUND:String = "UIMenuCraftingResearchMenuTitle";
      
      public static const OK_SOUND:String = "UIMenuCraftingResearchMenuGeneralOK";
      
      public static const CANCEL_SOUND:String = "UIMenuCraftingResearchMenuGeneralCancel";
      
      public static const FOCUS_SOUND:String = "UIMenuCraftingResearchMenuGeneralFocus";
      
      public static const NEXT_PREV_SOUND:String = "UIMenuCraftingResearchMenuGeneralCategoryNextPrev";
      
      public static const COUNTER_SOUND:String = "UIMenuCraftingResearchMenuGeneralCounter";
      
      public static const SUDDEN_DEV_SOUND:String = "UIMenuCraftingResearchMenuProjectSuddenDevelopment";
      
      public static const PROJECT_COMPLETE_SOUND:String = "UIMenuCraftingResearchMenuProjectComplete";
      
      public static const FILTER_SOUND:String = "UIMenuCraftingResearchMenuGeneralFilter";
      
      public static const SORT_SOUND:String = "UIMenuCraftingResearchMenuGeneralSort";
       
      
      public function ResearchUtils()
      {
         super();
      }
   }
}
