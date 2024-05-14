package Shared.AS3
{
   import flash.display.MovieClip;
   
   public class BSGridListEntry extends MovieClip
   {
       
      
      public var Sizer_mc:MovieClip;
      
      private var _clipIndex:int;
      
      private var _clipRow:uint;
      
      private var _clipCol:uint;
      
      private var _itemIndex:int;
      
      private var _selected:Boolean = false;
      
      private var _entryData:Object;
      
      public function BSGridListEntry()
      {
         super();
         if(this.Sizer_mc == null)
         {
            throw new Error("No \'Sizer_mc\' clip found.  BSGridListEntry requires a border rect.");
         }
         this.hitArea = this.Sizer_mc;
      }
      
      public function get EntryData() : Object
      {
         return this._entryData;
      }
      
      public function get clipIndex() : int
      {
         return this._clipIndex;
      }
      
      public function set clipIndex(param1:int) : *
      {
         this._clipIndex = param1;
      }
      
      public function get clipRow() : uint
      {
         return this._clipRow;
      }
      
      public function set clipRow(param1:uint) : *
      {
         this._clipRow = param1;
      }
      
      public function get clipCol() : uint
      {
         return this._clipCol;
      }
      
      public function set clipCol(param1:uint) : *
      {
         this._clipCol = param1;
      }
      
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(param1:int) : *
      {
         this._itemIndex = param1;
      }
      
      public function get clipHeight() : Number
      {
         return this.Sizer_mc.height;
      }
      
      public function get clipWidth() : Number
      {
         return this.Sizer_mc.width;
      }
      
      public function get selectedFrameLabel() : String
      {
         return "selected";
      }
      
      public function get unselectedFrameLabel() : String
      {
         return "unselected";
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : *
      {
         if(param1 != this._selected)
         {
            this._selected = param1;
         }
      }
      
      public function SetEntryData(param1:Object) : *
      {
         this._entryData = param1;
      }
      
      public function UpdateAnimation() : *
      {
         if(this.selected)
         {
            gotoAndStop(this.selectedFrameLabel);
         }
         else
         {
            gotoAndStop(this.unselectedFrameLabel);
         }
      }
   }
}
