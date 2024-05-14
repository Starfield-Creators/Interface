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
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.MinimalButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class InventoryMenu extends IMenu
   {
      
      private static const PERSONAL_EFFECT_ICON_X_OFFSET:int = -6;
      
      private static const PERSONAL_EFFECT_ICON_Y_OFFSET:int = -11;
      
      private static const PERSONAL_EFFECT_ICON_X_STEP:uint = 34;
      
      private static const PERSONAL_EFFECT_ICON_SCALE:Number = 0.9;
       
      
      public var CategoryHeader_mc:MovieClip;
      
      public var CategoryFooter_mc:MovieClip;
      
      public var CategoryList_mc:BSScrollingContainer;
      
      public var ItemHeader_mc:MovieClip;
      
      public var ItemList_mc:BSScrollingContainer;
      
      public var ItemCard_mc:InvItemCard;
      
      public var EquippedItemCard_mc:InvItemCard;
      
      public var PreviewSceneRect_mc:BSAnimating3DSceneRect;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var QuantityVignette_mc:MovieClip;
      
      public var QuantityMenu_mc:QuantityComponent;
      
      public var PlayerStatus_mc:MovieClip;
      
      private var PersonalEffectIconsA:Array;
      
      protected var m_State:Function;
      
      protected const ENTER_STATE:int = EnumHelper.GetEnum(0);
      
      protected const EXIT_STATE:int = EnumHelper.GetEnum();
      
      protected const LIST_ITEM_PRESS:int = EnumHelper.GetEnum();
      
      protected const LIST_ITEM_ROLLOVER:int = EnumHelper.GetEnum();
      
      protected const CANCEL_PRESS:int = EnumHelper.GetEnum();
      
      protected const DROP_PRESS:int = EnumHelper.GetEnum();
      
      protected const INSPECT_PRESS:int = EnumHelper.GetEnum();
      
      protected const SORT_PRESS:int = EnumHelper.GetEnum();
      
      protected const FAVORITE_PRESS:int = EnumHelper.GetEnum();
      
      protected const CARGO_HOLD_PRESS:int = EnumHelper.GetEnum();
      
      protected const SHOW_EQUIPPED_STATS:int = EnumHelper.GetEnum();
      
      public const EVENT_LOAD_3D_MODEL:String = "InventoryMenu_LoadModel";
      
      public const EVENT_TRY_ON:String = "InventoryMenu_PaperDollTryOn";
      
      public const EVENT_HIDE_3D_MODEL:String = "InventoryMenu_HideModel";
      
      public const EVENT_CHANGE_3D_VIEW:String = "InventoryMenu_Change3DView";
      
      public const EVENT_ON_ENTER_CATEGORY:String = "InventoryMenu_OnEnterCategory";
      
      public const EVENT_SELECT_ITEM:String = "InventoryMenu_SelectItem";
      
      public const EVENT_DROP_ITEM:String = "InventoryMenu_DropItem";
      
      public const EVENT_TOGGLE_FAVORITE:String = "InventoryMenu_ToggleFavorite";
      
      public const EVENT_RESET_PAPER_DOLL_INV:String = "InventoryMenu_ResetPaperDollInv";
      
      public const EVENT_TOGGLE_HELMET:String = "InventoryMenu_ToggleHelmet";
      
      public const EVENT_TOGGLE_SUIT:String = "InventoryMenu_ToggleSuit";
      
      public const EVENT_MOUSE_OVER_MODEL:String = "InventoryMenu_SetMouseOverModel";
      
      public const EVENT_OPEN_CARGO_HOLD:String = "InventoryMenu_OpenCargoHold";
      
      public const EVENT_START_CLOSE_ANIM:String = "InventoryMenu_StartCloseAnim";
      
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
      
      private var SortButtonData:ButtonBaseData;
      
      private var CurrFilter:int = 0;
      
      private var PlayerInventoryData:Object = null;
      
      private var FeaturedItemArray:Vector.<Object>;
      
      private var SecondaryFeaturedItemArray:Vector.<Object>;
      
      private var CurrShownModel:uint = 0;
      
      private var CompareItems:Dictionary;
      
      private var SortPerCategory:Dictionary;
      
      private var SecondaryCompareItems:Dictionary;
      
      private var ButtonBarRefreshTimer:Timer;
      
      private var LargeTextMode:Boolean = false;
      
      private var ItemDataA:Array;
      
      private var bExitingScreen:Boolean = false;
      
      private var bReturningToGame:Boolean = false;
      
      private var ToggleHelmetSuitButton:IButton;
      
      private var ToggleHelmetButtonData:ButtonBaseData;
      
      private var ToggleSuitButtonData:ButtonBaseData;
      
      private var HelmetShownInBreathableAreas:Boolean = true;
      
      private var SuitShownInSettlements:Boolean = true;
      
      private var CanPaperDollPreviewFilterFlags:* = 4294967295;
      
      private var ToggleHelmetSuitButtonShouldBeVisible:Boolean = false;
      
      private var ToggleHelmetSuitButtonShouldBeEnabled:Boolean = false;
      
      private var CompareToEquippedButtonShouldBeVisible:* = false;
      
      private var CompareToEquippedButtonShouldBeEnabled:* = false;
      
      private var EquippedItemCardShouldBeVisible:* = false;
      
      private var CargoHoldEnabled:* = false;
      
      private var bEquipCardWasVisible:* = false;
      
      private var AllowItemPreviews:* = false;
      
      private var _mouseOverModel:Boolean = false;
      
      public function InventoryMenu()
      {
         var configParams:BSScrollingConfigParams;
         this.SortOptions = [this.SORT_NULL,this.SORT_NAME,this.SORT_VALUE_DESC];
         this.FeaturedItemArray = new Vector.<Object>();
         this.SecondaryFeaturedItemArray = new Vector.<Object>();
         super();
         TextFieldEx.setTextAutoSize(this.ItemHeaderTitle_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.ItemHeaderCompareLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.PersonalEffectIconsA = new Array();
         Extensions.enabled = true;
         InvColumnValueHelper.InitHelper();
         this.CompareItems = new Dictionary();
         this.SecondaryCompareItems = new Dictionary();
         this.SortPerCategory = new Dictionary();
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "InvCategory";
         configParams.VerticalSpacing = 3;
         this.CategoryList_mc.Configure(configParams);
         this.CategoryList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return param1.uTotalItemCount > (!!param1.bHasGold ? 1 : 0) || param1.iFilterFlags == InventoryItemUtils.ICF_ALL;
         },false);
         configParams = new BSScrollingConfigParams();
         configParams.EntryClassName = "InvItem";
         configParams.VerticalSpacing = 3;
         this.ItemList_mc.Configure(configParams);
         this.ItemList_mc.SetFilterComparitor(function(param1:Object):Boolean
         {
            return (param1.iFilterFlag & CurrFilter) != 0 && (param1.bIsGold == null || param1.bIsGold == false);
         },false);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.onItemPress);
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onEntryRollover);
         this.PreviewSceneRect_mc.SetBackgroundColor(67504895);
         BS3DSceneRectManager.Register3DSceneRect(this.PreviewSceneRect_mc);
         GlobalFunc.PlayMenuSound("UIMenuInventoryMenuOpen");
         this.PlayerStatus_mc.PlayerMeter_mc.SetLabel("$HEALTH");
         this.PlayerStatus_mc.PlayerMeter_mc.Max_tf.visible = false;
         this.PlayerStatus_mc.PlayerMeter_mc.Current_tf.visible = false;
         this.PlayerStatus_mc.visible = false;
         this.ButtonBar_mc.visible = false;
         this.PopulateButtonBar();
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get DropButton() : IButton
      {
         return this.ButtonBar_mc.DropButton_mc;
      }
      
      private function get InspectButton() : IButton
      {
         return this.ButtonBar_mc.InspectButton_mc;
      }
      
      private function get CompareToEquippedButton() : IButton
      {
         return this.ButtonBar_mc.CompareToEquippedButton_mc;
      }
      
      private function get SortButton() : IButton
      {
         return this.ButtonBar_mc.SortButton_mc;
      }
      
      private function get FavoriteButton() : IButton
      {
         return this.ButtonBar_mc.FavoriteButton_mc;
      }
      
      private function get CargoHoldButton() : IButton
      {
         return this.ButtonBar_mc.CargoHoldButton_mc;
      }
      
      private function get ItemHeaderTitle_tf() : TextField
      {
         return this.ItemHeader_mc.CategoryName_mc.Text_tf;
      }
      
      private function get ItemHeaderCompareLabel_tf() : TextField
      {
         return this.ItemHeader_mc.CompareLabel_mc.Text_tf;
      }
      
      private function get Footer_Value_tf() : TextField
      {
         return this.CategoryFooter_mc.Credits_tf;
      }
      
      private function get Footer_Weight_tf() : TextField
      {
         return this.CategoryFooter_mc.Weight_tf;
      }
      
      private function get InventoryHelmetHideLabel() : String
      {
         return this.LargeTextMode ? "$INVENTORY_HELMET_HIDE_LRG" : "$INVENTORY_HELMET_HIDE";
      }
      
      private function get InventoryHelmetShowLabel() : String
      {
         return this.LargeTextMode ? "$INVENTORY_HELMET_SHOW_LRG" : "$INVENTORY_HELMET_SHOW";
      }
      
      private function get InventorySuitHideLabel() : String
      {
         return this.LargeTextMode ? "$INVENTORY_SUIT_HIDE_LRG" : "$INVENTORY_SUIT_HIDE";
      }
      
      private function get InventorySuitShowLabel() : String
      {
         return this.LargeTextMode ? "$INVENTORY_SUIT_SHOW_LRG" : "$INVENTORY_SUIT_SHOW";
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
         BSUIDataManager.Subscribe("PlayerData",this.onPlayerDataUpdate);
         BSUIDataManager.Subscribe("PlayerFrequentData",this.OnPlayerFreqDataUpdate);
         BSUIDataManager.Subscribe("PlayerInventoryData",this.onInventoryUpdate);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFireForgetEvent);
         BSUIDataManager.Subscribe("PersonalEffectsData",this.onPersonalEffectsDataUpdate);
         BSUIDataManager.Subscribe("DataInventoryProvider",this.onDataMenuInventoryDataUpdate);
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
         this.ToggleHelmetButtonData = new ButtonBaseData(this.InventoryHelmetHideLabel,[new UserEventData("RShoulder",this.ToggleHelmet)]);
         this.ToggleSuitButtonData = new ButtonBaseData(this.InventorySuitHideLabel,[new UserEventData("RShoulder",this.ToggleSuit)]);
         this.ToggleHelmetSuitButton = ButtonFactory.AddToButtonBar("BasicButton",this.ToggleHelmetButtonData,this.ButtonBar_mc);
         this.ToggleHelmetSuitButton.Visible = false;
         this.ButtonBar_mc.AddButtonWithData(this.CompareToEquippedButton,new ButtonBaseData(this.LargeTextMode ? "$COMPARE TO EQUIPPED_LRG" : "$COMPARE TO EQUIPPED",[new UserEventData("Select",this.onCompareToEquipped)],true,true));
         this.ButtonBar_mc.AddButtonWithData(this.InspectButton,new ButtonBaseData("$INSPECT",[new UserEventData("R3",this.InspectItem)],true,false));
         this.SortButtonData = new ButtonBaseData("$SORT",[new UserEventData("L3",this.ToggleSort)]);
         this.ButtonBar_mc.AddButtonWithData(this.SortButton,this.SortButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.FavoriteButton,new ButtonBaseData("$FAVORITE",[new UserEventData("YButton",this.SetFavorite)],true,false));
         this.ButtonBar_mc.AddButtonWithData(this.DropButton,new ButtonBaseData("$DROP",[new UserEventData("XButton",this.DropSelectedItem)],true,false));
         this.ButtonBar_mc.AddButtonWithData(this.CargoHoldButton,new ButtonBaseData("$CARGO HOLD",[new UserEventData("LShoulder",this.OpenCargoHold)],true,false));
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",this.LargeTextMode ? "$EXIT HOLD_LRG" : "$EXIT HOLD",[new UserEventData("Cancel",this.onCancelEvent),new UserEventData("",this.onReturnToGameplay)]));
         this.ButtonBar_mc.RefreshButtons();
         this.ButtonBarRefreshTimer = new Timer(60,1);
         this.ButtonBarRefreshTimer.addEventListener(TimerEvent.TIMER,this.handleButtonBarRefreshTimer);
         this.ButtonBarRefreshTimer.start();
      }
      
      private function handleButtonBarRefreshTimer(param1:TimerEvent) : *
      {
         this.ButtonBar_mc.visible = true;
         this.ButtonBarRefreshTimer = null;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.QuantityMenu_mc.visible)
         {
            _loc3_ = this.QuantityMenu_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.ButtonBar_mc.visible)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !param2)
         {
            if(param1 == "Inventory")
            {
               this.onReturnToGameplay();
               _loc3_ = true;
            }
         }
         return _loc3_;
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
         else if(GlobalFunc.HasFireForgetEvent(param1.data,"Inventory_AllowItemPreviews"))
         {
            this.AllowItemPreviews = true;
            this.m_State(this.LIST_ITEM_ROLLOVER);
         }
      }
      
      private function onCancelEvent() : void
      {
         this.m_State(this.CANCEL_PRESS);
      }
      
      private function DropSelectedItem() : void
      {
         this.m_State(this.DROP_PRESS);
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
      
      private function ToggleSort() : void
      {
         this.m_State(this.SORT_PRESS);
      }
      
      private function SetFavorite() : void
      {
         this.m_State(this.FAVORITE_PRESS);
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
      
      private function OpenCargoHold() : void
      {
         this.m_State(this.CARGO_HOLD_PRESS);
      }
      
      private function onReturnToGameplay() : void
      {
         this.CloseMenu(true);
      }
      
      private function playFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function onInventoryUpdate(param1:FromClientDataEvent) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         this.PlayerInventoryData = param1.data;
         var _loc2_:* = this.CategoryList_mc.entryCount == 0;
         GlobalFunc.SetText(this.Footer_Value_tf,param1.data.uCoin.toString());
         var _loc3_:uint = uint(param1.data.fEncumbrance);
         var _loc4_:uint = uint(param1.data.fMaxEncumbrance);
         GlobalFunc.SetText(this.Footer_Weight_tf,_loc3_ + "/" + _loc4_);
         this.ItemDataA = param1.data.aItems;
         this.CategoryList_mc.InitializeEntries(param1.data.aCategories);
         var _loc5_:uint = 0;
         while(_loc5_ < param1.data.aCategories.length)
         {
            this.CompareItems[param1.data.aCategories[_loc5_].iFilterFlags] = !!param1.data.aCategories[_loc5_].bShowFeaturedItem ? param1.data.aCategories[_loc5_].uFeaturedItemHandle : 0;
            this.SecondaryCompareItems[param1.data.aCategories[_loc5_].iFilterFlags] = !!param1.data.aCategories[_loc5_].bShowFeaturedItem ? param1.data.aCategories[_loc5_].uSecondaryFeaturedItemHandle : 0;
            _loc5_++;
         }
         this.ItemList_mc.InitializeEntries(param1.data.aItems);
         var _loc6_:uint = 0;
         if(this.SortPerCategory[this.CurrFilter] != null)
         {
            _loc6_ = uint(this.SortPerCategory[this.CurrFilter]);
         }
         this.SortItemList();
         if(_loc2_)
         {
            this.m_State = this.state_CategoryList;
            this.m_State(this.ENTER_STATE);
            this.CategoryList_mc.selectedIndex = 0;
            this.m_State(this.LIST_ITEM_ROLLOVER);
            addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.playFocusSound);
         }
         else if(this.m_State == this.state_ItemList)
         {
            _loc7_ = false;
            _loc8_ = 0;
            while(_loc8_ < param1.data.aCategories.length)
            {
               if(param1.data.aCategories[_loc8_].iFilterFlags === this.CurrFilter)
               {
                  if(param1.data.aCategories[_loc8_].uTotalItemCount > 0)
                  {
                     _loc7_ = true;
                  }
                  break;
               }
               _loc8_++;
            }
            if(!_loc7_)
            {
               this.TransitionToState(this.state_CategoryList);
               BSUIDataManager.dispatchCustomEvent(this.EVENT_RESET_PAPER_DOLL_INV);
               this.m_State(this.LIST_ITEM_ROLLOVER);
            }
         }
      }
      
      private function onPlayerDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = this.CategoryList_mc.entryCount == 0;
         if(_loc2_ || this.HelmetShownInBreathableAreas != param1.data.bShowHelmetInBreathable)
         {
            this.HelmetShownInBreathableAreas = param1.data.bShowHelmetInBreathable;
            this.ToggleHelmetButtonData.sButtonText = this.HelmetShownInBreathableAreas ? this.InventoryHelmetHideLabel : this.InventoryHelmetShowLabel;
            (this.ToggleHelmetSuitButton as MinimalButton).RefreshButtonData();
         }
         if(_loc2_ || this.SuitShownInSettlements != param1.data.bShowSuitInSettlements)
         {
            this.SuitShownInSettlements = param1.data.bShowSuitInSettlements;
            this.ToggleSuitButtonData.sButtonText = this.SuitShownInSettlements ? this.InventorySuitHideLabel : this.InventorySuitShowLabel;
            (this.ToggleHelmetSuitButton as MinimalButton).RefreshButtonData();
         }
         if(Boolean(param1.data.bIsAboardOwnedShip) && !this.CargoHoldEnabled)
         {
            this.CargoHoldEnabled = true;
            if(this.m_State == this.state_CategoryList)
            {
               this.CargoHoldButton.Visible = true;
               this.CargoHoldButton.Enabled = true;
               this.ButtonBar_mc.RefreshButtons();
            }
         }
      }
      
      private function onPersonalEffectsDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc3_:* = false;
         var _loc4_:* = undefined;
         this.PersonalEffectIconsA.length = 0;
         var _loc2_:* = 0;
         while(_loc2_ < param1.data.aPersonalEffects.length)
         {
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < this.PersonalEffectIconsA.length && !_loc3_)
            {
               _loc3_ = this.PersonalEffectIconsA == param1.data.aPersonalEffects[_loc2_].sEffectIcon;
               _loc4_++;
            }
            if(!_loc3_)
            {
               this.PersonalEffectIconsA.push(param1.data.aPersonalEffects[_loc2_].sEffectIcon);
            }
            _loc2_++;
         }
         this.UpdateEffects();
      }
      
      private function onDataMenuInventoryDataUpdate(param1:FromClientDataEvent) : *
      {
         this.CanPaperDollPreviewFilterFlags = param1.data.CanPaperDollPreviewFilterFlags;
         this.m_State(this.LIST_ITEM_ROLLOVER);
      }
      
      private function UpdateEffects() : void
      {
         this.PlayerStatus_mc.PlayerEffectIconHolder_mc.removeChildren();
         var _loc1_:* = 0;
         var _loc2_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < this.PersonalEffectIconsA.length)
         {
            _loc2_ = this.AttachPersonalEffectIcon(this.PersonalEffectIconsA[_loc1_] as String,_loc2_);
            _loc1_++;
         }
         this.PlayerStatus_mc.Background_mc.height = _loc2_ > 0 ? 85 : 60;
      }
      
      private function AttachPersonalEffectIcon(param1:String, param2:Number) : Number
      {
         var _loc3_:MovieClip = new BioCondition();
         if(_loc3_ != null)
         {
            _loc3_.scaleX = PERSONAL_EFFECT_ICON_SCALE;
            _loc3_.scaleY = PERSONAL_EFFECT_ICON_SCALE;
            _loc3_.x = param2 + PERSONAL_EFFECT_ICON_X_OFFSET;
            param2 += PERSONAL_EFFECT_ICON_X_STEP;
            _loc3_.y = PERSONAL_EFFECT_ICON_Y_OFFSET;
            this.PlayerStatus_mc.PlayerEffectIconHolder_mc.addChild(_loc3_);
            _loc3_.gotoAndStop(param1);
         }
         return param2;
      }
      
      private function OnPlayerFreqDataUpdate(param1:FromClientDataEvent) : void
      {
         this.PlayerStatus_mc.PlayerMeter_mc.SetMaxValue(param1.data.fMaxHealth);
         this.PlayerStatus_mc.PlayerMeter_mc.SetCurrentValue(param1.data.fHealth);
         this.PlayerStatus_mc.PlayerMeter_mc.SetCurrentDamage(param1.data.fHealthBarDamage);
         this.PlayerStatus_mc.PlayerMeter_mc.SetHealthGainPercent(param1.data.fHealthGainPct);
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
      
      private function SortItemsByColumn(param1:Object, param2:Object) : int
      {
         var _loc3_:Number = InvColumnValueHelper.GetColumnSortVal(this.CurrFilter,param1);
         var _loc4_:Number = InvColumnValueHelper.GetColumnSortVal(this.CurrFilter,param2);
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
      
      private function ShouldShowPaperDoll(param1:int) : Boolean
      {
         return (param1 & this.CanPaperDollPreviewFilterFlags) != 0;
      }
      
      private function ToggleHelmet() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuInventoryHideShow");
         BSUIDataManager.dispatchCustomEvent(this.EVENT_TOGGLE_HELMET);
      }
      
      private function ToggleSuit() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuInventoryHideShow");
         BSUIDataManager.dispatchCustomEvent(this.EVENT_TOGGLE_SUIT);
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
      
      public function SortItemList() : *
      {
         var _loc1_:uint = this.GetCurrentSortIndex();
         if(this.SortOptions[_loc1_].sortFunc != null)
         {
            this.ItemList_mc.SortEntries(this.SortOptions[_loc1_].sortFunc);
         }
      }
      
      private function CycleSortIndex() : uint
      {
         var _loc1_:uint = this.GetCurrentSortIndex();
         _loc1_ = (_loc1_ + 1) % this.SortOptions.length;
         this.SortPerCategory[this.CurrFilter] = _loc1_;
         this.SortButtonData.sButtonText = this.SortOptions[_loc1_].text;
         this.SortButton.SetButtonData(this.SortButtonData);
         return _loc1_;
      }
      
      private function UpdateSortButtonText() : *
      {
         var _loc1_:uint = this.GetCurrentSortIndex();
         this.SortButtonData.sButtonText = this.SortOptions[_loc1_].text;
         this.SortButton.SetButtonData(this.SortButtonData);
      }
      
      private function UpdateSortOptions() : *
      {
         this.SortOptions = new Array();
         this.SortButtonData.sButtonText = "$SORT";
         this.SortButton.SetButtonData(this.SortButtonData);
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
         InvColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc1_].sortType);
      }
      
      public function onMouseOverModel(param1:MouseEvent) : void
      {
         this.mouseOverModel = true;
      }
      
      public function onMouseOutModel(param1:MouseEvent) : void
      {
         this.mouseOverModel = false;
      }
      
      protected function TransitionToState(param1:Function) : void
      {
         this.m_State(this.EXIT_STATE);
         this.m_State = param1;
         this.m_State(this.ENTER_STATE);
      }
      
      protected function state_CategoryList(param1:int) : *
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryHeader_mc.visible = true;
               this.CategoryList_mc.visible = true;
               this.CategoryFooter_mc.visible = true;
               this.DropButton.Visible = false;
               this.FavoriteButton.Visible = false;
               this.SortButton.Visible = false;
               this.CompareToEquippedButton.Visible = false;
               this.InspectButton.Visible = false;
               this.ToggleHelmetSuitButton.Visible = false;
               this.CargoHoldButton.Visible = this.CargoHoldEnabled;
               this.DropButton.Enabled = false;
               this.FavoriteButton.Enabled = false;
               this.SortButton.Enabled = false;
               this.InspectButton.Enabled = false;
               this.ToggleHelmetSuitButton.Enabled = false;
               this.EquippedItemCard_mc.visible = false;
               this.CargoHoldButton.Enabled = this.CargoHoldEnabled;
               this.ButtonBar_mc.RefreshButtons();
               stage.focus = this.CategoryList_mc;
               break;
            case this.LIST_ITEM_PRESS:
               if(this.CategoryList_mc.selectedEntry.uTotalItemCount > 0)
               {
                  this.CurrFilter = this.CategoryList_mc.selectedEntry.iFilterFlags;
                  InvItem.CurrFilter = this.CurrFilter;
                  InvColumnValueHelper.ResetColumnIndex(this.CurrFilter);
                  this.ItemList_mc.ReinitializeEntries();
                  this.UpdateSortOptions();
                  this.SortItemList();
                  GlobalFunc.SetText(this.ItemHeaderTitle_tf,this.CategoryList_mc.selectedEntry.sName);
                  GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,InvColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
                  this.TransitionToState(this.state_ItemList);
                  this.ItemList_mc.selectedIndex = 0;
                  this.m_State(this.LIST_ITEM_ROLLOVER);
                  BSUIDataManager.dispatchCustomEvent(this.EVENT_ON_ENTER_CATEGORY,{"iFilterFlag":this.CurrFilter});
                  GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
               }
               else
               {
                  GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               }
               break;
            case this.LIST_ITEM_ROLLOVER:
               if(this.AllowItemPreviews && Boolean(this.CategoryList_mc.selectedEntry))
               {
                  BSUIDataManager.dispatchCustomEvent(this.EVENT_CHANGE_3D_VIEW,{"iFilterFlag":this.CategoryList_mc.selectedEntry.iFilterFlags});
                  if(this.CategoryList_mc.selectedEntry.uFeaturedItemHandle != 0)
                  {
                     if(!this.ShouldShowPaperDoll(this.CategoryList_mc.selectedEntry.iFilterFlags))
                     {
                        BSUIDataManager.dispatchCustomEvent(this.EVENT_LOAD_3D_MODEL,{"uItemHandle":this.CategoryList_mc.selectedEntry.uFeaturedItemHandle});
                        this.CurrShownModel = this.CategoryList_mc.selectedEntry.uFeaturedItemHandle;
                     }
                     for each(_loc2_ in this.ItemDataA)
                     {
                        if(_loc2_.uHandleID == this.CategoryList_mc.selectedEntry.uFeaturedItemHandle)
                        {
                           this.ItemCard_mc.SetItemData(_loc2_,_loc2_);
                           this.ItemCard_mc.visible = true;
                        }
                     }
                  }
                  else
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_HIDE_3D_MODEL);
                     this.CurrShownModel = 0;
                     this.ItemCard_mc.visible = false;
                  }
               }
               break;
            case this.CARGO_HOLD_PRESS:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_OPEN_CARGO_HOLD);
               break;
            case this.CANCEL_PRESS:
               this.CloseMenu(false);
               break;
            case this.EXIT_STATE:
               this.CategoryHeader_mc.visible = false;
               this.CategoryList_mc.visible = false;
         }
      }
      
      private function CloseMenu(param1:Boolean) : *
      {
         if(!this.bExitingScreen)
         {
            this.bExitingScreen = true;
            this.bReturningToGame = param1;
            if(param1)
            {
               BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
               GlobalFunc.StartGameRender();
            }
            else
            {
               BSUIDataManager.dispatchEvent(new Event(this.EVENT_START_CLOSE_ANIM));
            }
            GlobalFunc.PlayMenuSound("UIMenuInventoryMenuClose");
            this.gotoAndPlay("closeMenu");
            this.ItemCard_mc.gotoAndPlay("closeMenu");
         }
      }
      
      private function OnCloseMenuFadeOutComplete() : *
      {
         if(this.bReturningToGame)
         {
            GlobalFunc.CloseAllMenus();
         }
         else
         {
            GlobalFunc.CloseMenu("InventoryMenu");
         }
      }
      
      private function ShowHealthMeterIfRequired() : *
      {
         var _loc1_:* = false;
         if(this.ItemList_mc.selectedEntry)
         {
            _loc1_ = (this.ItemList_mc.selectedEntry.iFilterFlag & InventoryItemUtils.ICF_AID) > 0;
            this.PlayerStatus_mc.visible = _loc1_;
            if(_loc1_)
            {
               this.PlayerStatus_mc.y = this.ItemCard_mc.y + this.ItemCard_mc.GetModsBackgroundBottom();
            }
         }
      }
      
      private function state_ItemList(param1:int) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         switch(param1)
         {
            case this.ENTER_STATE:
               this.ItemHeader_mc.visible = true;
               this.ItemList_mc.visible = true;
               this.ItemCard_mc.visible = true;
               this.DropButton.Visible = true;
               this.FavoriteButton.Visible = true;
               this.SortButton.Visible = true;
               this.InspectButton.Visible = true;
               this.CargoHoldButton.Visible = false;
               this.ToggleHelmetSuitButton.Visible = this.ToggleHelmetSuitButtonShouldBeVisible;
               this.ToggleHelmetSuitButton.Enabled = this.ToggleHelmetSuitButtonShouldBeEnabled;
               this.CompareToEquippedButton.Visible = this.CompareToEquippedButtonShouldBeVisible;
               this.CompareToEquippedButton.Enabled = this.CompareToEquippedButtonShouldBeEnabled;
               this.EquippedItemCard_mc.visible = this.EquippedItemCardShouldBeVisible;
               this.DropButton.Enabled = true;
               this.FavoriteButton.Enabled = false;
               this.CargoHoldButton.Enabled = false;
               if(this.ItemList_mc.selectedEntry)
               {
                  this.FavoriteButton.Enabled = this.ItemList_mc.selectedEntry.bCanFavorite === true;
               }
               this.SortButton.Enabled = true;
               this.InspectButton.Enabled = true;
               this.UpdateSortButtonText();
               this.ButtonBar_mc.RefreshButtons();
               this.CategoryFooter_mc.visible = true;
               stage.focus = this.ItemList_mc;
               this.ShowHealthMeterIfRequired();
               this.m_State(this.LIST_ITEM_ROLLOVER);
               break;
            case this.LIST_ITEM_PRESS:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_SELECT_ITEM,{"uItemHandle":this.ItemList_mc.selectedEntry.uHandleID});
               break;
            case this.LIST_ITEM_ROLLOVER:
               if(this.AllowItemPreviews && this.ItemList_mc.selectedEntry && this.ItemList_mc.selectedEntry.uHandleID != this.CurrShownModel)
               {
                  BSUIDataManager.dispatchCustomEvent(this.EVENT_CHANGE_3D_VIEW,{"iFilterFlag":this.ItemList_mc.selectedEntry.iFilterFlag});
                  if((this.ItemList_mc.selectedEntry.iFilterFlag & InventoryItemUtils.ICF_HELMETS) != 0)
                  {
                     this.ToggleHelmetSuitButton.SetButtonData(this.ToggleHelmetButtonData);
                     this.ToggleHelmetSuitButton.Visible = true;
                     this.ToggleHelmetSuitButton.Enabled = true;
                  }
                  else if((this.ItemList_mc.selectedEntry.iFilterFlag & InventoryItemUtils.ICF_SPACESUITS) != 0)
                  {
                     this.ToggleHelmetSuitButton.SetButtonData(this.ToggleSuitButtonData);
                     this.ToggleHelmetSuitButton.Visible = true;
                     this.ToggleHelmetSuitButton.Enabled = true;
                  }
                  else
                  {
                     this.ToggleHelmetSuitButton.Visible = false;
                     this.ToggleHelmetSuitButton.Enabled = false;
                  }
                  this.ButtonBar_mc.RefreshButtons();
                  if(this.ShouldShowPaperDoll(this.ItemList_mc.selectedEntry.iFilterFlag))
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_TRY_ON,{"uItemHandle":this.ItemList_mc.selectedEntry.uHandleID});
                  }
                  else
                  {
                     BSUIDataManager.dispatchCustomEvent(this.EVENT_LOAD_3D_MODEL,{"uItemHandle":this.ItemList_mc.selectedEntry.uHandleID});
                  }
                  this.CurrShownModel = this.ItemList_mc.selectedEntry.uHandleID;
                  _loc3_ = null;
                  _loc4_ = 0;
                  _loc5_ = false;
                  if((this.ItemList_mc.selectedEntry.iFilterFlag & InventoryItemUtils.ICF_APPAREL) != 0)
                  {
                     _loc5_ = this.ItemList_mc.selectedEntry.ArmorInfo.bIsHeadgear;
                  }
                  if(this.CurrFilter == InventoryItemUtils.ICF_ALL || this.CurrFilter == InventoryItemUtils.ICF_NEW_ITEMS)
                  {
                     _loc6_ = 0;
                     while(_loc6_ < InventoryItemUtils.ICF_COUNT)
                     {
                        if(this.ItemList_mc.selectedEntry.iFilterFlag & 1 << _loc6_)
                        {
                           if((_loc4_ = !!_loc5_ ? uint(this.SecondaryCompareItems[1 << _loc6_]) : uint(this.CompareItems[1 << _loc6_])) > 0)
                           {
                              break;
                           }
                        }
                        _loc6_++;
                     }
                  }
                  else if(this.CategoryList_mc.selectedEntry.bShowFeaturedItem)
                  {
                     _loc4_ = !!_loc5_ ? uint(this.CategoryList_mc.selectedEntry.uSecondaryFeaturedItemHandle) : uint(this.CategoryList_mc.selectedEntry.uFeaturedItemHandle);
                  }
                  if(_loc4_ > 0)
                  {
                     for each(_loc7_ in this.ItemDataA)
                     {
                        if(_loc7_.uHandleID == _loc4_)
                        {
                           _loc3_ = _loc7_;
                           break;
                        }
                     }
                  }
                  if(_loc3_ == null)
                  {
                     this.CompareToEquippedButton.Visible = false;
                     this.CompareToEquippedButton.Enabled = false;
                     this.ButtonBar_mc.RefreshButtons();
                     this.EquippedItemCard_mc.visible = false;
                     _loc3_ = this.ItemList_mc.selectedEntry;
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
                  this.FavoriteButton.Enabled = this.ItemList_mc.selectedEntry.bCanFavorite === true;
                  this.ShowHealthMeterIfRequired();
               }
               break;
            case this.CANCEL_PRESS:
               this.TransitionToState(this.state_CategoryList);
               BSUIDataManager.dispatchCustomEvent(this.EVENT_RESET_PAPER_DOLL_INV);
               this.m_State(this.LIST_ITEM_ROLLOVER);
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
               break;
            case this.DROP_PRESS:
               if(this.ShouldAutoDropAll(this.ItemList_mc.selectedEntry))
               {
                  this.doDropItems(this.ItemList_mc.selectedEntry,1);
               }
               else
               {
                  this.TransitionToState(this.state_Quantity);
               }
               break;
            case this.SORT_PRESS:
               _loc2_ = this.CycleSortIndex();
               this.ButtonBar_mc.RefreshButtons();
               InvColumnValueHelper.SetColumnBySortType(this.CurrFilter,this.SortOptions[_loc2_].sortType);
               GlobalFunc.SetText(this.ItemHeaderCompareLabel_tf,InvColumnValueHelper.GetColumnHeaderString(this.CurrFilter));
               this.ItemList_mc.ReinitializeEntries();
               this.SortItemList();
               GlobalFunc.PlayMenuSound("UIMenuGeneralColumn");
               break;
            case this.FAVORITE_PRESS:
               BSUIDataManager.dispatchCustomEvent(this.EVENT_TOGGLE_FAVORITE,{
                  "uItemHandle":this.ItemList_mc.selectedEntry.uHandleID,
                  "uFormID":this.ItemList_mc.selectedEntry.uFormID
               });
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
               this.PlayerStatus_mc.visible = false;
               this.CompareToEquippedButtonShouldBeVisible = this.CompareToEquippedButton.Visible;
               this.CompareToEquippedButtonShouldBeEnabled = this.CompareToEquippedButton.Enabled;
               this.EquippedItemCardShouldBeVisible = this.EquippedItemCard_mc.visible;
         }
      }
      
      private function ShouldAutoDropAll(param1:Object) : Boolean
      {
         return param1.uCount < QuantityComponent.INV_MAX_NUM_BEFORE_QUANTITY_MENU;
      }
      
      private function state_InspectMode(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryList_mc.disableInput = true;
               this.ItemList_mc.disableInput = true;
               this.DropButton.Visible = false;
               this.SortButton.Visible = false;
               this.FavoriteButton.Visible = false;
               this.DropButton.Enabled = false;
               this.SortButton.Enabled = false;
               this.FavoriteButton.Enabled = false;
               this.CategoryFooter_mc.visible = false;
               this.ToggleHelmetSuitButtonShouldBeVisible = this.ToggleHelmetSuitButton.Visible;
               this.ToggleHelmetSuitButtonShouldBeEnabled = this.ToggleHelmetSuitButton.Enabled;
               this.ToggleHelmetSuitButton.Visible = false;
               this.ToggleHelmetSuitButton.Enabled = false;
               this.InspectButton.Visible = false;
               this.InspectButton.Enabled = true;
               this.CargoHoldButton.Visible = false;
               this.CargoHoldButton.Enabled = false;
               this.CompareToEquippedButton.Visible = false;
               this.CompareToEquippedButton.Enabled = false;
               this.EquippedItemCard_mc.visible = false;
               this.ButtonBar_mc.RefreshButtons();
               gotoAndPlay("enterInspect");
               GlobalFunc.PlayMenuSound("UIMenuInventoryInspect");
               break;
            case this.CANCEL_PRESS:
            case this.INSPECT_PRESS:
               gotoAndPlay("exitInspect");
               this.TransitionToState(this.state_ItemList);
               break;
            case this.EXIT_STATE:
               this.CategoryList_mc.disableInput = false;
               this.ItemList_mc.disableInput = false;
               GlobalFunc.PlayMenuSound("UIMenuInventoryInspect");
         }
      }
      
      private function state_Quantity(param1:int) : *
      {
         switch(param1)
         {
            case this.ENTER_STATE:
               this.CategoryList_mc.disableInput = true;
               this.ItemList_mc.disableInput = true;
               this.ButtonBar_mc.visible = false;
               this.QuantityVignette_mc.visible = true;
               this.QuantityMenu_mc.SetData(this.ItemList_mc.selectedEntry.uCount,"$Quantity_InventoryDrop");
               this.QuantityMenu_mc.addEventListener(QuantityComponent.CONFIRM_TRANSACTION,this.onQuantityConfirm);
               this.QuantityMenu_mc.addEventListener(QuantityComponent.WINDOW_CLOSED,this.onQuantityCancel);
               this.QuantityMenu_mc.visible = true;
               GlobalFunc.PlayMenuSound("UIToolTipPopUpStart");
               stage.focus = this.QuantityMenu_mc;
               break;
            case this.EXIT_STATE:
               this.QuantityMenu_mc.removeEventListener(QuantityComponent.CONFIRM_TRANSACTION,this.onQuantityConfirm);
               this.QuantityMenu_mc.removeEventListener(QuantityComponent.WINDOW_CLOSED,this.onQuantityCancel);
               this.CategoryList_mc.disableInput = false;
               this.ItemList_mc.disableInput = false;
               this.ButtonBar_mc.visible = true;
               this.QuantityVignette_mc.visible = false;
               this.QuantityMenu_mc.visible = false;
               GlobalFunc.PlayMenuSound("UIToolTipPopUpStop");
         }
      }
      
      private function onQuantityConfirm() : void
      {
         this.TransitionToState(this.state_ItemList);
         this.doDropItems(this.ItemList_mc.selectedEntry,this.QuantityMenu_mc.CurrentQuantity);
      }
      
      private function doDropItems(param1:Object, param2:uint) : void
      {
         if(this.ItemList_mc.itemsShown == 1 && param1.uCount == param2)
         {
            this.m_State(this.CANCEL_PRESS);
         }
         BSUIDataManager.dispatchCustomEvent(this.EVENT_DROP_ITEM,{
            "uItemHandle":param1.uHandleID,
            "uCount":param2
         });
      }
      
      private function onQuantityCancel() : void
      {
         this.TransitionToState(this.state_ItemList);
         this.m_State(this.LIST_ITEM_ROLLOVER);
      }
   }
}
