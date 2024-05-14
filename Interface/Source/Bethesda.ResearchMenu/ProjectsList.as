package
{
   import Shared.AS3.BSScrollingContainer;
   
   public class ProjectsList extends BSScrollingContainer
   {
       
      
      public function ProjectsList()
      {
         super();
      }
      
      public function SetSelectedProject(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < entryList.length && !_loc2_)
         {
            if(entryList[_loc3_].uID == param1)
            {
               selectedIndex = _loc3_;
               _loc2_ = true;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
