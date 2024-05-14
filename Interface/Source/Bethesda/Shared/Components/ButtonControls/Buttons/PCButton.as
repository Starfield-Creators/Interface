package Shared.Components.ButtonControls.Buttons
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   
   public class PCButton extends MovieClip
   {
       
      
      public var PCButton_tf:TextField;
      
      public var HoldUnderline_mc:MovieClip;
      
      public var HoldAnim_mc:MovieClip;
      
      public var Outline_mc:MovieClip;
      
      protected var Justification:int;
      
      protected const KEY_TEXT_SPACING:Number = -2;
      
      protected const OUTLINE_SPACING:Number = 28;
      
      protected const ARROW_KEY_FONT_SIZE:Number = 22;
      
      private var OriginalKeyTextY:Number = -8;
      
      private var OriginalKeyTextFontSize:Number = 14;
      
      public function PCButton()
      {
         this.Justification = IButtonUtils.LABEL_FIRST;
         super();
         this.OriginalKeyTextY = this.PCButton_tf.y;
         this.OriginalKeyTextFontSize = GlobalFunc.GetTextFieldFontSize(this.PCButton_tf);
         this.SetupAlignment();
      }
      
      public function set justification(param1:int) : void
      {
         if(param1 != this.Justification)
         {
            this.Justification = param1;
            this.SetupAlignment();
         }
      }
      
      protected function SetupAlignment() : void
      {
         var _loc1_:TextFormat = this.PCButton_tf.getTextFormat();
         _loc1_.align = TextFormatAlign.CENTER;
         this.PCButton_tf.setTextFormat(_loc1_);
         this.PCButton_tf.autoSize = TextFieldAutoSize.CENTER;
         this.AlignClips();
      }
      
      public function SetText(param1:String) : void
      {
         var _loc2_:TextLineMetrics = null;
         var _loc4_:Number = NaN;
         GlobalFunc.SetText(this.PCButton_tf,param1);
         var _loc3_:TextFormat = this.PCButton_tf.getTextFormat();
         if(this.HasArrowKey(param1))
         {
            _loc3_.size = this.ARROW_KEY_FONT_SIZE;
            this.PCButton_tf.setTextFormat(_loc3_);
            _loc2_ = this.PCButton_tf.getLineMetrics(0);
            _loc4_ = this.Outline_mc.y + this.Outline_mc.height / 2;
            this.PCButton_tf.y = _loc4_ - _loc2_.height / 2;
         }
         else
         {
            _loc3_.size = this.OriginalKeyTextFontSize;
            this.PCButton_tf.setTextFormat(_loc3_);
            this.PCButton_tf.y = this.OriginalKeyTextY;
         }
         _loc2_ = this.PCButton_tf.getLineMetrics(0);
         this.HoldAnim_mc.width = _loc2_.width + this.OUTLINE_SPACING;
         this.Outline_mc.width = _loc2_.width + this.OUTLINE_SPACING;
         this.HoldUnderline_mc.width = this.PCButton_tf.width;
         this.AlignClips();
      }
      
      public function GetBounds() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               _loc1_.topLeft = new Point(this.x,this.y - this.height / 2);
               _loc1_.bottomRight = new Point(this.x + this.width,this.y + this.height / 2);
               break;
            case IButtonUtils.ICON_FIRST:
               _loc1_.topLeft = new Point(this.x - this.width,this.y - this.height / 2);
               _loc1_.bottomRight = new Point(this.x,this.y + this.height / 2);
               break;
            case IButtonUtils.CENTER_BOTH:
               _loc1_.topLeft = new Point(this.x - this.width / 2,this.y - this.height / 2);
               _loc1_.bottomRight = new Point(this.x + this.width / 2,this.y + this.height / 2);
         }
         return _loc1_;
      }
      
      public function set holdArrowVisible(param1:Boolean) : void
      {
         this.HoldUnderline_mc.visible = param1;
      }
      
      private function HasArrowKey(param1:String) : Boolean
      {
         return param1.indexOf("←") != -1 || param1.indexOf("→") != -1 || param1.indexOf("↓") != -1 || param1.indexOf("↑") != -1;
      }
      
      private function AlignClips() : void
      {
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               this.Outline_mc.x = 0;
               this.HoldAnim_mc.x = 0;
               break;
            case IButtonUtils.ICON_FIRST:
               this.Outline_mc.x = -this.Outline_mc.width;
               this.HoldAnim_mc.x = -this.HoldAnim_mc.width;
               break;
            case IButtonUtils.CENTER_BOTH:
               this.Outline_mc.x = -(this.Outline_mc.width / 2);
               this.HoldAnim_mc.x = -(this.HoldAnim_mc.width / 2);
         }
         var _loc1_:TextLineMetrics = this.PCButton_tf.getLineMetrics(0);
         var _loc2_:Number = this.Outline_mc.x + this.Outline_mc.width / 2;
         this.PCButton_tf.x = _loc2_ - _loc1_.width / 2 + this.KEY_TEXT_SPACING;
         this.HoldUnderline_mc.x = this.PCButton_tf.x;
      }
   }
}
