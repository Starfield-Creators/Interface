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
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class IndustrialCraftingMenu extends IMenu
   {
      
      public static const ROLL_OFF:String = "rollOff";
      
      public static const ROLL_ON:String = "rollOn";
       
      
      public var MenuBanner_mc:MovieClip;
      
      public var ConfirmationPopup_mc:ConfirmationPopup;
      
      public var MessagesDisplay_mc:MessagesDisplay;
      
      public var ModelPreview_mc:MovieClip;
      
      public var InfoCard_mc:CraftingInfoCard;
      
      public var DirectoryHolder_mc:MovieClip;
      
      public var ComponentCostPanel_mc:ComponentCostPanel;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CutBackground_mc:MovieClip;
      
      private var TrackButton:IButton = null;
      
      private var TrackButtonData:ButtonBaseData;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      private var _requirementsMet:Boolean = false;
      
      private var _trackingActive:Boolean = false;
      
      private var _initAnimCompleted:Boolean = false;
      
      private var _rollOnCompleted:Boolean = false;
      
      private var _exitQueued:Boolean = false;
      
      private var _exitingMenu:Boolean = false;
      
      private var _inspectActive:Boolean = false;
      
      public function IndustrialCraftingMenu()
      {
         this.TrackButtonData = new ButtonBaseData("$TRACK",new UserEventData("XButton",this.ToggleTracking),false);
         super();
         this.ModelPreview_mc.ModelBounds_mc.SetBackgroundColor(790783);
         this.ModelPreview_mc.ModelBounds_mc.SetMask(this.ModelPreview_mc.ModelBounds_mc.MaskClip);
         BS3DSceneRectManager.Register3DSceneRect(this.ModelPreview_mc.ModelBounds_mc);
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         DirectoryList_Entry.unselectedColor = CraftingUtils.INDUSTRIAL_COLOR;
         DirectoryList_Entry.selectedColor = CraftingUtils.SELECTED_TEXT_COLOR_LIGHT;
         DirectoryList_Entry.dimmedColor = CraftingUtils.INDUSTRIAL_SECONDARY_COLOR;
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc1_.EntryClassName = "DirectoryList_Entry";
         this.DirectoryList_mc.Configure(_loc1_);
         GlobalFunc.SetText(this.MenuBanner_mc.MenuBannerLabel_mc.Text_tf,"$IndustrialWorkbench");
         GlobalFunc.SetText(this.DirectoryLabel_mc.Text_tf,"$Directory");
         GlobalFunc.SetText(this.NameHeader_mc.Text_tf,"$NAME");
         GlobalFunc.SetText(this.MassHeader_mc.Text_tf,"$MASS");
         GlobalFunc.SetText(this.ValueHeader_mc.Text_tf,"$VALUE");
         this.ComponentCostPanel_mc.buttonText = "$CRAFT";
         this.ConfirmationPopup_mc.buttonBarColor = CraftingUtils.INDUSTRIAL_COLOR;
         this.MessagesDisplay_mc.messagesAllowed = false;
         this.SetUpButtons();
         this.UpdateInteractivity();
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnItemPress);
         addEventListener(CraftingUtils.CREATE_BUTTON_HIT,this.ConfirmBuild);
         addEventListener(CraftingUtils.CONFIRM_POPUP_ACCEPT,this.CraftItem);
         addEventListener(CraftingUtils.CONFIRM_POPUP_CANCEL,this.CancelCraft);
         addEventListener(CraftingUtils.PLAY_ROLL_ON_ANIMS,this.PlayRollOnAnimations);
         addEventListener(CraftingUtils.ROLL_ON_FINISHED,this.RollOnComplete);
         addEventListener(CraftingUtils.EXIT_BENCH_ANIMATION,this.ExitBench);
      }
      
      private function get DirectoryLabel_mc() : MovieClip
      {
         return this.DirectoryHolder_mc.DirectoryLabel_mc;
      }
      
      private function get NameHeader_mc() : MovieClip
      {
         return this.DirectoryHolder_mc.NameHeader_mc;
      }
      
      private function get MassHeader_mc() : MovieClip
      {
         return this.DirectoryHolder_mc.MassHeader_mc;
      }
      
      private function get ValueHeader_mc() : MovieClip
      {
         return this.DirectoryHolder_mc.ValueHeader_mc;
      }
      
      private function get DirectoryList_mc() : BSScrollingContainer
      {
         return this.DirectoryHolder_mc.DirectoryList_mc;
      }
      
      private function get ExitButton() : IButton
      {
         return this.ButtonBar_mc.ExitButton_mc;
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
         BSUIDataManager.Subscribe("CraftingInfoCardData",this.OnInfoCardDataUpdate);
         BSUIDataManager.Subscribe("CraftingRecipesData",this.OnRecipesDataUpdate);
         BSUIDataManager.Subscribe("CraftingRequirementsData",this.OnRequirementsDataUpdate);
         this.ModelPreview_mc.addEventListener(MouseEvent.ROLL_OUT,this.OnModelMouseRollOut);
         this.ModelPreview_mc.addEventListener(MouseEvent.ROLL_OVER,this.OnModelMouseRollOver);
      }
      
      override public function onRemovedFromStage() : void
      {
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
            else
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
         this.ButtonBar_mc.ButtonBarColor = CraftingUtils.INDUSTRIAL_COLOR;
         this.TrackButton = ButtonFactory.AddToButtonBar("BasicButton",this.TrackButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.ExitButton,new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.ExitMenu)));
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateInteractivity() : void
      {
         this.DirectoryList_mc.disableInput = !this.allowInput;
         this.DirectoryList_mc.disableSelection = !this.allowInput;
         this.ComponentCostPanel_mc.mouseChildren = this.allowInput;
         this.ComponentCostPanel_mc.mouseEnabled = this.allowInput;
         this.TrackButton.Enabled = this.allowInput;
         this.ButtonBar_mc.RefreshButtons();
         BSUIDataManager.dispatchCustomEvent(CraftingUtils.SET_INSPECT_CONTROLS_EVENT,{
            "bGamepadControls":this.allowInput,
            "bMouseControls":this._inspectActive && this.allowInput
         });
      }
      
      private function OnModelMouseRollOut(param1:Event) : *
      {
         this.inspectActive = false;
      }
      
      private function OnModelMouseRollOver(param1:Event) : *
      {
         this.inspectActive = true;
      }
      
      private function OnInfoCardDataUpdate(param1:FromClientDataEvent) : void
      {
         this.InfoCard_mc.PopulateCard(param1.data);
      }
      
      private function OnRecipesDataUpdate(param1:FromClientDataEvent) : void
      {
         this.DirectoryList_mc.InitializeEntries(param1.data.aRecipes);
         if(this.DirectoryList_mc.selectedIndex == -1)
         {
            this.DirectoryList_mc.selectedIndex = 0;
         }
         stage.focus = this.DirectoryList_mc;
      }
      
      private function OnRequirementsDataUpdate(param1:FromClientDataEvent) : void
      {
         this._requirementsMet = param1.data.bRequirementsMet;
         this._trackingActive = param1.data.bTracking;
         this.TrackButtonData.sButtonText = this._trackingActive ? "$UNTRACK" : "$TRACK";
         this.TrackButton.SetButtonData(this.TrackButtonData);
         this.TrackButton.Enabled = this.allowInput;
         this.ButtonBar_mc.RefreshButtons();
         this.ComponentCostPanel_mc.PopulatePanel(param1.data);
         this.ConfirmationPopup_mc.PopulateList(param1.data.aCostRequirements,param1.data.uMaxAmountCraftable);
         var _loc2_:String = "$$Crafting " + param1.data.sDisplayName;
         this.ConfirmationPopup_mc.PopulateTextInfo(_loc2_,"","$ConfirmCraftPrompt");
      }
      
      private function OnSelectionChange() : void
      {
         var _loc1_:* = this.DirectoryList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.SELECTED_RECIPE_EVENT,{"formID":_loc1_.uID}));
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function OnItemPress() : void
      {
         if(this._requirementsMet)
         {
            this.ConfirmBuild();
         }
         else
         {
            GlobalFunc.PlayMenuSound("UIMenuGeneralActivateFailure");
         }
      }
      
      private function ConfirmBuild() : void
      {
         this.ConfirmationPopup_mc.active = true;
         GlobalFunc.PlayMenuSound("UIMenuCraftingIndustrialMenuRequirements");
         this.DirectoryList_mc.disableInput = true;
      }
      
      private function CraftItem(param1:CustomEvent) : void
      {
         var _loc2_:* = this.DirectoryList_mc.selectedEntry;
         if(_loc2_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.CRAFT_ITEM_EVENT,{
               "formID":_loc2_.uID,
               "itemQuantity":param1.params.itemQuantity
            }));
         }
         this.ConfirmationPopup_mc.active = false;
         this.DirectoryList_mc.disableInput = false;
         stage.focus = this.DirectoryList_mc;
      }
      
      private function CancelCraft() : void
      {
         this.ConfirmationPopup_mc.active = false;
         this.DirectoryList_mc.disableInput = false;
         stage.focus = this.DirectoryList_mc;
      }
      
      private function ToggleTracking() : void
      {
         var _loc1_:* = this.DirectoryList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            GlobalFunc.PlayMenuSound(this._trackingActive ? "UIMenuInventoryItemTagOff" : "UIMenuInventoryItemTagOn");
            BSUIDataManager.dispatchEvent(new CustomEvent(CraftingUtils.TOGGLE_TRACKING_EVENT,{"formID":_loc1_.uID}));
         }
      }
      
      private function ExitMenu() : void
      {
         this.exitingMenu = true;
         this.TrackButton.Enabled = false;
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
      
      private function PlayClosingAnimations() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuCraftingIndustrialMenuClose");
         this.gotoAndPlay(ROLL_OFF);
         this.MenuBanner_mc.gotoAndPlay(ROLL_OFF);
         this.ModelPreview_mc.gotoAndPlay(ROLL_OFF);
         this.MessagesDisplay_mc.messagesAllowed = false;
         this.MessagesDisplay_mc.ClearAllMessages();
         this.InfoCard_mc.gotoAndPlay(ROLL_OFF);
         this.DirectoryHolder_mc.gotoAndPlay(ROLL_OFF);
         this.ComponentCostPanel_mc.CancelQueuedAnims();
         this.ComponentCostPanel_mc.gotoAndPlay(ROLL_OFF);
         this.CutBackground_mc.gotoAndPlay(ROLL_OFF);
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
         this.DirectoryHolder_mc.gotoAndPlay(ROLL_ON);
         this.ComponentCostPanel_mc.gotoAndPlay(ROLL_ON);
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
   }
}
