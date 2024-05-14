package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.PipButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.TabButtonBar;
   import Shared.Components.ButtonControls.ButtonData.PipButtonData;
   import Shared.Components.ButtonControls.ButtonData.TabButtonBarEvent;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class BuildPopupContainer extends MovieClip
   {
       
      
      public var NavigationBar_mc:TabButtonBar;
      
      public var PipBar_mc:PipButtonBar;
      
      public var BuildList_mc:BSScrollingContainer;
      
      private var NavigationTabsA:Array;
      
      private var _openStarted:Boolean = false;
      
      private var _dataReady:Boolean = false;
      
      private const LIST_SPACING:Number = 3;
      
      private const PIP_SPACING:Number = 5;
      
      public function BuildPopupContainer()
      {
         this.NavigationTabsA = new Array();
         super();
         this.NavigationBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_PIXEL_PERFECT);
         this.PipBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,this.PIP_SPACING);
         this.PipBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_SCALE_TO_FIT);
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = this.LIST_SPACING;
         _loc1_.EntryClassName = "BuildObjectList_Entry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.BuildList_mc.Configure(_loc1_);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         BSUIDataManager.Subscribe("WorkshopCategoryBarData",this.OnCategoryBarDataUpdate);
      }
      
      public function get currentTabIndex() : int
      {
         return this.NavigationBar_mc.GetSelectedIndex();
      }
      
      public function get currentTabID() : uint
      {
         return this.NavigationBar_mc.GetSelected().Payload.CategoryID;
      }
      
      public function get currentItemHasVariants() : Boolean
      {
         return this.BuildList_mc.selectedEntry != null && WorkshopUtils.GetHasVariants(this.BuildList_mc.selectedEntry);
      }
      
      public function get currentItemBuildable() : Boolean
      {
         return this.BuildList_mc.selectedEntry != null && WorkshopUtils.GetBuildable(this.BuildList_mc.selectedEntry);
      }
      
      public function set show(param1:Boolean) : void
      {
         this.visible = param1;
         this.Open();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.NavigationBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function Open() : void
      {
         if(!this._openStarted && this._dataReady && this.visible)
         {
            this._openStarted = true;
            this.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
         }
      }
      
      public function Close(param1:Boolean) : void
      {
         if(param1)
         {
            this.gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
         }
         else
         {
            this.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
         }
      }
      
      public function InitPipBar(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         _loc2_ = 0;
         while(_loc2_ < this.NavigationTabsA.length)
         {
            _loc3_ = this.NavigationTabsA[_loc2_];
            ButtonFactory.AddToButtonBar("PipTab",new PipButtonData(_loc2_,new UserEventData("click",this.onPipButtonClicked)),this.PipBar_mc);
            _loc2_++;
         }
         this.PipBar_mc.SetSelectedIndex(param1);
         this.PipBar_mc.RefreshButtons();
      }
      
      private function onNavigationCategoryChanged(param1:TabButtonBarEvent) : void
      {
         if(this.NavigationBar_mc.GetSelected() != null)
         {
            GlobalFunc.PlayMenuSound("UIOutpostModeMenuCategory");
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_SelectedCategory",{"formID":this.currentTabID}));
         }
         this.PipBar_mc.SetSelectedIndex(this.currentTabIndex);
      }
      
      private function onPipButtonClicked(param1:int) : void
      {
         this.NavigationBar_mc.SetSelectedIndex(param1);
         this.PipBar_mc.SetSelectedIndex(param1);
      }
      
      private function onListSelectionChange() : void
      {
         var _loc1_:* = this.BuildList_mc.selectedEntry;
         if(_loc1_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_SelectedGridObject",{"formID":WorkshopUtils.GetVariantId(_loc1_)}));
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound("UIOutpostModeMenuGridFocus");
      }
      
      private function OnCategoryBarDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc4_:Object = null;
         this._dataReady = param1.data.uCurrentCategoryID != 0;
         this.NavigationBar_mc.removeEventListener(TabButtonBarEvent.TAB_CHANGED,this.onNavigationCategoryChanged);
         this.NavigationTabsA = new Array();
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.data.aCategories.length)
         {
            _loc4_ = param1.data.aCategories[_loc3_];
            if(param1.data.uCurrentCategoryID == _loc4_.uID)
            {
               _loc2_ = _loc3_;
            }
            this.NavigationTabsA.push(new WorkshopNavigationTabData(_loc4_.sName,_loc4_.uID,_loc4_.bSelectable));
            _loc3_++;
         }
         this.NavigationBar_mc.SetTabs("NavigationTab",this.NavigationTabsA,ButtonBar.JUSTIFY_CENTER,_loc2_,WorkshopUtils.WORKSHOP_INPUT_CONTEXT + "LShoulder",WorkshopUtils.WORKSHOP_INPUT_CONTEXT + "RShoulder",0);
         this.NavigationBar_mc.addEventListener(TabButtonBarEvent.TAB_CHANGED,this.onNavigationCategoryChanged);
         this.InitPipBar(_loc2_);
         this.Open();
      }
      
      public function UpdateCategoryInfo(param1:Object) : void
      {
         var _loc3_:Object = null;
         removeEventListener(ScrollingEvent.SELECTION_CHANGE,this.onListSelectionChange);
         this.BuildList_mc.InitializeEntries(param1.aPreviewIcons);
         var _loc2_:uint = 0;
         for each(_loc3_ in param1.aPreviewIcons)
         {
            if(_loc3_.uID == param1.uCurrentIconID)
            {
               break;
            }
            _loc2_++;
         }
         if(param1.aPreviewIcons.length > 0)
         {
            this.BuildList_mc.selectedIndex = _loc2_;
         }
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onListSelectionChange);
      }
   }
}
