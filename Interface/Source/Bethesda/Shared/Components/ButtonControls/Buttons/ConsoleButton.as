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
   
   public class ConsoleButton extends MovieClip
   {
      
      private static const ROUNDING_PRECISION:uint = 2;
       
      
      public var ConsoleButton_tf:TextField;
      
      public var HoldArrow_mc:MovieClip;
      
      public var HoldAnim_mc:MovieClip;
      
      protected var Justification:int;
      
      public function ConsoleButton()
      {
         this.Justification = IButtonUtils.LABEL_FIRST;
         super();
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
         var _loc1_:TextFormat = this.ConsoleButton_tf.getTextFormat();
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               _loc1_.align = TextFormatAlign.LEFT;
               this.ConsoleButton_tf.setTextFormat(_loc1_);
               this.ConsoleButton_tf.autoSize = TextFieldAutoSize.LEFT;
               break;
            case IButtonUtils.ICON_FIRST:
               _loc1_.align = TextFormatAlign.RIGHT;
               this.ConsoleButton_tf.setTextFormat(_loc1_);
               this.ConsoleButton_tf.autoSize = TextFieldAutoSize.RIGHT;
               break;
            case IButtonUtils.CENTER_BOTH:
               _loc1_.align = TextFormatAlign.CENTER;
               this.ConsoleButton_tf.setTextFormat(_loc1_);
               this.ConsoleButton_tf.autoSize = TextFieldAutoSize.CENTER;
         }
         this.AlignClips();
      }
      
      public function SetText(param1:String) : void
      {
         GlobalFunc.SetText(this.ConsoleButton_tf,param1);
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
         this.HoldArrow_mc.visible = param1;
      }
      
      private function AlignClips() : void
      {
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               this.ConsoleButton_tf.x = 0;
               break;
            case IButtonUtils.ICON_FIRST:
               this.ConsoleButton_tf.x = -this.ConsoleButton_tf.width;
               break;
            case IButtonUtils.CENTER_BOTH:
               this.ConsoleButton_tf.x = -(this.ConsoleButton_tf.width / 2);
         }
         var _loc1_:Number = this.ConsoleButton_tf.x + this.ConsoleButton_tf.width / 2;
         var _loc2_:Number = this.ConsoleButton_tf.y + this.ConsoleButton_tf.height / 2;
         _loc1_ = GlobalFunc.RoundDecimal(_loc1_,ROUNDING_PRECISION);
         _loc2_ = GlobalFunc.RoundDecimal(_loc2_,ROUNDING_PRECISION);
         this.HoldAnim_mc.y = _loc2_;
         this.HoldAnim_mc.x = _loc1_;
         this.HoldArrow_mc.x = _loc1_;
      }
   }
}
