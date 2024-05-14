package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MissionBoard extends IMenu
   {
      
      public static const MissionBoard_MissionEntryPressed:String = "MissionBoard_MissionEntryPressed";
      
      public static const MissionBoard_MissionEntryChanged:String = "MissionBoard_MissionEntryChanged";
      
      public static const MISSION_BOARD_ENTER_SOUND:String = "UITerminalMissionBoardEnter";
      
      public static const MISSION_BOARD_EXIT_SOUND:String = "UITerminalMissionBoardExit";
      
      public static const MISSION_BOARD_FOCUS_SOUND:String = "UITerminalMissionBoardFocus";
      
      public static const MISSION_BOARD_SELECT_SOUND:String = "UITerminalMissionBoardMissionSelect";
       
      
      public var Dots_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var MissionInfo_mc:MissionInfo;
      
      public var AvailableMissionList_mc:MovieClip;
      
      public var FactionIcon_mc:MovieClip;
      
      private var MissionListConfigParams:BSScrollingConfigParams;
      
      private var FactionID:int;
      
      public function MissionBoard()
      {
         this.FactionID = FactionUtils.FACTION_NONE;
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.AcceptButton,new ButtonBaseData("$ACCEPT",new UserEventData("Accept",this.onMissionEntryPressed),false));
         this.ButtonBar_mc.AddButtonWithData(this.ExitButton,new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.onCancelEvent)));
         this.ButtonBar_mc.RefreshButtons();
         this.MissionListConfigParams = new BSScrollingConfigParams();
         this.MissionListConfigParams.VerticalSpacing = 3;
         this.MissionListConfigParams.WrapAround = false;
         this.MissionListConfigParams.RestoreIndex = false;
         this.MissionListConfigParams.EntryClassName = "MissionEntry_NoFaction";
         this.MissionList.Configure(this.MissionListConfigParams);
         this.Dots_mc.mouseEnabled = false;
         this.Dots_mc.mouseChildren = false;
      }
      
      public static function GetFactionLabel(param1:int) : String
      {
         var _loc2_:String = "NoFaction";
         switch(param1)
         {
            case FactionUtils.FACTION_UNITEDCOLONIES:
               _loc2_ = "UnitedColonies";
               break;
            case FactionUtils.FACTION_RYUJININDUSTRIES:
               _loc2_ = "Ryujin";
               break;
            case FactionUtils.FACTION_HOUSEVARUUN:
               _loc2_ = "HouseVaruun";
               break;
            case FactionUtils.FACTION_FREESTAR:
               _loc2_ = "Freestar";
               break;
            case FactionUtils.FACTION_BLACKFLEET:
               _loc2_ = "Crimson";
               break;
            case FactionUtils.FACTION_CONSTELLATION:
               _loc2_ = "Constellation";
               break;
            case FactionUtils.FACTION_NONE:
            default:
               _loc2_ = "NoFaction";
         }
         return _loc2_;
      }
      
      private function get AcceptButton() : IButton
      {
         return this.ButtonBar_mc.AcceptButton_mc;
      }
      
      private function get ExitButton() : IButton
      {
         return this.ButtonBar_mc.ExitButton_mc;
      }
      
      private function get MissionList() : MissionsList
      {
         return this.AvailableMissionList_mc.MissionsList_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("MissionList",this.PopulateMissionList);
         BSUIDataManager.Subscribe("FactionData",this.OnReceivedFactionData);
         stage.focus = this.MissionList;
         addEventListener("OpenAnimComplete",this.onOpenAnimComplete);
         this.MissionList.addEventListener(ScrollingEvent.ITEM_PRESS,this.onMissionEntryPressed);
         this.MissionList.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onMissionEntryChanged);
         GlobalFunc.PlayMenuSound(MISSION_BOARD_ENTER_SOUND);
      }
      
      public function onOpenAnimComplete() : void
      {
         gotoAndStop(GetFactionLabel(this.FactionID));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function OnRightStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : *
      {
         this.MissionInfo_mc.OnRightStickInput(param1,param2,param3,param4,param5);
      }
      
      private function onMissionEntryPressed() : *
      {
         var _loc1_:Object = this.MissionList.selectedEntry;
         if(_loc1_ != null && !_loc1_.bAccepted)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(MissionBoard_MissionEntryPressed,{"missionID":_loc1_.uID}));
            GlobalFunc.PlayMenuSound(MISSION_BOARD_SELECT_SOUND);
         }
      }
      
      private function onMissionEntryChanged() : *
      {
         var _loc1_:Object = this.MissionList.selectedEntry;
         if(_loc1_ != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(MissionBoard_MissionEntryChanged,{"uID":_loc1_.uID}));
            GlobalFunc.PlayMenuSound(MISSION_BOARD_FOCUS_SOUND);
         }
         this.AcceptButton.Enabled = _loc1_ != null && !_loc1_.bAccepted;
      }
      
      private function onCancelEvent() : *
      {
         GlobalFunc.CloseMenu("MissionBoard");
         GlobalFunc.PlayMenuSound(MISSION_BOARD_EXIT_SOUND);
      }
      
      private function PopulateMissionList(param1:FromClientDataEvent) : *
      {
         if(param1.data.aListDataA is Array)
         {
            this.MissionList.InitializeEntries(param1.data.aListDataA);
            if(uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE)
            {
               this.MissionList.selectedIndex = Math.max(this.MissionList.selectedIndex,0);
            }
            if(Boolean(param1.data.bUpdatesInfo) && this.MissionList.selectedIndex >= 0)
            {
               this.onMissionEntryChanged();
            }
         }
      }
      
      private function OnReceivedFactionData(param1:FromClientDataEvent) : void
      {
         this.UpdateFaction(param1.data.iFaction);
      }
      
      private function UpdateFaction(param1:int) : void
      {
         this.FactionID = param1;
         var _loc2_:String = GetFactionLabel(this.FactionID);
         this.MissionInfo_mc.UpdateFaction(_loc2_);
         this.AvailableMissionList_mc.gotoAndStop(_loc2_);
         this.FactionIcon_mc.gotoAndStop(_loc2_);
         this.MissionList.SetMissionEntryClass("MissionEntry_" + GetFactionLabel(this.FactionID));
      }
   }
}
