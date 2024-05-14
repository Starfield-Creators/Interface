package
{
   import Shared.AS3.BSScrollingTreeEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FilterListEntry extends BSScrollingTreeEntry
   {
      
      private static const FILTER_AMOUNT_TEXT_PADDING:int = 20;
      
      private static const SELECTED_ENABLED_LABEL:* = "highlightentry";
      
      private static const FILTER_ENABLED_LABEL:* = "enabled";
      
      private static const FILTER_DISABLED_LABEL:* = "disabled";
       
      
      public var FilterActiveAmount_mc:MovieClip;
      
      public var FilterBackground_mc:MovieClip;
      
      public var FilterEntry_tf:MovieClip;
      
      public var SelectedBackground_mc:MovieClip;
      
      public var FilterIndicator_mc:MovieClip;
      
      public var Sizer_mc:MovieClip;
      
      public function FilterListEntry()
      {
         super();
         this.FilterActiveAmount_mc.visible = false;
         gotoAndStop(unselectedFrameLabel);
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.FilterEntry_tf.textField;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         if(param1.filterEnabled != null)
         {
            this.SetFilterState(param1.filterEnabled);
         }
         super.SetEntryText(param1);
         this.FilterActiveAmount_mc.x = this.baseTextField.textWidth + FILTER_AMOUNT_TEXT_PADDING;
      }
      
      public function SetFilterState(param1:Boolean) : *
      {
         this.FilterIndicator_mc.gotoAndStop(param1 ? FILTER_ENABLED_LABEL : FILTER_DISABLED_LABEL);
      }
   }
}
