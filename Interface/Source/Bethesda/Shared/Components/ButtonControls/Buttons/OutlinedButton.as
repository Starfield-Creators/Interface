package Shared.Components.ButtonControls.Buttons
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class OutlinedButton extends ButtonBase
   {
       
      
      public var ConsoleButtonOutline_mc:MovieClip;
      
      public function OutlinedButton()
      {
         super();
      }
      
      override protected function UpdateButtonText() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:String = null;
         super.UpdateButtonText();
         if(KeyHelper != null && Data != null)
         {
            _loc1_ = this.ConsoleButtonOutline_mc.ConsoleButton_tf.getTextFormat();
            switch(ButtonJustification)
            {
               case IButtonUtils.LABEL_FIRST:
                  _loc1_.align = TextFormatAlign.LEFT;
                  this.ConsoleButtonOutline_mc.ConsoleButton_tf.setTextFormat(_loc1_);
                  this.ConsoleButtonOutline_mc.ConsoleButton_tf.autoSize = TextFieldAutoSize.LEFT;
                  break;
               case IButtonUtils.ICON_FIRST:
                  _loc1_.align = TextFormatAlign.RIGHT;
                  this.ConsoleButtonOutline_mc.ConsoleButton_tf.setTextFormat(_loc1_);
                  this.ConsoleButtonOutline_mc.ConsoleButton_tf.autoSize = TextFieldAutoSize.RIGHT;
            }
            _loc2_ = KeyHelper.GetButtonNameForEvent(Data.UserEvents.UserEventKey);
            GlobalFunc.SetText(this.ConsoleButtonOutline_mc.ConsoleButton_tf,KeyHelper.usingController ? _loc2_ : "");
            this.ConsoleButtonOutline_mc.ConsoleButton_tf.visible = KeyHelper.usingController;
            this.ConsoleButtonOutline_mc.x = ConsoleButtonInstance_mc.x;
            this.ConsoleButtonOutline_mc.y = ConsoleButtonInstance_mc.y;
            this.ConsoleButtonOutline_mc.ConsoleButton_tf.x = ConsoleButtonInstance_mc.ConsoleButton_tf.x;
            this.ConsoleButtonOutline_mc.ConsoleButton_tf.y = ConsoleButtonInstance_mc.ConsoleButton_tf.y;
         }
      }
   }
}
