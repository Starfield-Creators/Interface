package
{
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import flash.events.Event;
   
   public class FacePartList extends BSScrollingContainer
   {
       
      
      public function FacePartList()
      {
         super();
      }
      
      override public function set scrollPosition(param1:int) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(scrollPosition < param1)
         {
            _loc2_ = scrollPosition;
            while(_loc2_ >= 0)
            {
               if(Boolean(rawEntries[_loc2_]) && Boolean(rawEntries[_loc2_].sRollOffCallbackName))
               {
                  BSUIDataManager.dispatchEvent(new Event(rawEntries[_loc2_].sRollOffCallbackName));
               }
               _loc2_--;
            }
         }
         else if(scrollPosition > param1)
         {
            _loc3_ = param1 + totalEntryClips;
            while(_loc3_ < rawEntries.length)
            {
               if(Boolean(rawEntries[_loc3_]) && Boolean(rawEntries[_loc3_].sRollOffCallbackName))
               {
                  BSUIDataManager.dispatchEvent(new Event(rawEntries[_loc3_].sRollOffCallbackName));
               }
               _loc3_ += 1;
            }
         }
         super.scrollPosition = param1;
      }
   }
}
