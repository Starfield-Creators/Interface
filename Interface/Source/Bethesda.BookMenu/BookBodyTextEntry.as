package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BookBodyTextEntry extends MovieClip
   {
       
      
      public var Text_tf:TextField;
      
      private var sCurrentText:String = "";
      
      public function BookBodyTextEntry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setVerticalAutoSize(this.Text_tf,TextFieldEx.VAUTOSIZE_TOP);
      }
      
      public function get CurrentText() : String
      {
         return this.sCurrentText;
      }
      
      public function GetLineOffset(param1:int) : int
      {
         return this.Text_tf.getLineOffset(param1);
      }
      
      public function GetCharBoundaries(param1:int) : Rectangle
      {
         return this.Text_tf.getCharBoundaries(param1);
      }
      
      public function get NumLines() : int
      {
         return this.Text_tf.numLines;
      }
      
      public function SetData(param1:String) : void
      {
         this.sCurrentText = param1;
         GlobalFunc.SetText(this.Text_tf,param1,true);
      }
   }
}
