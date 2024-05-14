package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BSContainerEntry extends MovieClip
   {
       
      
      public var Border_mc:MovieClip;
      
      public var textField:TextField;
      
      private var _clipIndex:int;
      
      private var _itemIndex:int;
      
      private var InitialBorderHeight:int = 0;
      
      private var MaxCharactersToDisplay:uint = 0;
      
      private var TwoLineText:Boolean = false;
      
      private var TruncateToFit:Boolean = false;
      
      public function BSContainerEntry()
      {
         super();
         Extensions.enabled = true;
         if(this.Border_mc == null)
         {
            throw new Error("No \'Border_mc\' clip found.  BSContainerEntry requires a border rect.");
         }
         this.hitArea = this.Border_mc;
         this.InitialBorderHeight = this.Border_mc.height;
      }
      
      protected function get baseTextField() : TextField
      {
         return this.textField;
      }
      
      public function get clipIndex() : int
      {
         return this._clipIndex;
      }
      
      public function set clipIndex(param1:int) : *
      {
         this._clipIndex = param1;
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
         return this.Border_mc.height;
      }
      
      public function get selectedFrameLabel() : String
      {
         return "selected";
      }
      
      public function get unselectedFrameLabel() : String
      {
         return "unselected";
      }
      
      public function get animationClip() : MovieClip
      {
         return this;
      }
      
      public function get selected() : Boolean
      {
         return this.animationClip.currentLabel == this.selectedFrameLabel;
      }
      
      public function set maxCharactersToDisplay(param1:uint) : *
      {
         this.MaxCharactersToDisplay = param1;
      }
      
      public function get maxCharactersToDisplay() : uint
      {
         return this.MaxCharactersToDisplay;
      }
      
      public function set twoLineText(param1:Boolean) : *
      {
         this.TwoLineText = param1;
      }
      
      public function get twoLineText() : Boolean
      {
         return this.TwoLineText;
      }
      
      public function set truncateToFit(param1:Boolean) : *
      {
         this.TruncateToFit = param1;
      }
      
      public function get truncateToFit() : Boolean
      {
         return this.TruncateToFit;
      }
      
      public function Configure(param1:String = "none", param2:Boolean = false) : *
      {
         if(this.baseTextField != null)
         {
            TextFieldEx.setTextAutoSize(this.baseTextField,param1);
            this.baseTextField.multiline = param2;
            if(param2)
            {
               this.baseTextField.autoSize = TextFieldAutoSize.LEFT;
               this.baseTextField.multiline = true;
               this.baseTextField.wordWrap = true;
            }
         }
      }
      
      public function SetEntryText(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         GlobalFunc.BSASSERT(param1 != null,"BSContainerEntry: SetEntryText requires a valid Entry!");
         if(this.baseTextField != null)
         {
            _loc2_ = this.TryGetEntryText(param1);
            if(_loc2_ != null)
            {
               if(this.truncateToFit)
               {
                  if(this.baseTextField.numLines > 1)
                  {
                     GlobalFunc.SetTruncatedMultilineText(this.baseTextField,this.TryGetEntryText(param1));
                  }
                  else
                  {
                     GlobalFunc.SetText(this.baseTextField,this.TryGetEntryText(param1),true);
                     GlobalFunc.TruncateSingleLineText(this.baseTextField);
                  }
               }
               else if(this.MaxCharactersToDisplay > 0 && this.TwoLineText)
               {
                  GlobalFunc.SetTwoLineText(this.baseTextField,_loc2_,this.MaxCharactersToDisplay,false);
               }
               else
               {
                  GlobalFunc.SetText(this.baseTextField,_loc2_,true,false,this.MaxCharactersToDisplay);
               }
            }
            else
            {
               GlobalFunc.SetText(this.baseTextField," ");
            }
            if(this.baseTextField.multiline)
            {
               _loc3_ = this.baseTextField.y - this.Border_mc.y;
               this.Border_mc.height = Math.max(this.baseTextField.textHeight + _loc3_ * 2 + 5,this.InitialBorderHeight);
            }
         }
      }
      
      protected function TryGetEntryText(param1:Object) : String
      {
         return param1.text;
      }
      
      public function onRollover() : void
      {
         if(this.animationClip.currentFrameLabel != this.selectedFrameLabel)
         {
            this.animationClip.gotoAndPlay(this.selectedFrameLabel);
         }
      }
      
      public function onRollout() : void
      {
         if(this.animationClip.currentFrameLabel != this.unselectedFrameLabel)
         {
            this.animationClip.gotoAndPlay(this.unselectedFrameLabel);
         }
      }
   }
}
