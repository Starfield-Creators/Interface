package Components.PlanetInfoCard
{
   import Components.ModularPanelObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.QuickHoldButton;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class Surveyor extends ModularPanelObject
   {
      
      public static const StarMapMenu_ScanPlanet:String = "StarMapMenu_ScanPlanet";
      
      private static const SCAN_BUTTON_CAN_HOLD:Boolean = true;
      
      private static const SCAN_BUTTON_RETURN_TO_IDLE:Boolean = true;
      
      private static const SCAN_BUTTON_JUSTIFY_HOLD_METER:Boolean = false;
       
      
      public var HoldButton_mc:MovieClip;
      
      public var Header_mc:MovieClip;
      
      public var DoubleHeader_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var Warning_mc:MovieClip;
      
      private var ScanHoldButtonHintData:ButtonBaseData;
      
      private var ScanButtonHintData:ButtonBaseData;
      
      private var IsOpen:Boolean = false;
      
      private var CanHandleRelease:Boolean = false;
      
      private var ScanLabelBaseY:Number;
      
      private var ScanLabelBaseHeight:Number;
      
      private var ScanHoldLabelBaseY:Number;
      
      private var ScanHoldLabelBaseHeight:Number;
      
      private var ScanButtonBaseBounds:Object;
      
      private const BUTTON_PADDING_PC:Number = 20;
      
      private const BUTTON_PADDING_GAMEPAD:Number = 10;
      
      public function Surveyor()
      {
         this.ScanHoldButtonHintData = new ButtonBaseData("$SCAN",[new UserEventData("OpenResourceView",this.ScanPlanetEvent)]);
         this.ScanButtonHintData = new ButtonBaseData("$SCAN",[new UserEventData("OpenResourceView",this.ScanPlanetEvent)],true,false);
         super();
         this.ScanHoldButtonHint.SetButtonData(this.ScanHoldButtonHintData);
         this.ScanButtonHint.SetButtonData(this.ScanButtonHintData);
         this.HoldButton_mc.ErrorHoldButton_mc.visible = false;
         this.ScanLabelBaseY = this.ScanLabel.y;
         this.ScanLabelBaseHeight = this.ScanLabel.height;
         this.ScanHoldLabelBaseY = this.ScanHoldLabel.y;
         this.ScanHoldLabelBaseHeight = this.ScanHoldLabel.height;
         this.ScanButtonBaseBounds = this.ScanButtonHint.getBounds(this.ScanButtonHint);
         this.UpdateScanLabelPos();
      }
      
      private function get ScanButtonWarningText() : TextField
      {
         return this.HoldButton_mc.ErrorHoldButton_mc.WarningBG_mc.warningTextTF_mc.warningText_tf;
      }
      
      public function get isOpen() : Boolean
      {
         return this.IsOpen;
      }
      
      private function get ScanButtonEnabled() : Boolean
      {
         return this.ActiveScanButtonHintData.bEnabled;
      }
      
      private function set ScanButtonEnabled(param1:Boolean) : void
      {
         this.ScanHoldButtonHintData.bEnabled = this.ScanButtonHintData.bEnabled = param1;
         this.RefreshButtons();
      }
      
      private function set ScanButtonVisible(param1:Boolean) : void
      {
         this.ActiveScanButtonHintData.bVisible = param1;
         this.ActiveScanButtonHint.RefreshButtonData();
      }
      
      private function set ScanButtonText(param1:String) : void
      {
         this.ScanHoldButtonHintData.sButtonText = this.ScanButtonHintData.sButtonText = param1;
         this.RefreshButtons();
      }
      
      private function get ScanHoldButtonHint() : QuickHoldButton
      {
         return this.HoldButton_mc.HoldButtonHint_mc;
      }
      
      private function get ScanHoldLabel() : MovieClip
      {
         return this.HoldButton_mc.HoldButtonHint_mc.Label_mc;
      }
      
      private function get ScanButtonHint() : BasicButton
      {
         return this.HoldButton_mc.ButtonHint_mc;
      }
      
      private function get ScanLabel() : MovieClip
      {
         return this.HoldButton_mc.ButtonHint_mc.Label_mc;
      }
      
      private function get IsScanButtonInstant() : Boolean
      {
         return this.ScanButtonHintData.bVisible;
      }
      
      private function get ActiveScanButtonHint() : MovieClip
      {
         return this.IsScanButtonInstant ? this.ScanButtonHint : this.ScanHoldButtonHint;
      }
      
      private function get ActiveScanButtonHintData() : ButtonBaseData
      {
         return this.IsScanButtonInstant ? this.ScanButtonHintData : this.ScanHoldButtonHintData;
      }
      
      private function RefreshButtons() : void
      {
         this.ScanHoldButtonHint.RefreshButtonData();
         this.ScanButtonHint.RefreshButtonData();
         this.UpdateScanLabelPos();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.HoldButton_mc.DisabledScan_mc.visible = false;
         this.HoldButton_mc.NewData_mc.visible = false;
      }
      
      public function UpdateButton(param1:Boolean, param2:Boolean) : void
      {
         this.ScanButtonEnabled = param1;
         this.HoldButton_mc.DisabledScan_mc.visible = !param1;
         this.HoldButton_mc.NewData_mc.visible = param1 && param2;
         this.addEventListener(Event.RENDER,this.UpdateScanButtonPos);
      }
      
      public function Open() : *
      {
         if(!this.IsOpen)
         {
            this.IsOpen = true;
            this.ScanButtonEnabled = true;
            if(!this.Warning_mc.visible)
            {
               AddToInfoPanelArray(this.Header_mc);
               AddToInfoPanelArray(this.DoubleHeader_mc);
               AddToInfoPanelArray(this.HoldButton_mc);
            }
            else
            {
               AddToInfoPanelArray(this.Header_mc);
               AddToInfoPanelArray(this.Warning_mc);
            }
            addEventListener("OpenBackground",this.SetBackground);
            addEventListener("NextAnimation",PlayNextAnimation);
            gotoAndPlay("Open");
         }
         GlobalFunc.SetText(this.DoubleHeader_mc.Header_mc.text_tf,"");
         GlobalFunc.SetText(this.DoubleHeader_mc.SubHeader_mc.text_tf,"$TYPE");
         GlobalFunc.SetText(this.Warning_mc.Header_mc.text_tf,"");
         GlobalFunc.SetText(this.Warning_mc.SubHeader_mc.text_tf,"$SCAN DATA TYPE");
         GlobalFunc.SetText(this.Header_mc.Header_mc.text_tf,"$SURVEYOR");
      }
      
      private function SetBackground() : *
      {
         OpenBackgroundAnimation(this.Background_mc);
      }
      
      public function Close() : *
      {
         if(this.IsOpen)
         {
            this.IsOpen = false;
            gotoAndPlay("Close");
            this.ScanButtonEnabled = false;
            OnClose(this.Background_mc);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean;
         if(!(_loc4_ = this.ScanButtonHintData.bVisible && !param2 && !this.CanHandleRelease))
         {
            _loc3_ = Boolean(this.ActiveScanButtonHint.HandleUserEvent(param1,param2,false));
         }
         this.CanHandleRelease = this.ScanButtonHintData.bVisible && param2;
         return _loc3_;
      }
      
      public function ScanPlanetEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event(StarMapMenu_ScanPlanet,true));
      }
      
      public function set strTitleText(param1:String) : void
      {
         GlobalFunc.SetText(this.DoubleHeader_mc.Header_mc.text_tf,param1);
      }
      
      public function set strButtonHintText(param1:String) : *
      {
         this.ScanButtonText = param1;
      }
      
      public function set bCanHold(param1:Boolean) : void
      {
         var _loc2_:* = this.ScanHoldButtonHintData.bVisible;
         if(_loc2_ != param1)
         {
            this.ScanHoldButtonHintData.bVisible = param1;
            this.ScanButtonHintData.bVisible = !param1;
            this.RefreshButtons();
         }
      }
      
      public function ShowWarningMessage(param1:String) : void
      {
         this.HoldButton_mc.ErrorHoldButton_mc.visible = true;
         this.ScanButtonEnabled = false;
         GlobalFunc.SetText(this.ScanButtonWarningText,param1);
         this.ScanButtonVisible = !this.HoldButton_mc.ErrorHoldButton_mc.visible;
      }
      
      public function ShowErrorMessage(param1:String) : void
      {
         this.HoldButton_mc.ErrorHoldButton_mc.visible = true;
         this.ScanButtonEnabled = false;
         GlobalFunc.SetText(this.ScanButtonWarningText,param1);
         this.ScanButtonVisible = !this.HoldButton_mc.ErrorHoldButton_mc.visible;
      }
      
      public function ClearMessages() : void
      {
         this.HoldButton_mc.ErrorHoldButton_mc.visible = false;
         this.ScanButtonEnabled = true;
         this.ScanButtonVisible = !this.HoldButton_mc.ErrorHoldButton_mc.visible;
      }
      
      private function UpdateScanLabelPos() : void
      {
         var _loc1_:Number = 0;
         if(this.ScanButtonHint.visible == true)
         {
            if(this.ScanLabel.height > this.ScanLabelBaseHeight)
            {
               _loc1_ = (this.ScanLabel.height - this.ScanLabelBaseHeight) * 0.5;
            }
            this.ScanLabel.y = this.ScanLabelBaseY - _loc1_;
         }
         _loc1_ = 0;
         if(this.ScanHoldButtonHint.visible == true)
         {
            if(this.ScanHoldLabel.height > this.ScanHoldLabelBaseHeight)
            {
               _loc1_ = (this.ScanHoldLabel.height - this.ScanHoldLabelBaseHeight) * 0.5;
            }
            this.ScanHoldLabel.y = this.ScanHoldLabelBaseY - _loc1_;
         }
      }
      
      private function UpdateScanButtonPos() : void
      {
         this.removeEventListener(Event.RENDER,this.UpdateScanButtonPos);
         var _loc1_:* = this.ScanButtonBaseBounds.width + this.ScanButtonBaseBounds.x;
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.ScanButtonHint.PCButton_mc.x = _loc1_ - (this.ScanButtonHint.PCButton_mc.width + this.BUTTON_PADDING_PC);
            this.ScanButtonHint.Label_mc.x = this.ScanButtonHint.PCButton_mc.x;
            this.ScanHoldButtonHint.PCButton_mc.x = _loc1_ - (this.ScanHoldButtonHint.PCButton_mc.width + this.BUTTON_PADDING_PC);
            this.ScanHoldButtonHint.Label_mc.x = this.ScanHoldButtonHint.PCButton_mc.x;
         }
         else
         {
            this.ScanButtonHint.ConsoleButton_mc.x = _loc1_ - (this.ScanButtonHint.ConsoleButton_mc.width + this.BUTTON_PADDING_GAMEPAD);
            this.ScanButtonHint.Label_mc.x = this.ScanButtonHint.ConsoleButton_mc.x;
            this.ScanHoldButtonHint.ConsoleButton_mc.x = _loc1_ - (this.ScanHoldButtonHint.ConsoleButton_mc.width + this.BUTTON_PADDING_GAMEPAD);
            this.ScanHoldButtonHint.Label_mc.x = this.ScanHoldButtonHint.ConsoleButton_mc.x;
         }
         this.UpdateScanLabelPos();
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.addEventListener(Event.RENDER,this.UpdateScanButtonPos);
      }
   }
}
