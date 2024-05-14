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
   
   public class WorkshopBuilderMenu extends IMenu
   {
      
      public static const ROLL_OFF:String = "rollOff";
      
      public static const ROLL_ON:String = "rollOn";
      
      public static const ROLL_ON_FINISHED:String = "RollOnFinished";
      
      public static const CLOSE_ANIM_FINISHED:String = "CloseAnimationFinished";
      
      public static const BUTTON_BAR_COLOR:uint = 13153632;
       
      
      public var MenuBanner_mc:MovieClip;
      
      public var ConfirmationPopup_mc:BuilderConfirmationPopup;
      
      public var ModelPreview_mc:MovieClip;
      
      public var InfoCard_mc:BuildItemInfoCard;
      
      public var DirectoryHolder_mc:MovieClip;
      
      public var RequirementsPanel_mc:RequirementsPanel;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CutBackground_mc:MovieClip;
      
      private var TrackButton:IButton = null;
      
      private var TrackButtonData:ButtonBaseData;
      
      private var ExitButton:IButton = null;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      private var _rollOnCompleted:Boolean = false;
      
      private var _exitingMenu:Boolean = false;
      
      private var _trackingActive:Boolean = false;
      
      public function WorkshopBuilderMenu()
      {
         this.TrackButtonData = new ButtonBaseData("$TRACK",new UserEventData("XButton",this.ToggleTracking),false);
         super();
         this.ModelPreview_mc.ModelBounds_mc.SetBackgroundColor(454034560);
         this.ModelPreview_mc.ModelBounds_mc.SetMask(this.ModelPreview_mc.ModelBounds_mc.MaskClip);
         BS3DSceneRectManager.Register3DSceneRect(this.ModelPreview_mc.ModelBounds_mc);
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "BuildList_Entry";
         this.DirectoryList_mc.Configure(_loc1_);
         GlobalFunc.SetText(this.MenuBanner_mc.MenuBannerLabel_mc.Text_tf,"$WorkshopBuilderMenu");
         GlobalFunc.SetText(this.DirectoryLabel_mc.Text_tf,"$BuildList");
         GlobalFunc.SetText(this.NameHeader_mc.Text_tf,"$NAME");
         GlobalFunc.SetText(this.MassHeader_mc.Text_tf,"$MASS");
         GlobalFunc.SetText(this.ValueHeader_mc.Text_tf,"$VALUE");
         this.SetUpButtons();
         this.UpdateInteractivity();
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnItemPress);
         addEventListener(RequirementsPanel.SELECT_BUTTON_HIT,this.ConfirmBuildChange);
         addEventListener(BuilderConfirmationPopup.CONFIRM_POPUP_ACCEPT,this.ChangeBuildItem);
         addEventListener(BuilderConfirmationPopup.CONFIRM_POPUP_CANCEL,this.PopupCanceled);
         addEventListener(ROLL_ON_FINISHED,this.RollOnComplete);
         addEventListener(CLOSE_ANIM_FINISHED,this.CloseAnimComplete);
         this.PlayOpeningAnimations();
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
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("WorkshopBuilderDirectoryData",this.OnDirectoryDataUpdate);
         BSUIDataManager.Subscribe("WorkshopBuilderInfoCardData",this.OnInfoCardDataUpdate);
         BSUIDataManager.Subscribe("WorkshopBuilderRequirementsData",this.OnRequirementsDataUpdate);
      }
      
      override public function onRemovedFromStage() : void
      {
         this._organicLibrary.RemoveEventListener();
         super.onRemovedFromStage();
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
               _loc3_ = this.RequirementsPanel_mc.ProcessUserEvent(param1,param2);
            }
         }
         if(!_loc3_ && !this.ConfirmationPopup_mc.active)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
         this.ButtonBar_mc.ButtonBarColor = WorkshopBuilderMenu.BUTTON_BAR_COLOR;
         this.TrackButton = ButtonFactory.AddToButtonBar("BasicButton",this.TrackButtonData,this.ButtonBar_mc);
         this.ExitButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.ExitMenu)),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateInteractivity() : void
      {
         this.DirectoryList_mc.disableInput = !this.allowInput;
         this.DirectoryList_mc.disableSelection = !this.allowInput;
         this.RequirementsPanel_mc.mouseChildren = this.allowInput;
         this.RequirementsPanel_mc.mouseEnabled = this.allowInput;
         this.TrackButton.Enabled = this.allowInput;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function OnInfoCardDataUpdate(param1:FromClientDataEvent) : void
      {
         this.InfoCard_mc.PopulateCard(param1.data);
      }
      
      private function OnDirectoryDataUpdate(param1:FromClientDataEvent) : void
      {
         this.DirectoryList_mc.InitializeEntries(param1.data.aBuildItems);
         if(this.DirectoryList_mc.selectedIndex == -1)
         {
            this.DirectoryList_mc.selectedIndex = 0;
         }
         stage.focus = this.DirectoryList_mc;
      }
      
      private function OnRequirementsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.RequirementsPanel_mc.PopulatePanel(param1.data);
         if(this._trackingActive != param1.data.bTracking)
         {
            this._trackingActive = param1.data.bTracking;
            this.TrackButtonData.sButtonText = this._trackingActive ? "$UNTRACK" : "$TRACK";
            this.TrackButton.SetButtonData(this.TrackButtonData);
            this.TrackButton.Enabled = this.allowInput;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function OnSelectionChange() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = false;
         var _loc3_:* = this.DirectoryList_mc.selectedEntry;
         if(_loc3_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopBuilderMenu_SelectedItem",{"formID":_loc3_.uID}));
            _loc1_ = !_loc3_.bCurrentlyBuilt && Boolean(_loc3_.bPlayerKnowledge);
            _loc2_ = !_loc3_.bPlayerKnowledge;
         }
         this.RequirementsPanel_mc.EnableCreateButton(_loc1_);
         this.InfoCard_mc.ShowDisabledMessage(_loc2_);
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function OnItemPress() : void
      {
         var _loc1_:* = this.DirectoryList_mc.selectedEntry;
         if(_loc1_ != null && !_loc1_.bCurrentlyBuilt && Boolean(_loc1_.bPlayerKnowledge))
         {
            this.ConfirmBuildChange();
         }
         else
         {
            GlobalFunc.PlayMenuSound("UIMenuGeneralActivateFailure");
         }
      }
      
      private function ConfirmBuildChange() : void
      {
         if(this.RequirementsPanel_mc.showWarning)
         {
            this.ConfirmationPopup_mc.PopulateTextInfo("","$Outpost_WarnBreakLinks","$Outpost_ConfirmBreakLinks");
            this.ConfirmationPopup_mc.active = true;
            this.DirectoryList_mc.disableInput = true;
         }
         else
         {
            this.ChangeBuildItem();
         }
      }
      
      private function ChangeBuildItem() : void
      {
         var _loc1_:* = this.DirectoryList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopBuilderMenu_ChangeBuildItem",{"formID":_loc1_.uID}));
         }
         this.ConfirmationPopup_mc.active = false;
         this.DirectoryList_mc.disableInput = false;
         stage.focus = this.DirectoryList_mc;
      }
      
      private function PopupCanceled() : void
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
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopBuilderMenu_ToggleTracking",{"formID":_loc1_.uID}));
         }
      }
      
      private function ExitMenu() : void
      {
         this.exitingMenu = true;
         this.TrackButton.Enabled = false;
         this.ExitButton.Enabled = false;
         this.ButtonBar_mc.RefreshButtons();
         this.PlayClosingAnimations();
      }
      
      private function PlayClosingAnimations() : void
      {
         this.gotoAndPlay(ROLL_OFF);
         this.MenuBanner_mc.gotoAndPlay(ROLL_OFF);
         this.ModelPreview_mc.gotoAndPlay(ROLL_OFF);
         this.InfoCard_mc.gotoAndPlay(ROLL_OFF);
         this.DirectoryHolder_mc.gotoAndPlay(ROLL_OFF);
         this.RequirementsPanel_mc.gotoAndPlay(ROLL_OFF);
         this.CutBackground_mc.gotoAndPlay(ROLL_OFF);
      }
      
      private function PlayOpeningAnimations() : void
      {
         this.MenuBanner_mc.gotoAndPlay(ROLL_ON);
         this.ModelPreview_mc.gotoAndPlay(ROLL_ON);
         this.InfoCard_mc.gotoAndPlay(ROLL_ON);
         this.DirectoryHolder_mc.gotoAndPlay(ROLL_ON);
         this.RequirementsPanel_mc.gotoAndPlay(ROLL_ON);
         this.CutBackground_mc.gotoAndPlay(ROLL_ON);
      }
      
      private function CloseAnimComplete() : void
      {
         GlobalFunc.CloseMenu("WorkshopBuilderMenu");
      }
      
      private function RollOnComplete() : void
      {
         this._rollOnCompleted = true;
         this.DirectoryList_mc.disableInput = false;
         this.DirectoryList_mc.disableSelection = false;
         this.TrackButton.Enabled = true;
         this.ButtonBar_mc.RefreshButtons();
      }
   }
}
