package
{
   import Components.ComponentResourceIcon;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class MaterialRequirement extends MovieClip
   {
      
      private static const UNSELECTED_FRAME_LABEL:String = "Unselected";
      
      private static const EMPTY_FRAME_LABEL:String = "Empty";
       
      
      public var MaterialIcon_mc:ComponentResourceIcon;
      
      public var MaterialAmount_mc:MovieClip;
      
      public var MaterialName_mc:MovieClip;
      
      public var MaterialAvailable_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      public function MaterialRequirement()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.MaterialName_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.MaterialAmount_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function PopulateRequirement(param1:Object) : void
      {
         GlobalFunc.SetText(this.MaterialName_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.MaterialAmount_mc.Text_tf,param1.uInputAmount + "/" + param1.uTotalRequiredAmount);
         this.MaterialIcon_mc.UpdateData(param1.resourceInfo);
         this.MaterialAvailable_mc.visible = param1.uInventoryAmount > 0 && param1.uInputAmount < param1.uTotalRequiredAmount;
         this.Tagged_mc.visible = param1.bTracking;
         if(currentFrameLabel != UNSELECTED_FRAME_LABEL)
         {
            gotoAndStop(UNSELECTED_FRAME_LABEL);
         }
      }
      
      public function ShowAsEmpty() : void
      {
         this.MaterialAvailable_mc.visible = false;
         this.Tagged_mc.visible = false;
         if(currentFrameLabel != EMPTY_FRAME_LABEL)
         {
            gotoAndStop(EMPTY_FRAME_LABEL);
         }
      }
   }
}
