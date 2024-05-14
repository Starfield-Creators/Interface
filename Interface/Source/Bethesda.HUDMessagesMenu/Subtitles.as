package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class Subtitles extends BSDisplayObject
   {
       
      
      public var SubtitleText_tf:TextField;
      
      private var fOriginalFontSize:Number;
      
      private var fOriginalSubtitleXPos:Number;
      
      private var fOriginalSubtitleBottomPos:Number;
      
      private var fTextAreaWidth:Number;
      
      private var vLineBackgrounds:Vector.<TextBackground>;
      
      private var iNextUnusedBackground:int = 0;
      
      private const TEXT_FIELD_GUTTER:Number = 2;
      
      private const VERTICAL_OFFSET:Number = -230;
      
      private const VERTICAL_OFFSET_NARROW_ASPECT_RATIO:Number = -290;
      
      private const SPEAKER_NAME_COLOR_STR:String = "#E8E8AC";
      
      private const TEXT_COLOR_STR:String = "#D3D3D3";
      
      private const VERTICAL_OFFSET_LRG_MODE:Number = -30;
      
      private var _fTextBGHorizontalPadding:Number = 20;
      
      private var _fTextBGVerticalPadding:Number = 5;
      
      private var _bCenterSingleLineTextBox:Boolean = false;
      
      private var _bAdjustVertically:Boolean = false;
      
      private var _bTallAspectRatio:Boolean = false;
      
      private var _largeTextModeOffset:Number = 0;
      
      public function Subtitles()
      {
         super();
         visible = false;
         this.fOriginalFontSize = GlobalFunc.GetTextFieldFontSize(this.SubtitleText_tf);
         this.fOriginalSubtitleXPos = this.SubtitleText_tf.x;
         this.fOriginalSubtitleBottomPos = this.SubtitleText_tf.y + this.SubtitleText_tf.height;
         this.fTextAreaWidth = this.SubtitleText_tf.width - 2 * this.TEXT_FIELD_GUTTER;
         this.vLineBackgrounds = new Vector.<TextBackground>();
      }
      
      public function get fTextBGHorizontalPadding() : Number
      {
         return this._fTextBGHorizontalPadding;
      }
      
      public function set fTextBGHorizontalPadding(param1:Number) : *
      {
         this._fTextBGHorizontalPadding = param1;
      }
      
      public function get fTextBGVerticalPadding() : Number
      {
         return this._fTextBGVerticalPadding;
      }
      
      public function set fTextBGVerticalPadding(param1:Number) : *
      {
         this._fTextBGVerticalPadding = param1;
      }
      
      public function get bCenterSingleLineTextBox() : Boolean
      {
         return this._bCenterSingleLineTextBox;
      }
      
      public function set bCenterSingleLineTextBox(param1:Boolean) : *
      {
         this._bCenterSingleLineTextBox = param1;
      }
      
      public function get adjustVertically() : Boolean
      {
         return this._bAdjustVertically;
      }
      
      public function set adjustVertically(param1:Boolean) : *
      {
         if(this._bAdjustVertically != param1)
         {
            this._bAdjustVertically = param1;
            this.AdjustPositioningAndSize();
            this.UpdateTextBG();
         }
      }
      
      public function get tallAspectRatio() : Boolean
      {
         return this._bTallAspectRatio;
      }
      
      public function set tallAspectRatio(param1:Boolean) : void
      {
         if(this._bTallAspectRatio != param1)
         {
            this._bTallAspectRatio = param1;
            this.AdjustPositioningAndSize();
            this.UpdateTextBG();
         }
      }
      
      public function get largeTextModeOffset() : Number
      {
         return this._largeTextModeOffset;
      }
      
      public function set largeTextModeOffset(param1:Number) : *
      {
         this._largeTextModeOffset = param1;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("CurrentSubtitleData",this.OnDataChanged);
      }
      
      private function OnDataChanged(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         if(param1 == null || param1.data == null)
         {
            visible = false;
            return;
         }
         _loc2_ = param1.data;
         if(_loc2_.bShouldDisplay)
         {
            visible = true;
            _loc3_ = this.FormatName(_loc2_.sSpeakerName);
            _loc4_ = _loc3_ + "<font color=\'" + this.TEXT_COLOR_STR + "\'>: " + _loc2_.sSubtitleText + "</font>";
            GlobalFunc.SetText(this.SubtitleText_tf,_loc4_,true);
            this.AdjustPositioningAndSize();
            this.UpdateTextBG();
         }
         else
         {
            visible = false;
         }
      }
      
      private function FormatName(param1:String) : String
      {
         return "<font color=\'" + this.SPEAKER_NAME_COLOR_STR + "\'>" + param1 + "</font>";
      }
      
      private function AdjustPositioningAndSize() : *
      {
         var _loc3_:TextLineMetrics = null;
         var _loc4_:Number = NaN;
         var _loc5_:TextFormat = null;
         var _loc6_:Number = NaN;
         var _loc1_:int = this.SubtitleText_tf.numLines;
         if(_loc1_ == 1 && this.bCenterSingleLineTextBox)
         {
            _loc3_ = this.SubtitleText_tf.getLineMetrics(0);
            _loc4_ = (this.fTextAreaWidth - _loc3_.width) / 2;
            this.SubtitleText_tf.x = this.fOriginalSubtitleXPos + _loc4_;
         }
         else
         {
            this.SubtitleText_tf.x = this.fOriginalSubtitleXPos;
            while(this.SubtitleText_tf.maxScrollV > 1)
            {
               (_loc5_ = this.SubtitleText_tf.getTextFormat()).size = GlobalFunc.GetFontSize(_loc5_) - 1;
               this.SubtitleText_tf.setTextFormat(_loc5_);
            }
         }
         var _loc2_:Number = this.getVisibleTextHeight(this.SubtitleText_tf);
         if(this.adjustVertically)
         {
            _loc6_ = this.tallAspectRatio ? this.VERTICAL_OFFSET_NARROW_ASPECT_RATIO : this.VERTICAL_OFFSET;
            this.SubtitleText_tf.y = this.fOriginalSubtitleBottomPos - _loc2_ + this.largeTextModeOffset + _loc6_;
         }
         else
         {
            this.SubtitleText_tf.y = this.fOriginalSubtitleBottomPos - _loc2_ + this.largeTextModeOffset;
         }
      }
      
      private function getVisibleTextHeight(param1:TextField) : Number
      {
         var _loc4_:TextLineMetrics = null;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.numLines)
         {
            _loc4_ = param1.getLineMetrics(_loc3_);
            _loc2_ += _loc4_.height;
            if(_loc3_ == param1.numLines - 1)
            {
               _loc2_ -= _loc4_.leading;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function UpdateTextBG() : *
      {
         var _loc1_:TextBackground = null;
         this.ReleaseAllTextBackgrounds();
         var _loc2_:int = this.SubtitleText_tf.numLines;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.AcquireUnusedTextBackground();
            this.AdjustBackgroundForLine(_loc1_,this.SubtitleText_tf,_loc3_);
            _loc3_++;
         }
      }
      
      private function AcquireUnusedTextBackground() : TextBackground
      {
         var _loc1_:TextBackground = null;
         if(this.iNextUnusedBackground < this.vLineBackgrounds.length)
         {
            _loc1_ = this.vLineBackgrounds[this.iNextUnusedBackground];
            _loc1_.visible = true;
         }
         else
         {
            _loc1_ = new TextBackground();
            this.vLineBackgrounds.push(_loc1_);
            addChildAt(_loc1_,0);
         }
         ++this.iNextUnusedBackground;
         return _loc1_;
      }
      
      private function ReleaseAllTextBackgrounds() : *
      {
         var _loc1_:String = null;
         for(_loc1_ in this.vLineBackgrounds)
         {
            this.vLineBackgrounds[_loc1_].visible = false;
         }
         this.iNextUnusedBackground = 0;
      }
      
      private function AdjustBackgroundForLine(param1:TextBackground, param2:TextField, param3:int) : *
      {
         var _loc4_:TextLineMetrics = null;
         _loc4_ = param2.getLineMetrics(param3);
         param1.x = param2.x + _loc4_.x + this.TEXT_FIELD_GUTTER - this.fTextBGHorizontalPadding;
         var _loc5_:Number = param3 * (_loc4_.height + _loc4_.leading);
         param1.y = param2.y + _loc5_ - _loc4_.leading * param3 - this.fTextBGVerticalPadding;
         param1.width = _loc4_.width + this.TEXT_FIELD_GUTTER + 2 * this.fTextBGHorizontalPadding;
         param1.height = _loc4_.height + this.TEXT_FIELD_GUTTER + 2 * this.fTextBGVerticalPadding - _loc4_.leading;
      }
   }
}
