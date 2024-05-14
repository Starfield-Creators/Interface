package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.SystemPanels.ControlRemapConfirmationPopup;
   
   public class MainMenu_ControlRemapConfirmationPopup extends ControlRemapConfirmationPopup
   {
       
      
      public var LargeButtonBar_mc:ButtonBar;
      
      private var _largeTextMode:Boolean = false;
      
      public function MainMenu_ControlRemapConfirmationPopup()
      {
         super();
         this.LargeButtonBar_mc.visible = this._largeTextMode;
      }
      
      private function get LargeCancelButton() : IButton
      {
         return this.LargeButtonBar_mc.CancelButton_mc;
      }
      
      override public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         super.PopulateButtonBar(param1,param2);
         this.LargeButtonBar_mc.Initialize(param1,param2);
         ButtonFactory.AddToButtonBar("LargeBasicButton",ConfirmButtonData,this.LargeButtonBar_mc);
         this.LargeButtonBar_mc.AddButtonWithData(this.LargeCancelButton,CancelButtonData);
         this.LargeButtonBar_mc.RefreshButtons();
      }
      
      override protected function ProcessEventForButtonBar(param1:String, param2:Boolean) : Boolean
      {
         return this._largeTextMode ? this.LargeButtonBar_mc.ProcessUserEvent(param1,param2) : ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function UpdateSize(param1:Boolean) : void
      {
         if(this._largeTextMode != param1)
         {
            this._largeTextMode = param1;
            ButtonBar_mc.visible = !this._largeTextMode;
            this.LargeButtonBar_mc.visible = this._largeTextMode;
         }
      }
   }
}
