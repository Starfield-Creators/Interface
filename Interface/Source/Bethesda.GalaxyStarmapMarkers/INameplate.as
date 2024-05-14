package
{
   import Components.Icons.DynamicPoiIcon;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class INameplate extends MovieClip
   {
       
      
      public var Nameplate_mc:MovieClip;
      
      public function INameplate()
      {
         super();
         GlobalFunc.BSASSERT(this.Nameplate_mc != null,"Nameplate_mc is null. Every nameplate instance must have a child called Nameplate_mc");
         this.Reset();
      }
      
      public function QFullTextWidth() : Number
      {
         var _loc1_:Number = Number(this.Nameplate_mc.NameplateText_mc.text_tf.textWidth);
         if(_loc1_ > 0)
         {
            return _loc1_ + MarkerConsts.TEXT_PADDING;
         }
         return 0;
      }
      
      public function Reset() : void
      {
         this.Nameplate_mc.y = 0;
         this.TurnOffNameplates();
         GlobalFunc.SetText(this.Nameplate_mc.NameplateText_mc.text_tf,"");
      }
      
      final public function Update(param1:Object) : void
      {
         if(param1.bForceHideText)
         {
            this.Reset();
         }
         else
         {
            if(param1.sMarkerText != this.Nameplate_mc.NameplateText_mc.text_tf.text)
            {
               DynamicPoiIcon.GetSpacePOIName(param1.sMarkerText,param1.bMarkerDiscovered,param1.uPoiCategory);
               this.SetText(param1.sMarkerText);
            }
            this.UpdateImpl(param1);
         }
      }
      
      protected function UpdateImpl(param1:Object) : void
      {
      }
      
      protected function SetText(param1:String) : void
      {
         GlobalFunc.SetText(this.Nameplate_mc.NameplateText_mc.text_tf,param1);
      }
      
      protected function SetBackgroundWidth() : *
      {
         this.Nameplate_mc.selectedTextBackground_mc.width = this.QFullTextWidth() + MarkerConsts.BG_PADDING;
         this.Nameplate_mc.selectedTextBackground_mc.visible = true;
      }
      
      protected function TurnOffNameplates() : *
      {
         this.Nameplate_mc.gotoAndStop("off");
      }
      
      protected function HideBackgroundAssets() : *
      {
         this.Nameplate_mc.selectedTextBackground_mc.visible = false;
      }
   }
}
