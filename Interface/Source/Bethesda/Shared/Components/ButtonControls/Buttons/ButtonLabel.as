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
   
   public class ButtonLabel extends MovieClip
   {
       
      
      public var Label_tf:TextField;
      
      protected var Justification:int;
      
      public function ButtonLabel()
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
         var _loc1_:TextFormat = this.Label_tf.getTextFormat();
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               _loc1_.align = TextFormatAlign.RIGHT;
               this.Label_tf.setTextFormat(_loc1_);
               this.Label_tf.autoSize = TextFieldAutoSize.RIGHT;
               break;
            case IButtonUtils.ICON_FIRST:
               _loc1_.align = TextFormatAlign.LEFT;
               this.Label_tf.setTextFormat(_loc1_);
               this.Label_tf.autoSize = TextFieldAutoSize.LEFT;
               break;
            case IButtonUtils.CENTER_BOTH:
               _loc1_.align = TextFormatAlign.CENTER;
               this.Label_tf.setTextFormat(_loc1_);
               this.Label_tf.autoSize = TextFieldAutoSize.CENTER;
         }
         this.AlignClips();
      }
      
      public function SetText(param1:String, param2:Array, param3:Boolean = false) : void
      {
         GlobalFunc.SetText(this.Label_tf,param1,param3,false,0,false,0,param2);
         this.AlignClips();
      }
      
      public function GetBounds() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               _loc1_.topLeft = new Point(this.x - this.width,this.y - this.height / 2);
               _loc1_.bottomRight = new Point(this.x,this.y + this.height / 2);
               break;
            case IButtonUtils.ICON_FIRST:
               _loc1_.topLeft = new Point(this.x,this.y - this.height / 2);
               _loc1_.bottomRight = new Point(this.x + this.width,this.y + this.height / 2);
               break;
            case IButtonUtils.CENTER_BOTH:
               _loc1_.topLeft = new Point(this.x - this.width / 2,this.y - this.height / 2);
               _loc1_.bottomRight = new Point(this.x + this.width / 2,this.y + this.height / 2);
         }
         return _loc1_;
      }
      
      public function set labelColor(param1:uint) : void
      {
         this.Label_tf.textColor = param1;
      }
      
      private function AlignClips() : void
      {
         switch(this.Justification)
         {
            case IButtonUtils.LABEL_FIRST:
               this.Label_tf.x = -this.Label_tf.width;
               break;
            case IButtonUtils.ICON_FIRST:
               this.Label_tf.x = 0;
               break;
            case IButtonUtils.CENTER_BOTH:
               this.Label_tf.x = -(this.Label_tf.width / 2);
         }
      }
   }
}
