package
{
   import Components.QuantityComponent;
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.AS3.Inventory.InvItemCard;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ContainerMenu extends IMenu
   {
      
      private static const CM_LOOT:* = EnumHelper.GetEnum(0);
      
      private static const CM_STEALING_FROM_CONTAINER:* = EnumHelper.GetEnum();
      
      private static const CM_TEAMMATE:* = EnumHelper.GetEnum();
      
      private static const CM_WORKBENCH:* = EnumHelper.GetEnum();
      
      private static const CM_PLAYER_SHIP_TRANSFER:* = EnumHelper.GetEnum();
       
      
      public var Title_mc:MovieClip;
      
      public var CategoryHeader_mc:MovieClip;
      
      public var CategoryFooter_mc:MovieClip;
      
      public var CategoryList_mc:BSScrollingContainer;
      
      public var ItemHeader_mc:MovieClip;
      
      public var ItemList_mc:BSScrollingContainer;
      
      public var ItemCard_mc:InvItemCard;
      
      public var EquippedItemCard_mc:InvItemCard;
      
      public var PreviewSceneRect_mc:BSAnimating3DSceneRect;
      
      public var ConfirmWindow_mc:QuantityComponent;
      
      public var ButtonBar_mc:ButtonBar;
      
      private const MAX_NUMBER_OF_ITEMS_FOR_OPENING_ALL:uint = 30;
      
      private const CONTAINER_TITLE_MAX_LENGTH:* = 24;
      
      private const CATEGORY_CHANGE_SFX:String = "UIMenuGeneralCategory";
      
      protected var m_State:Function = null;
      
      protected var m_previousState:Function = null;
      
      protected const ENTER_STATE:int = EnumHelper.GetEnum(0);
      
      protected const EXIT_STATE:int = EnumHelper.GetEnum();
      
      protected const LIST_ITEM_PRESS:int = EnumHelper.GetEnum();
      
      protected const LIST_ITEM_ROLLOVER:int = EnumHelper.GetEnum();
      
      protected const CANCEL_PRESS:int = EnumHelper.GetEnum();
      
      protected const SORT_PRESS:int = EnumHelper.GetEnum();
      
      protected const SWAP_INVENTORIES:int = EnumHelper.GetEnum();
      
      protected const SHOW_EQUIPPED_STATS:int = EnumHelper.GetEnum();
      
      protected const INSPECT_PRESS:int = EnumHelper.GetEnum();
      
      private var ToContainerButtonData:ButtonBaseData;
      
      private var ToPlayerButtonData:ButtonBaseData;
      
      private var ToShipButtonData:ButtonBaseData;
      
      private var AcceptButtonData:ButtonBaseData;
      
      private var TakeAllButtonData:ButtonBaseData;
      
      private var AllResourcesButtonData:ButtonBaseData;
      
      private var EquipOrStoreButtonData:ButtonBaseData;
      
      public const EVENT_LOAD_3D_MODEL:String = "ContainerMenu_LoadModel";
      
      public const EVENT_HIDE_3D_MODEL:String = "ContainerMenu_HideModel";
      
      public const EVENT_TRANSFER_ITEM:String = "ContainerMenu_TransferItem";
      
      public const EVENT_TOGGLE_EQUIP:String = "ContainerMenu_ToggleEquip";
      
      public const EVENT_TRANSFER_ALL_RESOURCES:String = "ContainerMenu_TransferAllResources";
      
      public const EVENT_TAKE_ALL:String = "ContainerMenu_TakeAll";
      
      public const EVENT_OPEN_REFUEL_MENU:String = "ContainerMenu_OpenRefuelMenu";
      
      public const EVENT_JETTISON:String = "ContainerMenu_Jettison";
      
      public const EVENT_MOUSE_OVER_MODEL:String = "ContainerMenu_SetMouseOverModel";
      
      protected const TITLE_CONTAINER_STATE:String = "Container";
      
      protected const TITLE_PLAYER_STATE:String = "Player";
      
      protected const TITLE_SHIP_STATE:String = "Ship";
      
      protected const FOOTER_STATE_YOUR_CREDITS:String = "YourCredits";
      
      protected const FOOTER_STATE_CONTAINER_CREDITS:String = "ContainerCredits";
      
      private const SORT_NULL:Object = {
         "text":"$SORT",
         "sortFunc":null,
         "sortType":InventoryItemUtils.SORT_NONE
      };
      
      private const SORT_NAME:Object = {
         "text":"$SORT_ABC",
         "sortFunc":this.SortItemsByName,
         "sortType":InventoryItemUtils.SORT_NAME
      };
      
      private const SORT_DMG_DESC:Object = {
         "text":"$SORT_DMG",
         "sortFunc":this.SortItemsByDamage,
         "sortType":InventoryItemUtils.SORT_KEY_STAT
      };
      
      private const SORT_ARMOR_DESC:Object = {
         "text":"$SORT_ARMOR",
         "sortFunc":this.SortItemsByDamage,
         "sortType":InventoryItemUtils.SORT_KEY_STAT
      };
      
      private const SORT_VALUE_DESC:Object = {
         "text":"$SORT_VAL",
         "sortFunc":this.SortItemsByValue,
         "sortType":InventoryItemUtils.SORT_VALUE
      };
      
      private const SORT_WEIGHT_DESC:Object = {
         "text":"$SORT_WT",
         "sortFunc":this.SortItemsByWeight,
         "sortType":InventoryItemUtils.SORT_WEIGHT
      };
      
      private const SORT_TYPE:Object = {
         "text":"$SORT_TYPE",
         "sortFunc":this.SortItemsByType,
         "sortType":InventoryItemUtils.SORT_TYPE
      };
      
      private const SORT_AMMO:Object = {
         "text":"$SORT_AMMO",
         "sortFunc":this.SortItemsByAmmo,
         "sortType":InventoryItemUtils.SORT_AMMO
      };
      
      private var SortOptions:Array;
      
      private var SortPerCategory:Dictionary;
      
      private var CurrFilter:int = 0;
      
      private var FeaturedItemArray:Vector.<Object>;
      
      private var SecondaryFeaturedItemArray:Vector.<Object>;
      
      private var CurrShownModel:uint = 0;
      
      private var LargeTextMode:Boolean = false;
      
      private var bEquipCardWasVisible:Boolean = false;
      
      private var bCanShowEquipCompareItemCard:Boolean = false;
      
      private var uContainerMode:uint = 0;
      
      private var bContainerIsMannequin:Boolean = false;
      
      private var TransferDirection:uint;
      
      private var ItemDataA:Array;
      
      private var ReturningToGameplay:Boolean = false;
      
      private var DataMenuIsOpen:Boolean = false;
      
      private var PlayerInventoryData:Object = null;
      
      private var ContainerInventoryData:Object = null;
      
      private var ShipInventoryData:Object = null;
      
      private var RecentlyTransferredInventoryData:Object = null;
      
      private var bHasShipInventoryDataToDisplay:Boolean = false;
      
      private var bInitialized:Boolean = false;
      
      private var bAcquiredMenuData:Boolean = false;
      
      private var bAcquiredContainerData:Boolean = false;
      
      private var EquippedItemCardShouldBeVisible:* = false;
      
      private var CompareToEquippedButtonShouldBeVisible:* = false;
      
      private var CompareToEquippedButtonShouldBeEnabled:* = false;
      
      private var sContainerTitle:String = "$CONTAINER";
      
      private var _mouseOverModel:Boolean = false;
      
      public function ContainerMenu()
      {
         var configParams:BSScrollingConfigParams;
         this.ToContainerButtonData = new ButtonBaseData("$CONTAINER",[new UserEventData("LShoulder",this.onSwapInventories)],true,true);
         this.ToPlayerButtonData = new ButtonBaseData("$INVENTORY",[new UserEventData("LShoulder",this.onSwapInventories)],true,true);
         this.ToShipButtonData = new ButtonBaseData("$SHIP",[new UserEventData("LShoulder",this.onSwapInventories)],true,true);
         this.AcceptButtonData = new ButtonBaseData("$STORE",[new UserEventData("Accept",this.onItemPress)],true,true);
         this.TakeAllButtonData = new ButtonBaseData("$TAKE ALL",[new UserEventData("XButton",this.TakeAll)],true,true);
         this.AllResourcesButtonData = new ButtonBaseData("$STOREALLRESOURCES",[new UserEventData("RShoulder",this.onTakeOrStoreResources)],true,true);
         this.EquipOrStoreButtonData = new ButtonBaseData("$EQUIP",[new UserEventData("YButton",this.onEquipOrStore)],true,true);
         this.SortOptions = [this.SORT_NULL,this.SORT_NAME,this.SORT_VALUE_DESC];
         this.FeaturedItemArray = new Vector.<Object>();
         this.SecondaryFeaturedItemArray = new Vector.<Object>();
         this.TransferDirection = InventoryItemUtils.CM_BOTH;
         super();
         TextFieldEx.setTextAutoSize(this.ItemHeaderTitle_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.ItemHeaderCompareLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.SortPerCategory = new Dictionary();
         Extensions.enabled = true;
         this.ItemCard_mc.visible = false;
         this.EquippedItemCard_mc.visible = false;
         this.ButtonBar_mc.visible = false;
         ContainerColumnValueHelper.InitHelper();
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "ContainerCategory";
         configParams.VerticalSpacing = 3;
         this.CategoryList_mc.Configure(configParams);
         this.CategoryList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return (param1.uTotalItemCount > 0 && ((!!param1.bHasGold ? 1 : 0) < param1.uTotalItemCount || InContainerStates()) || param1.iFilterFlags == InventoryItemUtils.ICF_BUY_BACK) && param1.iFilterFlags != InventoryItemUtils.ICF_NEW_ITEMS;
         },false);
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "ContainerItem";
         configParams.VerticalSpacing = 3;
         this.ItemList_mc.Configure(configParams);
         this.ItemList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return (param1.iFilterFlag & CurrFilter) != 0;
         },false);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemPress);
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onEntryRollover);
         this.PreviewSceneRect_mc.SetBackgroundColor(67504895);
         BS3DSceneRectManager.Register3DSceneRect(this.PreviewSceneRect_mc);
         this.PopulateButtonBar();
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get InspectButton() : IButton
      {
         return this.ButtonBar_mc.InspectButton_mc;
      }
      
      private function get SortButton() : IButton
      {
         return this.ButtonBar_mc.SortButton_mc;
      }
      
      private function get SwapInventoriesButton() : IButton
      {
         return this.ButtonBar_mc.SwapInventoriesButton_mc;
      }
      
      private function get CompareToEquippedButton() : IButton
      {
         return this.ButtonBar_mc.CompareToEquippedButton_mc;
      }
      
      private function get EquipOrStoreButton() : IButton
      {
         return this.ButtonBar_mc.EquipOrStoreButton_mc;
      }
      
      private function get AllResourcesButton() : IButton
      {
         return this.ButtonBar_mc.AllResourcesButton_mc;
      }
      
      private function get AcceptButton() : IButton
      {
         return this.ButtonBar_mc.AcceptButton_mc;
      }
      
      private function get TakeAllButton() : IButton
      {
         return this.ButtonBar_mc.TakeAllButton_mc;
      }
      
      public function get ItemHeaderTitle_tf() : TextField
      {
         return this.ItemHeader_mc.CategoryName_mc.Text_tf;
      }
      
      public function get ItemHeaderCompareLabel_tf() : TextField
      {
         return this.ItemHeader_mc.CompareLabel_mc.Text_tf;
      }
      
      public function get Footer_Value_tf() : TextField
      {
         return this.CategoryFooter_mc.Credits_mc.Credits_tf;
      }
      
      public function get Footer_Weight_tf() : TextField
      {
         return this.CategoryFooter_mc.Weight_tf;
      }
      
      private function get canTake() : Boolean
      {
         return (this.TransferDirection & InventoryItemUtils.CM_TAKE_ITEMS) != 0;
      }
      
      private function get canGive() : Boolean
      {
         return (this.TransferDirection & InventoryItemUtils.CM_GIVE_ITEMS) != 0;
      }
      
      private function set mouseOverModel(param1:Boolean) : void
      {
         this._mouseOverModel = param1;
         BSUIDataManager.dispatchCustomEvent(this.EVENT_MOUSE_OVER_MODEL,{"bMouseOverModel":this._mouseOverModel});
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.PreviewSceneRect_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverModel);
         this.PreviewSceneRect_mc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutModel);
         BSUIDataManager.Subscribe("PlayerContainerInventoryData",this.onPlayerInventoryUpdate);
         BSUIDataManager.Subscribe("ContainerMenuData",this.onContainerMenuDataUpdate);
         BSUIDataManager.Subscribe("PlayerShipContainerInventoryData",this.onShipInventoryUpdate);
         BSUIDataManager.Subscribe("ContainerInventoryData",this.onContainerInventoryUpdate);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFireForgetEvent);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         this.PreviewSceneRect_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverModel);
         this.PreviewSceneRect_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutModel);
      }
      
      private function PopulateButtonBar() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.AcceptButton,this.AcceptButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.CompareToEquippedButton,new ButtonBaseData(this.LargeTextMode ? "$COMPARE TO EQUIPPED_LRG" : "$COMPARE TO EQUIPPED",[new UserEventData("Select",this.onCompareToEquipped)],true,true));
         this.ButtonBar_mc.AddButtonWithData(this.SwapInventoriesButton,this.ToPlayerButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.EquipOrStoreButton,this.EquipOrStoreButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.SortButton,new ButtonBaseData("$SORT",[new UserEventData("L3",this.ToggleSort)],true,true));
         this.ButtonBar_mc.AddButtonWithData(this.TakeAllButton,this.TakeAllButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.AllResourcesButton,this.AllResourcesButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.InspectButton,new ButtonBaseData("$INSPECT",[new UserEventData("R3",this.InspectItem)],true,false));
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",this.LargeTextMode ? "$EXIT HOLD_LRG" : "$EXIT HOLD",[new UserEventData("Cancel",this.onCancelEvent),new UserEventData("",this.onReturnToGameplay)]));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.m_State == this.state_ConfirmWindow)
         {
            _loc3_ = this.ConfirmWindow_mc.ProcessUserEvent(param1,param2);
         }
         else
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onCancelEvent() : void
      {
         this.m_State(this.CANCEL_PRESS);
      }
      
      private function ToggleSort() : void
      {
         this.m_State(this.SORT_PRESS);
      }
      
      private function onSwapInventories() : void
      {
         this.m_State(this.SWAP_INVENTORIES);
         GlobalFunc.PlayMenuSound(this.CATEGORY_CHANGE_SFX);
      }
      
      private function onCompareToEquipped() : void
      {
         this.m_State(this.SHOW_EQUIPPED_STATS);
         GlobalFunc.PlayMenuSound("UIMenuInventoryCompare");
      }
      
      private function InspectItem() : void
      {
         this.m_State(this.INSPECT_PRESS);
      }
      
      private function onItemPress() : void
      {
         this.m_State(this.LIST_ITEM_PRESS);
      }
      
      private function onTakeOrStoreResources() : void
      {
         if(this.AllResourcesButtonData.bVisible === false || this.AllResourcesButtonData.bEnabled === false)
         {
            return;
         }
         var _loc1_:uint = 0;
         if(this.m_State == this.state_ContainerItemList)
         {
            _loc1_ = uint(this.ContainerInventoryData.uHandle);
         }
         else if(this.m_State == this.state_ShipItemList)
         {
            _loc1_ = uint(this.ShipInventoryData.uHandle);
         }
         else if(this.m_State == this.state_PlayerItemList)
         {
            _loc1_ = uint(this.PlayerInventoryData.uHandle);
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_TRANSFER_ALL_RESOURCES,{"uFromContainerHandle":_loc1_}));
      }
      
      private function onEquipOrStore() : void
      {
         var _loc1_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         if(this.EquipOrStoreButtonData.bVisible === false || this.EquipOrStoreButtonData.bEnabled === false)
         {
            return;
         }
         var _loc2_:uint = 0;
         if(Boolean(this.ContainerInventoryData) && Boolean(this.PlayerInventoryData))
         {
            if(this.uContainerMode == CM_PLAYER_SHIP_TRANSFER && !this.InPlayerStates())
            {
               _loc3_ = this.ItemList_mc.selectedEntry;
               if((_loc4_ = int(_loc3_.uCount)) < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU)
               {
                  _loc5_ = {
                     "uItemHandle":_loc3_.uHandleID,
                     "uCount":1
                  };
                  BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_JETTISON,_loc5_));
               }
               else
               {
                  this.ConfirmWindow_mc.Jettisoning = true;
                  if(this.m_State == this.state_ContainerCategoryList || this.m_State == this.state_ContainerItemList)
                  {
                     this.ConfirmWindow_mc.IsContainer = true;
                     this.ConfirmWindow_mc.IsFromShip = false;
                  }
                  else if(this.m_State == this.state_PlayerCategoryList || this.m_State == this.state_PlayerItemList)
                  {
                     this.ConfirmWindow_mc.IsContainer = false;
                     this.ConfirmWindow_mc.IsFromShip = false;
                  }
                  else
                  {
                     this.ConfirmWindow_mc.IsContainer = false;
                     this.ConfirmWindow_mc.IsFromShip = true;
                  }
                  this.ConfirmWindow_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_ContainerTransfer","$JETTISON ALL");
                  this.TransitionToState(this.state_ConfirmWindow,false);
               }
            }
            else if(this.ItemList_mc.selectedEntry != null)
            {
               _loc6_ = 0;
               if(this.m_State == this.state_ContainerCategoryList || this.m_State == this.state_ContainerItemList)
               {
                  _loc6_ = uint(this.ContainerInventoryData.uHandle);
               }
               else if(this.m_State == this.state_PlayerCategoryList || this.m_State == this.state_PlayerItemList)
               {
                  _loc6_ = uint(this.PlayerInventoryData.uHandle);
               }
               else
               {
                  _loc6_ = uint(this.ShipInventoryData.uHandle);
               }
               _loc7_ = {
                  "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
                  "uContainerHandle":_loc6_
               };
               BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_TOGGLE_EQUIP,_loc7_));
            }
         }
      }
      
      private function TakeAll() : void
      {
         var _loc1_:Object = null;
         if(Boolean(this.ContainerInventoryData) && Boolean(this.PlayerInventoryData))
         {
            _loc1_ = {
               "uFromContainerHandle":this.ContainerInventoryData.uHandle,
               "uToContainerHandle":this.PlayerInventoryData.uHandle
            };
            BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_TAKE_ALL,_loc1_));
         }
      }
      
      private function onEntryRollover() : void
      {
         if(this.m_State != null)
         {
            this.m_State(this.LIST_ITEM_ROLLOVER);
         }
      }
      
      private function onReturnToGameplay() : void
      {
         BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
         this.ReturningToGameplay = true;
         this.CloseMenu();
      }
      
      private function playFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function onContainerMenuDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_.bInitialized)
         {
            this.uContainerMode = _loc2_.uMode;
            this.bContainerIsMannequin = _loc2_.bIsMannequin;
            ContainerItem.IsStealing = this.uContainerMode == CM_STEALING_FROM_CONTAINER;
            if(this.bAcquiredContainerData)
            {
               this.ItemList_mc.ReinitializeEntries();
            }
            this.TransferDirection = _loc2_.uTransferDirection;
            this.ToContainerButtonData.sButtonText = _loc2_.sContainerTitle;
            this.sContainerTitle = _loc2_.sContainerTitle.toUpperCase();
            if(!this.bAcquiredMenuData && Boolean(_loc2_.bShipFirst))
            {
               this.TransitionToState(this.state_ShipCategoryList);
            }
            this.DataMenuIsOpen = _loc2_.bDataMenuIsOpen;
            this.bAcquiredMenuData = true;
            this.UpdateButtonHints();
         }
      }
      
      private function onPlayerInventoryUpdate(param1:FromClientDataEvent) : void
      {
         this.PlayerInventoryData = param1.data;
         if(this.m_State == this.state_PlayerCategoryList || this.m_State == this.state_PlayerItemList || this.m_State == this.state_ConfirmWindow && !this.ConfirmWindow_mc.IsContainer && !this.ConfirmWindow_mc.IsFromShip)
         {
            this.UpdateListsWithPlayerInventory();
         }
         else
         {
            this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_YOUR_CREDITS);
            GlobalFunc.SetText(this.Footer_Value_tf,this.PlayerInventoryData.uCoin.toString());
         }
         this.UpdateFeaturedItems();
      }
      
      private function onShipInventoryUpdate(param1:FromClientDataEvent) : void
      {
         this.ShipInventoryData = param1.data;
         this.ToShipButtonData.sButtonText = this.ShipInventoryData.sContainerName;
         if(this.ShipInventoryData.aCategories.length > 0)
         {
            this.bHasShipInventoryDataToDisplay = true;
         }
         if(this.m_State == this.state_ShipCategoryList || this.m_State == this.state_ShipItemList || this.m_State == this.state_ConfirmWindow && !this.ConfirmWindow_mc.IsContainer && this.ConfirmWindow_mc.IsFromShip)
         {
            this.UpdateListsWithShipInventory();
         }
      }
      
      private function onContainerInventoryUpdate(param1:FromClientDataEvent) : void
      {
         this.ContainerInventoryData = param1.data;
         var _loc2_:* = true;
         if(!this.bAcquiredContainerData)
         {
            if(this.ContainerInventoryData.bInitialized)
            {
               this.bAcquiredContainerData = true;
               if(this.ContainerInventoryData.aItems.length > 0 && this.ContainerInventoryData.aItems.length < this.MAX_NUMBER_OF_ITEMS_FOR_OPENING_ALL)
               {
                  _loc2_ = !this.OpenContainerAllCategory();
               }
            }
            else
            {
               _loc2_ = false;
            }
         }
         if(_loc2_)
         {
            if(this.m_State == null || this.m_State == this.state_ContainerCategoryList || this.m_State == this.state_ContainerItemList || this.m_State == this.state_ConfirmWindow && this.ConfirmWindow_mc.IsContainer)
            {
               this.UpdateListsWithContainerInventory();
            }
         }
      }
      
      private function GetCurrentSortIndex() : uint
      {
         var _loc1_:* = 0;
         if(this.SortPerCategory[this.CurrFilter] != null)
         {
            _loc1_ = this.SortPerCategory[this.CurrFilter];
         }
         return _loc1_;
      }
      
      private function CycleSortIndex() : uint
      {
         var _loc1_:uint = this.GetCurrentSortIndex();
         _loc1_ = (_loc1_ + 1) % this.SortOptions.length;
         this.SortPerCategory[this.CurrFilter] = _loc1_;
         return _loc1_;
      }
      
      public function SortItemList() : *
      {
         var _loc1_:uint = this.GetCurrentSortIndex();
         if(this.SortOptions[_loc1_].sortFunc != null)
         {
            this.ItemList_mc.SortEntries(this.SortOptions[_loc1_].sortFunc);
         }
      }
      
      private function UpdateSortButtonText() : *
      {
         var _loc1_:uint = this.GetCurrentSortIndex();
         this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc1_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
      }
      
      private function UpdateListsWithPlayerInventory() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.PlayerInventoryData)
         {
            this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_YOUR_CREDITS);
            GlobalFunc.SetText(this.Footer_Value_tf,this.PlayerInventoryData.uCoin.toString());
            ContainerItem.IsContainerItemList = false;
            _loc1_ = uint(this.PlayerInventoryData.fEncumbrance);
            _loc2_ = uint(this.PlayerInventoryData.fMaxEncumbrance);
            GlobalFunc.SetText(this.Footer_Weight_tf,_loc1_ + "/" + _loc2_);
            this.ItemDataA = this.PlayerInventoryData.aItems;
            this.CategoryList_mc.InitializeEntries(this.PlayerInventoryData.aCategories);
            this.ItemList_mc.InitializeEntries(this.PlayerInventoryData.aItems);
            this.SortItemList();
            if(this.m_State == this.state_PlayerItemList)
            {
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < this.PlayerInventoryData.aCategories.length)
               {
                  if(this.PlayerInventoryData.aCategories[_loc4_].iFilterFlags === this.CurrFilter)
                  {
                     if(this.PlayerInventoryData.aCategories[_loc4_].uTotalItemCount > 0)
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc3_)
               {
                  this.TransitionToState(this.state_PlayerCategoryList);
               }
               else
               {
                  this.m_State(this.LIST_ITEM_ROLLOVER);
               }
            }
         }
      }
      
      private function UpdateListsWithShipInventory() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.ShipInventoryData)
         {
            this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_YOUR_CREDITS);
            GlobalFunc.SetText(this.Footer_Value_tf,!!this.PlayerInventoryData ? String(this.PlayerInventoryData.uCoin.toString()) : "0");
            if(this.ShipInventoryData.fMaxEncumbrance > 0)
            {
               _loc1_ = uint(this.ShipInventoryData.fEncumbrance);
               _loc2_ = uint(this.ShipInventoryData.fMaxEncumbrance);
               GlobalFunc.SetText(this.Footer_Weight_tf,_loc1_ + "/" + _loc2_);
            }
            else
            {
               GlobalFunc.SetText(this.Footer_Weight_tf,"-/-");
            }
            ContainerItem.IsContainerItemList = false;
            this.ItemDataA = this.ShipInventoryData.aItems;
            this.CategoryList_mc.InitializeEntries(this.ShipInventoryData.aCategories);
            this.ItemList_mc.InitializeEntries(this.ShipInventoryData.aItems);
            this.SortItemList();
            if(this.m_State == this.state_ShipItemList)
            {
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < this.ShipInventoryData.aCategories.length)
               {
                  if(this.ShipInventoryData.aCategories[_loc4_].iFilterFlags === this.CurrFilter)
                  {
                     if(this.ShipInventoryData.aCategories[_loc4_].uTotalItemCount > 0)
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc3_)
               {
                  this.TransitionToState(this.state_ShipCategoryList);
               }
               else
               {
                  this.m_State(this.LIST_ITEM_ROLLOVER);
               }
            }
         }
      }
      
      private function UpdateListsWithContainerInventory() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.ContainerInventoryData)
         {
            ContainerItem.IsContainerItemList = true;
            this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_YOUR_CREDITS);
            GlobalFunc.SetText(this.Footer_Value_tf,!!this.PlayerInventoryData ? String(this.PlayerInventoryData.uCoin.toString()) : "0");
            if(this.ContainerInventoryData.fMaxEncumbrance > 0)
            {
               _loc1_ = uint(this.ContainerInventoryData.fEncumbrance);
               _loc2_ = uint(this.ContainerInventoryData.fMaxEncumbrance);
               GlobalFunc.SetText(this.Footer_Weight_tf,_loc1_ + "/" + _loc2_);
            }
            else
            {
               GlobalFunc.SetText(this.Footer_Weight_tf,"-/-");
            }
            this.ItemDataA = this.ContainerInventoryData.aItems;
            this.CategoryList_mc.InitializeEntries(this.ContainerInventoryData.aCategories);
            this.ItemList_mc.InitializeEntries(this.ContainerInventoryData.aItems);
            this.SortItemList();
            if(!this.bInitialized)
            {
               this.bInitialized = true;
               this.TransitionToState(this.state_ContainerCategoryList,false);
               this.CategoryList_mc.selectedIndex = 0;
               addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.playFocusSound);
            }
            else if(this.m_State == this.state_ContainerItemList)
            {
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < this.ContainerInventoryData.aCategories.length)
               {
                  if(this.ContainerInventoryData.aCategories[_loc4_].iFilterFlags === this.CurrFilter)
                  {
                     if(this.ContainerInventoryData.aCategories[_loc4_].uTotalItemCount > 0)
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc3_)
               {
                  this.TransitionToState(this.state_ContainerCategoryList);
               }
               else
               {
                  this.m_State(this.LIST_ITEM_ROLLOVER);
               }
            }
         }
      }
      
      private function onFireForgetEvent(param1:FromClientDataEvent) : void
      {
         if(GlobalFunc.HasFireForgetEvent(param1.data,"Inventory_MouseInspectStop"))
         {
            this.CategoryList_mc.disableInput = false;
            this.ItemList_mc.disableInput = false;
         }
         else if(GlobalFunc.HasFireForgetEvent(param1.data,"Inventory_MouseInspectStart"))
         {
            this.CategoryList_mc.disableInput = true;
            this.ItemList_mc.disableInput = true;
         }
      }
      
      private function SortItemsByName(param1:Object, param2:Object) : int
      {
         var _loc3_:String = String(param1.sName.toUpperCase());
         var _loc4_:String = String(param2.sName.toUpperCase());
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return this.SortItemsByHandle(param1,param2);
      }
      
      private function SortItemsByDamage(param1:Object, param2:Object) : int
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         for each(_loc5_ in param1.aElementalStats)
         {
            _loc3_ += _loc5_.fValue;
         }
         for each(_loc6_ in param2.aElementalStats)
         {
            _loc4_ += _loc6_.fValue;
         }
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return this.SortItemsByName(param1,param2);
      }
      
      private function SortItemsByValue(param1:Object, param2:Object) : int
      {
         var _loc3_:Number = Number(param1.uValue);
         var _loc4_:Number = Number(param2.uValue);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return this.SortItemsByName(param1,param2);
      }
      
      private function SortItemsByWeight(param1:Object, param2:Object) : int
      {
         var _loc3_:Number = GlobalFunc.RoundDecimal(param1.fWeight,2);
         var _loc4_:Number = GlobalFunc.RoundDecimal(param2.fWeight,2);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return this.SortItemsByName(param1,param2);
      }
      
      private function SortItemsByType(param1:Object, param2:Object) : int
      {
         var _loc3_:* = param1.WeaponInfo.sBaseName.toUpperCase();
         var _loc4_:* = param2.WeaponInfo.sBaseName.toUpperCase();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return this.SortItemsByDamage(param1,param2);
      }
      
      private function SortItemsByAmmo(param1:Object, param2:Object) : int
      {
         var _loc3_:* = param1.WeaponInfo.sAmmoType.toUpperCase();
         var _loc4_:* = param2.WeaponInfo.sAmmoType.toUpperCase();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return this.SortItemsByName(param1,param2);
      }
      
      private function SortItemsByColumn(param1:Object, param2:Object) : int
      {
         var _loc3_:Number = ContainerColumnValueHelper.GetColumnSortVal(this.CurrFilter,param1);
         var _loc4_:Number = ContainerColumnValueHelper.GetColumnSortVal(this.CurrFilter,param2);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return this.SortItemsByHandle(param1,param2);
      }
      
      private function SortItemsByHandle(param1:Object, param2:Object) : int
      {
         if(param1.uHandleID < param2.uHandleID)
         {
            return -1;
         }
         if(param1.uHandleID > param2.uHandleID)
         {
            return 1;
         }
         return 0;
      }
      
      private function UpdateButtonHints() : *
      {
         this.Title_mc.gotoAndStop(this.InContainerStates() ? this.TITLE_CONTAINER_STATE : (this.InPlayerStates() ? this.TITLE_PLAYER_STATE : this.TITLE_SHIP_STATE));
         if(this.InContainerStates())
         {
            GlobalFunc.SetText(this.Title_mc.ContainerHeader_mc.Label_tf,this.sContainerTitle,false,false,this.CONTAINER_TITLE_MAX_LENGTH);
         }
         else if(this.InShipStates() && Boolean(this.ShipInventoryData))
         {
            GlobalFunc.SetText(this.Title_mc.ContainerHeader_mc.Label_tf,this.ShipInventoryData.sContainerName.toUpperCase(),false,false,this.CONTAINER_TITLE_MAX_LENGTH);
         }
         if(this.m_State == this.state_InspectMode)
         {
            this.SwapInventoriesButton.Visible = false;
         }
         else
         {
            this.SwapInventoriesButton.Visible = true;
            this.SwapInventoriesButton.SetButtonData(this.InContainerStates() ? this.ToPlayerButtonData : (this.InPlayerStates() ? (this.bHasShipInventoryDataToDisplay ? this.ToShipButtonData : this.ToContainerButtonData) : this.ToContainerButtonData));
         }
         if(this.ContainerInventoryData)
         {
            this.TakeAllButtonData.bVisible = this.InContainerStates() && this.canTake;
            this.TakeAllButtonData.bEnabled = this.ContainerInventoryData.aItems.length > 0 && this.canTake && this.TakeAllButtonData.bVisible;
            this.TakeAllButton.SetButtonData(this.TakeAllButtonData);
         }
         this.ButtonBar_mc.RefreshButtons();
         this.UpdatePerItemButtonHints();
      }
      
      private function UpdateSortOptions() : *
      {
         this.SortOptions = new Array();
         this.SortButton.SetButtonData(new ButtonBaseData("$SORT",[new UserEventData("L3",this.ToggleSort)],true,true));
         switch(this.CurrFilter)
         {
            case InventoryItemUtils.ICF_WEAPONS:
               this.SortOptions.push(this.SORT_NAME);
               this.SortOptions.push(this.SORT_DMG_DESC);
               this.SortOptions.push(this.SORT_VALUE_DESC);
               this.SortOptions.push(this.SORT_WEIGHT_DESC);
               this.SortOptions.push(this.SORT_TYPE);
               this.SortOptions.push(this.SORT_AMMO);
               break;
            case InventoryItemUtils.ICF_THROWABLES:
               this.SortOptions.push(this.SORT_NAME);
               this.SortOptions.push(this.SORT_DMG_DESC);
               this.SortOptions.push(this.SORT_VALUE_DESC);
               this.SortOptions.push(this.SORT_WEIGHT_DESC);
               break;
            case InventoryItemUtils.ICF_SPACESUITS:
            case InventoryItemUtils.ICF_BACKPACKS:
            case InventoryItemUtils.ICF_HELMETS:
            case InventoryItemUtils.ICF_APPAREL:
               this.SortOptions.push(this.SORT_NAME);
               this.SortOptions.push(this.SORT_ARMOR_DESC);
               this.SortOptions.push(this.SORT_VALUE_DESC);
               this.SortOptions.push(this.SORT_WEIGHT_DESC);
               break;
            default:
               this.SortOptions.push(this.SORT_NAME);
               this.SortOptions.push(this.SORT_VALUE_DESC);
               this.SortOptions.push(this.SORT_WEIGHT_DESC);
         }
         var _loc1_:uint = this.GetCurrentSortIndex();
         this.ItemList_mc.SortEntries(this.SortOptions[_loc1_].sortFunc);
         ContainerColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc1_].sortType);
      }
      
      private function UpdatePerItemButtonHints() : *
      {
         var _loc1_:* = false;
         var _loc2_:Boolean = false;
         this.AcceptButtonData.bVisible = this.m_State == this.state_ContainerItemList && this.canTake || (this.m_State == this.state_PlayerItemList || this.m_State == this.state_ShipItemList) && this.canGive;
         this.AcceptButtonData.bEnabled = this.ItemList_mc.selectedEntry != null && this.AcceptButtonData.bVisible;
         if(this.m_State != this.state_ConfirmWindow)
         {
            _loc1_ = false;
            if(this.InContainerStates() && Boolean(this.ContainerInventoryData))
            {
               _loc1_ = this.ContainerInventoryData.aItems.length == 0;
            }
            else if(this.InPlayerStates() && Boolean(this.PlayerInventoryData))
            {
               _loc1_ = this.PlayerInventoryData.aItems.length == 0;
            }
            else if(this.InShipStates() && Boolean(this.ShipInventoryData))
            {
               _loc1_ = this.ShipInventoryData.aItems.length == 0;
            }
            this.AcceptButtonData.sButtonText = this.InContainerStates() ? (this.uContainerMode == CM_STEALING_FROM_CONTAINER ? "$STEAL" : "$TAKE") : (this.uContainerMode == CM_TEAMMATE ? "$TRADE" : "$STORE");
            this.AcceptButtonData.bEnabled = this.AcceptButtonData.bEnabled && !_loc1_;
         }
         this.AcceptButton.SetButtonData(this.AcceptButtonData);
         if((this.uContainerMode == CM_TEAMMATE || this.bContainerIsMannequin) && this.m_State == this.state_ContainerItemList || this.m_State == this.state_PlayerItemList)
         {
            this.EquipOrStoreButtonData.bVisible = this.ItemList_mc.selectedEntry != null && Boolean(this.ItemList_mc.selectedEntry.bCanEquip);
            this.EquipOrStoreButtonData.sButtonText = this.ItemList_mc.selectedEntry != null && Boolean(this.ItemList_mc.selectedEntry.bIsEquipped) ? "$UNEQUIP" : "$EQUIP";
            this.EquipOrStoreButtonData.bEnabled = this.ItemList_mc.selectedEntry != null;
         }
         else if(this.uContainerMode == CM_PLAYER_SHIP_TRANSFER && this.m_State == this.state_ContainerItemList)
         {
            this.AllResourcesButtonData.bVisible = this.canTake && this.CategoryList_mc.selectedEntry != null && this.CategoryList_mc.selectedEntry.iFilterFlags == InventoryItemUtils.ICF_RESOURCES;
            this.AllResourcesButtonData.bEnabled = this.AllResourcesButtonData.bVisible && this.ItemList_mc.selectedEntry != null;
            this.EquipOrStoreButtonData.bVisible = true;
            this.EquipOrStoreButtonData.sButtonText = "$Jettison";
            this.EquipOrStoreButtonData.bEnabled = this.ItemList_mc.selectedEntry != null;
         }
         else
         {
            this.EquipOrStoreButtonData.bVisible = false;
            this.EquipOrStoreButtonData.bEnabled = false;
         }
         if(this.uContainerMode != CM_WORKBENCH && (this.m_State == this.state_ContainerItemList || this.m_State == this.state_ShipItemList || this.m_State == this.state_PlayerItemList))
         {
            _loc2_ = this.m_State == this.state_ContainerItemList ? this.canTake : this.canGive;
            this.AllResourcesButtonData.bVisible = _loc2_ && Boolean(this.CategoryList_mc.selectedEntry) && this.CategoryList_mc.selectedEntry.iFilterFlags == InventoryItemUtils.ICF_RESOURCES;
            this.AllResourcesButtonData.bEnabled = this.AllResourcesButtonData.bVisible && this.ItemList_mc.selectedEntry != null;
            this.AllResourcesButtonData.sButtonText = this.m_State == this.state_PlayerItemList ? "$StoreAllResources" : "$TakeAllResources";
         }
         else
         {
            this.AllResourcesButtonData.bVisible = false;
            this.AllResourcesButtonData.bEnabled = false;
         }
         this.AllResourcesButton.SetButtonData(this.AllResourcesButtonData);
         this.EquipOrStoreButton.SetButtonData(this.EquipOrStoreButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function InContainerStates() : Boolean
      {
         return this.m_State == this.state_ContainerCategoryList || this.m_State == this.state_ContainerItemList || this.m_State == this.state_ConfirmWindow && Boolean(this.ConfirmWindow_mc.IsContainer);
      }
      
      private function InPlayerStates() : Boolean
      {
         return this.m_State == this.state_PlayerCategoryList || this.m_State == this.state_PlayerItemList || this.m_State == this.state_ConfirmWindow && !this.ConfirmWindow_mc.IsContainer && !this.ConfirmWindow_mc.IsFromShip;
      }
      
      private function InShipStates() : Boolean
      {
         return this.m_State == this.state_ShipCategoryList || this.m_State == this.state_ShipItemList || this.m_State == this.state_ConfirmWindow && Boolean(this.ConfirmWindow_mc.IsFromShip);
      }
      
      private function OpenContainerAllCategory() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.ContainerInventoryData.aCategories.length)
         {
            if(this.ContainerInventoryData.aCategories[_loc2_].iFilterFlags === InventoryItemUtils.ICF_ALL)
            {
               _loc1_ = true;
               this.CurrFilter = this.ContainerInventoryData.aCategories[_loc2_].iFilterFlags;
               ContainerItem.CurrFilter = this.CurrFilter;
               ContainerColumnValueHelper.ResetColumnIndex(this.CurrFilter);
               this.ItemList_mc.ReinitializeEntries();
               this.UpdateSortOptions();
               this.SortItemList();
               GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.ContainerInventoryData.aCategories[_loc2_].sName);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.UpdateFeaturedItems();
               if(!this.bInitialized)
               {
                  this.UpdateListsWithContainerInventory();
               }
               this.TransitionToState(this.state_ContainerItemList);
               this.ItemList_mc.selectedIndex = 0;
               this.m_State(this.LIST_ITEM_ROLLOVER);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function UpdateFeaturedItems() : *
      {
         var _loc3_:Object = null;
         var _loc8_:Object = null;
         this.FeaturedItemArray.splice(0,this.FeaturedItemArray.length);
         this.SecondaryFeaturedItemArray.splice(0,this.SecondaryFeaturedItemArray.length);
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc7_:* = false;
         if(this.m_State == this.state_ContainerCategoryList || this.m_State == this.state_ShipCategoryList)
         {
            _loc8_ = this.m_State == this.state_ContainerCategoryList ? this.ContainerInventoryData : this.ShipInventoryData;
            if(Boolean(this.PlayerInventoryData) && _loc8_ != null)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc8_.aCategories.length)
               {
                  if(_loc8_.aCategories[_loc1_].bShowFeaturedItem)
                  {
                     _loc4_ = false;
                     _loc5_ = false;
                     _loc2_ = 0;
                     while(_loc2_ < this.PlayerInventoryData.aCategories.length && !_loc4_ && !_loc5_)
                     {
                        if(this.PlayerInventoryData.aCategories[_loc2_].iFilterFlags == _loc8_.aCategories[_loc1_].iFilterFlags)
                        {
                           _loc6_ = this.PlayerInventoryData.aCategories[_loc2_].uFeaturedItemHandle != 0;
                           _loc7_ = this.PlayerInventoryData.aCategories[_loc2_].uSecondaryFeaturedItemHandle != 0;
                           _loc4_ = !_loc6_;
                           _loc5_ = !_loc7_;
                           if(_loc6_ || _loc7_)
                           {
                              for each(_loc3_ in this.PlayerInventoryData.aItems)
                              {
                                 if(!_loc4_ && _loc3_.uHandleID == this.PlayerInventoryData.aCategories[_loc2_].uFeaturedItemHandle)
                                 {
                                    this.FeaturedItemArray.push({
                                       "filterFlag":_loc3_.iFilterFlag & this.PlayerInventoryData.aCategories[_loc2_].iFilterFlags,
                                       "itemData":_loc3_
                                    });
                                    _loc4_ = true;
                                 }
                                 if(!_loc5_ && _loc3_.uHandleID == this.PlayerInventoryData.aCategories[_loc2_].uSecondaryFeaturedItemHandle)
                                 {
                                    this.SecondaryFeaturedItemArray.push({
                                       "filterFlag":_loc3_.iFilterFlag & this.PlayerInventoryData.aCategories[_loc2_].iFilterFlags,
                                       "itemData":_loc3_
                                    });
                                    _loc5_ = true;
                                 }
                                 if(_loc4_ && _loc5_)
                                 {
                                    break;
                                 }
                              }
                           }
                        }
                        _loc2_++;
                     }
                  }
                  _loc1_++;
               }
            }
         }
         else if(this.PlayerInventoryData)
         {
            _loc1_ = 0;
            while(_loc1_ < this.PlayerInventoryData.aCategories.length)
            {
               if(this.PlayerInventoryData.aCategories[_loc1_].bShowFeaturedItem)
               {
                  _loc6_ = this.PlayerInventoryData.aCategories[_loc1_].uFeaturedItemHandle != 0;
                  _loc7_ = this.PlayerInventoryData.aCategories[_loc1_].uSecondaryFeaturedItemHandle != 0;
                  _loc4_ = !_loc6_;
                  _loc5_ = !_loc7_;
                  if(_loc6_ || _loc7_)
                  {
                     for each(_loc3_ in this.PlayerInventoryData.aItems)
                     {
                        if(!_loc4_ && _loc3_.uHandleID == this.PlayerInventoryData.aCategories[_loc1_].uFeaturedItemHandle)
                        {
                           this.FeaturedItemArray.push({
                              "filterFlag":_loc3_.iFilterFlag & this.PlayerInventoryData.aCategories[_loc1_].iFilterFlags,
                              "itemData":_loc3_
                           });
                           _loc4_ = true;
                        }
                        if(!_loc5_ && _loc3_.uHandleID == this.PlayerInventoryData.aCategories[_loc1_].uSecondaryFeaturedItemHandle)
                        {
                           this.SecondaryFeaturedItemArray.push({
                              "filterFlag":_loc3_.iFilterFlag & this.PlayerInventoryData.aCategories[_loc1_].iFilterFlags,
                              "itemData":_loc3_
                           });
                           _loc5_ = true;
                        }
                        if(_loc4_ && _loc5_)
                        {
                           break;
                        }
                     }
                  }
               }
               _loc1_++;
            }
         }
      }
      
      private function GetFeaturedItem(param1:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         if((param1.iFilterFlag & InventoryItemUtils.ICF_APPAREL) != 0)
         {
            _loc3_ = Boolean(param1.ArmorInfo.bIsHeadgear);
         }
         for each(_loc4_ in _loc3_ ? this.SecondaryFeaturedItemArray : this.FeaturedItemArray)
         {
            if((param1.iFilterFlag & _loc4_.filterFlag) != 0)
            {
               _loc2_ = _loc4_.itemData;
               break;
            }
         }
         return _loc2_;
      }
      
      public function onMouseOverModel(param1:MouseEvent) : void
      {
         this.mouseOverModel = true;
      }
      
      public function onMouseOutModel(param1:MouseEvent) : void
      {
         this.mouseOverModel = false;
      }
      
      protected function TransitionToState(param1:Function, param2:Boolean = true) : void
      {
         this.m_previousState = this.m_State;
         if(param2)
         {
            this.m_State(this.EXIT_STATE);
         }
         this.m_State = param1;
         this.m_State(this.ENTER_STATE);
         this.UpdateButtonHints();
      }
      
      protected function state_ContainerCategoryList(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryHeader_mc.visible = true;
               this.CategoryList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.SortButton.Visible = false;
               this.CompareToEquippedButton.Visible = false;
               this.InspectButton.Visible = false;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCard_mc.visible = false;
               stage.focus = this.CategoryList_mc;
               BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
               break;
            case this.LIST_ITEM_PRESS:
               if(this.ContainerInventoryData.aItems.length > 0 && this.CategoryList_mc.selectedEntry.uTotalItemCount > 0)
               {
                  this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
                  ContainerItem.CurrFilter = this.CurrFilter;
                  ContainerColumnValueHelper.ResetColumnIndex(this.CurrFilter);
                  this.ItemList_mc.ReinitializeEntries();
                  this.UpdateSortOptions();
                  this.SortItemList();
                  GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
                  GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
                  this.UpdateFeaturedItems();
                  this.TransitionToState(this.state_ContainerItemList);
                  this.ItemList_mc.selectedIndex = 0;
                  this.m_State(this.LIST_ITEM_ROLLOVER);
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               }
               else
               {
                  GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               }
               break;
            case this.CANCEL_PRESS:
               this.CloseMenu();
               break;
            case this.SWAP_INVENTORIES:
               this.TransitionToState(this.state_PlayerCategoryList);
               this.UpdateListsWithPlayerInventory();
               break;
            case this.EXIT_STATE:
               this.CategoryHeader_mc.visible = false;
               this.CategoryList_mc.visible = false;
         }
      }
      
      protected function state_PlayerCategoryList(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryHeader_mc.visible = true;
               this.CategoryList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCard_mc.visible = false;
               this.SortButton.Visible = false;
               this.CompareToEquippedButton.Visible = false;
               this.InspectButton.Visible = false;
               stage.focus = this.CategoryList_mc;
               BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
               break;
            case this.LIST_ITEM_PRESS:
               if(this.PlayerInventoryData.aItems.length > 0)
               {
                  this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
                  ContainerItem.CurrFilter = this.CurrFilter;
                  ContainerColumnValueHelper.ResetColumnIndex(this.CurrFilter);
                  this.ItemList_mc.ReinitializeEntries();
                  this.UpdateSortOptions();
                  this.SortItemList();
                  GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
                  GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
                  this.UpdateFeaturedItems();
                  this.TransitionToState(this.state_PlayerItemList);
                  this.ItemList_mc.selectedIndex = 0;
                  this.m_State(this.LIST_ITEM_ROLLOVER);
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               }
               else
               {
                  GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               }
               break;
            case this.CANCEL_PRESS:
               this.CloseMenu();
               break;
            case this.SWAP_INVENTORIES:
               if(this.bHasShipInventoryDataToDisplay)
               {
                  this.TransitionToState(this.state_ShipCategoryList);
                  this.UpdateListsWithShipInventory();
               }
               else
               {
                  this.TransitionToState(this.state_ContainerCategoryList);
                  this.UpdateListsWithContainerInventory();
               }
               break;
            case this.EXIT_STATE:
               this.CategoryHeader_mc.visible = false;
               this.CategoryList_mc.visible = false;
         }
      }
      
      protected function state_ShipCategoryList(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryHeader_mc.visible = true;
               this.CategoryList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCard_mc.visible = false;
               this.SortButton.Visible = false;
               this.CompareToEquippedButton.Visible = false;
               this.InspectButton.Visible = false;
               stage.focus = this.CategoryList_mc;
               BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
               break;
            case this.LIST_ITEM_PRESS:
               if(this.ShipInventoryData.aItems.length > 0)
               {
                  this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
                  ContainerItem.CurrFilter = this.CurrFilter;
                  ContainerColumnValueHelper.ResetColumnIndex(this.CurrFilter);
                  this.ItemList_mc.ReinitializeEntries();
                  this.UpdateSortOptions();
                  this.SortItemList();
                  GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
                  GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
                  this.UpdateFeaturedItems();
                  this.TransitionToState(this.state_ShipItemList);
                  this.ItemList_mc.selectedIndex = 0;
                  this.m_State(this.LIST_ITEM_ROLLOVER);
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               }
               else
               {
                  GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               }
               break;
            case this.CANCEL_PRESS:
               this.CloseMenu();
               break;
            case this.SWAP_INVENTORIES:
               this.TransitionToState(this.state_ContainerCategoryList);
               this.UpdateListsWithContainerInventory();
               break;
            case this.EXIT_STATE:
               this.CategoryHeader_mc.visible = false;
               this.CategoryList_mc.visible = false;
         }
      }
      
      private function CloseMenu() : *
      {
         this.gotoAndPlay("closeMenu");
         if(!this.DataMenuIsOpen || this.ReturningToGameplay)
         {
            GlobalFunc.StartGameRender();
         }
      }
      
      private function OnCloseMenuFadeOutComplete() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuInventoryMenuClose");
         if(this.ReturningToGameplay)
         {
            GlobalFunc.CloseAllMenus();
         }
         else
         {
            BSUIDataManager.dispatchEvent(new Event("ContainerMenu_CloseMenu",true));
         }
      }
      
      protected function state_ContainerItemList(param1:int) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ItemHeader_mc.visible = true;
               this.ItemList_mc.visible = true;
               this.SortButton.Visible = true;
               this.CategoryFooter_mc.visible = true;
               this.InspectButton.Visible = true;
               this.ItemCard_mc.visible = true;
               this.EquippedItemCard_mc.visible = this.EquippedItemCardShouldBeVisible;
               this.CompareToEquippedButton.Visible = this.CompareToEquippedButtonShouldBeVisible;
               this.CompareToEquippedButton.Enabled = this.CompareToEquippedButtonShouldBeEnabled;
               stage.focus = this.ItemList_mc;
               this.UpdateSortButtonText();
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               if(Boolean(this.PlayerInventoryData) && this.canTake)
               {
                  if(GlobalFunc.CloseToNumber(this.ItemList_mc.selectedEntry.fWeight,0))
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_TRANSFER_ITEM,{
                        "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
                        "uCount":this.ItemList_mc.selectedEntry.uCount,
                        "uFromContainerHandle":this.ContainerInventoryData.uHandle,
                        "uToContainerHandle":this.PlayerInventoryData.uHandle
                     });
                  }
                  else if(this.ItemList_mc.selectedEntry.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_TRANSFER_ITEM,{
                        "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
                        "uCount":1,
                        "uFromContainerHandle":this.ContainerInventoryData.uHandle,
                        "uToContainerHandle":this.PlayerInventoryData.uHandle
                     });
                  }
                  else
                  {
                     this.ConfirmWindow_mc.IsContainer = true;
                     this.ConfirmWindow_mc.IsFromShip = false;
                     this.ConfirmWindow_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_ContainerTransfer","$TAKE ALL");
                     this.TransitionToState(this.state_ConfirmWindow,false);
                  }
               }
               break;
            case this.LIST_ITEM_ROLLOVER:
               if(this.ItemList_mc.selectedEntry)
               {
                  if(this.ItemList_mc.selectedEntry.uHandleID != this.CurrShownModel)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_LOAD_3D_MODEL,{
                        "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
                        "iFilterFlag":this.ItemList_mc.selectedEntry.iFilterFlag
                     });
                     this.CurrShownModel = this.ItemList_mc.selectedEntry.uHandleID;
                  }
                  _loc3_ = this.GetFeaturedItem(this.ItemList_mc.selectedEntry);
                  if(_loc3_ == null)
                  {
                     _loc3_ = this.ItemList_mc.selectedEntry;
                     this.CompareToEquippedButton.Visible = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                  }
                  else
                  {
                     this.CompareToEquippedButton.Visible = true;
                     this.CompareToEquippedButton.Enabled = true;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = this.bEquipCardWasVisible;
                     this.EquippedItemCard_mc.SetItemData(_loc3_,_loc3_);
                  }
                  this.ItemCard_mc.SetItemData(this.ItemList_mc.selectedEntry,_loc3_);
                  this.ItemCard_mc.visible = true;
               }
               this.UpdatePerItemButtonHints();
               break;
            case this.CANCEL_PRESS:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.TransitionToState(this.state_ContainerCategoryList);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc2_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
               ContainerColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.ItemList_mc.ReinitializeEntries();
               this.SortItemList();
               this.ButtonBar_mc.RefreshButtons();
               GlobalFunc.PlayMenuSound("UIMenuGeneralColumn");
               break;
            case this.SWAP_INVENTORIES:
               this.TransitionToState(this.state_PlayerCategoryList);
               this.UpdateListsWithPlayerInventory();
               break;
            case this.SHOW_EQUIPPED_STATS:
               if(this.CompareToEquippedButton.Visible)
               {
                  this.EquippedItemCard_mc.visible = !this.EquippedItemCard_mc.visible;
                  this.bEquipCardWasVisible = this.EquippedItemCard_mc.visible;
               }
               break;
            case this.INSPECT_PRESS:
               this.TransitionToState(this.state_InspectMode);
               break;
            case this.EXIT_STATE:
               this.ItemHeader_mc.visible = false;
               this.ItemList_mc.visible = false;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCardShouldBeVisible = this.EquippedItemCard_mc.visible;
               this.EquippedItemCard_mc.visible = false;
               this.CompareToEquippedButtonShouldBeVisible = this.CompareToEquippedButton.Visible;
               this.CompareToEquippedButtonShouldBeEnabled = this.CompareToEquippedButton.Enabled;
               this.CurrShownModel = 0;
         }
      }
      
      protected function state_PlayerItemList(param1:int) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ItemHeader_mc.visible = true;
               this.ItemList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.SortButton.Visible = true;
               this.InspectButton.Visible = true;
               stage.focus = this.ItemList_mc;
               this.UpdateSortButtonText();
               this.ButtonBar_mc.RefreshButtons();
               this.ItemCard_mc.visible = true;
               this.EquippedItemCard_mc.visible = this.EquippedItemCardShouldBeVisible;
               this.CompareToEquippedButton.Visible = this.CompareToEquippedButtonShouldBeVisible;
               this.CompareToEquippedButton.Enabled = this.CompareToEquippedButtonShouldBeEnabled;
               break;
            case this.LIST_ITEM_PRESS:
               if(Boolean(this.ContainerInventoryData) && this.canGive)
               {
                  if(this.ItemList_mc.selectedEntry.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_TRANSFER_ITEM,{
                        "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
                        "uCount":1,
                        "uFromContainerHandle":this.PlayerInventoryData.uHandle,
                        "uToContainerHandle":this.ContainerInventoryData.uHandle
                     });
                  }
                  else
                  {
                     this.ConfirmWindow_mc.IsContainer = false;
                     this.ConfirmWindow_mc.IsFromShip = false;
                     this.ConfirmWindow_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_ContainerTransfer","$STORE ALL");
                     this.TransitionToState(this.state_ConfirmWindow,false);
                  }
               }
               break;
            case this.LIST_ITEM_ROLLOVER:
               if(this.ItemList_mc.selectedEntry)
               {
                  if(this.ItemList_mc.selectedEntry.uHandleID != this.CurrShownModel)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_LOAD_3D_MODEL,{
                        "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
                        "iFilterFlag":this.ItemList_mc.selectedEntry.iFilterFlag
                     });
                     this.CurrShownModel = this.ItemList_mc.selectedEntry.uHandleID;
                  }
                  _loc3_ = this.GetFeaturedItem(this.ItemList_mc.selectedEntry);
                  if(_loc3_ == null)
                  {
                     _loc3_ = this.ItemList_mc.selectedEntry;
                     this.CompareToEquippedButton.Visible = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                  }
                  else
                  {
                     this.CompareToEquippedButton.Visible = true;
                     this.CompareToEquippedButton.Enabled = true;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = this.bEquipCardWasVisible;
                     this.EquippedItemCard_mc.SetItemData(_loc3_,_loc3_);
                  }
                  this.ItemCard_mc.SetItemData(this.ItemList_mc.selectedEntry,_loc3_);
                  this.ItemCard_mc.visible = true;
               }
               this.UpdatePerItemButtonHints();
               break;
            case this.CANCEL_PRESS:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.TransitionToState(this.state_PlayerCategoryList);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc2_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
               ContainerColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.ItemList_mc.ReinitializeEntries();
               this.SortItemList();
               this.ButtonBar_mc.RefreshButtons();
               GlobalFunc.PlayMenuSound("UIMenuGeneralColumn");
               break;
            case this.SWAP_INVENTORIES:
               if(this.bHasShipInventoryDataToDisplay)
               {
                  this.TransitionToState(this.state_ShipCategoryList);
                  this.UpdateListsWithShipInventory();
               }
               else
               {
                  this.TransitionToState(this.state_ContainerCategoryList);
                  this.UpdateListsWithContainerInventory();
               }
               break;
            case this.SHOW_EQUIPPED_STATS:
               if(this.CompareToEquippedButton.Visible)
               {
                  this.EquippedItemCard_mc.visible = !this.EquippedItemCard_mc.visible;
                  this.bEquipCardWasVisible = this.EquippedItemCard_mc.visible;
               }
               break;
            case this.INSPECT_PRESS:
               this.TransitionToState(this.state_InspectMode);
               break;
            case this.EXIT_STATE:
               this.ItemHeader_mc.visible = false;
               this.ItemList_mc.visible = false;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCardShouldBeVisible = this.EquippedItemCard_mc.visible;
               this.EquippedItemCard_mc.visible = false;
               this.CompareToEquippedButtonShouldBeVisible = this.CompareToEquippedButton.Visible;
               this.CompareToEquippedButtonShouldBeEnabled = this.CompareToEquippedButton.Enabled;
               this.CurrShownModel = 0;
         }
      }
      
      protected function state_ShipItemList(param1:int) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ItemHeader_mc.visible = true;
               this.ItemList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.SortButton.Visible = true;
               this.InspectButton.Visible = true;
               this.ItemCard_mc.visible = true;
               this.EquippedItemCard_mc.visible = this.EquippedItemCardShouldBeVisible;
               this.CompareToEquippedButton.Visible = this.CompareToEquippedButtonShouldBeVisible;
               this.CompareToEquippedButton.Enabled = this.CompareToEquippedButtonShouldBeEnabled;
               stage.focus = this.ItemList_mc;
               this.UpdateSortButtonText();
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               if(Boolean(this.ContainerInventoryData) && this.canGive)
               {
                  if(this.ItemList_mc.selectedEntry.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_TRANSFER_ITEM,{
                        "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
                        "uCount":1,
                        "uFromContainerHandle":this.ShipInventoryData.uHandle,
                        "uToContainerHandle":this.ContainerInventoryData.uHandle
                     });
                  }
                  else
                  {
                     this.ConfirmWindow_mc.IsFromShip = true;
                     this.ConfirmWindow_mc.IsContainer = false;
                     this.ConfirmWindow_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_ContainerTransfer","$STORE ALL");
                     this.TransitionToState(this.state_ConfirmWindow,false);
                  }
               }
               break;
            case this.LIST_ITEM_ROLLOVER:
               if(this.ItemList_mc.selectedEntry)
               {
                  if(this.ItemList_mc.selectedEntry.uHandleID != this.CurrShownModel)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_LOAD_3D_MODEL,{
                        "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
                        "iFilterFlag":this.ItemList_mc.selectedEntry.iFilterFlag
                     });
                     this.CurrShownModel = this.ItemList_mc.selectedEntry.uHandleID;
                  }
                  _loc3_ = this.GetFeaturedItem(this.ItemList_mc.selectedEntry);
                  if(_loc3_ == null)
                  {
                     _loc3_ = this.ItemList_mc.selectedEntry;
                     this.CompareToEquippedButton.Visible = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                  }
                  else
                  {
                     this.CompareToEquippedButton.Visible = true;
                     this.CompareToEquippedButton.Enabled = true;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = this.bEquipCardWasVisible;
                     this.EquippedItemCard_mc.SetItemData(_loc3_,_loc3_);
                  }
                  this.ItemCard_mc.SetItemData(this.ItemList_mc.selectedEntry,_loc3_);
                  this.ItemCard_mc.visible = true;
               }
               this.UpdatePerItemButtonHints();
               break;
            case this.CANCEL_PRESS:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.TransitionToState(this.state_ShipCategoryList);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc2_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
               ContainerColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,ContainerColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.ItemList_mc.ReinitializeEntries();
               this.SortItemList();
               this.ButtonBar_mc.RefreshButtons();
               GlobalFunc.PlayMenuSound("UIMenuGeneralColumn");
               break;
            case this.SWAP_INVENTORIES:
               this.TransitionToState(this.state_ContainerCategoryList);
               this.UpdateListsWithContainerInventory();
               break;
            case this.SHOW_EQUIPPED_STATS:
               if(this.CompareToEquippedButton.Visible)
               {
                  this.EquippedItemCard_mc.visible = !this.EquippedItemCard_mc.visible;
                  this.bEquipCardWasVisible = this.EquippedItemCard_mc.visible;
               }
               break;
            case this.INSPECT_PRESS:
               this.TransitionToState(this.state_InspectMode);
               break;
            case this.EXIT_STATE:
               this.ItemHeader_mc.visible = false;
               this.ItemList_mc.visible = false;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCardShouldBeVisible = this.EquippedItemCard_mc.visible;
               this.EquippedItemCard_mc.visible = false;
               this.CompareToEquippedButtonShouldBeVisible = this.CompareToEquippedButton.Visible;
               this.CompareToEquippedButtonShouldBeEnabled = this.CompareToEquippedButton.Enabled;
               this.CurrShownModel = 0;
         }
      }
      
      protected function state_ConfirmWindow(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ConfirmWindow_mc.visible = true;
               this.ButtonBar_mc.visible = false;
               this.ItemList_mc.disableInput = true;
               this.ConfirmWindow_mc.prevFocus = stage.focus;
               stage.focus = this.ConfirmWindow_mc;
               this.ConfirmWindow_mc.addEventListener(QuantityComponent.WINDOW_CLOSED,this.onConfirmWindowClosed);
               this.ConfirmWindow_mc.addEventListener(QuantityComponent.CONFIRM_TRANSACTION,this.onTransactionConfirmed);
               break;
            case this.EXIT_STATE:
               this.ConfirmWindow_mc.removeEventListener(QuantityComponent.WINDOW_CLOSED,this.onConfirmWindowClosed);
               this.ConfirmWindow_mc.removeEventListener(QuantityComponent.CONFIRM_TRANSACTION,this.onTransactionConfirmed);
               stage.focus = this.ConfirmWindow_mc.prevFocus;
               this.ConfirmWindow_mc.visible = false;
               this.ButtonBar_mc.visible = true;
               this.ItemList_mc.disableInput = false;
         }
      }
      
      private function state_InspectMode(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryList_mc.disableInput = true;
               this.ItemList_mc.disableInput = true;
               this.SortButton.Visible = false;
               this.CompareToEquippedButton.Visible = false;
               this.InspectButton.Visible = false;
               this.InspectButton.Enabled = true;
               this.CategoryFooter_mc.visible = false;
               this.ButtonBar_mc.RefreshButtons();
               gotoAndPlay("enterInspect");
               GlobalFunc.PlayMenuSound("UIMenuInventoryInspect");
               break;
            case this.CANCEL_PRESS:
            case this.INSPECT_PRESS:
               gotoAndPlay("exitInspect");
               this.TransitionToState(this.m_previousState);
               break;
            case this.EXIT_STATE:
               this.CategoryList_mc.disableInput = false;
               this.ItemList_mc.disableInput = false;
               GlobalFunc.PlayMenuSound("UIMenuInventoryInspect");
         }
      }
      
      private function onConfirmWindowClosed() : *
      {
         var _loc1_:Object = !!this.ConfirmWindow_mc.IsContainer ? this.ContainerInventoryData : (!!this.ConfirmWindow_mc.IsFromShip ? this.ShipInventoryData : this.PlayerInventoryData);
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.aCategories.length)
         {
            if(_loc1_.aCategories[_loc3_].iFilterFlags === this.CurrFilter)
            {
               if(_loc1_.aCategories[_loc3_].uTotalItemCount > 0)
               {
                  _loc2_ = true;
               }
               break;
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            this.ItemHeader_mc.visible = false;
            this.ItemList_mc.visible = false;
            this.ItemCard_mc.visible = false;
            this.CurrShownModel = 0;
            BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
            if(_loc1_ == this.ContainerInventoryData)
            {
               this.TransitionToState(this.state_ContainerCategoryList);
            }
            else if(_loc1_ == this.ShipInventoryData)
            {
               this.TransitionToState(this.state_ShipCategoryList);
            }
            else
            {
               this.TransitionToState(this.state_PlayerCategoryList);
            }
         }
         else if(_loc1_ == this.ContainerInventoryData)
         {
            this.TransitionToState(this.state_ContainerItemList);
         }
         else if(_loc1_ == this.ShipInventoryData)
         {
            this.TransitionToState(this.state_ShipItemList);
         }
         else
         {
            this.TransitionToState(this.state_PlayerItemList);
         }
         this.m_State(this.LIST_ITEM_ROLLOVER);
      }
      
      private function onTransactionConfirmed() : *
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         if(this.ConfirmWindow_mc.Jettisoning === true)
         {
            _loc1_ = {
               "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
               "uCount":this.ConfirmWindow_mc.CurrentQuantity
            };
            BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_JETTISON,_loc1_));
            this.ConfirmWindow_mc.Jettisoning = false;
         }
         else
         {
            _loc3_ = 0;
            if(this.ConfirmWindow_mc.IsContainer)
            {
               _loc2_ = this.ContainerInventoryData.uHandle;
               _loc3_ = uint(this.PlayerInventoryData.uHandle);
            }
            else if(this.ConfirmWindow_mc.IsFromShip)
            {
               _loc2_ = this.ShipInventoryData.uHandle;
               _loc3_ = uint(this.ContainerInventoryData.uHandle);
            }
            else
            {
               _loc2_ = this.PlayerInventoryData.uHandle;
               _loc3_ = uint(this.ContainerInventoryData.uHandle);
            }
            BSUIDataManager.dispatchCustomEvent(this.EVENT_TRANSFER_ITEM,{
               "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
               "uCount":this.ConfirmWindow_mc.CurrentQuantity,
               "uFromContainerHandle":_loc2_,
               "uToContainerHandle":_loc3_
            });
         }
      }
   }
}
