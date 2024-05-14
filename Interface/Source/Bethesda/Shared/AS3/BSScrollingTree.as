package Shared.AS3
{
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BSScrollingTree extends BSScrollingContainer
   {
       
      
      private var _filterMask:uint = 4294967295;
      
      private var _navigateParentEntriesOnly:Boolean = false;
      
      public function BSScrollingTree()
      {
         super();
      }
      
      public function get filterMask() : uint
      {
         return this._filterMask;
      }
      
      public function set filterMask(param1:uint) : *
      {
         this._filterMask = param1;
         this.FilterRootEntries();
      }
      
      public function get navigateParentEntriesOnly() : Boolean
      {
         return this._navigateParentEntriesOnly;
      }
      
      public function set navigateParentEntriesOnly(param1:Boolean) : *
      {
         this._navigateParentEntriesOnly = param1;
      }
      
      override public function InitializeEntries(param1:Array) : void
      {
         var _loc2_:* = undefined;
         rawEntries = param1;
         ClearEntryList();
         for each(_loc2_ in rawEntries)
         {
            _loc2_.expanded = false;
            if(this.IsRootEntry(_loc2_))
            {
               entryList.push(_loc2_);
            }
         }
         this.FilterEntries();
         InvalidateData();
      }
      
      protected function IsRootEntry(param1:Object) : Boolean
      {
         return param1.parentIndex == -1;
      }
      
      override public function FilterEntries() : void
      {
         this.FilterRootEntries();
      }
      
      protected function FilterRootEntries() : *
      {
         var _loc1_:* = undefined;
         ClearEntryList();
         for each(_loc1_ in rawEntries)
         {
            _loc1_.expanded = false;
            if(this.IsRootEntry(_loc1_) && this.EntryFilterCompare_Impl(_loc1_))
            {
               entryList.push(_loc1_);
            }
         }
         InvalidateData();
      }
      
      protected function EntryFilterCompare_Impl(param1:Object) : Boolean
      {
         return param1.filterFlag != null ? (this.filterMask & param1.filterFlag) != 0 : true;
      }
      
      protected function GetChildrenOfEntry(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = int(param1.childIndex);
         while(_loc3_ != -1)
         {
            _loc4_ = rawEntries[_loc3_];
            _loc2_.push(_loc4_);
            _loc3_ = int(_loc4_.siblingIndex);
         }
         return _loc2_;
      }
      
      protected function EntryHasChildren(param1:Object) : Boolean
      {
         return param1.childIndex != -1;
      }
      
      public function ExpandEntry(param1:int) : *
      {
         this.AddChildrenOfEntry(param1);
      }
      
      private function AddChildrenOfEntry(param1:int) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc2_:Object = entryList[param1];
         _loc2_.expanded = true;
         var _loc3_:Array = this.GetChildrenOfEntry(_loc2_);
         for each(_loc4_ in _loc3_)
         {
            _loc4_.expanded = false;
         }
         _loc5_ = entryList.splice(param1 + 1);
         entryList = entryList.concat(_loc3_).concat(_loc5_);
         Update();
      }
      
      private function CountVisibleNestedChildren(param1:Object) : int
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         if(param1.expanded)
         {
            _loc3_ = this.GetChildrenOfEntry(param1);
            _loc2_ += _loc3_.length;
            for each(_loc4_ in _loc3_)
            {
               _loc2_ += this.CountVisibleNestedChildren(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function CollapseEntry(param1:int) : *
      {
         this.RemoveChildrenOfEntry(param1);
      }
      
      private function RemoveChildrenOfEntry(param1:int) : void
      {
         var _loc2_:Object = entryList[param1];
         var _loc3_:* = selectedIndex > param1;
         var _loc4_:int = entryCount;
         var _loc5_:int = this.CountVisibleNestedChildren(_loc2_);
         entryList.splice(param1 + 1,_loc5_);
         _loc2_.expanded = false;
         if(_loc3_)
         {
            selectedIndex -= _loc4_ - entryCount;
         }
         InvalidateData();
      }
      
      protected function PrintEntries() : *
      {
         var _loc2_:* = undefined;
         trace("========================================================");
         trace("=============         List Start        ================");
         trace("========================================================");
         var _loc1_:* = 0;
         for each(_loc2_ in entryList)
         {
            trace("Entry " + _loc2_.text);
            trace("\tList Index: " + _loc1_++);
            trace("\tParent: " + _loc2_.parentIndex);
            trace("\tSibling: " + _loc2_.siblingIndex);
            trace("\tChild: " + _loc2_.childIndex);
            trace("");
         }
      }
      
      protected function IsClipAChild(param1:BSScrollingTreeEntry) : Boolean
      {
         var _loc2_:* = entryList[param1.itemIndex];
         return _loc2_ != null ? !this.IsRootEntry(_loc2_) : false;
      }
      
      public function ShowEntryChildren(param1:int, param2:Boolean) : *
      {
         var _loc3_:Object = null;
         if(param1 != -1 && param1 >= 0 && param1 < entryCount)
         {
            _loc3_ = entryList[param1];
            if(this.EntryHasChildren(_loc3_))
            {
               if(param2)
               {
                  if(!_loc3_.expanded)
                  {
                     this.AddChildrenOfEntry(param1);
                  }
               }
               else if(_loc3_.expanded)
               {
                  this.RemoveChildrenOfEntry(param1);
               }
            }
         }
      }
      
      override public function onEntryPress(param1:Event) : *
      {
         if(canSelect && selectedIndex != -1 && this.EntryHasChildren(selectedEntry))
         {
            this.ShowEntryChildren(selectedIndex,!selectedEntry.expanded);
         }
         else
         {
            super.onEntryPress(param1);
         }
         param1.stopPropagation();
      }
      
      override protected function UpdateEntryClip(param1:BSContainerEntry, param2:Object) : *
      {
         super.UpdateEntryClip(param1,param2);
         var _loc3_:* = param1 as BSScrollingTreeEntry;
         if(_loc3_ != null && param2 != null)
         {
            if(this.EntryHasChildren(param2))
            {
               _loc3_.ShowCollapseIcon(param2.expanded);
            }
            else
            {
               _loc3_.HideCollapseIcon();
            }
         }
      }
      
      override protected function PositionEntry(param1:BSContainerEntry, param2:Number) : *
      {
         super.PositionEntry(param1,param2);
         var _loc3_:* = param1 as BSScrollingTreeEntry;
         if(_loc3_ != null)
         {
            _loc3_.x += this.IsClipAChild(_loc3_) ? _loc3_.childSpacerWidth : 0;
         }
      }
      
      override public function MoveSelection(param1:int) : *
      {
         var _loc5_:BSContainerEntry = null;
         var _loc2_:int = selectedIndex;
         var _loc3_:BSScrollingTreeEntry = null;
         do
         {
            _loc2_ += param1;
            if(wrapAround)
            {
               if(_loc2_ < 0)
               {
                  _loc2_ = entryCount - 1;
               }
               else if(_loc2_ > entryCount - 1)
               {
                  _loc2_ = 0;
               }
            }
            else
            {
               _loc2_ = GlobalFunc.Clamp(_loc2_,0,entryCount - 1);
            }
            _loc3_ = !!(_loc5_ = GetClipByIndex(_loc2_,false)) ? _loc5_ as BSScrollingTreeEntry : null;
         }
         while(_loc3_ != null && (!_loc3_.IsEntryFocusable() || this.navigateParentEntriesOnly && this.IsClipAChild(_loc3_) && !_loc3_.CanBeFocusedInParentEntriesOnly()) && _loc2_ != selectedIndex);
         
         var _loc4_:int = selectedIndex;
         if(_loc2_ != _loc4_)
         {
            selectedIndex = _loc2_;
         }
      }
      
      override public function onMouseWheel(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         if(canScroll && itemsShown > 0)
         {
            _loc2_ = scrollPosition;
            if(param1.delta != 0)
            {
               this.MoveSelection(param1.delta > 0 ? -1 : 1);
            }
            param1.stopPropagation();
            if(_loc2_ != scrollPosition)
            {
               dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            }
         }
      }
      
      override public function onEntryRollover(param1:Event) : *
      {
         var _loc2_:BSScrollingTreeEntry = null;
         if(param1.currentTarget != null)
         {
            _loc2_ = param1.currentTarget as BSScrollingTreeEntry;
            if(_loc2_ && _loc2_.IsEntryFocusable() && (!this.navigateParentEntriesOnly || !this.IsClipAChild(_loc2_) || _loc2_.CanBeFocusedInParentEntriesOnly()))
            {
               super.onEntryRollover(param1);
            }
         }
      }
   }
}
