package Shared.Components.SystemPanels
{
   import Components.Meter;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class LoadPanel extends MovieClip implements IPanel
   {
      
      public static const LOAD_PANEL_PRESS:String = "LoadPanel_EntryPress";
      
      public static const LOAD_PANEL_CONFIRM:String = "LoadPanel_ConfirmLoad";
      
      public static const LOAD_PANEL_CANCEL:String = "LoadPanel_CancelLoad";
      
      public static const LOAD_PANEL_DELETE:String = "LoadPanel_DeleteSave";
      
      public static const LOAD_PANEL_SET_CHARACTER:String = "LoadPanel_SetCharacter";
      
      public static const LOAD_PANEL_UPLOAD_SAVE:String = "LoadPanel_UploadSave";
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var ModsLoaded_mc:MovieClip;
      
      public var ContinueInfo_mc:MovieClip;
      
      public var LoadList_mc:BSScrollingContainer;
      
      public var CharacterList_mc:BSScrollingContainer;
      
      public var ConfirmPrompt_mc:MovieClip;
      
      protected var ConfirmButton:IButton = null;
      
      protected var DeleteButton:IButton = null;
      
      protected var CharacterButton:IButton = null;
      
      protected var UploadSaveButton:IButton = null;
      
      protected var ConfirmButtonData:ButtonBaseData;
      
      protected var DeleteButtonData:ButtonBaseData;
      
      protected var CharacterButtonData:ButtonBaseData;
      
      protected var UploadSaveButtonData:ButtonBaseData;
      
      protected var CancelButtonData:ButtonBaseData;
      
      private var CurrentState:uint;
      
      private var ContinueData:Object;
      
      private var LevelMeter:Meter;
      
      private var ActiveList:BSScrollingContainer;
      
      private var AllowSavesToUpload:Boolean = false;
      
      private const LPS_NONE:int = EnumHelper.GetEnum(0);
      
      private const LPS_DISPLAY_MODE:int = EnumHelper.GetEnum();
      
      private const LPS_SELECT_MODE:int = EnumHelper.GetEnum();
      
      private const LPS_CHECKING_LOAD:int = EnumHelper.GetEnum();
      
      private const LPS_CONFIRMING_LOAD:int = EnumHelper.GetEnum();
      
      private const LPS_CONFIRMING_DELETE:int = EnumHelper.GetEnum();
      
      private const LPS_SELECT_CHARACTER:int = EnumHelper.GetEnum();
      
      private const LPS_LOAD_CONFIRMED:int = EnumHelper.GetEnum();
      
      private const LPS_DELETE_CONFIRMED:int = EnumHelper.GetEnum();
      
      private const LPS_SELECT_CHARACTER_CONFIRMED:int = EnumHelper.GetEnum();
      
      public function LoadPanel()
      {
         this.ConfirmButtonData = new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept));
         this.DeleteButtonData = new ButtonBaseData("$DELETE",new UserEventData("XButton",this.onDeleteSave));
         this.CharacterButtonData = new ButtonBaseData("$SELECT CHARACTER",new UserEventData("YButton",this.onSelectCharacter));
         this.UploadSaveButtonData = new ButtonBaseData("$UPLOAD SAVE",new UserEventData("RShoulder",this.onUploadSave));
         this.CancelButtonData = new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel));
         super();
         this.CurrentState = this.LPS_NONE;
         this.ActiveList = null;
         this.SetUpLists();
         GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnEntryPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         TextFieldEx.setTextAutoSize(this.ContinueInfo_mc.PlayerName_mc.PlayerName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.ContinueInfo_mc.Location_mc.Location_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.ContinueInfo_mc.PlayTime_mc.PlayTime_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      protected function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function get activeList() : BSScrollingContainer
      {
         return this.ActiveList;
      }
      
      private function set currentState(param1:uint) : *
      {
         if(this.CurrentState != param1)
         {
            this.CurrentState = param1;
            this.ActiveList = null;
            switch(this.CurrentState)
            {
               case this.LPS_DISPLAY_MODE:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
                  this.FillContinueData();
                  break;
               case this.LPS_SELECT_MODE:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
                  this.ActiveList = this.LoadList_mc;
                  break;
               case this.LPS_CHECKING_LOAD:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
                  if(this.LoadList_mc.selectedEntry != null)
                  {
                     dispatchEvent(new CustomEvent(LOAD_PANEL_PRESS,{"loadIndex":this.LoadList_mc.selectedEntry.uGameEntryIndex},true,true));
                  }
                  break;
               case this.LPS_CONFIRMING_LOAD:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"$ConfirmLoad");
                  break;
               case this.LPS_CONFIRMING_DELETE:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"$Delete this save?");
                  break;
               case this.LPS_SELECT_CHARACTER:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
                  this.ActiveList = this.CharacterList_mc;
                  break;
               default:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
            }
            dispatchEvent(new Event(PanelUtils.ACTIVE_LIST_CHANGED,true,true));
            this.UpdateComponentVisibility();
            this.UpdateButtons();
         }
      }
      
      public function SetUpLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.GameDataListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.LoadList_mc.Configure(_loc1_);
         var _loc2_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc2_.VerticalSpacing = 1.5;
         _loc2_.EntryClassName = "Shared.Components.SystemPanels.CharacterListEntry";
         _loc2_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.CharacterList_mc.Configure(_loc2_);
      }
      
      public function Open() : void
      {
         this.visible = true;
         if(this.CurrentState == this.LPS_NONE)
         {
            this.currentState = this.LPS_SELECT_MODE;
         }
      }
      
      public function DisplayContinueInfo() : void
      {
         this.visible = true;
         if(this.CurrentState == this.LPS_NONE)
         {
            this.currentState = this.LPS_DISPLAY_MODE;
         }
      }
      
      public function Close() : void
      {
         this.visible = false;
         this.currentState = this.LPS_NONE;
         this.LoadList_mc.selectedIndex = 0;
         this.CharacterList_mc.selectedIndex = 0;
      }
      
      public function OnConfirmDataUpdate(param1:Boolean) : void
      {
         if(this.CurrentState == this.LPS_CHECKING_LOAD)
         {
            if(param1)
            {
               this.currentState = this.LPS_CONFIRMING_LOAD;
            }
            else
            {
               this.currentState = this.LPS_SELECT_MODE;
            }
         }
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.DeleteButton = ButtonFactory.AddToButtonBar("BasicButton",this.DeleteButtonData,this.ButtonBar_mc);
         this.CharacterButton = ButtonFactory.AddToButtonBar("BasicButton",this.CharacterButtonData,this.ButtonBar_mc);
         this.UploadSaveButton = ButtonFactory.AddToButtonBar("BasicButton",this.UploadSaveButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,this.CancelButtonData);
         this.UpdateButtons();
      }
      
      protected function UpdateButtons() : void
      {
         var _loc1_:* = this.CurrentState == this.LPS_SELECT_MODE;
         var _loc2_:* = this.CurrentState == this.LPS_CONFIRMING_LOAD;
         var _loc3_:* = this.CurrentState == this.LPS_CONFIRMING_DELETE;
         var _loc4_:* = this.CurrentState == this.LPS_SELECT_CHARACTER;
         var _loc5_:* = this.CurrentState == this.LPS_LOAD_CONFIRMED;
         this.ConfirmButton.Visible = _loc2_ || _loc3_;
         this.ConfirmButton.Enabled = _loc2_ || _loc3_;
         this.DeleteButton.Visible = _loc1_ && this.LoadList_mc.selectedEntry != null;
         this.DeleteButton.Enabled = _loc1_ && this.LoadList_mc.selectedEntry != null;
         this.CharacterButton.Visible = _loc1_;
         this.CharacterButton.Enabled = _loc1_;
         this.UploadSaveButton.Visible = _loc1_ && this.AllowSavesToUpload;
         this.UploadSaveButton.Enabled = _loc1_ && this.AllowSavesToUpload;
         this.CancelButton.Visible = _loc1_ || _loc2_ || _loc3_ || _loc4_;
         this.CancelButton.Enabled = _loc1_ || _loc2_ || _loc3_ || _loc4_;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateComponentVisibility() : void
      {
         var _loc1_:* = this.CurrentState == this.LPS_DISPLAY_MODE;
         var _loc2_:* = this.CurrentState == this.LPS_SELECT_MODE;
         var _loc3_:* = this.CurrentState == this.LPS_CHECKING_LOAD;
         var _loc4_:* = this.CurrentState == this.LPS_CONFIRMING_LOAD;
         var _loc5_:* = this.CurrentState == this.LPS_CONFIRMING_DELETE;
         var _loc6_:* = this.CurrentState == this.LPS_SELECT_CHARACTER;
         var _loc7_:* = this.CurrentState == this.LPS_LOAD_CONFIRMED;
         this.ContinueInfo_mc.visible = _loc1_;
         this.LoadList_mc.visible = _loc2_ || _loc3_ || _loc4_ || _loc5_ || _loc7_;
         this.CharacterList_mc.visible = _loc6_;
         this.ConfirmPrompt_mc.visible = _loc4_ || _loc5_;
         this.SetListInteractivity();
      }
      
      private function SetListInteractivity() : *
      {
         this.LoadList_mc.disableInput = this.CurrentState != this.LPS_SELECT_MODE;
         this.LoadList_mc.disableSelection = this.CurrentState != this.LPS_SELECT_MODE;
         this.CharacterList_mc.disableInput = this.CurrentState != this.LPS_SELECT_CHARACTER;
         this.CharacterList_mc.disableSelection = this.CurrentState != this.LPS_SELECT_CHARACTER;
      }
      
      private function FillContinueData() : void
      {
         var _loc1_:String = null;
         if(this.ContinueData != null)
         {
            GlobalFunc.SetText(this.ContinueInfo_mc.PlayerName_mc.PlayerName_tf,this.ContinueData.sPlayerName);
            _loc1_ = "";
            if(this.ContinueData.bAutosave)
            {
               _loc1_ = "$$AUTOSAVE ";
            }
            else if(this.ContinueData.bExitsave)
            {
               _loc1_ = "$$EXITSAVE ";
            }
            else if(this.ContinueData.bQuicksave)
            {
               _loc1_ = "$$QUICKSAVE ";
            }
            GlobalFunc.SetText(this.ContinueInfo_mc.Location_mc.Location_tf,_loc1_ + this.ContinueData.sLocation,false,false,GameDataListEntry.LOCATION_NAME_MAX_TRUNCATE_LEN);
            if(this.ContinueData.uGameEntryIndex != -1)
            {
               GlobalFunc.SetText(this.ContinueInfo_mc.PlayerLevel_mc.text_tf,"$$Level " + this.ContinueData.uLevel);
               GlobalFunc.SetText(this.ContinueInfo_mc.SaveDate_mc.text_tf,this.ContinueData.sFileDate);
               GlobalFunc.SetText(this.ContinueInfo_mc.SaveTime_mc.text_tf,this.ContinueData.sFileTime);
            }
            else
            {
               GlobalFunc.SetText(this.ContinueInfo_mc.PlayerLevel_mc.text_tf,"");
               GlobalFunc.SetText(this.ContinueInfo_mc.SaveDate_mc.text_tf,"");
               GlobalFunc.SetText(this.ContinueInfo_mc.SaveTime_mc.text_tf,"");
            }
            if(this.ContinueData.sPlayTime)
            {
               GlobalFunc.SetText(this.ContinueInfo_mc.PlayTime_mc.PlayTime_tf,GameDataListEntry.FormatPlayTime(this.ContinueData.sPlayTime));
            }
            else
            {
               GlobalFunc.SetText(this.ContinueInfo_mc.PlayTime_mc.PlayTime_tf,"");
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.CurrentState == this.LPS_SELECT_MODE || this.CurrentState == this.LPS_CONFIRMING_LOAD || this.CurrentState == this.LPS_CONFIRMING_DELETE || this.CurrentState == this.LPS_SELECT_CHARACTER)
         {
            _loc3_ = this.ProcessEventForButtonBar(param1,param2);
         }
         return _loc3_;
      }
      
      protected function ProcessEventForButtonBar(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function UpdateLoadData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1 != null)
         {
            _loc2_ = 1;
            for each(_loc3_ in param1.aGameDataList)
            {
               _loc3_.iCurrentSlotNumber = _loc2_++;
            }
            this.LoadList_mc.InitializeEntries(param1.aGameDataList);
            if(this.LoadList_mc.selectedIndex < 0)
            {
               this.LoadList_mc.selectedIndex = 0;
            }
            if(param1.aGameDataList.length > 0)
            {
               this.ContinueData = param1.aGameDataList[0];
            }
            if(this.CurrentState == this.LPS_DELETE_CONFIRMED)
            {
               if(this.LoadList_mc.entryCount > 0)
               {
                  this.currentState = this.LPS_SELECT_MODE;
               }
               else
               {
                  this.currentState = this.LPS_SELECT_CHARACTER;
               }
            }
            else if(this.CurrentState == this.LPS_SELECT_CHARACTER_CONFIRMED)
            {
               this.currentState = this.LPS_SELECT_MODE;
            }
            this.CharacterList_mc.InitializeEntries(param1.aCharacterDataList);
            if(this.CharacterList_mc.selectedIndex < 0)
            {
               this.CharacterList_mc.selectedIndex = 0;
            }
            this.ModsLoaded_mc.visible = param1.bModsLoaded;
            this.AllowSavesToUpload = param1.bAllowSavesToUpload;
            this.UpdateButtons();
         }
      }
      
      private function OnEntryPress(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         if(this.CurrentState == this.LPS_SELECT_MODE && param1.target == this.LoadList_mc)
         {
            this.currentState = this.LPS_CHECKING_LOAD;
         }
         else if(this.CurrentState == this.LPS_SELECT_CHARACTER && param1.target == this.CharacterList_mc && this.CharacterList_mc.selectedEntry != null)
         {
            this.SetCurrentCharacter(this.CharacterList_mc.selectedEntry.uCharacterID);
            this.currentState = this.LPS_SELECT_CHARACTER_CONFIRMED;
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         if(this.visible)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         }
      }
      
      private function SetCurrentCharacter(param1:Object) : void
      {
         dispatchEvent(new CustomEvent(LOAD_PANEL_SET_CHARACTER,{"characterID":param1},true,true));
      }
      
      private function onAccept() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         switch(this.CurrentState)
         {
            case this.LPS_CONFIRMING_LOAD:
               this.currentState = this.LPS_LOAD_CONFIRMED;
               dispatchEvent(new Event(LOAD_PANEL_CONFIRM,true,true));
               break;
            case this.LPS_CONFIRMING_DELETE:
               this.currentState = this.LPS_DELETE_CONFIRMED;
               dispatchEvent(new CustomEvent(LOAD_PANEL_DELETE,{"deleteIndex":this.LoadList_mc.selectedEntry.uGameEntryIndex},true,true));
         }
      }
      
      private function onDeleteSave() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         this.currentState = this.LPS_CONFIRMING_DELETE;
      }
      
      private function onUploadSave() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         if(this.LoadList_mc.selectedEntry != null)
         {
            dispatchEvent(new CustomEvent(LOAD_PANEL_UPLOAD_SAVE,{"loadIndex":this.LoadList_mc.selectedEntry.uGameEntryIndex},true,true));
         }
      }
      
      private function onSelectCharacter() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         this.currentState = this.LPS_SELECT_CHARACTER;
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         switch(this.CurrentState)
         {
            case this.LPS_SELECT_MODE:
               dispatchEvent(new Event(PanelUtils.CLOSE_PANEL,true,true));
               break;
            case this.LPS_CONFIRMING_LOAD:
               dispatchEvent(new Event(LOAD_PANEL_CANCEL,true,true));
               this.currentState = this.LPS_SELECT_MODE;
               break;
            case this.LPS_CONFIRMING_DELETE:
            case this.LPS_SELECT_CHARACTER:
               this.currentState = this.LPS_SELECT_MODE;
         }
      }
   }
}
