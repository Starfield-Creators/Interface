package
{
   import Components.QuantityComponent;
   import Shared.AS3.BS3DSceneRectManager;
   import Shared.AS3.BSAnimating3DSceneRect;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
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
   
   public class BarterMenu extends IMenu
   {
       
      
      public var Title_mc:MovieClip;
      
      public var CategoryHeader_mc:MovieClip;
      
      public var VendorCreditsHeader_mc:MovieClip;
      
      public var CategoryFooter_mc:MovieClip;
      
      public var CategoryList_mc:BSScrollingContainer;
      
      public var ItemHeader_mc:MovieClip;
      
      public var ItemList_mc:BSScrollingContainer;
      
      public var ItemCard_mc:InvItemCard;
      
      public var EquippedItemCard_mc:InvItemCard;
      
      public var PreviewSceneRect_mc:BSAnimating3DSceneRect;
      
      public var ConfirmWindow_mc:QuantityComponent;
      
      public var ButtonBar_mc:ButtonBar;
      
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
      
      private var BuyButtonData:ButtonBaseData;
      
      private var SellButtonData:ButtonBaseData;
      
      private var SellFromShipButtonData:ButtonBaseData;
      
      public const EVENT_LOAD_3D_MODEL:String = "BarterMenu_LoadModel";
      
      public const EVENT_HIDE_3D_MODEL:String = "BarterMenu_HideModel";
      
      public const EVENT_SELECT_ITEM:String = "BarterMenu_SelectItem";
      
      public const EVENT_SELL_ITEM:String = "BarterMenu_SellItem";
      
      public const EVENT_BUY_ITEM:String = "BarterMenu_BuyItem";
      
      public const EVENT_MOUSE_OVER_MODEL:String = "BarterMenu_SetMouseOverModel";
      
      protected const TITLE_BUY_STATE:String = "Buy";
      
      protected const TITLE_SELL_STATE:String = "Sell";
      
      protected const TITLE_SELL_FROM_SHIP_STATE:String = "SellFromShip";
      
      protected const HEADER_STATE_VENDOR_CREDITS:String = "VendorCredits";
      
      protected const HEADER_STATE_VENDOR_NO_CREDITS:String = "VendorNoCredits";
      
      protected const FOOTER_STATE_PLAYER_CREDITS:String = "PlayerCredits";
      
      protected const FOOTER_STATE_PLAYER_NO_CREDITS:String = "PlayerNoCredits";
      
      private const VENDOR_TITLE_MAX_LENGTH:* = 24;
      
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
      
      private var bEquipCardWasVisible:Boolean = false;
      
      private var LargeTextMode:Boolean = false;
      
      private var ItemDataA:Array;
      
      private var PlayerInventoryData:Object = null;
      
      private var VendorInventoryData:Object = null;
      
      private var ShipInventoryData:Object = null;
      
      private var BuyBackInventoryData:Object = null;
      
      private var bHasShipInventoryDataToDisplay:Boolean = false;
      
      private var WaitingForInventoryData:Object = null;
      
      private var bInitialized:Boolean = false;
      
      private var bHasUserChosenContainer:Boolean = false;
      
      private var bBarterContainerIsEmpty:Boolean = true;
      
      private var bPlayerHasSoldAnItem:Boolean = false;
      
      private var EquippedItemCardShouldBeVisible:* = false;
      
      private var CompareToEquippedButtonShouldBeVisible:* = false;
      
      private var CompareToEquippedButtonShouldBeEnabled:* = false;
      
      private const CONFIRM_WINDOW_BUYING:int = EnumHelper.GetEnum(0);
      
      private const CONFIRM_WINDOW_SELLING_FROM_PLAYER:int = EnumHelper.GetEnum();
      
      private const CONFIRM_WINDOW_SELLING_FROM_SHIP:int = EnumHelper.GetEnum();
      
      private var ConfirmWindowState:*;
      
      private const CATEGORY_CHANGE_SFX:String = "UIMenuGeneralCategory";
      
      private var _mouseOverModel:Boolean = false;
      
      public function BarterMenu()
      {
         var configParams:BSScrollingConfigParams;
         this.BuyButtonData = new ButtonBaseData("$BUY",[new UserEventData("LShoulder",this.onSwapInventories)],true,true);
         this.SellButtonData = new ButtonBaseData("$SELL",[new UserEventData("LShoulder",this.onSwapInventories)],true,true);
         this.SellFromShipButtonData = new ButtonBaseData("$SELL FROM SHIP INVENTORY",[new UserEventData("LShoulder",this.onSwapInventories)],true,true);
         this.SortOptions = [this.SORT_NULL,this.SORT_NAME,this.SORT_VALUE_DESC];
         this.FeaturedItemArray = new Vector.<Object>();
         this.SecondaryFeaturedItemArray = new Vector.<Object>();
         this.ConfirmWindowState = this.CONFIRM_WINDOW_BUYING;
         super();
         TextFieldEx.setTextAutoSize(this.ItemHeaderTitle_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.ItemHeaderCompareLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.SortPerCategory = new Dictionary();
         Extensions.enabled = true;
         this.ItemCard_mc.visible = false;
         this.EquippedItemCard_mc.visible = false;
         this.ButtonBar_mc.visible = false;
         BarterColumnValueHelper.InitHelper();
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "BarterCategory";
         configParams.VerticalSpacing = 3;
         this.CategoryList_mc.Configure(configParams);
         this.CategoryList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return (param1.uTotalItemCount > 0 || param1.iFilterFlags == InventoryItemUtils.ICF_BUY_BACK) && param1.iFilterFlags != InventoryItemUtils.ICF_NEW_ITEMS;
         },false);
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "BarterItem";
         configParams.VerticalSpacing = 3;
         this.ItemList_mc.Configure(configParams);
         this.ItemList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            var _loc3_:* = false;
            var _loc4_:* = false;
            var _loc2_:* = (param1.iFilterFlag & CurrFilter) != 0;
            if(_loc2_)
            {
               _loc3_ = CurrFilter == InventoryItemUtils.ICF_BUY_BACK;
               _loc4_ = (param1.iFilterFlag & InventoryItemUtils.ICF_BUY_BACK) != 0;
               _loc2_ = _loc3_ == _loc4_;
            }
            return _loc2_;
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
      
      public function get VendorCredits_Value_tf() : TextField
      {
         return this.VendorCreditsHeader_mc.Credits_mc.Credits_tf;
      }
      
      public function get Footer_Weight_tf() : TextField
      {
         return this.CategoryFooter_mc.Weight_tf;
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
         BSUIDataManager.Subscribe("ContainerInventoryData",this.onContainerInventoryUpdate);
         BSUIDataManager.Subscribe("ShipInventoryData",this.onShipInventoryUpdate);
         BSUIDataManager.Subscribe("BuyBackContainerInventoryData",this.onBuyBackInventoryUpdate);
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
         this.ButtonBar_mc.AddButtonWithData(this.CompareToEquippedButton,new ButtonBaseData(this.LargeTextMode ? "$COMPARE TO EQUIPPED_LRG" : "$COMPARE TO EQUIPPED",[new UserEventData("Select",this.onCompareToEquipped)],true,true));
         this.ButtonBar_mc.AddButtonWithData(this.SwapInventoriesButton,this.BuyButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.SortButton,new ButtonBaseData("$SORT",[new UserEventData("L3",this.ToggleSort)],true,true));
         this.ButtonBar_mc.AddButtonWithData(this.InspectButton,new ButtonBaseData("$INSPECT",[new UserEventData("R3",this.InspectItem)],true,false));
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",this.LargeTextMode ? "$EXIT HOLD_LRG" : "$EXIT HOLD",[new UserEventData("Cancel",this.onCancelEvent),new UserEventData("",this.CloseMenu)]));
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
      
      private function onEntryRollover() : void
      {
         if(this.m_State != null)
         {
            this.m_State(this.LIST_ITEM_ROLLOVER);
         }
      }
      
      private function CloseMenu() : *
      {
         BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
         this.gotoAndPlay("closeMenu");
         GlobalFunc.StartGameRender();
      }
      
      private function playFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function onBuyBackInventoryUpdate(param1:FromClientDataEvent) : void
      {
         this.BuyBackInventoryData = param1.data;
         this.UpdateVendorInventoryDataWithBuyBackData();
         if(this.m_State == this.state_VendorCategoryList || this.m_State == this.state_VendorItemList || this.m_State == this.state_ConfirmWindow && this.ConfirmWindowState === this.CONFIRM_WINDOW_BUYING)
         {
            this.UpdateListsWithVendorInventory();
         }
      }
      
      private function UpdateVendorInventoryDataWithBuyBackData() : *
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(Boolean(this.VendorInventoryData) && Boolean(this.BuyBackInventoryData))
         {
            if(this.VendorInventoryData.aCategories.length == 0 || this.VendorInventoryData.aCategories[this.VendorInventoryData.aCategories.length - 1].iFilterFlags != InventoryItemUtils.ICF_BUY_BACK)
            {
               _loc1_ = {};
               _loc1_.iFilterFlags = InventoryItemUtils.ICF_BUY_BACK;
               _loc1_.sName = "$BUY BACK";
               _loc1_.sSubtitle = "$NO ITEMS";
               _loc1_.uTotalItemCount = 0;
               this.VendorInventoryData.aCategories.push(_loc1_);
               _loc2_ = this.VendorInventoryData.aCategories.length - 1;
               if(this.BuyBackInventoryData.aItems.length == 0)
               {
                  this.VendorInventoryData.aCategories[_loc2_].sSubtitle = "$NO ITEMS";
                  this.VendorInventoryData.aCategories[_loc2_].uTotalItemCount = 0;
               }
               else
               {
                  this.VendorInventoryData.aCategories[_loc2_].sSubtitle = "";
                  this.VendorInventoryData.aCategories[_loc2_].uTotalItemCount = this.BuyBackInventoryData.aItems.length;
                  if(this.bBarterContainerIsEmpty)
                  {
                     this.VendorInventoryData.aItems.length = 0;
                  }
                  _loc3_ = 0;
                  while(_loc3_ < this.BuyBackInventoryData.aItems.length)
                  {
                     this.BuyBackInventoryData.aItems[_loc3_].iFilterFlag |= InventoryItemUtils.ICF_BUY_BACK;
                     this.VendorInventoryData.aItems.push(this.BuyBackInventoryData.aItems[_loc3_]);
                     _loc3_++;
                  }
                  if(!this.BuyBackInventoryData.aItems.isEmpty)
                  {
                     this.bPlayerHasSoldAnItem = true;
                  }
               }
            }
            if(this.m_State == null || this.m_State == this.state_VendorCategoryList || this.m_State == this.state_VendorItemList || this.m_State == this.state_ConfirmWindow && this.ConfirmWindowState === this.CONFIRM_WINDOW_BUYING)
            {
               this.UpdateListsWithVendorInventory();
            }
         }
      }
      
      private function onPlayerInventoryUpdate(param1:FromClientDataEvent) : void
      {
         if(this.WaitingForInventoryData == this.PlayerInventoryData)
         {
            this.WaitingForInventoryData = null;
         }
         this.PlayerInventoryData = param1.data;
         var _loc2_:int = 0;
         if(this.VendorInventoryData)
         {
            _loc2_ = int(this.VendorInventoryData.aItems.length);
         }
         if(!this.bHasUserChosenContainer && this.m_State == this.state_VendorCategoryList && _loc2_ == 0)
         {
            this.TransitionToState(this.state_PlayerCategoryList);
         }
         BarterItem.PlayerFunds = this.PlayerInventoryData.uCoin;
         if(this.m_State == this.state_PlayerCategoryList || this.m_State == this.state_PlayerItemList || this.m_State == this.state_ConfirmWindow && this.ConfirmWindowState === this.CONFIRM_WINDOW_SELLING_FROM_PLAYER)
         {
            this.UpdateListsWithPlayerInventory();
         }
      }
      
      private function onShipInventoryUpdate(param1:FromClientDataEvent) : void
      {
         if(this.WaitingForInventoryData == this.ShipInventoryData)
         {
            this.WaitingForInventoryData = null;
         }
         this.ShipInventoryData = param1.data;
         if(this.ShipInventoryData.aCategories.length > 0)
         {
            this.bHasShipInventoryDataToDisplay = true;
            if(this.m_State == this.state_PlayerCategoryList)
            {
               this.SwapInventoriesButton.SetButtonData(this.bHasShipInventoryDataToDisplay ? this.SellFromShipButtonData : this.BuyButtonData);
            }
         }
         if(this.m_State == this.state_ShipCategoryList || this.m_State == this.state_ShipItemList || this.m_State == this.state_ConfirmWindow && this.ConfirmWindowState === this.CONFIRM_WINDOW_SELLING_FROM_SHIP)
         {
            this.UpdateListsWithShipInventory();
         }
      }
      
      private function onContainerInventoryUpdate(param1:FromClientDataEvent) : void
      {
         if(this.WaitingForInventoryData == this.VendorInventoryData)
         {
            this.WaitingForInventoryData = null;
         }
         this.VendorInventoryData = param1.data;
         if(this.VendorInventoryData.aItems.length > 0 && !this.bPlayerHasSoldAnItem)
         {
            this.bBarterContainerIsEmpty = false;
         }
         if(!this.bHasUserChosenContainer && this.m_State == this.state_PlayerCategoryList && this.VendorInventoryData.aItems.length > 0)
         {
            this.TransitionToState(this.state_VendorCategoryList);
         }
         this.UpdateVendorInventoryDataWithBuyBackData();
         if(this.m_State == null || this.m_State == this.state_VendorCategoryList || this.m_State == this.state_VendorItemList || this.m_State == this.state_ConfirmWindow && this.ConfirmWindowState === this.CONFIRM_WINDOW_BUYING)
         {
            this.UpdateListsWithVendorInventory();
         }
      }
      
      private function CategoryListCompareFunc(param1:Object, param2:Object) : int
      {
         var _loc3_:int = 0;
         if(param1.iFilterFlags == InventoryItemUtils.ICF_ALL)
         {
            _loc3_ = -1;
         }
         else if(param2.iFilterFlags == InventoryItemUtils.ICF_ALL)
         {
            _loc3_ = 1;
         }
         else if(param1.iFilterFlags == InventoryItemUtils.ICF_BUY_BACK)
         {
            _loc3_ = 1;
         }
         else if(param2.iFilterFlags == InventoryItemUtils.ICF_BUY_BACK)
         {
            _loc3_ = -1;
         }
         else if(param1.iFilterFlags < param2.iFilterFlags)
         {
            _loc3_ = -1;
         }
         else if(param2.iFilterFlags < param1.iFilterFlags)
         {
            _loc3_ = 1;
         }
         return _loc3_;
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
         var _loc1_:uint = 0;
         if(this.SortPerCategory[this.CurrFilter] != null)
         {
            _loc1_ = uint(this.SortPerCategory[this.CurrFilter]);
         }
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
      
      private function UpdateCreditsDisplay() : *
      {
         if(this.PlayerInventoryData)
         {
            this.CategoryFooter_mc.gotoAndStop(this.PlayerInventoryData.uCoin == 0 ? this.FOOTER_STATE_PLAYER_NO_CREDITS : this.FOOTER_STATE_PLAYER_CREDITS);
            GlobalFunc.SetText(this.Footer_Value_tf,this.PlayerInventoryData.uCoin.toString());
         }
         else
         {
            this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_PLAYER_NO_CREDITS);
            GlobalFunc.SetText(this.Footer_Value_tf,"0");
         }
         if(this.VendorInventoryData)
         {
            this.VendorCreditsHeader_mc.gotoAndStop(this.VendorInventoryData.uCoin == 0 ? this.HEADER_STATE_VENDOR_NO_CREDITS : this.HEADER_STATE_VENDOR_CREDITS);
            GlobalFunc.SetText(this.VendorCredits_Value_tf,this.VendorInventoryData.uCoin.toString());
         }
         else
         {
            this.VendorCreditsHeader_mc.gotoAndStop(this.HEADER_STATE_VENDOR_NO_CREDITS);
            GlobalFunc.SetText(this.VendorCredits_Value_tf,"0");
         }
      }
      
      private function UpdateListsWithPlayerInventory() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.PlayerInventoryData)
         {
            this.UpdateCreditsDisplay();
            BarterItem.IsVendorItemList = false;
            _loc1_ = uint(this.PlayerInventoryData.fEncumbrance);
            _loc2_ = uint(this.PlayerInventoryData.fMaxEncumbrance);
            GlobalFunc.SetText(this.Footer_Weight_tf,_loc1_ + "/" + _loc2_);
            this.ItemDataA = this.PlayerInventoryData.aItems;
            this.CategoryList_mc.InitializeEntries(this.PlayerInventoryData.aCategories);
            this.CategoryList_mc.SortEntries(this.CategoryListCompareFunc);
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
            this.UpdateCreditsDisplay();
            BarterItem.IsVendorItemList = false;
            _loc1_ = uint(this.PlayerInventoryData.fEncumbrance);
            _loc2_ = uint(this.PlayerInventoryData.fMaxEncumbrance);
            GlobalFunc.SetText(this.Footer_Weight_tf,_loc1_ + "/" + _loc2_);
            this.ItemDataA = this.ShipInventoryData.aItems;
            this.CategoryList_mc.InitializeEntries(this.ShipInventoryData.aCategories);
            this.CategoryList_mc.SortEntries(this.CategoryListCompareFunc);
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
      
      private function UpdateListsWithVendorInventory() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.VendorInventoryData)
         {
            BarterItem.IsVendorItemList = true;
            this.UpdateCreditsDisplay();
            _loc1_ = uint(this.PlayerInventoryData.fEncumbrance);
            _loc2_ = uint(this.PlayerInventoryData.fMaxEncumbrance);
            GlobalFunc.SetText(this.Footer_Weight_tf,_loc1_ + "/" + _loc2_);
            this.ItemDataA = this.VendorInventoryData.aItems;
            this.CategoryList_mc.InitializeEntries(this.VendorInventoryData.aCategories);
            this.CategoryList_mc.SortEntries(this.CategoryListCompareFunc);
            this.ItemList_mc.InitializeEntries(this.VendorInventoryData.aItems);
            this.SortItemList();
            if(!this.bInitialized)
            {
               this.bInitialized = true;
               this.m_State = this.state_VendorCategoryList;
               this.m_State(this.ENTER_STATE);
               this.CategoryList_mc.selectedIndex = 0;
               addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.playFocusSound);
            }
            else if(this.m_State == this.state_VendorItemList)
            {
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < this.VendorInventoryData.aCategories.length)
               {
                  if(this.VendorInventoryData.aCategories[_loc4_].iFilterFlags === this.CurrFilter)
                  {
                     if(this.VendorInventoryData.aCategories[_loc4_].uTotalItemCount > 0)
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc3_)
               {
                  this.TransitionToState(this.state_VendorCategoryList);
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
         var _loc3_:Number = BarterColumnValueHelper.GetColumnSortVal(this.CurrFilter,param1);
         var _loc4_:Number = BarterColumnValueHelper.GetColumnSortVal(this.CurrFilter,param2);
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
      
      private function UpdateSortOptions() : *
      {
         this.SortOptions = new Array();
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
         BarterColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc1_].sortType);
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
         if(this.m_State == this.state_VendorCategoryList || this.m_State == this.state_ShipCategoryList)
         {
            _loc8_ = this.m_State == this.state_VendorCategoryList ? this.VendorInventoryData : this.ShipInventoryData;
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
      }
      
      protected function state_VendorCategoryList(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryHeader_mc.visible = true;
               this.CategoryList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_PLAYER_CREDITS);
               this.SortButton.Visible = false;
               this.CompareToEquippedButton.Visible = false;
               this.InspectButton.Visible = false;
               this.ItemCard_mc.visible = false;
               this.EquippedItemCard_mc.visible = false;
               this.Title_mc.gotoAndStop(this.TITLE_BUY_STATE);
               this.SwapInventoriesButton.SetButtonData(this.SellButtonData);
               stage.focus = this.CategoryList_mc;
               BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               if(this.CategoryList_mc.selectedEntry.uTotalItemCount > 0)
               {
                  this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
                  BarterItem.CurrFilter = this.CurrFilter;
                  BarterColumnValueHelper.ResetColumnIndex(this.CurrFilter);
                  this.ItemList_mc.ReinitializeEntries();
                  this.UpdateSortOptions();
                  this.SortItemList();
                  GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
                  GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,BarterColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
                  this.UpdateFeaturedItems();
                  this.TransitionToState(this.state_VendorItemList);
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
               this.bHasUserChosenContainer = true;
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
               this.Title_mc.gotoAndStop(this.TITLE_SELL_STATE);
               this.SwapInventoriesButton.SetButtonData(this.bHasShipInventoryDataToDisplay ? this.SellFromShipButtonData : this.BuyButtonData);
               stage.focus = this.CategoryList_mc;
               BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
               BarterItem.CurrFilter = this.CurrFilter;
               BarterColumnValueHelper.ResetColumnIndex(this.CurrFilter);
               this.ItemList_mc.ReinitializeEntries();
               this.UpdateSortOptions();
               this.SortItemList();
               GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,BarterColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.UpdateFeaturedItems();
               this.TransitionToState(this.state_PlayerItemList);
               this.ItemList_mc.selectedIndex = 0;
               this.m_State(this.LIST_ITEM_ROLLOVER);
               GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
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
                  this.TransitionToState(this.state_VendorCategoryList);
                  this.UpdateListsWithVendorInventory();
               }
               this.bHasUserChosenContainer = true;
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
               this.Title_mc.gotoAndStop(this.TITLE_SELL_FROM_SHIP_STATE);
               this.SwapInventoriesButton.SetButtonData(this.BuyButtonData);
               stage.focus = this.CategoryList_mc;
               if(this.ShipInventoryData)
               {
                  GlobalFunc.SetText(this.Title_mc.VendorHeader_mc.text_tf,"$$VENDOR" + " < " + "$$SELLFROM" + " " + this.ShipInventoryData.sContainerName.toUpperCase(),false,false,this.VENDOR_TITLE_MAX_LENGTH);
               }
               BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
               BarterItem.CurrFilter = this.CurrFilter;
               BarterColumnValueHelper.ResetColumnIndex(this.CurrFilter);
               this.ItemList_mc.ReinitializeEntries();
               this.UpdateSortOptions();
               this.SortItemList();
               GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,BarterColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.UpdateFeaturedItems();
               this.TransitionToState(this.state_ShipItemList);
               this.ItemList_mc.selectedIndex = 0;
               this.m_State(this.LIST_ITEM_ROLLOVER);
               GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               break;
            case this.CANCEL_PRESS:
               this.CloseMenu();
               break;
            case this.SWAP_INVENTORIES:
               this.TransitionToState(this.state_VendorCategoryList);
               this.UpdateListsWithVendorInventory();
               this.bHasUserChosenContainer = true;
               break;
            case this.EXIT_STATE:
               this.CategoryHeader_mc.visible = false;
               this.CategoryList_mc.visible = false;
         }
      }
      
      private function OnCloseMenuFadeOutComplete() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuInventoryMenuClose");
         BSUIDataManager.dispatchEvent(new Event("BarterMenu_CloseMenu",true));
      }
      
      protected function state_VendorItemList(param1:int) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ItemHeader_mc.visible = true;
               this.ItemList_mc.visible = true;
               this.SortButton.Visible = true;
               this.InspectButton.Visible = true;
               this.CategoryFooter_mc.visible = true;
               this.ItemCard_mc.visible = true;
               this.EquippedItemCard_mc.visible = this.EquippedItemCardShouldBeVisible;
               this.CompareToEquippedButton.Visible = this.CompareToEquippedButtonShouldBeVisible;
               this.CompareToEquippedButton.Enabled = this.CompareToEquippedButtonShouldBeEnabled;
               stage.focus = this.ItemList_mc;
               this.UpdateSortButtonText();
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               if(Boolean(this.PlayerInventoryData) && !this.WaitingForInventoryData)
               {
                  _loc3_ = uint(this.ItemList_mc.selectedEntry.uValue);
                  if(this.PlayerInventoryData.uCoin >= _loc3_)
                  {
                     this.WaitingForInventoryData = this.VendorInventoryData;
                     _loc4_ = int(this.ItemList_mc.selectedEntry.uCount);
                     if(this.ItemList_mc.selectedEntry.uValue > 0)
                     {
                        while(_loc4_ * _loc3_ > this.PlayerInventoryData.uCoin && _loc4_ > 1)
                        {
                           _loc4_--;
                        }
                     }
                     if(this.ItemList_mc.selectedEntry.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU || _loc4_ <= 1)
                     {
                        BSUIDataManager.dispatchCustomEvent(this.EVENT_BUY_ITEM,{
                           "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
                           "uQuantity":1,
                           "uValue":_loc3_,
                           "bToShip":!(this.CurrFilter == InventoryItemUtils.ICF_BUY_BACK && this.ItemList_mc.selectedEntry.bToShip === false),
                           "bIsBuyBack":this.CurrFilter == InventoryItemUtils.ICF_BUY_BACK
                        });
                     }
                     else
                     {
                        this.ConfirmWindowState = this.CONFIRM_WINDOW_BUYING;
                        this.ConfirmWindow_mc.SetData(_loc4_,"$Quantity_BarterBuy","$BUY ALL",null,true,this.ItemList_mc.selectedEntry.uValue);
                        this.TransitionToState(this.state_ConfirmWindow,false);
                     }
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
                  if(this.PlayerInventoryData)
                  {
                     this.CategoryFooter_mc.gotoAndStop(this.PlayerInventoryData.uCoin < this.ItemList_mc.selectedEntry.uValue ? this.FOOTER_STATE_PLAYER_NO_CREDITS : this.FOOTER_STATE_PLAYER_CREDITS);
                  }
                  if((_loc5_ = this.GetFeaturedItem(this.ItemList_mc.selectedEntry)) == null)
                  {
                     _loc5_ = this.ItemList_mc.selectedEntry;
                     this.CompareToEquippedButton.Visible = false;
                     this.CompareToEquippedButton.Enabled = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                  }
                  else
                  {
                     this.CompareToEquippedButton.Visible = true;
                     this.CompareToEquippedButton.Enabled = true;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = this.bEquipCardWasVisible;
                     this.EquippedItemCard_mc.SetItemData(_loc5_,_loc5_);
                  }
                  this.ItemCard_mc.SetItemData(this.ItemList_mc.selectedEntry,_loc5_);
                  this.ItemCard_mc.visible = true;
               }
               break;
            case this.CANCEL_PRESS:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.TransitionToState(this.state_VendorCategoryList);
               this.CategoryFooter_mc.gotoAndStop(this.FOOTER_STATE_PLAYER_CREDITS);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc2_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
               BarterColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,BarterColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
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
      
      public function QuantityMenuWarningFunc(param1:uint, param2:uint) : String
      {
         return this.VendorInventoryData.uCoin < param1 * param2 ? "$QuantityWarning_BadTransaction" : "";
      }
      
      protected function state_PlayerItemList(param1:int) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
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
               if(Boolean(this.VendorInventoryData) && !this.WaitingForInventoryData)
               {
                  this.WaitingForInventoryData = this.PlayerInventoryData;
                  _loc3_ = uint(this.ItemList_mc.selectedEntry.uValue);
                  if(this.ItemList_mc.selectedEntry.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU && this.VendorInventoryData.uCoin >= _loc3_)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_SELL_ITEM,{
                        "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
                        "uQuantity":1
                     });
                  }
                  else
                  {
                     this.ConfirmWindowState = this.CONFIRM_WINDOW_SELLING_FROM_PLAYER;
                     this.ConfirmWindow_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_BarterSell","$SELL ALL",this.QuantityMenuWarningFunc,true,this.ItemList_mc.selectedEntry.uValue);
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
                  if(this.VendorInventoryData)
                  {
                     this.VendorCreditsHeader_mc.gotoAndStop(this.VendorInventoryData.uCoin < this.ItemList_mc.selectedEntry.uValue ? this.HEADER_STATE_VENDOR_NO_CREDITS : this.HEADER_STATE_VENDOR_CREDITS);
                  }
                  if((_loc4_ = this.GetFeaturedItem(this.ItemList_mc.selectedEntry)) == null)
                  {
                     _loc4_ = this.ItemList_mc.selectedEntry;
                     this.CompareToEquippedButton.Visible = false;
                     this.CompareToEquippedButton.Enabled = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                  }
                  else
                  {
                     this.CompareToEquippedButton.Visible = true;
                     this.CompareToEquippedButton.Enabled = true;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = this.bEquipCardWasVisible;
                     this.EquippedItemCard_mc.SetItemData(_loc4_,_loc4_);
                  }
                  this.ItemCard_mc.SetItemData(this.ItemList_mc.selectedEntry,_loc4_);
                  this.ItemCard_mc.visible = true;
               }
               break;
            case this.CANCEL_PRESS:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.TransitionToState(this.state_PlayerCategoryList);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc2_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
               BarterColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,BarterColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
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
                  this.TransitionToState(this.state_VendorCategoryList);
                  this.UpdateListsWithVendorInventory();
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
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ItemHeader_mc.visible = true;
               this.ItemList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.SortButton.Visible = true;
               this.InspectButton.Visible = true;
               this.EquippedItemCard_mc.visible = this.EquippedItemCardShouldBeVisible;
               this.CompareToEquippedButton.Visible = this.CompareToEquippedButtonShouldBeVisible;
               this.CompareToEquippedButton.Enabled = this.CompareToEquippedButtonShouldBeEnabled;
               stage.focus = this.ItemList_mc;
               this.ItemCard_mc.visible = true;
               this.UpdateSortButtonText();
               this.ButtonBar_mc.RefreshButtons();
               break;
            case this.LIST_ITEM_PRESS:
               if(Boolean(this.VendorInventoryData) && !this.WaitingForInventoryData)
               {
                  _loc3_ = uint(this.ItemList_mc.selectedEntry.uValue);
                  this.WaitingForInventoryData = this.ShipInventoryData;
                  if(this.ItemList_mc.selectedEntry.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU && this.VendorInventoryData.uCoin >= _loc3_)
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_SELL_ITEM,{
                        "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
                        "uQuantity":1,
                        "bFromShip":true
                     });
                  }
                  else
                  {
                     this.ConfirmWindowState = this.CONFIRM_WINDOW_SELLING_FROM_SHIP;
                     this.ConfirmWindow_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_BarterSell","$SELL ALL",this.QuantityMenuWarningFunc,true,this.ItemList_mc.selectedEntry.uValue);
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
                  if(this.VendorInventoryData)
                  {
                     this.VendorCreditsHeader_mc.gotoAndStop(this.VendorInventoryData.uCoin < this.ItemList_mc.selectedEntry.uValue ? this.HEADER_STATE_VENDOR_NO_CREDITS : this.HEADER_STATE_VENDOR_CREDITS);
                  }
                  if((_loc4_ = this.GetFeaturedItem(this.ItemList_mc.selectedEntry)) == null)
                  {
                     _loc4_ = this.ItemList_mc.selectedEntry;
                     this.CompareToEquippedButton.Visible = false;
                     this.CompareToEquippedButton.Enabled = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                  }
                  else
                  {
                     this.CompareToEquippedButton.Visible = true;
                     this.CompareToEquippedButton.Enabled = true;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = this.bEquipCardWasVisible;
                     this.EquippedItemCard_mc.SetItemData(_loc4_,_loc4_);
                  }
                  this.ItemCard_mc.SetItemData(this.ItemList_mc.selectedEntry,_loc4_);
                  this.ItemCard_mc.visible = true;
               }
               break;
            case this.CANCEL_PRESS:
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               this.TransitionToState(this.state_ShipCategoryList);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.SortButton.SetButtonData(new ButtonBaseData(this.SortOptions[_loc2_].text,[new UserEventData("L3",this.ToggleSort)],true,true));
               BarterColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,BarterColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.ItemList_mc.ReinitializeEntries();
               this.SortItemList();
               this.ButtonBar_mc.RefreshButtons();
               GlobalFunc.PlayMenuSound("UIMenuGeneralColumn");
               break;
            case this.SWAP_INVENTORIES:
               this.TransitionToState(this.state_VendorCategoryList);
               this.UpdateListsWithVendorInventory();
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
               this.ConfirmWindow_mc.addEventListener(QuantityComponent.CANCEL_TRANSACTION,this.onTransactionCancelled);
               break;
            case this.EXIT_STATE:
               this.ConfirmWindow_mc.removeEventListener(QuantityComponent.WINDOW_CLOSED,this.onConfirmWindowClosed);
               this.ConfirmWindow_mc.removeEventListener(QuantityComponent.CONFIRM_TRANSACTION,this.onTransactionConfirmed);
               this.ConfirmWindow_mc.removeEventListener(QuantityComponent.CANCEL_TRANSACTION,this.onTransactionCancelled);
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
               this.SwapInventoriesButton.Visible = false;
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
               this.SwapInventoriesButton.Visible = true;
               GlobalFunc.PlayMenuSound("UIMenuInventoryInspect");
         }
      }
      
      private function onConfirmWindowClosed() : *
      {
         var _loc1_:Object = this.VendorInventoryData;
         if(this.ConfirmWindowState === this.CONFIRM_WINDOW_SELLING_FROM_SHIP)
         {
            _loc1_ = this.ShipInventoryData;
         }
         else if(this.ConfirmWindowState === this.CONFIRM_WINDOW_SELLING_FROM_PLAYER)
         {
            _loc1_ = this.PlayerInventoryData;
         }
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
            if(_loc1_ == this.VendorInventoryData)
            {
               this.TransitionToState(this.state_VendorCategoryList);
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
         else if(_loc1_ == this.VendorInventoryData)
         {
            this.TransitionToState(this.state_VendorItemList);
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
         if(this.ConfirmWindowState === this.CONFIRM_WINDOW_BUYING)
         {
            BSUIDataManager.dispatchCustomEvent(this.EVENT_BUY_ITEM,{
               "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
               "uQuantity":this.ConfirmWindow_mc.CurrentQuantity,
               "uValue":this.ItemList_mc.selectedEntry.uValue,
               "bToShip":!(this.CurrFilter == InventoryItemUtils.ICF_BUY_BACK && this.ItemList_mc.selectedEntry.bToShip === false),
               "bIsBuyBack":this.CurrFilter == InventoryItemUtils.ICF_BUY_BACK
            });
         }
         else
         {
            BSUIDataManager.dispatchCustomEvent(this.EVENT_SELL_ITEM,{
               "uHandleID":this.ItemList_mc.selectedEntry.uHandleID,
               "uQuantity":this.ConfirmWindow_mc.CurrentQuantity,
               "bFromShip":this.ConfirmWindowState === this.CONFIRM_WINDOW_SELLING_FROM_SHIP
            });
         }
      }
      
      private function onTransactionCancelled() : *
      {
         this.WaitingForInventoryData = null;
      }
   }
}
