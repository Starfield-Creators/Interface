package Shared.AS3
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   
   public class BSTabbedSelection extends BSDisplayObject
   {
      
      public static const CENTER_ALIGNED:* = "Center";
      
      public static const RIGHT_ALIGNED:* = "Right";
      
      public static const LEFT_ALIGNED:* = "Left";
      
      public static const DEFAULT_SPACING:Number = 5;
      
      public static const TABS_CREATED:String = "BSTabbedSelection::tabsCreated";
       
      
      public var Border_mc:MovieClip;
      
      public var LeftButton:MovieClip;
      
      public var RightButton:MovieClip;
      
      protected var EntriesA:Array;
      
      protected var EntryHolder_mc:MovieClip;
      
      protected var iSelectedIndex:int = -1;
      
      protected var bMouseDrivenNav:Boolean = false;
      
      protected var bDisableInput:Boolean = false;
      
      protected var bInitialized:Boolean = false;
      
      protected var bConfigured:Boolean = false;
      
      protected var bHasTabsData:Boolean = false;
      
      private var LeftButtonUserEvents:Array = null;
      
      private var RightButtonUserEvents:Array = null;
      
      protected var strTextOption:String = "none";
      
      protected var TabEntryClass:Class;
      
      protected var DefaultSpacing:Number = 5;
      
      protected var Alignment:String = "Center";
      
      protected var Wrap:Boolean = false;
      
      public function BSTabbedSelection()
      {
         this.EntriesA = new Array();
         this.TabEntryClass = getDefinitionByName("Shared.AS3.BSTabbedSelectionEntry") as Class;
         super();
         if(this.Border_mc == null)
         {
            throw new Error("No \'Border_mc\' clip found.  BSTabbedSelection requires a border rect to define its extents.");
         }
         if(this.LeftButton != null)
         {
            this.LeftButton.SetButtonData(new ButtonBaseData("",[new UserEventData("LShoulder",this.MoveSelectionLeft)],false));
         }
         if(this.RightButton != null)
         {
            this.RightButton.SetButtonData(new ButtonBaseData("",[new UserEventData("RShoulder",this.MoveSelectionRight)],false));
         }
         this.EntryHolder_mc = new MovieClip();
         this.EntryHolder_mc.name = "DynamicEntryHolder_mc";
         this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.Border_mc) + 1);
         this.EntryHolder_mc.x = this.Border_mc.x;
         this.EntryHolder_mc.y = this.Border_mc.y;
      }
      
      public function get initialized() : Boolean
      {
         return this.bInitialized;
      }
      
      public function get numTabs() : int
      {
         return this.EntriesA != null ? int(this.EntriesA.length) : 0;
      }
      
      public function get selectedIndex() : int
      {
         return this.iSelectedIndex;
      }
      
      public function get selectedEntry() : Object
      {
         return this.EntriesA[this.iSelectedIndex];
      }
      
      public function get disableInput() : Boolean
      {
         return this.bDisableInput;
      }
      
      public function set disableInput(param1:Boolean) : void
      {
         this.bDisableInput = param1;
      }
      
      public function Configure(param1:Class = null, param2:String = "Center", param3:* = 5, param4:Array = null, param5:Array = null, param6:String = "none", param7:Boolean = false) : void
      {
         if(param1)
         {
            this.TabEntryClass = param1;
         }
         this.Alignment = param2;
         this.DefaultSpacing = param3;
         this.strTextOption = param6;
         this.Wrap = param7;
         this.bConfigured = true;
         this.UpdateButtonUserEvents(param4,param5);
      }
      
      public function UpdateButtonUserEvents(param1:Array, param2:Array) : void
      {
         this.LeftButtonUserEvents = !!param1 ? param1 : ["LShoulder"];
         this.RightButtonUserEvents = !!param2 ? param2 : ["RShoulder"];
         if(this.LeftButton != null && this.LeftButtonUserEvents.length > 0)
         {
            this.LeftButton.SetButtonData(new ButtonBaseData("",[new UserEventData(this.LeftButtonUserEvents[0],this.MoveSelectionLeft)],false));
         }
         if(this.RightButton != null && this.RightButtonUserEvents.length > 0)
         {
            this.RightButton.SetButtonData(new ButtonBaseData("",[new UserEventData(this.RightButtonUserEvents[0],this.MoveSelectionRight)],false));
         }
         this.UpdateTabs();
      }
      
      public function SetTabsData(param1:Array, param2:uint = 0) : void
      {
         this.EntriesA = param1;
         if(this.EntriesA == null)
         {
            this.EntriesA = new Array();
         }
         this.bHasTabsData = true;
         this.UpdateTabs(param2);
      }
      
      protected function UpdateTabs(param1:uint = 0) : void
      {
         var _loc4_:BSTabbedSelectionEntry = null;
         if(!this.bConfigured || !this.bHasTabsData)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.EntryHolder_mc.numChildren && _loc2_ < this.numTabs)
         {
            this.GetClipByIndex(_loc2_).visible = true;
            _loc2_++;
         }
         _loc2_ = this.EntryHolder_mc.numChildren;
         while(_loc2_ < this.numTabs)
         {
            if((_loc4_ = this.GetNewListEntry()) == null)
            {
               return;
            }
            _loc4_.iIndex = _loc2_;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
            this.EntryHolder_mc.addChild(_loc4_);
            _loc2_++;
         }
         _loc2_ = this.numTabs;
         while(_loc2_ < this.EntryHolder_mc.numChildren)
         {
            this.GetClipByIndex(_loc2_).visible = false;
            _loc2_++;
         }
         this.UpdateAllEntries();
         var _loc3_:Boolean = this.bInitialized;
         this.bInitialized = true;
         if(this.selectedIndex < 0 || this.selectedIndex >= this.numTabs)
         {
            this.SetSelectedIndex(this.numTabs > 0 && param1 < this.numTabs ? int(param1) : -1);
         }
         else
         {
            this.UpdateButtonHints();
         }
         if(!_loc3_)
         {
            dispatchEvent(new Event(TABS_CREATED,true,true));
         }
      }
      
      protected function UpdateButtonHints() : void
      {
         if(this.LeftButton != null)
         {
            this.LeftButton.Enabled = this.iSelectedIndex > 0 || this.Wrap;
         }
         if(this.RightButton != null)
         {
            this.RightButton.Enabled = this.iSelectedIndex < this.numTabs - 1 && this.iSelectedIndex >= 0 || this.Wrap;
         }
      }
      
      protected function GetNewListEntry() : BSTabbedSelectionEntry
      {
         if(this.TabEntryClass == null)
         {
            GlobalFunc.TraceWarning("BSTabbedSelection::GetNewListEntry -- Tab Entry Class is not set.");
            return null;
         }
         var _loc1_:BSTabbedSelectionEntry = new this.TabEntryClass() as BSTabbedSelectionEntry;
         if(_loc1_ == null)
         {
            GlobalFunc.TraceWarning("BSTabbedSelection::GetNewListEntry -- Tab Entry Class is invalid or does not derive from BSTabbedSelectionEntry.");
         }
         return _loc1_;
      }
      
      protected function PositionEntries() : void
      {
         var _loc7_:BSTabbedSelectionEntry = null;
         var _loc8_:Number = NaN;
         var _loc9_:BSTabbedSelectionEntry = null;
         var _loc10_:BSTabbedSelectionEntry = null;
         var _loc11_:Number = NaN;
         if(this.numTabs <= 0)
         {
            return;
         }
         var _loc1_:Array = new Array();
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.numTabs)
         {
            if(!(_loc7_ = this.GetClipByIndex(_loc3_)).LockedWidth)
            {
               _loc1_.push(_loc7_);
            }
            else
            {
               _loc2_ += _loc7_.GetWidth();
            }
            _loc3_++;
         }
         var _loc4_:Number = this.Border_mc.width - _loc2_;
         if(_loc1_.length > 0)
         {
            _loc8_ = _loc4_ / _loc1_.length - this.DefaultSpacing;
            for each(_loc9_ in _loc1_)
            {
               _loc9_.SetWidth(_loc8_);
            }
            _loc4_ = 0;
         }
         var _loc5_:Number = this.Alignment == CENTER_ALIGNED ? Math.max(_loc4_ / (this.numTabs - 1),this.DefaultSpacing) : this.DefaultSpacing;
         var _loc6_:* = this.Alignment == RIGHT_ALIGNED ? this.Border_mc.width : 0;
         _loc3_ = 0;
         while(_loc3_ < this.numTabs)
         {
            (_loc10_ = this.GetClipByIndex(_loc3_)).x = _loc6_;
            if(this.Alignment == RIGHT_ALIGNED)
            {
               _loc10_.x -= _loc10_.GetWidth();
            }
            _loc11_ = _loc10_.GetWidth() + _loc5_;
            if(this.Alignment == RIGHT_ALIGNED)
            {
               _loc11_ = -_loc11_;
            }
            _loc6_ += _loc11_;
            _loc3_++;
         }
      }
      
      protected function onEntryPress(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.bMouseDrivenNav = true;
         var _loc2_:* = param1.currentTarget as BSTabbedSelectionEntry;
         if(_loc2_ != null)
         {
            this.SetSelectedIndex(_loc2_.iIndex);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(this.bDisableInput)
         {
            return false;
         }
         var _loc3_:Boolean = false;
         if(this.LeftButton != null)
         {
            if(this.LeftButtonUserEvents.indexOf(param1) > -1)
            {
               _loc3_ = Boolean(this.LeftButton.HandleUserEvent(this.LeftButtonUserEvents[0],param2,_loc3_));
            }
         }
         if(!_loc3_ && this.RightButton != null)
         {
            if(this.RightButtonUserEvents.indexOf(param1) > -1)
            {
               _loc3_ = Boolean(this.RightButton.HandleUserEvent(this.RightButtonUserEvents[0],param2,_loc3_));
            }
         }
         return _loc3_;
      }
      
      protected function MoveSelectionRight() : void
      {
         this.SetSelectedIndex(this.iSelectedIndex + 1);
      }
      
      protected function MoveSelectionLeft() : void
      {
         this.SetSelectedIndex(this.iSelectedIndex - 1);
      }
      
      protected function SetSelectedIndex(param1:int) : void
      {
         if(!this.bInitialized)
         {
            GlobalFunc.TraceWarning("BSScrollingList::SetSelectedIndex -- Can\'t set selection before list has been created.");
         }
         if(this.Wrap)
         {
            param1 = (param1 + this.numTabs) % this.numTabs;
         }
         if(this.bDisableInput || param1 == this.iSelectedIndex || param1 < 0 || param1 >= this.numTabs)
         {
            return;
         }
         var _loc2_:int = this.iSelectedIndex;
         this.iSelectedIndex = param1;
         this.UpdateEntry(_loc2_);
         this.UpdateSelectedEntry();
         this.UpdateButtonHints();
         dispatchEvent(new BSTabbedSelectionEvent(this.iSelectedIndex,_loc2_,true,true));
      }
      
      protected function UpdateEntry(param1:int) : void
      {
         var _loc2_:BSTabbedSelectionEntry = null;
         if(param1 >= 0 && param1 < this.numTabs)
         {
            _loc2_ = this.GetClipByIndex(param1);
            if(_loc2_ != null)
            {
               _loc2_.Update(this.EntriesA[param1],this.iSelectedIndex == param1,this.strTextOption);
            }
         }
      }
      
      protected function UpdateSelectedEntry() : void
      {
         if(this.iSelectedIndex != -1)
         {
            this.UpdateEntry(this.iSelectedIndex);
         }
      }
      
      protected function UpdateAllEntries() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.numTabs)
         {
            this.UpdateEntry(_loc1_);
            _loc1_++;
         }
         this.PositionEntries();
      }
      
      public function GetClipByIndex(param1:int) : BSTabbedSelectionEntry
      {
         return param1 < this.EntryHolder_mc.numChildren ? this.EntryHolder_mc.getChildAt(param1) as BSTabbedSelectionEntry : null;
      }
   }
}
