package
{
   import Components.ModularPanelObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.BSGalaxyTypes;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.HoldButton;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   public class JumpDataPanel extends ModularPanelObject
   {
      
      private static const METER_PRECISION:uint = 3;
      
      private static const FULL_SIZE_EXECUTE_BUTTON_Y:int = 616;
      
      private static const FULL_SIZE_EXECUTE_BUTTON_Y_LRG:int = 670;
      
      private static const MINI_SIZE_EXECUTE_BUTTON_Y:int = 694;
      
      private static const MINI_SIZE_EXECUTE_BUTTON_Y_LRG:int = 775;
      
      private static const StarMapMenu_ExecuteRoute:String = "StarMapMenu_ExecuteRoute";
      
      private static const JUMP_BUTTON_CAN_HOLD:Boolean = true;
      
      private static const JUMP_BUTTON_HAS_PRESS_CALLBACK:Boolean = false;
      
      private static const JUMP_BUTTON_RETURN_TO_IDLE:Boolean = false;
      
      private static const JUMP_BUTTON_JUSTIFY_HOLD_METER:Boolean = false;
      
      public static const JumpPanelShowEvent_MAIN:String = "JumpPanelShowEvent_MAIN";
      
      public static const JumpPanelShowEvent_MINI:String = "JumpPanelShowEvent_MINI";
      
      public static const JumpPanelHideEvent:String = "JumpPanelHideEvent";
       
      
      public var PlotPointDisplayStart_mc:PlotPointDisplay;
      
      public var PlotPointDisplayEnd_mc:PlotPointDisplay;
      
      public var BodyLine_mc:MovieClip;
      
      public var SmallBodyLine_mc:MovieClip;
      
      public var RouteInfoDisplay_mc:RouteInfoDisplay;
      
      public var Header_mc:MovieClip;
      
      public var PlotBorder_mc:MovieClip;
      
      public var JumpDataList_mc:MovieClip;
      
      public var CargoMeter_mc:MovieClip;
      
      public var FuelMeter_mc:MovieClip;
      
      public var ExecuteButton_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var Header_Mini_mc:MovieClip;
      
      public var Background_Mini_mc:MovieClip;
      
      public var Destination_Mini_mc:PlotPointDisplay;
      
      private var TextAlignLeft:TextFormat;
      
      private var TextAlignRight:TextFormat;
      
      private var ExecuteButtonHintData:ButtonBaseData;
      
      private var IsJumpDataShown:Boolean = false;
      
      private var DisplayedPlotPoints:Number = 0;
      
      private var WarningTextBaseY:Number = 0;
      
      private var ExecuteButtonBaseX:Number = 0;
      
      private var ExecuteButtonBaseBounds:Object;
      
      private var ButtonPadding_PC:Number = 20;
      
      private var ButtonPadding_GamePad:Number = 10;
      
      public function JumpDataPanel()
      {
         this.TextAlignLeft = new TextFormat();
         this.TextAlignRight = new TextFormat();
         this.ExecuteButtonHintData = new ButtonBaseData("$EXECUTE",[new UserEventData("ExecuteJump",this.SendExecuteEvent)]);
         super();
         this.ExecuteButtonHint.SetButtonData(this.ExecuteButtonHintData);
         this.TextAlignLeft.align = "left";
         this.TextAlignRight.align = "right";
         GlobalFunc.SetText(this.Header_mc.Header_mc.text_tf,"$TRAVEL DATA");
         GlobalFunc.SetText(this.Header_Mini_mc.Header_mc.text_tf,"$DESTINATION");
         GlobalFunc.SetText(this.JumpDataList_mc.Data1_mc.Name_mc.text_tf,"$JUMPS");
         GlobalFunc.SetText(this.JumpDataList_mc.Data2_mc.Name_mc.text_tf,"$JUMP RANGE");
         GlobalFunc.SetText(this.JumpDataList_mc.Data3_mc.Name_mc.text_tf,"$DISTANCE");
         GlobalFunc.SetText(this.CargoMeter_mc.Name_mc.text_tf,"$CARGO HOLD");
         GlobalFunc.SetText(this.FuelMeter_mc.Name_mc.text_tf,"$FUEL CONSUMPTION");
         this.ExecuteButtonBaseX = this.ExecuteButtonHint.x;
         this.ExecuteButtonBaseBounds = this.ExecuteButtonHint.getBounds(this.ExecuteButtonHint);
         this.Background_Mini_mc.visible = false;
         this.Header_Mini_mc.visible = false;
         this.Destination_Mini_mc.visible = false;
         this.HideBodyDisplays();
         this.WarningTextBaseY = this.ExecuteButton_mc.Warning_mc.WarningBG_mc.warningTextTF_mc.warningText_tf.y;
      }
      
      private function get FullSizeExecuteButtonY() : int
      {
         return FULL_SIZE_EXECUTE_BUTTON_Y;
      }
      
      private function get MiniSizeExecuteButtonY() : int
      {
         return MINI_SIZE_EXECUTE_BUTTON_Y;
      }
      
      private function get ExecuteButtonHint() : HoldButton
      {
         return this.ExecuteButton_mc.ExecuteButtonHint_mc;
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.addEventListener(Event.RENDER,this.AlignExecuteButtonContents);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(!this.IsJumpDataShown)
         {
            return false;
         }
         var _loc3_:Boolean = false;
         if(this.ExecuteButtonHint.Visible)
         {
            _loc3_ = this.ExecuteButtonHint.HandleUserEvent(param1,param2,false);
         }
         return _loc3_;
      }
      
      private function UpdateResourceDeltaInfo(param1:MovieClip, param2:uint, param3:uint, param4:Number) : *
      {
         GlobalFunc.SetText(param1.Title_mc.title_tf,BSGalaxyTypes.GetScarcityLabel(param2));
         GlobalFunc.SetText(param1.Count_mc.data_tf,GlobalFunc.FormatNumberToString(param3));
         GlobalFunc.SetText(param1.Weight_mc.data_tf,GlobalFunc.FormatNumberToString(param4,1));
      }
      
      private function SetBackground() : *
      {
         OpenBackgroundAnimation(this.Background_mc);
      }
      
      private function UpdateBarInfo(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:String, param6:uint = 0) : *
      {
         if(param2 == 0)
         {
            param2 = 9999;
         }
         GlobalFunc.SetText(param1.Data_mc.text_tf,param5);
         GlobalFunc.SetText(param1.MeterAmount_mc.amount_tf,GlobalFunc.FormatNumberToString(param4,param6));
         var _loc7_:Number = Math.min(1,param4 / param3);
         var _loc8_:Number = Math.min(1,param3 / param2);
         var _loc9_:Number = param1.background_mc.width * _loc8_;
         var _loc10_:Number = _loc7_ * (param1.background_mc.width * _loc8_);
         eaze(param1.currentValue_mc).delay(0.1).easing(Quadratic.easeOut).apply({"width":param1.currentValue_mc.width}).to(1,{"width":_loc9_});
         eaze(param1.consumeValue_mc).delay(0.1).easing(Quadratic.easeOut).apply({"width":param1.consumeValue_mc.width}).to(1,{"width":_loc10_});
         if(_loc10_ > param1.MeterAmount_mc.amount_tf.textWidth)
         {
            param1.MeterAmount_mc.amount_tf.setTextFormat(this.TextAlignRight);
            eaze(param1.MeterAmount_mc).delay(0.1).easing(Quadratic.easeOut).apply({"alpha":param1.MeterAmount_mc.alpha}).to(0.1,{"alpha":1}).apply({"visible":param1.MeterAmount_mc.visible}).to(0.1,{"visible":param4 > 0}).apply({"x":param1.MeterAmount_mc.x}).to(1,{"x":_loc10_ + param1.MeterAmount_mc.width / 2});
         }
         else
         {
            param1.MeterAmount_mc.amount_tf.setTextFormat(this.TextAlignLeft);
            eaze(param1.MeterAmount_mc).delay(0.1).easing(Quadratic.easeOut).apply({"alpha":param1.MeterAmount_mc.alpha}).to(0.1,{"alpha":1}).apply({"visible":param1.MeterAmount_mc.visible}).to(0.1,{"visible":param4 > 0}).apply({"x":param1.MeterAmount_mc.x}).to(1,{"x":param1.background_mc.x + param1.MeterAmount_mc.width});
         }
      }
      
      private function UpdateFuelBarInfo(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint = 0) : *
      {
         this.UpdateBarInfo(param1,param2,param3,param4,GlobalFunc.FormatNumberToString(param2,param6),param6);
         if(param5 > 0)
         {
            param1.FuelGained_mc.visible = true;
            GlobalFunc.SetText(param1.FuelGained_mc.text_tf,"+" + GlobalFunc.FormatNumberToString(param5,param6));
            param1.Data_mc.x = param1.FuelGained_mc.x - param1.FuelGained_mc.text_tf.textWidth;
         }
         else
         {
            param1.FuelGained_mc.visible = false;
            param1.Data_mc.x = param1.FuelGained_mc.x;
         }
      }
      
      public function SendExecuteEvent() : void
      {
         if(this.ExecuteButtonHint.Visible)
         {
            BSUIDataManager.dispatchEvent(new Event(StarMapMenu_ExecuteRoute,true));
         }
      }
      
      private function HideBodyDisplays() : *
      {
         this.PlotPointDisplayStart_mc.visible = false;
         this.PlotPointDisplayEnd_mc.visible = false;
         this.RouteInfoDisplay_mc.visible = false;
         this.BodyLine_mc.visible = false;
         this.SmallBodyLine_mc.visible = false;
         this.visible = false;
      }
      
      private function UpdateData(param1:Object) : *
      {
         TextFieldEx.setTextAutoSize(this.ExecuteButton_mc.Warning_mc.WarningBG_mc.warningTextTF_mc.warningText_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.PlotPointDisplayStart_mc.SetText(param1.sOriginSystemName,param1.sOriginBodyName);
         this.PlotPointDisplayEnd_mc.SetText(param1.sDestinationSystemName,param1.sDestinationBodyName);
         this.Destination_Mini_mc.SetText(param1.sDestinationSystemName,param1.sDestinationBodyName);
         GlobalFunc.SetText(this.ExecuteButton_mc.Warning_mc.WarningBG_mc.warningTextTF_mc.warningText_tf,param1.sWarningText);
         var _loc2_:Number = Number(this.ExecuteButton_mc.Warning_mc.WarningBG_mc.warningTextTF_mc.warningText_tf.height);
         var _loc3_:Number = Number(this.ExecuteButton_mc.Warning_mc.WarningBG_mc.warningTextTF_mc.warningText_tf.textHeight);
         this.ExecuteButton_mc.Warning_mc.WarningBG_mc.warningTextTF_mc.warningText_tf.y = this.WarningTextBaseY - Math.round((_loc2_ - _loc3_) / 2) + 1;
         var _loc4_:uint = uint(param1.iPlotRouteSize);
         GlobalFunc.SetText(this.JumpDataList_mc.Data1_mc.Info_mc.text_tf,_loc4_.toString());
         GlobalFunc.SetText(this.JumpDataList_mc.Data2_mc.Info_mc.text_tf,param1.fMaxJumpDistance + "$$LY");
         GlobalFunc.SetText(this.JumpDataList_mc.Data3_mc.Info_mc.text_tf,param1.sRouteDistance);
         var _loc5_:String = GlobalFunc.FormatNumberToString(param1.fCargoCurrentWeight) + "/" + GlobalFunc.FormatNumberToString(param1.fCargoMaxWeight);
         this.UpdateFuelBarInfo(this.FuelMeter_mc,param1.fMaxJumpFuel,param1.fCurrentJumpFuel,param1.fFuelUse,param1.fFuelGained,METER_PRECISION);
         this.UpdateBarInfo(this.CargoMeter_mc,param1.fCargoMaxWeight,param1.fCargoCurrentWeight,param1.fCargoDeltaWeight,_loc5_);
         this.UpdateExecuteButton(param1.sButtonText);
         this.addEventListener(Event.RENDER,this.AlignExecuteButtonContents);
      }
      
      private function ShowJumpData(param1:Boolean, param2:Boolean) : void
      {
         if(!this.visible)
         {
            this.ExecuteButtonHint.Visible = param1;
            this.ExecuteButton_mc.Warning_mc.WarningBG_mc.gotoAndPlay("Active");
            this.ExecuteButton_mc.Warning_mc.visible = !param1;
            this.IsJumpDataShown = true;
            this.visible = true;
            this.PlotPointDisplayStart_mc.visible = true;
            this.PlotPointDisplayEnd_mc.visible = true;
            this.BodyLine_mc.visible = true;
            this.BodyLine_mc.gotoAndPlay("Play");
            AddToInfoPanelArray(this.Header_mc);
            AddToInfoPanelArray(this.PlotBorder_mc);
            AddToInfoPanelArray(this.JumpDataList_mc);
            AddToInfoPanelArray(this.CargoMeter_mc);
            AddToInfoPanelArray(this.FuelMeter_mc);
            AddToInfoPanelArray(this.ExecuteButton_mc);
            addEventListener("OpenBackground",this.SetBackground);
            addEventListener("NextAnimation",PlayNextAnimation);
            gotoAndPlay("Open");
         }
         this.ExecuteButtonHint.CancelHold();
         this.ExecuteButtonHint.Visible = param1;
         this.ExecuteButton_mc.Warning_mc.visible = !param1;
         if(param2)
         {
            dispatchEvent(new Event(JumpPanelShowEvent_MINI));
         }
         else
         {
            dispatchEvent(new Event(JumpPanelShowEvent_MAIN));
         }
      }
      
      public function HideJumpData() : void
      {
         if(this.IsJumpDataShown)
         {
            this.HideBodyDisplays();
            this.IsJumpDataShown = false;
            this.DisplayedPlotPoints = 0;
            gotoAndPlay("Close");
            OnClose(this.Background_mc);
         }
         else
         {
            this.visible = false;
         }
         dispatchEvent(new Event(JumpPanelHideEvent));
      }
      
      public function SetPlotPointData(param1:Object) : void
      {
         this.ShowJumpData(param1.bCanExecuteRoute,param1.bShowMiniPanel);
         var _loc2_:Number = Number(param1.iPlotRouteSize);
         var _loc3_:Number = 0;
         if(this.DisplayedPlotPoints != _loc2_)
         {
            if(_loc2_ > 0)
            {
               if(this.DisplayedPlotPoints < _loc2_)
               {
                  if(_loc2_ > 1)
                  {
                     _loc3_ = _loc2_ - 1;
                     if(!this.RouteInfoDisplay_mc.visible)
                     {
                        this.RouteInfoDisplay_mc.visible = true;
                        this.BodyLine_mc.visible = false;
                        this.SmallBodyLine_mc.visible = true;
                        this.SmallBodyLine_mc.gotoAndPlay("Play");
                     }
                     this.RouteInfoDisplay_mc.Update(_loc3_);
                  }
               }
               else if(_loc2_ == 1)
               {
                  this.RouteInfoDisplay_mc.visible = false;
                  this.SmallBodyLine_mc.visible = false;
                  this.BodyLine_mc.visible = true;
                  this.BodyLine_mc.gotoAndPlay("Play");
               }
               else
               {
                  _loc3_ = _loc2_ - 1;
                  this.RouteInfoDisplay_mc.Update(_loc3_);
               }
            }
            this.DisplayedPlotPoints = _loc2_;
         }
         this.UpdateData(param1);
         this.UpdateMiniPanel(param1);
      }
      
      public function UpdateExecuteButton(param1:String) : void
      {
         this.ExecuteButtonHintData.sButtonText = param1;
         this.ExecuteButtonHintData.bVisible = this.ExecuteButtonHint.Visible;
         this.ExecuteButtonHint.RefreshButtonData();
      }
      
      public function UpdateMiniPanel(param1:Object) : void
      {
         var _loc2_:* = param1.bShowMiniPanel;
         this.SmallBodyLine_mc.visible = !_loc2_;
         this.PlotPointDisplayStart_mc.visible = !_loc2_;
         this.PlotPointDisplayEnd_mc.visible = !_loc2_;
         this.CargoMeter_mc.visible = !_loc2_;
         this.FuelMeter_mc.visible = !_loc2_;
         this.Header_mc.visible = !_loc2_;
         this.PlotBorder_mc.visible = !_loc2_;
         this.JumpDataList_mc.visible = !_loc2_;
         this.Background_mc.visible = !_loc2_;
         this.BodyLine_mc.visible = !_loc2_ && this.DisplayedPlotPoints == 1;
         this.RouteInfoDisplay_mc.visible = !_loc2_ && this.DisplayedPlotPoints > 1;
         this.Background_Mini_mc.visible = _loc2_;
         this.Header_Mini_mc.visible = _loc2_;
         this.Destination_Mini_mc.visible = _loc2_;
         this.ExecuteButton_mc.y = !!_loc2_ ? this.MiniSizeExecuteButtonY : this.FullSizeExecuteButtonY;
         this.ExecuteButton_mc.visible = true;
         if(this.ExecuteButton_mc.currentLabel != "Open_End")
         {
            this.ExecuteButton_mc.gotoAndPlay("Open");
         }
         if(_loc2_ && this.Header_Mini_mc.currentLabel != "Open_End")
         {
            this.Header_Mini_mc.gotoAndPlay("Open");
         }
      }
      
      private function AlignExecuteButtonContents() : *
      {
         this.removeEventListener(Event.RENDER,this.AlignExecuteButtonContents);
         var _loc1_:* = this.ExecuteButtonBaseBounds.width + this.ExecuteButtonBaseBounds.x;
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.ExecuteButtonHint.PCButton_mc.x = _loc1_ - (this.ExecuteButtonHint.PCButton_mc.width + this.ButtonPadding_PC);
            this.ExecuteButtonHint.Label_mc.x = this.ExecuteButtonHint.PCButton_mc.x;
         }
         else
         {
            this.ExecuteButtonHint.ConsoleButton_mc.x = _loc1_ - (this.ExecuteButtonHint.ConsoleButton_mc.width + this.ButtonPadding_GamePad);
            this.ExecuteButtonHint.Label_mc.x = this.ExecuteButtonHint.ConsoleButton_mc.x;
         }
      }
   }
}
