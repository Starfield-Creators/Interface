package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class ShieldComponent extends MovieClip
   {
      
      private static const SHIP_HEALTH_EMPTY_FRAME:uint = 100;
      
      private static const SHIP_HEALTH_FULL_FRAME:uint = 1;
      
      private static const SHIELD_EMPTY_FRAME:uint = 1;
      
      private static const SHIELD_FULL_FRAME:uint = 100;
      
      private static const SHIELD_HIT_RADIUS:Number = 95;
      
      private static const EDGE_HIT_CUTOFF:Number = 0.08;
      
      private static const HIT_SCALE_AT_EDGE:Number = 0.45;
      
      private static const ShipHud_Repair:String = "ShipHud_Repair";
      
      private static const BUTTON_MARGIN:Number = 9;
       
      
      public var INTMeter_mc:MovieClip;
      
      public var ShieldHealth_mc:MovieClip;
      
      public var ShieldWave_mc:ShieldWaveManager;
      
      public var ShipOutline_mc:MovieClip;
      
      public var ShipRepairButton_mc:MovieClip;
      
      public var HullLabel_mc:MovieClip;
      
      public var ComponentStatus1_mc:MovieClip;
      
      public var ComponentStatus2_mc:MovieClip;
      
      public var ComponentStatus3_mc:MovieClip;
      
      public var ComponentStatus4_mc:MovieClip;
      
      public var ComponentStatus5_mc:MovieClip;
      
      public var ComponentStatus6_mc:MovieClip;
      
      public var ComponentStatus7_mc:MovieClip;
      
      private var HullWrapper:MovieClip;
      
      private var ShieldMaxPower:uint = 0;
      
      private var ShieldMaxHealth:Number;
      
      private var ShieldCurrentHealth:Number;
      
      private var ShipRepairButtonData:ButtonBaseData;
      
      private var RepairBaseText:String;
      
      private var RepairButtonTextField:TextField;
      
      private var LastRepairCount:uint = 4294967295;
      
      private var DisplayRepairCount:Boolean = true;
      
      private const MAX_DISPLAYED_COUNT:uint = 99;
      
      private const MAX_DISPLAYED_COUNT_STRING:String = "99+";
      
      public function ShieldComponent()
      {
         this.ShipRepairButtonData = new ButtonBaseData("$Repair",new UserEventData("RepairShip",this.onShipRepair),false,false);
         super();
         this.ShipRepairButton.justification = IButtonUtils.ICON_FIRST;
         this.ShipRepairButton.SetButtonData(this.ShipRepairButtonData);
         this.RepairButtonTextField = this.ShipRepairButton.Label_mc.LabelInstance_mc.Label_tf;
         this.RepairBaseText = this.RepairButtonTextField.text;
         this.ShipRepairButton.x = BUTTON_MARGIN - this.ShipRepairButton.getBounds(this.ShipRepairButton_mc).left;
         this.HullWrapper = this.HullLabel_mc.Wrapper_mc;
         this.UpdateRepairText(0,false);
      }
      
      public function get ShipRepairButton() : ButtonBase
      {
         return this.ShipRepairButton_mc.Button_mc;
      }
      
      public function UpdateShieldHealth(param1:Object) : *
      {
         if(this.ShieldWave_mc.visible == true && this.ShieldWave_mc.alpha == 100)
         {
            this.ShieldWave_mc.rotation = -param1.shieldFocusAngle * 180 / Math.PI + 90;
         }
         this.ShieldMaxHealth = param1.shieldMaxHealth;
         this.ShieldCurrentHealth = param1.shieldHealth;
         if(this.ShieldMaxHealth == 0)
         {
            this.ShieldMaxHealth = 1;
         }
         this.ShieldHealth_mc.ShieldHealth_tf.text = GlobalFunc.FormatNumberToString(int(this.ShieldCurrentHealth / this.ShieldMaxHealth * 100));
         var _loc2_:Number = GlobalFunc.MapLinearlyToRange(SHIP_HEALTH_EMPTY_FRAME,SHIP_HEALTH_FULL_FRAME,0,1,param1.shipHealth,true);
         this.INTMeter_mc.gotoAndStop(Math.round(_loc2_));
         this.UpdateShieldWaves();
         this.UpdateRepairText(param1.bShowRepairKitCount,param1.bShowRepairKitCount);
      }
      
      public function UpdateShieldPower(param1:Object) : *
      {
         this.ShieldMaxPower = param1.componentMaxPower;
         this.UpdateShieldWaves();
      }
      
      public function UpdateShieldWaves() : *
      {
         var _loc1_:Number = GlobalFunc.MapLinearlyToRange(0,1,0,this.ShieldMaxHealth,this.ShieldCurrentHealth,true);
         this.ShieldWave_mc.SetPower(this.ShieldMaxPower,_loc1_);
      }
      
      public function InitiateFarTravel() : *
      {
         gotoAndPlay("FarTravelUp");
      }
      
      public function CompleteFarTravel() : *
      {
         gotoAndPlay("FarTravelDown");
      }
      
      private function onShipRepair() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipHud_Repair));
      }
      
      private function UpdateRepairText(param1:uint, param2:Boolean) : *
      {
         if(this.LastRepairCount != param1 || this.DisplayRepairCount != param2)
         {
            if(param2)
            {
               this.RepairButtonTextField.text = this.RepairBaseText + "(" + (param1 > this.MAX_DISPLAYED_COUNT ? this.MAX_DISPLAYED_COUNT_STRING : param1) + ")";
            }
            else
            {
               this.RepairButtonTextField.text = this.RepairBaseText;
            }
            this.LastRepairCount = param1;
            this.DisplayRepairCount = param2;
         }
      }
   }
}
