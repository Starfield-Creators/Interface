package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.events.Event;
   
   public class WorkshopQuickMenu extends IMenu
   {
       
      
      public var DisplayMessage_mc:DisplayMessage;
      
      public var InspectItemCard_mc:OutpostItemCard;
      
      public var ActionCard_mc:ActionCard;
      
      public var ColorPopup_mc:ColorPopup;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var ConfirmButtonData:ButtonBaseData;
      
      private var XButtonData:ButtonBaseData;
      
      private var CancelButtonData:ButtonBaseData;
      
      private var ConfirmButton:IButton = null;
      
      private var XButton:IButton = null;
      
      private var CancelButton:IButton = null;
      
      private const BUTTON_BAR_BG_HORIZONTAL_PADDING:Number = 5;
      
      private var _mode:uint;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      private var _skillLibrary:SharedLibraryOwner = null;
      
      private const BORDER_BOUND:Number = 50;
      
      private const POPUP_OFFSET:Number = -4;
      
      public function WorkshopQuickMenu()
      {
         this.ConfirmButtonData = new ButtonBaseData("$CONFIRM",new UserEventData("Confirm",this.OnConfirmAction));
         this.XButtonData = new ButtonBaseData("$DEFAULT_COLOR",new UserEventData("XButton",this.OnXButton));
         this.CancelButtonData = new ButtonBaseData("$CANCEL",new UserEventData("QMCancel",this.OnExit));
         super();
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         this._skillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,AttributeIcon.SET_LOADER);
         this._mode = WorkshopUtils.WQM_IDLE;
         this.ColorPopup_mc.active = false;
         this.ColorPopup_mc.contextName = WorkshopUtils.QUICK_MENU_INPUT_CONTEXT;
         this.PopulateButtonBars();
         BSUIDataManager.Subscribe("WorkshopQuickMenuData",this.OnQuickMenuDataUpdate);
         BSUIDataManager.Subscribe("WorkshopPickRefData",this.OnPickRefDataUpdate);
         addEventListener(ActionCard.CURRENT_ACTION_CHANGED,this.onPopupActionChanged);
         this.UpdateButtonVisibility();
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
      
      public function set mode(param1:uint) : *
      {
         if(this._mode != param1)
         {
            this._mode = param1;
            this.ActionCard_mc.mode = this._mode;
            this.UpdateButtonVisibility();
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.focus = this.ActionCard_mc.focusObject;
      }
      
      override public function onRemovedFromStage() : void
      {
         this._organicLibrary.RemoveEventListener();
         this._skillLibrary.RemoveEventListener();
         super.onRemovedFromStage();
      }
      
      override protected function onSetSafeRect() : void
      {
         GlobalFunc.LockToSafeRect(this.ColorPopup_mc,"TR",this.BORDER_BOUND,this.BORDER_BOUND + this.POPUP_OFFSET,true);
         GlobalFunc.LockToSafeRect(this.InspectItemCard_mc,"TL",this.BORDER_BOUND,this.BORDER_BOUND);
         GlobalFunc.LockToSafeRect(this.ActionCard_mc,"CC",this.BORDER_BOUND,this.BORDER_BOUND);
         GlobalFunc.LockToSafeRect(this.DisplayMessage_mc,"BC",this.BORDER_BOUND,this.BORDER_BOUND);
         GlobalFunc.LockToSafeRect(this.ButtonBar_mc,"R",this.BORDER_BOUND,this.BORDER_BOUND);
      }
      
      private function PopulateButtonBars() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.SetBackgroundPadding(this.BUTTON_BAR_BG_HORIZONTAL_PADDING,0);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.XButton = ButtonFactory.AddToButtonBar("BasicButton",this.XButtonData,this.ButtonBar_mc);
         this.CancelButton = ButtonFactory.AddToButtonBar("BasicButton",this.CancelButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function OnQuickMenuDataUpdate(param1:FromClientDataEvent) : void
      {
         this.mode = param1.data.uCurrentMode;
      }
      
      private function OnPickRefDataUpdate(param1:FromClientDataEvent) : void
      {
         this.InspectItemCard_mc.UpdateItemData(param1.data);
         this.ActionCard_mc.UpdateCardData(param1.data);
      }
      
      private function UpdateButtonVisibility() : void
      {
         var _loc1_:* = this._mode == WorkshopUtils.WQM_HUD_PERFORMING_ACTION;
         this.ConfirmButtonData.bVisible = _loc1_;
         this.ConfirmButtonData.bEnabled = _loc1_;
         this.ConfirmButton.SetButtonData(this.ConfirmButtonData);
         this.XButton.Visible = _loc1_ && this.ActionCard_mc.currentAction == WorkshopUtils.WIA_SET_COLORS;
         this.XButton.Enabled = this.XButton.Visible;
         this.CancelButton.Visible = _loc1_;
         this.CancelButton.Enabled = _loc1_;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_ && this.ActionCard_mc.active)
         {
            _loc3_ = this.ActionCard_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.ColorPopup_mc.active)
         {
            _loc3_ = this.ColorPopup_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onPopupActionChanged(param1:CustomEvent) : void
      {
         switch(param1.params.action)
         {
            case WorkshopUtils.WIA_WIRE:
               this.ConfirmButtonData.sButtonText = "$ATTACH WIRE";
               break;
            case WorkshopUtils.WIA_TRANSFER_LINK:
               this.ConfirmButtonData.sButtonText = "$CREATE OUTPUT LINK";
               break;
            default:
               this.ConfirmButtonData.sButtonText = "$CONFIRM";
         }
         this.ConfirmButton.SetButtonData(this.ConfirmButtonData);
         this.ButtonBar_mc.RefreshButtons();
         this.ColorPopup_mc.active = param1.params.action == WorkshopUtils.WIA_SET_COLORS;
         if(this.ColorPopup_mc.active)
         {
            stage.focus = this.ColorPopup_mc;
         }
      }
      
      private function OnExit() : void
      {
         BSUIDataManager.dispatchEvent(new Event("WorkshopQuickMenu_ExitMenu"));
      }
      
      private function OnConfirmAction() : void
      {
         if(this.ActionCard_mc.currentAction == WorkshopUtils.WIA_SET_COLORS)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_ApplyColors",{"colorScheme":WorkshopUtils.CUSTOM_COLORS}));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopQuickMenu_ConfirmAction",{"actionType":this.ActionCard_mc.currentAction}));
         }
      }
      
      private function OnXButton() : void
      {
         if(this.ActionCard_mc.currentAction == WorkshopUtils.WIA_SET_COLORS)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_ApplyColors",{"colorScheme":WorkshopUtils.DEFAULT_COLORS}));
         }
      }
   }
}
