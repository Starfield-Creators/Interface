package
{
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   
   public class PowerPanelButton extends ButtonBase
   {
       
      
      public function PowerPanelButton()
      {
         super();
      }
      
      override protected function UpdateButtonText() : void
      {
         super.UpdateButtonText();
         ButtonBackground_mc.visible = !KeyHelper.usingController;
         ConsoleButton_mc.visible = KeyHelper.usingController;
      }
      
      override protected function SetBackgroundSize() : void
      {
      }
   }
}
