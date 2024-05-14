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
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class GenesisTerminal extends IMenu
   {
      
      public static const FACTION_CONSTELLATION:int = EnumHelper.GetEnum(0);
      
      public static const FACTION_FREESTAR:int = EnumHelper.GetEnum();
      
      public static const FACTION_GENERIC:int = EnumHelper.GetEnum();
      
      public static const FACTION_NASA:int = EnumHelper.GetEnum();
      
      public static const FACTION_RYUJININDUSTRIES:int = EnumHelper.GetEnum();
      
      public static const FACTION_SLAYTONAEROSPACE:int = EnumHelper.GetEnum();
      
      public static const FACTION_UNITEDCOLONIES:int = EnumHelper.GetEnum();
      
      public static const FACTION_CRIMSONFLEET:int = EnumHelper.GetEnum();
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var DesktopIcons_mc:DesktopIconHolder;
      
      public var PopupWindowContainer_mc:MovieClip;
      
      public var WindowCascadePadding_mc:MovieClip;
      
      public var KioskContainer_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private const EVENT_CANCELEVENT:String = "TerminalMenu_CancelEvent";
      
      private const EVENT_TEXTLOOPSOUND_START:String = "TerminalMenu_TextLoopSound_Start";
      
      private const EVENT_TEXTLOOPSOUND_STOP:String = "TerminalMenu_TextLoopSound_Stop";
      
      private const VIEW_DESKTOP:String = "$VIEW_DESKTOP";
      
      private const VIEW_WINDOWS:String = "$VIEW_WINDOWS";
      
      private const IS_OPEN:String = "IsOpen";
      
      private var MAX_CASCADED_WINDOWS:uint = 2;
      
      private var DesktopButtonData:ButtonBaseData;
      
      private var _popupWindowsV:Vector.<MovieClip>;
      
      private var _closing:Boolean = false;
      
      private var _openedDesktopIconID:int = -1;
      
      private var KioskViewOpenCount:int = 0;
      
      private var SingleItemOnDesktop:Boolean = false;
      
      private var FactionId:int = 0;
      
      public function GenesisTerminal()
      {
         this._popupWindowsV = new Vector.<MovieClip>();
         super();
         addEventListener("onOpenAnimComplete",this.onOpenAnimComplete);
         addEventListener("onCloseAnimComplete",this.onCloseAnimComplete);
         addEventListener("onCloseViews",this.onCloseViews);
         addEventListener(FolderView.CLOSE_CLICK_EVENT,this.onCloseWindow);
         addEventListener(DocumentView.CLOSE_CLICK_EVENT,this.onCloseWindow);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.DesktopButtonData = new ButtonBaseData(this.VIEW_DESKTOP,new UserEventData("SwitchView",this.onToggleViewsEvent),true,false);
         this.ButtonBar_mc.AddButtonWithData(this.DesktopButton,this.DesktopButtonData);
         var _loc1_:String = "$EXIT HOLD";
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ReleaseHoldComboButtonData("$BACK",_loc1_,[new UserEventData("Cancel",this.onCancelEvent),new UserEventData("",this.PlayCloseAnim)]));
         this.ButtonBar_mc.RefreshButtons();
         this.visible = true;
         this.PopupWindowContainer_mc.visible = false;
         this.KioskContainer_mc.visible = false;
         this.KioskContainer_mc.width = this.width;
         this.KioskContainer_mc.height = this.height;
         GlobalFunc.PlayMenuSound("UI_Terminal_General_01_Enter");
      }
      
      public static function GetFactionNameFromId(param1:int) : String
      {
         var _loc2_:String = "Generic";
         switch(param1)
         {
            case FACTION_CONSTELLATION:
               _loc2_ = "Constellation";
               break;
            case FACTION_FREESTAR:
               _loc2_ = "Freestar";
               break;
            case FACTION_NASA:
               _loc2_ = "NASA";
               break;
            case FACTION_RYUJININDUSTRIES:
               _loc2_ = "Ryujin";
               break;
            case FACTION_SLAYTONAEROSPACE:
               _loc2_ = "SlaytonAerospace";
               break;
            case FACTION_UNITEDCOLONIES:
               _loc2_ = "UnitedColonies";
               break;
            case FACTION_CRIMSONFLEET:
               _loc2_ = "CrimsonFleet";
         }
         return _loc2_;
      }
      
      private function get DesktopButton() : IButton
      {
         return this.ButtonBar_mc.DesktopButton_mc;
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function set ShowMinimizedIcon(param1:Boolean) : *
      {
         this.DesktopIcons_mc.ShowIconAsMinimized(this._openedDesktopIconID,param1);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("DesktopViewData",this.OnReceivedDesktopData);
         BSUIDataManager.Subscribe("FolderViewData",this.OnReceivedFolderData);
         BSUIDataManager.Subscribe("DocumentViewData",this.OnReceivedDocumentData);
         BSUIDataManager.Subscribe("ItemActionData",this.OnReceivedItemActionData);
         BSUIDataManager.Subscribe("FactionData",this.OnReceivedFactionData);
         GlobalFunc.PlayMenuSound("Play_OBJ_Terminal_Machine_LP");
      }
      
      private function OnReceivedFactionData(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         this.UpdateFaction(_loc2_.iFactionId);
      }
      
      private function UpdateFaction(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         if(param1 > -1)
         {
            this.FactionId = param1;
            _loc2_ = GetFactionNameFromId(this.FactionId);
            GlobalFunc.PlayMenuSound("OBJTerminalSplashScreenOneshot_" + _loc2_);
            this.KioskContainer_mc.UpdateFaction(_loc2_);
            this.Background_mc.gotoAndStop(_loc2_);
            this.DesktopIcons_mc.Faction = _loc2_;
            for each(_loc3_ in this._popupWindowsV)
            {
               _loc3_.UpdateFaction(_loc2_);
            }
         }
      }
      
      private function OnReceivedDesktopData(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         if(_loc2_.bInitialized == true)
         {
            this.SingleItemOnDesktop = (_loc2_.aIcons as Array).length == 1;
            this.DesktopButton.Enabled = !this.SingleItemOnDesktop;
            this.ButtonBar_mc.RefreshButtons();
            this.DesktopIcons_mc.InitializeDesktopIcons(_loc2_.aIcons,uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE);
         }
      }
      
      private function OnReceivedFolderData(param1:FromClientDataEvent) : void
      {
         var _loc3_:FolderView = null;
         var _loc4_:Boolean = false;
         var _loc2_:* = param1.data;
         if(_loc2_.bInitialized == true)
         {
            if(Boolean(_loc2_.bIsKiosk) || this.KioskContainer_mc.visible && !this.KioskContainer_mc.Closing)
            {
               if(this.KioskViewOpenCount <= 0 || Boolean(_loc2_.bCreatesNewWindow))
               {
                  ++this.KioskViewOpenCount;
               }
               this.KioskContainer_mc.RefreshKioskView(_loc2_);
            }
            else
            {
               _loc3_ = this.GetCurrentWindow() as FolderView;
               if(_loc4_ = Boolean(_loc2_.bCreatesNewWindow) || _loc3_ == null)
               {
                  _loc3_ = new FolderView();
                  this.OpenNewPopupWindow(_loc3_);
               }
               _loc3_.UpdateFaction(GetFactionNameFromId(this.FactionId));
               _loc3_.headerText = _loc2_.sHeader;
               _loc3_.Refresh(_loc2_.aIcons,uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE);
               if(currentFrameLabel == this.IS_OPEN)
               {
                  _loc3_.SetFocus();
               }
            }
            this.DesktopButton.Visible = !this.SingleItemOnDesktop;
            this.DesktopButton.Enabled = !this.SingleItemOnDesktop;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function OnReceivedDocumentData(param1:FromClientDataEvent) : void
      {
         var _loc3_:DocumentView = null;
         var _loc4_:Boolean = false;
         var _loc2_:* = param1.data;
         if(_loc2_.bInitialized == true)
         {
            if(Boolean(_loc2_.bIsKiosk) || this.KioskContainer_mc.visible && !this.KioskContainer_mc.Closing)
            {
               if(this.KioskViewOpenCount <= 0 || Boolean(_loc2_.bCreatesNewWindow))
               {
                  ++this.KioskViewOpenCount;
               }
               this.KioskContainer_mc.RefreshKioskView(_loc2_);
            }
            else
            {
               _loc3_ = this.GetCurrentWindow() as DocumentView;
               if(_loc4_ = Boolean(_loc2_.bCreatesNewWindow) || _loc3_ == null)
               {
                  _loc3_ = new DocumentView();
                  this.OpenNewPopupWindow(_loc3_);
               }
               _loc3_.UpdateFaction(GetFactionNameFromId(this.FactionId));
               _loc3_.Refresh(_loc2_.sHeader,_loc2_.sBody,_loc2_.aIcons);
               if(currentFrameLabel == this.IS_OPEN)
               {
                  _loc3_.SetFocus();
               }
            }
            this.DesktopButton.Visible = !this.SingleItemOnDesktop;
            this.DesktopButton.Enabled = !this.SingleItemOnDesktop;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function OnReceivedItemActionData(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         switch(_loc2_.iItemActionType)
         {
            case 0:
               break;
            case 1:
               this.CloseAllAndReturnToDesktop();
               break;
            case 2:
               if(this.CloseTopView())
               {
                  this.PlayCloseAnim();
               }
               break;
            case 3:
               this.CloseAllAndReturnToDesktop();
               BSUIDataManager.dispatchEvent(new CustomEvent(GenesisTerminalShared.MENU_ITEM_CLICK_EVENT,{
                  "iIconId":_loc2_.iMenuItemIndex,
                  "iParentStackLevel":0
               }));
         }
      }
      
      private function OpenNewPopupWindow(param1:MovieClip) : void
      {
         var _loc2_:uint = this._popupWindowsV.length;
         if(_loc2_ == 0)
         {
            this.MAX_CASCADED_WINDOWS = (this.PopupWindowContainer_mc.height - param1.height) / this.WindowCascadePadding_mc.height + 1;
         }
         param1.x = this.WindowCascadePadding_mc.width * (_loc2_ / this.MAX_CASCADED_WINDOWS);
         param1.y = this.WindowCascadePadding_mc.height * (_loc2_ % this.MAX_CASCADED_WINDOWS);
         param1.scaleX = 1 / this.PopupWindowContainer_mc.scaleX;
         param1.scaleY = 1 / this.PopupWindowContainer_mc.scaleY;
         this.PopupWindowContainer_mc.addChild(param1);
         this._popupWindowsV.push(param1);
         this.PlayOpenPopupSound();
         if(_loc2_ != 0)
         {
            this._popupWindowsV[_loc2_ - 1].mouseChildren = false;
         }
         if(param1 is FolderView)
         {
            GlobalFunc.PlayMenuSound("UI_Terminal_General_OK_Folder_Enter");
         }
         this.PopupWindowContainer_mc.visible = true;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(currentFrameLabel == "IsOpen")
         {
            if(this.KioskContainer_mc.HasFocus)
            {
               _loc3_ = Boolean(this.KioskContainer_mc.KioskView_mc.ProcessUserEvent(param1,param2));
            }
            else if(this._popupWindowsV.length > 0 && Boolean(this.GetCurrentWindow().HasFocus))
            {
               _loc3_ = Boolean(this.GetCurrentWindow().ProcessUserEvent(param1,param2));
            }
            else if(stage.focus == this.DesktopIcons_mc)
            {
               this.DesktopIcons_mc.ProcessUserEvent(param1,param2);
            }
            if(!_loc3_)
            {
               _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
         }
         return _loc3_;
      }
      
      public function PlayCloseAnim() : void
      {
         GlobalFunc.PlayMenuSound("UI_Terminal_General_01_Exit");
         GlobalFunc.StartGameRender();
         gotoAndPlay("Close");
         this._closing = true;
      }
      
      public function onCloseViews() : void
      {
         this.KioskContainer_mc.visible = false;
         this.CloseAllPopupWindows();
      }
      
      public function onCloseAnimComplete() : void
      {
         GlobalFunc.CloseMenu("GenesisTerminalMenu");
      }
      
      public function onOpenAnimComplete() : void
      {
         if(this.KioskContainer_mc.visible)
         {
            this.KioskContainer_mc.SetFocus();
         }
         else if(this._popupWindowsV.length > 0 && this.PopupWindowContainer_mc.visible)
         {
            this.GetCurrentWindow().SetFocus();
         }
         else
         {
            stage.focus = this.DesktopIcons_mc;
         }
         addEventListener(GenesisTerminalShared.MENU_ITEM_CLICK_EVENT,this.onIconClick);
      }
      
      private function onCancelEvent() : void
      {
         if(!this._closing && !this.KioskContainer_mc.Closing)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(this.EVENT_CANCELEVENT,{}));
         }
      }
      
      private function onToggleViewsEvent() : void
      {
         var _loc1_:* = this.PopupWindowContainer_mc.visible || this.KioskContainer_mc.visible;
         this.PopupWindowContainer_mc.visible = !_loc1_;
         this.DesktopButtonData.bVisible = true;
         this.DesktopButtonData.sButtonText = !_loc1_ ? this.VIEW_DESKTOP : this.VIEW_WINDOWS;
         this.DesktopButton.SetButtonData(this.DesktopButtonData);
         this.ButtonBar_mc.RefreshButtons();
         if(_loc1_)
         {
            this.CloseKiosk();
            this.PopupWindowContainer_mc.visible = false;
            stage.focus = this.DesktopIcons_mc;
         }
         else
         {
            this.PopupWindowContainer_mc.visible = this._popupWindowsV.length > 0;
            if(this.KioskViewOpenCount > 0)
            {
               this.KioskContainer_mc.OpenKioskView();
               this.KioskContainer_mc.SetFocus();
            }
            else
            {
               this.GetCurrentWindow().SetFocus();
            }
         }
         this.ShowMinimizedIcon = _loc1_;
      }
      
      private function onCloseWindow(param1:Event) : void
      {
         this.CloseTopView();
      }
      
      private function CloseTopView() : Boolean
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Boolean = false;
         if(this.KioskContainer_mc.visible)
         {
            if(!this.KioskContainer_mc.Closing && --this.KioskViewOpenCount < 1)
            {
               this.KioskViewOpenCount = 0;
               this.DesktopButton.Visible = this._popupWindowsV.length > 0;
               this.ButtonBar_mc.RefreshButtons();
               _loc1_ = this._popupWindowsV.length == 0 && this.SingleItemOnDesktop;
               if(!_loc1_)
               {
                  this.CloseKiosk();
               }
            }
            else
            {
               GlobalFunc.PlayMenuSound("UITerminalGeneralCancel");
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(GenesisTerminalShared.CLOSE_TOP_VIEW_EVENT,{}));
         }
         else if(this.PopupWindowContainer_mc.visible && this._popupWindowsV.length > 0)
         {
            this.ClosePopupWindow(this._popupWindowsV.length - 1);
            _loc2_ = this.GetCurrentWindow();
            if(_loc2_)
            {
               _loc2_.mouseChildren = true;
               _loc2_.SetFocus();
            }
            else
            {
               this.PopupWindowContainer_mc.visible = false;
               this.DesktopButton.Visible = false;
               this.ButtonBar_mc.RefreshButtons();
               stage.focus = this.DesktopIcons_mc;
            }
            BSUIDataManager.dispatchEvent(new CustomEvent(GenesisTerminalShared.CLOSE_TOP_VIEW_EVENT,{}));
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function ClosePopupWindow(param1:int) : void
      {
         var _loc2_:* = undefined;
         if(param1 < this._popupWindowsV.length && this.PopupWindowContainer_mc.visible)
         {
            _loc2_ = this._popupWindowsV[param1];
            if(_loc2_ is DocumentView)
            {
               (_loc2_ as DocumentView).onClose();
            }
            this.PopupWindowContainer_mc.removeChild(_loc2_);
            this.PopupWindowContainer_mc.visible = this._popupWindowsV.length != 0;
            this._popupWindowsV.splice(param1,1);
            this.PlayClosePopupSound();
         }
      }
      
      private function CloseAllAndReturnToDesktop() : void
      {
         this.KioskContainer_mc.CloseKioskView();
         this.KioskViewOpenCount = 0;
         if(this._popupWindowsV.length > 0)
         {
            this.PopupWindowContainer_mc.removeChildren();
            this._popupWindowsV.length = 0;
         }
         this.DesktopButton.Visible = false;
         this.ButtonBar_mc.RefreshButtons();
         stage.focus = this.DesktopIcons_mc;
         BSUIDataManager.dispatchEvent(new Event(GenesisTerminalShared.CLOSE_ALL_VIEWS_EVENT));
      }
      
      private function CloseKiosk() : void
      {
         if(this.KioskContainer_mc.visible)
         {
            this.KioskContainer_mc.CloseKioskView();
            stage.focus = this.DesktopIcons_mc;
         }
      }
      
      private function CloseAllPopupWindows() : void
      {
         if(this._popupWindowsV.length > 0)
         {
            this.PopupWindowContainer_mc.removeChildren();
            this._popupWindowsV.length = 0;
            stage.focus = this.DesktopIcons_mc;
            BSUIDataManager.dispatchEvent(new Event(GenesisTerminalShared.CLOSE_ALL_VIEWS_EVENT));
         }
      }
      
      private function PlayOpenPopupSound() : void
      {
         switch(this._popupWindowsV.length)
         {
            case 0:
               break;
            case 1:
               GlobalFunc.PlayMenuSound("UIOBJTerminalHDAccessDown01");
               break;
            case 2:
               GlobalFunc.PlayMenuSound("UIOBJTerminalHDAccessDown02");
               break;
            default:
               GlobalFunc.PlayMenuSound("UIOBJTerminalHDAccessDown03");
         }
      }
      
      private function PlayClosePopupSound() : void
      {
         GlobalFunc.PlayMenuSound("UI_Terminal_General_OK_Folder_Exit");
         switch(this._popupWindowsV.length)
         {
            case 0:
               GlobalFunc.PlayMenuSound("UIOBJTerminalHDAccessUp01");
               break;
            case 1:
               GlobalFunc.PlayMenuSound("UIOBJTerminalHDAccessUp02");
               break;
            default:
               GlobalFunc.PlayMenuSound("UIOBJTerminalHDAccessUp03");
         }
      }
      
      private function onIconClick(param1:CustomEvent) : void
      {
         GlobalFunc.PlayMenuSound("Play_UI_Terminal_General_OK");
         if(!this.PopupWindowContainer_mc.visible && !this.KioskContainer_mc.visible)
         {
            this.CloseAllPopupWindows();
            this.ShowMinimizedIcon = false;
            this._openedDesktopIconID = param1.params.iconId;
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(GenesisTerminalShared.MENU_ITEM_CLICK_EVENT,{
            "iIconId":param1.params.iconId,
            "iParentStackLevel":param1.params.parentStackLevel
         }));
      }
      
      private function GetCurrentWindow() : MovieClip
      {
         return this._popupWindowsV.length > 0 ? this._popupWindowsV[this._popupWindowsV.length - 1] : null;
      }
   }
}
