package
{
   import Shared.AS3.BSScrollingTree;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class FilterList extends BSScrollingTree
   {
      
      public static const StarMapMenu_OnToggleFilter:String = "StarMapMenu_OnToggleFilter";
       
      
      public var FilterTitle_tf:TextField;
      
      public var TotalFiltersActive_tf:MovieClip;
      
      private var FilterListEntriesData:Object;
      
      public function FilterList()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnToggleFilter);
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnFilterSelectionChange);
      }
      
      public function OnAddedToStage() : void
      {
      }
      
      private function OnFilterSelectionChange(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuStarmapRolloverFlash");
      }
      
      private function OnToggleFilter() : void
      {
         (GetClipByIndex(selectedClipIndex) as FilterListEntry).SetFilterState(!selectedEntry.filterEnabled);
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_OnToggleFilter,{"flagValue":selectedEntry.flagValue}));
      }
   }
}
