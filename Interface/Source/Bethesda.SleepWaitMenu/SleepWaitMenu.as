package
{
   import Shared.AS3.BSSlider;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import scaleform.gfx.Extensions;
   
   public class SleepWaitMenu extends IMenu
   {
      
      protected static var MOUSE_WHEEL_VALUE_CHANGE:int = 1;
      
      protected static var TIME_TO_WAIT_BEFORE_CONSIDERED_HELD:Number = 500;
       
      
      public var __id0_:MovieClip;
      
      public var __id1_:MovieClip;
      
      public var CurrentTime_tf:TextField;
      
      public var LocalTime_tf:TextField;
      
      public var Label_tf:TextField;
      
      public var Value_tf:TextField;
      
      public var Slider_mc:BSSlider;
      
      public var Function_tf:TextField;
      
      public var BGRect_mc:MovieClip;
      
      public var FadeInBackground_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var DayTime_tf:TextField;
      
      private var WaitButtonData:ButtonBaseData;
      
      protected var bSleeping:Boolean = false;
      
      protected var bOpened:Boolean = false;
      
      protected var bWaiting:Boolean = false;
      
      protected var bLeftHeld:Boolean = false;
      
      protected var bRightHeld:Boolean = false;
      
      protected var ButtonHeldStartTime:Number = 0;
      
      private var fLocalPlanetHoursPerDay:Number = 0;
      
      public function SleepWaitMenu()
      {
         this.WaitButtonData = new ButtonBaseData("$Wait",new UserEventData("Accept",this.onAcceptPressed));
         super();
         this.visible = false;
         this.Slider_mc.minValue = 1;
         this.Slider_mc.maxValue = 24;
         this.Slider_mc.value = 1;
         this.Slider_mc.mouseWheelValueChange = 1;
         this.Slider_mc.addEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
         this.PopulateButtonBar();
         this.UpdateButtonHints();
         stage.focus = this;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.__setProp_BGRect_mc_Wait_mc_Brackets_0();
         this.__setProp___id0__Wait_mc_LowerBorder_0();
         this.__setProp___id1__Wait_mc_UpperBorder_0();
      }
      
      private function get WaitButton() : IButton
      {
         return this.ButtonBar_mc.WaitButton_mc;
      }
      
      private function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("SleepWaitData",this.onSleepWaitDataChange);
         BSUIDataManager.Subscribe("SleepWaitRemainingHours",this.onSleepWaitRemainingHoursChange);
         BSUIDataManager.Subscribe("SleepWaitTimeData",this.onSleepWaitTimeDataChange);
         BSUIDataManager.Subscribe("SleepStickData",this.onStickDataChanged);
         GlobalFunc.PlayMenuSound("UIToolTipPopUpStart");
      }
      
      override protected function onSetSafeRect() : void
      {
         Extensions.enabled = true;
         this.FadeInBackground_mc.x = Extensions.visibleRect.x;
         this.FadeInBackground_mc.y = this.FadeInBackground_mc.y / 720 * Extensions.visibleRect.height;
         this.FadeInBackground_mc.width = this.FadeInBackground_mc.width / 1280 * Extensions.visibleRect.width;
         this.FadeInBackground_mc.height = this.FadeInBackground_mc.height / 720 * Extensions.visibleRect.height;
      }
      
      private function PopulateButtonBar() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.WaitButton,this.WaitButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.onCancelPressed)));
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateButtonHints() : *
      {
         this.WaitButtonData.sButtonText = this.bSleeping ? "$SLEEP" : "$Wait";
         this.WaitButton.SetButtonData(this.WaitButtonData);
      }
      
      private function onStickDataChanged(param1:FromClientDataEvent) : *
      {
         if(Math.abs(param1.data.fInputX) > 0.1)
         {
            if(!this.bLeftHeld && param1.data.fInputX < 0)
            {
               this.ProcessUserEvent("Left",true);
            }
            else if(!this.bRightHeld && param1.data.fInputX > 0)
            {
               this.ProcessUserEvent("Right",true);
            }
         }
         else if(this.bLeftHeld || this.bRightHeld)
         {
            this.ProcessUserEvent(this.bLeftHeld ? "Left" : "Right",false);
         }
      }
      
      public function SetSleeping(param1:Boolean) : *
      {
         this.bSleeping = param1;
         if(this.bSleeping)
         {
            GlobalFunc.SetText(this.Label_tf,"$SLEEP");
            GlobalFunc.SetText(this.Function_tf,"$SleepPrompt",false);
         }
         else
         {
            GlobalFunc.SetText(this.Label_tf,"$Wait");
            GlobalFunc.SetText(this.Function_tf,"$WaitPrompt",false);
         }
         this.RefreshText();
         this.UpdateButtonHints();
      }
      
      public function onEnterFrame(param1:Event) : *
      {
         if(this.bLeftHeld || this.bRightHeld)
         {
            if(getTimer() - this.ButtonHeldStartTime >= TIME_TO_WAIT_BEFORE_CONSIDERED_HELD)
            {
               this.Slider_mc.value += this.bLeftHeld ? -1 : 1;
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!this.bWaiting)
         {
            if(!param2)
            {
               if(param1 == "Left" || param1 == "Down")
               {
                  this.bLeftHeld = false;
                  _loc3_ = true;
               }
               else if(param1 == "Right" || param1 == "Up")
               {
                  this.bRightHeld = false;
                  _loc3_ = true;
               }
            }
            else if(param1 == "Left" || param1 == "Down")
            {
               this.bLeftHeld = true;
               this.bRightHeld = false;
               --this.Slider_mc.value;
               this.ButtonHeldStartTime = getTimer();
               _loc3_ = true;
            }
            else if(param1 == "Right" || param1 == "Up")
            {
               this.bRightHeld = true;
               this.bLeftHeld = false;
               this.Slider_mc.value += 1;
               this.ButtonHeldStartTime = getTimer();
               _loc3_ = true;
            }
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onAcceptPressed() : void
      {
         if(this.bSleeping)
         {
            this.FadeInBackground_mc.gotoAndPlay("fadeIn");
         }
         this.SetWaiting(true);
         BSUIDataManager.dispatchEvent(new CustomEvent("SleepWaitMenu_StartRest",{"uHours":this.Slider_mc.value}));
      }
      
      private function onCancelPressed() : void
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralCancel");
         if(this.bWaiting)
         {
            this.SetWaiting(false);
            BSUIDataManager.dispatchEvent(new Event("SleepWaitMenu_InterruptRest"));
         }
         else
         {
            GlobalFunc.CloseMenu("SleepWaitMenu");
         }
      }
      
      private function onValueChanged() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralSlider");
         this.RefreshText();
      }
      
      public function SetWaiting(param1:Boolean) : *
      {
         this.bWaiting = param1;
         this.WaitButton.Enabled = !param1;
         this.Slider_mc.sliderEnabled = !param1;
         if(param1)
         {
            this.bLeftHeld = false;
            this.bRightHeld = false;
         }
      }
      
      private function RefreshText() : *
      {
         var _loc1_:Number = this.Slider_mc.value * (this.fLocalPlanetHoursPerDay != 0 ? this.fLocalPlanetHoursPerDay / 24 : 1);
         var _loc2_:int = Math.floor(_loc1_);
         var _loc3_:int = Math.round((_loc1_ - _loc2_) * 60);
         if(_loc2_ == 0 && _loc3_ == 0)
         {
            _loc3_ = 1;
         }
         GlobalFunc.SetText(this.Value_tf,this.Slider_mc.value.toString() + (this.Slider_mc.value == 1 ? " $$LOCAL_HOUR" : " $$LOCAL_HOURS") + "  ( " + (_loc2_ > 0 ? _loc2_.toString() + (_loc2_ == 1 ? " $$HOUR" : " $$HOURS") + " " : "") + (_loc3_ > 0 ? _loc3_.toString() + (_loc3_ == 1 ? " $$MINUTE" : " $$MINUTES") : "") + " $$UT" + " )",false);
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         if(!this.bWaiting)
         {
            this.Slider_mc.valueJump(MOUSE_WHEEL_VALUE_CHANGE * (param1.delta < 0 ? -1 : 1));
         }
      }
      
      protected function onSleepWaitDataChange(param1:FromClientDataEvent) : *
      {
         if(param1)
         {
            this.SetWaiting(false);
            this.Slider_mc.value = param1.data.iDefaultHours;
            this.SetSleeping(param1.data.bSleeping);
         }
      }
      
      protected function onSleepWaitRemainingHoursChange(param1:FromClientDataEvent) : *
      {
         if(param1)
         {
            this.Slider_mc.value = param1.data.iRemainingHours;
            this.RefreshText();
         }
      }
      
      public function onSleepWaitTimeDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(Boolean(param1) && Boolean(param1.data.bInitialized))
         {
            this.visible = true;
            this.fLocalPlanetHoursPerDay = param1.data.fLocalPlanetHoursPerDay;
            _loc2_ = Math.floor(param1.data.fGalacticStandardTime);
            _loc3_ = Math.floor((param1.data.fGalacticStandardTime - _loc2_) * 60);
            GlobalFunc.SetText(this.CurrentTime_tf,GlobalFunc.PadNumber(_loc2_,2) + ":" + GlobalFunc.PadNumber(_loc3_,2) + " $$UT");
            _loc4_ = param1.data.fLocalPlanetTime * 24;
            _loc5_ = Math.floor(_loc4_ / 24);
            _loc4_ -= _loc5_ * 24;
            _loc6_ = Math.floor(_loc4_);
            _loc7_ = Math.floor((_loc4_ - _loc6_) * 60);
            GlobalFunc.SetText(this.LocalTime_tf,GlobalFunc.PadNumber(_loc6_,2) + ":" + GlobalFunc.PadNumber(_loc7_,2) + " $$LocalTime",false,false,0,false,0,[GlobalFunc.RoundDecimal(param1.data.fLocalPlanetHoursPerDay,0)]);
            this.RefreshText();
         }
      }
      
      internal function __setProp_BGRect_mc_Wait_mc_Brackets_0() : *
      {
         try
         {
            this.BGRect_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.BGRect_mc.bracketCornerLength = 6;
         this.BGRect_mc.bracketLineWidth = 1.5;
         this.BGRect_mc.bracketPaddingX = 0;
         this.BGRect_mc.bracketPaddingY = 0;
         this.BGRect_mc.BracketStyle = "horizontal";
         this.BGRect_mc.bShowBrackets = false;
         this.BGRect_mc.bUseShadedBackground = true;
         this.BGRect_mc.ShadedBackgroundMethod = "Shader";
         this.BGRect_mc.ShadedBackgroundType = "normal";
         try
         {
            this.BGRect_mc["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id0__Wait_mc_LowerBorder_0() : *
      {
         try
         {
            this.__id0_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id0_.bracketCornerLength = 6;
         this.__id0_.bracketLineWidth = 1.5;
         this.__id0_.bracketPaddingX = 0;
         this.__id0_.bracketPaddingY = 0;
         this.__id0_.BracketStyle = "horizontal";
         this.__id0_.bShowBrackets = false;
         this.__id0_.bUseShadedBackground = true;
         this.__id0_.ShadedBackgroundMethod = "Shader";
         this.__id0_.ShadedBackgroundType = "normal";
         try
         {
            this.__id0_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp___id1__Wait_mc_UpperBorder_0() : *
      {
         try
         {
            this.__id1_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id1_.bracketCornerLength = 6;
         this.__id1_.bracketLineWidth = 1.5;
         this.__id1_.bracketPaddingX = 0;
         this.__id1_.bracketPaddingY = 0;
         this.__id1_.BracketStyle = "horizontal";
         this.__id1_.bShowBrackets = false;
         this.__id1_.bUseShadedBackground = true;
         this.__id1_.ShadedBackgroundMethod = "Shader";
         this.__id1_.ShadedBackgroundType = "normal";
         try
         {
            this.__id1_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
