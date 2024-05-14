package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.TabButtonBar;
   import Shared.Components.ButtonControls.ButtonData.TabButtonBarEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class PhotoModePanelContainer extends MovieClip
   {
      
      public static const CAMERA_CATEGORY:int = EnumHelper.GetEnum(0);
      
      public static const PLAYER_CATEGORY:int = EnumHelper.GetEnum();
      
      public static const CINEMATIC_CATEGORY:int = EnumHelper.GetEnum();
      
      public static const FILTERS_CATEGORY:int = EnumHelper.GetEnum();
      
      public static const OVERLAYS_CATEGORY:int = EnumHelper.GetEnum();
      
      public static const TOTAL_CATEGORIES:int = EnumHelper.GetEnum();
      
      public static const SETTINGS_MODE:int = EnumHelper.GetEnum(0);
      
      public static const REFINE_MODE:int = EnumHelper.GetEnum();
      
      public static const ACTIVE_LIST_CHANGED:String = "PhotoMode_ActiveListChanged";
      
      public static const REFRESH_BUTTONS:String = "PhotoMode_RefreshButtons";
       
      
      public var CategoriesBar_mc:TabButtonBar;
      
      public var SettingsList_mc:PhotoModeSettingsList;
      
      public var RefineSettingsList_mc:PhotoModeSettingsList;
      
      private var CategoryTabsA:Array;
      
      private var CategoryRequested:Array;
      
      private var ActiveList:MovieClip = null;
      
      private var _categoriesInitialized:Boolean = false;
      
      private var _currentMode:int = -1;
      
      private var _currentRefinementFilter:uint = 0;
      
      public function PhotoModePanelContainer()
      {
         this.CategoryTabsA = new Array();
         this.CategoryRequested = new Array();
         super();
         var _loc1_:uint = uint(CAMERA_CATEGORY);
         while(_loc1_ < TOTAL_CATEGORIES)
         {
            this.CategoryRequested.push(false);
            _loc1_++;
         }
         this.CategoriesBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_SPACE_EVENLY);
         var _loc2_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc2_.VerticalSpacing = 3;
         _loc2_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         _loc2_.EntryClassName = "PhotoModeSettingEntry";
         this.SettingsList_mc.Configure(_loc2_);
         this.RefineSettingsList_mc.Configure(_loc2_);
         this.currentMode = SETTINGS_MODE;
         this.SettingsList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSettingsSelectionChange);
         this.SettingsList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.OnSettingsEntryPress);
         this.RefineSettingsList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.OnRefineEntryPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      public function get currentCategoryID() : uint
      {
         return this.CategoriesBar_mc.GetSelected().Payload.CategoryID;
      }
      
      public function get currentMode() : int
      {
         return this._currentMode;
      }
      
      public function get activeList() : MovieClip
      {
         return this.ActiveList;
      }
      
      public function get canRefineSetting() : Boolean
      {
         return this.SettingsList_mc.selectedEntry != null && Boolean(this.SettingsList_mc.selectedEntry.bHasRefineSettings) && !this.SettingsList_mc.selectedEntry.bDisabled;
      }
      
      public function get refinementFilter() : uint
      {
         return this._currentRefinementFilter;
      }
      
      public function set currentMode(param1:int) : void
      {
         if(this._currentMode != param1)
         {
            this._currentMode = param1;
            switch(this._currentMode)
            {
               case SETTINGS_MODE:
                  this.ActiveList = this.SettingsList_mc;
                  break;
               case REFINE_MODE:
                  this.ActiveList = this.RefineSettingsList_mc;
                  break;
               default:
                  this.ActiveList = null;
            }
            dispatchEvent(new Event(ACTIVE_LIST_CHANGED,true,true));
            this.UpdateComponentVisibility();
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.CategoriesBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function UpdateCategories(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         if(!this._categoriesInitialized)
         {
            this.CategoryTabsA = new Array();
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               this.CategoryTabsA.push(new PhotoModePanelTabData(_loc3_.sName,_loc3_.uID));
               _loc2_++;
            }
            this.CategoriesBar_mc.addEventListener(TabButtonBarEvent.TAB_CHANGED,this.OnCategoryChanged);
            this.CategoriesBar_mc.SetTabs("PanelTabButton",this.CategoryTabsA);
            this._categoriesInitialized = param1.length > 0;
         }
      }
      
      public function UpdateSettings(param1:Array) : void
      {
         this.SettingsList_mc.removeEventListener(PhotoModeSettingEntry.VALUE_CHANGE,this.OnSettingValueChange);
         this.SettingsList_mc.InitializeEntries(param1);
         if(this.SettingsList_mc.selectedIndex < 0)
         {
            this.SettingsList_mc.selectedIndex = 0;
         }
         this.SettingsList_mc.addEventListener(PhotoModeSettingEntry.VALUE_CHANGE,this.OnSettingValueChange);
      }
      
      public function UpdateRefinementData(param1:uint, param2:Array) : void
      {
         var aFilter:uint = param1;
         var aSettings:Array = param2;
         this.RefineSettingsList_mc.removeEventListener(PhotoModeSettingEntry.VALUE_CHANGE,this.OnRefineValueChange);
         this._currentRefinementFilter = aFilter;
         this.RefineSettingsList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return param1.uCategory != undefined && (param1.uCategory == _currentRefinementFilter || param1.uCategory == 0);
         });
         this.RefineSettingsList_mc.InitializeEntries(aSettings);
         if(this.RefineSettingsList_mc.selectedIndex < 0)
         {
            this.RefineSettingsList_mc.selectedIndex = 0;
         }
         this.RefineSettingsList_mc.addEventListener(PhotoModeSettingEntry.VALUE_CHANGE,this.OnRefineValueChange);
      }
      
      private function UpdateComponentVisibility() : void
      {
         var _loc1_:* = this.currentMode == SETTINGS_MODE;
         var _loc2_:* = this.currentMode == REFINE_MODE;
         this.SettingsList_mc.visible = _loc1_;
         this.RefineSettingsList_mc.visible = _loc2_;
         this.SettingsList_mc.disableInput = !_loc1_;
         this.SettingsList_mc.disableSelection = !_loc1_;
         this.RefineSettingsList_mc.disableInput = !_loc2_;
         this.RefineSettingsList_mc.disableSelection = !_loc2_;
      }
      
      public function OnRefineButton() : void
      {
         if(this.currentMode == SETTINGS_MODE && this.canRefineSetting)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_RefineSetting",{"uSettingID":this.SettingsList_mc.selectedEntry.uID}));
            this.currentMode = REFINE_MODE;
         }
         else if(this.currentMode == REFINE_MODE)
         {
            this.currentMode = SETTINGS_MODE;
         }
      }
      
      private function OnCategoryChanged(param1:TabButtonBarEvent) : void
      {
         var aEvent:TabButtonBarEvent = param1;
         if(this.CategoriesBar_mc.GetSelected() != null)
         {
            GlobalFunc.PlayMenuSound("UIPhotomodeTab");
            this.SettingsList_mc.SetFilterComparitor(function(param1:Object):Boolean
            {
               return param1.uCategory != undefined && param1.uCategory == currentCategoryID;
            });
            if(!this.CategoryRequested[this.currentCategoryID])
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_InitializeCategory",{"uCategoryID":this.currentCategoryID}));
               this.CategoryRequested[this.currentCategoryID] = true;
            }
            else
            {
               this.SettingsList_mc.selectedIndex = 0;
            }
            if(this.currentMode == REFINE_MODE)
            {
               this.currentMode = SETTINGS_MODE;
            }
         }
      }
      
      private function OnSettingsSelectionChange() : void
      {
         if(this.currentMode == SETTINGS_MODE)
         {
            dispatchEvent(new Event(REFRESH_BUTTONS,true,true));
         }
      }
      
      private function OnSettingsEntryPress(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         this.SettingsList_mc.OnEntryPressed();
      }
      
      private function OnSettingValueChange(param1:CustomEvent) : void
      {
         if(param1.params.type == PhotoModeSettingEntry.PMST_SLIDER)
         {
            GlobalFunc.PlayMenuSound("UIPhotomodeSlider");
            BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_SliderChanged",{
               "fValue":param1.params.value,
               "uSettingID":param1.params.id,
               "bRefinement":false
            }));
         }
         else if(param1.params.type == PhotoModeSettingEntry.PMST_STEPPER)
         {
            GlobalFunc.PlayMenuSound("UIPhotomodePrevNext");
            BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_StepperChanged",{
               "uIndex":param1.params.value,
               "uSettingID":param1.params.id,
               "bRefinement":false
            }));
         }
      }
      
      private function OnRefineEntryPress(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         this.RefineSettingsList_mc.OnEntryPressed();
      }
      
      private function OnRefineValueChange(param1:CustomEvent) : void
      {
         if(param1.params.type == PhotoModeSettingEntry.PMST_SLIDER)
         {
            GlobalFunc.PlayMenuSound("UIPhotomodeSlider");
            BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_SliderChanged",{
               "fValue":param1.params.value,
               "uSettingID":param1.params.id,
               "bRefinement":true
            }));
         }
         else if(param1.params.type == PhotoModeSettingEntry.PMST_STEPPER)
         {
            GlobalFunc.PlayMenuSound("UIPhotomodePrevNext");
            BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_StepperChanged",{
               "uIndex":param1.params.value,
               "uSettingID":param1.params.id,
               "bRefinement":true
            }));
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound("UIPhotomodeFocus");
      }
   }
}
