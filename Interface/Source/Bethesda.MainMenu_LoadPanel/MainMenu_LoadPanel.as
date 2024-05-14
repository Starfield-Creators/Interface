package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.SystemPanels.LoadPanel;
   
   public class MainMenu_LoadPanel extends LoadPanel
   {
       
      
      public var LargeButtonBar_mc:ButtonBar;
      
      protected var LargeConfirmButton:IButton = null;
      
      protected var LargeDeleteButton:IButton = null;
      
      protected var LargeCharacterButton:IButton = null;
      
      protected var LargeUploadSaveButton:IButton = null;
      
      private var _largeTextMode:Boolean = false;
      
      private var ConfirmPromptStartX:Number = 0;
      
      private var ButtonBarsStartX:Number = 0;
      
      private const LOAD_ENTRY_CLASS_STANDARD:String = "LoadPanelListEntryStandard";
      
      private const LOAD_ENTRY_CLASS_LARGE:String = "LoadPanelListEntryLarge";
      
      private const CHAR_ENTRY_CLASS_STANDARD:String = "CharacterListEntryStandard";
      
      private const CHAR_ENTRY_CLASS_LARGE:String = "CharacterListEntryLarge";
      
      public function MainMenu_LoadPanel()
      {
         super();
         this.LargeButtonBar_mc.visible = this._largeTextMode;
         this.ConfirmPromptStartX = ConfirmPrompt_mc.x;
         this.ButtonBarsStartX = ButtonBar_mc.x;
      }
      
      protected function get LargeCancelButton() : IButton
      {
         return this.LargeButtonBar_mc.CancelButton_mc;
      }
      
      override public function SetUpLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = this.LOAD_ENTRY_CLASS_STANDARD;
         LoadList_mc.Configure(_loc1_);
         var _loc2_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc2_.VerticalSpacing = 1.5;
         _loc2_.EntryClassName = this.CHAR_ENTRY_CLASS_STANDARD;
         CharacterList_mc.Configure(_loc2_);
      }
      
      override public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.LargeButtonBar_mc.Initialize(param1,param2);
         this.LargeConfirmButton = ButtonFactory.AddToButtonBar("LargeBasicButton",ConfirmButtonData,this.LargeButtonBar_mc);
         this.LargeDeleteButton = ButtonFactory.AddToButtonBar("LargeBasicButton",DeleteButtonData,this.LargeButtonBar_mc);
         this.LargeCharacterButton = ButtonFactory.AddToButtonBar("LargeBasicButton",CharacterButtonData,this.LargeButtonBar_mc);
         this.LargeUploadSaveButton = ButtonFactory.AddToButtonBar("LargeBasicButton",UploadSaveButtonData,this.LargeButtonBar_mc);
         this.LargeButtonBar_mc.AddButtonWithData(this.LargeCancelButton,CancelButtonData);
         super.PopulateButtonBar(param1,param2);
      }
      
      override protected function UpdateButtons() : void
      {
         super.UpdateButtons();
         this.LargeConfirmButton.Visible = ConfirmButton.Visible;
         this.LargeConfirmButton.Enabled = ConfirmButton.Enabled;
         this.LargeDeleteButton.Visible = DeleteButton.Visible;
         this.LargeDeleteButton.Enabled = DeleteButton.Enabled;
         this.LargeCharacterButton.Visible = CharacterButton.Visible;
         this.LargeCharacterButton.Enabled = CharacterButton.Enabled;
         this.LargeUploadSaveButton.Visible = UploadSaveButton.Visible;
         this.LargeUploadSaveButton.Enabled = UploadSaveButton.Enabled;
         this.LargeCancelButton.Visible = CancelButton.Visible;
         this.LargeCancelButton.Enabled = CancelButton.Enabled;
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
            if(this._largeTextMode)
            {
               LoadList_mc.ChangeEntryClass(this.LOAD_ENTRY_CLASS_LARGE);
               CharacterList_mc.ChangeEntryClass(this.CHAR_ENTRY_CLASS_LARGE);
               ContinueInfo_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
            }
            else
            {
               LoadList_mc.ChangeEntryClass(this.LOAD_ENTRY_CLASS_STANDARD);
               CharacterList_mc.ChangeEntryClass(this.CHAR_ENTRY_CLASS_STANDARD);
               ContinueInfo_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
            }
            ButtonBar_mc.x = this._largeTextMode ? this.ButtonBarsStartX - MainMenu.LOAD_PANEL_OFFSET : this.ButtonBarsStartX;
            this.LargeButtonBar_mc.x = this._largeTextMode ? this.ButtonBarsStartX - MainMenu.LOAD_PANEL_OFFSET : this.ButtonBarsStartX;
            ConfirmPrompt_mc.x = this._largeTextMode ? this.ConfirmPromptStartX - MainMenu.LOAD_PANEL_OFFSET : this.ConfirmPromptStartX;
            ButtonBar_mc.visible = !this._largeTextMode;
            this.LargeButtonBar_mc.visible = this._largeTextMode;
         }
      }
   }
}
