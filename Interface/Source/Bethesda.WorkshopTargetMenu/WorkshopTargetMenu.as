package
{
   import Components.LabeledMeterColorConfig;
   import Components.LabeledMeterMC;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
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
   import flash.display.MovieClip;
   
   public class WorkshopTargetMenu extends IMenu
   {
       
      
      public var ConfirmationPopup_mc:TargetConfirmationPopup;
      
      public var Footer_mc:MovieClip;
      
      public var CurrentOutpostInfo_mc:MovieClip;
      
      public var AvailableOutposts_mc:MovieClip;
      
      public var TargetOutpostInfo_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      private const BUTTON_SPACING:uint = 10;
      
      private var AcceptButton:IButton = null;
      
      private var CancelButton:IButton = null;
      
      private var RemoveButton:IButton = null;
      
      private var _currentLinkedOutpost:String = "";
      
      private var _confirmationType:int = -1;
      
      private var _hasActiveLink:Boolean = false;
      
      private var _initialTargetSelected:Boolean = false;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      public function WorkshopTargetMenu()
      {
         super();
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "OutpostsList_Entry";
         this.AvailableOutposts_mc.OutpostList_mc.Configure(_loc1_);
         this.CurrentOutpostInfo_mc.MeterHolder_mc.CargoMeter_mc.SetMode(LabeledMeterMC.MODE_WEIGHT);
         this.CurrentOutpostInfo_mc.MeterHolder_mc.CargoMeter_mc.SetColorConfig(LabeledMeterColorConfig.CONFIG_DEFAULT_WEIGHT);
         this.CurrentOutpostInfo_mc.MeterHolder_mc.CargoMeter_mc.SetLabel("$CARGO SHIP");
         GlobalFunc.SetText(this.TargetOutpostInfo_mc.SelectedOutpost_mc.SelectedOutpostName_mc.text_tf,"");
         GlobalFunc.SetText(this.TargetOutpostInfo_mc.Location_mc.text_tf,"");
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnSelect);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         addEventListener(TargetConfirmationPopup.CONFIRM_POPUP_ACCEPT,this.OnPopupConfirmed);
         addEventListener(TargetConfirmationPopup.CONFIRM_POPUP_CANCEL,this.ClearPopup);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.SetUpButtons();
         BSUIDataManager.Subscribe("WorkshopTargetData",this.OnTargetDataUpdate);
         BSUIDataManager.Subscribe("WorkshopTargetSourceData",this.OnSourceDataUpdate);
      }
      
      override public function onRemovedFromStage() : void
      {
         this._organicLibrary.RemoveEventListener();
         super.onRemovedFromStage();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.ConfirmationPopup_mc.active)
         {
            _loc3_ = this.ConfirmationPopup_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,this.BUTTON_SPACING);
         this.RemoveButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$REMOVE LINK",new UserEventData("XButton",this.OnRemove),false),this.ButtonBar_mc);
         this.AcceptButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SELECT",new UserEventData("Accept",this.OnSelect),false),this.ButtonBar_mc);
         this.CancelButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.OnCancel)),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateButtons() : void
      {
         var _loc1_:Object = this.AvailableOutposts_mc.OutpostList_mc.selectedEntry;
         this.AcceptButton.Enabled = _loc1_ != null && !OutpostsList_Entry.IsOutpost(_loc1_) && !_loc1_.bCurrentTarget;
         this.RemoveButton.Enabled = this._hasActiveLink;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function OnTargetDataUpdate(param1:FromClientDataEvent) : void
      {
         this._currentLinkedOutpost = param1.data.sLinkedOutpostName;
         this._hasActiveLink = this._currentLinkedOutpost != "";
         GlobalFunc.SetText(this.Footer_mc.LinkedOutpostName_mc.text_tf,this._hasActiveLink ? this._currentLinkedOutpost : "$NONE");
         this.CurrentOutpostInfo_mc.MeterHolder_mc.CargoMeter_mc.visible = this._hasActiveLink;
         this.CurrentOutpostInfo_mc.MeterHolder_mc.CargoMeter_mc.SetCurrentValue(Math.round(param1.data.fCargoShipWeight));
         this.CurrentOutpostInfo_mc.MeterHolder_mc.CargoMeter_mc.SetMaxValue(Math.round(param1.data.fCargoShipMaxWeight));
         var _loc2_:Array = param1.data.aOutposts;
         this.AvailableOutposts_mc.OutpostList_mc.InitializeEntries(_loc2_);
         stage.focus = this.AvailableOutposts_mc.OutpostList_mc;
         if(!this._initialTargetSelected && this._hasActiveLink)
         {
            this.AvailableOutposts_mc.OutpostList_mc.SelectInitialTarget();
         }
         else if(_loc2_.length > 0 && this.AvailableOutposts_mc.OutpostList_mc.selectedIndex == -1)
         {
            this.AvailableOutposts_mc.OutpostList_mc.selectedIndex = 0;
         }
         else if(_loc2_.length == 0)
         {
            this.AvailableOutposts_mc.OutpostList_mc.selectedIndex = -1;
         }
         if(!this._initialTargetSelected)
         {
            this._initialTargetSelected = _loc2_.length > 0;
         }
         this.UpdateButtons();
      }
      
      private function OnSourceDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data.SourceOutpost;
         GlobalFunc.SetText(this.CurrentOutpostInfo_mc.CurrentOutpost_mc.CurrentOutpostName_mc.text_tf,_loc2_.sName);
         GlobalFunc.SetText(this.CurrentOutpostInfo_mc.Location_mc.text_tf,_loc2_.sPlanet + ", " + _loc2_.sSystem);
         this.CurrentOutpostInfo_mc.CurrentNeedList_mc.SetResources(param1.data.SourceRef.aResourcesNeeded);
         this.CurrentOutpostInfo_mc.CurrentOutgoingList_mc.SetResources(param1.data.SourceRef.aOutgoingResources);
         this.UpdateButtons();
      }
      
      private function OnSelectionChange() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.AvailableOutposts_mc.OutpostList_mc.GetCurrentParentEntry();
         if(_loc1_ != null)
         {
            GlobalFunc.SetText(this.TargetOutpostInfo_mc.SelectedOutpost_mc.SelectedOutpostName_mc.text_tf,_loc1_.sName);
            GlobalFunc.SetText(this.TargetOutpostInfo_mc.Location_mc.text_tf,_loc1_.sPlanet + ", " + _loc1_.sSystem);
            _loc2_ = this.AvailableOutposts_mc.OutpostList_mc.selectedEntry;
            if(_loc2_ != null && !OutpostsList_Entry.IsOutpost(_loc2_))
            {
               this.TargetOutpostInfo_mc.TargetNeedList_mc.SetResources(_loc2_.aResourcesNeeded);
               this.TargetOutpostInfo_mc.TargetOutgoingList_mc.SetResources(_loc2_.aOutgoingResources);
               BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopTargetMenu_TargetHovered",{
                  "uOutpostHandle":_loc1_.uHandle,
                  "uTargetHandle":_loc2_.uHandle
               }));
            }
            else
            {
               this.TargetOutpostInfo_mc.TargetNeedList_mc.HideResources();
               this.TargetOutpostInfo_mc.TargetOutgoingList_mc.HideResources();
               this.CurrentOutpostInfo_mc.CurrentNeedList_mc.ForceHideCheckmarks();
               this.CurrentOutpostInfo_mc.CurrentOutgoingList_mc.ForceHideCheckmarks();
            }
         }
         else
         {
            GlobalFunc.SetText(this.TargetOutpostInfo_mc.SelectedOutpost_mc.SelectedOutpostName_mc.text_tf,"");
            GlobalFunc.SetText(this.TargetOutpostInfo_mc.Location_mc.text_tf,"");
         }
         this.UpdateButtons();
      }
      
      private function PlayFocusSound() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function OnSelect() : void
      {
         var _loc1_:Object = this.AvailableOutposts_mc.OutpostList_mc.selectedEntry;
         var _loc2_:Object = this.AvailableOutposts_mc.OutpostList_mc.GetCurrentParentEntry();
         if(_loc1_ != null && !OutpostsList_Entry.IsOutpost(_loc1_) && !_loc1_.bCurrentTarget && _loc2_ != null)
         {
            this._confirmationType = this._hasActiveLink ? TargetConfirmationPopup.CHANGE_LINK : TargetConfirmationPopup.CREATE_LINK;
            this.ConfirmationPopup_mc.SetPopupText(this._confirmationType,this._currentLinkedOutpost,_loc2_.sName);
            this.ConfirmationPopup_mc.active = true;
            this.AvailableOutposts_mc.OutpostList_mc.disableInput = true;
         }
      }
      
      private function OnRemove() : void
      {
         this._confirmationType = TargetConfirmationPopup.REMOVE_LINK;
         this.ConfirmationPopup_mc.SetPopupText(this._confirmationType,this._currentLinkedOutpost,"");
         this.ConfirmationPopup_mc.active = true;
         this.AvailableOutposts_mc.OutpostList_mc.disableInput = true;
      }
      
      private function OnCancel() : void
      {
         GlobalFunc.CloseMenu("WorkshopTargetMenu");
      }
      
      private function OnPopupConfirmed() : void
      {
         var _loc1_:Object = null;
         if(this._confirmationType == TargetConfirmationPopup.REMOVE_LINK)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopTargetMenu_TargetPicked",{"uHandle":0}));
         }
         else
         {
            _loc1_ = this.AvailableOutposts_mc.OutpostList_mc.selectedEntry;
            if(_loc1_ != null && !OutpostsList_Entry.IsOutpost(_loc1_) && !_loc1_.bCurrentTarget)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopTargetMenu_TargetPicked",{"uHandle":_loc1_.uHandle}));
            }
         }
         this.ClearPopup();
      }
      
      private function ClearPopup() : void
      {
         this.ConfirmationPopup_mc.active = false;
         this.AvailableOutposts_mc.OutpostList_mc.disableInput = false;
         stage.focus = this.AvailableOutposts_mc.OutpostList_mc;
      }
   }
}
