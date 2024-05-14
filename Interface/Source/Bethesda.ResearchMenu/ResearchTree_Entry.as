package
{
   import Components.DisplayList_Entry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ResearchTree_Entry extends DisplayList_Entry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var Progress_mc:MovieClip;
      
      private var progressPercent:Number = 0;
      
      public function ResearchTree_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         var _loc2_:String = String(param1.sName);
         if(param1.uTotalProjects > 1)
         {
            _loc2_ += " (" + param1.uCompletedProjects + "/" + param1.uTotalProjects + ")";
         }
         GlobalFunc.SetText(this.Name_mc.Text_tf,_loc2_);
         this.progressPercent = GlobalFunc.RoundDecimal(param1.fProgressPercentage * 100,0);
         GlobalFunc.SetText(this.Progress_mc.Percent_mc.Text_tf,this.progressPercent + "%");
      }
      
      public function ShowProgressInfo(param1:Boolean) : void
      {
         var _loc2_:* = this.progressPercent >= 100;
         var _loc3_:String = param1 ? (_loc2_ ? ResearchUtils.COMPLETED_FRAME_LABEL : ResearchUtils.REQUIRED_FRAME_LABEL) : ResearchUtils.NONE_FRAME_LABEL;
         if(this.Progress_mc.currentFrameLabel != _loc3_)
         {
            this.Progress_mc.gotoAndStop(_loc3_);
         }
      }
   }
}
