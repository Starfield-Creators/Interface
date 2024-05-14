package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   
   public class BSGridList extends BSDisplayObject
   {
      
      public static const DIRECTION_UP:int = EnumHelper.GetEnum(0);
      
      public static const DIRECTION_DOWN:int = EnumHelper.GetEnum();
      
      public static const DIRECTION_LEFT:int = EnumHelper.GetEnum();
      
      public static const DIRECTION_RIGHT:int = EnumHelper.GetEnum();
       
      
      public var Body_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollLeft_mc:MovieClip;
      
      public var ScrollRight_mc:MovieClip;
      
      public var ScrollBarVertical_mc:BSScrollingBar;
      
      public var ScrollBarHorizontal_mc:BSScrollingBar;
      
      private var EntryHolder_mc:MovieClip;
      
      private var _entriesA:Array;
      
      private var _visibleEntriesA:Array;
      
      private var _maxRows:uint = 1;
      
      private var _maxCols:uint = 1;
      
      private var _rowSpacing:Number = 0;
      
      private var _columnSpacing:Number = 0;
      
      private var _configured:Boolean = false;
      
      private var _disableInput:Boolean = false;
      
      private var _disableSelection:Boolean = false;
      
      private var _repeatKeyDownIntervalMS:Number = 0;
      
      private var _scrollVertical:Boolean = true;
      
      private var _stageScroll:Boolean = false;
      
      private var _wrapAround:Boolean = true;
      
      private var _selectedIndex:int = -1;
      
      private var _maxDisplayedItems:uint = 0;
      
      private var _listStartIndex:uint = 0;
      
      private var _needRecalculateScrollMax:Boolean = true;
      
      private var _needRecreateClips:Boolean = false;
      
      private var _needRedraw:Boolean = true;
      
      private var _queueSelectUnderMouse:Boolean = false;
      
      private var _rowScrollPos:int = 0;
      
      private var _rowScrollPosMax:int = 0;
      
      private var _colScrollPos:int = 0;
      
      private var _colScrollPosMax:int = 0;
      
      private var KeyDownRepeatLastTriggerTime:int = 0;
      
      protected var EntryClass:Class;
      
      private var bDisableListWrap:Boolean = false;
      
      public function BSGridList()
      {
         this._entriesA = new Array();
         this._visibleEntriesA = new Array();
         this.EntryClass = getDefinitionByName("Shared.AS3.BSGridListEntry") as Class;
         super();
         if(this.Body_mc == null)
         {
            throw new Error("BSGridList: Required MovieClip \"Body_mc\" does not exist!");
         }
         this.EntryHolder_mc = new MovieClip();
         this.EntryHolder_mc.name = "EntryHolder_mc";
         this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.Body_mc) + 1);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         BSUIDataManager.Subscribe("ListWrapData",this.OnListWrapDataUpdate);
      }
      
      public function set maxRows(param1:uint) : void
      {
         this._maxRows = param1;
         this._needRecreateClips = true;
      }
      
      public function set maxCols(param1:uint) : void
      {
         this._maxCols = param1;
         this._needRecreateClips = true;
      }
      
      public function set scrollVertical(param1:Boolean) : void
      {
         this._scrollVertical = param1;
         this._needRecalculateScrollMax = true;
         this._needRedraw = true;
         this.InvalidateData();
      }
      
      public function get scrollVertical() : Boolean
      {
         return this._scrollVertical;
      }
      
      public function get rowSpacing() : Number
      {
         return this._rowSpacing;
      }
      
      public function set rowSpacing(param1:Number) : void
      {
         this._rowSpacing = param1;
      }
      
      public function get columnSpacing() : Number
      {
         return this._columnSpacing;
      }
      
      public function set columnSpacing(param1:Number) : void
      {
         this._columnSpacing = param1;
      }
      
      public function get selectedEntry() : Object
      {
         return this._entriesA[this._selectedIndex];
      }
      
      public function get rowScrollPos() : int
      {
         return this._rowScrollPos;
      }
      
      public function set rowScrollPos(param1:int) : void
      {
         param1 = GlobalFunc.Clamp(param1,0,this._rowScrollPosMax);
         if(param1 != this._rowScrollPos)
         {
            this._rowScrollPos = param1;
            this._needRedraw = true;
            this.InvalidateData();
         }
      }
      
      public function get colScrollPos() : int
      {
         return this._colScrollPos;
      }
      
      public function set colScrollPos(param1:int) : void
      {
         param1 = GlobalFunc.Clamp(param1,0,this._colScrollPosMax);
         if(param1 != this._colScrollPos)
         {
            this._colScrollPos = param1;
            this._needRedraw = true;
            this.InvalidateData();
         }
      }
      
      public function get disableInput() : Boolean
      {
         return this._disableInput;
      }
      
      public function set disableInput(param1:Boolean) : void
      {
         this._disableInput = param1;
      }
      
      public function get disableSelection() : Boolean
      {
         return this._disableSelection;
      }
      
      public function set disableSelection(param1:Boolean) : *
      {
         this._disableSelection = param1;
      }
      
      public function get canScroll() : Boolean
      {
         return !this.disableInput;
      }
      
      public function get canSelect() : Boolean
      {
         return !this.disableInput && !this.disableSelection;
      }
      
      public function get wrapAround() : Boolean
      {
         return this.bDisableListWrap ? false : this._wrapAround;
      }
      
      public function set wrapAround(param1:Boolean) : void
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
      
      public function get selectedCol() : uint
      {
         return this.getColFromIndex(this._selectedIndex);
      }
      
      public function get selectedRow() : uint
      {
         return this.getRowFromIndex(this._selectedIndex);
      }
      
      public function get entryCount() : uint
      {
         return this._entriesA.length;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : *
      {
         var _loc3_:BSGridListEntry = null;
         var _loc4_:BSGridListEntry = null;
         var _loc5_:int = 0;
         if(!this._configured)
         {
            this._selectedIndex = -1;
            return;
         }
         var _loc2_:int = GlobalFunc.Clamp(param1,-1,this.entryCount - 1);
         if(_loc2_ != this.selectedIndex)
         {
            _loc3_ = this.findClipForEntry(this.selectedIndex);
            if(_loc3_ != null)
            {
               _loc3_.selected = false;
               _loc3_.UpdateAnimation();
            }
            if((_loc4_ = this.findClipForEntry(_loc2_)) != null)
            {
               _loc4_.selected = true;
               _loc4_.UpdateAnimation();
            }
            _loc5_ = this._selectedIndex;
            this._selectedIndex = _loc2_;
            dispatchEvent(new ScrollingEvent(ScrollingEvent.SELECTION_CHANGE,true,true,this._selectedIndex,_loc5_));
            this.constrainScrollToSelection();
            this.InvalidateData();
         }
      }
      
      public function get entryData() : Array
      {
         return this._entriesA;
      }
      
      public function set entryData(param1:Array) : void
      {
         this._entriesA = param1;
         this._needRecalculateScrollMax = true;
         this._needRedraw = true;
         this.InvalidateData();
      }
      
      private function getRowFromIndex(param1:int) : uint
      {
         if(param1 > 0)
         {
            return Math.floor(param1 / (this._maxCols + this._colScrollPosMax));
         }
         return 0;
      }
      
      private function getColFromIndex(param1:int) : uint
      {
         if(param1 > 0)
         {
            return param1 % (this._maxCols + this._colScrollPosMax);
         }
         return 0;
      }
      
      public function InvalidateData() : void
      {
         if(this._needRecalculateScrollMax)
         {
            this.calculateListScrollMax();
         }
         if(this._needRecreateClips)
         {
            this.createEntryClips();
         }
         if(this._needRedraw || this._queueSelectUnderMouse)
         {
            this._listStartIndex = this._scrollVertical ? uint(this._maxCols * this._rowScrollPos) : uint(this._maxRows * this._colScrollPos);
         }
         if(this._queueSelectUnderMouse)
         {
            this.selectItemUnderMouse();
         }
         if(this._needRedraw)
         {
            this.redrawList();
         }
      }
      
      public function getIndexFromGridPos(param1:uint, param2:uint) : int
      {
         return param1 * this._maxCols + param2;
      }
      
      private function constrainScrollToSelection() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this._needRecalculateScrollMax)
         {
            this.calculateListScrollMax();
         }
         if(this.selectedIndex > 0)
         {
            _loc1_ = this.selectedRow;
            _loc2_ = this.selectedCol;
            if(this.scrollVertical)
            {
               _loc3_ = uint(this._rowScrollPos);
               _loc4_ = uint(this._rowScrollPos + this._maxRows - 1);
               if(_loc1_ < _loc3_)
               {
                  this.rowScrollPos = _loc1_;
               }
               else if(_loc1_ > _loc4_)
               {
                  this.rowScrollPos = _loc1_ - (this._maxRows - 1);
               }
            }
            else
            {
               _loc5_ = uint(this._colScrollPos);
               _loc6_ = uint(this._colScrollPos + this._maxCols - 1);
               if(_loc2_ < _loc5_)
               {
                  this.colScrollPos = _loc2_;
               }
               else if(_loc2_ > _loc6_)
               {
                  this.colScrollPos = _loc2_ - (this._maxCols - 1);
               }
            }
         }
         else
         {
            this.rowScrollPos = 0;
            this.colScrollPos = 0;
         }
      }
      
      private function OnListWrapDataUpdate(param1:FromClientDataEvent) : void
      {
         this.bDisableListWrap = param1.data.bDisableListWrap;
      }
      
      public function Configure(param1:Class, param2:uint = 1, param3:uint = 1, param4:uint = 0, param5:uint = 0, param6:Boolean = true, param7:Number = 0, param8:Boolean = true, param9:Boolean = false) : void
      {
         if(param1)
         {
            this.EntryClass = param1;
         }
         this.maxCols = param2;
         this.maxRows = param3;
         this.columnSpacing = param4;
         this.rowSpacing = param5;
         this.scrollVertical = param6;
         this._repeatKeyDownIntervalMS = param7;
         this.wrapAround = param8;
         this.stageScroll = param9;
         this._configured = true;
         if(this.stageScroll)
         {
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
      }
      
      public function MoveSelection(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = this.selectedRow;
         var _loc4_:uint = this.selectedCol;
         switch(param1)
         {
            case DIRECTION_UP:
               if(_loc3_ > 0)
               {
                  _loc2_ = true;
                  _loc3_--;
               }
               else if(this.wrapAround)
               {
                  _loc2_ = true;
                  _loc3_ = this.getRowFromIndex(this._entriesA.length - 1);
               }
               break;
            case DIRECTION_DOWN:
               if(_loc3_ < this.getRowFromIndex(this._entriesA.length - 1))
               {
                  _loc2_ = true;
                  _loc3_++;
               }
               else if(this.wrapAround)
               {
                  _loc2_ = true;
                  _loc3_ = 0;
               }
               break;
            case DIRECTION_LEFT:
               if(_loc4_ > 0)
               {
                  _loc2_ = true;
                  _loc4_--;
               }
               else if(this.selectedIndex > 0)
               {
                  _loc2_ = true;
                  _loc4_ = this._maxCols - 1;
                  _loc3_--;
               }
               else if(this.wrapAround)
               {
                  _loc2_ = true;
                  _loc4_ = this._maxCols - 1;
                  _loc3_ = this.getRowFromIndex(this._entriesA.length - 1);
               }
               break;
            case DIRECTION_RIGHT:
               if(_loc4_ < this._maxCols - 1 + this._colScrollPosMax && this.selectedIndex < this.entryData.length - 1)
               {
                  _loc2_ = true;
                  _loc4_++;
               }
               else if(this.selectedIndex < this.entryData.length - 1)
               {
                  _loc2_ = true;
                  _loc4_ = 0;
                  _loc3_++;
               }
               else if(this.wrapAround)
               {
                  _loc2_ = true;
                  _loc4_ = 0;
                  _loc3_ = 0;
               }
         }
         if(_loc2_)
         {
            dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            this.selectedIndex = this.getIndexFromGridPos(_loc3_,_loc4_);
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         var _loc2_:int = 0;
         if(!this.disableInput)
         {
            _loc2_ = getTimer();
            if(_loc2_ - this.KeyDownRepeatLastTriggerTime > this._repeatKeyDownIntervalMS)
            {
               this.KeyDownRepeatLastTriggerTime = _loc2_;
               switch(param1.keyCode)
               {
                  case Keyboard.UP:
                     this.MoveSelection(DIRECTION_UP);
                     param1.stopPropagation();
                     break;
                  case Keyboard.DOWN:
                     this.MoveSelection(DIRECTION_DOWN);
                     param1.stopPropagation();
                     break;
                  case Keyboard.LEFT:
                     this.MoveSelection(DIRECTION_LEFT);
                     param1.stopPropagation();
                     break;
                  case Keyboard.RIGHT:
                     this.MoveSelection(DIRECTION_RIGHT);
                     param1.stopPropagation();
               }
            }
         }
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(!this.disableInput && param1.keyCode == Keyboard.ENTER)
         {
            this.onEntryPress(param1);
         }
      }
      
      public function onEntryPress(param1:Event) : void
      {
         if(!this.disableInput && this.selectedIndex != -1)
         {
            dispatchEvent(new ScrollingEvent(ScrollingEvent.ITEM_PRESS,true,true,this.selectedIndex));
         }
         else
         {
            dispatchEvent(new ScrollingEvent(ScrollingEvent.LIST_PRESS,true,true));
         }
         param1.stopPropagation();
      }
      
      private function onEntryRollover(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if(this.canScroll)
         {
            _loc2_ = this.selectedIndex;
            this.selectedIndex = (param1.currentTarget as BSGridListEntry).itemIndex;
            if(_loc2_ != this.selectedIndex)
            {
               dispatchEvent(new ScrollingEvent(ScrollingEvent.PLAY_FOCUS_SOUND,true,true));
            }
         }
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:* = false;
         if(this.canScroll)
         {
            _loc2_ = param1.delta < 0;
            this._queueSelectUnderMouse = true;
            if(this.scrollVertical)
            {
               this.scrollRow(_loc2_);
            }
            else
            {
               this.scrollCol(_loc2_);
            }
            param1.stopPropagation();
         }
      }
      
      public function scrollRow(param1:Boolean) : void
      {
         var _loc2_:int = param1 ? this._rowScrollPos + 1 : this._rowScrollPos - 1;
         _loc2_ = Math.max(0,_loc2_);
         this.rowScrollPos = _loc2_;
      }
      
      public function scrollCol(param1:Boolean) : void
      {
         var _loc2_:int = param1 ? this._colScrollPos + 1 : this._colScrollPos - 1;
         _loc2_ = Math.max(0,_loc2_);
         this.colScrollPos = _loc2_;
      }
      
      private function onVertScrollBarMoved(param1:BSScrollingBarPosChangeEvent) : *
      {
         if(this.scrollVertical)
         {
            this.rowScrollPos = param1.iNewScrollPosition;
         }
      }
      
      private function onHorizScrollBarMoved(param1:BSScrollingBarPosChangeEvent) : *
      {
         if(!this.scrollVertical)
         {
            this.colScrollPos = param1.iNewScrollPosition;
         }
      }
      
      private function onScrollBarStart(param1:Event) : *
      {
         this.EntryHolder_mc.mouseEnabled = this.EntryHolder_mc.mouseChildren = false;
      }
      
      private function onScrollBarEnd(param1:Event) : *
      {
         this.EntryHolder_mc.mouseEnabled = this.EntryHolder_mc.mouseChildren = true;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollRow(false);
            });
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollRow(true);
            });
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollCol(false);
            });
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
            {
               scrollCol(true);
            });
         }
         if(this.ScrollBarVertical_mc != null)
         {
            this.ScrollBarVertical_mc.addEventListener(BSScrollingBarPosChangeEvent.NAME,this.onVertScrollBarMoved);
            this.ScrollBarVertical_mc.addEventListener(BSScrollingBar.SCROLL_START,this.onScrollBarStart);
            this.ScrollBarVertical_mc.addEventListener(BSScrollingBar.SCROLL_END,this.onScrollBarEnd);
         }
         if(this.ScrollBarHorizontal_mc != null)
         {
            this.ScrollBarHorizontal_mc.addEventListener(BSScrollingBarPosChangeEvent.NAME,this.onHorizScrollBarMoved);
            this.ScrollBarHorizontal_mc.addEventListener(BSScrollingBar.SCROLL_START,this.onScrollBarStart);
            this.ScrollBarHorizontal_mc.addEventListener(BSScrollingBar.SCROLL_END,this.onScrollBarEnd);
         }
      }
      
      private function populateEntryClip(param1:BSGridListEntry, param2:Object) : *
      {
         if(param1 != null)
         {
            param1.selected = param2 == this.selectedEntry;
            param1.SetEntryData(param2);
            param1.UpdateAnimation();
         }
      }
      
      private function calculateListScrollMax() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.scrollVertical)
         {
            this._colScrollPosMax = 0;
            _loc1_ = this.calculateTotalRows();
            this._rowScrollPosMax = Math.max(_loc1_ - this._maxRows,0);
         }
         else
         {
            this._rowScrollPosMax = 0;
            _loc2_ = this.calculateTotalColumns();
            this._colScrollPosMax = Math.max(_loc2_ - this._maxCols,0);
         }
         this._needRecalculateScrollMax = false;
         this._needRedraw = true;
      }
      
      private function calculateTotalColumns() : uint
      {
         return Math.ceil(this.entryCount / this._maxRows);
      }
      
      private function calculateTotalRows() : uint
      {
         return Math.ceil(this.entryCount / this._maxCols);
      }
      
      public function clearList() : void
      {
         this._entriesA.splice(0,this._entriesA.length);
      }
      
      private function createEntryClip(param1:uint, param2:uint, param3:uint) : Boolean
      {
         var _loc4_:BSGridListEntry;
         if((_loc4_ = new this.EntryClass() as BSGridListEntry) != null)
         {
            _loc4_.clipIndex = param1;
            _loc4_.name = "Entry" + param1;
            _loc4_.clipRow = param2;
            _loc4_.clipCol = param3;
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
            _loc4_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
            this.EntryHolder_mc.addChild(_loc4_);
            return true;
         }
         trace("BSGridList::createEntryClip -- EntryClass is invalid or does not derive from BSGridListEntry.");
         return false;
      }
      
      private function createEntryClips() : void
      {
         while(this.EntryHolder_mc.numChildren > 0)
         {
            this.EntryHolder_mc.removeChildAt(0);
         }
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.scrollVertical)
         {
            _loc2_ = 0;
            while(_loc2_ < this._maxRows)
            {
               _loc3_ = 0;
               while(_loc3_ < this._maxCols)
               {
                  if(this.createEntryClip(_loc1_,_loc2_,_loc3_))
                  {
                     _loc1_++;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this._maxCols)
            {
               _loc2_ = 0;
               while(_loc2_ < this._maxRows)
               {
                  if(this.createEntryClip(_loc1_,_loc2_,_loc3_))
                  {
                     _loc1_++;
                  }
                  _loc2_++;
               }
               _loc3_++;
            }
         }
         this._maxDisplayedItems = _loc1_;
         this._needRecreateClips = false;
      }
      
      private function findClipForEntry(param1:int) : BSGridListEntry
      {
         var _loc4_:BSGridListEntry = null;
         var _loc2_:BSGridListEntry = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.EntryHolder_mc.numChildren)
         {
            if((_loc4_ = this.getClipByIndex(_loc3_)).itemIndex == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getClipByIndex(param1:int) : BSGridListEntry
      {
         return param1 < this.EntryHolder_mc.numChildren && param1 > -1 ? this.EntryHolder_mc.getChildAt(param1) as BSGridListEntry : null;
      }
      
      private function updateScrollIndicators() : void
      {
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.visible = this._scrollVertical && this._rowScrollPos > 0;
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.visible = this._scrollVertical && this._rowScrollPos < this._rowScrollPosMax;
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.visible = !this._scrollVertical && this._colScrollPos > 0;
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.visible = !this._scrollVertical && this._colScrollPos < this._colScrollPosMax;
         }
         if(this.ScrollBarVertical_mc != null)
         {
            if(this._scrollVertical && this._rowScrollPosMax > 0)
            {
               this.ScrollBarVertical_mc.Update(this._rowScrollPos,this._rowScrollPosMax,this.calculateTotalRows());
               this.ScrollBarVertical_mc.visible = true;
            }
            else
            {
               this.ScrollBarVertical_mc.visible = false;
            }
         }
         if(this.ScrollBarHorizontal_mc != null)
         {
            if(!this._scrollVertical && this._colScrollPosMax > 0)
            {
               this.ScrollBarHorizontal_mc.Update(this._colScrollPos,this._colScrollPosMax,this.calculateTotalColumns());
               this.ScrollBarHorizontal_mc.visible = true;
            }
            else
            {
               this.ScrollBarHorizontal_mc.visible = false;
            }
         }
      }
      
      private function selectItemUnderMouse() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:BSGridListEntry = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Point = null;
         if(!this._disableInput)
         {
            this._queueSelectUnderMouse = false;
            _loc1_ = 0;
            while(_loc1_ < this._maxDisplayedItems)
            {
               _loc2_ = this.getClipByIndex(_loc1_);
               _loc3_ = _loc2_ as MovieClip;
               if(_loc2_.Sizer_mc != null)
               {
                  _loc3_ = _loc2_.Sizer_mc;
               }
               _loc4_ = localToGlobal(new Point(mouseX,mouseY));
               if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y,false))
               {
                  this.selectedIndex = this._listStartIndex + _loc1_;
               }
               _loc1_++;
            }
         }
      }
      
      private function redrawList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:BSGridListEntry = null;
         if(this._maxDisplayedItems > 0)
         {
            _loc1_ = this._listStartIndex;
            _loc2_ = this._entriesA.length;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < this._maxDisplayedItems)
            {
               if((_loc5_ = this.getClipByIndex(_loc4_)) != null)
               {
                  if(_loc4_ + _loc1_ < _loc2_)
                  {
                     _loc5_.itemIndex = _loc4_ + _loc1_;
                     this.populateEntryClip(_loc5_,this._entriesA[_loc4_ + _loc1_]);
                     _loc5_.visible = true;
                     _loc5_.x = (_loc5_.clipWidth + this.columnSpacing) * _loc5_.clipCol + this.Body_mc.x;
                     _loc5_.y = (_loc5_.clipHeight + this.rowSpacing) * _loc5_.clipRow + this.Body_mc.y;
                  }
                  else
                  {
                     _loc5_.visible = false;
                     _loc5_.itemIndex = -1;
                  }
               }
               _loc4_++;
            }
            this.updateScrollIndicators();
         }
         else
         {
            trace("BSGridList::redrawList -- List configuration resulted in _maxDisplayedItems < 1 (unable to display any items)");
         }
         this._needRedraw = false;
      }
   }
}
