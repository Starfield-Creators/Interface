package Shared.Components.SystemPanels
{
   import Components.DisplayList_Entry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class SettingsControlConflictInfo extends DisplayList_Entry
   {
       
      
      public var ContextName_mc:MovieClip;
      
      public var ControlName_mc:MovieClip;
      
      public function SettingsControlConflictInfo()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.ContextName_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.ControlName_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         GlobalFunc.SetText(this.ContextName_mc.Text_tf,"$" + param1.sContextUserFacingName);
         GlobalFunc.SetText(this.ControlName_mc.Text_tf,"$" + param1.sContextName + "_" + param1.sUserEvent);
      }
   }
}
