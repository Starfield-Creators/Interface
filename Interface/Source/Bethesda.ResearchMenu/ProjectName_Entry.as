package
{
   import Components.DisplayList_Entry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ProjectName_Entry extends DisplayList_Entry
   {
       
      
      public var Name_mc:MovieClip;
      
      public function ProjectName_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         GlobalFunc.SetText(this.Name_mc.Text_tf,param1 as String);
      }
   }
}
