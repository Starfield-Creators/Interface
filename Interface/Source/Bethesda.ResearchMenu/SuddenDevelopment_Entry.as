package
{
   import Components.ComponentResourceIcon;
   import Components.DisplayList_Entry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class SuddenDevelopment_Entry extends DisplayList_Entry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var Amount_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      public function SuddenDevelopment_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Amount_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         var _loc2_:String = "";
         if(param1.uTotalRequired > 0)
         {
            _loc2_ = param1.uCountAdded + "/" + param1.uTotalRequired;
         }
         else
         {
            _loc2_ = "+" + param1.uCountAdded;
         }
         GlobalFunc.SetText(this.Name_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.Amount_mc.Text_tf,_loc2_);
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
         this.Tagged_mc.visible = param1.bTracking;
      }
   }
}
