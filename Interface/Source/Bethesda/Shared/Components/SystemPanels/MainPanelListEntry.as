package Shared.Components.SystemPanels
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MainPanelListEntry extends BSContainerEntry
   {
       
      
      public var LoadingSpinner_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      public var Text_mc:MovieClip;
      
      private var Disabled:Boolean = false;
      
      private const LOADING_SPINNER_BUFFER_X:* = 20;
      
      public function MainPanelListEntry()
      {
         super();
      }
      
      public function get selectedDisabledFrameLabel() : String
      {
         return "selectedDisabled";
      }
      
      public function get unselectedDisabledFrameLabel() : String
      {
         return "unselectedDisabled";
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.textField;
      }
      
      override public function get selected() : Boolean
      {
         return animationClip.currentLabel == selectedFrameLabel || animationClip.currentLabel == this.selectedDisabledFrameLabel;
      }
      
      override public function onRollover() : void
      {
         if(this.Disabled)
         {
            this.disabledRollover();
         }
         else
         {
            super.onRollover();
         }
      }
      
      override public function onRollout() : void
      {
         if(this.Disabled)
         {
            this.disabledRollout();
         }
         else
         {
            super.onRollout();
         }
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         if(this.Disabled != param1.bDisabled)
         {
            if(param1.bDisabled)
            {
               if(this.selected)
               {
                  this.disabledRollover();
               }
               else
               {
                  this.disabledRollout();
               }
            }
            else if(this.selected)
            {
               super.onRollover();
            }
            else
            {
               super.onRollout();
            }
            this.Disabled = param1.bDisabled;
         }
         if(this.LoadingSpinner_mc)
         {
            this.LoadingSpinner_mc.x = this.baseTextField.x + this.baseTextField.textWidth + this.LOADING_SPINNER_BUFFER_X;
            this.LoadingSpinner_mc.alpha = !!param1.bShowSpinner ? 1 : 0;
         }
         GlobalFunc.SetText(this.baseTextField,param1.sActionText);
      }
      
      private function disabledRollover() : void
      {
         if(animationClip.currentFrameLabel != this.selectedDisabledFrameLabel)
         {
            animationClip.gotoAndPlay(this.selectedDisabledFrameLabel);
         }
      }
      
      private function disabledRollout() : void
      {
         if(animationClip.currentFrameLabel != this.unselectedDisabledFrameLabel)
         {
            animationClip.gotoAndPlay(this.unselectedDisabledFrameLabel);
         }
      }
   }
}
