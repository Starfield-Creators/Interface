package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.BSEaze;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.Extensions;
   
   public class WorkshopMenu extends IMenu
   {
       
      
      public var BuildPopupContainer_mc:BuildPopupContainer;
      
      public var ColorPopup_mc:ColorPopup;
      
      public var AreaResourcesCard_mc:AreaResourcesCard;
      
      public var BuildItemCard_mc:OutpostItemCard;
      
      public var InspectItemCard_mc:OutpostItemCard;
      
      public var ActionCard_mc:ActionCard;
      
      public var InteractiveMessage_mc:InteractiveMessage;
      
      public var DisplayMessage_mc:DisplayMessage;
      
      public var Reticle_mc:MovieClip;
      
      public var Spinner_mc:MovieClip;
      
      public var FooterContainer_mc:FooterContainer;
      
      public var ScreenBorderFrameContainer_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var SecondaryButtonBar_mc:ButtonBar;
      
      private var _currentState:uint;
      
      private var _currentConnectionType:int;
      
      private var _autoFoundationMode:Boolean;
      
      private var _flycamActive:Boolean;
      
      private var _spinnerActive:Boolean;
      
      private var _flycamDisabled:Boolean;
      
      private var _blockInput:Boolean;
      
      private var _allowedActions:uint;
      
      private var _hasExtras:Boolean;
      
      private var _activateText:String;
      
      private var _secondaryMode:int = -1;
      
      private var _closeAnimsPlayed:uint = 0;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      private var _skillLibrary:SharedLibraryOwner = null;
      
      private var _trackingActive:Boolean = false;
      
      private var _updateList:Array;
      
      private var _largeTextMode:Boolean = false;
      
      private var _closingMenu:Boolean = false;
      
      private const TOTAL_ANIMATED_CLIPS:uint = 4;
      
      private const BUTTON_BAR_BG_HORIZONTAL_PADDING:Number = 5;
      
      private const MOVE_TEXT:String = "$MOVE";
      
      private const REVERT_TEXT:String = "$REVERT";
      
      private const BUILD_TEXT:String = "$BUILD";
      
      private const CANCEL_TEXT:String = "$CANCEL";
      
      private const CONFIRM_TEXT:String = "$CONFIRM";
      
      private const OUTPUT_LINK_TEXT:String = "$CREATE OUTPUT LINK";
      
      private const CONNECTION_TEXT:String = "$CREATE CONNECTION";
      
      private const WIRE_TEXT:String = "$ATTACH WIRE";
      
      private const CHANGE_TEXT:String = "$CHANGE";
      
      private const BULLDOZE_TEXT:String = "$CLEAR";
      
      private const CHANGE_COLORS_TEXT:String = "$ChangeColors";
      
      private const HOLD_EXIT_TEXT:String = "$EXIT HOLD";
      
      private const EXIT_TEXT:String = "$EXIT";
      
      private const TRACK_TEXT:String = "$TRACK";
      
      private const UNTRACK_TEXT:String = "$UNTRACK";
      
      private const HOLD_EXIT_TEXT_LRG:String = "$EXIT HOLD_LRG";
      
      private var BackButtonData:ReleaseHoldComboButtonData;
      
      private var EditButtonData:ReleaseHoldComboButtonData;
      
      private var EditExtrasComboButtonData:ReleaseHoldComboButtonData;
      
      private var ReplaceButtonData:ReleaseHoldComboButtonData;
      
      private var DeleteButtonData:ReleaseHoldComboButtonData;
      
      private var DeleteReplaceComboButtonData:ReleaseHoldComboButtonData;
      
      private var ConfirmButtonData:ButtonBaseData;
      
      private var TrackButtonData:ButtonBaseData;
      
      private var ModeButtonKBMData:ButtonBaseData;
      
      private var ConnectionButtonData:ButtonBaseData;
      
      private var FoundationButtonData:ButtonBaseData;
      
      private var FoundationButtonFlycamData:ButtonBaseData;
      
      private var AdjustHoldButtonData:ButtonBaseData;
      
      private var AdjustPanButtonData:ButtonBaseData;
      
      private var RotateButtonData:ButtonBaseData;
      
      private var ConfirmButton:IButton = null;
      
      private var TrackButton:IButton = null;
      
      private var ModeButtonKBM:IButton = null;
      
      private var ViewButton:IButton = null;
      
      private var FoundationButton:IButton = null;
      
      private var EditButton:WorkshopActionButton = null;
      
      private var BackButton:IButton = null;
      
      private var VariantsButton:IButton = null;
      
      private var DeleteButton:WorkshopActionButton = null;
      
      private var ConnectionButton:IButton = null;
      
      private var RepairButton:IButton = null;
      
      private var ChangeColorsButton:IButton = null;
      
      private var RevertColorsButton:IButton = null;
      
      private var RotateButton:IButton = null;
      
      private var BulldozeButton:IButton = null;
      
      private var AdjustHoldButton:IButton = null;
      
      private var AdjustPanButton:IButton = null;
      
      private var RotateMouseButton:IButton = null;
      
      private const MAIN_BUTTONS:int = EnumHelper.GetEnum(0);
      
      private const SECONDARY_BUTTONS:int = EnumHelper.GetEnum();
      
      private const COMPONENT_VISIBILITY:int = EnumHelper.GetEnum();
      
      private const LIST_INTERACTIVITY:int = EnumHelper.GetEnum();
      
      private const TOTAL_UPDATE_TYPES:int = EnumHelper.GetEnum();
      
      private const WIDE_ASPECT_RATIO:Number = 2.3;
      
      private const TALL_ASPECT_RATIO:Number = 1.7;
      
      private const LINE_EXPAND_TIME:Number = 0.67;
      
      private const LINE_START_WIDTH:Number = 100;
      
      private const BORDER_BOUND:Number = 50;
      
      private const POPUP_OFFSET_Y:Number = -4;
      
      private const POPUP_OFFSET_X:Number = -26;
      
      private const DIVIDER_OFFSET:Number = 100;
      
      private const FOOTER_OFFSET:Number = 6;
      
      private const BORDER_BOUND_X_LRG:Number = 50;
      
      private const BORDER_BOUND_Y_LRG:Number = 32;
      
      private const POPUP_OFFSET_X_LRG:Number = -5;
      
      private const MESSAGE_OFFSET_Y_LRG:Number = 60;
      
      public function WorkshopMenu()
      {
         this.BackButtonData = new ReleaseHoldComboButtonData(this.CANCEL_TEXT,this.HOLD_EXIT_TEXT,[new UserEventData("Cancel",this.CancelAction),new UserEventData("",this.PlayClosingAnimations)]);
         this.EditButtonData = new ReleaseHoldComboButtonData(this.MOVE_TEXT,"",[new UserEventData("Confirm",this.EditObject),new UserEventData("",null,"",false)]);
         this.EditExtrasComboButtonData = new ReleaseHoldComboButtonData(this.MOVE_TEXT,"$EXTRAS HOLD",[new UserEventData("Confirm",this.EditObject),new UserEventData("",null,"WorkshopMenu_ShowExtras")]);
         this.ReplaceButtonData = new ReleaseHoldComboButtonData("$REPLACE","",[new UserEventData("XButton",this.ReplaceObject),new UserEventData("",null,"",false)]);
         this.DeleteButtonData = new ReleaseHoldComboButtonData("","$DELETE",[new UserEventData("XButton",null,"",false),new UserEventData("",this.DeleteObject)]);
         this.DeleteReplaceComboButtonData = new ReleaseHoldComboButtonData("$REPLACE","$DELETE",[new UserEventData("XButton",this.ReplaceObject),new UserEventData("",this.DeleteObject)]);
         this.ConfirmButtonData = new ButtonBaseData(this.CONFIRM_TEXT,[new UserEventData("Confirm",this.ConfirmAction)]);
         this.TrackButtonData = new ButtonBaseData(this.TRACK_TEXT,[new UserEventData("XButton",this.ToggleTracking)]);
         this.ModeButtonKBMData = new ButtonBaseData("",[new UserEventData("ChangeMode",this.CancelAction)]);
         this.ConnectionButtonData = new ButtonBaseData(this.CONNECTION_TEXT,[new UserEventData("RTrigger",this.CreateConnection)]);
         this.FoundationButtonData = new ButtonBaseData("$ADJUST HEIGHT",[new UserEventData("Look")]);
         this.FoundationButtonFlycamData = new ButtonBaseData("$ADJUST HEIGHT",[new UserEventData("Move"),new UserEventData("Forward"),new UserEventData("Back")]);
         this.AdjustHoldButtonData = new ButtonBaseData("$HOLD DISTANCE",[new UserEventData("Move")]);
         this.AdjustPanButtonData = new ButtonBaseData("$PAN DISTANCE",[new UserEventData("Move")]);
         this.RotateButtonData = new ButtonBaseData("$ROTATE",[new UserEventData("LTrigger"),new UserEventData("RTrigger")]);
         super();
         this._updateList = new Array();
         this.ClearUpdates();
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         this._skillLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG,AttributeIcon.SET_LOADER);
         this._currentState = WorkshopUtils.IDLE;
         this._flycamActive = false;
         this._spinnerActive = false;
         this._flycamDisabled = false;
         this._blockInput = false;
         this._closingMenu = false;
         this._currentConnectionType = WorkshopUtils.WCT_SELECT_CONNECTION;
         this.Spinner_mc.visible = this._spinnerActive;
         this.ColorPopup_mc.contextName = WorkshopUtils.WORKSHOP_INPUT_CONTEXT;
         this.UpdateComponentsVisibility();
         BSUIDataManager.Subscribe("WorkshopCategoryInfoData",this.OnCategoryInfoDataUpdate);
         BSUIDataManager.Subscribe("WorkshopObjectInfoCardData",this.OnObjectInfoCardDataUpdate);
         BSUIDataManager.Subscribe("WorkshopStateData",this.OnStateDataUpdate);
         BSUIDataManager.Subscribe("WorkshopPickRefData",this.OnPickRefDataUpdate);
         BSUIDataManager.Subscribe("WorkshopQuickMenuData",this.OnQuickMenuDataUpdate);
         BSUIDataManager.Subscribe("WorkshopInfoData",this.OnOutpostInfoUpdate);
         this.PopulateButtonBars();
         addEventListener(WorkshopUtils.CLOSE_ANIM_FINISHED,this.CloseAnimComplete);
      }
      
      private function get currentState() : uint
      {
         return this._currentState;
      }
      
      private function set currentState(param1:uint) : void
      {
         if(this._currentState != param1)
         {
            this.PreStateChangeActions(param1);
            this._currentState = param1;
            this.Update(this.COMPONENT_VISIBILITY);
         }
      }
      
      private function set secondaryMode(param1:uint) : void
      {
         var _loc2_:* = false;
         if(this._secondaryMode != param1)
         {
            this._secondaryMode = param1;
            _loc2_ = this._secondaryMode != WorkshopUtils.WSM_NONE;
            this.ButtonBar_mc.visible = !_loc2_;
            this.SecondaryButtonBar_mc.visible = _loc2_;
            this.Update(this.SECONDARY_BUTTONS);
         }
      }
      
      private function get allowInput() : Boolean
      {
         return !this._closingMenu && !this._blockInput;
      }
      
      override public function onRemovedFromStage() : void
      {
         this._organicLibrary.RemoveEventListener();
         this._skillLibrary.RemoveEventListener();
         super.onRemovedFromStage();
      }
      
      override protected function onSetSafeRect() : void
      {
         var _loc1_:Number = NaN;
         Extensions.enabled = true;
         if(this._largeTextMode)
         {
            GlobalFunc.LockToSafeRect(this.BuildPopupContainer_mc,"TR",this.BORDER_BOUND_X_LRG + this.POPUP_OFFSET_X_LRG,this.BORDER_BOUND_Y_LRG + this.POPUP_OFFSET_Y,true);
            GlobalFunc.LockToSafeRect(this.ColorPopup_mc,"TR",this.BORDER_BOUND_X_LRG + this.POPUP_OFFSET_X,this.BORDER_BOUND_Y_LRG + this.POPUP_OFFSET_Y,true);
            GlobalFunc.LockToSafeRect(this.AreaResourcesCard_mc,"TL",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.BuildItemCard_mc,"TL",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.InspectItemCard_mc,"TL",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.ActionCard_mc,"CC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.InteractiveMessage_mc,"CC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.DisplayMessage_mc,"BC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG + this.MESSAGE_OFFSET_Y_LRG);
            GlobalFunc.LockToSafeRect(this.Reticle_mc,"CC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG,true);
            GlobalFunc.LockToSafeRect(this.Spinner_mc,"CC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc,"BC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc.DividerHolder_mc,"BL",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG + this.DIVIDER_OFFSET,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc.Info_mc,"TC",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc.Stats_mc,"BR",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG,true);
            GlobalFunc.LockToSafeRect(this.ButtonBar_mc,"R",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            GlobalFunc.LockToSafeRect(this.SecondaryButtonBar_mc,"R",this.BORDER_BOUND_X_LRG,this.BORDER_BOUND_Y_LRG);
            BSEaze(this.FooterContainer_mc.DividerHolder_mc.Divider_mc).ExpandClipWidth(this.LINE_EXPAND_TIME,this.LINE_START_WIDTH,Extensions.visibleRect.width - this.BORDER_BOUND_X_LRG * 2);
         }
         else
         {
            GlobalFunc.LockToSafeRect(this.BuildPopupContainer_mc,"TR",this.BORDER_BOUND + this.POPUP_OFFSET_X,this.BORDER_BOUND + this.POPUP_OFFSET_Y,true);
            GlobalFunc.LockToSafeRect(this.ColorPopup_mc,"TR",this.BORDER_BOUND + this.POPUP_OFFSET_X,this.BORDER_BOUND + this.POPUP_OFFSET_Y,true);
            GlobalFunc.LockToSafeRect(this.AreaResourcesCard_mc,"TL",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.BuildItemCard_mc,"TL",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.InspectItemCard_mc,"TL",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.ActionCard_mc,"CC",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.InteractiveMessage_mc,"CC",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.DisplayMessage_mc,"BC",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.Reticle_mc,"CC",this.BORDER_BOUND,this.BORDER_BOUND,true);
            GlobalFunc.LockToSafeRect(this.Spinner_mc,"CC",this.BORDER_BOUND,this.BORDER_BOUND,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc,"BC",this.BORDER_BOUND,this.BORDER_BOUND + this.FOOTER_OFFSET,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc.DividerHolder_mc,"BL",this.BORDER_BOUND,this.BORDER_BOUND + this.DIVIDER_OFFSET,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc.Info_mc,"BL",this.BORDER_BOUND,this.BORDER_BOUND + this.FOOTER_OFFSET,true);
            GlobalFunc.LockToSafeRect(this.FooterContainer_mc.Stats_mc,"BR",this.BORDER_BOUND,this.BORDER_BOUND + this.FOOTER_OFFSET,true);
            GlobalFunc.LockToSafeRect(this.ButtonBar_mc,"R",this.BORDER_BOUND,this.BORDER_BOUND);
            GlobalFunc.LockToSafeRect(this.SecondaryButtonBar_mc,"R",this.BORDER_BOUND,this.BORDER_BOUND);
            BSEaze(this.FooterContainer_mc.DividerHolder_mc.Divider_mc).ExpandClipWidth(this.LINE_EXPAND_TIME,this.LINE_START_WIDTH,Extensions.visibleRect.width - this.BORDER_BOUND * 2);
            _loc1_ = stage.stageWidth / stage.stageHeight;
            if(_loc1_ > this.WIDE_ASPECT_RATIO)
            {
               this.ScreenBorderFrameContainer_mc.gotoAndStop("wide");
            }
            else if(_loc1_ < this.TALL_ASPECT_RATIO)
            {
               this.ScreenBorderFrameContainer_mc.gotoAndStop("tall");
            }
            else
            {
               this.ScreenBorderFrameContainer_mc.gotoAndStop("standard");
            }
            this.ScreenBorderFrameContainer_mc.width = Extensions.visibleRect.width;
            this.ScreenBorderFrameContainer_mc.height = Extensions.visibleRect.height;
            this.ScreenBorderFrameContainer_mc.x = Extensions.visibleRect.x;
            this.ScreenBorderFrameContainer_mc.y = Extensions.visibleRect.y;
         }
      }
      
      private function PlayClosingAnimations() : void
      {
         this._closingMenu = true;
         this.BuildPopupContainer_mc.Close(this.BuildPopupContainer_mc.visible);
         this.BuildItemCard_mc.Close(this.BuildItemCard_mc.visible);
         this.InspectItemCard_mc.Close(this.InspectItemCard_mc.visible);
         this.FooterContainer_mc.Close(this.FooterContainer_mc.visible);
         this.Update(this.MAIN_BUTTONS);
         this.Update(this.SECONDARY_BUTTONS);
      }
      
      private function CloseAnimComplete() : void
      {
         ++this._closeAnimsPlayed;
         if(this._closeAnimsPlayed == this.TOTAL_ANIMATED_CLIPS)
         {
            removeEventListener(WorkshopUtils.CLOSE_ANIM_FINISHED,this.CloseAnimComplete);
            BSUIDataManager.dispatchEvent(new Event("WorkshopMenu_ExitMenu"));
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.Update(this.MAIN_BUTTONS);
         this.Update(this.SECONDARY_BUTTONS);
      }
      
      private function PopulateButtonBars() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.SetBackgroundPadding(this.BUTTON_BAR_BG_HORIZONTAL_PADDING,0);
         this.SecondaryButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.SecondaryButtonBar_mc.SetBackgroundPadding(this.BUTTON_BAR_BG_HORIZONTAL_PADDING,0);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.TrackButton = ButtonFactory.AddToButtonBar("BasicButton",this.TrackButtonData,this.ButtonBar_mc);
         this.EditButton = ButtonFactory.AddToButtonBar("WorkshopActionButton",this.EditButtonData,this.ButtonBar_mc) as WorkshopActionButton;
         this.RotateButton = ButtonFactory.AddToButtonBar("BasicButton",this.RotateButtonData,this.ButtonBar_mc);
         this.ViewButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$TOGGLE VIEW",[new UserEventData("ToggleView",null,"WorkshopMenu_ToggleView")]),this.ButtonBar_mc);
         this.FoundationButton = ButtonFactory.AddToButtonBar("BasicButton",this.FoundationButtonData,this.ButtonBar_mc);
         this.VariantsButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$VARIANTS",[new UserEventData("Left",function():void
         {
            ChangeVariant(WorkshopUtils.PREVIOUS_VARIANT);
         }),new UserEventData("Right",function():void
         {
            ChangeVariant(WorkshopUtils.NEXT_VARIANT);
         })]),this.ButtonBar_mc);
         this.DeleteButton = ButtonFactory.AddToButtonBar("WorkshopActionButton",this.DeleteButtonData,this.ButtonBar_mc) as WorkshopActionButton;
         this.ConnectionButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConnectionButtonData,this.ButtonBar_mc);
         this.RepairButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$REPAIR",[new UserEventData("RShoulder",this.RepairObject)]),this.ButtonBar_mc);
         this.ChangeColorsButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData(this.CHANGE_COLORS_TEXT,[new UserEventData("LShoulder",this.ChangeColors)]),this.ButtonBar_mc);
         this.RevertColorsButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$DEFAULT_COLOR",[new UserEventData("XButton",this.RevertColors)]),this.ButtonBar_mc);
         this.ModeButtonKBM = ButtonFactory.AddToButtonBar("BasicButton",this.ModeButtonKBMData,this.ButtonBar_mc);
         this.BackButton = ButtonFactory.AddToButtonBar("ComboButton",this.BackButtonData,this.ButtonBar_mc);
         this.EditButton.buttonAction = WorkshopUtils.ABT_EXTRAS;
         this.DeleteButton.buttonAction = WorkshopUtils.ABT_DELETE;
         this.Update(this.MAIN_BUTTONS);
         this.BulldozeButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData(this.BULLDOZE_TEXT,[new UserEventData("Move"),new UserEventData("Forward"),new UserEventData("StrafeLeft"),new UserEventData("Back"),new UserEventData("StrafeRight")]),this.SecondaryButtonBar_mc);
         this.AdjustHoldButton = ButtonFactory.AddToButtonBar("BasicButton",this.AdjustHoldButtonData,this.SecondaryButtonBar_mc);
         this.AdjustPanButton = ButtonFactory.AddToButtonBar("BasicButton",this.AdjustPanButtonData,this.SecondaryButtonBar_mc);
         this.RotateMouseButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$ROTATE",[new UserEventData("Look")]),this.SecondaryButtonBar_mc);
         this.Update(this.SECONDARY_BUTTONS);
      }
      
      private function CancelActionButtons() : void
      {
         this.EditButton.CancelHold();
         this.DeleteButton.CancelHold();
      }
      
      private function UpdateMainButtons() : void
      {
         var _loc1_:* = false;
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc7_:* = false;
         var _loc8_:* = false;
         var _loc9_:* = false;
         var _loc10_:* = false;
         var _loc11_:* = false;
         var _loc12_:* = false;
         var _loc13_:Boolean = false;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:String = null;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:String = null;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         if(IsControllerValueValid())
         {
            _loc1_ = this.currentState == WorkshopUtils.IDLE;
            _loc2_ = this.currentState == WorkshopUtils.INSPECT_ITEM;
            _loc3_ = this.currentState == WorkshopUtils.INSPECT_IDLE;
            _loc4_ = this.currentState == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT;
            _loc5_ = this.currentState == WorkshopUtils.UPDATE_EXISTING_ITEM_PLACEMENT;
            _loc6_ = this.currentState == WorkshopUtils.UPDATE_NEW_DEPLOYABLE_PLACEMENT;
            _loc7_ = this.currentState == WorkshopUtils.UPDATE_WIRE_PLACEMENT;
            _loc8_ = this.currentState == WorkshopUtils.UPDATE_TRANSFER_LINK_PLACEMENT;
            _loc9_ = this.currentState == WorkshopUtils.MODIFY_ITEM_COLORS;
            _loc10_ = this.currentState == WorkshopUtils.BULLDOZE_STATE;
            _loc11_ = this.currentState == WorkshopUtils.INSPECT_COLORS;
            _loc12_ = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
            this.ViewButton.Visible = !_loc1_ && !_loc6_ && !this._autoFoundationMode && !this._flycamDisabled;
            this.ViewButton.Enabled = this.ViewButton.Visible && this.allowInput;
            this.VariantsButton.Visible = _loc4_ && this.BuildPopupContainer_mc.currentItemHasVariants;
            this.VariantsButton.Enabled = this.VariantsButton.Visible && this.allowInput;
            _loc13_ = _loc2_ && this._hasExtras;
            _loc14_ = this.GetEditButtonText();
            if(_loc13_)
            {
               this.EditExtrasComboButtonData.sButtonText = _loc14_;
               this.EditButton.SetButtonData(this.EditExtrasComboButtonData);
            }
            else
            {
               this.EditButtonData.sButtonText = _loc14_;
               this.EditButton.SetButtonData(this.EditButtonData);
            }
            this.EditButton.Visible = _loc14_ != "" && !this.ActionCard_mc.active;
            this.EditButton.Enabled = this.EditButton.Visible && this.allowInput;
            _loc15_ = _loc2_ && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_DELETE);
            _loc16_ = _loc2_ && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_REPLACE);
            if(_loc15_ && _loc16_)
            {
               this.DeleteButton.SetButtonData(this.DeleteReplaceComboButtonData);
            }
            else if(_loc15_)
            {
               this.DeleteButton.SetButtonData(this.DeleteButtonData);
            }
            else if(_loc16_)
            {
               this.DeleteButton.SetButtonData(this.ReplaceButtonData);
            }
            this.DeleteButton.Visible = _loc15_ || _loc16_;
            this.DeleteButton.Enabled = this.DeleteButton.Visible && this.allowInput;
            _loc17_ = _loc6_ || _loc5_ || _loc7_ || _loc8_ || this._autoFoundationMode || _loc9_;
            _loc18_ = _loc12_ && !_loc17_;
            this.BackButtonData.sButtonText = _loc17_ ? this.CANCEL_TEXT : (_loc12_ ? this.EXIT_TEXT : WorkshopUtils.GetInteractModeText(this.GetNextMode()));
            this.BackButtonData.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.PRESS_AND_RELEASE_EVENT_INDEX).funcCallback = _loc18_ ? this.PlayClosingAnimations : this.CancelAction;
            this.BackButtonData.sHoldText = _loc6_ || _loc18_ ? "" : (this._largeTextMode ? this.HOLD_EXIT_TEXT_LRG : this.HOLD_EXIT_TEXT);
            this.BackButtonData.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.PRESS_AND_RELEASE_EVENT_INDEX).bEnabled = _loc18_ ? true : this.allowInput;
            this.BackButtonData.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.HOLD_EVENT_INDEX).bEnabled = !_loc6_ && !_loc18_;
            this.BackButton.SetButtonData(this.BackButtonData);
            if(_loc18_)
            {
               this.ModeButtonKBMData.sButtonText = WorkshopUtils.GetInteractModeText(this.GetNextMode());
               this.ModeButtonKBM.SetButtonData(this.ModeButtonKBMData);
            }
            this.ModeButtonKBM.Visible = _loc18_;
            this.ModeButtonKBM.Enabled = _loc18_ && this.allowInput;
            if(this._flycamActive)
            {
               this.FoundationButton.SetButtonData(this.FoundationButtonFlycamData);
            }
            else
            {
               this.FoundationButton.SetButtonData(this.FoundationButtonData);
            }
            this.FoundationButton.Visible = this._autoFoundationMode;
            this.FoundationButton.Enabled = this._autoFoundationMode && this.allowInput;
            _loc19_ = this.GetConnectionButtonText(this._allowedActions);
            this.ConnectionButtonData.sButtonText = _loc19_;
            this.ConnectionButton.SetButtonData(this.ConnectionButtonData);
            this.ConnectionButton.Visible = _loc2_ && _loc19_ != "";
            this.ConnectionButton.Enabled = (_loc2_ || _loc7_ || _loc8_) && _loc19_ != "" && this.allowInput;
            _loc20_ = _loc4_ && !this._autoFoundationMode;
            _loc21_ = _loc6_ || _loc5_ || this._autoFoundationMode;
            _loc22_ = (_loc7_ || _loc8_) && _loc19_ != "";
            _loc23_ = _loc11_ && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_SET_COLORS);
            _loc24_ = this.BUILD_TEXT;
            if(_loc22_)
            {
               _loc24_ = _loc19_;
            }
            else if(_loc21_ || _loc9_)
            {
               _loc24_ = this.CONFIRM_TEXT;
            }
            else if(_loc10_)
            {
               _loc24_ = this.BULLDOZE_TEXT;
            }
            else if(_loc11_)
            {
               _loc24_ = this.CHANGE_COLORS_TEXT;
            }
            this.ConfirmButtonData.sButtonText = _loc24_;
            this.ConfirmButton.SetButtonData(this.ConfirmButtonData);
            this.ConfirmButton.Visible = _loc21_ || _loc22_ || _loc20_ || _loc9_ || _loc10_ || _loc23_;
            this.ConfirmButton.Enabled = this.ConfirmButton.Visible && this.allowInput;
            _loc25_ = _loc2_ && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_REPAIR);
            this.RepairButton.Visible = _loc25_;
            this.RepairButton.Enabled = this.RepairButton.Visible && this.allowInput;
            _loc26_ = _loc2_ && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_SET_COLORS);
            this.ChangeColorsButton.Visible = _loc26_;
            this.ChangeColorsButton.Enabled = this.ChangeColorsButton.Visible && this.allowInput;
            this.RevertColorsButton.Visible = _loc9_;
            this.RevertColorsButton.Enabled = _loc9_ && this.allowInput;
            this.RotateButton.Visible = _loc6_ || _loc4_ || _loc5_ || _loc10_;
            this.RotateButton.Enabled = this.RotateButton.Visible && this.allowInput;
            this.TrackButtonData.sButtonText = this._trackingActive ? this.UNTRACK_TEXT : this.TRACK_TEXT;
            this.TrackButton.SetButtonData(this.TrackButtonData);
            this.TrackButton.Visible = _loc20_;
            this.TrackButton.Enabled = this.TrackButton.Visible && this.allowInput;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      private function UpdateSecondaryButtons() : void
      {
         var _loc1_:* = false;
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:* = false;
         if(IsControllerValueValid())
         {
            _loc1_ = this._secondaryMode == WorkshopUtils.WSM_ADJUSTING;
            _loc2_ = this._secondaryMode == WorkshopUtils.WSM_BULLDOZING;
            _loc3_ = this._secondaryMode == WorkshopUtils.WSM_ROTATING;
            _loc4_ = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
            this.BulldozeButton.Visible = _loc2_ && (!_loc4_ || this._flycamActive);
            this.RotateMouseButton.Visible = _loc3_;
            this.AdjustHoldButtonData.UserEvents.GetUserEventByIndex(0).sUserEvent = _loc4_ ? "Look" : "Move";
            this.AdjustHoldButtonData.UserEvents.BuildUserEventKey();
            this.AdjustHoldButton.SetButtonData(this.AdjustHoldButtonData);
            this.AdjustHoldButton.Visible = _loc1_;
            this.AdjustPanButtonData.UserEvents.GetUserEventByIndex(0).sUserEvent = _loc4_ ? "Look" : "Move";
            this.AdjustPanButtonData.UserEvents.BuildUserEventKey();
            this.AdjustPanButton.SetButtonData(this.AdjustPanButtonData);
            this.AdjustPanButton.Visible = _loc1_;
            this.SecondaryButtonBar_mc.RefreshButtons();
         }
      }
      
      private function GetConnectionButtonText(param1:int) : String
      {
         var _loc5_:Boolean = false;
         var _loc2_:* = this.currentState == WorkshopUtils.UPDATE_WIRE_PLACEMENT;
         var _loc3_:* = this.currentState == WorkshopUtils.UPDATE_TRANSFER_LINK_PLACEMENT;
         var _loc4_:String = "";
         if(_loc2_)
         {
            _loc4_ = this.WIRE_TEXT;
            this._currentConnectionType = WorkshopUtils.WCT_WIRE_CONNECTION;
         }
         else if(_loc3_)
         {
            _loc4_ = this.OUTPUT_LINK_TEXT;
            this._currentConnectionType = WorkshopUtils.WCT_TRANSFER_CONNECTION;
         }
         else if(_loc5_ = WorkshopUtils.CheckActionFlags(param1,WorkshopUtils.WIA_TRANSFER_LINK))
         {
            _loc4_ = this.OUTPUT_LINK_TEXT;
            this._currentConnectionType = WorkshopUtils.WCT_TRANSFER_CONNECTION;
         }
         return _loc4_;
      }
      
      private function GetEditButtonText() : String
      {
         if(this.currentState == WorkshopUtils.INSPECT_ITEM)
         {
            if(!this._flycamActive && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_ACTIVATE))
            {
               return this._activateText;
            }
            if(WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_REVERT))
            {
               return this.REVERT_TEXT;
            }
            if(WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_CYCLE_SNAP_BEHAVIOR_ENTRY))
            {
               return this.CHANGE_TEXT;
            }
            if(WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_MOVE))
            {
               return this.MOVE_TEXT;
            }
         }
         return "";
      }
      
      private function GetNextMode() : int
      {
         var _loc1_:int = WorkshopUtils.WIM_NONE;
         var _loc2_:int = WorkshopUtils.StateToInteractMode(this.currentState);
         switch(_loc2_)
         {
            case WorkshopUtils.WIM_BUILD_MODE:
               _loc1_ = WorkshopUtils.WIM_MODIFY_MODE;
               break;
            case WorkshopUtils.WIM_MODIFY_MODE:
               _loc1_ = WorkshopUtils.WIM_BUILD_MODE;
         }
         return _loc1_;
      }
      
      private function UpdateComponentsVisibility() : void
      {
         var _loc1_:* = this.currentState == WorkshopUtils.IDLE;
         var _loc2_:* = this.currentState == WorkshopUtils.INSPECT_IDLE;
         var _loc3_:* = this.currentState == WorkshopUtils.INSPECT_ITEM;
         var _loc4_:* = this.currentState == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT;
         var _loc5_:* = this.currentState == WorkshopUtils.UPDATE_NEW_DEPLOYABLE_PLACEMENT;
         var _loc6_:* = this.currentState == WorkshopUtils.UPDATE_WIRE_PLACEMENT;
         var _loc7_:* = this.currentState == WorkshopUtils.UPDATE_TRANSFER_LINK_PLACEMENT;
         var _loc8_:* = this.currentState == WorkshopUtils.MODIFY_ITEM_COLORS;
         var _loc9_:* = this.currentState == WorkshopUtils.INSPECT_COLORS;
         this.AreaResourcesCard_mc.show = _loc5_;
         this.BuildPopupContainer_mc.show = _loc4_;
         this.BuildItemCard_mc.show = _loc4_;
         this.InspectItemCard_mc.show = _loc3_ || _loc6_ || _loc7_;
         this.FooterContainer_mc.show = !_loc1_ && !_loc5_;
         this.ColorPopup_mc.active = _loc8_;
         this.Reticle_mc.visible = _loc2_ || _loc3_ || _loc9_;
         this.ScreenBorderFrameContainer_mc.visible = !_loc1_ && !_loc5_;
         stage.focus = null;
         if(this.InteractiveMessage_mc.active)
         {
            stage.focus = this.InteractiveMessage_mc.focusObject;
         }
         else if(this.ActionCard_mc.active)
         {
            stage.focus = this.ActionCard_mc.focusObject;
         }
         else if(this.BuildPopupContainer_mc.visible)
         {
            stage.focus = this.BuildPopupContainer_mc.BuildList_mc;
         }
         else if(this.ColorPopup_mc.active)
         {
            stage.focus = this.ColorPopup_mc;
         }
      }
      
      private function PreStateChangeActions(param1:uint) : void
      {
         if(this.currentState == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT)
         {
            GlobalFunc.PlayMenuSound("UIOutpostModeItemMenuClose");
         }
         else if(param1 == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT)
         {
            GlobalFunc.PlayMenuSound("UIOutpostModeItemMenuOpen");
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(!_loc3_ && this.InteractiveMessage_mc.active && this.allowInput)
         {
            _loc4_ = true;
            _loc3_ = this.InteractiveMessage_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !_loc4_ && this.ActionCard_mc.active && this.allowInput)
         {
            _loc4_ = true;
            _loc3_ = this.ActionCard_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !_loc4_ && this.BuildPopupContainer_mc.visible && this.allowInput)
         {
            _loc3_ = this.BuildPopupContainer_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !_loc4_ && this.ColorPopup_mc.active && this.allowInput)
         {
            _loc3_ = this.ColorPopup_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && !_loc4_)
         {
            if(this._secondaryMode == WorkshopUtils.WSM_NONE)
            {
               _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
            else if(this.allowInput)
            {
               _loc3_ = this.SecondaryButtonBar_mc.ProcessUserEvent(param1,param2);
            }
         }
         return _loc3_;
      }
      
      override public function redrawDisplayObject() : void
      {
         if(this._updateList[this.MAIN_BUTTONS])
         {
            this.UpdateMainButtons();
         }
         if(this._updateList[this.SECONDARY_BUTTONS])
         {
            this.UpdateSecondaryButtons();
         }
         if(this._updateList[this.COMPONENT_VISIBILITY])
         {
            this.UpdateComponentsVisibility();
         }
         if(this._updateList[this.LIST_INTERACTIVITY])
         {
            this.InteractiveMessage_mc.List_mc.disableInput = !this.allowInput;
            this.ActionCard_mc.ActionList_mc.disableInput = !this.allowInput;
            this.BuildPopupContainer_mc.BuildList_mc.disableInput = !this.allowInput;
            this.ColorPopup_mc.blockInput = !this.allowInput;
         }
         this.ClearUpdates();
      }
      
      private function ClearUpdates() : void
      {
         var _loc1_:uint = uint(this.MAIN_BUTTONS);
         while(_loc1_ < this.TOTAL_UPDATE_TYPES)
         {
            this._updateList[_loc1_] = false;
            _loc1_++;
         }
      }
      
      private function Update(param1:int) : void
      {
         this._updateList[param1] = true;
         SetIsDirty();
      }
      
      private function OnCategoryInfoDataUpdate(param1:FromClientDataEvent) : void
      {
         this.BuildPopupContainer_mc.UpdateCategoryInfo(param1.data);
         this.Update(this.MAIN_BUTTONS);
      }
      
      private function OnObjectInfoCardDataUpdate(param1:FromClientDataEvent) : void
      {
         this._trackingActive = param1.data.bTracking;
         this.BuildItemCard_mc.UpdateItemData(param1.data);
         this.Update(this.MAIN_BUTTONS);
      }
      
      private function OnStateDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Boolean = this._currentState != param1.data.uCurrentState || this._flycamActive != param1.data.bFlycamActive || this._autoFoundationMode != param1.data.bAutoFoundationMode || this._blockInput != param1.data.bBlockInput;
         var _loc3_:* = this._blockInput != param1.data.bBlockInput;
         this._flycamActive = param1.data.bFlycamActive;
         this._autoFoundationMode = param1.data.bAutoFoundationMode;
         this._spinnerActive = param1.data.bShowSpinner;
         this._blockInput = param1.data.bBlockInput;
         this.currentState = param1.data.uCurrentState;
         this.secondaryMode = param1.data.uSecondaryMode;
         this.Spinner_mc.visible = this._spinnerActive;
         if(_loc2_)
         {
            this.Update(this.MAIN_BUTTONS);
         }
         if(_loc3_)
         {
            this.Update(this.LIST_INTERACTIVITY);
         }
      }
      
      private function OnPickRefDataUpdate(param1:FromClientDataEvent) : void
      {
         this._allowedActions = param1.data.uAllowedActionsFlag;
         this._hasExtras = param1.data.bHasExtras;
         this._activateText = param1.data.sActivateText;
         this.InspectItemCard_mc.UpdateItemData(param1.data);
         this.ActionCard_mc.UpdateCardData(param1.data);
         this.CancelActionButtons();
         this.Update(this.MAIN_BUTTONS);
      }
      
      private function OnQuickMenuDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.data.bForceHideCards);
         this.ActionCard_mc.mode = _loc2_ ? uint(WorkshopUtils.WQM_IDLE) : uint(param1.data.uCurrentMode);
         this.Update(this.MAIN_BUTTONS);
      }
      
      private function OnOutpostInfoUpdate(param1:FromClientDataEvent) : void
      {
         this.FooterContainer_mc.UpdateFooterInfo(param1.data);
         this._flycamDisabled = param1.data.bFlycamDisabled;
         this.Update(this.MAIN_BUTTONS);
      }
      
      private function EditObject() : void
      {
         if(!this._flycamActive && WorkshopUtils.CheckActionFlags(this._allowedActions,WorkshopUtils.WIA_ACTIVATE))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":WorkshopUtils.WIA_ACTIVATE}));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":WorkshopUtils.WIA_MOVE}));
         }
      }
      
      private function DeleteObject() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":WorkshopUtils.WIA_DELETE}));
      }
      
      private function RepairObject() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":WorkshopUtils.WIA_REPAIR}));
      }
      
      private function ReplaceObject() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":WorkshopUtils.WIA_REPLACE}));
      }
      
      private function ChangeColors() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.START_ACTION,{"actionType":WorkshopUtils.WIA_SET_COLORS}));
      }
      
      private function CancelAction() : void
      {
         if(this.currentState == WorkshopUtils.UPDATE_EXISTING_ITEM_PLACEMENT || this.currentState == WorkshopUtils.UPDATE_WIRE_PLACEMENT || this.currentState == WorkshopUtils.UPDATE_TRANSFER_LINK_PLACEMENT || this.currentState == WorkshopUtils.MODIFY_ITEM_COLORS)
         {
            BSUIDataManager.dispatchEvent(new Event("WorkshopMenu_CancelAction"));
         }
         else if(WorkshopUtils.StateIsInteractiveMode(this.currentState))
         {
            if(this._autoFoundationMode)
            {
               BSUIDataManager.dispatchEvent(new Event("WorkshopMenu_CancelAction"));
            }
            else
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_SwitchMode",{"mode":this.GetNextMode()}));
            }
         }
         else if(this.currentState == WorkshopUtils.UPDATE_NEW_DEPLOYABLE_PLACEMENT)
         {
            BSUIDataManager.dispatchEvent(new Event("WorkshopMenu_ExitMenu"));
         }
      }
      
      private function ChangeVariant(param1:uint) : void
      {
         GlobalFunc.PlayMenuSound("UIOutpostModeMenuGridVariant");
         if(this.currentState == WorkshopUtils.BULLDOZE_STATE)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_ChangeBulldozerVariant",{"variantDirection":param1}));
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_ChangeVariant",{"variantDirection":param1}));
         }
      }
      
      private function ConfirmAction() : void
      {
         if(this.currentState == WorkshopUtils.UPDATE_NEW_DEPLOYABLE_PLACEMENT || this.currentState == WorkshopUtils.UPDATE_EXISTING_ITEM_PLACEMENT || this.currentState == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT || this.currentState == WorkshopUtils.BULLDOZE_STATE)
         {
            BSUIDataManager.dispatchEvent(new Event("WorkshopMenu_AttemptBuild"));
         }
         else if(this.currentState == WorkshopUtils.UPDATE_WIRE_PLACEMENT || this.currentState == WorkshopUtils.UPDATE_TRANSFER_LINK_PLACEMENT)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_ConnectionEvent",{"connectionType":this._currentConnectionType}));
         }
         else if(this.currentState == WorkshopUtils.MODIFY_ITEM_COLORS)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_ApplyColors",{"colorScheme":WorkshopUtils.CUSTOM_COLORS}));
         }
         else if(this.currentState == WorkshopUtils.INSPECT_COLORS)
         {
            this.ChangeColors();
         }
      }
      
      private function ToggleTracking() : void
      {
         if(this.currentState == WorkshopUtils.UPDATE_NEW_ITEM_PLACEMENT)
         {
            GlobalFunc.PlayMenuSound(this._trackingActive ? "UIMenuInventoryItemTagOff" : "UIMenuInventoryItemTagOn");
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_ToggleTracking",{"startTracking":!this._trackingActive}));
         }
      }
      
      private function CreateConnection() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_ConnectionEvent",{"connectionType":this._currentConnectionType}));
      }
      
      private function RevertColors() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopColorMode_ApplyColors",{"colorScheme":WorkshopUtils.DEFAULT_COLORS}));
      }
   }
}
