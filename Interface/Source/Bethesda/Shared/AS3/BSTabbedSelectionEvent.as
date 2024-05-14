package Shared.AS3
{
   import flash.events.Event;
   
   public class BSTabbedSelectionEvent extends Event
   {
      
      public static const NAME:String = "BSTabbedSelection::selectionChange";
       
      
      public var iSelectedIndex:int;
      
      public var iPreviousSelectionIndex:int;
      
      public function BSTabbedSelectionEvent(param1:int, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(NAME,param3,param4);
         this.iSelectedIndex = param1;
         this.iPreviousSelectionIndex = param2;
      }
      
      override public function clone() : Event
      {
         return new BSTabbedSelectionEvent(this.iSelectedIndex,this.iPreviousSelectionIndex,bubbles,cancelable);
      }
   }
}
