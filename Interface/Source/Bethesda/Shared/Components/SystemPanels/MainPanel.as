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
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class MainPanel extends MovieClip implements IPanel
   {
      
      public static const MAIN_PANEL_PRESS:String = "MainPanel_EntryPress";
      
      public static const MAIN_PANEL_CONFIRM:String = "MainPanel_ConfirmAction";
      
      public static const MAIN_PANEL_Y_BTN:String = "MainPanel_YButtonPressed";
      
      public static const MAIN_PANEL_CANCEL:String = "MainPanel_CancelAction";
      
      private static const NO_ACTION:uint = 0;
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var MainList_mc:MainPanelList;
      
      public var ConfirmPrompt_mc:MovieClip;
      
      private var ActiveList:BSScrollingContainer;
      
      private var CurrentAction:uint;
      
      private var ConfirmButton:IButton = null;
      
      private var YButton:IButton = null;
      
      protected var ConfirmButtonData:ButtonBaseData;
      
      protected var YButtonData:ButtonBaseData;
      
      protected var CancelButtonData:ButtonBaseData;
      
      public function MainPanel()
      {
         this.ConfirmButtonData = new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.onAccept));
         this.YButtonData = new ButtonBaseData("",new UserEventData("YButton",this.onYButton));
         this.CancelButtonData = new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel));
         super();
         this.CurrentAction = NO_ACTION;
         this.ActiveList = this.MainList_mc;
         GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
         this.SetUpLists();
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnEntryPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      private function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function get currentAction() : uint
      {
         return this.CurrentAction;
      }
      
      public function get activeList() : BSScrollingContainer
      {
         return this.ActiveList;
      }
      
      public function SetUpLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.MainPanelListEntry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.MainList_mc.Configure(_loc1_);
      }
      
      public function Open() : void
      {
         this.visible = true;
      }
      
      public function Close() : void
      {
         this.visible = false;
         this.CurrentAction = NO_ACTION;
      }
      
      public function SetListInteractive(param1:Boolean) : void
      {
         this.MainList_mc.disableInput = !param1;
         this.MainList_mc.disableSelection = !param1;
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.YButton = ButtonFactory.AddToButtonBar("BasicButton",this.YButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,this.CancelButtonData);
         this.ConfirmButton.Visible = false;
         this.ConfirmButton.Enabled = false;
         this.YButton.Visible = false;
         this.YButton.Enabled = false;
         this.CancelButton.Visible = false;
         this.CancelButton.Enabled = false;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function PopulateMainList(param1:Array) : void
      {
         var _loc2_:uint = NO_ACTION;
         if(this.MainList_mc.selectedEntry != null)
         {
            _loc2_ = uint(this.MainList_mc.selectedEntry.uActionType);
         }
         this.MainList_mc.InitializeEntries(param1);
         if(this.MainList_mc.selectedIndex < 0)
         {
            this.MainList_mc.selectedIndex = 0;
         }
         else if(_loc2_ != NO_ACTION)
         {
            this.MainList_mc.SetIndexByAction(_loc2_);
         }
      }
      
      public function SetYButtonLabel(param1:String) : void
      {
         this.YButtonData.sButtonText = param1;
         this.YButton.SetButtonData(this.YButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function UpdateYButton(param1:Boolean) : void
      {
         if(this.YButton.Visible != param1)
         {
            this.YButton.Visible = param1;
            this.YButton.Enabled = param1;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      protected function UpdateConfirmationButtons(param1:Boolean) : void
      {
         this.ConfirmButton.Visible = param1;
         this.ConfirmButton.Enabled = param1;
         this.CancelButton.Visible = param1;
         this.CancelButton.Enabled = param1;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function OnConfirmDataUpdate(param1:Boolean) : void
      {
         if(param1 && this.MainList_mc.selectedEntry != null && this.MainList_mc.selectedEntry.sConfirmText != "")
         {
            GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,this.MainList_mc.selectedEntry.sConfirmText);
            this.UpdateConfirmationButtons(true);
         }
         else
         {
            this.CurrentAction = NO_ACTION;
            this.ClearConfirmPrompt();
         }
      }
      
      public function ClearConfirmPrompt() : void
      {
         GlobalFunc.SetText(this.ConfirmPrompt_mc.TextPulse_mc.textField,"");
         this.UpdateConfirmationButtons(false);
      }
      
      private function OnEntryPress(param1:Event) : void
      {
         if(!this.MainList_mc.selectedEntry.bDisabled)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.CurrentAction = this.MainList_mc.selectedEntry.uActionType;
            dispatchEvent(new CustomEvent(MAIN_PANEL_PRESS,{"entryAction":this.CurrentAction},true,true));
         }
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
         dispatchEvent(new Event(MAIN_PANEL_CONFIRM,true,true));
      }
      
      private function onYButton() : void
      {
         dispatchEvent(new Event(MAIN_PANEL_Y_BTN,true,true));
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         this.CurrentAction = NO_ACTION;
         dispatchEvent(new Event(MAIN_PANEL_CANCEL,true,true));
      }
   }
}
