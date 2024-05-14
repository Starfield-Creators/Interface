package
{
   import Components.BSButton;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ChangeCategoryButton extends BSButton
   {
      
      public static const CHANGE_CATEGORY_CLICKED_EVENT:String = "onChangeCategoryClicked";
       
      
      private var categoryOffset:int = 0;
      
      private var eventName:String = "";
      
      private var alwaysHighlight:Boolean = false;
      
      private var eventToNameMappings:Array = null;
      
      public function ChangeCategoryButton()
      {
         super();
         BSUIDataManager.Subscribe("ControlMapData",function(param1:FromClientDataEvent):*
         {
            OnControlMapDataChanged(param1.data);
         });
      }
      
      public function set CategoryOffset(param1:int) : void
      {
         this.categoryOffset = param1;
      }
      
      private function get CategoryOffset() : int
      {
         return this.categoryOffset;
      }
      
      public function set EventName(param1:String) : void
      {
         this.eventName = param1;
      }
      
      private function get EventName() : String
      {
         return this.eventName;
      }
      
      public function SetAlwaysHighlight(param1:Boolean) : *
      {
         this.alwaysHighlight = param1;
         if(this.alwaysHighlight)
         {
            gotoAndStop("over");
         }
      }
      
      override public function onClick() : *
      {
         if(!disabled)
         {
            dispatchEvent(new CustomEvent(CHANGE_CATEGORY_CLICKED_EVENT,{"aOffset":this.categoryOffset},true,true));
         }
      }
      
      override public function onRollover(param1:MouseEvent) : *
      {
         if(!this.alwaysHighlight)
         {
            super.onRollover(param1);
         }
      }
      
      override public function onRollout() : *
      {
         if(!this.alwaysHighlight)
         {
            super.onRollout();
         }
      }
      
      override public function onDown() : *
      {
         if(!this.alwaysHighlight)
         {
            super.onDown();
         }
      }
      
      override public function onUp() : *
      {
         if(!this.alwaysHighlight)
         {
            super.onUp();
         }
      }
      
      private function OnControlMapDataChanged(param1:Object) : void
      {
         this.eventToNameMappings = param1.vMappedEvents;
         var _loc2_:MovieClip = this as MovieClip;
         if(_loc2_ != null && _loc2_.text_tf != null)
         {
            GlobalFunc.SetText(_loc2_.text_tf,this.GetButtonNameForEvent(this.eventName));
         }
      }
      
      private function GetButtonNameForEvent(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc2_:* = "";
         for each(_loc3_ in this.eventToNameMappings)
         {
            if(_loc3_.strUserEventName == param1)
            {
               _loc2_ = _loc3_.strButtonName;
               break;
            }
         }
         return _loc2_;
      }
   }
}
