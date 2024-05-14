package
{
   import Components.LabeledMeterMC;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipInfoCard extends BSDisplayObject
   {
      
      private static const CREDITS_NORMAL:String = "Normal";
      
      private static const REACTOR_CLASS_M:* = EnumHelper.GetEnum(0);
      
      private static const REACTOR_CLASS_C:* = EnumHelper.GetEnum();
      
      private static const REACTOR_CLASS_B:* = EnumHelper.GetEnum();
      
      private static const REACTOR_CLASS_A:* = EnumHelper.GetEnum();
      
      private static const NUM_WEAPON_GROUPS:uint = 3;
      
      private static const LABELMETER_LENGTH:uint = 11;
      
      private static const STATLABEL_LENGTH:uint = 8;
       
      
      public var bgClip:*;
      
      public var bgClip2:*;
      
      public var FuelBar_mc:LabeledMeterMC;
      
      public var HullBar_mc:LabeledMeterMC;
      
      public var CargoBar_mc:LabeledMeterMC;
      
      public var StatReactor_mc:ShipStat;
      
      public var StatCrew_mc:ShipStat;
      
      public var StatJumpRange_mc:ShipStat;
      
      public var StatShield_mc:ShipStat;
      
      public var ShipValue_mc:ShipValue;
      
      public var ShipMass_mc:ShipMass;
      
      public var StatWeapons_mc:ShipStatWeapons;
      
      public var Registration_mc:MovieClip;
      
      public var NoShipAvailable_mc:MovieClip;
      
      public var ShieldedCargo_mc:MovieClip;
      
      public function ShipInfoCard()
      {
         super();
      }
      
      private function get ShouldTruncateText() : Boolean
      {
         return false;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ShipStatsData",this.onShipStatsDataUpdate);
         BSUIDataManager.Subscribe("ShipHangarModuleInfoData",this.onSystemStatsUpdate);
      }
      
      private function onSystemStatsUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         this.visible = !_loc2_.bShowWidget;
      }
      
      private function onShipStatsDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:* = false;
         var _loc2_:Object = param1.data;
         var _loc3_:Boolean = Boolean(_loc2_.bShowNoShip);
         gotoAndStop(_loc3_ ? "NoShip" : "ShipOverview");
         if(!_loc3_)
         {
            this.FuelBar_mc.SetLabel("$FUEL");
            this.TruncateTextCharLength(this.FuelBar_mc.NameLabel_tf,LABELMETER_LENGTH);
            this.FuelBar_mc.SetCurrentValue(_loc2_.iFuel);
            this.FuelBar_mc.SetMaxValue(_loc2_.iMaxFuel);
            this.FuelBar_mc.Current_tf.visible = false;
            this.SetHullBarInfo(_loc2_);
            this.CargoBar_mc.SetCurrentValue(!!_loc2_.bIsHomeShip ? Number(_loc2_.iCargo) : Number(_loc2_.iMaxCargo));
            this.CargoBar_mc.SetMaxValue(_loc2_.iMaxCargo);
            if(!_loc2_.bIsHomeShip)
            {
               this.CargoBar_mc.SetLabel("$CARGO CAPACITY");
               this.CargoBar_mc.SetMode(LabeledMeterMC.MODE_DEFAULT);
            }
            else
            {
               this.CargoBar_mc.SetLabel("$CARGO");
               this.CargoBar_mc.SetMode(LabeledMeterMC.MODE_WEIGHT);
            }
            this.TruncateTextCharLength(this.CargoBar_mc.NameLabel_tf,LABELMETER_LENGTH);
            this.CargoBar_mc.Current_tf.visible = false;
            GlobalFunc.SetText(this.ShieldedCargo_mc.Value_tf,"$shieldedcapacity");
            this.ShieldedCargo_mc.Value_tf.text += " " + _loc2_.iShieldedCargo;
            this.StatReactor_mc.SetTitle("$REACTOR");
            this.TruncateTextCharLength(this.StatReactor_mc.Title_mc.text_tf,STATLABEL_LENGTH);
            this.StatReactor_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iReactorPower),_loc2_.iReactorPowerDiff);
            if(_loc2_.iPowerClass === REACTOR_CLASS_A)
            {
               this.StatReactor_mc.SetStatType(ShipStatBase.STAT_TYPE_REACTOR_A);
            }
            else if(_loc2_.iPowerClass === REACTOR_CLASS_B)
            {
               this.StatReactor_mc.SetStatType(ShipStatBase.STAT_TYPE_REACTOR_B);
            }
            else if(_loc2_.iPowerClass === REACTOR_CLASS_C)
            {
               this.StatReactor_mc.SetStatType(ShipStatBase.STAT_TYPE_REACTOR_C);
            }
            else if(_loc2_.iPowerClass === REACTOR_CLASS_M)
            {
               this.StatReactor_mc.SetStatType(ShipStatBase.STAT_TYPE_REACTOR_M);
            }
            this.StatCrew_mc.SetTitle("$CREW");
            this.TruncateTextCharLength(this.StatCrew_mc.Title_mc.text_tf,STATLABEL_LENGTH);
            this.StatCrew_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iCrew),_loc2_.iCrewDiff);
            this.StatCrew_mc.SetStatType(ShipStatBase.STAT_TYPE_CREW);
            this.StatJumpRange_mc.SetTitle("$JUMP RANGE");
            this.TruncateTextCharLength(this.StatJumpRange_mc.Title_mc.text_tf,STATLABEL_LENGTH);
            this.StatJumpRange_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iJumpRange) + " LY",_loc2_.iJumpRangeDiff);
            this.StatJumpRange_mc.SetStatType(ShipStatBase.STAT_TYPE_JUMP_RANGE);
            this.StatShield_mc.SetTitle("$SHIELD");
            this.TruncateTextCharLength(this.StatShield_mc.Title_mc.text_tf,STATLABEL_LENGTH);
            this.StatShield_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iShield),_loc2_.iShieldDiff);
            this.StatShield_mc.SetStatType(ShipStatBase.STAT_TYPE_SHIELD);
            _loc4_ = 0;
            while(_loc4_ < NUM_WEAPON_GROUPS)
            {
               if(_loc5_ = _loc2_.aWeaponGroupNames[_loc4_] != "")
               {
                  this.StatWeapons_mc.SetTitle(_loc2_.aWeaponGroupNames[_loc4_],_loc4_);
                  this.StatWeapons_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.aWeaponGroupsDPS[_loc4_]),_loc2_.aWeaponGroupsDPSDiff[_loc4_],_loc4_);
               }
               else
               {
                  this.StatWeapons_mc.SetTitle("",_loc4_);
                  this.StatWeapons_mc.SetValue("",0,_loc4_);
               }
               _loc4_++;
            }
            this.ShipValue_mc.SetTitle("$VALUE");
            this.ShipValue_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iValue));
            this.ShipMass_mc.SetTitle("$MASS");
            this.ShipMass_mc.SetValue(GlobalFunc.FormatNumberToString(_loc2_.iMass));
            GlobalFunc.SetText(this.Registration_mc.text_tf,!!_loc2_.bRegistered ? "$REGISTERED" : "$UNREGISTERED");
         }
      }
      
      private function SetHullBarInfo(param1:Object) : void
      {
         this.HullBar_mc.SetLabel("$HULL");
         this.TruncateTextCharLength(this.HullBar_mc.NameLabel_tf,LABELMETER_LENGTH);
         var _loc2_:Number = Math.min(param1.iHullHealth + param1.iHullRepairAmount,param1.iMaxHullHealth);
         var _loc3_:Number = Math.min(param1.iHullRepairAmount,param1.iMaxHullHealth - param1.iHullHealth);
         this.HullBar_mc.SetCurrentValue(_loc2_,_loc3_);
         this.HullBar_mc.SetMaxValue(param1.iMaxHullHealth);
         this.HullBar_mc.SetMode(LabeledMeterMC.MODE_WEIGHT);
         this.HullBar_mc.Current_tf.visible = false;
      }
      
      private function TruncateTextCharLength(param1:TextField, param2:Number, param3:String = "…") : *
      {
         var _loc5_:uint = 0;
         if(!this.ShouldTruncateText)
         {
            return;
         }
         var _loc4_:*;
         if(_loc4_ = param1.text.length > param2)
         {
            _loc5_ = param1.text.length - param2;
            param1.text = param1.text.substr(0,param1.text.length - _loc5_);
            if(param1.text.charAt(param1.length - 1) == " ")
            {
               param1.text = param1.text.slice(0,-1);
            }
            param1.appendText(param3);
         }
      }
   }
}
