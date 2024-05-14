package
{
   import Shared.AS3.BSTabbedSelection;
   
   public class FlightCheckTabbedSelection extends BSTabbedSelection
   {
      
      private static const TAB_SPACING:Number = 5;
       
      
      public function FlightCheckTabbedSelection()
      {
         super();
      }
      
      override protected function PositionEntries() : void
      {
         var _loc3_:FlightCheckTab = null;
         if(numTabs <= 0)
         {
            return;
         }
         var _loc1_:Number = (Border_mc.width - TAB_SPACING * (numTabs - 1)) / numTabs;
         var _loc2_:int = 0;
         while(_loc2_ < numTabs)
         {
            _loc3_ = FlightCheckTab(GetClipByIndex(_loc2_));
            _loc3_.SetWidth(_loc1_);
            _loc2_++;
         }
         super.PositionEntries();
      }
   }
}
