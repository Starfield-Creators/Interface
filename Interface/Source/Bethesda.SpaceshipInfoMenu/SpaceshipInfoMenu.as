package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SpaceshipInfoMenu extends IMenu
   {
      
      private static const SpaceshipInfoMenu_AssignWeapons:String = "SpaceshipInfoMenu_AssignWeapons";
      
      private static const SpaceshipInfoMenu_Crew:String = "SpaceshipInfoMenu_Crew";
      
      private static const SpaceshipInfoMenu_RepairHull:String = "SpaceshipInfoMenu_RepairHull";
      
      private static const SpaceshipInfoMenu_Transfer:String = "SpaceshipInfoMenu_Transfer";
      
      private static const SpaceshipInfoMenu_ShipBuilder:String = "SpaceshipInfoMenu_ShipBuilder";
      
      private static const SpaceshipInfoMenu_SelectShip:String = "SpaceshipInfoMenu_SelectShip";
      
      private static const SpaceshipInfoMenu_HomeShip:String = "SpaceshipInfoMenu_HomeShip";
      
      private static const SpaceshipInfoMenu_PurchaseShip:String = "SpaceshipInfoMenu_PurchaseShip";
      
      private static const SpaceshipInfoMenu_SellShip:String = "SpaceshipInfoMenu_SellShip";
      
      private static const SpaceshipInfoMenu_MyShipsTabChanged:String = "SpaceshipInfoMenu_MyShipsTabChanged";
      
      public static const TAB_OWNED:int = EnumHelper.GetEnum(0);
      
      public static const TAB_AVAILABLE:int = EnumHelper.GetEnum();
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Spinner_mc:MovieClip;
      
      public var CreditsContainer_mc:CreditsSummary;
      
      public var Content_mc:MovieClip;
      
      public var MenuBackground_mc:MovieClip;
      
      private var ShipTransactionButtonData:ButtonBaseData;
      
      private var SwitchCategoryButtonData:ButtonBaseData;
      
      private var RepairButton:IButton;
      
      private var OpenBuilderButton:IButton;
      
      private var UpgradeShipButton:IButton;
      
      private var HomeShipButton:IButton;
      
      private var TransferButton:IButton;
      
      private var CrewButton:IButton;
      
      private var SwitchCategoryButton:IButton;
      
      private var VendorMode:Boolean = false;
      
      private var ModifyMode:Boolean = false;
      
      private var ShipRegistered:Boolean = true;
      
      private var ShowingOwned:Boolean = false;
      
      public function SpaceshipInfoMenu()
      {
         super();
         this.Spinner_mc.visible = false;
         GlobalFunc.PlayMenuSound("UIMenuShipMenuOpen");
      }
      
      private function get ShipTransactionButton() : IButton
      {
         return this.ButtonBar_mc.ShipTransactionButton_mc;
      }
      
      private function get ShipSelector() : ShipNameCallSign
      {
         return this.Content_mc.ShipSelector_mc;
      }
      
      private function get PowerPanel() : PowerDisplay
      {
         return this.Content_mc.PowerPanel_mc;
      }
      
      private function get ContentBackground() : MovieClip
      {
         return this.Content_mc.ContentBackground_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.SetUpButtonBar();
         BSUIDataManager.Subscribe("ShipMenuData",this.OnReceivedPayloadData);
         BSUIDataManager.Subscribe("ShipStatsData",this.onReceivedShipStatsData);
         BSUIDataManager.Subscribe("ShipHangarModuleInfoData",this.onSystemStatsUpdate);
      }
      
      private function onSystemStatsUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         this.ContentBackground.visible = !_loc2_.bShowWidget;
      }
      
      private function OnReceivedPayloadData(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         visible = _loc2_.bMenuVisible;
         this.VendorMode = _loc2_.bVendorMode;
         this.ModifyMode = _loc2_.bModifyMode;
         this.Spinner_mc.visible = _loc2_.bShipLoading;
         this.MenuBackground_mc.visible = _loc2_.bCellLoading;
         this.CreditsContainer_mc.visible = this.VendorMode;
         this.ShowingOwned = this.VendorMode && _loc2_.iSelectedTab == TAB_OWNED;
         this.SetButtonsVisible(_loc2_);
      }
      
      private function SetUpButtonBar() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ShipTransactionButtonData = new ButtonBaseData("",[new UserEventData("ShipTransaction",this.onShipTransaction)]);
         this.SwitchCategoryButtonData = new ButtonBaseData("$VIEW_AVAILABLE",[new UserEventData("SwitchCategory",this.onSwitchCategory)]);
         this.CrewButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CREW",[new UserEventData("Crew",this.onCrew)]),this.ButtonBar_mc);
         this.TransferButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CARGO HOLD",[new UserEventData("CargoHold",this.onTransferButton)]),this.ButtonBar_mc);
         this.RepairButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$REPAIR HULL",[new UserEventData("Repair",this.onRepairHull)]),this.ButtonBar_mc);
         this.HomeShipButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$MAKE_HOME_SHIP",[new UserEventData("HomeShip",this.onHomeShip)]),this.ButtonBar_mc);
         this.OpenBuilderButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$OPEN_BUILDER",[new UserEventData("ShipBuilder",this.onShipBuilder)]),this.ButtonBar_mc);
         this.UpgradeShipButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$UPGRADE_SHIP",[new UserEventData("UpgradeShip",this.onUpgradeShip)]),this.ButtonBar_mc);
         this.SwitchCategoryButton = ButtonFactory.AddToButtonBar("BasicButton",this.SwitchCategoryButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.ShipTransactionButton,this.ShipTransactionButtonData);
         var _loc1_:String = "$EXIT HOLD";
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.ExitButton_mc,new ReleaseHoldComboButtonData("$EXIT",_loc1_,[new UserEventData("Exit",this.onCancelEvent),new UserEventData("",this.onCloseSubMenuToGame)]));
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function SetButtonsVisible(param1:Object) : void
      {
         this.ShipSelector.SetButtonsVisible(this.VendorMode);
         this.ShipSelector.SetButtonsEnabled(this.VendorMode && Boolean(param1.bPreviousButtonEnabled),this.VendorMode && Boolean(param1.bNextButtonEnabled));
         this.RepairButton.Enabled = param1.bRepairButtonEnabled;
         this.RepairButton.Visible = param1.bRepairButtonVisible;
         this.HomeShipButton.Visible = param1.bHomeShipButtonVisible;
         this.TransferButton.Visible = param1.bTransferButtonVisible;
         this.OpenBuilderButton.Visible = this.ShowingOwned && this.ModifyMode;
         this.UpgradeShipButton.Visible = this.ShowingOwned && this.ModifyMode;
         this.CrewButton.Visible = !this.VendorMode || this.ShowingOwned && this.ModifyMode;
         this.SwitchCategoryButton.Visible = this.VendorMode && !this.ModifyMode;
         if(this.SwitchCategoryButton.Visible)
         {
            this.UpdateSwitchCategoryButton();
         }
         this.ShipTransactionButton.Visible = this.VendorMode && !this.ModifyMode;
         if(this.ShipTransactionButton.Visible)
         {
            this.UpdateTransactionButton();
         }
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function onReceivedShipStatsData(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.ShipTransactionButtonData.bVisible = !_loc2_.bShowNoShip;
         this.ShipTransactionButtonData.bEnabled = !_loc2_.bShowNoShip;
         this.ShipRegistered = _loc2_.bRegistered;
         this.UpdateTransactionButton();
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:uint) : Boolean
      {
         if(param4)
         {
            this.PowerPanel.OnLeftStickInput(param1,param2,param3,param4,param5,param6);
         }
         return true;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = this.ShipSelector.ProcessUserEvent(param1,param2);
         if(!_loc3_)
         {
            _loc3_ = this.PowerPanel.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onRepairHull() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuShipRepairHull");
         BSUIDataManager.dispatchEvent(new Event(SpaceshipInfoMenu_RepairHull));
      }
      
      private function onTransferButton() : *
      {
         BSUIDataManager.dispatchEvent(new Event(SpaceshipInfoMenu_Transfer));
      }
      
      private function onCancelEvent() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuShipMenuClose");
         GlobalFunc.CloseMenu("SpaceshipInfoMenu");
      }
      
      private function onHoldCancelEvent() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuShipMenuClose");
         BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
         GlobalFunc.CloseMenu("SpaceshipInfoMenu");
         GlobalFunc.CloseMenu("DataMenu");
      }
      
      private function onCrew() : *
      {
         BSUIDataManager.dispatchEvent(new Event(SpaceshipInfoMenu_Crew));
      }
      
      private function onShipBuilder() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuCraftingShipMenuOpen");
         BSUIDataManager.dispatchEvent(new CustomEvent(SpaceshipInfoMenu_ShipBuilder,{}));
      }
      
      private function onUpgradeShip() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuCraftingShipMenuOpen");
         BSUIDataManager.dispatchCustomEvent(PowerDisplay.HangarShipSelection_UpgradeSystem);
      }
      
      private function onHomeShip() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralOK");
         BSUIDataManager.dispatchEvent(new Event(SpaceshipInfoMenu_HomeShip));
      }
      
      private function onShipTransaction() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralOK");
         if(this.ShowingOwned)
         {
            BSUIDataManager.dispatchEvent(new Event(SpaceshipInfoMenu_SellShip));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new Event(SpaceshipInfoMenu_PurchaseShip));
         }
      }
      
      private function onCloseSubMenuToGame() : *
      {
         BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
         GlobalFunc.CloseAllMenus();
      }
      
      private function UpdateTransactionButton() : void
      {
         if(this.ShowingOwned)
         {
            this.ShipTransactionButtonData.sButtonText = this.ShipRegistered ? "$SELL SHIP" : "$REGISTER_SHIP";
         }
         else
         {
            this.ShipTransactionButtonData.sButtonText = "$PURCHASE SHIP";
         }
         this.ShipTransactionButton.SetButtonData(this.ShipTransactionButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function onSwitchCategory() : void
      {
         if(this.VendorMode)
         {
            this.ShowingOwned = !this.ShowingOwned;
            BSUIDataManager.dispatchCustomEvent(SpaceshipInfoMenu_MyShipsTabChanged,{"tabType":(this.ShowingOwned ? TAB_OWNED : TAB_AVAILABLE)});
         }
      }
      
      private function UpdateSwitchCategoryButton() : void
      {
         this.SwitchCategoryButtonData.sButtonText = this.ShowingOwned ? "$BUY SHIPS" : "$SELL SHIPS";
         this.SwitchCategoryButton.SetButtonData(this.SwitchCategoryButtonData);
      }
   }
}
