package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSSlider;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public dynamic class QuantityComponent extends BSDisplayObject
   {
      
      public static const WINDOW_CLOSED:String = "WindowClosed";
      
      public static const CONFIRM_TRANSACTION:String = "ConfirmTransaction";
      
      public static const CANCEL_TRANSACTION:String = "CancelTransaction";
      
      public static const INV_MAX_NUM_BEFORE_QUANTITY_MENU:uint = 5;
       
      
      public var Header_mc:MovieClip;
      
      public var QuantityMeter_mc:BSSlider;
      
      public var Warning_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var TotalCost_mc:MovieClip;
      
      private const OPEN_STATE:String = "Open";
      
      private const CLOSE_STATE:String = "Close";
      
      private const WARNING_OPEN_STATE:String = "Warning_Open";
      
      private const WARNING_CLOSE_STATE:String = "Warning_Close";
      
      private const BARTER_OPEN_STATE:String = "Barter_Open";
      
      private const BARTER_CLOSE_STATE:String = "Barter_Close";
      
      private const BARTERWARNING_OPEN_STATE:String = "BarterWarning_Open";
      
      private const BARTERWARNING_CLOSE_STATE:String = "BarterWarning_Close";
      
      private var bShowingWarning:Boolean = false;
      
      private var bSkipSounds:Boolean = false;
      
      private var bIsBartering:Boolean = false;
      
      private var CostPerItem:uint = 0;
      
      private var WarningFunc:Function = null;
      
      private var AllButtonData:ButtonBaseData;
      
      public function QuantityComponent()
      {
         this.AllButtonData = new ButtonBaseData("",[new UserEventData("XButton",this.onAllPress)]);
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.QuantityText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.HeaderText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.WarningText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.QuantityMeter_mc.addEventListener(BSSlider.VALUE_CHANGED,function():*
         {
            GlobalFunc.SetText(QuantityText_tf,QuantityMeter_mc.value.toString());
            UpdateTotalCost();
            if(!bSkipSounds)
            {
               GlobalFunc.PlayMenuSound("UIMenuGeneralSlider");
            }
            bSkipSounds = false;
         });
         this.PopulateButtonBar();
      }
      
      public function get CurrentQuantity() : uint
      {
         return Math.round(this.QuantityMeter_mc.value);
      }
      
      private function get BackButton() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get AcceptButton() : IButton
      {
         return this.ButtonBar_mc.AcceptButton_mc;
      }
      
      private function get AllButton() : IButton
      {
         return this.ButtonBar_mc.AllButton_mc;
      }
      
      public function get HeaderText_tf() : TextField
      {
         return this.Header_mc.Text_tf;
      }
      
      public function get WarningText_tf() : TextField
      {
         return this.Warning_mc.Text_tf;
      }
      
      public function get QuantityText_tf() : TextField
      {
         return (this.QuantityMeter_mc as MovieClip).Number_tf;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):void
         {
            if(param1.target is QuantityComponent)
            {
               addEventListener(Event.ENTER_FRAME,SwitchFocusToMeter);
            }
         });
      }
      
      private function SwitchFocusToMeter() : void
      {
         stage.focus = this.QuantityMeter_mc;
         removeEventListener(Event.ENTER_FRAME,this.SwitchFocusToMeter);
      }
      
      private function PopulateButtonBar() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.AllButton,this.AllButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.AcceptButton,new ButtonBaseData("$CONFIRM",[new UserEventData("Accept",this.onAcceptEvent)],true,true));
         this.ButtonBar_mc.AddButtonWithData(this.BackButton,new ButtonBaseData("$BACK",[new UserEventData("Cancel",this.onCancelEvent)],true,true));
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function SetData(param1:uint, param2:String, param3:String = "", param4:Function = null, param5:Boolean = false, param6:uint = 0) : *
      {
         if(param3.length > 0)
         {
            this.AllButtonData.sButtonText = param3;
            this.AllButton.SetButtonData(this.AllButtonData);
            this.AllButton.Enabled = true;
            this.AllButton.Visible = true;
         }
         else
         {
            this.AllButton.Enabled = false;
            this.AllButton.Visible = false;
         }
         GlobalFunc.SetText(this.HeaderText_tf,param2);
         this.bSkipSounds = true;
         this.QuantityMeter_mc.minValue = 1;
         this.QuantityMeter_mc.maxValue = param1;
         this.QuantityMeter_mc.value = param1;
         this.bIsBartering = param5;
         this.CostPerItem = param6;
         this.WarningFunc = param4;
         var _loc7_:String = "";
         if(this.WarningFunc != null)
         {
            _loc7_ = this.WarningFunc(this.CurrentQuantity,this.CostPerItem);
         }
         this.bShowingWarning = _loc7_.length > 0;
         GlobalFunc.SetText(this.WarningText_tf,_loc7_);
         if(this.bIsBartering)
         {
            gotoAndPlay(this.bShowingWarning ? this.BARTERWARNING_OPEN_STATE : this.BARTER_OPEN_STATE);
            this.UpdateTotalCost();
         }
         else
         {
            gotoAndPlay(this.bShowingWarning ? this.WARNING_OPEN_STATE : this.OPEN_STATE);
         }
         this.ButtonBar_mc.RefreshButtons();
         this.QuantityMeter_mc.sliderEnabled = true;
      }
      
      private function HideWindow() : *
      {
         dispatchEvent(new Event(WINDOW_CLOSED));
      }
      
      private function BeginClosingWindow() : *
      {
         this.QuantityMeter_mc.sliderEnabled = false;
         if(this.bIsBartering)
         {
            gotoAndPlay(this.bShowingWarning ? this.BARTERWARNING_CLOSE_STATE : this.BARTER_CLOSE_STATE);
         }
         else
         {
            gotoAndPlay(this.bShowingWarning ? this.WARNING_CLOSE_STATE : this.CLOSE_STATE);
         }
      }
      
      private function onCancelEvent() : void
      {
         this.BeginClosingWindow();
         dispatchEvent(new Event(CANCEL_TRANSACTION));
      }
      
      private function onAcceptEvent() : void
      {
         this.BeginClosingWindow();
         dispatchEvent(new Event(CONFIRM_TRANSACTION));
      }
      
      private function onAllPress() : void
      {
         this.QuantityMeter_mc.value = this.QuantityMeter_mc.maxValue;
         this.UpdateTotalCost();
         this.BeginClosingWindow();
         dispatchEvent(new Event(CONFIRM_TRANSACTION));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.QuantityMeter_mc.sliderEnabled)
         {
            _loc3_ = this.QuantityMeter_mc.ProcessUserEvent(param1,param2);
            _loc3_ ||= this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function UpdateTotalCost() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         if(this.TotalCost_mc)
         {
            _loc1_ = this.CurrentQuantity * this.CostPerItem;
            GlobalFunc.SetText(this.TotalCost_mc.Cost_tf,_loc1_.toString());
            if(this.bShowingWarning && this.WarningFunc != null)
            {
               _loc2_ = this.WarningFunc(this.CurrentQuantity,this.CostPerItem);
               this.Warning_mc.visible = _loc2_.length > 0;
               GlobalFunc.SetText(this.WarningText_tf,_loc2_);
            }
         }
      }
   }
}
