package
{
   import Shared.AS3.BSScrollingContainer;
   
   public class WorkshopModeList extends BSScrollingContainer
   {
       
      
      public function WorkshopModeList()
      {
         super();
      }
      
      public function SetIndexByMode(param1:int) : void
      {
         var _loc2_:int = selectedIndex;
         var _loc3_:uint = 0;
         while(_loc3_ < entryList.length)
         {
            if(entryList[_loc3_] == param1)
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
