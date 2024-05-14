package Components
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class DisplayList extends MovieClip
   {
       
      
      public var ListBG_mc:MovieClip;
      
      private var EntryHolder_mc:MovieClip;
      
      private var _maxRows:uint = 1;
      
      private var _maxCols:uint = 1;
      
      private var _rowSpacing:uint = 0;
      
      private var _colSpacing:uint = 0;
      
      private var _horizontalPadding:uint = 0;
      
      private var _verticalPadding:uint = 0;
      
      private var _entriesA:*;
      
      private var _defaultHeight:*;
      
      private var _defaultWidth:*;
      
      protected var EntryClass:Class;
      
      public function DisplayList()
      {
         this.EntryClass = getDefinitionByName("Components.DisplayList_Entry") as Class;
         super();
         this.EntryHolder_mc = new MovieClip();
         this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.ListBG_mc) + 1);
         this._entriesA = new Array();
         this._defaultHeight = this.ListBG_mc.height;
         this._defaultWidth = this.ListBG_mc.width;
      }
      
      public function get totalEntryClips() : int
      {
         return this.EntryHolder_mc.numChildren;
      }
      
      public function get entryCount() : uint
      {
         return this._entriesA.length;
      }
      
      public function get entryData() : Array
      {
         return this._entriesA;
      }
      
      public function set entryData(param1:Array) : *
      {
         this._entriesA = param1;
         this.RedrawEntries();
      }
      
      public function Configure(param1:Class, param2:uint = 1, param3:uint = 1, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0) : void
      {
         if(param1)
         {
            this.EntryClass = param1;
         }
         this._maxCols = param2;
         this._maxRows = param3;
         this._colSpacing = param4;
         this._rowSpacing = param5;
         this._horizontalPadding = param6;
         this._verticalPadding = param7;
      }
      
      public function ChangeEntryClass(param1:Class) : void
      {
         this.EntryClass = param1;
         this.RedrawEntries();
      }
      
      public function GetClipByIndex(param1:int) : DisplayList_Entry
      {
         var _loc2_:* = param1 < this.EntryHolder_mc.numChildren ? this.EntryHolder_mc.getChildAt(param1) : null;
         return _loc2_ as DisplayList_Entry;
      }
      
      private function calculateTotalColumns() : uint
      {
         return Math.ceil(this.entryCount / this._maxRows);
      }
      
      private function calculateTotalRows() : uint
      {
         return Math.ceil(this.entryCount / this._maxCols);
      }
      
      private function RedrawEntries() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc12_:DisplayList_Entry = null;
         while(this.EntryHolder_mc.numChildren > 0)
         {
            this.EntryHolder_mc.removeChildAt(0);
         }
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = this._horizontalPadding;
         var _loc8_:Number = this._verticalPadding;
         var _loc9_:uint = 0;
         while(_loc9_ < this._entriesA.length)
         {
            _loc12_ = new this.EntryClass() as DisplayList_Entry;
            this.EntryHolder_mc.addChild(_loc12_);
            _loc12_.SetEntryData(this._entriesA[_loc9_]);
            if(_loc12_.Sizer_mc != null)
            {
               _loc3_ = _loc12_.Sizer_mc.width;
               _loc4_ = _loc12_.Sizer_mc.height;
            }
            else
            {
               _loc3_ = _loc12_.width;
               _loc4_ = _loc12_.height;
            }
            _loc12_.x = _loc7_;
            _loc12_.y = _loc8_;
            if(_loc1_ + 1 < this._maxCols)
            {
               _loc1_++;
               _loc5_ += _loc3_;
               _loc7_ += _loc3_ + this._colSpacing;
            }
            else
            {
               _loc1_ = 0;
               _loc2_++;
               _loc6_ += _loc4_;
               _loc8_ += _loc4_ + this._rowSpacing;
            }
            if(_loc5_ == 0)
            {
               _loc5_ += _loc3_;
            }
            if(_loc6_ == 0)
            {
               _loc6_ += _loc4_;
            }
            _loc9_++;
         }
         var _loc10_:uint;
         if((_loc10_ = this.calculateTotalRows()) > 0)
         {
            this.ListBG_mc.height = _loc6_ + this._rowSpacing * (_loc10_ - 1) + this._verticalPadding * 2;
         }
         else
         {
            this.ListBG_mc.height = this._defaultHeight;
         }
         var _loc11_:uint;
         if((_loc11_ = this.calculateTotalColumns()) > 0)
         {
            this.ListBG_mc.width = _loc5_ + this._colSpacing * (_loc11_ - 1) + this._horizontalPadding * 2;
         }
         else
         {
            this.ListBG_mc.width = this._defaultWidth;
         }
      }
   }
}
