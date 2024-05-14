package
{
   import flash.display.MovieClip;
   
   public class ShipTargetIcon extends MannedObjectIcon
   {
       
      
      public var HeadingIndicator_mc:MovieClip;
      
      private var HeadingRotation_mc:MovieClip;
      
      private var LastSelected:Boolean = true;
      
      public function ShipTargetIcon()
      {
         super();
         this.HeadingRotation_mc = this.HeadingIndicator_mc.Rotation_mc;
      }
      
      override public function SetTargetHighInfo(param1:Object) : *
      {
         super.SetTargetHighInfo(param1);
         this.HeadingRotation_mc.rotation = TargetHigh.rotationZ;
      }
      
      override protected function SetAsStaticIndicator(param1:Boolean) : *
      {
         super.SetAsStaticIndicator(param1);
         this.UpdateHeadingIndicatorVisibility();
      }
      
      override public function UpdateOnScreenStatus(param1:Boolean) : *
      {
         super.UpdateOnScreenStatus(param1);
         if(LastOnScreen != param1)
         {
            this.UpdateHeadingIndicatorVisibility();
         }
      }
      
      private function UpdateHeadingIndicatorVisibility() : *
      {
         this.HeadingIndicator_mc.visible = !IsStaticIcon && LastOnScreen;
      }
      
      override protected function SelectFrame() : *
      {
         super.SelectFrame();
         if(this.LastSelected != ShowAsSelected)
         {
            this.HeadingRotation_mc = this.HeadingIndicator_mc.Rotation_mc;
            this.LastSelected = ShowAsSelected;
         }
      }
   }
}
