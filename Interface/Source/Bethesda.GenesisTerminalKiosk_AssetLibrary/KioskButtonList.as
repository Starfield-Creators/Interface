package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSScrollingContainer;
   
   public class KioskButtonList extends BSScrollingContainer
   {
       
      
      private var Faction:String = "Generic";
      
      public function KioskButtonList()
      {
         super();
      }
      
      public function set FactionName(param1:String) : void
      {
         this.Faction = param1;
      }
      
      public function SetEntryClass(param1:String) : void
      {
         entryClass = param1;
         RecreateEntryClips();
         Border_mc.mouseEnabled = false;
         Border_mc.mouseChildren = false;
      }
      
      override protected function UpdateEntryClip(param1:BSContainerEntry, param2:Object) : *
      {
         super.UpdateEntryClip(param1,param2);
         (param1 as KioskButtonListEntry).Background_mc.gotoAndStop(this.Faction);
      }
   }
}
