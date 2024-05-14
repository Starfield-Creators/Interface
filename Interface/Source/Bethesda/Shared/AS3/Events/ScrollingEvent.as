package Shared.AS3.Events
{
   import flash.events.Event;
   
   public class ScrollingEvent extends Event
   {
      
      public static const SELECTION_CHANGE:String = "ScrollingEvent::selectionChange";
      
      public static const ITEM_PRESS:String = "ScrollingEvent::itemPress";
      
      public static const LIST_PRESS:String = "ScrollingEvent::listPress";
      
      public static const ENTRY_MOUSE_DOWN:String = "ScrollingEvent::entryMouseDown";
      
      public static const LIST_WOULD_HAVE_SCROLLED:* = "ScrollingEvent::listWouldHaveScrolled";
      
      public static const PLAY_FOCUS_SOUND:String = "ScrollingEvent::playFocusSound";
       
      
      private var _currentIndex:int = -1;
      
      private var _previousIndex:int = -1;
      
      private var _entryObject:Object = "";
      
      public function ScrollingEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1, param5:int = -1, param6:Object = null)
      {
         super(param1,param2,param3);
         this._currentIndex = param4;
         this._previousIndex = param5;
         this._entryObject = param6;
      }
      
      public function get CurrentIndex() : *
      {
         return this._currentIndex;
      }
      
      public function set CurrentIndex(param1:int) : *
      {
         this._currentIndex = param1;
      }
      
      public function get PreviousIndex() : *
      {
         return this._previousIndex;
      }
      
      public function set PreviousIndex(param1:int) : *
      {
         this._previousIndex = param1;
      }
      
      public function get EntryObject() : *
      {
         return this._entryObject;
      }
      
      public function set EntryObject(param1:Object) : *
      {
         this._entryObject = param1;
      }
      
      override public function clone() : Event
      {
         return new ScrollingEvent(type,bubbles,cancelable,this._currentIndex,this._previousIndex,this._entryObject);
      }
   }
}
