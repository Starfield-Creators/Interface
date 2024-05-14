package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class ModDescription extends AnimatedModClip
   {
       
      
      public var Description_mc:MovieClip;
      
      public function ModDescription()
      {
         super();
         TextFieldEx.setVerticalAlign(this.Description_mc.Text_tf,TextFieldEx.VALIGN_BOTTOM);
      }
      
      public function SetDescription(param1:String) : void
      {
         GlobalFunc.SetText(this.Description_mc.Text_tf,param1);
      }
   }
}
