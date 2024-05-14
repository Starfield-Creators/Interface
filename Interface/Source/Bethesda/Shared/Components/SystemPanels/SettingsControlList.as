package Shared.Components.SystemPanels
{
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class SettingsControlList extends BSScrollingContainer
   {
       
      
      private var _allowAltBindings:Boolean = false;
      
      public function SettingsControlList()
      {
         super();
      }
      
      private function GetCurrentClip() : SettingsControlListEntry
      {
         return GetClipByIndex(selectedClipIndex) as SettingsControlListEntry;
      }
      
      public function get activePriority() : int
      {
         var _loc1_:SettingsControlListEntry = this.GetCurrentClip();
         return _loc1_ != null ? _loc1_.activePriority : ControlBinding.NO_PRIORITY;
      }
      
      override public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SettingsControlListEntry = null;
         var _loc2_:int = selectedIndex;
         if(!disableInput)
         {
            _loc3_ = param1.keyCode == Keyboard.UP ? -1 : (param1.keyCode == Keyboard.DOWN ? 1 : 0);
            if(_loc3_ != 0)
            {
               _loc4_ = selectedIndex + _loc3_;
               if(wrapAround)
               {
                  if(_loc4_ < 0)
                  {
                     _loc4_ = entryCount - 1;
                  }
                  else if(_loc4_ > entryCount - 1)
                  {
                     _loc4_ = 0;
                  }
               }
               else
               {
                  _loc4_ = GlobalFunc.Clamp(_loc4_,0,entryCount - 1);
               }
               if(_loc4_ != selectedIndex)
               {
                  if((_loc5_ = this.GetValidControlEntry(_loc4_,_loc3_)) > -1 && _loc5_ != selectedIndex)
                  {
                     selectedIndex = _loc5_;
                     this.CheckScrollPosition();
                     if(_loc2_ != selectedIndex)
                     {
                        dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
                     }
                  }
               }
               param1.stopPropagation();
            }
            if(this._allowAltBindings && this.selectedEntry != null && (param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT))
            {
               if((_loc6_ = FindClipForEntry(selectedIndex) as SettingsControlListEntry) != null)
               {
                  _loc6_.onKeyDownHandler(param1);
                  param1.stopPropagation();
               }
            }
         }
      }
      
      private function CheckScrollPosition() : void
      {
         var _loc1_:int = scrollPosition;
         if(selectedClipIndex < 1 && selectedIndex > 0)
         {
            _loc1_--;
         }
         else if(selectedClipIndex >= itemsShown - 1 && selectedIndex < entryCount - 1)
         {
            _loc1_++;
         }
         scrollPosition = _loc1_;
      }
      
      override public function onMouseWheel(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(canScroll)
         {
            _loc2_ = scrollPosition;
            if(param1.delta != 0)
            {
               scrollPosition += param1.delta > 0 ? -1 : 1;
            }
            param1.stopPropagation();
            if(_loc2_ != scrollPosition)
            {
               _loc3_ = scrollPosition - _loc2_;
               _loc4_ = selectedIndex + _loc3_;
               if((_loc5_ = this.GetValidControlEntry(_loc4_,_loc3_)) > -1 && _loc5_ != selectedIndex)
               {
                  selectedIndex = _loc5_;
                  dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
               }
            }
         }
      }
      
      public function GetValidControlEntry(param1:int, param2:int) : int
      {
         var _loc3_:int = -1;
         var _loc4_:int = param1;
         var _loc5_:* = 0;
         while(_loc3_ == -1 && _loc4_ >= 0 && _loc4_ < entryCount && _loc5_ < entryCount)
         {
            if(GetDataForEntry(_loc4_).bIsDivider !== true)
            {
               _loc3_ = _loc4_;
            }
            if(param2 >= 0)
            {
               _loc4_++;
            }
            else
            {
               _loc4_--;
            }
            if(wrapAround)
            {
               if(_loc4_ < 0)
               {
                  _loc4_ = entryCount - 1;
               }
               else if(_loc4_ >= entryCount)
               {
                  _loc4_ = 0;
               }
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function ResetSelection() : void
      {
         scrollPosition = 0;
         selectedIndex = this.GetValidControlEntry(0,1);
      }
      
      public function EnableAltBindings(param1:Boolean) : void
      {
         var _loc2_:SettingsControlListEntry = null;
         if(this._allowAltBindings != param1)
         {
            this._allowAltBindings = param1;
            if(!this._allowAltBindings)
            {
               _loc2_ = this.GetCurrentClip();
               if(_loc2_ != null)
               {
                  _loc2_.SetActiveBinding(ControlBinding.MAIN_KEY);
               }
            }
         }
      }
      
      public function ClearEntryListenState() : void
      {
         var _loc1_:SettingsControlListEntry = this.GetCurrentClip();
         if(_loc1_ != null)
         {
            _loc1_.ClearListenState();
         }
      }
      
      override protected function OnSelectionChanged(param1:int, param2:int) : *
      {
         var _loc6_:int = 0;
         var _loc3_:int = ControlBinding.MAIN_KEY;
         var _loc4_:SettingsControlListEntry;
         if((_loc4_ = FindClipForEntry(param1) as SettingsControlListEntry) != null)
         {
            if((_loc6_ = _loc4_.activePriority) != ControlBinding.NO_PRIORITY)
            {
               _loc3_ = _loc6_;
            }
         }
         var _loc5_:SettingsControlListEntry;
         if((_loc5_ = this.GetCurrentClip()) != null)
         {
            _loc5_.SetActiveBinding(_loc3_);
         }
         super.OnSelectionChanged(param1,param2);
      }
      
      override protected function updateScrollPosition(param1:int) : *
      {
         var _loc2_:int = this.activePriority;
         super.updateScrollPosition(param1);
         var _loc3_:SettingsControlListEntry = this.GetCurrentClip();
         if(_loc3_ != null)
         {
            _loc3_.SetActiveBinding(_loc2_);
         }
      }
      
      override public function onEntryRollover(param1:Event) : *
      {
         var _loc2_:SettingsControlListEntry = null;
         if(param1.currentTarget != null)
         {
            _loc2_ = param1.currentTarget as SettingsControlListEntry;
            if(Boolean(_loc2_) && !_loc2_.isDividerEntry)
            {
               super.onEntryRollover(param1);
            }
         }
      }
      
      public function OnEntryPressed() : void
      {
         var _loc1_:SettingsControlListEntry = null;
         if(!disableInput && this.selectedEntry != null)
         {
            _loc1_ = this.GetCurrentClip();
            if(_loc1_ != null)
            {
               _loc1_.onEntryPressed();
            }
         }
      }
      
      public function OnDeleteBinding() : void
      {
         var _loc1_:SettingsControlListEntry = null;
         if(!disableInput && this.selectedEntry != null)
         {
            _loc1_ = this.GetCurrentClip();
            if(_loc1_ != null)
            {
               _loc1_.onDeleteBinding();
            }
         }
      }
   }
}
