package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DocumentBodyTextEntry extends MovieClip implements IDocumentEntry
   {
       
      
      public var Text_tf:TextField;
      
      public var HeightSpacer_mc:MovieClip;
      
      public function DocumentBodyTextEntry(param1:Object)
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setVerticalAutoSize(this.Text_tf,TextFieldEx.VAUTOSIZE_TOP);
         this.SetData(param1);
      }
      
      public function SetData(param1:Object) : void
      {
         GlobalFunc.SetText(this.Text_tf,param1.arg0);
         this.HeightSpacer_mc.y = this.Text_tf.y + this.Text_tf.height;
      }
   }
}
