package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PowerAllocation extends BSDisplayObject
   {
      
      public static const CURRENT:* = "Current";
      
      public static const ADD:* = "Add";
      
      public static const REMOVE:* = "Remove";
      
      public static const EMPTY:* = "Empty";
      
      public static const CURRENT_HIGHLIGHT:* = "Current_Highlight";
      
      public static const EMPTY_HIGHLIGHT:* = "Empty_Highlight";
      
      public static const NORMAL:* = "Normal";
      
      public static const HIGHLIGHT:* = "Highlight";
      
      public static const SYSTEM_WEAPONGROUP1:int = EnumHelper.GetEnum(0);
      
      public static const SYSTEM_WEAPONGROUP2:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_WEAPONGROUP3:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_ENGINE:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_SHIELD:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_GRAVDRIVE:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_REACTOR:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_GENERAL:int = EnumHelper.GetEnum();
       
      
      public var ComponentMeter1_mc:MovieClip;
      
      public var ComponentMeter2_mc:MovieClip;
      
      public var ComponentMeter3_mc:MovieClip;
      
      public var ComponentMeter4_mc:MovieClip;
      
      public var ComponentMeter5_mc:MovieClip;
      
      public var ComponentMeter6_mc:MovieClip;
      
      public var ShipPower_mc:MovieClip;
      
      internal const NUM_METERS:int = 6;
      
      internal const NUM_BARS_FOR_METER:int = 12;
      
      internal const NUM_BARS_FOR_REACTOR_METER:int = 38;
      
      internal var CurrentHighlightIndex:int;
      
      public function PowerAllocation()
      {
         this.CurrentHighlightIndex = SYSTEM_GENERAL;
         super();
         BSUIDataManager.Subscribe("PowerAllocation",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            UpdateValues(_loc2_);
         });
         BSUIDataManager.Subscribe("SystemPowerHighlight",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            if(_loc2_.iHighlightedSystem >= SYSTEM_WEAPONGROUP1)
            {
               UpdatePowerHighlight(_loc2_.iHighlightedSystem);
            }
         });
      }
      
      private function get Weapon1MeterText() : TextField
      {
         return this.ComponentMeter1_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get Weapon2MeterText() : TextField
      {
         return this.ComponentMeter2_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get Weapon3MeterText() : TextField
      {
         return this.ComponentMeter3_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get EngineMeterText() : TextField
      {
         return this.ComponentMeter4_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get ShieldMeterText() : TextField
      {
         return this.ComponentMeter5_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get GravDriveMeterText() : TextField
      {
         return this.ComponentMeter6_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get ShipPowerMeter() : MovieClip
      {
         return this.ShipPower_mc.PowerMeter_mc;
      }
      
      private function get Weapon1Meter() : MovieClip
      {
         return this.ComponentMeter1_mc.PowerMeter_mc;
      }
      
      private function get Weapon2Meter() : MovieClip
      {
         return this.ComponentMeter2_mc.PowerMeter_mc;
      }
      
      private function get Weapon3Meter() : MovieClip
      {
         return this.ComponentMeter3_mc.PowerMeter_mc;
      }
      
      private function get EngineMeter() : MovieClip
      {
         return this.ComponentMeter4_mc.PowerMeter_mc;
      }
      
      private function get ShieldMeter() : MovieClip
      {
         return this.ComponentMeter5_mc.PowerMeter_mc;
      }
      
      private function get GravDriveMeter() : MovieClip
      {
         return this.ComponentMeter6_mc.PowerMeter_mc;
      }
      
      override public function onAddedToStage() : void
      {
         GlobalFunc.SetText(this.EngineMeterText,"");
         GlobalFunc.SetText(this.GravDriveMeterText,"");
         GlobalFunc.SetText(this.ShieldMeterText,"");
         GlobalFunc.SetText(this.Weapon1MeterText,"");
         GlobalFunc.SetText(this.Weapon2MeterText,"");
         GlobalFunc.SetText(this.Weapon3MeterText,"");
      }
      
      public function UpdateValues(param1:Object) : void
      {
         this.UpdateComponentMeter(this.ShipPowerMeter,this.NUM_BARS_FOR_REACTOR_METER,param1.iReactor,param1.iReactorDiff);
         this.UpdateComponentMeter(this.EngineMeter,this.NUM_BARS_FOR_METER,param1.iEngine,param1.iEngineDiff);
         var _loc2_:String = param1.iEngine > 0 ? "$ENG" : "";
         GlobalFunc.SetText(this.EngineMeterText,_loc2_);
         this.UpdateComponentMeter(this.GravDriveMeter,this.NUM_BARS_FOR_METER,param1.iGravDrive,param1.iGravDriveDiff);
         var _loc3_:String = param1.iGravDrive > 0 ? "$GRV" : "";
         GlobalFunc.SetText(this.GravDriveMeterText,_loc3_);
         this.UpdateComponentMeter(this.ShieldMeter,this.NUM_BARS_FOR_METER,param1.iShield,param1.iShieldDiff);
         var _loc4_:String = param1.iShield > 0 ? "$SHD" : "";
         GlobalFunc.SetText(this.ShieldMeterText,_loc4_);
         this.UpdateComponentMeter(this.Weapon1Meter,this.NUM_BARS_FOR_METER,param1.iWeapon1,param1.iWeapon1Diff);
         if(param1.iWeapon1 > 0)
         {
            GlobalFunc.SetText(this.Weapon1MeterText,"$W",false,false,0,false,0,new Array(GlobalFunc.FormatNumberToString(0)));
         }
         else
         {
            GlobalFunc.SetText(this.Weapon1MeterText,"");
         }
         this.UpdateComponentMeter(this.Weapon2Meter,this.NUM_BARS_FOR_METER,param1.iWeapon2,param1.iWeapon2Diff);
         if(param1.iWeapon2 > 0)
         {
            GlobalFunc.SetText(this.Weapon2MeterText,"$W",false,false,0,false,0,new Array(GlobalFunc.FormatNumberToString(1)));
         }
         else
         {
            GlobalFunc.SetText(this.Weapon2MeterText,"");
         }
         this.UpdateComponentMeter(this.Weapon3Meter,this.NUM_BARS_FOR_METER,param1.iWeapon3,param1.iWeapon3Diff);
         if(param1.iWeapon3 > 0)
         {
            GlobalFunc.SetText(this.Weapon3MeterText,"$W",false,false,0,false,0,new Array(GlobalFunc.FormatNumberToString(2)));
         }
         else
         {
            GlobalFunc.SetText(this.Weapon3MeterText,"");
         }
      }
      
      public function UpdatePowerHighlight(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:* = undefined;
         if(this.CurrentHighlightIndex == param1)
         {
            return;
         }
         if(this.CurrentHighlightIndex != SYSTEM_GENERAL)
         {
            _loc2_ = this.GetSystemMovieClip(this.CurrentHighlightIndex);
            _loc3_ = this.CurrentHighlightIndex == SYSTEM_REACTOR ? this.NUM_BARS_FOR_REACTOR_METER : this.NUM_BARS_FOR_METER;
            _loc4_ = 1;
            while(_loc4_ <= _loc3_)
            {
               if((_loc5_ = _loc2_.PowerMeter_mc["Bar" + _loc4_ + "_mc"]).currentFrameLabel == CURRENT_HIGHLIGHT)
               {
                  _loc5_.gotoAndStop(CURRENT);
               }
               else if(_loc5_.currentFrameLabel == EMPTY_HIGHLIGHT)
               {
                  _loc5_.gotoAndStop(EMPTY);
               }
               _loc4_++;
            }
            _loc2_.gotoAndStop(NORMAL);
         }
         if(param1 != SYSTEM_GENERAL)
         {
            _loc2_ = this.GetSystemMovieClip(param1);
            _loc3_ = param1 == SYSTEM_REACTOR ? this.NUM_BARS_FOR_REACTOR_METER : this.NUM_BARS_FOR_METER;
            _loc6_ = 1;
            while(_loc6_ <= _loc3_)
            {
               if((_loc5_ = _loc2_.PowerMeter_mc["Bar" + _loc6_ + "_mc"]).currentFrameLabel == CURRENT)
               {
                  _loc5_.gotoAndStop(CURRENT_HIGHLIGHT);
               }
               else if(_loc5_.currentFrameLabel == EMPTY)
               {
                  _loc5_.gotoAndStop(EMPTY_HIGHLIGHT);
               }
               _loc6_++;
            }
            _loc2_.gotoAndStop(HIGHLIGHT);
         }
         this.CurrentHighlightIndex = param1;
      }
      
      private function UpdateComponentMeter(param1:MovieClip, param2:int, param3:int, param4:int) : *
      {
         var _loc5_:int = param4 > 0 ? param3 - param4 : param3;
         var _loc6_:int = Math.abs(param4);
         var _loc7_:String = param4 < 0 ? REMOVE : ADD;
         if(_loc5_ + _loc6_ > param2)
         {
            if(_loc5_ > param2)
            {
               _loc5_ = param2;
            }
            _loc6_ = param2 - _loc5_;
         }
         param1.visible = param3 > 0;
         var _loc8_:int = 1;
         if(param3 > 0)
         {
            while(_loc8_ <= _loc5_)
            {
               param1["Bar" + _loc8_ + "_mc"].gotoAndStop(CURRENT);
               _loc8_++;
            }
            while(_loc8_ <= _loc5_ + _loc6_)
            {
               param1["Bar" + _loc8_ + "_mc"].gotoAndStop(_loc7_);
               _loc8_++;
            }
            while(_loc8_ <= param2)
            {
               param1["Bar" + _loc8_ + "_mc"].gotoAndStop(EMPTY);
               _loc8_++;
            }
         }
      }
      
      private function GetSystemMovieClip(param1:int) : MovieClip
      {
         var _loc2_:MovieClip = null;
         if(param1 == SYSTEM_WEAPONGROUP1)
         {
            _loc2_ = this.ComponentMeter1_mc;
         }
         else if(param1 == SYSTEM_WEAPONGROUP2)
         {
            _loc2_ = this.ComponentMeter2_mc;
         }
         else if(param1 == SYSTEM_WEAPONGROUP3)
         {
            _loc2_ = this.ComponentMeter3_mc;
         }
         else if(param1 == SYSTEM_ENGINE)
         {
            _loc2_ = this.ComponentMeter4_mc;
         }
         else if(param1 == SYSTEM_SHIELD)
         {
            _loc2_ = this.ComponentMeter5_mc;
         }
         else if(param1 == SYSTEM_GRAVDRIVE)
         {
            _loc2_ = this.ComponentMeter6_mc;
         }
         else if(param1 == SYSTEM_REACTOR)
         {
            _loc2_ = this.ShipPower_mc;
         }
         return _loc2_;
      }
   }
}
