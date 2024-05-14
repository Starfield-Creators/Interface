package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BSScrollingListEntry extends MovieClip
   {
      
      protected static const SELECTED_FRAME_LABEL:String = "selected";
      
      protected static const UNSELECTED_FRAME_LABEL:String = "unselected";
       
      
      public var border:MovieClip;
      
      public var textField:TextField;
      
      public var Sizer_mc:MovieClip;
      
      protected var _clipIndex:uint;
      
      protected var _itemIndex:uint;
      
      protected var _selected:Boolean;
      
      protected var ORIG_BORDER_HEIGHT:Number;
      
      protected var ORIG_BORDER_WIDTH:Number;
      
      protected var _HasDynamicHeight:Boolean = false;
      
      protected var _dataFieldForText:String = "text";
      
      public function BSScrollingListEntry()
      {
         super();
         Extensions.enabled = true;
         this.ORIG_BORDER_HEIGHT = this.border != null ? this.border.height : 0;
         this.ORIG_BORDER_WIDTH = this.border != null ? this.border.width : 0;
         if(this.textField != null)
         {
            this.textField.mouseEnabled = false;
         }
         if(this.Sizer_mc)
         {
            this.hitArea = this.Sizer_mc;
         }
      }
      
      public function get clipIndex() : uint
      {
         return this._clipIndex;
      }
      
      public function set clipIndex(param1:uint) : *
      {
         this._clipIndex = param1;
      }
      
      public function get itemIndex() : uint
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(param1:uint) : *
      {
         this._itemIndex = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : *
      {
         this._selected = param1;
      }
      
      public function get hasDynamicHeight() : Boolean
      {
         return this._HasDynamicHeight;
      }
      
      public function get defaultHeight() : Number
      {
         return this.ORIG_BORDER_HEIGHT;
      }
      
      public function get defaultWidth() : Number
      {
         return this.ORIG_BORDER_WIDTH;
      }
      
      public function set datafieldForText(param1:String) : *
      {
         this._dataFieldForText = param1;
      }
      
      public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc3_:Number = NaN;
         if(currentLabel == SELECTED_FRAME_LABEL)
         {
            if(param2 == BSScrollingList.TEXT_OPTION_MULTILINE)
            {
               GlobalFunc.TraceWarning("Multiline lists do not support frame label animations!");
            }
            if(!this.selected)
            {
               gotoAndPlay(UNSELECTED_FRAME_LABEL);
            }
         }
         else if(currentLabel == UNSELECTED_FRAME_LABEL)
         {
            if(param2 == BSScrollingList.TEXT_OPTION_MULTILINE)
            {
               GlobalFunc.TraceWarning("Multiline lists do not support frame label animations!");
            }
            if(this.selected)
            {
               gotoAndPlay(SELECTED_FRAME_LABEL);
            }
         }
         else if(this.border != null)
         {
            this.border.alpha = this.selected ? GlobalFunc.SELECTED_RECT_ALPHA : 0;
         }
         if(this.textField != null)
         {
            if(param2 == BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT)
            {
               TextFieldEx.setTextAutoSize(this.textField,"shrink");
            }
            else if(param2 == BSScrollingList.TEXT_OPTION_MULTILINE)
            {
               this.textField.autoSize = TextFieldAutoSize.LEFT;
               this.textField.multiline = true;
               this.textField.wordWrap = true;
            }
            if(param1 != null && param1[this._dataFieldForText] != undefined)
            {
               GlobalFunc.SetText(this.textField,param1[this._dataFieldForText],true);
            }
            else
            {
               GlobalFunc.SetText(this.textField," ",true);
            }
            if(this.border != null && param2 == BSScrollingList.TEXT_OPTION_MULTILINE)
            {
               if(this.textField.numLines > 1)
               {
                  _loc3_ = this.textField.y - this.border.y;
                  this.border.height = this.textField.textHeight + _loc3_ * 2 + 5;
               }
               else
               {
                  this.border.height = this.ORIG_BORDER_HEIGHT;
               }
            }
         }
      }
   }
}
