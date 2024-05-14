package
{
   import flash.text.TextFieldAutoSize;
   
   public class CreditsLineCenter extends CreditsLine
   {
       
      
      public function CreditsLineCenter()
      {
         super();
         Title_tf.autoSize = TextFieldAutoSize.CENTER;
         Content_tf.autoSize = TextFieldAutoSize.CENTER;
      }
      
      override public function SetCreditText(param1:String, param2:Array) : void
      {
         super.SetCreditText(param1,param2);
         Content_tf.y = Title_tf.height + 5;
      }
   }
}
