package Shared.Components.SystemPanels
{
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
   
   public class SavePanel extends MovieClip implements IPanel
   {
      
      public static const SAVE_PANEL_CONFIRM:String = "SavePanel_ConfirmSave";
      
      public static const SAVE_PANEL_DELETE:String = "SavePanel_DeleteSave";
      
      public static const SAVE_PANEL_SET_CHARACTER:String = "SavePanel_SetCharacter";
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var SaveList_mc:BSScrollingContainer;
      
      public var CharacterList_mc:BSScrollingContainer;
      
      public var ConfirmPrompt_mc:MovieClip;
      
      private var ConfirmButton:IButton = null;
      
      private var DeleteButton:IButton = null;
      
      private var CharacterButton:IButton = null;
      
      private var CurrentState:uint;
      
      private var ActiveList:BSScrollingContainer;
      
      private const SPS_NONE:int = EnumHelper.GetEnum(0);
      
      private const SPS_SELECT_MODE:int = EnumHelper.GetEnum();
      
      private const SPS_CONFIRMING_OVERWRITE:int = EnumHelper.GetEnum();
      
      private const SPS_CONFIRMING_DELETE:int = EnumHelper.GetEnum();
      
      private const SPS_DELETE_CONFIRMED:int = EnumHelper.GetEnum();
      
      private const SPS_SAVING:int = EnumHelper.GetEnum();
      
      private const SPS_SELECT_CHARACTER:int = EnumHelper.GetEnum();
      
      private const SPS_SELECT_CHARACTER_CONFIRMED:int = EnumHelper.GetEnum();
      
      public function SavePanel()
      {
         super();
         this.CurrentState = this.SPS_NONE;
         this.ActiveList = null;
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.GameDataListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.SaveList_mc.Configure(_loc1_);
         var _loc2_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc2_.VerticalSpacing = 1.5;
         _loc2_.EntryClassName = "Shared.Components.SystemPanels.CharacterListEntry";
         _loc2_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.CharacterList_mc.Configure(_loc2_);
         GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnEntryHover);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnEntryPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      private function get CancelButton() : IButton
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
               case this.SPS_SELECT_MODE:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
                  this.ActiveList = this.SaveList_mc;
                  break;
               case this.SPS_CONFIRMING_OVERWRITE:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"$Overwrite?");
                  break;
               case this.SPS_CONFIRMING_DELETE:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"$Delete this save?");
                  break;
               case this.SPS_SELECT_CHARACTER:
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
      
      public function Open() : void
      {
         this.visible = true;
         if(this.CurrentState == this.SPS_NONE)
         {
            this.currentState = this.SPS_SELECT_MODE;
         }
      }
      
      public function Close() : void
      {
         this.visible = false;
         this.currentState = this.SPS_NONE;
         this.SaveList_mc.selectedIndex = 0;
      }
      
      public function OnConfirmDataUpdate(param1:Boolean) : void
      {
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept)),this.ButtonBar_mc);
         this.DeleteButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$DELETE",new UserEventData("XButton",this.onDeleteSave)),this.ButtonBar_mc);
         this.CharacterButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SELECT CHARACTER",new UserEventData("YButton",this.onSelectCharacter)),this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel)));
         this.UpdateButtons();
      }
      
      private function UpdateButtons() : void
      {
         var _loc1_:* = this.CurrentState == this.SPS_SELECT_MODE;
         var _loc2_:* = this.CurrentState == this.SPS_CONFIRMING_OVERWRITE;
         var _loc3_:* = this.CurrentState == this.SPS_CONFIRMING_DELETE;
         var _loc4_:* = this.CurrentState == this.SPS_SELECT_CHARACTER;
         this.ConfirmButton.Visible = _loc2_ || _loc3_;
         this.ConfirmButton.Enabled = _loc2_ || _loc3_;
         this.DeleteButton.Visible = _loc1_ && this.SaveList_mc.selectedIndex != 0;
         this.DeleteButton.Enabled = _loc1_ && this.SaveList_mc.selectedIndex != 0;
         this.CharacterButton.Visible = _loc1_;
         this.CharacterButton.Enabled = _loc1_;
         this.CancelButton.Visible = _loc1_ || _loc2_ || _loc3_ || _loc4_;
         this.CancelButton.Enabled = _loc1_ || _loc2_ || _loc3_ || _loc4_;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateComponentVisibility() : void
      {
         var _loc1_:* = this.CurrentState == this.SPS_SELECT_MODE;
         var _loc2_:* = this.CurrentState == this.SPS_CONFIRMING_OVERWRITE;
         var _loc3_:* = this.CurrentState == this.SPS_CONFIRMING_DELETE;
         var _loc4_:* = this.CurrentState == this.SPS_SELECT_CHARACTER;
         var _loc5_:* = this.CurrentState == this.SPS_SAVING;
         this.SaveList_mc.visible = _loc1_ || _loc2_ || _loc3_ || _loc5_;
         this.CharacterList_mc.visible = _loc4_;
         this.ConfirmPrompt_mc.visible = _loc2_ || _loc3_;
         this.SetListInteractivity();
      }
      
      private function SetListInteractivity() : *
      {
         this.SaveList_mc.disableInput = this.CurrentState != this.SPS_SELECT_MODE;
         this.SaveList_mc.disableSelection = this.CurrentState != this.SPS_SELECT_MODE;
         this.CharacterList_mc.disableInput = this.CurrentState != this.SPS_SELECT_CHARACTER;
         this.CharacterList_mc.disableSelection = this.CurrentState != this.SPS_SELECT_CHARACTER;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.CurrentState == this.SPS_SELECT_MODE || this.CurrentState == this.SPS_CONFIRMING_OVERWRITE || this.CurrentState == this.SPS_CONFIRMING_DELETE || this.CurrentState == this.SPS_SELECT_CHARACTER)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function UpdateSaveData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         if(param1 != null)
         {
            _loc2_ = 1;
            _loc3_ = new Array();
            _loc3_.push({
               "sLocation":"$EMPTY",
               "uGameEntryIndex":-1,
               "iCurrentSlotNumber":_loc2_++
            });
            _loc4_ = 0;
            while(_loc4_ < param1.aGameDataList.length)
            {
               _loc5_ = new Object();
               for(_loc6_ in param1.aGameDataList[_loc4_])
               {
                  _loc5_[_loc6_] = param1.aGameDataList[_loc4_][_loc6_];
               }
               _loc5_.iCurrentSlotNumber = _loc2_++;
               _loc3_.push(_loc5_);
               _loc4_++;
            }
            this.SaveList_mc.InitializeEntries(_loc3_);
            if(this.SaveList_mc.selectedIndex < 0)
            {
               this.SaveList_mc.selectedIndex = 0;
            }
            if(this.CurrentState == this.SPS_DELETE_CONFIRMED)
            {
               this.currentState = this.SPS_SELECT_MODE;
            }
            else if(this.CurrentState == this.SPS_SELECT_CHARACTER_CONFIRMED)
            {
               this.currentState = this.SPS_SELECT_MODE;
            }
            this.CharacterList_mc.InitializeEntries(param1.aCharacterDataList);
            if(this.CharacterList_mc.selectedIndex < 0)
            {
               this.CharacterList_mc.selectedIndex = 0;
            }
         }
      }
      
      private function OnEntryHover(param1:ScrollingEvent) : void
      {
         if(this.CurrentState == this.SPS_SELECT_MODE && param1.target == this.SaveList_mc)
         {
            if(param1.CurrentIndex == 0 || param1.PreviousIndex == 0)
            {
               this.UpdateButtons();
            }
         }
      }
      
      private function OnEntryPress(param1:Event) : void
      {
         if(this.CurrentState == this.SPS_SELECT_MODE && param1.target == this.SaveList_mc)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            if(this.SaveList_mc.selectedIndex == 0)
            {
               dispatchEvent(new CustomEvent(SAVE_PANEL_CONFIRM,{"saveIndex":this.SaveList_mc.selectedEntry.uGameEntryIndex},true,true));
               this.currentState = this.SPS_SAVING;
            }
            else
            {
               this.currentState = this.SPS_CONFIRMING_OVERWRITE;
            }
         }
         else if(this.CurrentState == this.SPS_SELECT_CHARACTER && param1.target == this.CharacterList_mc && this.CharacterList_mc.selectedEntry != null)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.SetCurrentCharacter(this.CharacterList_mc.selectedEntry.uCharacterID);
            this.currentState = this.SPS_SELECT_CHARACTER_CONFIRMED;
         }
      }
      
      private function SetCurrentCharacter(param1:Object) : void
      {
         dispatchEvent(new CustomEvent(SAVE_PANEL_SET_CHARACTER,{"characterID":param1},true,true));
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         if(this.visible)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         }
      }
      
      private function onAccept() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         switch(this.CurrentState)
         {
            case this.SPS_CONFIRMING_OVERWRITE:
               dispatchEvent(new CustomEvent(SAVE_PANEL_CONFIRM,{"saveIndex":this.SaveList_mc.selectedEntry.uGameEntryIndex},true,true));
               this.currentState = this.SPS_SAVING;
               break;
            case this.SPS_CONFIRMING_DELETE:
               dispatchEvent(new CustomEvent(SAVE_PANEL_DELETE,{"deleteIndex":this.SaveList_mc.selectedEntry.uGameEntryIndex},true,true));
               this.currentState = this.SPS_DELETE_CONFIRMED;
         }
      }
      
      private function onDeleteSave() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         this.currentState = this.SPS_CONFIRMING_DELETE;
      }
      
      private function onSelectCharacter() : void
      {
         this.currentState = this.SPS_SELECT_CHARACTER;
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         switch(this.CurrentState)
         {
            case this.SPS_SELECT_MODE:
               dispatchEvent(new Event(PanelUtils.CLOSE_PANEL,true,true));
               break;
            case this.SPS_CONFIRMING_OVERWRITE:
               this.currentState = this.SPS_SELECT_MODE;
               break;
            case this.SPS_CONFIRMING_DELETE:
            case this.SPS_SELECT_CHARACTER:
               this.currentState = this.SPS_SELECT_MODE;
         }
      }
   }
}
