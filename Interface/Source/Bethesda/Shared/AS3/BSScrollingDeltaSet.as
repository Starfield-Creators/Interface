package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.DataProviderUtils;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class BSScrollingDeltaSet extends BSDisplayObject
   {
       
      
      public var Border_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollBar:BSScrollingBar;
      
      private var EntryHolder_mc:MovieClip;
      
      private var _entriesA:Array;
      
      private var _filteredEntriesA:Array;
      
      private var _selectedIndex:int = -1;
      
      private var _maxClips:int = 0;
      
      private var _itemsFullyShown:int = 0;
      
      private var _scrollPosition:int = 0;
      
      private var _initialized:Boolean = false;
      
      private var _disableInput:Boolean = false;
      
      private var _textOption:String = "none";
      
      private var _multiLineText:Boolean = false;
      
      private var _verticalSpacing:Number = 0;
      
      private var _numListItems:int = 0;
      
      private var _restoreListIndex:Boolean = true;
      
      private var _disableSelection:Boolean = false;
      
      private var _filterComparitor:Function = null;
      
      private var _wrapAround:Boolean = true;
      
      protected var EntryClass:Class;
      
      private var ContainerRect:Rectangle;
      
      protected var ListClips:Array;
      
      protected var UnusedListClips:Array;
      
      private var bDisableListWrap:Boolean = false;
      
      public function BSScrollingDeltaSet()
      {
         this._entriesA = new Array();
         this._filteredEntriesA = new Array();
         this.EntryClass = getDefinitionByName("Shared.AS3.BSContainerEntry") as Class;
         this.ListClips = new Array();
         this.UnusedListClips = new Array();
         super();
         if(this.Border_mc == null)
         {
            throw new Error("BSScrollingDeltaSet: Required MovieClip \"Border_mc\" does not exist!");
         }
         this.EntryHolder_mc = new MovieClip();
         this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.Border_mc) + 1);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.ContainerRect = this.Border_mc.getBounds(this);
         BSUIDataManager.Subscribe("ListWrapData",this.OnListWrapDataUpdate);
      }
      
      public function get disableInput() : Boolean
      {
         return this._disableInput;
      }
      
      public function set disableInput(param1:Boolean) : *
      {
         this._disableInput = param1;
      }
      
      protected function get textOption() : String
      {
         return this._textOption;
      }
      
      protected function set textOption(param1:String) : *
      {
         this._textOption = param1;
      }
      
      protected function get multiLineText() : Boolean
      {
         return this._multiLineText;
      }
      
      protected function set multiLineText(param1:Boolean) : *
      {
         this._multiLineText = param1;
      }
      
      protected function get verticalSpacing() : *
      {
         return this._verticalSpacing;
      }
      
      protected function set verticalSpacing(param1:Number) : *
      {
         this._verticalSpacing = param1;
      }
      
      protected function get entryClass() : String
      {
         return getQualifiedClassName(this.EntryClass);
      }
      
      protected function set entryClass(param1:String) : *
      {
         this.EntryClass = getDefinitionByName(param1) as Class;
      }
      
      public function get restoreListIndex() : Boolean
      {
         return this._restoreListIndex;
      }
      
      public function set restoreListIndex(param1:Boolean) : *
      {
         this._restoreListIndex = param1;
      }
      
      public function get disableSelection() : Boolean
      {
         return this._disableSelection;
      }
      
      public function set disableSelection(param1:Boolean) : *
      {
         this._disableSelection = param1;
      }
      
      public function get wrapAround() : Boolean
      {
         return this.bDisableListWrap ? false : this._wrapAround;
      }
      
      public function set wrapAround(param1:Boolean) : *
      {
         this._wrapAround = param1;
      }
      
      public function get scrollbarScrolling() : Boolean
      {
         return this.ScrollBar != null ? this.ScrollBar.scrolling : false;
      }
      
      public function get maxScrollPosition() : int
      {
         return Math.max(this.entryCount - this._maxClips,0);
      }
      
      public function get scrollPosition() : int
      {
         return this._scrollPosition;
      }
      
      public function set scrollPosition(param1:int) : *
      {
         if(param1 != this._scrollPosition && param1 >= 0 && param1 <= this.maxScrollPosition)
         {
            this.updateScrollPosition(param1);
         }
      }
      
      public function get clipCount() : int
      {
         return this.ListClips.length;
      }
      
      public function get itemsFullyShown() : int
      {
         return this._itemsFullyShown;
      }
      
      public function set itemsFullyShown(param1:int) : *
      {
         this._itemsFullyShown = param1;
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function set initialized(param1:Boolean) : *
      {
         this._initialized = param1;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : *
      {
         this.SetSelectedIndex(param1);
      }
      
      protected function get rawEntries() : Array
      {
         return this._entriesA;
      }
      
      protected function set rawEntries(param1:Array) : *
      {
         this._entriesA = param1;
      }
      
      protected function get filteredEntries() : Array
      {
         return this._filteredEntriesA;
      }
      
      protected function set filteredEntries(param1:Array) : *
      {
         this._filteredEntriesA = param1;
      }
      
      public function get entryCount() : int
      {
         return this.filteredEntries.length;
      }
      
      public function get canScroll() : Boolean
      {
         return !this.disableInput;
      }
      
      public function get canSelect() : Boolean
      {
         return !this.disableInput && !this.disableSelection;
      }
      
      public function get containerTop() : Number
      {
         return this.ContainerRect.top;
      }
      
      public function get containerBottom() : Number
      {
         return this.ContainerRect.bottom;
      }
      
      public function get containerLeft() : Number
      {
         return this.ContainerRect.left;
      }
      
      public function get containerHeight() : Number
      {
         return this.ContainerRect.height;
      }
      
      public function get selectedEntry() : Object
      {
         return this.filteredEntries[this.selectedIndex];
      }
      
      public function get selectedClipIndex() : int
      {
         return this.selectedIndex - this.scrollPosition;
      }
      
      public function set selectedClipIndex(param1:int) : void
      {
         this.selectedIndex = this.scrollPosition + param1;
      }
      
      private function OnListWrapDataUpdate(param1:FromClientDataEvent) : void
      {
         this.bDisableListWrap = param1.data.bDisableListWrap;
      }
      
      public function InitializeEntries(param1:Array) : void
      {
         this.rawEntries = param1;
         this.FilterEntries();
      }
      
      public function UpdateEntries(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:* = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:BSContainerEntry = null;
         var _loc10_:BSContainerEntry = null;
         if(param1.arrayActionsA.length > 0 && param1.arrayActionsA[0].uType == DataProviderUtils.ACA_CLEAR)
         {
            this.InitializeEntries(param1.dataA);
            return;
         }
         this.rawEntries = param1.dataA;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param1.arrayActionsA)
         {
            if(_loc4_.uType == DataProviderUtils.ACA_INSERT)
            {
               _loc2_ = GlobalFunc.BinarySearchUpperBound(_loc4_.uFirstValue,this.filteredEntries,"rawIndex");
               _loc3_ = int(_loc2_.index);
               while(_loc3_ < this.filteredEntries.length)
               {
                  if(this.filteredEntries[_loc3_].rawIndex != null)
                  {
                     ++this.filteredEntries[_loc3_].rawIndex;
                  }
                  _loc3_++;
               }
            }
            else if(_loc4_.uType == DataProviderUtils.ACA_REMOVE)
            {
               _loc2_ = GlobalFunc.BinarySearchUpperBound(_loc4_.uFirstValue,this.filteredEntries,"rawIndex");
               if(_loc2_.found)
               {
                  this.RemoveFilteredEntry(_loc2_.index);
               }
               _loc3_ = int(_loc2_.index);
               while(_loc3_ < this.filteredEntries.length)
               {
                  if(this.filteredEntries[_loc3_].rawIndex != null)
                  {
                     --this.filteredEntries[_loc3_].rawIndex;
                  }
                  _loc3_++;
               }
            }
            else if(_loc4_.uType == DataProviderUtils.ACA_RESIZE)
            {
               while(this.filteredEntries.length > 0 && _loc4_.uFirstValue <= this.filteredEntries[this.filteredEntries.length - 1].rawIndex)
               {
                  this.RemoveFilteredEntry(this.filteredEntries.length - 1);
               }
            }
         }
         _loc5_ = this._filterComparitor != null;
         for each(_loc6_ in param1.updatedindicesA)
         {
            _loc7_ = this.rawEntries[_loc6_];
            _loc8_ = !_loc5_ || this._filterComparitor(_loc7_);
            _loc2_ = GlobalFunc.BinarySearchUpperBound(_loc6_,this.filteredEntries,"rawIndex");
            if(_loc8_ != _loc2_.found)
            {
               if(_loc8_)
               {
                  this.filteredEntries.splice(_loc2_.index,0,GlobalFunc.CloneObject(_loc7_));
                  this.filteredEntries[_loc2_.index].rawIndex = _loc6_;
                  if(this.IsFilteredEntryIndexVisible(_loc2_.index))
                  {
                     _loc9_ = this.NewEntryClip(_loc2_.index - this.scrollPosition);
                     this.UpdateEntryClip(_loc9_,this.filteredEntries[_loc2_.index],_loc2_.index);
                  }
               }
               else
               {
                  this.RemoveFilteredEntry(_loc2_.index);
               }
            }
            else if(_loc2_.found)
            {
               this.filteredEntries[_loc2_.index] = GlobalFunc.CloneObject(_loc7_);
               this.filteredEntries[_loc2_.index].rawIndex = _loc6_;
               if(this.IsFilteredEntryIndexVisible(_loc2_.index))
               {
                  _loc10_ = this.FindClipForEntry(_loc2_.index);
                  this.UpdateEntryClip(_loc10_,this.filteredEntries[_loc2_.index],_loc2_.index);
               }
            }
         }
         this.IncrementalUpdate();
      }
      
      protected function FilterEntries() : void
      {
         var _loc3_:Object = null;
         this.ClearEntryList();
         while(this.EntryHolder_mc.numChildren > 0)
         {
            this.EntryHolder_mc.removeChildAt(0);
         }
         var _loc1_:* = this._filterComparitor != null;
         var _loc2_:int = 0;
         while(_loc2_ < this.rawEntries.length)
         {
            _loc3_ = this.rawEntries[_loc2_];
            if(!_loc1_ || this._filterComparitor(_loc3_))
            {
               this.filteredEntries.push(GlobalFunc.CloneObject(_loc3_));
               this.filteredEntries[this.filteredEntries.length - 1].rawIndex = _loc2_;
            }
            _loc2_++;
         }
         this.Update();
      }
      
      public function SetFilterComparitor(param1:Function, param2:* = true) : void
      {
         this._filterComparitor = param1;
         if(param2)
         {
            this.FilterEntries();
         }
      }
      
      public function Configure(param1:BSScrollingConfigParams) : void
      {
         if(this.initialized)
         {
            GlobalFunc.TraceWarning("Calling BSScrollingDeltaSet::Configure after it\'s already been initialized. Skipping new Configure.");
            return;
         }
         this.textOption = param1.TextOption;
         this.multiLineText = param1.MultiLine;
         this.verticalSpacing = param1.VerticalSpacing;
         this.entryClass = param1.EntryClassName;
         this.restoreListIndex = param1.RestoreIndex;
         this.disableInput = param1.DisableInput;
         this.disableSelection = param1.DisableSelection;
         this.wrapAround = param1.WrapAround;
         this.initialized = true;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.addEventListener(MouseEvent.CLICK,this.onScrollUpArrowClick);
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.addEventListener(MouseEvent.CLICK,this.onScrollDownArrowClick);
         }
         if(this.ScrollBar != null)
         {
            this.ScrollBar.addEventListener(BSScrollingBarPosChangeEvent.NAME,this.onScrollBarMoved);
         }
      }
      
      protected function ClearEntryList() : void
      {
         this.filteredEntries.length = 0;
      }
      
      protected function GetEntryIndexFromClipIndex(param1:int) : int
      {
         var _loc2_:BSContainerEntry = this.GetClipByIndex(param1);
         return !!_loc2_ ? _loc2_.itemIndex : -1;
      }
      
      public function GetClipByIndex(param1:int) : BSContainerEntry
      {
         return param1 >= 0 && param1 < this.ListClips.length ? this.ListClips[param1] : null;
      }
      
      public function FindClipForEntry(param1:int) : BSContainerEntry
      {
         var _loc4_:BSContainerEntry = null;
         var _loc2_:BSContainerEntry = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.EntryHolder_mc.numChildren)
         {
            if((_loc4_ = this.GetClipByIndex(_loc3_)).itemIndex == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function NewEntryClip(param1:int = -1) : BSContainerEntry
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:BSContainerEntry = null;
         if(this.UnusedListClips.length > 0)
         {
            _loc2_ = this.UnusedListClips.pop();
         }
         else
         {
            _loc2_ = new this.EntryClass() as BSContainerEntry;
         }
         _loc2_.Configure(this.textOption,this.multiLineText);
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
         _loc2_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
         this.EntryHolder_mc.addChild(_loc2_);
         if(param1 >= 0 && param1 < this.ListClips.length)
         {
            this.ListClips.splice(param1,0,_loc2_);
         }
         else
         {
            this.ListClips.push(_loc2_);
         }
         _loc2_.clipIndex = param1;
         var _loc3_:int = param1 + 1;
         while(_loc3_ < this.ListClips.length)
         {
            ++this.ListClips[_loc3_].clipIndex;
            ++this.ListClips[_loc3_].itemIndex;
            _loc3_++;
         }
         if(this._maxClips == 0 && _loc2_.height > 0)
         {
            _loc4_ = this.containerHeight;
            _loc5_ = _loc2_.height;
            while(_loc4_ > 0)
            {
               _loc4_ -= _loc5_ + this.verticalSpacing;
               ++this._maxClips;
            }
         }
         return _loc2_;
      }
      
      protected function RemoveEntryClip(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:BSContainerEntry = null;
         var _loc4_:int = 0;
         if(param1 < this.ListClips.length)
         {
            _loc2_ = this.ListClips.splice(param1,1);
            _loc3_ = _loc2_[0];
            this.EntryHolder_mc.removeChild(_loc3_);
            this.UnusedListClips.push(_loc3_);
            _loc4_ = param1;
            while(_loc4_ < this.ListClips.length)
            {
               --this.ListClips[_loc4_].clipIndex;
               --this.ListClips[_loc4_].itemIndex;
               _loc4_++;
            }
         }
      }
      
      protected function RemoveFilteredEntry(param1:int) : void
      {
         this.filteredEntries.splice(param1,1);
         if(this.IsFilteredEntryIndexVisible(param1))
         {
            this.RemoveEntryClip(param1 - this.scrollPosition);
         }
      }
      
      protected function IsFilteredEntryIndexVisible(param1:int) : Boolean
      {
         return param1 >= this.scrollPosition && param1 < this.scrollPosition + this.clipCount;
      }
      
      protected function updateScrollPosition(param1:int) : *
      {
         this._scrollPosition = param1;
         this.Update();
      }
      
      protected function Update() : *
      {
         if(!this.initialized)
         {
            GlobalFunc.TraceWarning("BSScrollingDeltaSet::Update -- Can\'t update list before list has been created.");
         }
         while(this.ListClips.length > 0)
         {
            this.RemoveEntryClip(this.ListClips.length - 1);
         }
         this.IncrementalUpdate();
      }
      
      protected function UpdateScrollIndicators() : *
      {
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.visible = this.scrollPosition > 0;
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.visible = this.scrollPosition < this.maxScrollPosition;
         }
         if(this.ScrollBar != null)
         {
            this.ScrollBar.Update(this.scrollPosition,this.maxScrollPosition,this.entryCount);
         }
      }
      
      protected function PositionEntry(param1:BSContainerEntry, param2:Number) : *
      {
         var _loc3_:Rectangle = param1.getBounds(this);
         var _loc4_:Number = param1.y - _loc3_.y;
         var _loc5_:Number = param1.x - _loc3_.x;
         param1.y = this.containerTop + param2 + _loc4_;
         param1.x = this.containerLeft + _loc5_;
      }
      
      protected function IncrementalUpdate() : *
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         var _loc3_:BSContainerEntry = null;
         this.itemsFullyShown = 0;
         while(_loc2_ < this.ListClips.length && _loc1_ <= this.containerHeight && this.scrollPosition + _loc2_ < this.entryCount)
         {
            _loc3_ = this.ListClips[_loc2_];
            this.PositionEntry(_loc3_,_loc1_);
            _loc1_ += _loc3_.clipHeight + this.verticalSpacing;
            if(_loc1_ <= this.containerHeight)
            {
               ++this.itemsFullyShown;
            }
            _loc2_++;
         }
         while(this.ListClips.length > _loc2_)
         {
            this.RemoveEntryClip(this.ListClips.length - 1);
         }
         while(this.scrollPosition + _loc2_ < this.entryCount && _loc1_ <= this.containerHeight)
         {
            _loc3_ = this.NewEntryClip(_loc2_);
            this.UpdateEntryClip(_loc3_,this.filteredEntries[this.scrollPosition + _loc2_],this.scrollPosition + _loc2_);
            this.PositionEntry(_loc3_,_loc1_);
            _loc1_ += _loc3_.clipHeight + this.verticalSpacing;
            _loc2_++;
            if(_loc1_ <= this.containerHeight)
            {
               ++this.itemsFullyShown;
            }
         }
         if(this.selectedIndex >= this.entryCount)
         {
            this.selectedIndex = this.entryCount - 1;
         }
         if(this.scrollPosition > this.maxScrollPosition)
         {
            this.scrollPosition = this.maxScrollPosition;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.clipCount)
         {
            _loc3_ = this.GetClipByIndex(_loc4_);
            if(_loc4_ == this.selectedClipIndex)
            {
               _loc3_.onRollover();
               dispatchEvent(new ScrollingEvent(ScrollingEvent.SELECTION_CHANGE,true,true,this.selectedIndex));
            }
            else
            {
               _loc3_.onRollout();
            }
            _loc4_++;
         }
         this.UpdateScrollIndicators();
      }
      
      protected function UpdateEntryClip(param1:BSContainerEntry, param2:Object, param3:int) : *
      {
         if(param1 != null)
         {
            param1.SetEntryText(param2);
            param1.visible = true;
            param1.itemIndex = param3;
         }
      }
      
      protected function SetSelectedIndex(param1:int) : *
      {
         var _loc2_:BSContainerEntry = null;
         var _loc3_:int = this._selectedIndex;
         if(!this.initialized)
         {
            this._selectedIndex = -1;
            return;
         }
         this._selectedIndex = GlobalFunc.Clamp(param1,-1,this.entryCount - 1);
         if(this._selectedIndex < this.scrollPosition)
         {
            this.scrollPosition -= this.scrollPosition - this._selectedIndex;
         }
         if(this._selectedIndex - this.scrollPosition > this.clipCount - 1)
         {
            this.scrollPosition += this._selectedIndex - this.scrollPosition - (this.clipCount - 1);
         }
         if(this._selectedIndex != _loc3_)
         {
            this.OnSelectionChanged(_loc3_);
         }
      }
      
      public function MoveSelection(param1:int) : *
      {
         var _loc2_:int = this.selectedIndex + param1;
         if(this.wrapAround)
         {
            if(_loc2_ < 0)
            {
               _loc2_ = this.entryCount - 1;
            }
            else if(_loc2_ > this.entryCount - 1)
            {
               _loc2_ = 0;
            }
         }
         else
         {
            _loc2_ = GlobalFunc.Clamp(_loc2_,0,this.entryCount - 1);
         }
         var _loc3_:int = this.selectedIndex;
         if(_loc2_ != _loc3_)
         {
            this.selectedIndex = _loc2_;
         }
      }
      
      protected function OnSelectionChanged(param1:int) : *
      {
         var _loc4_:uint = 0;
         var _loc2_:BSContainerEntry = this.FindClipForEntry(param1);
         if(_loc2_ == null)
         {
            _loc4_ = (_loc4_ = uint(this.entryCount - this.itemsFullyShown)) * (param1 > this.selectedIndex ? -1 : 1);
            _loc2_ = this.FindClipForEntry(param1 + _loc4_);
         }
         if(_loc2_ != null)
         {
            _loc2_.onRollout();
         }
         dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
         var _loc3_:BSContainerEntry = this.FindClipForEntry(this.selectedIndex);
         if(_loc3_ != null)
         {
            _loc3_.onRollover();
         }
         dispatchEvent(new ScrollingEvent(ScrollingEvent.SELECTION_CHANGE,true,true,this._selectedIndex,param1));
      }
      
      protected function onScrollBarMoved(param1:BSScrollingBarPosChangeEvent) : *
      {
         this.scrollPosition = param1.iNewScrollPosition;
      }
      
      public function onScrollUpArrowClick(param1:Event) : *
      {
         if(this.canScroll)
         {
            this.scrollPosition += -1;
            param1.stopPropagation();
         }
      }
      
      public function onScrollDownArrowClick(param1:Event) : *
      {
         if(this.canScroll)
         {
            this.scrollPosition += 1;
            param1.stopPropagation();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(!this.disableInput)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               this.MoveSelection(-1);
               param1.stopPropagation();
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               this.MoveSelection(1);
               param1.stopPropagation();
            }
         }
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(this.canSelect && param1.keyCode == Keyboard.ENTER)
         {
            this.onEntryPress(param1);
         }
      }
      
      public function onEntryRollover(param1:Event) : *
      {
         var _loc2_:int = 0;
         var _loc3_:BSContainerEntry = null;
         if(this.canScroll)
         {
            _loc2_ = this.selectedIndex;
            this.selectedIndex = (param1.currentTarget as BSContainerEntry).itemIndex;
            if(_loc2_ != this.selectedIndex)
            {
               _loc3_ = this.FindClipForEntry(_loc2_);
               if(_loc3_ != null)
               {
                  _loc3_.onRollout();
               }
               dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            }
         }
      }
      
      public function onEntryPress(param1:Event) : *
      {
         dispatchEvent(new ScrollingEvent(this.selectedIndex != -1 ? ScrollingEvent.ITEM_PRESS : ScrollingEvent.LIST_PRESS,true,true,this.selectedIndex));
         param1.stopPropagation();
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         var _loc2_:int = 0;
         if(this.canScroll)
         {
            _loc2_ = this.scrollPosition;
            if(param1.delta != 0)
            {
               this.scrollPosition += param1.delta > 0 ? -1 : 1;
            }
            param1.stopPropagation();
            if(_loc2_ != this.scrollPosition)
            {
               this.selectedIndex += this.scrollPosition - _loc2_;
               dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            }
         }
      }
   }
}
