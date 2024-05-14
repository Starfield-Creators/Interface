package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.TextFieldEx;
   
   public class TutorialTip extends MovieClip
   {
       
      
      public var TipIconBox_mc:MovieClip;
      
      public var TipTextBox_mc:MovieClip;
      
      public var TipText_mc:MovieClip;
      
      public var TipIcon_mc:MovieClip;
      
      public function TutorialTip()
      {
         super();
         TextFieldEx.setTextAutoSize(this.TipText_mc.TipText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         BSUIDataManager.Subscribe("TutorialTips",this.OnDataChange);
      }
      
      public function OnDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:Number = NaN;
         if(param1.data.sText != null)
         {
            if(param1.data.sText.length > 0)
            {
               GlobalFunc.SetText(this.TipText_mc.TipText_tf,param1.data.sText,true);
               _loc2_ = 30;
               this.TipTextBox_mc.TipBoxSizer_mc.height = this.TipText_mc.TipText_tf.textHeight + _loc2_;
               this.TipIconBox_mc.TipIconBoxSizer_mc.height = this.TipTextBox_mc.TipBoxSizer_mc.height;
               this.TipIcon_mc.TipIconPositioner_mc.y = this.TipIconBox_mc.TipIconBoxSizer_mc.height / 2;
               gotoAndPlay("OpenTip");
               GlobalFunc.PlayMenuSound("UIToolTipPopUpStart");
            }
            else
            {
               gotoAndPlay("DismissTip");
               GlobalFunc.PlayMenuSound("UIToolTipPopUpStop");
            }
         }
      }
   }
}
