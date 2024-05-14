package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSScrollingTree;
   import Shared.AS3.Events.ScrollingEvent;
   
   public class AvailableOutpostsList extends BSScrollingTree
   {
       
      
      private var _expandedOutpostID:uint = 0;
      
      private var _selectedID:uint = 0;
      
      public function AvailableOutpostsList()
      {
         super();
      }
      
      public function SelectInitialTarget() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc1_:int = -1;
         var _loc2_:int = -1;
         var _loc3_:Boolean = false;
         for each(_loc4_ in rawEntries)
         {
            _loc1_++;
            _loc2_++;
            if(this.IsRootEntry(_loc4_) && Boolean(_loc4_.bCurrentLink))
            {
               _loc5_ = this.GetChildrenOfEntry(_loc4_);
               for each(_loc6_ in _loc5_)
               {
                  _loc2_++;
                  if(_loc6_.bCurrentTarget)
                  {
                     _loc3_ = true;
                     break;
                  }
               }
               break;
            }
         }
         if(_loc3_)
         {
            ExpandEntry(_loc1_);
            selectedIndex = _loc2_;
         }
      }
      
      override public function InitializeEntries(param1:Array) : void
      {
         rawEntries = param1;
         this.FilterEntries();
         InvalidateData();
      }
      
      override public function FilterEntries() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         ClearEntryList();
         for each(_loc1_ in rawEntries)
         {
            _loc1_.expanded = false;
            if(this.IsRootEntry(_loc1_))
            {
               _loc1_.expanded = this._expandedOutpostID == _loc1_.uHandle;
               entryList.push(_loc1_);
               if(_loc1_.expanded)
               {
                  _loc2_ = this.GetChildrenOfEntry(_loc1_);
                  for each(_loc3_ in _loc2_)
                  {
                     _loc3_.expanded = false;
                     if(_loc3_.uHandle == this._selectedID)
                     {
                        _loc3_.selected = true;
                     }
                     entryList.push(_loc3_);
                  }
               }
            }
         }
      }
      
      override protected function IsRootEntry(param1:Object) : Boolean
      {
         return OutpostsList_Entry.IsOutpost(param1);
      }
      
      override protected function GetChildrenOfEntry(param1:Object) : Array
      {
         return OutpostsList_Entry.IsOutpost(param1) ? param1.aTargets : new Array();
      }
      
      override protected function EntryHasChildren(param1:Object) : Boolean
      {
         return OutpostsList_Entry.IsOutpost(param1);
      }
      
      override protected function OnSelectionChanged(param1:int, param2:int) : *
      {
         var _loc13_:uint = 0;
         var _loc3_:BSContainerEntry = FindClipForEntry(param1);
         if(_loc3_ == null && wrapAround)
         {
            _loc13_ = (_loc13_ = uint(entryCount - itemsShown)) * (param1 > selectedIndex ? -1 : 1);
            _loc3_ = FindClipForEntry(param1 + _loc13_);
         }
         if(_loc3_ != null)
         {
            _loc3_.onRollout();
         }
         dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
         var _loc4_:BSContainerEntry;
         if((_loc4_ = FindClipForEntry(selectedIndex)) != null)
         {
            _loc4_.onRollover();
         }
         var _loc5_:Boolean = selectedEntry != null && this.IsRootEntry(selectedEntry);
         var _loc6_:Object;
         var _loc7_:Boolean = (_loc6_ = entryList[param1]) != null && this.IsRootEntry(_loc6_);
         var _loc8_:int = this.GetCurrentParentIndex();
         var _loc9_:Object = entryList[_loc8_];
         var _loc10_:uint = 0;
         var _loc11_:int = selectedIndex;
         if(_loc9_ != null && _loc5_ && _loc9_ != selectedEntry)
         {
            _loc10_ = this.GetChildrenOfEntry(_loc9_).length;
            CollapseEntry(_loc8_);
            if(_loc11_ < param1 && !_loc7_)
            {
               SetSelectedIndexUnsafe(Math.max(_loc11_ - _loc10_,0));
            }
         }
         if(selectedEntry != null && this.IsRootEntry(selectedEntry) && !selectedEntry.expanded)
         {
            ExpandEntry(selectedIndex);
         }
         var _loc12_:Object = this.GetCurrentParentEntry();
         this._expandedOutpostID = _loc12_ != null ? uint(_loc12_.uHandle) : 0;
         this._selectedID = selectedEntry != null ? uint(selectedEntry.uHandle) : 0;
         dispatchEvent(new ScrollingEvent(ScrollingEvent.SELECTION_CHANGE,true,true,selectedIndex,param1,entryList[selectedIndex]));
      }
      
      private function GetCurrentParentIndex() : int
      {
         var _loc1_:int = -1;
         var _loc2_:int = 0;
         while(_loc2_ < entryList.length)
         {
            if(OutpostsList_Entry.IsOutpost(entryList[_loc2_]) && Boolean(entryList[_loc2_].expanded))
            {
               _loc1_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function GetCurrentParentEntry() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = this.GetCurrentParentIndex();
         if(_loc2_ != -1)
         {
            _loc1_ = entryList[_loc2_];
         }
         return _loc1_;
      }
   }
}
