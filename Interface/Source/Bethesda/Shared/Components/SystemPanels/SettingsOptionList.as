package Shared.Components.SystemPanels
{
   import Shared.AS3.BSScrollingContainer;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class SettingsOptionList extends BSScrollingContainer
   {
       
      
      public function SettingsOptionList()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,this.onBeginDrag);
      }
      
      override public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         var _loc2_:SettingsOptionListEntry = null;
         if(!disableInput)
         {
            super.onKeyDownHandler(param1);
            if(this.selectedEntry != null && (param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT))
            {
               _loc2_ = GetClipByIndex(this.selectedClipIndex) as SettingsOptionListEntry;
               if(_loc2_ != null)
               {
                  _loc2_.onKeyDownHandler(param1);
                  param1.stopPropagation();
               }
            }
         }
      }
      
      public function OnEntryPressed() : *
      {
         var _loc1_:SettingsOptionListEntry = null;
         if(!disableInput)
         {
            if(this.selectedEntry != null)
            {
               _loc1_ = GetClipByIndex(this.selectedClipIndex) as SettingsOptionListEntry;
               if(_loc1_ != null)
               {
                  _loc1_.onEntryPressed();
               }
            }
         }
      }
      
      private function onBeginDrag() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onEndDrag);
         this.disableInput = true;
      }
      
      private function onEndDrag() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onEndDrag);
         this.disableInput = false;
      }
   }
}
