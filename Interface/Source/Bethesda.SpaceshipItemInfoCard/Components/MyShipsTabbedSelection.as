package Components
{
   import Shared.AS3.BSTabbedSelection;
   
   public class MyShipsTabbedSelection extends BSTabbedSelection
   {
      
      private static const TAB_SPACING:Number = 5;
       
      
      public function MyShipsTabbedSelection()
      {
         super();
      }
      
      public function ToggleDisplayedShips() : void
      {
         MoveSelectionRight();
      }
      
      override protected function PositionEntries() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:MyShipsTab = null;
         if(numTabs <= 0)
         {
            return;
         }
         if(Alignment == CENTER_ALIGNED)
         {
            _loc1_ = (Border_mc.width - TAB_SPACING * (numTabs - 1)) / numTabs;
            _loc2_ = _loc1_ + TAB_SPACING;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < numTabs)
            {
               (_loc5_ = MyShipsTab(GetClipByIndex(_loc4_))).Border_mc.width = _loc1_;
               _loc5_.Highlight_mc.width = _loc1_;
               _loc5_.x = _loc3_;
               _loc3_ += _loc2_;
               _loc4_++;
            }
         }
         else
         {
            super.PositionEntries();
         }
      }
   }
}
