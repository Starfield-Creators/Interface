package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class KioskBodyTextEntry extends MovieClip implements IDocumentEntry
   {
       
      
      public var Text_tf:TextField;
      
      public function KioskBodyTextEntry(param1:Object, param2:Number)
      {
         super();
         this.Text_tf.selectable = false;
         this.Text_tf.mouseWheelEnabled = false;
         this.Text_tf.height = param2;
         this.SetData(param1);
      }
      
      public function SetData(param1:Object) : void
      {
         GlobalFunc.SetText(this.Text_tf,param1.arg0.replace(/$\s+/g,""));
      }
   }
}
