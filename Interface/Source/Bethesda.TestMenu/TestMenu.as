package
{
   import Shared.AS3.BSGridList;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.BSScrollingDeltaSet;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.TestMenu_DeprecatedListStyle;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.Components.ButtonControls.Buttons.ReleaseHoldComboButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class TestMenu extends IMenu
   {
      
      public static const TEST_TYPE_SCREEN:int = EnumHelper.GetEnum(0);
      
      public static const LIST_TYPE_SCREEN:int = EnumHelper.GetEnum();
      
      public static const DATA_SCREEN:int = EnumHelper.GetEnum();
      
      public static const LIST_TEST:int = EnumHelper.GetEnum(0);
      
      public static const BUTTON_TEST:int = EnumHelper.GetEnum();
      
      public static const RESOURCE_TEST:int = EnumHelper.GetEnum();
      
      public static const IMAGE_TEST:int = EnumHelper.GetEnum();
      
      public static const DELTA_SET_INDEX:int = EnumHelper.GetEnum(0);
      
      public static const SCROLLING_CONTAINER_INDEX:int = EnumHelper.GetEnum();
      
      public static const GRID_LIST_INDEX:int = EnumHelper.GetEnum();
      
      public static const DEPRECATED_SCROLLING_LIST_INDEX:int = EnumHelper.GetEnum();
      
      public static const SA_PUSH_BACK:int = EnumHelper.GetEnum(0);
      
      public static const SA_INSERT_AT:int = EnumHelper.GetEnum();
      
      public static const SA_REMOVE:int = EnumHelper.GetEnum();
      
      public static const SA_REMOVE_MULTIPLE:int = EnumHelper.GetEnum();
      
      public static const SA_SORTED_INSERT:int = EnumHelper.GetEnum();
      
      public static const SA_RESIZE:int = EnumHelper.GetEnum();
      
      public static const SA_CLEAR:int = EnumHelper.GetEnum();
      
      public static const SA_SORT:int = EnumHelper.GetEnum();
      
      public static const AF_NONE:int = 0;
      
      public static const AF_MAJOR_ARCANA:int = 1 << EnumHelper.GetEnum(0);
      
      public static const AF_SPECIAL:int = 1 << EnumHelper.GetEnum();
      
      public static const AF_ASTROLOGICAL:int = 1 << EnumHelper.GetEnum();
      
      public static const AF_COUNT:int = EnumHelper.GetEnum();
      
      public static const AF_ALL:int = (1 << AF_COUNT) - 1;
      
      public static const ST_NONE:int = 0;
      
      public static const ST_NAME:int = 1 << EnumHelper.GetEnum(0);
      
      public static const ST_ID:int = 1 << EnumHelper.GetEnum();
       
      
      public var OptionsList_mc:BSScrollingContainer;
      
      public var ImagesTest_mc:TestImages;
      
      public var ResourcesTest_mc:TestResourceIcons;
      
      public var ButtonTest_mc:MovieClip;
      
      public var ListTest_mc:MovieClip;
      
      public var ExitButtonBar_mc:ButtonBar;
      
      private var MyButtonManager:ButtonManager;
      
      private const GREEN_TEST_COLOR:uint = 261293;
      
      private const TEAL_TEST_COLOR:uint = 4905207;
      
      private const GRID_SPACING:Number = 3;
      
      private const MAX_COLUMNS:Number = 5;
      
      private const MAX_ROWS:Number = 4;
      
      private const GRID_REPEAT_INTERVAL_MS:int = 100;
      
      private var _currentFilter:int = -1;
      
      private var _currentScreenState:int = -1;
      
      private var _currentTestType:int = -1;
      
      private var _currentListType:int = -1;
      
      private var _currentSortType:int = -1;
      
      private var _initButtonTest:Boolean = false;
      
      private var _initListTest:Boolean = false;
      
      private var NextButton:ButtonBase = null;
      
      private var PushBackButton:ButtonBase = null;
      
      private var InsertButton:ButtonBase = null;
      
      private var AlignButton:ButtonBase = null;
      
      private var InsertAtData:ButtonBaseData;
      
      private var SortedInsertData:ButtonBaseData;
      
      public function TestMenu()
      {
         this.MyButtonManager = new ButtonManager();
         this.InsertAtData = new ButtonBaseData("Insert At",new UserEventData("XButton",function():void
         {
            this.DoAction(SA_INSERT_AT);
         }));
         this.SortedInsertData = new ButtonBaseData("Sorted Insert",new UserEventData("XButton",function():void
         {
            this.DoAction(SA_SORTED_INSERT);
         }));
         super();
         this._currentScreenState = TEST_TYPE_SCREEN;
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 2;
         _loc1_.EntryClassName = "TestOptionList_Entry";
         this.OptionsList_mc.Configure(_loc1_);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.AcceptScreenAction);
      }
      
      protected function get ListButtonBar_mc() : ButtonBar
      {
         return this.ListTest_mc.ButtonBar_mc;
      }
      
      protected function get DeprecatedList_mc() : BSScrollingList
      {
         return this.ListTest_mc.DeprecatedList_mc;
      }
      
      protected function get GridList_mc() : BSGridList
      {
         return this.ListTest_mc.GridList_mc;
      }
      
      protected function get ScrollList_mc() : BSScrollingContainer
      {
         return this.ListTest_mc.ScrollList_mc;
      }
      
      protected function get DeltaList_mc() : BSScrollingDeltaSet
      {
         return this.ListTest_mc.DeltaList_mc;
      }
      
      protected function get MiscInfo_mc() : MovieClip
      {
         return this.ListTest_mc.MiscInfo_mc;
      }
      
      protected function get CurrentFilter_tf() : TextField
      {
         return this.MiscInfo_mc.CurrentFilter_mc.text_tf;
      }
      
      protected function get CurrentSortType_tf() : TextField
      {
         return this.MiscInfo_mc.CurrentSortType_mc.text_tf;
      }
      
      protected function get ButtonBarTest_mc() : ButtonBar
      {
         return this.ButtonTest_mc.ButtonBar_mc;
      }
      
      protected function get ReleaseHoldComboButton_mc() : ReleaseHoldComboButton
      {
         return this.ButtonTest_mc.ReleaseHoldComboButton_mc;
      }
      
      protected function get BasicButton_mc() : ButtonBase
      {
         return this.ButtonTest_mc.BasicButton_mc;
      }
      
      public function get currentSortType() : int
      {
         return this._currentSortType;
      }
      
      public function set currentSortType(param1:int) : void
      {
         if(this._currentSortType != param1)
         {
            this._currentSortType = param1;
            GlobalFunc.SetText(this.CurrentSortType_tf,"Current Sort Type: " + this.SortTypeAsString(this._currentSortType));
            this.UpdateListButtons();
         }
      }
      
      public function get currentFilter() : int
      {
         return this._currentFilter;
      }
      
      public function set currentFilter(param1:int) : void
      {
         var aFilter:int = param1;
         this._currentFilter = aFilter;
         if(this._currentListType == DELTA_SET_INDEX)
         {
            this.DeltaList_mc.SetFilterComparitor(function(param1:Object):Boolean
            {
               return param1.filterFlag != null && (param1.filterFlag & _currentFilter) != 0;
            });
            if(this.DeltaList_mc.selectedIndex == -1 && this.DeltaList_mc.entryCount > 0)
            {
               this.DeltaList_mc.selectedIndex = 0;
            }
            else if(this.DeltaList_mc.entryCount == 0)
            {
               this.DeltaList_mc.selectedIndex = -1;
            }
         }
         else if(this._currentListType == SCROLLING_CONTAINER_INDEX)
         {
            this.ScrollList_mc.SetFilterComparitor(function(param1:Object):Boolean
            {
               return param1.filterFlag != null && (param1.filterFlag & _currentFilter) != 0;
            });
            if(this.ScrollList_mc.selectedIndex == -1 && this.ScrollList_mc.entryCount > 0)
            {
               this.ScrollList_mc.selectedIndex = 0;
            }
            else if(this.ScrollList_mc.entryCount == 0)
            {
               this.ScrollList_mc.selectedIndex = -1;
            }
         }
         else if(this._currentListType == DEPRECATED_SCROLLING_LIST_INDEX)
         {
            this.DeprecatedList_mc.filterer.itemFilter = this._currentFilter;
         }
         GlobalFunc.SetText(this.CurrentFilter_tf,"Current Filter: " + this.FilterAsString(this._currentFilter));
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.ExitButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
         this.NextButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Next",new UserEventData("Accept",this.AcceptScreenAction)),this.ExitButtonBar_mc) as ButtonBase;
         this.ExitButtonBar_mc.AddButtonWithData(this.ExitButtonBar_mc.ExitButton_mc,new ReleaseHoldComboButtonData("Back","Get Out",[new UserEventData("Cancel",this.PreviousScreen),new UserEventData("",this.ExitMenu)]));
         this.ExitButtonBar_mc.RefreshButtons();
         this.InitializeCurrentScreen();
         BSUIDataManager.Subscribe("TestMenuData",this.OnTestMenuDataUpdate);
         BSUIDataManager.Subscribe("TestFlushData",this.OnTestFlushDataUpdate);
      }
      
      public function OnTestRuntimeShared() : *
      {
         trace("Successful test of runtime shared buttons");
      }
      
      private function UpdateExitButtons() : void
      {
         this.NextButton.Visible = this._currentScreenState == TEST_TYPE_SCREEN || this._currentScreenState == LIST_TYPE_SCREEN;
         this.NextButton.Enabled = this.NextButton.Visible;
         this.ExitButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateComponentsVisibility() : void
      {
         var _loc1_:* = this._currentScreenState == TEST_TYPE_SCREEN;
         var _loc2_:* = this._currentScreenState == LIST_TYPE_SCREEN;
         var _loc3_:* = this._currentScreenState == DATA_SCREEN;
         var _loc4_:* = this._currentTestType == LIST_TEST;
         var _loc5_:* = this._currentTestType == BUTTON_TEST;
         var _loc6_:* = this._currentTestType == RESOURCE_TEST;
         var _loc7_:* = this._currentTestType == IMAGE_TEST;
         var _loc8_:* = this._currentListType == DELTA_SET_INDEX;
         var _loc9_:* = this._currentListType == SCROLLING_CONTAINER_INDEX;
         var _loc10_:* = this._currentListType == GRID_LIST_INDEX;
         var _loc11_:* = this._currentListType == DEPRECATED_SCROLLING_LIST_INDEX;
         stage.focus = null;
         this.OptionsList_mc.visible = _loc1_ || _loc2_;
         this.DeltaList_mc.visible = _loc3_ && _loc4_ && _loc8_;
         this.ScrollList_mc.visible = _loc3_ && _loc4_ && _loc9_;
         this.GridList_mc.visible = _loc3_ && _loc4_ && _loc10_;
         this.DeprecatedList_mc.visible = _loc3_ && _loc4_ && _loc11_;
         this.MiscInfo_mc.visible = _loc3_ && _loc4_ && !_loc10_;
         this.ListButtonBar_mc.visible = _loc3_ && _loc4_;
         this.ButtonTest_mc.visible = _loc3_ && _loc5_;
         this.ResourcesTest_mc.visible = _loc3_ && _loc6_;
         this.ImagesTest_mc.visible = _loc3_ && _loc7_;
         if(this.OptionsList_mc.visible)
         {
            stage.focus = this.OptionsList_mc;
         }
         else if(this.DeltaList_mc.visible)
         {
            stage.focus = this.DeltaList_mc;
         }
         else if(this.ScrollList_mc.visible)
         {
            stage.focus = this.ScrollList_mc;
         }
         else if(this.GridList_mc.visible)
         {
            stage.focus = this.GridList_mc;
         }
         else if(this.DeprecatedList_mc.visible)
         {
            stage.focus = this.DeprecatedList_mc;
         }
         else if(this.ResourcesTest_mc.visible)
         {
            stage.focus = this.ResourcesTest_mc.ResourcesList_mc;
         }
      }
      
      private function InitializeCurrentScreen() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         if(this._currentScreenState == TEST_TYPE_SCREEN)
         {
            _loc1_ = new Array();
            _loc1_.push({"name":"Test Lists"});
            _loc1_.push({"name":"Test New Buttons"});
            _loc1_.push({"name":"Test Resources"});
            _loc1_.push({"name":"Test Images"});
            this.OptionsList_mc.InitializeEntries(_loc1_);
            this.OptionsList_mc.selectedIndex = 0;
         }
         else if(this._currentScreenState == LIST_TYPE_SCREEN)
         {
            _loc2_ = new Array();
            _loc2_.push({"name":"Delta Set"});
            _loc2_.push({"name":"Scrolling Container"});
            _loc2_.push({"name":"Grid List"});
            _loc2_.push({"name":"Deprecated Scrolling List"});
            this.OptionsList_mc.InitializeEntries(_loc2_);
            this.OptionsList_mc.selectedIndex = 0;
         }
         else if(this._currentScreenState == DATA_SCREEN)
         {
            switch(this._currentTestType)
            {
               case LIST_TEST:
                  this.InitializeListDataScreen();
                  break;
               case BUTTON_TEST:
                  this.InitializeButtonDataScreen();
                  break;
               case RESOURCE_TEST:
                  this.ResourcesTest_mc.ShowResources();
                  break;
               case IMAGE_TEST:
                  this.ImagesTest_mc.ShowImages();
            }
         }
         this.UpdateComponentsVisibility();
         this.UpdateExitButtons();
      }
      
      private function UpdateListButtons() : void
      {
         if(this.PushBackButton != null)
         {
            this.PushBackButton.Enabled = this.currentSortType == ST_NONE;
            this.InsertButton.SetButtonData(this.currentSortType == ST_NONE ? this.InsertAtData : this.SortedInsertData);
            this.ListButtonBar_mc.RefreshButtons();
         }
      }
      
      private function InitializeListDataScreen() : void
      {
         var ScrollListConfig:BSScrollingConfigParams;
         if(!this._initListTest)
         {
            this.ListButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,10);
            this.ListButtonBar_mc.ButtonBarColor = this.TEAL_TEST_COLOR;
            this.PushBackButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Push Back",new UserEventData("Accept",function():void
            {
               DoAction(SA_PUSH_BACK);
            })),this.ListButtonBar_mc) as ButtonBase;
            this.InsertButton = ButtonFactory.AddToButtonBar("BasicButton",this.InsertAtData,this.ListButtonBar_mc) as ButtonBase;
            ButtonFactory.AddToButtonBar("ReleaseHoldComboButton",new ReleaseHoldComboButtonData("Remove","Remove multiples of 2",[new UserEventData("YButton",function():void
            {
               DoAction(SA_REMOVE);
            }),new UserEventData("",function():void
            {
               DoAction(SA_REMOVE_MULTIPLE);
            })]),this.ListButtonBar_mc);
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Resize",new UserEventData("RShoulder",function():void
            {
               DoAction(SA_RESIZE);
            })),this.ListButtonBar_mc);
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Clear",new UserEventData("LShoulder",function():void
            {
               DoAction(SA_CLEAR);
            })),this.ListButtonBar_mc);
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Next Sort",new UserEventData("R3",function():void
            {
               DoAction(SA_SORT);
            })),this.ListButtonBar_mc);
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Next Filter",new UserEventData("L3",this.FilterAction)),this.ListButtonBar_mc);
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Test All",new UserEventData("Select",this.TestAllAction)),this.ListButtonBar_mc);
            this.UpdateListButtons();
            this._initListTest = true;
         }
         ScrollListConfig = new BSScrollingConfigParams();
         ScrollListConfig.VerticalSpacing = 1;
         ScrollListConfig.EntryClassName = "TestScroll_Entry";
         ScrollListConfig.MultiLine = true;
         switch(this._currentListType)
         {
            case DELTA_SET_INDEX:
               this.DeltaList_mc.Configure(ScrollListConfig);
               break;
            case SCROLLING_CONTAINER_INDEX:
               this.ScrollList_mc.Configure(ScrollListConfig);
               break;
            case GRID_LIST_INDEX:
               this.GridList_mc.Configure(TestGrid_Entry,this.MAX_COLUMNS,this.MAX_ROWS,this.GRID_SPACING,this.GRID_SPACING,true,this.GRID_REPEAT_INTERVAL_MS);
               break;
            case DEPRECATED_SCROLLING_LIST_INDEX:
               StyleSheet.apply(this.DeprecatedList_mc,false,TestMenu_DeprecatedListStyle);
         }
         this.currentFilter = AF_ALL;
      }
      
      private function ChangeButtonAlignment(param1:int) : void
      {
         if(this.AlignButton != null)
         {
            this.AlignButton.justification = param1;
            this.ButtonBarTest_mc.RefreshButtons();
         }
      }
      
      private function InitializeButtonDataScreen() : void
      {
         if(!this._initButtonTest)
         {
            this.ReleaseHoldComboButton_mc.SetButtonData(new ReleaseHoldComboButtonData("Release Button","Hold Button",[new UserEventData("XButton",this.ReleaseASCallback,""),new UserEventData("",this.HoldASCallback,"")]));
            this.MyButtonManager.AddButton(this.ReleaseHoldComboButton_mc);
            this.ReleaseHoldComboButton_mc.ButtonColor = this.GREEN_TEST_COLOR;
            this.BasicButton_mc.SetButtonData(new ButtonBaseData("Basic Button",new UserEventData("LShoulder",this.ReleaseASCallback)));
            this.MyButtonManager.AddButton(this.BasicButton_mc);
            this.BasicButton_mc.ButtonColor = this.GREEN_TEST_COLOR;
            this.ButtonBarTest_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
            this.ButtonBarTest_mc.ButtonBarColor = this.TEAL_TEST_COLOR;
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Up Arrow",new UserEventData("Up",function():void
            {
               trace("Pressed up.");
            })),this.ButtonBarTest_mc);
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Down Arrow",new UserEventData("Down",function():void
            {
               trace("Pressed down.");
            })),this.ButtonBarTest_mc);
            ButtonFactory.AddToButtonBar("ReleaseHoldComboButton",new ReleaseHoldComboButtonData("PRESS","HOLD TO DO THING",[new UserEventData("YButton",this.ReleaseASCallback),new UserEventData("",this.HoldASCallback)]),this.ButtonBarTest_mc);
            this.AlignButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("Button Alignment Test",[new UserEventData("Left",function():void
            {
               ChangeButtonAlignment(IButtonUtils.ICON_FIRST);
            }),new UserEventData("Right",function():void
            {
               ChangeButtonAlignment(IButtonUtils.LABEL_FIRST);
            })]),this.ButtonBarTest_mc) as ButtonBase;
            this.ButtonBarTest_mc.RefreshButtons();
         }
      }
      
      private function FilterAsString(param1:int) : String
      {
         var _loc2_:String = "";
         switch(this.currentFilter)
         {
            case AF_NONE:
               _loc2_ = "No Cards";
               break;
            case AF_MAJOR_ARCANA:
               _loc2_ = "Major Arcana";
               break;
            case AF_SPECIAL:
               _loc2_ = "Special";
               break;
            case AF_ASTROLOGICAL:
               _loc2_ = "Astrological";
               break;
            case AF_ALL:
               _loc2_ = "All Cards";
         }
         return _loc2_;
      }
      
      private function SortTypeAsString(param1:int) : String
      {
         var _loc2_:String = "";
         switch(this._currentSortType)
         {
            case ST_NONE:
               _loc2_ = "None";
               break;
            case ST_NAME:
               _loc2_ = "Name";
               break;
            case ST_ID:
               _loc2_ = "ID";
         }
         return _loc2_;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.ExitButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this._currentTestType == BUTTON_TEST && this._currentScreenState == DATA_SCREEN)
         {
            _loc3_ = this.MyButtonManager.ProcessUserEvent(param1,param2);
            if(!_loc3_)
            {
               _loc3_ = this.ButtonBarTest_mc.ProcessUserEvent(param1,param2);
            }
         }
         if(!_loc3_ && this._currentTestType == LIST_TEST && this._currentScreenState == DATA_SCREEN)
         {
            _loc3_ = this.ListButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function OnTestMenuDataUpdate(param1:FromClientDataEvent) : void
      {
         this.currentSortType = param1.data.uSortType;
         if(this._currentScreenState == DATA_SCREEN)
         {
            if(this._currentListType == DELTA_SET_INDEX)
            {
               this.DeltaList_mc.UpdateEntries(param1.data.aArcanaItems);
               if(this.DeltaList_mc.selectedIndex == -1 && this.DeltaList_mc.entryCount > 0)
               {
                  this.DeltaList_mc.selectedIndex = 0;
               }
               else if(this.DeltaList_mc.entryCount == 0)
               {
                  this.DeltaList_mc.selectedIndex = -1;
               }
            }
            else if(this._currentListType == SCROLLING_CONTAINER_INDEX)
            {
               this.ScrollList_mc.InitializeEntries(param1.data.aArcanaItems.dataA);
               if(this.ScrollList_mc.selectedIndex == -1 && this.ScrollList_mc.entryCount > 0)
               {
                  this.ScrollList_mc.selectedIndex = 0;
               }
               else if(this.ScrollList_mc.entryCount == 0)
               {
                  this.ScrollList_mc.selectedIndex = -1;
               }
            }
            else if(this._currentListType == GRID_LIST_INDEX)
            {
               this.GridList_mc.entryData = param1.data.aArcanaItems.dataA;
               if(this.GridList_mc.selectedIndex == -1 && this.GridList_mc.entryCount > 0)
               {
                  this.GridList_mc.selectedIndex = 0;
               }
               else if(this.GridList_mc.entryCount == 0)
               {
                  this.GridList_mc.selectedIndex = -1;
               }
            }
            else if(this._currentListType == DEPRECATED_SCROLLING_LIST_INDEX)
            {
               this.DeprecatedList_mc.entryList = param1.data.aArcanaItems.dataA;
               this.DeprecatedList_mc.InvalidateData();
            }
         }
      }
      
      private function OnTestFlushDataUpdate(param1:FromClientDataEvent) : void
      {
         trace("OnTestFlushDataUpdate: " + param1.data.bTestFlag);
      }
      
      private function AcceptScreenAction() : void
      {
         if(this._currentScreenState == TEST_TYPE_SCREEN)
         {
            this._currentTestType = this.OptionsList_mc.selectedIndex;
            if(this._currentTestType == LIST_TEST)
            {
               this._currentScreenState = LIST_TYPE_SCREEN;
            }
            else if(this._currentTestType == BUTTON_TEST)
            {
               this._currentScreenState = DATA_SCREEN;
            }
            else if(this._currentTestType == RESOURCE_TEST)
            {
               this._currentScreenState = DATA_SCREEN;
            }
            else if(this._currentTestType == IMAGE_TEST)
            {
               this._currentScreenState = DATA_SCREEN;
            }
            this.InitializeCurrentScreen();
         }
         else if(this._currentScreenState == LIST_TYPE_SCREEN)
         {
            this._currentListType = this.OptionsList_mc.selectedIndex;
            this._currentScreenState = DATA_SCREEN;
            this.InitializeCurrentScreen();
         }
      }
      
      private function ExitMenu() : void
      {
         BSUIDataManager.dispatchEvent(new Event("TestMenu_ExitMenu"));
      }
      
      private function ReleaseASCallback() : *
      {
         trace("Successful button release callback.");
      }
      
      private function HoldASCallback() : *
      {
         trace("Successful button hold callback.");
      }
      
      private function PreviousScreen() : void
      {
         if(this._currentScreenState == TEST_TYPE_SCREEN)
         {
            this.ExitMenu();
         }
         else if(this._currentScreenState == LIST_TYPE_SCREEN)
         {
            this._currentScreenState = TEST_TYPE_SCREEN;
            this._currentTestType = -1;
            this.InitializeCurrentScreen();
         }
         else if(this._currentScreenState == DATA_SCREEN)
         {
            if(this._currentTestType == LIST_TEST)
            {
               this._currentScreenState = LIST_TYPE_SCREEN;
               this._currentListType = -1;
            }
            else if(this._currentTestType == BUTTON_TEST)
            {
               this._currentScreenState = TEST_TYPE_SCREEN;
               this._currentTestType = -1;
            }
            else if(this._currentTestType == RESOURCE_TEST)
            {
               this._currentScreenState = TEST_TYPE_SCREEN;
               this._currentTestType = -1;
            }
            else if(this._currentTestType == IMAGE_TEST)
            {
               this._currentScreenState = TEST_TYPE_SCREEN;
               this._currentTestType = -1;
            }
            this.InitializeCurrentScreen();
         }
      }
      
      private function DoAction(param1:int) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("TestMenu_DoAction",{"action":param1}));
      }
      
      private function TestAllAction() : void
      {
         BSUIDataManager.dispatchEvent(new Event("TestMenu_TestAll"));
      }
      
      private function FilterAction() : void
      {
         switch(this.currentFilter)
         {
            case AF_NONE:
               this.currentFilter = AF_MAJOR_ARCANA;
               break;
            case AF_MAJOR_ARCANA:
               this.currentFilter = AF_SPECIAL;
               break;
            case AF_SPECIAL:
               this.currentFilter = AF_ASTROLOGICAL;
               break;
            case AF_ASTROLOGICAL:
               this.currentFilter = AF_ALL;
               break;
            case AF_ALL:
               this.currentFilter = AF_NONE;
         }
      }
   }
}
