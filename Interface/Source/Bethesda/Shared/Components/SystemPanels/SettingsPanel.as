package Shared.Components.SystemPanels
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import scaleform.gfx.TextFieldEx;
   
   public class SettingsPanel extends MovieClip implements IPanel
   {
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CategoryPanel_mc:MovieClip;
      
      public var ControlsPanel_mc:MovieClip;
      
      public var OptionsPanel_mc:MovieClip;
      
      public var Prompt_mc:MovieClip;
      
      public var Version_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      protected var ConfirmButton:IButton = null;
      
      protected var DeleteBindingButton:IButton = null;
      
      protected var DefaultsButton:IButton = null;
      
      protected var BackButton:IButton = null;
      
      protected var ConfirmButtonData:ButtonBaseData;
      
      protected var CancelButtonData:ButtonBaseData;
      
      private var CategoryRequested:Array;
      
      private var CurrentState:uint;
      
      private var CurrentCategory:uint;
      
      private var RemappingControl:Boolean;
      
      private var WaitingOnControlsValidation:Boolean;
      
      private var HasControlConflicts:Boolean;
      
      private var ActiveList:BSScrollingContainer;
      
      private var HidePromptTimer:Timer;
      
      protected var PromptText:String = "";
      
      private const SPS_NONE:int = EnumHelper.GetEnum(0);
      
      private const SPS_CATEGORY:int = EnumHelper.GetEnum();
      
      private const SPS_CONTROLS:int = EnumHelper.GetEnum();
      
      private const SPS_OPTIONS:int = EnumHelper.GetEnum();
      
      private const SPS_CONFIRMING_DEFAULTS:int = EnumHelper.GetEnum();
      
      private const SPS_CONFIRMING_CONFLICTS:int = EnumHelper.GetEnum();
      
      protected const CONFLICT_COLUMNS:Number = 1;
      
      protected const CONFLICT_ROWS:Number = 11;
      
      protected const CONFLICT_COLUMNS_SPACING:Number = 0;
      
      protected const CONFLICT_ROWS_SPACING:Number = 2;
      
      protected const DESC_PADDING:Number = 30;
      
      private const FFE_CONTROLS_SAVED_EVENT:String = "SettingsDataModel_ControlsSaved";
      
      private const FFE_SETTINGS_SAVED_EVENT:String = "SettingsDataModel_SettingsSaved";
      
      private const FFE_RESET_TO_DEFAULTS:String = "SettingsDataModel_ResetDefaults";
      
      private const FFE_MISSING_BINDINGS_ERROR:String = "SettingsDataModel_MissingRequiredBindingError";
      
      private const FFE_CONTROLS_VALIDATED_EVENT:String = "SettingsDataModel_ControlsValidatedEvent";
      
      private const GAMEPLAY_CATEGORY:int = EnumHelper.GetEnum(0);
      
      private const DISPLAY_CATEGORY:int = EnumHelper.GetEnum();
      
      private const INTERFACE_CATEGORY:int = EnumHelper.GetEnum();
      
      private const CONTROLS_CATEGORY:int = EnumHelper.GetEnum();
      
      private const CONTROL_MAPPINGS_CATEGORY:int = EnumHelper.GetEnum();
      
      private const AUDIO_CATEGORY:int = EnumHelper.GetEnum();
      
      private const ACCESSIBILITY_CATEGORY:int = EnumHelper.GetEnum();
      
      private const TOTAL_CATEGORIES:int = EnumHelper.GetEnum();
      
      protected var DeleteBindingButtonData:ButtonBaseData;
      
      protected var DefaultsButtonData:ButtonBaseData;
      
      protected var BackButtonData:ButtonBaseData;
      
      public function SettingsPanel()
      {
         this.ConfirmButtonData = new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept));
         this.CancelButtonData = new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel));
         this.HidePromptTimer = new Timer(750,1);
         this.DeleteBindingButtonData = new ButtonBaseData("$DELETE_BINDING",new UserEventData("XButton",this.onDeleteBinding));
         this.DefaultsButtonData = new ButtonBaseData("$DEFAULTS",new UserEventData("YButton",this.onResetToDefaults));
         this.BackButtonData = new ButtonBaseData("$BACK",new UserEventData("Cancel",this.onCancel));
         super();
         this.ActiveList = null;
         this.CurrentState = this.SPS_NONE;
         this.CurrentCategory = this.GAMEPLAY_CATEGORY;
         this.RemappingControl = false;
         this.WaitingOnControlsValidation = false;
         this.HasControlConflicts = false;
         this.CategoryRequested = new Array();
         var _loc1_:uint = uint(this.GAMEPLAY_CATEGORY);
         while(_loc1_ < this.TOTAL_CATEGORIES)
         {
            this.CategoryRequested.push(false);
            _loc1_++;
         }
         this.SetUpLists();
         this.OptionsPanel_mc.Description_mc.Details_mc.Text_mc.Text_tf.autoSize = TextFieldAutoSize.LEFT;
         this.OptionsPanel_mc.Description_mc.Details_mc.Text_mc.Text_tf.multiline = true;
         BSUIDataManager.Subscribe("SettingsCategoriesData",this.OnSettingsCategoriesDataUpdate);
         BSUIDataManager.Subscribe("SettingsData",this.OnSettingsDataUpdate);
         BSUIDataManager.Subscribe("ControlBindingsData",this.OnControlBindingsDataUpdate);
         BSUIDataManager.Subscribe("FireForgetEventData",this.OnFireForgetEvent);
         BSUIDataManager.Subscribe("ControlConflictsData",this.OnControlConflictsUpdate);
         BSUIDataManager.Subscribe("RemapErrorData",this.OnRemapErrorEvent);
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnEntryHover);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnEntryPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         addEventListener(SettingsControlListEntry.ACTIVE_BINDING_CHANGED,this.OnActiveBindingChanged);
         this.HidePromptTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideErrorTimerComplete);
      }
      
      protected function get CategoryList_mc() : BSScrollingContainer
      {
         return this.CategoryPanel_mc.CategoryList_mc;
      }
      
      protected function get ControlsList_mc() : SettingsControlList
      {
         return this.ControlsPanel_mc.ControlsList_mc;
      }
      
      protected function get OptionsList_mc() : SettingsOptionList
      {
         return this.OptionsPanel_mc.OptionsList_mc;
      }
      
      protected function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function get activeList() : BSScrollingContainer
      {
         return this.ActiveList;
      }
      
      public function get remappingControl() : Boolean
      {
         return this.RemappingControl;
      }
      
      public function set remappingControl(param1:Boolean) : *
      {
         var _loc2_:String = null;
         if(this.RemappingControl != param1)
         {
            this.RemappingControl = param1;
            _loc2_ = this.RemappingControl ? "$Remap_Prompt" : "";
            this.SetPromptText(_loc2_);
            this.UpdateButtons();
            this.SetListInteractivity();
            if(!this.RemappingControl)
            {
               this.ControlsList_mc.ClearEntryListenState();
               this.ShowRemapConfirmationPopup(false);
               GlobalFunc.PlayMenuSound("UIMenuGeneralTriggerFire");
            }
            else
            {
               GlobalFunc.PlayMenuSound("UIMenuGeneralTriggerDown");
            }
         }
      }
      
      private function set currentState(param1:uint) : *
      {
         if(this.CurrentState != param1)
         {
            this.ActiveList = null;
            this.CurrentState = param1;
            switch(this.CurrentState)
            {
               case this.SPS_CATEGORY:
                  this.ActiveList = this.CategoryList_mc;
                  if(this.CategoryList_mc.entryCount == 0)
                  {
                     BSUIDataManager.dispatchEvent(new Event("SettingsPanel_OpenSettings",true));
                  }
                  break;
               case this.SPS_CONTROLS:
                  this.ActiveList = this.ControlsList_mc;
                  break;
               case this.SPS_OPTIONS:
                  this.ActiveList = this.OptionsList_mc;
            }
            dispatchEvent(new Event(PanelUtils.ACTIVE_LIST_CHANGED,true,true));
            this.UpdateButtons();
            this.UpdateComponentVisibility();
            this.SetListInteractivity();
         }
      }
      
      public function SetUpLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 2;
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.SettingsCategoryListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.CategoryList_mc.Configure(_loc1_);
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.SettingsControlListEntry";
         this.ControlsList_mc.Configure(_loc1_);
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.SettingsOptionListEntry";
         this.OptionsList_mc.Configure(_loc1_);
         this.ControlsPanel_mc.ConflictsSection_mc.ConflictsList_mc.Configure(SettingsControlConflictEntry,this.CONFLICT_COLUMNS,this.CONFLICT_ROWS,this.CONFLICT_COLUMNS_SPACING,this.CONFLICT_ROWS_SPACING);
      }
      
      public function Open() : void
      {
         this.visible = true;
         this.SetPromptText("");
         if(this.CurrentState == this.SPS_NONE)
         {
            this.currentState = this.SPS_CATEGORY;
         }
      }
      
      public function Close() : void
      {
         this.visible = false;
         this.SetPromptText("");
         this.currentState = this.SPS_NONE;
         this.CategoryList_mc.selectedIndex = 0;
         this.ControlsList_mc.ResetSelection();
         this.OptionsList_mc.selectedIndex = 0;
         this.ShowRemapConfirmationPopup(false);
      }
      
      public function SetBackground(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.Background_mc.x = param1;
         this.Background_mc.y = param2;
         this.Background_mc.width = param3;
         this.Background_mc.height = param4;
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         this.ControlsPanel_mc.ConfirmationPopup_mc.PopulateButtonBar(param1,param2);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,this.CancelButtonData);
         this.DeleteBindingButton = ButtonFactory.AddToButtonBar("BasicButton",this.DeleteBindingButtonData,this.ButtonBar_mc);
         this.DefaultsButton = ButtonFactory.AddToButtonBar("BasicButton",this.DefaultsButtonData,this.ButtonBar_mc);
         this.BackButton = ButtonFactory.AddToButtonBar("BasicButton",this.BackButtonData,this.ButtonBar_mc);
         this.UpdateButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.ControlsPanel_mc.ConfirmationPopup_mc.active)
         {
            _loc3_ = Boolean(this.ControlsPanel_mc.ConfirmationPopup_mc.ProcessUserEvent(param1,param2));
         }
         if(!_loc3_)
         {
            _loc3_ = this.ProcessEventForButtonBar(param1,param2);
         }
         return _loc3_;
      }
      
      protected function ProcessEventForButtonBar(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function OnConfirmDataUpdate(param1:Boolean) : void
      {
      }
      
      public function SetVersion(param1:String) : void
      {
         GlobalFunc.SetText(this.Version_mc.Text_mc.Text_tf,param1);
      }
      
      protected function UpdateButtons() : void
      {
         var _loc1_:* = this.CurrentState == this.SPS_CATEGORY;
         var _loc2_:* = this.CurrentState == this.SPS_CONTROLS;
         var _loc3_:* = this.CurrentState == this.SPS_OPTIONS;
         var _loc4_:* = this.CurrentState == this.SPS_CONFIRMING_DEFAULTS;
         var _loc5_:* = this.CurrentState == this.SPS_CONFIRMING_CONFLICTS;
         this.ConfirmButtonData.sButtonText = _loc5_ ? "$EXIT ANYWAY" : "$CONFIRM";
         this.ConfirmButton.SetButtonData(this.ConfirmButtonData);
         this.ConfirmButton.Visible = !this.RemappingControl && (_loc4_ || _loc5_);
         this.ConfirmButton.Enabled = this.ConfirmButton.Visible;
         this.CancelButtonData.sButtonText = _loc5_ ? "$RETURN TO CONTROLS" : "$CANCEL";
         this.CancelButton.SetButtonData(this.CancelButtonData);
         this.CancelButton.Visible = !this.RemappingControl && (_loc4_ || _loc5_);
         this.CancelButton.Enabled = this.CancelButton.Visible;
         this.DefaultsButton.Visible = !this.RemappingControl && (_loc2_ || _loc3_);
         this.DefaultsButton.Enabled = this.DefaultsButton.Visible;
         this.UpdateDeleteBindingButton();
         this.BackButton.Visible = !this.RemappingControl && (_loc1_ || _loc2_ || _loc3_);
         this.BackButton.Enabled = this.BackButton.Visible;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateComponentVisibility() : void
      {
         var _loc1_:* = this.CurrentState == this.SPS_CATEGORY;
         var _loc2_:* = this.CurrentState == this.SPS_CONTROLS;
         var _loc3_:* = this.CurrentState == this.SPS_OPTIONS;
         var _loc4_:Boolean = this.CurrentState == this.SPS_CONFIRMING_DEFAULTS || this.CurrentState == this.SPS_CONFIRMING_CONFLICTS;
         var _loc5_:uint = this.GetStateGivenCategory();
         this.CategoryPanel_mc.visible = _loc1_;
         this.ControlsPanel_mc.visible = _loc2_ || _loc4_ && _loc5_ == this.SPS_CONTROLS;
         this.OptionsPanel_mc.visible = _loc3_ || _loc4_ && _loc5_ == this.SPS_OPTIONS;
      }
      
      private function SetListInteractivity() : *
      {
         var _loc1_:Boolean = this.RemappingControl || this.CurrentState == this.SPS_CONFIRMING_DEFAULTS || this.CurrentState == this.SPS_CONFIRMING_CONFLICTS;
         this.CategoryList_mc.disableSelection = _loc1_;
         this.CategoryList_mc.disableInput = _loc1_;
         this.ControlsList_mc.disableSelection = _loc1_;
         this.ControlsList_mc.disableInput = _loc1_;
         this.OptionsList_mc.disableSelection = _loc1_;
         this.OptionsList_mc.disableInput = _loc1_;
      }
      
      private function OpenCategorySubPanel() : void
      {
         this.currentState = this.GetStateGivenCategory();
         if(this.CurrentState == this.SPS_OPTIONS)
         {
            GlobalFunc.SetText(this.OptionsPanel_mc.Header_mc.Text_mc.Text_tf,this.CategoryList_mc.selectedEntry.sText);
            this.OptionsList_mc.SetFilterComparitor(function(param1:Object):Boolean
            {
               return param1.uCategory != undefined && param1.uCategory == CurrentCategory;
            });
         }
         else if(this.CurrentState == this.SPS_CONTROLS)
         {
            GlobalFunc.SetText(this.ControlsPanel_mc.Header_mc.Text_mc.Text_tf,this.CategoryList_mc.selectedEntry.sText);
         }
         if(!this.CategoryRequested[this.CurrentCategory])
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_OpenCategory",{"categoryID":this.CurrentCategory}));
            this.CategoryRequested[this.CurrentCategory] = true;
         }
         else if(this.CurrentCategory == this.DISPLAY_CATEGORY)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_OpenCategory",{"categoryID":this.CurrentCategory}));
            if(this.ActiveList != null)
            {
               this.ActiveList.selectedIndex = 0;
            }
         }
         else if(this.ActiveList != null)
         {
            if(this.ActiveList == this.ControlsList_mc)
            {
               this.ControlsList_mc.ResetSelection();
            }
            else
            {
               this.ActiveList.selectedIndex = 0;
            }
         }
      }
      
      private function GetStateGivenCategory() : uint
      {
         var _loc1_:uint = uint(this.SPS_CATEGORY);
         switch(this.CurrentCategory)
         {
            case this.CONTROL_MAPPINGS_CATEGORY:
               _loc1_ = uint(this.SPS_CONTROLS);
               break;
            default:
               _loc1_ = uint(this.SPS_OPTIONS);
         }
         return _loc1_;
      }
      
      protected function UpdateDeleteBindingButton() : void
      {
         var _loc1_:Boolean = !this.RemappingControl && this.CurrentState == this.SPS_CONTROLS && this.ControlsList_mc.activePriority == ControlBinding.ALT_KEY;
         this.DeleteBindingButton.Visible = _loc1_;
         this.DeleteBindingButton.Enabled = _loc1_;
      }
      
      private function ShowRemapConfirmationPopup(param1:Boolean) : void
      {
         this.ControlsPanel_mc.ConfirmationPopup_mc.active = param1;
      }
      
      private function OnSettingsCategoriesDataUpdate(param1:FromClientDataEvent) : void
      {
         this.CategoryList_mc.InitializeEntries(param1.data.aCategoryHeaders);
         if(this.CategoryList_mc.selectedIndex < 0)
         {
            this.CategoryList_mc.selectedIndex = 0;
         }
      }
      
      private function OnSettingsDataUpdate(param1:FromClientDataEvent) : void
      {
         removeEventListener(SettingsOptionListEntry.VALUE_CHANGE,this.OnSettingValueChange);
         this.OptionsList_mc.InitializeEntries(param1.data.aGeneralSettingsList);
         if(this.OptionsList_mc.selectedIndex < 0)
         {
            this.OptionsList_mc.selectedIndex = 0;
         }
         addEventListener(SettingsOptionListEntry.VALUE_CHANGE,this.OnSettingValueChange);
      }
      
      private function OnControlBindingsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.ControlsList_mc.InitializeEntries(param1.data.aInputSettingsList);
         if(this.ControlsList_mc.selectedIndex < 0)
         {
            this.ControlsList_mc.ResetSelection();
         }
         this.remappingControl = param1.data.bRemappingControl;
         var _loc2_:Boolean = Boolean(param1.data.bShowSecondaryBindings);
         var _loc3_:* = this.ControlsPanel_mc.currentFrameLabel == "showSecondary";
         if(_loc2_ != _loc3_)
         {
            if(_loc2_)
            {
               this.ControlsPanel_mc.gotoAndStop("showSecondary");
            }
            else
            {
               this.ControlsPanel_mc.gotoAndStop("hideSecondary");
            }
         }
         this.ControlsList_mc.EnableAltBindings(_loc2_);
      }
      
      private function OnFireForgetEvent(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         if(GlobalFunc.HasFireForgetEvent(_loc2_,this.FFE_RESET_TO_DEFAULTS))
         {
            this.currentState = this.GetStateGivenCategory();
            this.SetPromptText("");
         }
         else if(GlobalFunc.HasFireForgetEvent(_loc2_,this.FFE_CONTROLS_VALIDATED_EVENT))
         {
            this.ControlsValidated(true);
         }
         else if(GlobalFunc.HasFireForgetEvent(_loc2_,this.FFE_MISSING_BINDINGS_ERROR))
         {
            this.ControlsValidated(false);
         }
      }
      
      private function OnControlConflictsUpdate(param1:FromClientDataEvent) : void
      {
         this.ControlsPanel_mc.ConflictsSection_mc.ConflictsList_mc.entryData = param1.data.aAllConflicts;
         this.HasControlConflicts = param1.data.aAllConflicts.length > 0;
      }
      
      private function OnRemapErrorEvent(param1:FromClientDataEvent) : void
      {
         if(param1.data.sErrorText != "")
         {
            this.ShowRemapConfirmationPopup(false);
            this.SetPromptText(param1.data.sErrorText);
            GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
            this.HidePromptTimer.start();
         }
      }
      
      private function ControlsValidated(param1:Boolean) : void
      {
         if(this.WaitingOnControlsValidation)
         {
            this.WaitingOnControlsValidation = false;
            if(param1)
            {
               if(this.HasControlConflicts)
               {
                  this.currentState = this.SPS_CONFIRMING_CONFLICTS;
                  this.SetPromptText("$Remap_BindingConflictsWarning");
               }
               else
               {
                  this.SaveAndCloseControls();
               }
            }
            else
            {
               this.SetPromptText("$Remap_MissingBindingsError");
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.HidePromptTimer.start();
            }
         }
      }
      
      private function SaveAndCloseControls() : void
      {
         this.SetPromptText("");
         BSUIDataManager.dispatchEvent(new Event("SettingsPanel_SaveControls",true));
         this.currentState = this.SPS_CATEGORY;
      }
      
      private function SetPromptText(param1:String) : void
      {
         this.Version_mc.visible = param1 == "";
         this.PromptText = param1;
         this.HidePromptTimer.reset();
         GlobalFunc.SetText(this.Prompt_mc.Text_mc.Text_tf,this.PromptText);
      }
      
      private function onHideErrorTimerComplete() : *
      {
         this.SetPromptText("");
      }
      
      private function OnEntryHover(param1:Event) : void
      {
         if(param1.target == this.CategoryList_mc && this.CategoryList_mc.selectedEntry != null)
         {
            this.CurrentCategory = this.CategoryList_mc.selectedEntry.uID;
         }
         else if(param1.target == this.OptionsList_mc && this.OptionsList_mc.selectedEntry != null)
         {
            this.OptionsPanel_mc.Description_mc.Details_mc.Text_mc.Text_tf.autoSize = TextFieldAutoSize.LEFT;
            this.OptionsPanel_mc.Description_mc.Details_mc.Text_mc.Text_tf.multiline = true;
            GlobalFunc.SetText(this.OptionsPanel_mc.Description_mc.Header_mc.Text_mc.Text_tf,this.OptionsList_mc.selectedEntry.sText);
            GlobalFunc.SetText(this.OptionsPanel_mc.Description_mc.Details_mc.Text_mc.Text_tf,this.OptionsList_mc.selectedEntry.sDescription);
            this.UpdatePreview(this.OptionsList_mc.selectedEntry.sPreview);
         }
      }
      
      protected function UpdatePreview(param1:String) : void
      {
         this.OptionsPanel_mc.Preview_mc.UpdatePreview(param1);
         this.OptionsPanel_mc.Preview_mc.y = this.OptionsPanel_mc.Description_mc.y + this.OptionsPanel_mc.Description_mc.height + this.DESC_PADDING;
      }
      
      private function OnEntryPress(param1:Event) : void
      {
         if(param1.target == this.CategoryList_mc)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.CurrentCategory = this.CategoryList_mc.selectedEntry.uID;
            this.OpenCategorySubPanel();
         }
         else if(param1.target == this.ControlsList_mc)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.ControlsList_mc.OnEntryPressed();
         }
         else if(param1.target == this.OptionsList_mc)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.OptionsList_mc.OnEntryPressed();
         }
      }
      
      private function OnSettingValueChange(param1:CustomEvent) : void
      {
         switch(param1.params.type)
         {
            case SettingsOptionListEntry.SDT_SLIDER:
               BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_SliderChanged",{
                  "fValue":param1.params.value,
                  "uSettingID":param1.params.id
               }));
               break;
            case SettingsOptionListEntry.SDT_STEPPER:
            case SettingsOptionListEntry.SDT_LARGE_STEPPER:
               BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_StepperChanged",{
                  "uIndex":param1.params.value,
                  "uSettingID":param1.params.id
               }));
               break;
            case SettingsOptionListEntry.SDT_CHECKBOX:
               BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_CheckBoxChanged",{
                  "bChecked":param1.params.value == SettingsOptionListEntry.CHECKBOX_ON_VALUE,
                  "uSettingID":param1.params.id
               }));
               break;
            case SettingsOptionListEntry.SDT_LINK:
               BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_LinkClicked",{"uSettingID":param1.params.id}));
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         if(this.visible)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         }
      }
      
      protected function OnActiveBindingChanged(param1:Event) : void
      {
         this.UpdateDeleteBindingButton();
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function onAccept() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         switch(this.CurrentState)
         {
            case this.SPS_CONFIRMING_DEFAULTS:
               this.SetPromptText("");
               BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_ResetToDefaults",{"categoryID":this.CurrentCategory}));
               break;
            case this.SPS_CONFIRMING_CONFLICTS:
               this.SaveAndCloseControls();
         }
      }
      
      private function onResetToDefaults() : void
      {
         this.currentState = this.SPS_CONFIRMING_DEFAULTS;
         this.SetPromptText("$Reset settings to default values?");
      }
      
      private function onDeleteBinding() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         this.ControlsList_mc.OnDeleteBinding();
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         switch(this.CurrentState)
         {
            case this.SPS_CATEGORY:
               dispatchEvent(new Event(PanelUtils.CLOSE_PANEL,true,true));
               break;
            case this.SPS_CONTROLS:
               this.WaitingOnControlsValidation = true;
               BSUIDataManager.dispatchEvent(new Event("SettingsPanel_ValidateControls",true));
               break;
            case this.SPS_OPTIONS:
               BSUIDataManager.dispatchEvent(new Event("SettingsPanel_SaveSettings",true));
               this.currentState = this.SPS_CATEGORY;
               break;
            case this.SPS_CONFIRMING_DEFAULTS:
            case this.SPS_CONFIRMING_CONFLICTS:
               this.currentState = this.GetStateGivenCategory();
               this.SetPromptText("");
         }
      }
   }
}
