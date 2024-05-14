package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DrugsList_Entry extends DirectoryList_Entry
   {
       
      
      public var Type_mc:MovieClip;
      
      public function DrugsList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Type_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         GlobalFunc.SetText(this.Type_mc.Text_tf,param1.sType);
      }
   }
}
