package
{
   import Components.DeltaTextValue;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.ShipPower.MyShipComponentManager;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import Shared.ShipInfoUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TargetInfoShip extends BSDisplayObject
   {
      
      private static const TEXT_SPACING:Number = 2;
       
      
      public var Weapons_mc:MovieClip;
      
      public var Credits_mc:MovieClip;
      
      public var Crew_mc:ShipIconStat;
      
      public var Hull_mc:ShipIconStat;
      
      public var Reactor_mc:ShipIconStat;
      
      public var Shield_mc:ShipIconStat;
      
      public var Faction_mc:MovieClip;
      
      public var DamageRating_mc:MovieClip;
      
      public var Level_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var ShipComponents_mc:MyShipComponentManager;
      
      private var Name_tf:TextField;
      
      private var NameArrow_mc:MovieClip;
      
      private var TargetRatingArrow_mc:MovieClip;
      
      private var Level_tf:TextField;
      
      private var DamageRatingLabel_tf:TextField;
      
      private var DamageRatingValue_mc:DeltaTextValue;
      
      private var CreditLabel_tf:TextField;
      
      private var CreditValue_tf:TextField;
      
      private var CreditIcon_mc:MovieClip;
      
      private var WeaponIcon_mc:MovieClip;
      
      private var Weapons:Array;
      
      private var LastName:String = null;
      
      private var LastLevel:int = -1;
      
      private var LastTargetDamageRating:int = -1;
      
      private var LastPlayerDamageRating:int = -1;
      
      private var LastFaction:int = 2147483647;
      
      private var LastReactorClass:int = -1;
      
      private var LastEnableScanningTargetedShipDamageRating:Boolean = true;
      
      private var LastEnableScanningTargetedShipCargoValue:Boolean = true;
      
      private var CargoValueCached:Number = -1;
      
      public function TargetInfoShip()
      {
         this.Weapons = new Array();
         super();
         this.Name_tf = this.Name_mc.Text_tf;
         this.NameArrow_mc = this.Name_mc.Arrow_mc;
         this.TargetRatingArrow_mc = this.Name_mc.Arrow_mc;
         this.Level_tf = this.Level_mc.Text_tf;
         this.DamageRatingLabel_tf = this.DamageRating_mc.Title_tf;
         this.DamageRatingValue_mc = this.DamageRating_mc.Value_mc;
         this.CreditLabel_tf = this.Credits_mc.Label_tf;
         this.CreditValue_tf = this.Credits_mc.Value_tf;
         this.CreditIcon_mc = this.Credits_mc.Icon_mc;
         this.WeaponIcon_mc = this.Weapons_mc.Icon_mc;
         this.Name_tf.autoSize = TextFieldAutoSize.LEFT;
         this.CreditValue_tf.autoSize = TextFieldAutoSize.LEFT;
         this.DamageRatingLabel_tf.autoSize = TextFieldAutoSize.LEFT;
         this.Crew_mc.SetLabel("$CREW");
         this.Hull_mc.SetLabel("$HULL");
         this.Reactor_mc.SetLabel("$REACTOR");
         this.Shield_mc.SetLabel("$SHIELD");
         GlobalFunc.SetText(this.CreditLabel_tf,"$Cargo Value");
         var _loc1_:int = 0;
         var _loc2_:ShipStatBase = this.GetWeapon(_loc1_);
         while(_loc2_ != null)
         {
            this.Weapons.push(_loc2_);
            _loc1_++;
            _loc2_ = this.GetWeapon(_loc1_);
         }
      }
      
      public function GetWeapon(param1:int) : ShipStatBase
      {
         var _loc2_:MovieClip = this.Weapons_mc["Weapon" + param1 + "_mc"];
         return _loc2_ != null ? _loc2_ as ShipStatBase : null;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.NameArrow_mc.stop();
         this.WeaponIcon_mc.gotoAndStop("Damage");
         this.Crew_mc.SetFrame("Crew");
         this.Hull_mc.SetFrame("Hull");
         this.Reactor_mc.SetFrame("ReactorClassA");
         this.Shield_mc.SetFrame("Shield");
      }
      
      private function GetComponent(param1:Array, param2:int) : Object
      {
         return param2 < param1.length ? param1[param2] : null;
      }
      
      public function SetTarget(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : *
      {
         var _loc10_:ShipStatBase = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         if(this.LastName != param1.name)
         {
            GlobalFunc.SetText(this.Name_tf,param1.name,false,false,0,false,0,null,0,2);
            this.NameArrow_mc.x = this.Name_tf.x + this.Name_tf.width + DeltaTextValue.ARROW_TEXT_OFFSET;
            this.LastName = param1.name;
         }
         if(this.LastLevel != param1.iLevel)
         {
            GlobalFunc.SetText(this.Level_tf,"$Level {0} Ship",false,false,0,false,0,new Array(GlobalFunc.FormatNumberToString(param1.iLevel)));
            this.LastLevel = param1.iLevel;
         }
         var _loc6_:Boolean = false;
         if(this.LastTargetDamageRating != param3.iDamageRating || this.LastPlayerDamageRating != param5.iDamageRating)
         {
            this.LastTargetDamageRating = param3.iDamageRating;
            this.LastPlayerDamageRating = param5.iDamageRating;
            _loc6_ = true;
         }
         if(this.LastEnableScanningTargetedShipDamageRating != param4.bEnableScanningTargetedShipDamageRating)
         {
            this.LastEnableScanningTargetedShipDamageRating = param4.bEnableScanningTargetedShipDamageRating;
            _loc6_ = true;
         }
         if(_loc6_)
         {
            if(this.LastEnableScanningTargetedShipDamageRating)
            {
               this.DamageRatingValue_mc.Update(param3.iDamageRating,param5.iDamageRating - param3.iDamageRating);
            }
            else
            {
               this.DamageRatingValue_mc.UpdateToDefaultText("---");
            }
         }
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = this.GetComponent(param3.targetComponentArray,_loc8_);
         while(_loc7_ < this.Weapons.length && _loc9_ != null && _loc8_ < param3.targetComponentArray.length)
         {
            if(_loc9_ != null && _loc9_.type == ShipInfoUtils.MT_WEAPON)
            {
               (_loc10_ = this.Weapons[_loc7_]).visible = true;
               if((_loc11_ = String(_loc9_.abbreviation)) != "")
               {
                  _loc10_.SetLabel(_loc9_.abbreviation);
               }
               else
               {
                  _loc10_.SetLabel("$NONE");
               }
               if(Boolean(param4.bEnableScanningTargetedShipWeaponStats) && _loc11_ != "")
               {
                  _loc10_.SetValueAndDelta(_loc9_.iDamageRating,0);
               }
               else
               {
                  _loc10_.DefaultValueAndDelta("---");
               }
               _loc7_++;
            }
            _loc8_++;
            _loc9_ = this.GetComponent(param3.targetComponentArray,_loc8_);
         }
         while(_loc7_ < this.Weapons.length)
         {
            this.Weapons[_loc7_].visible = false;
            _loc7_++;
         }
         if(param4.bEnableScanningTargetedShipHealthValues)
         {
            _loc12_ = uint(GlobalFunc.MapLinearlyToRange(0,param3.iMaxHealth,0,1,param2.targetHealth,true));
            _loc13_ = uint(GlobalFunc.MapLinearlyToRange(0,param3.iMaxShield,0,1,param2.targetShield,true));
            this.Hull_mc.SetValueAndDelta(_loc12_,param4.iShipMaxHealth);
            this.Shield_mc.SetValueAndDelta(_loc13_,param4.shieldMaxHealth);
         }
         else
         {
            this.Hull_mc.DefaultValueAndDelta("---");
            this.Shield_mc.DefaultValueAndDelta("---");
         }
         if(param4.bEnableScanningTargetedShipCrewCount)
         {
            this.Crew_mc.SetValueAndDelta(param3.uShipCrew,param4.uShipCrew);
         }
         else
         {
            this.Crew_mc.DefaultValueAndDelta("---");
         }
         if(param4.bEnableScanningTargetedShipPowerAlloc)
         {
            this.Reactor_mc.SetValueAndDelta(param3.PowerComponent.componentMaxPower,param5.PowerComponent.componentMaxPower);
         }
         else
         {
            this.Reactor_mc.DefaultValueAndDelta("---");
         }
         if(this.LastEnableScanningTargetedShipCargoValue != param4.bEnableScanningTargetedShipCargoValue)
         {
            this.LastEnableScanningTargetedShipCargoValue = param4.bEnableScanningTargetedShipCargoValue;
            this.RefreshCargoValue();
         }
         if(this.LastFaction != param1.iFaction)
         {
            this.Faction_mc.gotoAndStop(FactionUtils.GetFactionIconLabel(param1.iFaction));
            this.LastFaction = param1.iFaction;
         }
         if(this.LastReactorClass != param3.PowerComponent.iModuleClass)
         {
            this.Reactor_mc.SetFrame(ShipInfoUtils.GetReactorClassString(param3.PowerComponent.iModuleClass));
            this.LastReactorClass = param3.PowerComponent.iModuleClass;
         }
         this.ShipComponents_mc.OnShipComponentUpdate(param3.PowerComponent,param3.targetComponentArray);
      }
      
      public function UpdateInventoryData(param1:Object, param2:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc3_:Number = Number(param1.uCoin);
         for each(_loc4_ in param1.aItems)
         {
            _loc3_ += _loc4_.uValue * _loc4_.uCount;
         }
         if(this.CargoValueCached != _loc3_)
         {
            this.CargoValueCached = _loc3_;
            this.RefreshCargoValue();
         }
      }
      
      public function RefreshCargoValue() : *
      {
         if(this.LastEnableScanningTargetedShipCargoValue && this.CargoValueCached != -1)
         {
            GlobalFunc.SetText(this.CreditValue_tf,GlobalFunc.FormatNumberToString(this.CargoValueCached));
         }
         else
         {
            GlobalFunc.SetText(this.CreditValue_tf,"---");
         }
         this.CreditIcon_mc.x = this.CreditValue_tf.x + this.CreditValue_tf.width + TEXT_SPACING;
      }
   }
}
