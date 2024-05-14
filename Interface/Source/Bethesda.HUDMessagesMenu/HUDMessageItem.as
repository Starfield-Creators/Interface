package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class HUDMessageItem extends HUDFadingListItem
   {
       
      
      public var Internal_mc:MovieClip;
      
      public function HUDMessageItem()
      {
         super();
         this.Text_tf.autoSize = TextFieldAutoSize.RIGHT;
      }
      
      private function get Text_tf() : TextField
      {
         return this.Internal_mc.Text_tf;
      }
      
      private function get BG_mc() : MovieClip
      {
         return this.Internal_mc.Background_mc;
      }
      
      public function SetText(param1:String) : void
      {
         GlobalFunc.SetText(this.Text_tf,param1);
         var _loc2_:Number = 40;
         var _loc3_:Number = 25;
         var _loc4_:Number = -2;
         this.BG_mc.width = this.Text_tf.textWidth + _loc2_;
         this.BG_mc.height = this.Text_tf.textHeight + _loc3_;
         this.BG_mc.x = -this.BG_mc.width;
         this.Text_tf.y = _loc4_ + (this.BG_mc.height - this.Text_tf.textHeight) / 2;
      }
   }
}
