package
{
   import Shared.AS3.BSScrollingContainer;
   
   public class MissionsList extends BSScrollingContainer
   {
       
      
      public function MissionsList()
      {
         super();
      }
      
      public function SetMissionEntryClass(param1:String) : void
      {
         entryClass = param1;
         RecreateEntryClips();
      }
   }
}
