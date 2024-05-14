package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class MiscInfoEntry extends MovieClip
   {
       
      
      public var TitleText_tf:TextField;
      
      public var DescriptionText_tf:TextField;
      
      public function MiscInfoEntry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.TitleText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.DescriptionText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function SetEntry(param1:Object) : *
      {
         this.TitleText_tf.text = param1.sTitle;
         this.DescriptionText_tf.text = param1.sDescription;
      }
   }
}
