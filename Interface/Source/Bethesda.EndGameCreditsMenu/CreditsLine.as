package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class CreditsLine extends MovieClip
   {
       
      
      public var Title_tf:TextField;
      
      public var Content_tf:TextField;
      
      public function CreditsLine()
      {
         super();
         Extensions.enabled = true;
         this.Title_tf.autoSize = TextFieldAutoSize.RIGHT;
         this.Content_tf.autoSize = TextFieldAutoSize.LEFT;
         TextFieldEx.setVerticalAutoSize(this.Title_tf,TextFieldEx.VAUTOSIZE_TOP);
         TextFieldEx.setVerticalAutoSize(this.Content_tf,TextFieldEx.VAUTOSIZE_TOP);
      }
      
      public function SetCreditText(param1:String, param2:Array) : void
      {
         GlobalFunc.SetText(this.Title_tf,param1,true);
         var _loc3_:String = "";
         var _loc4_:uint = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ += param2[_loc4_];
            _loc4_++;
         }
         GlobalFunc.SetText(this.Content_tf,_loc3_,true);
      }
   }
}
