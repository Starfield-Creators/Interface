package Shared.Components.ButtonControls.ButtonData
{
   import flash.events.Event;
   
   public class TabButtonBarEvent extends Event
   {
      
      public static const TAB_CHANGED:String = "TabChanged";
      
      public static const TAB_PAYLOAD_CHANGED:String = "TabPayloadChanged";
      
      public static const TAB_DATA_SET:String = "TabDataSet";
       
      
      public var SelectedIndex:int = -1;
      
      public var PayloadData:Object;
      
      public function TabButtonBarEvent(param1:String, param2:int, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.SelectedIndex = param2;
         this.PayloadData = param3;
      }
      
      override public function clone() : Event
      {
         return new TabButtonBarEvent(type,this.SelectedIndex,this.PayloadData,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return "[Event type=\"" + type + "\" SelectedIndex=" + this.SelectedIndex + " PayloadData=" + this.PayloadData + " bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
      }
   }
}
