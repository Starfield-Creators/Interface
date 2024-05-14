package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import Shared.TextUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class PersistentContent extends BSDisplayObject
   {
      
      public static const CREDIT_BALANCE_NUMBER_OF_DIGITS:int = 10;
       
      
      public var TopFaderHalf_mc:MovieClip;
      
      public var BottomFaderHalf_mc:MovieClip;
      
      public var FullFade_mc:MovieClip;
      
      public var BGLineAnim_mc:MovieClip;
      
      public var BBLineAnim_mc:MovieClip;
      
      public var NameLabel_mc:MovieClip;
      
      public var SubtextLabel_mc:MovieClip;
      
      public var LevelDisplay_mc:LabeledMeterMC;
      
      public var Points_mc:MovieClip;
      
      public var Credits_mc:MovieClip;
      
      public var PointsTitle_mc:MovieClip;
      
      public var CreditsTitle_mc:MovieClip;
      
      public var FactionIcon_mc:MovieClip;
      
      public var LevelIcon_mc:MovieClip;
      
      public var CapacityDisplay_mc:LabeledMeterMC;
      
      public var HPDisplay_mc:LabeledMeterMC;
      
      public var RepairModules_mc:MovieClip;
      
      public var SharedComponentsButtonBar_mc:ButtonBar;
      
      public var SpendingCredits_mc:MovieClip;
      
      public var SpendingCreditsTitle_mc:MovieClip;
      
      public var VendorCreditsTitle_mc:MovieClip;
      
      public var VendorCredits_mc:MovieClip;
      
      public function PersistentContent()
      {
         super();
         this.CapacityDisplay_mc.SetMode(LabeledMeterMC.MODE_WEIGHT);
         this.CapacityDisplay_mc.SetColorConfig(LabeledMeterColorConfig.CONFIG_DEFAULT_WEIGHT);
         this.CapacityDisplay_mc.SetLabel("$CARRYWT");
         this.HPDisplay_mc.SetLabel("$HP");
         TextFieldEx.setTextAutoSize(this.PlayerNameText,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.SubtextText,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.SharedComponentsButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         (this.SharedComponentsButtonBar_mc as MovieClip).MenuButton_mc.SetButtonData(new ButtonBaseData("$MENU",new UserEventData("Pause",null,"")));
         this.SharedComponentsButtonBar_mc.AddButton((this.SharedComponentsButtonBar_mc as MovieClip).MenuButton_mc);
         this.SharedComponentsButtonBar_mc.RefreshButtons();
         this.SpendingCredits_mc.DeltaTextValue_mc.InvertComparison = true;
      }
      
      private function get PlayerNameText() : TextField
      {
         return this.NameLabel_mc.Label_tf;
      }
      
      private function get SubtextText() : TextField
      {
         return this.SubtextLabel_mc.Label_tf;
      }
      
      private function get CreditsText() : TextField
      {
         return this.Credits_mc.Label_tf;
      }
      
      override public function onAddedToStage() : void
      {
         BSUIDataManager.Subscribe("GraphicsInfoData",function(param1:FromClientDataEvent):*
         {
            TopFaderHalf_mc.Internal_mc.width = stage.stageWidth;
            BottomFaderHalf_mc.Internal_mc.width = stage.stageWidth;
            FullFade_mc.Internal_mc.width = stage.stageWidth;
            BGLineAnim_mc.Internal_mc.width = stage.stageWidth;
            BBLineAnim_mc.Internal_mc.x += Extensions.visibleRect.x;
            BBLineAnim_mc.Internal_mc.width += -Extensions.visibleRect.x * 2;
         });
      }
      
      public function UpdatePlayerData(param1:Object) : void
      {
         GlobalFunc.SetText(this.PlayerNameText,param1.sName);
         this.LevelDisplay_mc.SetLabel("$$LEVEL " + param1.uLevel);
         this.LevelDisplay_mc.SetMaxValue(param1.fNextLevelXP);
         this.LevelDisplay_mc.SetCurrentValue(param1.fLevelXP);
         this.LevelIcon_mc.Initialize(param1.uLevel,true);
         this.FactionIcon_mc.visible = false;
         var _loc2_:String = TextUtils.TruncateNumericText(param1.uCredits,CREDIT_BALANCE_NUMBER_OF_DIGITS);
         GlobalFunc.SetText(this.CreditsText,_loc2_);
         var _loc3_:String = TextUtils.TruncateNumericText(param1.uSkillPoints,6);
         GlobalFunc.SetText(this.Points_mc.NumberTextAnim_mc.Label_tf,_loc3_);
         if(param1.uSkillPoints > 0)
         {
            this.Points_mc.gotoAndPlay(2);
         }
         this.CapacityDisplay_mc.SetCurrentValue(Math.round(param1.fEncumbrance));
         this.CapacityDisplay_mc.SetMaxValue(Math.round(param1.fMaxEncumbrance));
         this.CapacityDisplay_mc.SetSuffix(" $KG");
      }
      
      public function UpdateFreqPlayerData(param1:Object) : void
      {
         this.HPDisplay_mc.SetCurrentValue(Math.round(param1.fHealth));
         this.HPDisplay_mc.SetMaxValue(Math.round(param1.fMaxHealth));
      }
      
      public function SetViewingConsumables(param1:Boolean) : void
      {
         this.HPDisplay_mc.visible = param1;
         this.CapacityDisplay_mc.visible = !param1;
      }
      
      public function UpdateLocationData(param1:String, param2:String) : void
      {
         var _loc3_:String = param1 + ", " + param2;
         GlobalFunc.SetText(this.SubtextText,_loc3_);
      }
      
      public function UpdateShipData(param1:Object) : void
      {
         GlobalFunc.SetText(this.RepairModules_mc.Count_mc.text_tf,param1.uiNumRepairModules);
      }
      
      public function UpdateBarterData(param1:Object) : void
      {
         GlobalFunc.SetText(this.PlayerNameText,param1.sName);
         this.LevelDisplay_mc.SetLabel("$CARRYWT");
         this.LevelDisplay_mc.SetMaxValue(param1.fMaxCarryWeight);
         this.LevelDisplay_mc.SetCurrentValue(param1.fCurrentEncumberance,param1.fWeightDelta);
         var _loc2_:String = TextUtils.TruncateNumericText(param1.uCredits,CREDIT_BALANCE_NUMBER_OF_DIGITS);
         GlobalFunc.SetText(this.CreditsText,_loc2_);
         this.SpendingCredits_mc.DeltaTextValue_mc.Update(Math.abs(param1.iTransactionCost),param1.iTransactionCost,0,"+",true,6);
         GlobalFunc.SetText(this.SubtextText,"");
         GlobalFunc.SetText(this.SpendingCreditsTitle_mc.Label_tf,"$SPENDING");
      }
      
      public function UpdateVendorData(param1:Object) : void
      {
         GlobalFunc.SetText(this.VendorCreditsTitle_mc.Label_tf,param1.name);
         this.VendorCredits_mc.DeltaTextValue_mc.Update(param1.credits,0,0,"+",true,6);
      }
      
      public function ShowMenuButton(param1:Boolean) : void
      {
         (this.SharedComponentsButtonBar_mc as MovieClip).MenuButton_mc.Visible = param1;
      }
      
      public function Close() : void
      {
         gotoAndPlay("Close");
      }
   }
}
