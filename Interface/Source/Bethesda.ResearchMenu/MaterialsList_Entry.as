package
{
   import Components.ComponentResourceIcon;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class MaterialsList_Entry extends BSContainerEntry
   {
       
      
      public var InProgressMarker_mc:MovieClip;
      
      public var ProgressIndicator_mc:MovieClip;
      
      public var EntryAmount_mc:MovieClip;
      
      public var MaterialName_mc:MovieClip;
      
      public var ComponentResourceIcon_mc:ComponentResourceIcon;
      
      public var Tagged_mc:MovieClip;
      
      public function MaterialsList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.MaterialName_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.EntryAmount_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.MaterialName_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.EntryAmount_mc.Text_tf,param1.uInputAmount + "/" + param1.uTotalRequiredAmount);
         this.ComponentResourceIcon_mc.UpdateData(param1.resourceInfo);
         this.Tagged_mc.visible = param1.bTracking;
         var _loc2_:* = param1.uInputAmount >= param1.uTotalRequiredAmount;
         var _loc3_:* = param1.uInputAmount != 0;
         var _loc4_:Boolean = !_loc2_ && param1.uInventoryAmount > 0;
         var _loc5_:String = ResearchUtils.NOT_STARTED_FRAME_LABEL;
         if(_loc2_)
         {
            _loc5_ = ResearchUtils.COMPLETED_FRAME_LABEL;
         }
         else if(_loc4_)
         {
            _loc5_ = ResearchUtils.MATERIAL_AVAILABLE_FRAME_LABEL;
         }
         else if(_loc3_)
         {
            _loc5_ = ResearchUtils.IN_PROGRESS_FRAME_LABEL;
         }
         if(this.InProgressMarker_mc.currentFrameLabel != _loc5_)
         {
            this.InProgressMarker_mc.gotoAndStop(_loc5_);
         }
         var _loc6_:String = _loc2_ ? ResearchUtils.COMPLETED_FRAME_LABEL : ResearchUtils.NONE_FRAME_LABEL;
         if(this.ProgressIndicator_mc.currentFrameLabel != _loc6_)
         {
            this.ProgressIndicator_mc.gotoAndStop(_loc6_);
         }
      }
      
      override public function onRollover() : void
      {
         if(this.ComponentResourceIcon_mc.currentFrameLabel != selectedFrameLabel)
         {
            this.ComponentResourceIcon_mc.gotoAndStop(selectedFrameLabel);
         }
         super.onRollover();
      }
      
      override public function onRollout() : void
      {
         if(this.ComponentResourceIcon_mc.currentFrameLabel != unselectedFrameLabel)
         {
            this.ComponentResourceIcon_mc.gotoAndStop(unselectedFrameLabel);
         }
         super.onRollout();
      }
   }
}
