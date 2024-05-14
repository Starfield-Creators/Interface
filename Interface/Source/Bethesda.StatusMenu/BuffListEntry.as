package
{
   import Shared.AS3.BSContainerEntry;
   
   public class BuffListEntry extends BSContainerEntry
   {
      
      public static const BLE_BUFF:String = "Buff";
      
      public static const BLE_DIVIDER:String = "Divider";
       
      
      public var Buff_mc:BuffEntry;
      
      public function BuffListEntry()
      {
         super();
      }
      
      public function StatusListEntry() : *
      {
         stop();
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.Buff_mc.SetEntry(param1);
      }
      
      override public function onRollover() : void
      {
      }
      
      override public function onRollout() : void
      {
      }
   }
}
