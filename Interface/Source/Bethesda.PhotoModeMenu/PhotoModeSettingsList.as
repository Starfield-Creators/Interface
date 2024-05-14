package
{
   import Shared.AS3.BSScrollingContainer;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class PhotoModeSettingsList extends BSScrollingContainer
   {
       
      
      public function PhotoModeSettingsList()
      {
         super();
      }
      
      override public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         var _loc2_:PhotoModeSettingEntry = null;
         if(!disableInput)
         {
            super.onKeyDownHandler(param1);
            if(this.selectedEntry != null && (param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT))
            {
               _loc2_ = GetClipByIndex(this.selectedClipIndex) as PhotoModeSettingEntry;
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
         var _loc1_:PhotoModeSettingEntry = null;
         if(!disableInput)
         {
            if(this.selectedEntry != null)
            {
               _loc1_ = GetClipByIndex(this.selectedClipIndex) as PhotoModeSettingEntry;
               if(_loc1_ != null)
               {
                  _loc1_.onEntryPressed();
               }
            }
         }
      }
   }
}
