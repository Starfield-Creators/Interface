package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.SystemPanels.SettingsControlConflictEntry;
   import Shared.Components.SystemPanels.SettingsPanel;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class MainMenu_SettingsPanel extends SettingsPanel
   {
       
      
      public var LargeButtonBar_mc:ButtonBar;
      
      protected var LargeConfirmButton:IButton = null;
      
      protected var LargeDeleteBindingButton:IButton = null;
      
      protected var LargeDefaultsButton:IButton = null;
      
      protected var LargeBackButton:IButton = null;
      
      private var _largeTextMode:Boolean = false;
      
      private const CATEGORY_ENTRY_CLASS_STANDARD:String = "SettingsCategoryListEntryStandard";
      
      private const CATEGORY_ENTRY_CLASS_LARGE:String = "SettingsCategoryListEntryLarge";
      
      private const CONTROL_ENTRY_CLASS_STANDARD:String = "SettingsControlListEntryStandard";
      
      private const CONTROL_ENTRY_CLASS_LARGE:String = "SettingsControlListEntryLarge";
      
      private const OPTION_ENTRY_CLASS_STANDARD:String = "SettingsOptionListEntryStandard";
      
      private const OPTION_ENTRY_CLASS_LARGE:String = "SettingsOptionListEntryLarge";
      
      private const CONFLICT_INFO_CLASS_STANDARD:String = "ConflictInfoStandard";
      
      private const CONFLICT_INFO_CLASS_LARGE:String = "ConflictInfoLarge";
      
      protected var ConflictEntryClassStandard:Class;
      
      protected var ConflictEntryClassLarge:Class;
      
      public function MainMenu_SettingsPanel()
      {
         this.ConflictEntryClassStandard = getDefinitionByName("ConflictEntryStandard") as Class;
         this.ConflictEntryClassLarge = getDefinitionByName("ConflictEntryLarge") as Class;
         super();
         this.LargeButtonBar_mc.visible = this._largeTextMode;
         OptionsPanel_mc.LargePreview_mc.visible = this._largeTextMode;
      }
      
      protected function get LargeCancelButton() : IButton
      {
         return this.LargeButtonBar_mc.CancelButton_mc;
      }
      
      override public function SetUpLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 2;
         _loc1_.EntryClassName = this.CATEGORY_ENTRY_CLASS_STANDARD;
         CategoryList_mc.Configure(_loc1_);
         _loc1_.EntryClassName = this.CONTROL_ENTRY_CLASS_STANDARD;
         ControlsList_mc.Configure(_loc1_);
         _loc1_.EntryClassName = this.OPTION_ENTRY_CLASS_STANDARD;
         OptionsList_mc.Configure(_loc1_);
         SettingsControlConflictEntry.ConflictInfoClassName = this.CONFLICT_INFO_CLASS_STANDARD;
         ControlsPanel_mc.ConflictsSection_mc.ConflictsList_mc.Configure(this.ConflictEntryClassStandard,CONFLICT_COLUMNS,CONFLICT_ROWS,CONFLICT_COLUMNS_SPACING,CONFLICT_ROWS_SPACING);
      }
      
      override public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.LargeButtonBar_mc.Initialize(param1,param2);
         this.LargeConfirmButton = ButtonFactory.AddToButtonBar("LargeBasicButton",ConfirmButtonData,this.LargeButtonBar_mc);
         this.LargeButtonBar_mc.AddButtonWithData(this.LargeCancelButton,CancelButtonData);
         this.LargeDeleteBindingButton = ButtonFactory.AddToButtonBar("LargeBasicButton",DeleteBindingButtonData,this.LargeButtonBar_mc);
         this.LargeDefaultsButton = ButtonFactory.AddToButtonBar("LargeBasicButton",DefaultsButtonData,this.LargeButtonBar_mc);
         this.LargeBackButton = ButtonFactory.AddToButtonBar("LargeBasicButton",BackButtonData,this.LargeButtonBar_mc);
         super.PopulateButtonBar(param1,param2);
      }
      
      override protected function UpdateButtons() : void
      {
         super.UpdateButtons();
         this.LargeConfirmButton.SetButtonData(ConfirmButtonData);
         this.LargeConfirmButton.Visible = ConfirmButton.Visible;
         this.LargeConfirmButton.Enabled = ConfirmButton.Enabled;
         this.LargeCancelButton.SetButtonData(CancelButtonData);
         this.LargeCancelButton.Visible = CancelButton.Visible;
         this.LargeCancelButton.Enabled = CancelButton.Enabled;
         this.LargeDefaultsButton.Visible = DefaultsButton.Visible;
         this.LargeDefaultsButton.Enabled = DefaultsButton.Enabled;
         this.UpdateDeleteBindingButton();
         this.LargeBackButton.Visible = BackButton.Visible;
         this.LargeBackButton.Enabled = BackButton.Enabled;
         this.LargeButtonBar_mc.RefreshButtons();
      }
      
      override protected function UpdateDeleteBindingButton() : void
      {
         super.UpdateDeleteBindingButton();
         this.LargeDeleteBindingButton.Visible = DeleteBindingButton.Visible;
         this.LargeDeleteBindingButton.Enabled = DeleteBindingButton.Enabled;
      }
      
      override protected function OnActiveBindingChanged(param1:Event) : void
      {
         super.OnActiveBindingChanged(param1);
         this.LargeButtonBar_mc.RefreshButtons();
      }
      
      override protected function ProcessEventForButtonBar(param1:String, param2:Boolean) : Boolean
      {
         return this._largeTextMode ? this.LargeButtonBar_mc.ProcessUserEvent(param1,param2) : ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      override protected function UpdatePreview(param1:String) : void
      {
         super.UpdatePreview(param1);
         OptionsPanel_mc.LargePreview_mc.UpdatePreview(param1);
         OptionsPanel_mc.LargePreview_mc.y = OptionsPanel_mc.Description_mc.y + OptionsPanel_mc.Description_mc.height + DESC_PADDING;
      }
      
      public function UpdateSize(param1:Boolean) : void
      {
         if(this._largeTextMode != param1)
         {
            this._largeTextMode = param1;
            if(this._largeTextMode)
            {
               CategoryList_mc.ChangeEntryClass(this.CATEGORY_ENTRY_CLASS_LARGE);
               ControlsList_mc.ChangeEntryClass(this.CONTROL_ENTRY_CLASS_LARGE);
               OptionsList_mc.ChangeEntryClass(this.OPTION_ENTRY_CLASS_LARGE);
               SettingsControlConflictEntry.ConflictInfoClassName = this.CONFLICT_INFO_CLASS_LARGE;
               ControlsPanel_mc.ConflictsSection_mc.ConflictsList_mc.ChangeEntryClass(this.ConflictEntryClassLarge);
               Version_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               Prompt_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               GlobalFunc.SetText(Prompt_mc.Text_mc.Text_tf,PromptText);
               OptionsPanel_mc.Header_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               OptionsPanel_mc.Description_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               OptionsPanel_mc.Description_mc.Header_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               OptionsPanel_mc.Description_mc.Details_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               ControlsPanel_mc.Header_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               ControlsPanel_mc.BindingHint_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               ControlsPanel_mc.ConfirmationPopup_mc.Warning_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               ControlsPanel_mc.ConfirmationPopup_mc.ControlInfo_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               ControlsPanel_mc.ConflictsSection_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
               ControlsPanel_mc.ActionsHeader_mc.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
            }
            else
            {
               CategoryList_mc.ChangeEntryClass(this.CATEGORY_ENTRY_CLASS_STANDARD);
               ControlsList_mc.ChangeEntryClass(this.CONTROL_ENTRY_CLASS_STANDARD);
               OptionsList_mc.ChangeEntryClass(this.OPTION_ENTRY_CLASS_STANDARD);
               SettingsControlConflictEntry.ConflictInfoClassName = this.CONFLICT_INFO_CLASS_STANDARD;
               ControlsPanel_mc.ConflictsSection_mc.ConflictsList_mc.ChangeEntryClass(this.ConflictEntryClassStandard);
               Version_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               Prompt_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               GlobalFunc.SetText(Prompt_mc.Text_mc.Text_tf,PromptText);
               OptionsPanel_mc.Header_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               OptionsPanel_mc.Description_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               OptionsPanel_mc.Description_mc.Header_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               OptionsPanel_mc.Description_mc.Details_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               ControlsPanel_mc.Header_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               ControlsPanel_mc.BindingHint_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               ControlsPanel_mc.ConfirmationPopup_mc.Warning_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               ControlsPanel_mc.ConfirmationPopup_mc.ControlInfo_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               ControlsPanel_mc.ConflictsSection_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
               ControlsPanel_mc.ActionsHeader_mc.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
            }
            ButtonBar_mc.visible = !this._largeTextMode;
            this.LargeButtonBar_mc.visible = this._largeTextMode;
            ControlsPanel_mc.ConfirmationPopup_mc.ButtonBar_mc.visible = !this._largeTextMode;
            ControlsPanel_mc.ConfirmationPopup_mc.LargeButtonBar_mc.visible = this._largeTextMode;
            OptionsPanel_mc.Preview_mc.visible = !this._largeTextMode;
            OptionsPanel_mc.LargePreview_mc.visible = this._largeTextMode;
         }
      }
   }
}
