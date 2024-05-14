package
{
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.TabButtonBarEvent;
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
   
   public class ShipCrewMenu extends IMenu
   {
      
      private static const CSVT_NAME:uint = EnumHelper.GetEnum(0);
      
      private static const CSVT_ASSIGNMENT:uint = EnumHelper.GetEnum();
      
      private static const CSVT_SKILLS:uint = EnumHelper.GetEnum();
      
      private static const CSDT_ASCENDING:uint = EnumHelper.GetEnum(0);
      
      private static const CSDT_DESCENDING:uint = EnumHelper.GetEnum();
      
      private static const CSDT_SKILLS_ALL:uint = EnumHelper.GetEnum();
      
      private static const CSDT_SKILLS_SHIP:uint = EnumHelper.GetEnum();
      
      private static const CSDT_SKILLS_OUTPOST:uint = EnumHelper.GetEnum();
      
      private static const CSDT_COUNT:uint = EnumHelper.GetEnum();
      
      private static const ShipCrewMenu_ViewedItem:String = "ShipCrewMenu_ViewedItem";
      
      private static const ShipCrewMenu_Close:String = "ShipCrewMenu_Close";
      
      private static const ShipCrewMenu_OpenAssignMenu:String = "ShipCrewMenu_OpenAssignMenu";
      
      private static const ShipCrewMenu_SetSort:String = "ShipCrewMenu_SetSort";
       
      
      public var CrewList_mc:CrewList;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Tabs_mc:MovieClip;
      
      public var TabBar_mc:TabButtonBar;
      
      public var MenuBackground_mc:MovieClip;
      
      public var Vignette_mc:MovieClip;
      
      public var PreviewSceneRect_mc:BSAnimating3DSceneRect;
      
      private var SkillLibrary:SharedLibraryOwner = null;
      
      private var SortButtonData:ButtonBaseData;
      
      private var UnassignButtonData:ButtonBaseData;
      
      private var AssignButtonData:ButtonBaseData;
      
      private var BackButtonData:ReleaseHoldComboButtonData = null;
      
      private var LeftRightButtonData:ButtonBaseData;
      
      private var SortButton:IButton;
      
      private var UnassignButton:IButton;
      
      private var AssignButton:IButton;
      
      private var LeftRightButton:IButton;
      
      private var SelectedEntry:Object = null;
      
      private var CrewData:Object = null;
      
      private var CurrentCategoryFilter:ShipCrewTabData;
      
      private var Tabs:Array = null;
      
      private var TabIndex:uint;
      
      private var CurrentSortedTab:uint;
      
      private var CurrentSortedDirection:uint;
      
      public function ShipCrewMenu()
      {
         var _loc8_:* = undefined;
         this.SortButtonData = new ButtonBaseData("$SORT",new UserEventData("R3",this.onSort),true,true);
         this.UnassignButtonData = new ButtonBaseData("$UNASSIGN",new UserEventData("XButton",this.onUnassign),true,true);
         this.AssignButtonData = new ButtonBaseData("$Assign",new UserEventData("Accept",this.onAssign),true,true);
         this.LeftRightButtonData = new ButtonBaseData("",[new UserEventData("Left",this.onPressLeft),new UserEventData("Right",this.onPressRight)],true,false);
         this.TabIndex = CSVT_NAME;
         this.CurrentSortedTab = CSVT_NAME;
         this.CurrentSortedDirection = CSDT_ASCENDING;
         super();
         var _loc1_:String = "$EXIT HOLD";
         this.BackButtonData = new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.onBack),new UserEventData("",GlobalFunc.CloseAllMenus)],true,true);
         this.SkillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.AssignButton = ButtonFactory.AddToButtonBar("BasicButton",this.AssignButtonData,this.ButtonBar_mc) as IButton;
         this.UnassignButton = ButtonFactory.AddToButtonBar("BasicButton",this.UnassignButtonData,this.ButtonBar_mc) as IButton;
         this.SortButton = ButtonFactory.AddToButtonBar("BasicButton",this.SortButtonData,this.ButtonBar_mc) as IButton;
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,this.BackButtonData);
         this.LeftRightButton = ButtonFactory.AddToButtonBar("BasicButton",this.LeftRightButtonData,this.ButtonBar_mc) as IButton;
         this.ButtonBar_mc.RefreshButtons();
         var _loc2_:CrewTab = this.Tabs_mc.NameTab_mc;
         var _loc3_:CrewTab = this.Tabs_mc.AssignmentTab_mc;
         var _loc4_:CrewTab = this.Tabs_mc.SkillsTab_mc;
         _loc2_.TabIndex = CSVT_NAME;
         _loc3_.TabIndex = CSVT_ASSIGNMENT;
         _loc4_.TabIndex = CSVT_SKILLS;
         this.Tabs = new Array(_loc2_,_loc3_,_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < this.Tabs.length)
         {
            (_loc8_ = this.Tabs[_loc5_]).Deselect();
            _loc8_.index = _loc5_;
            _loc8_.addEventListener(MouseEvent.CLICK,this.OnEntryPress);
            _loc5_++;
         }
         this.Tabs[this.CurrentSortedTab].Select();
         this.Tabs[this.CurrentSortedTab].SetSortUp();
         var _loc6_:BSScrollingConfigParams;
         (_loc6_ = new BSScrollingConfigParams()).VerticalSpacing = 3;
         _loc6_.EntryClassName = "CrewListEntry";
         this.CrewList_mc.Configure(_loc6_);
         this.CrewList_mc.SetFilterComparitor(this.CrewFilterFunction);
         this.CrewList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.SelectedItem);
         this.CrewList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.onAssign);
         this.TabBar_mc.addEventListener(TabButtonBarEvent.TAB_CHANGED,this.ListFilterChanged);
         var _loc7_:Array;
         (_loc7_ = new Array()).push(new ShipCrewTabData("$ALL",ShipCrewUtils.ASSIGNMENT_TYPE_FLAG_ALL,false));
         _loc7_.push(new ShipCrewTabData("$AssignmentCategoryShip",ShipCrewUtils.ASSIGNMENT_TYPE_FLAG_SHIP,false));
         _loc7_.push(new ShipCrewTabData("$AssignmentCategoryCurrentOutpost",ShipCrewUtils.ASSIGNMENT_TYPE_FLAG_OUTPOST,true));
         _loc7_.push(new ShipCrewTabData("$AssignmentCategoryOutpost",ShipCrewUtils.ASSIGNMENT_TYPE_FLAG_OUTPOST,false));
         this.TabBar_mc.SetTabs("TabTextButton",_loc7_);
         this.TabBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_PIXEL_PERFECT);
         stage.focus = this.CrewList_mc;
         this.PreviewSceneRect_mc.SetBackgroundColor(67504895);
         BS3DSceneRectManager.Register3DSceneRect(this.PreviewSceneRect_mc);
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function OnEntryPress(param1:MouseEvent) : *
      {
         this.SelectTab(param1.currentTarget.index);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ShipCrewData",this.OnReceivedPayloadData);
      }
      
      private function OnReceivedPayloadData(param1:FromClientDataEvent) : void
      {
         this.CrewData = param1.data;
         this.UpdateCategoryData();
         this.SelectedEntry = this.CrewList_mc.selectedEntry;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.TabBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function ListFilterChanged(param1:TabButtonBarEvent) : void
      {
         this.CurrentCategoryFilter = param1.PayloadData as ShipCrewTabData;
         CrewListEntry.CurrentCrewListFilter = this.CurrentCategoryFilter.Type;
         this.CrewList_mc.selectedIndex = -1;
         this.UpdateCategoryData();
      }
      
      private function UpdateCategoryData() : *
      {
         if(this.CrewData != null)
         {
            this.CrewList_mc.InitializeEntries(this.CrewData.CrewInfoA);
            if(this.CrewList_mc.selectedIndex == -1 && this.CrewList_mc.entryCount > 0)
            {
               this.CrewList_mc.selectedIndex = 0;
            }
         }
         this.UpdateButtonHints();
      }
      
      private function CrewFilterFunction(param1:Object) : Boolean
      {
         return (this.CurrentCategoryFilter.Type & ShipCrewUtils.AssignmentTypeToFlag(param1.uAssignmentType)) > 0;
      }
      
      private function SelectedItem(param1:ScrollingEvent) : void
      {
         if(this.SelectedEntry != this.CrewList_mc.selectedEntry)
         {
            if(this.SelectedEntry != null && Boolean(this.SelectedEntry.bNew))
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewMenu_ViewedItem,{"uHandle":this.SelectedEntry.uHandle}));
            }
            this.SelectedEntry = this.CrewList_mc.selectedEntry;
            this.UpdateButtonHints();
            GlobalFunc.PlayMenuSound("UIMenuGeneralFocus");
         }
      }
      
      private function UpdateButtonHints() : *
      {
         var _loc1_:Boolean = this.CrewList_mc.entryCount > 0 && this.SelectedEntry != null && !this.SelectedEntry.bReassignDisabled;
         this.UnassignButton.Enabled = _loc1_ && this.CrewList_mc.selectedEntry.uAssignmentType != ShipCrewUtils.ASSIGNMENT_TYPE_UNASSIGNED;
         this.AssignButton.Enabled = _loc1_;
      }
      
      private function onBack() : *
      {
         if(this.SelectedEntry != null && Boolean(this.SelectedEntry.bNew))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewMenu_ViewedItem,{"uHandle":this.SelectedEntry.uHandle}));
         }
         BSUIDataManager.dispatchEvent(new Event(ShipCrewMenu_Close));
         GlobalFunc.PlayMenuSound("UIMenuGeneralCancel");
      }
      
      private function onPressLeft() : *
      {
         var _loc1_:* = (this.TabIndex - 1 + this.Tabs.length) % this.Tabs.length;
         this.SelectTab(_loc1_);
      }
      
      private function onPressRight() : *
      {
         var _loc1_:* = (this.TabIndex + 1 + this.Tabs.length) % this.Tabs.length;
         this.SelectTab(_loc1_);
      }
      
      private function SelectTab(param1:int) : *
      {
         this.Tabs[this.TabIndex].Deselect();
         this.TabIndex = param1;
         this.Tabs[this.TabIndex].Select();
      }
      
      private function onUnassign() : *
      {
         if(this.SelectedEntry != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewMenu_OpenAssignMenu,{
               "uHandle":this.SelectedEntry.uHandle,
               "bAssign":false
            }));
         }
      }
      
      private function onAssign() : *
      {
         if(this.SelectedEntry != null && this.AssignButton.Enabled)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewMenu_OpenAssignMenu,{
               "uHandle":this.SelectedEntry.uHandle,
               "bAssign":true
            }));
         }
      }
      
      private function onSort() : *
      {
         if(this.CurrentSortedTab != this.TabIndex)
         {
            this.Tabs[this.CurrentSortedTab].SetNoSort();
            this.CurrentSortedTab = this.TabIndex;
            switch(this.CurrentSortedTab)
            {
               case CSVT_NAME:
               case CSVT_ASSIGNMENT:
                  this.CurrentSortedDirection = CSDT_ASCENDING;
                  break;
               case CSVT_SKILLS:
                  this.CurrentSortedDirection = CSDT_SKILLS_ALL;
            }
            this.Tabs[this.CurrentSortedTab].SetSortUp();
         }
         else
         {
            switch(this.CurrentSortedTab)
            {
               case CSVT_NAME:
               case CSVT_ASSIGNMENT:
                  if(this.CurrentSortedDirection == CSDT_ASCENDING)
                  {
                     this.CurrentSortedDirection = CSDT_DESCENDING;
                     this.Tabs[this.CurrentSortedTab].SetSortDown();
                  }
                  else
                  {
                     this.CurrentSortedDirection = CSDT_ASCENDING;
                     this.Tabs[this.CurrentSortedTab].SetSortUp();
                  }
                  break;
               case CSVT_SKILLS:
                  ++this.CurrentSortedDirection;
                  if(this.CurrentSortedDirection == CSDT_COUNT)
                  {
                     this.CurrentSortedDirection = CSDT_SKILLS_ALL;
                  }
                  break;
               default:
                  GlobalFunc.TraceWarning("Unhandled sort direction");
            }
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewMenu_SetSort,{
            "uValue":this.CurrentSortedTab,
            "uDirection":this.CurrentSortedDirection
         }));
      }
   }
}
