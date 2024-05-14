package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.TextFieldEx;
   
   public class InteractiveMessage extends MovieClip
   {
       
      
      public var TitleSection_mc:MovieClip;
      
      public var List_mc:BSScrollingContainer;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Background_mc:MovieClip;
      
      private var _largeTextMode:Boolean = false;
      
      private var _active:Boolean = false;
      
      public function InteractiveMessage()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "InteractiveMessage_Entry";
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.List_mc.Configure(_loc1_);
         this.List_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.onSelectionChange);
         this.PopulateButtonBars();
         this.active = false;
         if(!this._largeTextMode)
         {
            TextFieldEx.setTextAutoSize(this.TitleSection_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         BSUIDataManager.Subscribe("WorkshopInteractiveMessageData",this.OnMessageDataUpdate);
      }
      
      public function get focusObject() : MovieClip
      {
         return this.active ? this.List_mc : null;
      }
      
      private function get selectedEntry() : Object
      {
         return this.List_mc.selectedEntry;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : *
      {
         if(!this._active && param1)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            gotoAndPlay(WorkshopUtils.OPEN_FRAME);
         }
         else if(this._active && !param1)
         {
            gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
         }
         this._active = param1;
         stage.focus = this.focusObject;
      }
      
      private function PopulateButtonBars() : *
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$SELECT",new UserEventData("Confirm",this.OnConfirm)),this.ButtonBar_mc);
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.OnCancel)),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function OnMessageDataUpdate(param1:FromClientDataEvent) : void
      {
         WorkshopUtils.SetSingleLineText(this.TitleSection_mc.Text_tf,param1.data.sMessageText,this._largeTextMode);
         this.List_mc.InitializeEntries(param1.data.aChoices);
         if(param1.data.aChoices.length > 0)
         {
            this.List_mc.selectedIndex = 0;
         }
         this.active = param1.data.sMessageText != "";
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function onSelectionChange(param1:ScrollingEvent) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      private function OnConfirm() : void
      {
         if(this.selectedEntry)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_MessageCallback",{"choice":this.List_mc.selectedIndex}));
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         }
      }
      
      private function OnCancel() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopMenu_MessageCallback",{"choice":-1}));
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
      }
   }
}
