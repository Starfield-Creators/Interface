package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.Extensions;
   
   public class BSScrollingContainer extends BSDisplayObject
   {
      
      public static const ADDED_TO_STAGE:String = "BSScrollingContainer::ADDED_TO_STAGE";
       
      
      public var Border_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollBar:BSScrollingBar;
      
      private var EntryHolder_mc:MovieClip;
      
      private var _entriesA:Array;
      
      private var _visibleEntriesA:Array;
      
      private var _selectedIndex:int = -1;
      
      private var _scrollPosition:int = 0;
      
      private var _initialized:Boolean = false;
      
      private var _disableInput:Boolean = false;
      
      private var _textOption:String = "none";
      
      private var _multiLineText:Boolean = false;
      
      private var _verticalSpacing:Number = 0;
      
      private var _restoreListIndex:Boolean = true;
      
      private var _disableSelection:Boolean = false;
      
      private var _listItemsShown:int = 0;
      
      protected var _filterComparitor:Function = null;
      
      private var _wrapAround:Boolean = true;
      
      private var _stageScroll:* = false;
      
      private var _truncateToFit:* = false;
      
      protected var EntryClass:Class;
      
      private var ContainerRect:Rectangle;
      
      private var bDisableListWrap:Boolean = false;
      
      public function BSScrollingContainer()
      {
         this._entriesA = new Array();
         this._visibleEntriesA = new Array();
         this.EntryClass = getDefinitionByName("Shared.AS3.BSContainerEntry") as Class;
         super();
         if(this.Border_mc == null)
         {
            throw new Error("BSScrollingContainer: Required MovieClip \"Border_mc\" does not exist!");
         }
         this.EntryHolder_mc = new MovieClip();
         this.EntryHolder_mc.name = "EntryHolder_mc";
         this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.Border_mc) + 1);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
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
      
      public function get stageScroll() : Boolean
      {
         return this._stageScroll;
      }
      
      public function set stageScroll(param1:Boolean) : *
      {
         this._stageScroll = param1;
      }
      
      public function set truncateToFit(param1:Boolean) : *
      {
         this._truncateToFit = param1;
      }
      
      public function get truncateToFit() : Boolean
      {
         return this._truncateToFit;
      }
      
      public function get scrollbarScrolling() : Boolean
      {
         return this.ScrollBar != null ? this.ScrollBar.scrolling : false;
      }
      
      public function get maxScrollPosition() : int
      {
         return Math.max(this.entryCount - this.itemsShown,0);
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
      
      public function get totalEntryClips() : int
      {
         return this.EntryHolder_mc.numChildren;
      }
      
      public function get itemsShown() : int
      {
         return this._listItemsShown;
      }
      
      public function set itemsShown(param1:int) : *
      {
         this._listItemsShown = param1;
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
      
      protected function get entryList() : Array
      {
         return this._visibleEntriesA;
      }
      
      protected function set entryList(param1:Array) : *
      {
         this._visibleEntriesA = param1;
      }
      
      public function get entryCount() : int
      {
         return this.entryList.length;
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
         return this.entryList[this.selectedIndex];
      }
      
      public function get selectedClipIndex() : int
      {
         return this.selectedIndex - this.scrollPosition;
      }
      
      public function get scrollBarHeight() : Number
      {
         var _loc1_:Number = 0;
         if(this.ScrollBar != null)
         {
            _loc1_ = this.ScrollBar.height;
         }
         return _loc1_;
      }
      
      public function set scrollBarHeight(param1:Number) : void
      {
         if(this.ScrollBar != null)
         {
            this.ScrollBar.height = param1;
         }
      }
      
      public function get borderHeight() : Number
      {
         return this.Border_mc.height;
      }
      
      public function set borderHeight(param1:Number) : void
      {
         this.Border_mc.height = param1;
         this.UpdateContainerRect();
      }
      
      public function get borderYPosition() : Number
      {
         return this.Border_mc.y;
      }
      
      public function set borderYPosition(param1:Number) : void
      {
         this.Border_mc.y = param1;
      }
      
      protected function get shouldFilter() : Boolean
      {
         return this._filterComparitor != null;
      }
      
      private function OnListWrapDataUpdate(param1:FromClientDataEvent) : void
      {
         this.bDisableListWrap = param1.data.bDisableListWrap;
      }
      
      public function InitializeEntries(param1:Array) : void
      {
         var _loc2_:* = undefined;
         this._entriesA = param1;
         if(this.shouldFilter)
         {
            this.FilterEntries();
         }
         else
         {
            this.ClearEntryList();
            for each(_loc2_ in this.rawEntries)
            {
               this.entryList.push(_loc2_);
            }
         }
         this.InvalidateData();
      }
      
      public function RecreateEntryClips() : *
      {
         this.EntryHolder_mc.removeChildren();
         this.ReinitializeEntries();
      }
      
      public function ReinitializeEntries() : void
      {
         this.InitializeEntries(this.rawEntries);
      }
      
      public function FilterEntries() : void
      {
         var _loc1_:* = undefined;
         this.ClearEntryList();
         for each(_loc1_ in this.rawEntries)
         {
            if(this._filterComparitor(_loc1_))
            {
               this.entryList.push(_loc1_);
            }
         }
      }
      
      public function SetFilterComparitor(param1:Function, param2:* = true) : void
      {
         this._filterComparitor = param1;
         if(param2)
         {
            this.FilterEntries();
            this.InvalidateData();
         }
      }
      
      public function SortEntriesOn(param1:*, param2:* = 0, ... rest) : void
      {
         this.entryList.sortOn(param1,param2);
         this.InvalidateData();
      }
      
      public function SortEntries(param1:Function, param2:* = 0) : void
      {
         this.entryList.sort(param1,param2);
         this.InvalidateData();
      }
      
      public function ChangeEntryClass(param1:String) : void
      {
         this.entryClass = param1;
         this.RecreateEntryClips();
      }
      
      public function Configure(param1:BSScrollingConfigParams) : void
      {
         if(this.initialized)
         {
            GlobalFunc.TraceWarning("Calling BSScrollingContainer::Configure after it\'s already been initialized. Skipping new Configure.");
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
         this.stageScroll = param1.StageScroll;
         this.truncateToFit = param1.TruncateToFit;
         this.initialized = true;
         if(this.stageScroll)
         {
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
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
            this.ScrollBar.addEventListener(BSScrollingBar.SCROLL_START,this.onScrollBarStart);
            this.ScrollBar.addEventListener(BSScrollingBar.SCROLL_END,this.onScrollBarEnd);
         }
         this.dispatchEvent(new Event(ADDED_TO_STAGE,true,true));
      }
      
      public function ClearEntryList() : void
      {
         this.entryList.splice(0,this.entryList.length);
      }
      
      public function GetDataForEntry(param1:int) : Object
      {
         return param1 < this.entryCount && param1 > -1 ? this.entryList[param1] : null;
      }
      
      public function GetEntryFromClipIndex(param1:int) : int
      {
         var _loc2_:BSContainerEntry = this.GetClipByIndex(param1);
         return !!_loc2_ ? _loc2_.itemIndex : -1;
      }
      
      public function GetClipByIndex(param1:int, param2:Boolean = false) : BSContainerEntry
      {
         var _loc3_:* = param1 < this.EntryHolder_mc.numChildren && param1 > -1 ? this.EntryHolder_mc.getChildAt(param1) : null;
         if(_loc3_ == null && param2)
         {
            _loc3_ = this.GetNewEntry();
            _loc3_.name = "Entry" + param1;
            _loc3_.clipIndex = param1;
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
            this.EntryHolder_mc.addChild(_loc3_);
         }
         return _loc3_ as BSContainerEntry;
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
      
      public function UpdateContainerRect() : *
      {
         this.ContainerRect = this.Border_mc.getBounds(this);
         this.Update();
      }
      
      protected function GetNewEntry() : BSContainerEntry
      {
         var _loc1_:BSContainerEntry = new this.EntryClass() as BSContainerEntry;
         _loc1_.Configure(this.textOption,this.multiLineText);
         _loc1_.truncateToFit = this.truncateToFit;
         return _loc1_;
      }
      
      protected function InvalidateData() : *
      {
         if(this.selectedIndex >= this.entryCount)
         {
            this.selectedIndex = this.entryCount - 1;
         }
         if(this.scrollPosition > this.maxScrollPosition)
         {
            this.scrollPosition = this.maxScrollPosition;
         }
         this.Update();
      }
      
      protected function updateScrollPosition(param1:int) : *
      {
         this._scrollPosition = param1;
         this.Update();
      }
      
      protected function Update() : *
      {
         var _loc6_:BSContainerEntry = null;
         var _loc7_:BSContainerEntry = null;
         var _loc8_:BSContainerEntry = null;
         if(!this.initialized)
         {
            GlobalFunc.TraceWarning("BSScrollingContainer::Update -- Can\'t update list before list has been created.");
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = this.scrollPosition;
         var _loc3_:Boolean = false;
         this.itemsShown = 0;
         while(_loc2_ != -1 && _loc2_ < this.entryCount && _loc1_ <= this.containerHeight)
         {
            if(_loc6_ = this.GetClipByIndex(this._listItemsShown,true))
            {
               this.UpdateEntryClip(_loc6_,this.entryList[_loc2_]);
               _loc6_.itemIndex = _loc2_;
               this.PositionEntry(_loc6_,_loc1_);
               _loc1_ += _loc6_.clipHeight;
               if(_loc1_ < this.containerHeight || GlobalFunc.CloseToNumber(_loc1_,this.containerHeight,1))
               {
                  _loc1_ += this.verticalSpacing;
                  ++this.itemsShown;
               }
               else
               {
                  _loc3_ = true;
               }
            }
            _loc2_++;
         }
         if(this.selectedClipIndex >= this.itemsShown && _loc3_ && this._selectedIndex - this.scrollPosition > this.itemsShown - 1)
         {
            this.scrollPosition += this._selectedIndex - this.scrollPosition - (this.itemsShown - 1);
            return;
         }
         var _loc4_:int = this.itemsShown;
         if(this.multiLineText && _loc3_)
         {
            _loc4_++;
         }
         while(_loc4_ < this.totalEntryClips)
         {
            if(_loc7_ = this.GetClipByIndex(_loc4_))
            {
               _loc7_.visible = false;
               _loc7_.itemIndex = -1;
            }
            _loc4_++;
         }
         this.UpdateScrollIndicators();
         var _loc5_:int = 0;
         while(_loc5_ < this.totalEntryClips)
         {
            _loc8_ = this.GetClipByIndex(_loc5_);
            if(_loc5_ == this.selectedClipIndex)
            {
               _loc8_.onRollover();
               dispatchEvent(new ScrollingEvent(ScrollingEvent.SELECTION_CHANGE,true,true,this._selectedIndex,-1,this.entryList[this._selectedIndex]));
            }
            else
            {
               _loc8_.onRollout();
            }
            _loc5_++;
         }
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
      
      protected function UpdateEntryClip(param1:BSContainerEntry, param2:Object) : *
      {
         if(param1 != null)
         {
            param1.SetEntryText(param2);
            param1.visible = true;
         }
      }
      
      protected function SetSelectedIndex(param1:int) : *
      {
         var _loc2_:BSContainerEntry = null;
         var _loc3_:int = this._selectedIndex;
         var _loc4_:int = this.scrollPosition;
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
         if(this._selectedIndex - this.scrollPosition > this.itemsShown - 1)
         {
            this.scrollPosition += this._selectedIndex - this.scrollPosition - (this.itemsShown - 1);
         }
         if(this._selectedIndex != _loc3_)
         {
            this.OnSelectionChanged(_loc3_,_loc4_);
         }
      }
      
      protected function SetSelectedIndexUnsafe(param1:int) : *
      {
         this._selectedIndex = param1;
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
            if(_loc2_ >= this.entryCount || _loc2_ < 0)
            {
               dispatchEvent(new ScrollingEvent(ScrollingEvent.LIST_WOULD_HAVE_SCROLLED,true,true,_loc2_,this.selectedIndex,this.entryList[_loc2_]));
            }
            _loc2_ = GlobalFunc.Clamp(_loc2_,0,this.entryCount - 1);
         }
         var _loc3_:int = this.selectedIndex;
         if(_loc2_ != _loc3_)
         {
            dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            this.selectedIndex = _loc2_;
         }
      }
      
      protected function OnSelectionChanged(param1:int, param2:int) : *
      {
         var _loc4_:int = 0;
         var _loc5_:BSContainerEntry = null;
         var _loc3_:BSContainerEntry = this.FindClipForEntry(this.selectedIndex);
         if(_loc3_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.totalEntryClips)
            {
               if((_loc5_ = this.GetClipByIndex(_loc4_)) == _loc3_)
               {
                  _loc5_.onRollover();
               }
               else
               {
                  _loc5_.onRollout();
               }
               _loc4_++;
            }
         }
         dispatchEvent(new ScrollingEvent(ScrollingEvent.SELECTION_CHANGE,true,true,this.selectedIndex,param1,this.entryList[this.selectedIndex]));
      }
      
      public function SetInitSelection() : *
      {
         var _loc1_:DisplayObject = Extensions.getMouseTopMostEntity();
         var _loc2_:Boolean = false;
         while(!_loc2_ && _loc1_ != null)
         {
            if(_loc1_.parent === this.EntryHolder_mc)
            {
               _loc2_ = true;
            }
            else
            {
               _loc1_ = _loc1_.parent;
            }
         }
         this.selectedIndex = _loc2_ ? (_loc1_ as BSContainerEntry).itemIndex : 0;
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
         var _loc2_:* = undefined;
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
         dispatchEvent(new ScrollingEvent(this.selectedIndex != -1 && this.canSelect ? ScrollingEvent.ITEM_PRESS : ScrollingEvent.LIST_PRESS,true,true,this.selectedIndex,-1,this.entryList[this.selectedIndex]));
         param1.stopPropagation();
      }
      
      public function onMouseDownHandler(param1:Event) : *
      {
         dispatchEvent(new ScrollingEvent(ScrollingEvent.ENTRY_MOUSE_DOWN,true,true,this.selectedIndex,-1,this.entryList[this.selectedIndex]));
         param1.stopPropagation();
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
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
      
      private function onScrollBarStart(param1:Event) : *
      {
         this.EntryHolder_mc.mouseEnabled = this.EntryHolder_mc.mouseChildren = false;
      }
      
      private function onScrollBarEnd(param1:Event) : *
      {
         var _loc3_:BSContainerEntry = null;
         this.EntryHolder_mc.mouseEnabled = this.EntryHolder_mc.mouseChildren = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.totalEntryClips)
         {
            _loc3_ = this.GetClipByIndex(_loc2_);
            if(_loc3_.selected)
            {
               this._selectedIndex = _loc3_.itemIndex;
               break;
            }
            _loc2_++;
         }
      }
   }
}
