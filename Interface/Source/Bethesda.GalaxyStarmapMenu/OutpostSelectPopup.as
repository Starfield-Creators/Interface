package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import scaleform.gfx.TextFieldEx;
   
   public class OutpostSelectPopup extends BSDisplayObject
   {
      
      public static const StarMapMenu_OnOutpostEntrySelected:String = "StarMapmenu_OnOutpostEntrySelected";
       
      
      public var List_mc:BSScrollingContainer;
      
      public function OutpostSelectPopup()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         var _loc1_:BSScrollingConfigParams = null;
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "ListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.List_mc.Configure(_loc1_);
         this.List_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemPressed);
      }
      
      public function Show() : void
      {
         this.visible = true;
         stage.focus = this.List_mc;
      }
      
      public function Hide() : void
      {
         this.visible = false;
         stage.focus = null;
      }
      
      public function SetListData(param1:Array) : void
      {
         this.List_mc.InitializeEntries(param1);
      }
      
      private function onItemPressed() : *
      {
         var _loc1_:Object = this.List_mc.selectedEntry;
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_OnOutpostEntrySelected,{"OutpostID":_loc1_.uFormID}));
      }
   }
}
