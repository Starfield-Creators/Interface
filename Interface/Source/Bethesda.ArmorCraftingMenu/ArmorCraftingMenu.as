package
{
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ArmorCraftingMenu extends IMenu
   {
      
      public static const ROLL_OFF:String = "rollOff";
      
      public static const ROLL_ON:String = "rollOn";
       
      
      public var MenuBanner_mc:MovieClip;
      
      public var ConfirmationPopup_mc:ConfirmationPopup;
      
      public var MessagesDisplay_mc:MessagesDisplay;
      
      public var ModDescription_mc:ModDescription;
      
      public var ModelPreview_mc:MovieClip;
      
      public var InfoCard_mc:ArmorInfoCard;
      
      public var InventoryDirectory_mc:MovieClip;
      
      public var SlotsDirectory_mc:MovieClip;
      
      public var ModsDirectory_mc:MovieClip;
      
      public var ComponentCostPanel_mc:ComponentCostPanel;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CutBackground_mc:MovieClip;
      
      private var ModifyButton:IButton = null;
      
      private var RenameButton:IButton = null;
      
      private var TrackButton:IButton = null;
      
      private var TrackButtonData:ButtonBaseData;
      
      private var CancelData:ReleaseHoldComboButtonData = null;
      
      private var ExitData:*;
      
      private var RequirementsData:Object = null;
      
      private var ModInfoCardData:Object = null;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      private var _currentState:int;
      
      private var _stateHandler:Function;
      
      private var _waitingOnSlotsData:Boolean = false;
      
      private var _waitingOnModsData:Boolean = false;
      
      private var _initAnimCompleted:Boolean = false;
      
      private var _rollOnCompleted:Boolean = false;
      
      private var _exitQueued:Boolean = false;
      
      private var _exitingMenu:Boolean = false;
      
      private var _inspectActive:Boolean = false;
      
      private var _currentItemHandle:uint = 4294967295;
      
      private var _itemsA:Array;
      
      private const ENTER_STATE:int = EnumHelper.GetEnum(0);
      
      private const EXIT_STATE:int = EnumHelper.GetEnum();
      
      private const LIST_HOVER:int = EnumHelper.GetEnum();
      
      private const LIST_PRESS:int = EnumHelper.GetEnum();
      
      private const ACCEPT_BTN:int = EnumHelper.GetEnum();
      
      private const CANCEL_BTN:int = EnumHelper.GetEnum();
      
      private const EXIT_HOLD_BTN:int = EnumHelper.GetEnum();
      
      private const RENAME_BTN:int = EnumHelper.GetEnum();
      
      private const TRACKING_BTN:int = EnumHelper.GetEnum();
      
      public function ArmorCraftingMenu()
      {
         this.TrackButtonData = new ButtonBaseData("$TRACK",new UserEventData("XButton",this.OnToggleTracking),false);
         this.ExitData = new ReleaseHoldComboButtonData("$EXIT","",[new UserEventData("Cancel",this.OnCancel),new UserEventData("",null,"",false)]);
         this._currentState = CraftingUtils.NO_STATE;
         this._stateHandler = this.inventoryState;
         this._itemsA = new Array();
         super();
         var _loc1_:String = "$EXIT HOLD";
         this.CancelData = new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.OnCancel),new UserEventData("",this.OnExitButtonHeld)]);
         this.ModelPreview_mc.ModelBounds_mc.SetBackgroundColor(151981440);
         this.ModelPreview_mc.ModelBounds_mc.SetMask(this.ModelPreview_mc.ModelBounds_mc.MaskClip);
         BS3DSceneRectManager.Register3DSceneRect(this.ModelPreview_mc.ModelBounds_mc);
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         DirectoryList_Entry.unselectedColor = CraftingUtils.ARMOR_COLOR;
         DirectoryList_Entry.selectedColor = CraftingUtils.SELECTED_TEXT_COLOR_DARK;
         var _loc2_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc2_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc2_.EntryClassName = "ArmorList_Entry";
         this.InventoryList_mc.Configure(_loc2_);
         _loc2_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc2_.EntryClassName = "ModSlotsList_Entry";
         this.SlotsList_mc.Configure(_loc2_);
         _loc2_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc2_.EntryClassName = "ModsList_Entry";
         this.ModsList_mc.Configure(_loc2_);
         GlobalFunc.SetText(this.MenuBanner_mc.MenuBannerLabel_mc.Text_tf,"$SpacesuitWorkbench");
         GlobalFunc.SetText(this.InventoryFrame_mc.Label_mc.Text_tf,"$INVENTORY");
         GlobalFunc.SetText(this.InventoryHeaders_mc.NameHeader_mc.Text_tf,"$NAME");
         GlobalFunc.SetText(this.InventoryHeaders_mc.ResistHeader_mc.Text_tf,"$Resistance");
         GlobalFunc.SetText(this.InventoryHeaders_mc.MassHeader_mc.Text_tf,"$MASS");
         GlobalFunc.SetText(this.InventoryHeaders_mc.ValueHeader_mc.Text_tf,"$VALUE");
         GlobalFunc.SetText(this.SlotsFrame_mc.Label_mc.Text_tf,"$MOD SLOTS");
         GlobalFunc.SetText(this.SlotsHeaders_mc.SlotHeader_mc.Text_tf,"$SLOT");
         GlobalFunc.SetText(this.SlotsHeaders_mc.ComponentHeader_mc.Text_tf,"$INSTALLED COMPONENT");
         GlobalFunc.SetText(this.ModsFrame_mc.Label_mc.Text_tf,"$MODS");
         this.ComponentCostPanel_mc.buttonText = "$INSTALL";
         this.ConfirmationPopup_mc.buttonBarColor = CraftingUtils.ARMOR_COLOR;
         this.MessagesDisplay_mc.messagesAllowed = false;
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnItemPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         addEventListener(CraftingUtils.CREATE_BUTTON_HIT,this.ConfirmInstall);
         addEventListener(CraftingUtils.CONFIRM_POPUP_ACCEPT,this.InstallMod);
         addEventListener(CraftingUtils.CONFIRM_POPUP_CANCEL,this.CancelInstall);
         addEventListener(CraftingUtils.PLAY_ROLL_ON_ANIMS,this.PlayRollOnAnimations);
         addEventListener(CraftingUtils.ROLL_ON_FINISHED,this.RollOnComplete);
         addEventListener(CraftingUtils.EXIT_BENCH_ANIMATION,this.ExitBench);
         this.SetUpButtons();
         this.UpdateInteractivity();
         this._stateHandler(this.ENTER_STATE);
      }
      
      private function get InventoryFrame_mc() : MovieClip
      {
         return this.InventoryDirectory_mc.InventoryFrame_mc;
      }
      
      private function get InventoryHeaders_mc() : MovieClip
      {
         return this.InventoryDirectory_mc.InventoryHeaders_mc;
      }
      
      private function get InventoryList_mc() : BSScrollingContainer
      {
         return this.InventoryDirectory_mc.InventoryList_mc;
      }
      
      private function get SlotsFrame_mc() : MovieClip
      {
         return this.SlotsDirectory_mc.SlotsFrame_mc;
      }
      
      private function get SlotsHeaders_mc() : MovieClip
      {
         return this.SlotsDirectory_mc.SlotsHeaders_mc;
      }
      
      private function get SlotsSpinner_mc() : MovieClip
      {
         return this.SlotsDirectory_mc.SlotsSpinner_mc;
      }
      
      private function get SlotsList_mc() : BSScrollingContainer
      {
         return this.SlotsDirectory_mc.SlotsList_mc;
      }
      
      private function get ModsFrame_mc() : MovieClip
      {
         return this.ModsDirectory_mc.ModsFrame_mc;
      }
      
      private function get ModsHeaders_mc() : MovieClip
      {
         return this.ModsDirectory_mc.ModsHeaders_mc;
      }
      
      private function get ModsList_mc() : BSScrollingContainer
      {
         return this.ModsDirectory_mc.ModsList_mc;
      }
      
      private function get ExitButton() : IButton
      {
         return this.ButtonBar_mc.ExitButton_mc;
      }
      
      private function get currentState() : int
      {
         return this._currentState;
      }
      
      private function set currentState(param1:int) : void
      {
         this._currentState = param1;
      }
      
      private function get allowExit() : Boolean
      {
         return this._initAnimCompleted && !this._exitingMenu;
      }
      
      private function get allowInput() : Boolean
      {
         return this._rollOnCompleted && !this._exitingMenu;
      }
      
      private function set rollOnCompleted(param1:Boolean) : void
      {
         this._rollOnCompleted = param1;
         this.UpdateInteractivity();
      }
      
      private function set exitingMenu(param1:Boolean) : void
      {
         this._exitingMenu = param1;
         this.UpdateInteractivity();
      }
      
      private function set inspectActive(param1:Boolean) : void
      {
         this._inspectActive = param1;
         BSUIDataManager.dispatchCustomEvent(CraftingUtils.SET_INSPECT_CONTROLS_EVENT,{
            "bGamepadControls":this.allowInput,
            "bMouseControls":this._inspectActive && this.allowInput
         });
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ItemModDirectoryData",this.OnModChoicesUpdate);
         BSUIDataManager.Subscribe("ItemModSlotsDirectoryData",this.OnModSlotsUpdate);
         BSUIDataManager.Subscribe("ItemModInfoCardData",this.OnInfoCardDataUpdate);
         BSUIDataManager.Subscribe("CraftingRequirementsData",this.OnRequirementsDataUpdate);
         BSUIDataManager.Subscribe("PlayerArmorInventoryData",this.OnPlayerArmorInventoryDataUpdate);
         BSUIDataManager.Subscribe("ActiveModItemData",this.OnActiveModItemDataUpdate);
         this.ModelPreview_mc.addEventListener(MouseEvent.ROLL_OUT,this.OnModelMouseRollOut);
         this.ModelPreview_mc.addEventListener(MouseEvent.ROLL_OVER,this.OnModelMouseRollOver);
      }
      
      override public function onRemovedFromStage() : void
      {
         this.ComponentCostPanel_mc.RemovedFromStage();
         this._organicLibrary.RemoveEventListener();
         super.onRemovedFromStage();
         this.ModelPreview_mc.removeEventListener(MouseEvent.ROLL_OUT,this.OnModelMouseRollOut);
         this.ModelPreview_mc.removeEventListener(MouseEvent.ROLL_OVER,this.OnModelMouseRollOver);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.allowInput)
         {
            if(this.ConfirmationPopup_mc.active)
            {
               _loc3_ = this.ConfirmationPopup_mc.ProcessUserEvent(param1,param2);
            }
            else if(this._currentState == CraftingUtils.MODS_STATE)
            {
               _loc3_ = this.ComponentCostPanel_mc.ProcessUserEvent(param1,param2);
            }
         }
         if(!_loc3_ && !this.ConfirmationPopup_mc.active && this.allowExit)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,CraftingUtils.BUTTON_SPACING);
         this.ButtonBar_mc.ButtonBarColor = CraftingUtils.ARMOR_COLOR;
         this.ModifyButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$MODIFY",new UserEventData("Accept",this.OnModify),false),this.ButtonBar_mc);
         this.TrackButton = ButtonFactory.AddToButtonBar("BasicButton",this.TrackButtonData,this.ButtonBar_mc);
         this.RenameButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$RENAME",new UserEventData("YButton",this.OnRename),false),this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.ExitButton,this.ExitData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateInteractivity() : void
      {
         var _loc1_:* = this._currentState == CraftingUtils.INVENTORY_STATE;
         var _loc2_:* = this._currentState == CraftingUtils.SLOTS_STATE;
         var _loc3_:* = this._currentState == CraftingUtils.MODS_STATE;
         var _loc4_:* = this._currentState == CraftingUtils.CONFIRMING_STATE;
         this.InventoryList_mc.disableSelection = !_loc1_ || !this.allowInput;
         this.InventoryList_mc.disableInput = !_loc1_ || !this.allowInput;
         this.SlotsList_mc.disableSelection = !_loc2_ || this._waitingOnSlotsData || !this.allowInput;
         this.SlotsList_mc.disableInput = !_loc2_ || this._waitingOnSlotsData || !this.allowInput;
         this.ModsList_mc.disableSelection = !_loc3_ || this._waitingOnModsData || !this.allowInput;
         this.ModsList_mc.disableInput = !_loc3_ || this._waitingOnModsData || !this.allowInput;
         this.ComponentCostPanel_mc.mouseChildren = this.allowInput;
         this.ComponentCostPanel_mc.mouseEnabled = this.allowInput;
         this.ModifyButton.Enabled = this.allowInput && ((_loc1_ || _loc2_) && !this._waitingOnSlotsData);
         this.ModifyButton.Visible = _loc1_ || _loc2_;
         this.TrackButton.Enabled = this.allowInput && !_loc1_ && !_loc2_ && !this._waitingOnModsData && this.RequirementsData != null && this.RequirementsData.aCostRequirements.length > 0;
         this.TrackButton.Visible = !_loc1_ && !_loc2_;
         this.RenameButton.Enabled = this.allowInput && _loc1_ && this.InventoryList_mc.selectedEntry != null && Boolean(this.InventoryList_mc.selectedEntry.bCanRename);
         this.RenameButton.Visible = _loc1_;
         this.ButtonBar_mc.RefreshButtons();
         BSUIDataManager.dispatchCustomEvent(CraftingUtils.SET_INSPECT_CONTROLS_EVENT,{
            "bGamepadControls":this.allowInput,
            "bMouseControls":this._inspectActive && this.allowInput
         });
      }
      
      private function UpdateDirectories() : void
      {
         var _loc1_:* = this._currentState == CraftingUtils.INVENTORY_STATE;
         var _loc2_:* = this._currentState == CraftingUtils.SLOTS_STATE;
         var _loc3_:* = this._currentState == CraftingUtils.MODS_STATE;
         var _loc4_:* = this._currentState == CraftingUtils.CONFIRMING_STATE;
         this.UpdateInteractivity();
         this.InventoryFrame_mc.alpha = _loc1_ ? 1 : CraftingUtils.FADED_DIRECTORY;
         this.InventoryFrame_mc.visible = _loc1_ || _loc2_ || _loc3_ || _loc4_;
         this.InventoryHeaders_mc.visible = _loc1_;
         this.InventoryList_mc.visible = _loc1_;
         this.SlotsFrame_mc.alpha = _loc2_ ? 1 : CraftingUtils.FADED_DIRECTORY;
         this.SlotsFrame_mc.visible = _loc2_ || _loc3_ || _loc4_;
         this.SlotsHeaders_mc.visible = _loc2_;
         this.SlotsList_mc.visible = _loc2_ && !this._waitingOnSlotsData;
         this.SlotsSpinner_mc.visible = _loc2_ && this._waitingOnSlotsData;
         this.ModsFrame_mc.visible = _loc3_ || _loc4_;
         this.ModsHeaders_mc.visible = (_loc3_ || _loc4_) && !this._waitingOnModsData;
         this.ModsList_mc.visible = (_loc3_ || _loc4_) && !this._waitingOnModsData;
      }
      
      private function UpdateInfoCard() : void
      {
         if(this.ModInfoCardData != null && this.currentState == CraftingUtils.MODS_STATE && this.ModsList_mc.selectedEntry != null && !this.ModsList_mc.selectedEntry.bCurrentlyInstalled)
         {
            this.InfoCard_mc.PopulateModData(this.ModInfoCardData);
         }
         else if(this.InventoryList_mc.selectedEntry != null)
         {
            this.InfoCard_mc.PopulateCard(this.InventoryList_mc.selectedEntry);
         }
      }
      
      private function UpdateCostPanel() : void
      {
         if(this.RequirementsData != null && this.currentState == CraftingUtils.MODS_STATE && this.ModsList_mc.selectedEntry != null)
         {
            this.ComponentCostPanel_mc.PopulatePanel(this.RequirementsData);
            this.ComponentCostPanel_mc.SetHeader(this.ModsList_mc.selectedEntry.sName);
            this.ModDescription_mc.SetDescription(this.RequirementsData.sDescription);
            if(this.ModsList_mc.selectedEntry.bCurrentlyInstalled)
            {
               this.ComponentCostPanel_mc.PlayAnimation(AnimatedModClip.INSTALLED);
               this.ComponentCostPanel_mc.EnableCreateButton(false);
               this.ModDescription_mc.PlayAnimation(AnimatedModClip.INSTALLED);
            }
            else
            {
               this.ComponentCostPanel_mc.PlayAnimation(AnimatedModClip.SHOW_CONTENT);
               this.ModDescription_mc.PlayAnimation(AnimatedModClip.SHOW_CONTENT);
            }
         }
         else
         {
            this.ComponentCostPanel_mc.SetHeader("$NoModSelected");
            this.ComponentCostPanel_mc.PlayAnimation(AnimatedModClip.HIDE_CONTENT);
            this.ComponentCostPanel_mc.EnableCreateButton(false);
            this.ModDescription_mc.PlayAnimation(AnimatedModClip.HIDE_CONTENT);
         }
      }
      
      private function ExitMenu() : void
      {
         this.exitingMenu = true;
         this.ExitButton.Enabled = false;
         this.ButtonBar_mc.RefreshButtons();
         if(this._rollOnCompleted)
         {
            this.PlayClosingAnimations();
         }
         else
         {
            this._exitQueued = true;
         }
      }
      
      private function OnModelMouseRollOut(param1:Event) : *
      {
         this.inspectActive = false;
      }
      
      private function OnModelMouseRollOver(param1:Event) : *
      {
         this.inspectActive = true;
      }
      
      private function CheckActiveModItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         if(this._currentItemHandle != uint.MAX_VALUE && (this.InventoryList_mc.selectedEntry == null || this.InventoryList_mc.selectedEntry.uHandleID != this._currentItemHandle))
         {
            _loc1_ = 0;
            for each(_loc2_ in this._itemsA)
            {
               if(_loc2_.uHandleID == this._currentItemHandle)
               {
                  break;
               }
               _loc1_++;
            }
            this.InventoryList_mc.selectedIndex = _loc1_;
         }
      }
      
      private function OnActiveModItemDataUpdate(param1:FromClientDataEvent) : void
      {
         this._currentItemHandle = param1.data.uCurrentItemHandle;
         this.CheckActiveModItem();
      }
      
      private function OnPlayerArmorInventoryDataUpdate(param1:FromClientDataEvent) : void
      {
         this._itemsA = param1.data.aItems;
         this.InventoryList_mc.InitializeEntries(this._itemsA);
         if(this._currentItemHandle == uint.MAX_VALUE)
         {
            this.InventoryList_mc.selectedIndex = 0;
         }
         else
         {
            this.CheckActiveModItem();
         }
      }
      
      private function OnModSlotsUpdate(param1:FromClientDataEvent) : void
      {
         this.SlotsList_mc.InitializeEntries(param1.data.aModSlots);
         if(this.SlotsList_mc.selectedIndex < 0 || this.SlotsList_mc.selectedIndex >= param1.data.aModSlots.length)
         {
            this.SlotsList_mc.selectedIndex = 0;
         }
         if(this._waitingOnSlotsData)
         {
            this._waitingOnSlotsData = false;
            this.UpdateDirectories();
         }
      }
      
      private function OnModChoicesUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data.sType + " $$COMPONENTS";
         GlobalFunc.SetText(this.ModsHeaders_mc.ComponentsHeader_mc.Text_tf,_loc2_);
         this.ModsList_mc.InitializeEntries(param1.data.aMods);
         if(this.ModsList_mc.selectedIndex < 0 || this.ModsList_mc.selectedIndex >= param1.data.aMods.length)
         {
            this.ModsList_mc.selectedIndex = 0;
         }
         if(this._waitingOnModsData)
         {
            this._waitingOnModsData = false;
            this.UpdateDirectories();
         }
      }
      
      private function OnInfoCardDataUpdate(param1:FromClientDataEvent) : void
      {
         this.ModInfoCardData = param1.data;
         this.UpdateInfoCard();
      }
      
      private function OnRequirementsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.RequirementsData = param1.data;
         var _loc2_:* = this._currentState == CraftingUtils.INVENTORY_STATE;
         var _loc3_:* = this._currentState == CraftingUtils.SLOTS_STATE;
         this.TrackButtonData.sButtonText = !!this.RequirementsData.bTracking ? "$UNTRACK" : "$TRACK";
         this.TrackButton.SetButtonData(this.TrackButtonData);
         this.TrackButton.Enabled = this.allowInput && !_loc2_ && !_loc3_ && !this._waitingOnModsData && this.RequirementsData != null && this.RequirementsData.aCostRequirements.length > 0;
         this.TrackButton.Visible = !_loc2_ && !_loc3_;
         this.ButtonBar_mc.RefreshButtons();
         this.UpdateCostPanel();
      }
      
      private function OnSelectionChange() : void
      {
         this._stateHandler(this.LIST_HOVER);
      }
      
      private function OnItemPress() : void
      {
         if(this._initAnimCompleted)
         {
            this._stateHandler(this.LIST_PRESS);
         }
      }
      
      private function PlayFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function ExitBench() : void
      {
         BSUIDataManager.dispatchEvent(new Event(CraftingUtils.EXIT_BENCH_EVENT));
      }
      
      private function PlayRollOnAnimations() : void
      {
         this._initAnimCompleted = true;
         this.MenuBanner_mc.gotoAndPlay(ROLL_ON);
         this.ModelPreview_mc.gotoAndPlay(ROLL_ON);
         this.InfoCard_mc.gotoAndPlay(ROLL_ON);
         this.InventoryDirectory_mc.gotoAndPlay(ROLL_ON);
         this.InventoryHeaders_mc.gotoAndPlay(ROLL_ON);
         this.InventoryFrame_mc.gotoAndPlay(ROLL_ON);
         this.ComponentCostPanel_mc.gotoAndPlay(ROLL_ON);
         this.ModDescription_mc.gotoAndPlay(ROLL_ON);
         this.CutBackground_mc.gotoAndPlay(ROLL_ON);
      }
      
      private function RollOnComplete() : void
      {
         this.rollOnCompleted = true;
         this.MessagesDisplay_mc.messagesAllowed = true;
         if(this._exitQueued)
         {
            this.PlayClosingAnimations();
            this._exitQueued = false;
         }
      }
      
      private function PlayClosingAnimations() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuCraftingSpacesuitMenuClose");
         this.gotoAndPlay(ROLL_OFF);
         this.MenuBanner_mc.gotoAndPlay(ROLL_OFF);
         this.ModelPreview_mc.gotoAndPlay(ROLL_OFF);
         this.MessagesDisplay_mc.messagesAllowed = false;
         this.MessagesDisplay_mc.ClearAllMessages();
         this.InfoCard_mc.gotoAndPlay(ROLL_OFF);
         this.CutBackground_mc.gotoAndPlay(ROLL_OFF);
         this.InventoryDirectory_mc.gotoAndPlay(ROLL_OFF);
         this.InventoryHeaders_mc.gotoAndPlay(ROLL_OFF);
         this.InventoryFrame_mc.gotoAndPlay(ROLL_OFF);
         this.SlotsSpinner_mc.visible = false;
         this.SlotsDirectory_mc.gotoAndPlay(ROLL_OFF);
         this.SlotsHeaders_mc.gotoAndPlay(ROLL_OFF);
         this.SlotsFrame_mc.gotoAndPlay(ROLL_OFF);
         this.ModsDirectory_mc.gotoAndPlay(ROLL_OFF);
         this.ModsHeaders_mc.gotoAndPlay(ROLL_OFF);
         this.ModsFrame_mc.gotoAndPlay(ROLL_OFF);
         this.ComponentCostPanel_mc.CancelQueuedAnims();
         this.ComponentCostPanel_mc.gotoAndPlay(ROLL_OFF);
         this.ModDescription_mc.CancelQueuedAnims();
         this.ModDescription_mc.gotoAndPlay(ROLL_OFF);
      }
      
      private function ConfirmInstall() : void
      {
         this._stateHandler(this.ACCEPT_BTN);
      }
      
      private function InstallMod() : void
      {
         this._stateHandler(this.ACCEPT_BTN);
      }
      
      private function CancelInstall() : void
      {
         this._stateHandler(this.CANCEL_BTN);
      }
      
      private function OnModify() : void
      {
         this._stateHandler(this.LIST_PRESS);
      }
      
      private function OnToggleTracking() : void
      {
         this._stateHandler(this.TRACKING_BTN);
      }
      
      private function OnCancel() : void
      {
         this._stateHandler(this.CANCEL_BTN);
      }
      
      private function OnExitButtonHeld() : void
      {
         this._stateHandler(this.EXIT_HOLD_BTN);
      }
      
      private function OnRename() : void
      {
         this._stateHandler(this.RENAME_BTN);
      }
      
      private function TransitionToState(param1:Function) : void
      {
         this._stateHandler(this.EXIT_STATE);
         this._stateHandler = param1;
         this._stateHandler(this.ENTER_STATE);
      }
      
      private function inventoryState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = CraftingUtils.INVENTORY_STATE;
               stage.focus = this.InventoryList_mc;
               this.ExitButton.SetButtonData(this.ExitData);
               this.ButtonBar_mc.RefreshButtons();
               this.UpdateDirectories();
               this.UpdateInfoCard();
               this.UpdateCostPanel();
               break;
            case this.LIST_HOVER:
               if(this.InventoryList_mc.selectedEntry != null)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.VIEW_MOD_ITEM_EVENT,{"formID":this.InventoryList_mc.selectedEntry.uHandleID}));
                  this.UpdateInfoCard();
                  this.RenameButton.Enabled = this.allowInput && Boolean(this.InventoryList_mc.selectedEntry.bCanRename);
                  this.RenameButton.Visible = true;
                  this.ButtonBar_mc.RefreshButtons();
               }
               break;
            case this.LIST_PRESS:
               if(this.InventoryList_mc.selectedEntry != null)
               {
                  BSUIDataManager.dispatchEvent(new Event(CraftingUtils.SELECT_MOD_ITEM_EVENT));
                  this._waitingOnSlotsData = true;
                  this.SlotsList_mc.selectedIndex = 0;
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
                  this.TransitionToState(this.slotsState);
               }
               break;
            case this.RENAME_BTN:
               if(this.InventoryList_mc.selectedEntry != null && Boolean(this.InventoryList_mc.selectedEntry.bCanRename))
               {
                  BSUIDataManager.dispatchEvent(new Event(CraftingUtils.RENAME_ITEM_EVENT));
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               }
               break;
            case this.CANCEL_BTN:
               this.ExitMenu();
               break;
            case this.EXIT_STATE:
               stage.focus = null;
         }
      }
      
      private function slotsState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = CraftingUtils.SLOTS_STATE;
               stage.focus = this.SlotsList_mc;
               this.ExitButton.SetButtonData(this.CancelData);
               this.ButtonBar_mc.RefreshButtons();
               this.UpdateDirectories();
               this.UpdateInfoCard();
               this.UpdateCostPanel();
               break;
            case this.LIST_PRESS:
               if(this.SlotsList_mc.selectedEntry != null && Boolean(this.SlotsList_mc.selectedEntry.CurrentMod.bPlayerEditable))
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.SELECT_MODSLOT_EVENT,{"formID":this.SlotsList_mc.selectedEntry.uID}));
                  this._waitingOnModsData = true;
                  this.ModsList_mc.selectedIndex = 0;
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
                  this.TransitionToState(this.modsState);
               }
               else
               {
                  GlobalFunc.PlayMenuSound("UIMenuGeneralActivateFailure");
               }
               break;
            case this.CANCEL_BTN:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               BSUIDataManager.dispatchEvent(new Event("ArmorCraftingMenu_RevertHighlight"));
               this.TransitionToState(this.inventoryState);
               break;
            case this.EXIT_HOLD_BTN:
               this.ExitMenu();
               break;
            case this.EXIT_STATE:
               stage.focus = null;
         }
      }
      
      private function modsState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = CraftingUtils.MODS_STATE;
               stage.focus = this.ModsList_mc;
               this.ExitButton.SetButtonData(this.CancelData);
               this.ButtonBar_mc.RefreshButtons();
               this.UpdateDirectories();
               break;
            case this.LIST_HOVER:
               if(this.ModsList_mc.selectedEntry != null)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.SELECT_MOD_EVENT,{"formID":this.ModsList_mc.selectedEntry.uID}));
                  if(this.ModsList_mc.selectedEntry.bCurrentlyInstalled)
                  {
                     this.UpdateInfoCard();
                  }
               }
               break;
            case this.LIST_PRESS:
               if(this.RequirementsData.bRequirementsMet && this.ModsList_mc.selectedEntry != null && !this.ModsList_mc.selectedEntry.bCurrentlyInstalled)
               {
                  this.TransitionToState(this.confirmingState);
               }
               else
               {
                  GlobalFunc.PlayMenuSound("UIMenuGeneralActivateFailure");
               }
               break;
            case this.ACCEPT_BTN:
               this.TransitionToState(this.confirmingState);
               break;
            case this.CANCEL_BTN:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               BSUIDataManager.dispatchEvent(new Event(CraftingUtils.REVERT_MOD_EVENT));
               this.TransitionToState(this.slotsState);
               break;
            case this.EXIT_HOLD_BTN:
               this.ExitMenu();
               break;
            case this.TRACKING_BTN:
               if(this.ModsList_mc.selectedEntry != null)
               {
                  GlobalFunc.PlayMenuSound(!!this.RequirementsData.bTracking ? "UIMenuInventoryItemTagOff" : "UIMenuInventoryItemTagOn");
                  BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.TOGGLE_TRACKING_EVENT,{"formID":this.ModsList_mc.selectedEntry.uRecipeID}));
               }
               break;
            case this.EXIT_STATE:
               stage.focus = null;
         }
      }
      
      private function confirmingState(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = CraftingUtils.CONFIRMING_STATE;
               if(this.RequirementsData != null)
               {
                  this.ConfirmationPopup_mc.PopulateList(this.RequirementsData.aCostRequirements);
                  _loc2_ = "$$Installing " + this.RequirementsData.sDisplayName;
                  _loc3_ = this.RequirementsData.aCostRequirements.length > 0 ? "" : "$ModHasNoRequirements";
                  this.ConfirmationPopup_mc.PopulateTextInfo(_loc2_,_loc3_,"$ConfirmInstallPrompt");
                  this.ConfirmationPopup_mc.active = true;
                  GlobalFunc.PlayMenuSound("UIMenuCraftingModsMenuRequirements");
               }
               break;
            case this.ACCEPT_BTN:
               if(this.ModsList_mc.selectedEntry != null)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.INSTALL_MOD_EVENT,{"formID":this.ModsList_mc.selectedEntry.uID}));
               }
               this.TransitionToState(this.modsState);
               break;
            case this.CANCEL_BTN:
               this.TransitionToState(this.modsState);
               break;
            case this.EXIT_STATE:
               this.ConfirmationPopup_mc.active = false;
         }
      }
   }
}
