package Shared.Components.SystemPanels
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import scaleform.gfx.TextFieldEx;
   
   public class HelpPanel extends MovieClip implements IPanel
   {
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var TopicList_mc:BSScrollingContainer;
      
      public var ScrollableDescription_mc:HelpPanelScrollableDescription;
      
      public var DescriptionHeader_tf:TextField;
      
      private var bHeld:Boolean = false;
      
      private var bHoldingUp:Boolean = false;
      
      private var ButtonHeldStartTime:Number = 0;
      
      private const TIME_TO_WAIT_BEFORE_CONSIDERED_HELD:Number = 500;
      
      private var _largeTextMode:Boolean = false;
      
      public function HelpPanel()
      {
         super();
         addEventListener(ScrollingEvent.SELECTION_CHANGE,this.OnSelectionChange);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      private function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function get activeList() : BSScrollingContainer
      {
         return this.TopicList_mc;
      }
      
      public function set largeTextMode(param1:Boolean) : *
      {
         this._largeTextMode = param1;
         HelpTopicListEntry.largeTextMode = param1;
      }
      
      public function ConfigureLists() : void
      {
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 1.5;
         _loc1_.EntryClassName = "Shared.Components.SystemPanels.HelpTopicListEntry";
         _loc1_.TextOption = this._largeTextMode ? TextFieldEx.TEXTAUTOSZ_NONE : TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.TopicList_mc.Configure(_loc1_);
      }
      
      public function Open() : void
      {
         this.visible = true;
         this.TopicList_mc.selectedIndex = 0;
      }
      
      public function Close() : void
      {
         this.visible = false;
      }
      
      public function PopulateButtonBar(param1:uint, param2:int) : void
      {
         this.ButtonBar_mc.Initialize(param1,param2);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancel)));
         this.CancelButton.Visible = true;
         this.CancelButton.Enabled = true;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function UpdateTopicData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.TopicList_mc.InitializeEntries(param1.aTopics);
            this.TopicList_mc.SortEntriesOn("sTopicName",Array.CASEINSENSITIVE);
            if(this.TopicList_mc.selectedIndex < 0)
            {
               this.TopicList_mc.selectedIndex = 0;
            }
         }
      }
      
      public function OnConfirmDataUpdate(param1:Boolean) : void
      {
      }
      
      private function OnSelectionChange(param1:Event) : void
      {
         if(param1.target == this.TopicList_mc && this.TopicList_mc.selectedEntry != null)
         {
            GlobalFunc.SetText(this.DescriptionHeader_tf,this.TopicList_mc.selectedEntry.sTopicName);
            this.ScrollableDescription_mc.SetData(this.TopicList_mc.selectedEntry);
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         if(this.visible)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
         }
      }
      
      public function ProcessStickData(param1:Number) : *
      {
         if(Math.abs(param1) > 0.1)
         {
            if(!this.bHeld)
            {
               this.ButtonHeldStartTime = getTimer();
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            if((!this.bHoldingUp || !this.bHeld) && param1 < 0)
            {
               this.bHeld = true;
               this.bHoldingUp = true;
               this.ScrollableDescription_mc.MoveScroll(HelpPanelScrollableDescription.SCROLL_DELTA);
            }
            else if((this.bHoldingUp || !this.bHeld) && param1 > 0)
            {
               this.bHeld = true;
               this.bHoldingUp = false;
               this.ScrollableDescription_mc.MoveScroll(-1 * HelpPanelScrollableDescription.SCROLL_DELTA);
            }
         }
         else if(this.bHeld)
         {
            this.bHeld = false;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function onEnterFrame(param1:Event) : *
      {
         if(this.bHeld)
         {
            if(getTimer() - this.ButtonHeldStartTime >= this.TIME_TO_WAIT_BEFORE_CONSIDERED_HELD)
            {
               if(this.bHoldingUp)
               {
                  this.ScrollableDescription_mc.MoveScroll(HelpPanelScrollableDescription.SCROLL_DELTA);
               }
               else
               {
                  this.ScrollableDescription_mc.MoveScroll(-1 * HelpPanelScrollableDescription.SCROLL_DELTA);
               }
            }
         }
      }
      
      private function onCancel() : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
         dispatchEvent(new Event(PanelUtils.CLOSE_PANEL,true,true));
      }
   }
}
