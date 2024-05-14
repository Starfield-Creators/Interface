package Shared.AS3
{
   import flash.events.Event;
   
   public class BSScrollingBarPosChangeEvent extends Event
   {
      
      public static const NAME:String = "BSScrollingBar::posChange";
       
      
      public var iNewScrollPosition:int;
      
      public function BSScrollingBarPosChangeEvent(param1:int, param2:Boolean = false, param3:Boolean = false)
      {
         super(NAME,param2,param3);
         this.iNewScrollPosition = param1;
      }
      
      override public function clone() : Event
      {
         return new BSScrollingBarPosChangeEvent(this.iNewScrollPosition,bubbles,cancelable);
      }
   }
}
