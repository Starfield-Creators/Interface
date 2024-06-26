package
{
   import Components.ComponentResourceIcon;
   import Components.DisplayList_Entry;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class CostCard_Entry extends DisplayList_Entry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var Count_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      private var _largeTextMode:Boolean = false;
      
      public function CostCard_Entry()
      {
         super();
         if(!this._largeTextMode)
         {
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Count_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
         WorkshopUtils.SetSingleLineText(this.Name_mc.Text_tf,param1.sName,this._largeTextMode);
         WorkshopUtils.SetSingleLineText(this.Count_mc.Text_tf,param1.sCounts,this._largeTextMode);
         this.Tagged_mc.visible = param1.bTracking;
         if(param1.bHasEnough)
         {
            gotoAndStop("valid");
            this.ComponentResourceIcon_mc.gotoAndStop("valid");
         }
         else if(param1.bRequirementPreview)
         {
            gotoAndStop("missingInputRequirement");
            this.ComponentResourceIcon_mc.gotoAndStop("missingInputRequirement");
         }
         else
         {
            gotoAndStop("invalid");
            this.ComponentResourceIcon_mc.gotoAndStop("invalid");
         }
      }
   }
}
