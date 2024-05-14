package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ModSlotsList_Entry extends BSContainerEntry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var Component_mc:MovieClip;
      
      public var Locked_mc:MovieClip;
      
      public function ModSlotsList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Component_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.Name_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.Component_mc.Text_tf,param1.CurrentMod.sName);
         this.Locked_mc.visible = !param1.CurrentMod.bPlayerEditable;
      }
   }
}
