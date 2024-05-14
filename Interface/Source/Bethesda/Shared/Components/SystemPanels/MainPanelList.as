package Shared.Components.SystemPanels
{
   import Shared.AS3.BSScrollingContainer;
   
   public class MainPanelList extends BSScrollingContainer
   {
       
      
      public function MainPanelList()
      {
         super();
      }
      
      public function SetIndexByAction(param1:uint) : void
      {
         var _loc2_:int = selectedIndex;
         var _loc3_:uint = 0;
         while(_loc3_ < entryList.length)
         {
            if(entryList[_loc3_].uActionType == param1)
            {
               _loc2_ = int(_loc3_);
               break;
            }
            _loc3_++;
         }
         selectedIndex = _loc2_;
      }
   }
}
