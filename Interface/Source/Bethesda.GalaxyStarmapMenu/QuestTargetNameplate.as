package
{
   public class QuestTargetNameplate extends INameplate
   {
       
      
      private var bHighlight:Boolean = false;
      
      public function QuestTargetNameplate()
      {
         super();
      }
      
      override protected function UpdateImpl(param1:Object) : void
      {
         var _loc2_:Number = QFullTextWidth() + MarkerConsts.BG_PADDING;
         var _loc3_:Boolean = param1.bMarkerVisible != null ? Boolean(param1.bMarkerVisible) : Boolean(param1.bShowHighlight);
         if(this.bHighlight != _loc3_)
         {
            this.bHighlight = _loc3_;
            if(this.bHighlight)
            {
               Nameplate_mc.gotoAndPlay("system_selected");
               Nameplate_mc.Mask_mc.MaskBase_mc.width = _loc2_;
               Nameplate_mc.NameplateText_mc.text_tf.width = _loc2_;
               SetBackgroundWidth();
            }
            else
            {
               Nameplate_mc.gotoAndPlay("system_close");
               HideBackgroundAssets();
            }
         }
      }
   }
}
