package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.SystemPanels.MainPanel;
   
   public class MainMenu_MainPanel extends MainPanel
   {
       
      
      public var LargeButtonBar_mc:ButtonBar;
      
      protected var LargeConfirmButton:IButton = null;
      
      protected var LargeYButton:IButton = null;
      
      private var _largeTextMode:Boolean = false;
      
      private const ENTRY_CLASS_STANDARD:String = "MainPanelListEntryStandard";
      
      private const ENTRY_CLASS_LARGE:String = "MainPanelListEntryLarge";
      
      public function MainMenu_MainPanel()
      {
         super();
         this.LargeButtonBar_mc.visible = this._largeTextMode;
      }
      
      protected function get LargeCancelButton() : IButton
      {
         return this.LargeButtonBar_mc.CancelButton_mc;
      }
      
      override public function SetUpLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = this.ENTRY_CLASS_STANDARD;
         MainList_mc.Configure(_loc1_);
      }
      
      override public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         super.PopulateButtonBar(param1,param2);
         this.LargeButtonBar_mc.Initialize(param1,param2);
         this.LargeConfirmButton = ButtonFactory.AddToButtonBar("LargeBasicButton",ConfirmButtonData,this.LargeButtonBar_mc);
         this.LargeYButton = ButtonFactory.AddToButtonBar("LargeBasicButton",YButtonData,this.LargeButtonBar_mc);
         this.LargeButtonBar_mc.AddButtonWithData(this.LargeCancelButton,CancelButtonData);
         this.LargeConfirmButton.Visible = false;
         this.LargeConfirmButton.Enabled = false;
         this.LargeYButton.Visible = false;
         this.LargeYButton.Enabled = false;
         this.LargeCancelButton.Visible = false;
         this.LargeCancelButton.Enabled = false;
         this.LargeButtonBar_mc.RefreshButtons();
      }
      
      override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this._largeTextMode ? this.LargeButtonBar_mc.ProcessUserEvent(param1,param2) : ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      override public function SetYButtonLabel(param1:String) : void
      {
         super.SetYButtonLabel(param1);
         this.LargeYButton.SetButtonData(YButtonData);
         this.LargeButtonBar_mc.RefreshButtons();
      }
      
      override public function UpdateYButton(param1:Boolean) : void
      {
         super.UpdateYButton(param1);
         if(this.LargeYButton.Visible != param1)
         {
            this.LargeYButton.Visible = param1;
            this.LargeYButton.Enabled = param1;
            this.LargeButtonBar_mc.RefreshButtons();
         }
      }
      
      override protected function UpdateConfirmationButtons(param1:Boolean) : void
      {
         super.UpdateConfirmationButtons(param1);
         this.LargeConfirmButton.Visible = param1;
         this.LargeConfirmButton.Enabled = param1;
         this.LargeCancelButton.Visible = param1;
         this.LargeCancelButton.Enabled = param1;
         this.LargeButtonBar_mc.RefreshButtons();
      }
      
      public function UpdateSize(param1:Boolean) : void
      {
         if(this._largeTextMode != param1)
         {
            this._largeTextMode = param1;
            if(this._largeTextMode)
            {
               MainList_mc.ChangeEntryClass(this.ENTRY_CLASS_LARGE);
            }
            else
            {
               MainList_mc.ChangeEntryClass(this.ENTRY_CLASS_STANDARD);
            }
            ButtonBar_mc.visible = !this._largeTextMode;
            this.LargeButtonBar_mc.visible = this._largeTextMode;
         }
      }
   }
}
