package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.BSScrollingListEntry;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class QuickSystemSelect extends BSScrollingList
   {
      
      public static const StarMapMenu_FocusSystem:String = "StarMapMenu_Galaxy_FocusSystem";
      
      public static const StarMapMenu_OnCancel:String = "StarMapMenu_OnCancel";
      
      public static const StarMapMenu_QuickSelectChange:String = "StarMapMenu_QuickSelectChange";
      
      public static const StarMapMenu_OnHintButtonClicked:String = "StarMapMenu_OnHintButtonClicked";
      
      internal static const LIST_ITEM_HEIGHT:Number = 30;
      
      internal static const LIST_ITEM_HEIGHT_LRG:Number = 39;
       
      
      internal const TEXT_PADDING:uint = 4;
      
      public var BorderMask:MovieClip;
      
      public var ListEntries:Number = 0;
      
      internal var buttonBarWidth:Number = 0;
      
      private var ListItemDelay:Number = 0;
      
      public var OpenForPlot:Boolean = false;
      
      public function QuickSystemSelect()
      {
         super();
         addEventListener(BSScrollingList.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(BSScrollingList.ITEM_PRESS,this.OnItemPress);
      }
      
      private function get listItemHeight() : Number
      {
         return LIST_ITEM_HEIGHT;
      }
      
      override protected function PositionEntries() : *
      {
         var _loc2_:BSScrollingListEntry = null;
         var _loc3_:Rectangle = null;
         super.PositionEntries();
         var _loc1_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         this.ListItemDelay = 0.1;
         _loc6_ = 0;
         while(_loc6_ < iListItemsShown)
         {
            _loc2_ = GetClipByIndex(_loc6_);
            _loc3_ = _loc2_.getBounds(this);
            _loc5_ = _loc2_.x - _loc3_.x;
            _loc2_.y = fListUpperBound + _loc1_ + _loc4_;
            _loc2_.x = fListLeftBound + _loc5_;
            _loc1_ += this.listItemHeight;
            _loc6_++;
         }
      }
      
      override protected function HandleFiltererChange() : *
      {
         super.HandleFiltererChange();
         if(EntryHolder_mc != null)
         {
            eaze(EntryHolder_mc).easing(Quadratic.easeOut).apply({
               "alpha":0,
               "visible":true
            }).delay(0.2).to(0.15,{"alpha":1});
         }
         if(ScrollBar != null && EntriesA.length > uiNumListItems)
         {
            eaze(ScrollBar).easing(Quadratic.easeOut).apply({
               "alpha":0,
               "visible":true
            }).delay(0.2).to(1,{"alpha":1});
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2 && param1 == "Select")
         {
            this.OnItemPress();
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function OnItemPress() : void
      {
         if(this.OpenForPlot)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_OnHintButtonClicked,{"buttonAction":"SetRouteDestination"}));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new Event(StarMapMenu_FocusSystem,true));
         }
      }
      
      private function OnSelectionChange(param1:Event) : *
      {
         if(selectedIndex >= 0)
         {
            GlobalFunc.PlayMenuSound("UIMenuStarmapRolloverFlash");
            BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_QuickSelectChange,{"bodyID":entryList[selectedIndex].uBodyID}));
         }
      }
      
      public function SetMarkers(param1:Array) : *
      {
         this.entryList = param1;
      }
   }
}
