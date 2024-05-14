package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
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
   
   public class ResearchMenu extends IMenu
   {
      
      public static const BUTTON_COLOR:uint = 4343626;
      
      public static const LOADING_ANIM_COMPLETE:String = "LoadingScreenAnimComplete";
      
      public static const CLOSE_MENU_ANIM_COMPLETE:String = "CloseMenuAnimComplete";
       
      
      public var Header_mc:MovieClip;
      
      public var LoadingScreen_mc:MovieClip;
      
      public var MiniCategoryList_mc:MiniCategoryList;
      
      public var MainLanding_mc:MainLanding;
      
      public var CategoryPage_mc:CategoryPage;
      
      public var ProjectPage_mc:ProjectPage;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Background_mc:MovieClip;
      
      public var Dots_mc:MovieClip;
      
      public var Overlay_mc:MovieClip;
      
      public var VolumeSelection_mc:VolumeSelection;
      
      public var SuddenEvent_mc:SuddenDevelopmentPopup;
      
      public var ProjectComplete_mc:ProjectCompletePopup;
      
      private var _activePopup:IResearchComponent = null;
      
      private var _popupQueue:Array;
      
      private var _currentState:int;
      
      private var _stateHandler:Function;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      private var _skillLibrary:SharedLibraryOwner = null;
      
      private var _exitingMenu:Boolean = false;
      
      private var TrackButton:IButton = null;
      
      private var PrevCategoryButton:IButton = null;
      
      private var NextCategoryButton:IButton = null;
      
      private var SelectButton:IButton = null;
      
      private var BackButton:IButton = null;
      
      private var TrackButtonData:ButtonBaseData;
      
      private var ExitButtonData:ReleaseHoldComboButtonData;
      
      private var ExitComboButtonData:ReleaseHoldComboButtonData = null;
      
      private const ENTER_STATE:int = EnumHelper.GetEnum(0);
      
      private const EXIT_STATE:int = EnumHelper.GetEnum();
      
      private const SHOW_NEXT_COMPONENT:int = EnumHelper.GetEnum();
      
      private const ACCEPT_EVENT:int = EnumHelper.GetEnum();
      
      private const CANCEL_EVENT:int = EnumHelper.GetEnum();
      
      private const PREV_CATEGORY:int = EnumHelper.GetEnum();
      
      private const NEXT_CATEGORY:int = EnumHelper.GetEnum();
      
      private const CATEGORY_CHANGED_EVENT:int = EnumHelper.GetEnum();
      
      private const SORT_EVENT:int = EnumHelper.GetEnum();
      
      private const FILTER_EVENT:int = EnumHelper.GetEnum();
      
      private const TRACK_EVENT:int = EnumHelper.GetEnum();
      
      private const EXIT_EVENT:int = EnumHelper.GetEnum();
      
      public function ResearchMenu()
      {
         this._currentState = ResearchUtils.NO_STATE;
         this._stateHandler = this.loadingState;
         this.TrackButtonData = new ButtonBaseData("$TRACK",new UserEventData("XButton",this.OnTrackButton),false,false);
         this.ExitButtonData = new ReleaseHoldComboButtonData("$EXIT","",[new UserEventData("Cancel",this.OnBackButton),new UserEventData("",null,"",false)]);
         super();
         var _loc1_:String = "$EXIT HOLD";
         this.ExitComboButtonData = new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.OnBackButton),new UserEventData("",this.OnExitButtonHeld)]);
         this.Dots_mc.mouseChildren = false;
         this.Dots_mc.mouseEnabled = false;
         this.Overlay_mc.mouseChildren = false;
         this.Overlay_mc.mouseEnabled = false;
         this._popupQueue = new Array();
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         this._skillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,ProjectSkillRequirement.REQUEST_LOADER);
         this.MiniCategoryList_mc.Initialize(ButtonBar.JUSTIFY_CENTER,ResearchUtils.CATEGORY_LIST_SPACING);
         this.MiniCategoryList_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_PIXEL_PERFECT);
         this.MiniCategoryList_mc.SetVertical(true);
         addEventListener(LOADING_ANIM_COMPLETE,this.LoadScreenAnimComplete);
         addEventListener(CLOSE_MENU_ANIM_COMPLETE,this.CloseAnimComplete);
         addEventListener(ResearchUtils.CLOSE_POPUP,this.CloseCurrentPopup);
         addEventListener(ResearchUtils.REFRESH_BUTTON_BAR,this.UpdateButtonHints);
         addEventListener(ResearchUtils.CATEGORY_PRESSED,this.ShowCategoryPage);
         addEventListener(ResearchUtils.PROJECT_PRESSED,this.ShowProjectPage);
         addEventListener(ResearchUtils.SHOW_VOLUME_POPUP,this.ShowVolumePopup);
         addEventListener(ResearchUtils.VOLUME_POPUP_ACCEPT,this.ConfirmedAddingMaterial);
         addEventListener(ResearchUtils.CATEGORY_CHANGED,this.ChangeCategory);
         this.SetUpButtons();
         this._stateHandler(this.ENTER_STATE);
         GlobalFunc.PlayMenuSound(ResearchUtils.MENU_OPEN_SOUND);
         GlobalFunc.PlayMenuSound(ResearchUtils.TITLE_SOUND);
      }
      
      private function get currentState() : int
      {
         return this._currentState;
      }
      
      private function set currentState(param1:int) : void
      {
         if(this._currentState != param1)
         {
            this._currentState = param1;
            this.UpdateMenuHeader();
            this.UpdateButtonHints();
         }
      }
      
      private function get ActivePopup() : IResearchComponent
      {
         return this._activePopup;
      }
      
      private function set ActivePopup(param1:IResearchComponent) : void
      {
         this._activePopup = param1;
      }
      
      private function get PopupQueue() : Array
      {
         return this._popupQueue;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ResearchCategoriesData",this.OnCategoriesDataUpdate);
         BSUIDataManager.Subscribe("ResearchProjectsData",this.OnProjectsDataUpdate);
         BSUIDataManager.Subscribe("ResearchProjectDetailsData",this.OnProjectDetailsDataUpdate);
         BSUIDataManager.Subscribe("ResearchPopupData",this.OnPopupDataUpdate);
      }
      
      override public function onRemovedFromStage() : void
      {
         this._organicLibrary.RemoveEventListener();
         this._skillLibrary.RemoveEventListener();
         super.onRemovedFromStage();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.ActivePopup != null)
         {
            _loc3_ = this.ActivePopup.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,ResearchUtils.BUTTON_SPACING);
         this.ButtonBar_mc.ButtonBarColor = ResearchMenu.BUTTON_COLOR;
         this.TrackButton = ButtonFactory.AddToButtonBar("BasicButton",this.TrackButtonData,this.ButtonBar_mc);
         this.PrevCategoryButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$PREVCATEGORY",new UserEventData("LShoulder",this.OnPrevCatButton),false,false),this.ButtonBar_mc);
         this.NextCategoryButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$NEXTCATEGORY",new UserEventData("RShoulder",this.OnNextCatButton),false,false),this.ButtonBar_mc);
         this.SelectButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SELECT",new UserEventData("Accept",this.OnSelectButton),false,false),this.ButtonBar_mc);
         this.BackButton = ButtonFactory.AddToButtonBar("ReleaseHoldComboButton",this.ExitButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateButtonHints() : void
      {
         var _loc2_:* = false;
         var _loc1_:* = this.currentState == ResearchUtils.MAIN_LANDING_STATE;
         _loc2_ = this.currentState == ResearchUtils.CATEGORY_PAGE_STATE;
         var _loc3_:* = this.currentState == ResearchUtils.PROJECT_PAGE_STATE;
         var _loc4_:String = _loc2_ ? this.CategoryPage_mc.GetTrackingButtonText() : (_loc3_ ? this.ProjectPage_mc.GetTrackingButtonText() : "");
         this.TrackButtonData.sButtonText = _loc4_;
         this.TrackButton.SetButtonData(this.TrackButtonData);
         this.TrackButton.Enabled = _loc4_ != "" && (_loc2_ || _loc3_);
         this.TrackButton.Visible = _loc4_ != "" && (_loc2_ || _loc3_);
         this.PrevCategoryButton.Enabled = _loc2_ || _loc3_;
         this.PrevCategoryButton.Visible = _loc2_ || _loc3_;
         this.NextCategoryButton.Enabled = _loc2_ || _loc3_;
         this.NextCategoryButton.Visible = _loc2_ || _loc3_;
         this.SelectButton.Enabled = (_loc1_ || _loc2_ && !this.CategoryPage_mc.selectButtonDisabled || _loc3_ && !this.ProjectPage_mc.addButtonDisabled) && !this._exitingMenu;
         this.SelectButton.Visible = _loc1_ || _loc2_ || _loc3_;
         this.BackButton.SetButtonData(_loc1_ ? this.ExitButtonData : this.ExitComboButtonData);
         this.BackButton.Enabled = (_loc1_ || _loc2_ || _loc3_) && !this._exitingMenu;
         this.BackButton.Visible = _loc1_ || _loc2_ || _loc3_;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateMenuHeader() : void
      {
         if(this._currentState > ResearchUtils.MAIN_LANDING_STATE && this.MainLanding_mc.CategoriesList_mc.selectedEntry != null)
         {
            GlobalFunc.SetText(this.Header_mc.Text_mc.Text_tf,"$FIELD RESEARCH TERMINAL CATEGORY",false,false,0,false,0,new Array(this.MainLanding_mc.CategoriesList_mc.selectedEntry.sCategoryName));
         }
         else
         {
            GlobalFunc.SetText(this.Header_mc.Text_mc.Text_tf,"$FIELD RESEARCH TERMINAL");
         }
      }
      
      private function GetFilterButtonText(param1:uint) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case ResearchUtils.PROJECT_FILTER_NONE:
               _loc2_ = "$RESEARCH_FILTER_NONE";
               break;
            case ResearchUtils.PROJECT_FILTER_HIDE_COMPLETED:
               _loc2_ = "$RESEARCH_FILTER_HIDE_COMPLETED";
               break;
            case ResearchUtils.PROJECT_FILTER_CAN_COMPLETE:
               _loc2_ = "$RESEARCH_FILTER_CAN_COMPLETE";
               break;
            case ResearchUtils.RESEARCH_FILTER_CAN_CONTRIBUTE:
               _loc2_ = "$RESEARCH_FILTER_CAN_CONTRIBUTE";
               break;
            case ResearchUtils.PROJECT_FILTER_CAN_PROGRESS:
               _loc2_ = "$RESEARCH_FILTER_CAN_PROGRESS";
               break;
            case ResearchUtils.PROJECT_FILTER_COMPLETED_ONLY:
               _loc2_ = "$RESEARCH_FILTER_COMPLETED_ONLY";
         }
         return _loc2_;
      }
      
      private function InitMiniList(param1:Array) : void
      {
         var _loc5_:Object = null;
         var _loc2_:ButtonFactory = new ButtonFactory();
         var _loc3_:uint = this.MiniCategoryList_mc.GetSelectedID();
         this.MiniCategoryList_mc.ClearButtons();
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            ButtonFactory.AddToButtonBar("MiniCategoryListButton",new MiniCategoryButtonData(_loc4_,new UserEventData("click",this.onMiniCategoryClicked),new MiniCategoryData(_loc5_.sIconName,_loc5_.uID,_loc5_.bHasNew)),this.MiniCategoryList_mc);
            _loc4_++;
         }
         this.MiniCategoryList_mc.SetSelectedCategory(_loc3_);
         this.MiniCategoryList_mc.RefreshButtons();
      }
      
      private function onMiniCategoryClicked(param1:int) : void
      {
         GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
         this.MiniCategoryList_mc.SetSelectedIndex(param1);
      }
      
      private function OnCategoriesDataUpdate(param1:FromClientDataEvent) : void
      {
         this.InitMiniList(param1.data.aCategories);
         this.MainLanding_mc.UpdateCategoriesList(param1.data.aCategories);
      }
      
      private function OnProjectsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.CategoryPage_mc.UpdateProjectsList(param1.data.aProjects);
      }
      
      private function OnProjectDetailsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.CategoryPage_mc.UpdateProjectDetails(param1.data);
         this.ProjectPage_mc.PopulateProjectPage(param1.data);
      }
      
      private function OnPopupDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = null;
         if(this.currentState == ResearchUtils.PROJECT_PAGE_STATE)
         {
            _loc2_ = null;
            if(param1.data.aOverflowedItems.length > 0)
            {
               _loc2_ = {
                  "uPopupState":ResearchUtils.SUDDEN_DEV_STATE,
                  "suddenDevData":param1.data
               };
               this.PopupQueue.push(_loc2_);
               this.ShowNextPopup();
            }
            if(param1.data.sName != "")
            {
               _loc2_ = {
                  "uPopupState":ResearchUtils.COMPLETE_POPUP_STATE,
                  "sName":param1.data.sName,
                  "aUnlockedProjects":param1.data.aUnlockedProjects
               };
               this.PopupQueue.push(_loc2_);
               this.ShowNextPopup();
            }
         }
      }
      
      private function ShowNextPopup() : void
      {
         var _loc1_:Object = null;
         if(this.ActivePopup == null)
         {
            _loc1_ = this.PopupQueue.shift();
            if(_loc1_ != null)
            {
               switch(_loc1_.uPopupState)
               {
                  case ResearchUtils.SUDDEN_DEV_STATE:
                     this.SuddenEvent_mc.UpdateData(_loc1_.suddenDevData);
                     this.TransitionToState(this.suddenDevelopmentState);
                     break;
                  case ResearchUtils.COMPLETE_POPUP_STATE:
                     this.ProjectComplete_mc.UpdateData(_loc1_);
                     this.TransitionToState(this.completePopupState);
               }
            }
         }
      }
      
      private function CloseCurrentPopup() : void
      {
         this._stateHandler(this.CANCEL_EVENT);
         this.ShowNextPopup();
      }
      
      private function ShowCategoryPage(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ResearchMenu_CategorySelected",{"categoryID":param1.params.categoryID}));
         this.MiniCategoryList_mc.SetSelectedCategory(param1.params.categoryID);
         this._stateHandler(this.SHOW_NEXT_COMPONENT);
      }
      
      private function ShowProjectPage() : void
      {
         this._stateHandler(this.SHOW_NEXT_COMPONENT);
      }
      
      private function ShowVolumePopup(param1:CustomEvent) : void
      {
         this.VolumeSelection_mc.UpdatePopupData(param1.params);
         this._stateHandler(this.SHOW_NEXT_COMPONENT);
      }
      
      private function ConfirmedAddingMaterial(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ResearchMenu_AddMaterial",{
            "amountToAdd":param1.params.inputAmount,
            "materialToAdd":param1.params.materialFormID
         }));
         this._stateHandler(this.ACCEPT_EVENT);
      }
      
      private function ChangeCategory(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ResearchMenu_CategorySelected",{"categoryID":param1.params.categoryID}));
         this.MainLanding_mc.SetSelectedCategory(param1.params.categoryID);
         this.UpdateMenuHeader();
         this._stateHandler(this.CATEGORY_CHANGED_EVENT);
      }
      
      private function LoadScreenAnimComplete() : void
      {
         this.TransitionToState(this.mainLandingState);
      }
      
      private function CloseAnimComplete() : void
      {
         BSUIDataManager.dispatchEvent(new Event("ResearchMenu_ExitMenu"));
      }
      
      private function PlayClosingAnimations() : void
      {
         if(!this._exitingMenu)
         {
            this._exitingMenu = true;
            this.UpdateButtonHints();
            this.MainLanding_mc.Close();
            this.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
            GlobalFunc.PlayMenuSound(ResearchUtils.MENU_CLOSE_SOUND);
         }
      }
      
      private function OnTrackButton() : void
      {
         this._stateHandler(this.TRACK_EVENT);
      }
      
      private function OnFilterButton() : void
      {
         this._stateHandler(this.FILTER_EVENT);
      }
      
      private function OnSortButton() : void
      {
         this._stateHandler(this.SORT_EVENT);
      }
      
      private function OnPrevCatButton() : void
      {
         this._stateHandler(this.PREV_CATEGORY);
      }
      
      private function OnNextCatButton() : void
      {
         this._stateHandler(this.NEXT_CATEGORY);
      }
      
      private function OnSelectButton() : void
      {
         this._stateHandler(this.ACCEPT_EVENT);
      }
      
      private function OnBackButton() : void
      {
         this._stateHandler(this.CANCEL_EVENT);
      }
      
      private function OnExitButtonHeld() : void
      {
         this._stateHandler(this.EXIT_EVENT);
      }
      
      private function TransitionToState(param1:Function) : void
      {
         this._stateHandler(this.EXIT_STATE);
         this._stateHandler = param1;
         this._stateHandler(this.ENTER_STATE);
      }
      
      private function loadingState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.LOADING_STATE;
               break;
            case this.EXIT_STATE:
               this.LoadingScreen_mc.visible = false;
               this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
         }
      }
      
      private function mainLandingState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.MAIN_LANDING_STATE;
               this.MainLanding_mc.Open();
               stage.focus = this.MainLanding_mc.CategoriesList_mc;
               break;
            case this.ACCEPT_EVENT:
               this.MainLanding_mc.CategoryPressed();
               break;
            case this.SHOW_NEXT_COMPONENT:
               this.MainLanding_mc.TransitionToCategoryPage();
               this.MiniCategoryList_mc.Open();
               this.CategoryPage_mc.ProjectList_mc.selectedIndex = 0;
               this.TransitionToState(this.categoryPageState);
               break;
            case this.CANCEL_EVENT:
               this.PlayClosingAnimations();
               break;
            case this.EXIT_STATE:
               stage.focus = null;
         }
      }
      
      private function categoryPageState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.CATEGORY_PAGE_STATE;
               this.CategoryPage_mc.Open();
               stage.focus = this.CategoryPage_mc.ProjectList_mc;
               this.Background_mc.visible = false;
               break;
            case this.ACCEPT_EVENT:
               this.CategoryPage_mc.ProjectPressed();
               break;
            case this.SHOW_NEXT_COMPONENT:
               this.TransitionToState(this.projectPageState);
               this.ProjectPage_mc.Open();
               break;
            case this.PREV_CATEGORY:
               GlobalFunc.PlayMenuSound(ResearchUtils.NEXT_PREV_SOUND);
               this.MiniCategoryList_mc.SetSelectedIndex(this.MiniCategoryList_mc.GetSelectedIndex() - 1);
               break;
            case this.NEXT_CATEGORY:
               GlobalFunc.PlayMenuSound(ResearchUtils.NEXT_PREV_SOUND);
               this.MiniCategoryList_mc.SetSelectedIndex(this.MiniCategoryList_mc.GetSelectedIndex() + 1);
               break;
            case this.CATEGORY_CHANGED_EVENT:
               this.CategoryPage_mc.ProjectList_mc.selectedIndex = 0;
               break;
            case this.FILTER_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.FILTER_SOUND);
               this.CategoryPage_mc.NextFilterType();
               this.UpdateButtonHints();
               break;
            case this.SORT_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.SORT_SOUND);
               this.CategoryPage_mc.NextSortType();
               this.UpdateButtonHints();
               break;
            case this.TRACK_EVENT:
               this.CategoryPage_mc.ToggleTracking();
               break;
            case this.CANCEL_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.CANCEL_SOUND);
               this.MiniCategoryList_mc.Close();
               this.TransitionToState(this.mainLandingState);
               break;
            case this.EXIT_EVENT:
               this.MiniCategoryList_mc.Close();
               this.CategoryPage_mc.Close();
               this.Background_mc.visible = true;
               stage.focus = null;
               this.PlayClosingAnimations();
               break;
            case this.EXIT_STATE:
               this.CategoryPage_mc.Close();
               this.Background_mc.visible = true;
               stage.focus = null;
         }
      }
      
      private function projectPageState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.PROJECT_PAGE_STATE;
               stage.focus = this.ProjectPage_mc.MaterialsList_mc;
               break;
            case this.ACCEPT_EVENT:
               this.ProjectPage_mc.AddToMaterial();
               break;
            case this.SHOW_NEXT_COMPONENT:
               this.TransitionToState(this.volumeSelectionState);
               break;
            case this.PREV_CATEGORY:
               GlobalFunc.PlayMenuSound(ResearchUtils.NEXT_PREV_SOUND);
               this.MiniCategoryList_mc.SetSelectedIndex(this.MiniCategoryList_mc.GetSelectedIndex() - 1);
               break;
            case this.NEXT_CATEGORY:
               GlobalFunc.PlayMenuSound(ResearchUtils.NEXT_PREV_SOUND);
               this.MiniCategoryList_mc.SetSelectedIndex(this.MiniCategoryList_mc.GetSelectedIndex() + 1);
               break;
            case this.CATEGORY_CHANGED_EVENT:
               this.CategoryPage_mc.ProjectList_mc.selectedIndex = 0;
               this.ProjectPage_mc.Close();
               this.TransitionToState(this.categoryPageState);
               break;
            case this.SORT_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.SORT_SOUND);
               this.ProjectPage_mc.NextSortType();
               this.UpdateButtonHints();
               break;
            case this.TRACK_EVENT:
               this.ProjectPage_mc.ToggleTracking();
               break;
            case this.CANCEL_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.CANCEL_SOUND);
               this.ProjectPage_mc.Close();
               this.TransitionToState(this.categoryPageState);
               break;
            case this.EXIT_EVENT:
               this.MiniCategoryList_mc.Close();
               this.ProjectPage_mc.Close();
               stage.focus = null;
               this.PlayClosingAnimations();
               break;
            case this.EXIT_STATE:
               stage.focus = null;
         }
      }
      
      private function volumeSelectionState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.MATERIAL_SELECTION_STATE;
               this.ActivePopup = this.VolumeSelection_mc;
               stage.focus = this.VolumeSelection_mc.Slider_mc;
               this.ActivePopup.Open();
               break;
            case this.ACCEPT_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
               this.TransitionToState(this.projectPageState);
               break;
            case this.CANCEL_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.CANCEL_SOUND);
               this.TransitionToState(this.projectPageState);
               break;
            case this.EXIT_STATE:
               this.ActivePopup.Close();
               this.ActivePopup = null;
               stage.focus = null;
         }
      }
      
      private function suddenDevelopmentState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.SUDDEN_DEV_STATE;
               this.ActivePopup = this.SuddenEvent_mc;
               this.ActivePopup.Open();
               break;
            case this.CANCEL_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
               this.TransitionToState(this.projectPageState);
               break;
            case this.EXIT_STATE:
               this.ActivePopup.Close();
               this.ActivePopup = null;
         }
      }
      
      private function completePopupState(param1:int) : void
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.currentState = ResearchUtils.COMPLETE_POPUP_STATE;
               this.ActivePopup = this.ProjectComplete_mc;
               this.ActivePopup.Open();
               break;
            case this.CANCEL_EVENT:
               GlobalFunc.PlayMenuSound(ResearchUtils.OK_SOUND);
               this.TransitionToState(this.projectPageState);
               break;
            case this.EXIT_STATE:
               this.ActivePopup.Close();
               this.ActivePopup = null;
         }
      }
   }
}
