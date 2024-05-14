package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.Extensions;
   
   public class BSScrollingList extends BSDisplayObject
   {
      
      public static const TEXT_OPTION_NONE:String = "None";
      
      public static const TEXT_OPTION_SHRINK_TO_FIT:String = "Shrink To Fit";
      
      public static const TEXT_OPTION_MULTILINE:String = "Multi-Line";
      
      public static const SELECTION_CHANGE:String = "BSScrollingList::selectionChange";
      
      public static const ITEM_PRESS:String = "BSScrollingList::itemPress";
      
      public static const LIST_PRESS:String = "BSScrollingList::listPress";
      
      public static const LIST_ITEMS_CREATED:String = "BSScrollingList::listItemsCreated";
      
      public static const PLAY_FOCUS_SOUND:String = "BSScrollingList::playFocusSound";
      
      public static const MOBILE_ITEM_PRESS:String = "BSScrollingList::mobileItemPress";
       
      
      public var border:MovieClip;
      
      public var ScrollUp:MovieClip;
      
      public var ScrollDown:MovieClip;
      
      public var ScrollBar:BSScrollingBar;
      
      protected var EntriesA:Array;
      
      protected var EntryHolder_mc:MovieClip;
      
      protected var _filterer:ListFilterer;
      
      protected var iSelectedIndex:int;
      
      protected var bRestoreListIndex:Boolean;
      
      protected var iListItemsShown:uint;
      
      protected var uiNumListItems:uint;
      
      protected var ListEntryClass:Class;
      
      protected var fListHeight:Number;
      
      protected var fListWidth:Number;
      
      protected var fVerticalSpacing:Number;
      
      protected var fListUpperBound:Number;
      
      protected var fListLowerBound:Number;
      
      protected var fListLeftBound:Number;
      
      protected var fListRightBound:Number;
      
      protected var iScrollPosition:uint;
      
      protected var iMaxScrollPosition:uint;
      
      protected var iNumFilteredEntries:uint;
      
      protected var bMouseDrivenNav:Boolean;
      
      protected var fShownItemsHeight:Number;
      
      protected var bInitialized:Boolean;
      
      protected var strTextOption:String;
      
      protected var strDatafieldForText:String = "text";
      
      protected var bDisableSelection:Boolean;
      
      protected var bAllowSelectionDisabledListNav:Boolean;
      
      protected var bDisableInput:Boolean;
      
      protected var bWrapAround:Boolean;
      
      protected var bUpdated:Boolean;
      
      protected var bScrollBarScrolling:Boolean = false;
      
      private var bDisableListWrap:Boolean = false;
      
      public function BSScrollingList()
      {
         this.ListEntryClass = getDefinitionByName("Shared.AS3.BSScrollingListEntry") as Class;
         super();
         this.EntriesA = new Array();
         this._filterer = new ListFilterer();
         this._filterer.addEventListener(ListFilterer.FILTER_CHANGE,this.onFilterChange);
         this._filterer.addEventListener(ListFilterer.ARRAY_CHANGE,this.onFilteredArrayChange);
         this.strTextOption = TEXT_OPTION_NONE;
         this.fVerticalSpacing = 0;
         this.uiNumListItems = 0;
         this.bRestoreListIndex = true;
         this.bDisableSelection = false;
         this.bAllowSelectionDisabledListNav = false;
         this.bDisableInput = false;
         this.bMouseDrivenNav = false;
         this.bUpdated = false;
         this.bInitialized = false;
         this.bWrapAround = true;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         if(this.border == null)
         {
            throw new Error("No \'border\' clip found.  BSScrollingList requires a border rect to define its extents.");
         }
         this.EntryHolder_mc = new MovieClip();
         this.EntryHolder_mc.name = "EntryHolder_mc";
         this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.border) + 1);
         this.iSelectedIndex = -1;
         this.iScrollPosition = 0;
         this.iMaxScrollPosition = 0;
         this.iListItemsShown = 0;
         this.fListHeight = 0;
         this.fListWidth = 0;
         this.fListUpperBound = 0;
         this.fListLowerBound = 0;
         this.fListLeftBound = 0;
         this.fListRightBound = 0;
         if(this.ScrollUp != null)
         {
            this.ScrollUp.visible = false;
         }
         if(this.ScrollDown != null)
         {
            this.ScrollDown.visible = false;
         }
         BSUIDataManager.Subscribe("ListWrapData",this.OnListWrapDataUpdate);
      }
      
      protected function get ListScrollSize() : Number
      {
         return this.fListHeight;
      }
      
      private function OnListWrapDataUpdate(param1:FromClientDataEvent) : void
      {
         this.bDisableListWrap = param1.data.bDisableListWrap;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         if(this.ScrollUp != null)
         {
            this.ScrollUp.addEventListener(MouseEvent.CLICK,this.onScrollArrowClick);
         }
         if(this.ScrollDown != null)
         {
            this.ScrollDown.addEventListener(MouseEvent.CLICK,this.onScrollArrowClick);
         }
         if(this.ScrollBar != null)
         {
            this.ScrollBar.addEventListener(BSScrollingBar.SCROLL_START,this.onScrollBarStart);
            this.ScrollBar.addEventListener(BSScrollingBarPosChangeEvent.NAME,this.onScrollBarMoved);
            this.ScrollBar.addEventListener(BSScrollingBar.SCROLL_END,this.onScrollBarEnd);
         }
      }
      
      public function onStyleUpdated() : void
      {
         if(!this.bInitialized)
         {
            this.SetNumListItems(this.uiNumListItems);
         }
      }
      
      public function onScrollArrowClick(param1:Event) : *
      {
         if(!this.bDisableInput && (!this.bDisableSelection || this.bAllowSelectionDisabledListNav))
         {
            this.doSetSelectedIndex(-1);
            if(param1.target == this.ScrollUp || param1.target.parent == this.ScrollUp)
            {
               --this.scrollPosition;
            }
            else if(param1.target == this.ScrollDown || param1.target.parent == this.ScrollDown)
            {
               this.scrollPosition += 1;
            }
            param1.stopPropagation();
         }
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
         this.selectedIndex = _loc2_ ? int((_loc1_ as BSScrollingListEntry).itemIndex) : 0;
      }
      
      protected function onScrollBarStart(param1:Event) : *
      {
         this.bScrollBarScrolling = true;
      }
      
      protected function onScrollBarMoved(param1:BSScrollingBarPosChangeEvent) : *
      {
         this.scrollPosition = param1.iNewScrollPosition;
      }
      
      protected function onScrollBarEnd(param1:Event) : *
      {
         this.bScrollBarScrolling = false;
      }
      
      public function onEntryRollover(param1:Event) : *
      {
         var _loc2_:* = undefined;
         this.bMouseDrivenNav = true;
         if(!this.bDisableInput && !this.bDisableSelection && !this.bScrollBarScrolling)
         {
            _loc2_ = this.iSelectedIndex;
            this.doSetSelectedIndex((param1.currentTarget as BSScrollingListEntry).itemIndex);
            if(_loc2_ != this.iSelectedIndex)
            {
               dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
            }
         }
      }
      
      public function onEntryPress(param1:MouseEvent) : *
      {
         param1.stopPropagation();
         this.bMouseDrivenNav = true;
         this.onItemPress();
      }
      
      public function ClearList() : *
      {
         this.EntriesA.splice(0,this.EntriesA.length);
      }
      
      public function GetClipByIndex(param1:uint) : BSScrollingListEntry
      {
         return param1 < this.EntryHolder_mc.numChildren ? this.EntryHolder_mc.getChildAt(param1) as BSScrollingListEntry : null;
      }
      
      public function FindClipForEntry(param1:int) : BSScrollingListEntry
      {
         var _loc4_:BSScrollingListEntry = null;
         if(param1 == -1 || param1 == int.MAX_VALUE || param1 >= this.EntriesA.length)
         {
            return null;
         }
         if(!this.bUpdated)
         {
            GlobalFunc.TraceWarning("FindClipForEntry will always fail to find a clip before Update() has been called at least once");
         }
         var _loc2_:BSScrollingListEntry = null;
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
      
      public function GetEntryFromClipIndex(param1:uint) : int
      {
         var _loc2_:BSScrollingListEntry = this.GetClipByIndex(param1);
         return !!_loc2_ ? int(_loc2_.itemIndex) : -1;
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(!this.bDisableInput)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               this.moveSelectionUp();
               param1.stopPropagation();
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               this.moveSelectionDown();
               param1.stopPropagation();
            }
         }
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(!this.bDisableInput && !this.bDisableSelection && param1.keyCode == Keyboard.ENTER)
         {
            this.onItemPress();
            param1.stopPropagation();
         }
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         if(!this.bDisableInput && (!this.bDisableSelection || this.bAllowSelectionDisabledListNav) && this.iMaxScrollPosition > 0)
         {
            _loc2_ = this.scrollPosition;
            if(param1.delta < 0)
            {
               this.scrollPosition += 1;
            }
            else if(param1.delta > 0)
            {
               --this.scrollPosition;
            }
            this.SetFocusUnderMouse();
            param1.stopPropagation();
            if(_loc2_ != this.scrollPosition)
            {
               dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
            }
         }
      }
      
      private function SetFocusUnderMouse() : *
      {
         var _loc2_:BSScrollingListEntry = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Point = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.iListItemsShown)
         {
            _loc2_ = this.GetClipByIndex(_loc1_);
            _loc3_ = _loc2_.border;
            _loc4_ = localToGlobal(new Point(mouseX,mouseY));
            if(_loc2_.hitTestPoint(_loc4_.x,_loc4_.y,false))
            {
               this.selectedIndex = _loc2_.itemIndex;
            }
            _loc1_++;
         }
      }
      
      public function get mouseDrivenNav() : Boolean
      {
         return this.bMouseDrivenNav;
      }
      
      public function get filterer() : ListFilterer
      {
         return this._filterer;
      }
      
      public function get itemsShown() : uint
      {
         return this.iListItemsShown;
      }
      
      public function get initialized() : Boolean
      {
         return this.bInitialized;
      }
      
      public function get selectedIndex() : int
      {
         return this.iSelectedIndex;
      }
      
      public function set selectedIndex(param1:int) : *
      {
         this.doSetSelectedIndex(param1);
      }
      
      public function get selectedClipIndex() : int
      {
         var _loc1_:BSScrollingListEntry = this.FindClipForEntry(this.iSelectedIndex);
         return _loc1_ != null ? int(_loc1_.clipIndex) : -1;
      }
      
      public function set selectedClipIndex(param1:int) : *
      {
         this.doSetSelectedIndex(this.GetEntryFromClipIndex(param1));
      }
      
      public function set filterer(param1:ListFilterer) : *
      {
         this._filterer = param1;
      }
      
      public function get shownItemsHeight() : Number
      {
         return this.fShownItemsHeight;
      }
      
      protected function IsClipOutOfListBounds(param1:uint) : Boolean
      {
         var _loc4_:Rectangle = null;
         var _loc2_:Boolean = false;
         var _loc3_:BSScrollingListEntry = this.GetClipByIndex(param1);
         if(_loc3_ != null)
         {
            if((_loc4_ = _loc3_.getBounds(this)).bottom > this.fListLowerBound)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      protected function doSetSelectedIndex(param1:int) : *
      {
         var _loc3_:int = 0;
         var _loc4_:BSScrollingListEntry = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:BSScrollingListEntry = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc2_:BSScrollingListEntry = null;
         if(!this.bInitialized || this.numListItems_Inspectable == 0)
         {
            trace("BSScrollingList::doSetSelectedIndex -- Can\'t set selection before list has been created.");
         }
         if(!this.bDisableSelection && param1 != this.iSelectedIndex)
         {
            _loc3_ = this.iSelectedIndex;
            this.iSelectedIndex = param1;
            if(this.EntriesA.length == 0)
            {
               this.iSelectedIndex = -1;
            }
            if(_loc3_ != -1 && _loc3_ < this.EntriesA.length)
            {
               if((_loc4_ = this.FindClipForEntry(_loc3_)) != null)
               {
                  this.SetEntry(_loc4_,this.EntriesA[_loc3_]);
               }
            }
            if(this.iSelectedIndex != -1)
            {
               this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
               if(this.iSelectedIndex == int.MAX_VALUE)
               {
                  this.iSelectedIndex = -1;
               }
            }
            if(this.iSelectedIndex != -1)
            {
               _loc2_ = this.FindClipForEntry(this.iSelectedIndex);
               if(_loc2_ == null)
               {
                  this.InvalidateData();
                  _loc2_ = this.FindClipForEntry(this.iSelectedIndex);
               }
               if(this.iSelectedIndex != -1 && _loc3_ != this.iSelectedIndex)
               {
                  _loc5_ = false;
                  if(this.scrollPosition != this.maxScrollPosition && uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE)
                  {
                     if((_loc6_ = this.GetEntryFromClipIndex(this.iListItemsShown - 1)) != -1 && _loc6_ == this.iSelectedIndex)
                     {
                        if((_loc7_ = this.FindClipForEntry(_loc6_)) != null)
                        {
                           _loc5_ = this.IsClipOutOfListBounds(_loc7_.clipIndex);
                        }
                     }
                  }
                  if(_loc2_ != null && !_loc5_)
                  {
                     this.SetEntry(_loc2_,this.EntriesA[this.iSelectedIndex]);
                  }
                  else if(this.iListItemsShown > 0)
                  {
                     _loc8_ = this.GetEntryFromClipIndex(0);
                     _loc9_ = this.GetEntryFromClipIndex(this.iListItemsShown - 1);
                     _loc11_ = 0;
                     if(this.iSelectedIndex < _loc8_)
                     {
                        _loc10_ = _loc8_;
                        do
                        {
                           _loc10_ = this._filterer.GetPrevFilterMatch(_loc10_);
                           _loc11_--;
                        }
                        while(_loc10_ != this.iSelectedIndex && _loc10_ != -1 && _loc10_ != int.MAX_VALUE);
                        
                     }
                     else if(this.iSelectedIndex > _loc9_)
                     {
                        _loc10_ = _loc9_;
                        _loc12_ = 0;
                        _loc13_ = this.shownItemsHeight;
                        do
                        {
                           _loc11_++;
                           if(_loc12_ < this.uiNumListItems)
                           {
                              _loc13_ -= this.GetEntryScrollDimSize(_loc12_) + this.fVerticalSpacing;
                              _loc12_++;
                           }
                           else
                           {
                              trace("BSScrollingList::doSetSelectedIndex -- Somehow removing all of the visible clips was not enough reduce the visible height, " + _loc13_ + ", below the list height, " + this.ListScrollSize + ". was one of the heights negative? Is the world flat?");
                           }
                           if(_loc13_ < this.ListScrollSize)
                           {
                              if((_loc10_ = this._filterer.GetNextFilterMatch(_loc10_)) != this.iSelectedIndex)
                              {
                                 _loc13_ += this.GetEntryScrollDimSize(_loc10_) + this.fVerticalSpacing;
                              }
                           }
                        }
                        while(_loc10_ != this.iSelectedIndex && _loc10_ != -1 && _loc10_ != int.MAX_VALUE);
                        
                     }
                     else if(_loc5_)
                     {
                        _loc11_++;
                     }
                     this.scrollPosition += _loc11_;
                  }
               }
            }
            if(_loc3_ != this.iSelectedIndex)
            {
               dispatchEvent(new Event(SELECTION_CHANGE,true,true));
            }
         }
      }
      
      public function get scrollPosition() : uint
      {
         return this.iScrollPosition;
      }
      
      public function get maxScrollPosition() : uint
      {
         return this.iMaxScrollPosition;
      }
      
      public function set scrollPosition(param1:uint) : *
      {
         if(param1 != this.iScrollPosition && param1 >= 0 && param1 <= this.iMaxScrollPosition)
         {
            this.updateScrollPosition(param1);
         }
      }
      
      protected function updateScrollPosition(param1:uint) : *
      {
         this.iScrollPosition = param1;
         this.UpdateList();
      }
      
      public function get selectedEntry() : Object
      {
         return this.EntriesA[this.iSelectedIndex];
      }
      
      public function get entryList() : Array
      {
         return this.EntriesA;
      }
      
      public function set entryList(param1:Array) : *
      {
         this.EntriesA = param1;
         if(this.EntriesA == null)
         {
            this.EntriesA = new Array();
         }
      }
      
      public function get disableInput_Inspectable() : Boolean
      {
         return this.bDisableInput;
      }
      
      public function set disableInput_Inspectable(param1:Boolean) : *
      {
         this.bDisableInput = param1;
      }
      
      public function get textOption_Inspectable() : String
      {
         return this.strTextOption;
      }
      
      public function set textOption_Inspectable(param1:String) : *
      {
         this.strTextOption = param1;
      }
      
      public function get verticalSpacing_Inspectable() : *
      {
         return this.fVerticalSpacing;
      }
      
      public function set verticalSpacing_Inspectable(param1:Number) : *
      {
         this.fVerticalSpacing = param1;
      }
      
      public function get numListItems_Inspectable() : uint
      {
         return this.uiNumListItems;
      }
      
      public function set numListItems_Inspectable(param1:uint) : *
      {
         this.uiNumListItems = param1;
      }
      
      public function get listEntryClass_Inspectable() : String
      {
         return getQualifiedClassName(this.ListEntryClass);
      }
      
      public function set listEntryClass_Inspectable(param1:String) : *
      {
         this.ListEntryClass = getDefinitionByName(param1) as Class;
      }
      
      public function get restoreListIndex_Inspectable() : Boolean
      {
         return this.bRestoreListIndex;
      }
      
      public function set restoreListIndex_Inspectable(param1:Boolean) : *
      {
         this.bRestoreListIndex = param1;
      }
      
      public function get disableSelection_Inspectable() : Boolean
      {
         return this.bDisableSelection;
      }
      
      public function set disableSelection_Inspectable(param1:Boolean) : *
      {
         this.bDisableSelection = param1;
      }
      
      public function get dataFieldForText() : String
      {
         return this.strDatafieldForText;
      }
      
      public function set dataFieldForText(param1:String) : *
      {
         this.strDatafieldForText = param1;
      }
      
      public function set allowWheelScrollNoSelectionChange(param1:Boolean) : *
      {
         this.bAllowSelectionDisabledListNav = param1;
      }
      
      public function get wrapAround() : Boolean
      {
         return this.bDisableListWrap ? false : this.bWrapAround;
      }
      
      public function set wrapAround(param1:Boolean) : *
      {
         this.bWrapAround = param1;
      }
      
      public function SetNumListItems(param1:uint) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         if(this.ListEntryClass != null && param1 > 0)
         {
            if(this.EntryHolder_mc.numChildren > 0)
            {
               this.EntryHolder_mc.removeChildren();
            }
            _loc2_ = 0;
            while(_loc2_ < param1)
            {
               _loc3_ = this.GetNewListEntry(_loc2_);
               if(_loc3_ != null)
               {
                  _loc3_.clipIndex = _loc2_;
                  _loc3_.name = "ListEntry" + _loc2_;
                  _loc3_.datafieldForText = this.strDatafieldForText;
                  _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
                  _loc3_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
                  this.EntryHolder_mc.addChild(_loc3_);
               }
               else
               {
                  GlobalFunc.TraceWarning("BSScrollingList::SetNumListItems -- List Entry Class is invalid or does not derive from BSScrollingListEntry.");
               }
               _loc2_++;
            }
            this.bInitialized = true;
            dispatchEvent(new Event(LIST_ITEMS_CREATED,true,true));
         }
      }
      
      protected function GetNewListEntry(param1:uint) : BSScrollingListEntry
      {
         return new this.ListEntryClass() as BSScrollingListEntry;
      }
      
      public function UpdateList() : *
      {
         var _loc4_:BSScrollingListEntry = null;
         var _loc5_:BSScrollingListEntry = null;
         if(!this.bInitialized || this.numListItems_Inspectable == 0)
         {
            GlobalFunc.TraceWarning("BSScrollingList::UpdateList -- Can\'t update list before list has been created.");
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = this._filterer.FindArrayIndexOfFilteredPosition(this.iScrollPosition);
         var _loc3_:uint = 0;
         while(_loc3_ < this.uiNumListItems)
         {
            if(_loc4_ = this.GetClipByIndex(_loc3_))
            {
               _loc4_.visible = false;
               _loc4_.itemIndex = int.MAX_VALUE;
            }
            _loc3_++;
         }
         this.iListItemsShown = 0;
         while(_loc2_ != int.MAX_VALUE && _loc2_ != -1 && _loc2_ < this.EntriesA.length && this.iListItemsShown < this.uiNumListItems && _loc1_ <= this.ListScrollSize)
         {
            if(_loc5_ = this.GetClipByIndex(this.iListItemsShown))
            {
               this.SetEntry(_loc5_,this.EntriesA[_loc2_]);
               _loc5_.visible = true;
               _loc5_.itemIndex = _loc2_;
               _loc1_ += this.GetExistingEntryScrollDimSize(_loc5_);
               if(_loc1_ <= this.ListScrollSize && this.iListItemsShown < this.uiNumListItems)
               {
                  _loc1_ += this.fVerticalSpacing;
                  ++this.iListItemsShown;
               }
               else
               {
                  ++this.iListItemsShown;
               }
            }
            _loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
         }
         this.PositionEntries();
         if(this.ScrollUp != null)
         {
            this.ScrollUp.visible = this.scrollPosition > 0;
         }
         if(this.ScrollDown != null)
         {
            this.ScrollDown.visible = this.scrollPosition < this.iMaxScrollPosition;
         }
         if(this.ScrollBar != null)
         {
            this.ScrollBar.Update(this.scrollPosition,this.maxScrollPosition,this.iNumFilteredEntries);
         }
         this.bUpdated = true;
      }
      
      protected function PositionEntries() : *
      {
         var _loc2_:BSScrollingListEntry = null;
         var _loc3_:Rectangle = null;
         var _loc1_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < this.iListItemsShown)
         {
            _loc2_ = this.GetClipByIndex(_loc6_);
            _loc3_ = _loc2_.getBounds(this);
            _loc4_ = _loc2_.y - _loc3_.y;
            _loc5_ = _loc2_.x - _loc3_.x;
            _loc2_.y = this.fListUpperBound + _loc1_ + _loc4_;
            _loc2_.x = this.fListLeftBound + _loc5_;
            _loc1_ += this.GetExistingEntryScrollDimSize(_loc2_) + this.fVerticalSpacing;
            _loc6_++;
         }
         this.fShownItemsHeight = _loc1_;
      }
      
      public function InvalidateData() : *
      {
         var _loc1_:int = this.selectedClipIndex;
         var _loc2_:Boolean = false;
         var _loc3_:Rectangle = this.border.getBounds(this);
         this.fListHeight = _loc3_.height;
         this.fListWidth = _loc3_.width;
         this.fListUpperBound = _loc3_.top;
         this.fListLowerBound = _loc3_.bottom;
         this.fListLeftBound = _loc3_.left;
         this.fListRightBound = _loc3_.right;
         this._filterer.filterArray = this.EntriesA;
         this.HandleFiltererChange();
         if(this.iSelectedIndex >= this.EntriesA.length)
         {
            this.iSelectedIndex = this.EntriesA.length - 1;
            _loc2_ = true;
         }
         if(!this._filterer.IsValidIndex(this.iSelectedIndex))
         {
            if(this._filterer.GetPrevFilterMatch(this.iSelectedIndex) == int.MAX_VALUE)
            {
               if(this._filterer.GetNextFilterMatch(this.iSelectedIndex) == int.MAX_VALUE)
               {
                  this.iSelectedIndex = -1;
               }
            }
         }
         if(this.iScrollPosition > this.iMaxScrollPosition)
         {
            this.iScrollPosition = this.iMaxScrollPosition;
         }
         this.UpdateList();
         if(_loc1_ != -1 && this.restoreListIndex_Inspectable)
         {
            this.selectedClipIndex = _loc1_;
         }
         else if(_loc2_)
         {
            dispatchEvent(new Event(SELECTION_CHANGE,true,true));
         }
      }
      
      public function UpdateSelectedEntry() : *
      {
         var _loc1_:BSScrollingListEntry = null;
         if(this.iSelectedIndex != -1)
         {
            _loc1_ = this.FindClipForEntry(this.iSelectedIndex);
            if(_loc1_ != null)
            {
               this.SetEntry(_loc1_,this.EntriesA[this.iSelectedIndex]);
            }
         }
      }
      
      public function UpdateEntry(param1:int) : *
      {
         var _loc2_:Object = this.EntriesA[param1];
         var _loc3_:BSScrollingListEntry = this.FindClipForEntry(param1);
         this.SetEntry(_loc3_,_loc2_);
      }
      
      public function onFilterChange() : *
      {
         this.HandleFiltererChange();
      }
      
      public function onFilteredArrayChange() : *
      {
         this.HandleFiltererChange();
      }
      
      protected function HandleFiltererChange() : *
      {
         var _loc1_:int = this.iSelectedIndex;
         this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
         if(this.iSelectedIndex == int.MAX_VALUE)
         {
            this.iSelectedIndex = -1;
         }
         this.CalculateMaxScrollPosition();
         this.iNumFilteredEntries = this._filterer.GetCountMatchingFilter();
         this.UpdateList();
         if(_loc1_ != this.iSelectedIndex)
         {
            dispatchEvent(new Event(SELECTION_CHANGE,true,true));
         }
      }
      
      protected function CalculateMaxScrollPosition() : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:int = this._filterer.EntryMatchesFilter(this.EntriesA[this.EntriesA.length - 1]) ? int(this.EntriesA.length - 1) : this._filterer.GetPrevFilterMatch(this.EntriesA.length - 1);
         if(_loc1_ == int.MAX_VALUE)
         {
            this.iMaxScrollPosition = 0;
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = _loc1_;
            _loc4_ = 1;
            while(_loc3_ != int.MAX_VALUE && _loc2_ <= this.ListScrollSize && _loc4_ < this.uiNumListItems)
            {
               _loc5_ = _loc3_;
               _loc3_ = this._filterer.GetPrevFilterMatch(_loc3_);
               if(_loc3_ != int.MAX_VALUE)
               {
                  _loc2_ += this.GetEntryScrollDimSize(_loc3_) + this.fVerticalSpacing;
                  if(_loc2_ <= this.ListScrollSize)
                  {
                     _loc4_++;
                  }
                  else
                  {
                     _loc3_ = _loc5_;
                  }
               }
            }
            if(_loc3_ == int.MAX_VALUE)
            {
               this.iMaxScrollPosition = 0;
            }
            else
            {
               _loc6_ = 0;
               _loc7_ = this._filterer.GetPrevFilterMatch(_loc3_);
               while(_loc7_ != int.MAX_VALUE)
               {
                  _loc6_++;
                  _loc7_ = this._filterer.GetPrevFilterMatch(_loc7_);
               }
               this.iMaxScrollPosition = _loc6_;
            }
         }
      }
      
      protected function GetEntryScrollDimSize(param1:Number) : Number
      {
         var _loc2_:BSScrollingListEntry = this.GetClipByIndex(0);
         var _loc3_:Number = 0;
         if(_loc2_ != null)
         {
            if(_loc2_.hasDynamicHeight)
            {
               this.SetEntry(_loc2_,this.EntriesA[param1]);
               _loc3_ = this.GetExistingEntryScrollDimSize(_loc2_);
            }
            else
            {
               _loc3_ = _loc2_.defaultHeight;
            }
         }
         return _loc3_;
      }
      
      protected function GetExistingEntryScrollDimSize(param1:BSScrollingListEntry) : Number
      {
         var _loc2_:Number = param1.height;
         if(param1.Sizer_mc)
         {
            _loc2_ = param1.Sizer_mc.height;
         }
         return _loc2_;
      }
      
      public function moveSelectionUp() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!this.bDisableSelection || this.bAllowSelectionDisabledListNav)
         {
            _loc1_ = int.MAX_VALUE;
            if(this.selectedIndex > 0)
            {
               _loc2_ = this._filterer.GetPrevFilterMatch(this.selectedIndex);
               if(_loc2_ != int.MAX_VALUE)
               {
                  this.selectedIndex = _loc2_;
                  this.bMouseDrivenNav = false;
                  dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
               }
               else if(this.wrapAround)
               {
                  _loc1_ = this._filterer.GetLastFilterMatch();
                  if(_loc1_ != int.MAX_VALUE && _loc1_ != this.selectedIndex)
                  {
                     this.selectedIndex = _loc1_;
                     this.bMouseDrivenNav = false;
                     dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
                  }
               }
            }
            else if(this.wrapAround)
            {
               _loc1_ = this._filterer.GetLastFilterMatch();
               if(_loc1_ != int.MAX_VALUE)
               {
                  this.selectedIndex = _loc1_;
                  this.bMouseDrivenNav = false;
                  dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
               }
            }
         }
         else
         {
            --this.scrollPosition;
         }
      }
      
      public function moveSelectionDown() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!this.bDisableSelection || this.bAllowSelectionDisabledListNav)
         {
            _loc1_ = int.MAX_VALUE;
            if(this.selectedIndex < this.EntriesA.length - 1)
            {
               _loc2_ = this._filterer.GetNextFilterMatch(this.selectedIndex);
               if(_loc2_ != int.MAX_VALUE)
               {
                  this.selectedIndex = _loc2_;
                  this.bMouseDrivenNav = false;
                  dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
               }
               else if(this.wrapAround)
               {
                  _loc1_ = this._filterer.GetFirstFilterMatch();
                  if(_loc1_ != int.MAX_VALUE)
                  {
                     this.selectedIndex = _loc1_;
                     this.bMouseDrivenNav = false;
                     dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
                  }
               }
            }
            else if(this.wrapAround)
            {
               _loc1_ = this._filterer.GetFirstFilterMatch();
               if(_loc1_ != int.MAX_VALUE)
               {
                  this.selectedIndex = _loc1_;
                  this.bMouseDrivenNav = false;
                  dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
               }
            }
         }
         else
         {
            this.scrollPosition += 1;
         }
      }
      
      protected function onItemPress() : *
      {
         if(!this.bDisableInput && !this.bDisableSelection && this.iSelectedIndex != -1)
         {
            dispatchEvent(new Event(ITEM_PRESS,true,true));
         }
         else
         {
            dispatchEvent(new Event(LIST_PRESS,true,true));
         }
      }
      
      protected function SetEntry(param1:BSScrollingListEntry, param2:Object) : *
      {
         if(param1 != null)
         {
            param1.selected = param2 == this.selectedEntry;
            param1.SetEntryText(param2,this.strTextOption);
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.bMouseDrivenNav = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
   }
}
