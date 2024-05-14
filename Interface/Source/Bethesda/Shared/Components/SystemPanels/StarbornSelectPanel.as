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
   
   public class StarbornSelectPanel extends MovieClip implements IPanel
   {
      
      public static const STARBORN_SELECT_PANEL_PRESS:String = "StarbornSelectPanel_EntryPress";
      
      public static const STARBORN_SELECT_PANEL_CONFIRM:String = "StarbornSelectPanel_ConfirmLoad";
      
      public static const STARBORN_SELECT_PANEL_CANCEL:String = "StarbornSelectPanel_CancelLoad";
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var CharacterList_mc:BSScrollingContainer;
      
      public var ConfirmPrompt_mc:MovieClip;
      
      private var ConfirmButton:IButton = null;
      
      private var CurrentState:uint;
      
      private var ContinueData:Object;
      
      private var ActiveList:BSScrollingContainer;
      
      private const SSS_NONE:int = EnumHelper.GetEnum(0);
      
      private const SSS_SELECT_MODE:int = EnumHelper.GetEnum();
      
      private const SSS_CHECKING_SELECT:int = EnumHelper.GetEnum();
      
      private const SSS_CONFIRMING_SELECT:int = EnumHelper.GetEnum();
      
      private const SSS_STARBORN_SELECTED:int = EnumHelper.GetEnum();
      
      private var SelectedCharacter:uint = 0;
      
      public function StarbornSelectPanel()
      {
         super();
         this.CurrentState = this.SSS_NONE;
         this.ActiveList = null;
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.CharacterListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.CharacterList_mc.Configure(_loc1_);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnEntryPress);
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
               case this.SSS_CHECKING_SELECT:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
                  break;
               case this.SSS_CONFIRMING_SELECT:
                  GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"$ConfirmStarborn");
                  break;
               case this.SSS_SELECT_MODE:
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
         if(this.CurrentState == this.SSS_NONE)
         {
            this.currentState = this.SSS_SELECT_MODE;
         }
      }
      
      public function Close() : void
      {
         this.visible = false;
         this.currentState = this.SSS_NONE;
         this.CharacterList_mc.selectedIndex = 0;
      }
      
      public function OnConfirmDataUpdate(param1:Boolean) : void
      {
         if(this.CurrentState == this.SSS_CHECKING_SELECT)
         {
            if(param1)
            {
               this.currentState = this.SSS_CONFIRMING_SELECT;
            }
            else
            {
               this.currentState = this.SSS_SELECT_MODE;
            }
         }
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept)),this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel)));
         this.UpdateButtons();
      }
      
      private function UpdateButtons() : void
      {
         var _loc1_:* = this.CurrentState == this.SSS_SELECT_MODE;
         var _loc2_:* = this.CurrentState == this.SSS_CONFIRMING_SELECT;
         this.ConfirmButton.Visible = _loc2_;
         this.ConfirmButton.Enabled = _loc2_;
         this.CancelButton.Visible = _loc1_ || _loc2_;
         this.CancelButton.Enabled = _loc1_ || _loc2_;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateComponentVisibility() : void
      {
         var _loc1_:* = this.CurrentState == this.SSS_SELECT_MODE;
         var _loc2_:* = this.CurrentState == this.SSS_CONFIRMING_SELECT;
         this.CharacterList_mc.visible = _loc1_ || _loc2_;
         this.ConfirmPrompt_mc.visible = _loc2_;
         this.SetListInteractivity();
      }
      
      private function SetListInteractivity() : *
      {
         this.CharacterList_mc.disableInput = this.CurrentState != this.SSS_SELECT_MODE;
         this.CharacterList_mc.disableSelection = this.CurrentState != this.SSS_SELECT_MODE;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.CurrentState == this.SSS_SELECT_MODE || this.CurrentState == this.SSS_CHECKING_SELECT || this.CurrentState == this.SSS_CONFIRMING_SELECT)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function UpdateLoadData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.CharacterList_mc.InitializeEntries(param1.aStarbornCharacterDataList);
            if(this.CharacterList_mc.selectedIndex < 0)
            {
               this.CharacterList_mc.selectedIndex = 0;
            }
         }
      }
      
      private function OnEntryPress(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         if(this.CurrentState == this.SSS_SELECT_MODE && param1.target == this.CharacterList_mc && this.CharacterList_mc.selectedEntry != null)
         {
            this.SetCurrentCharacter(this.CharacterList_mc.selectedEntry.uCharacterID);
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         if(this.visible)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         }
      }
      
      private function SetCurrentCharacter(param1:uint) : void
      {
         this.SelectedCharacter = param1;
         this.currentState = this.SSS_CONFIRMING_SELECT;
      }
      
      private function onAccept() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         switch(this.CurrentState)
         {
            case this.SSS_CONFIRMING_SELECT:
               dispatchEvent(new CustomEvent(STARBORN_SELECT_PANEL_PRESS,{"characterID":this.SelectedCharacter},true,true));
               this.currentState = this.SSS_STARBORN_SELECTED;
         }
      }
      
      private function onSelectCharacter() : void
      {
         this.currentState = this.SSS_SELECT_MODE;
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         switch(this.CurrentState)
         {
            case this.SSS_SELECT_MODE:
               dispatchEvent(new Event(PanelUtils.CLOSE_PANEL,true,true));
               break;
            case this.SSS_CONFIRMING_SELECT:
               dispatchEvent(new Event(STARBORN_SELECT_PANEL_CANCEL,true,true));
               this.currentState = this.SSS_SELECT_MODE;
         }
      }
   }
}
