package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ItemInfoCard extends BSDisplayObject
   {
      
      private static const MAX_ELEMENTAL_STATS:int = 3;
      
      private static const MAX_LINER_STATS:int = 3;
      
      private static const MAX_METERS:int = 3;
      
      private static const METER_ANIM_SPEED:Number = 125;
       
      
      public var Content_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var Mass_mc:DeltaTextValue;
      
      public var Value_mc:DeltaTextValue;
      
      public var ManufacturerLogo_mc:MovieClip;
      
      private const CONFIG_ALWAYS_NEGATIVE_DELTA:LabeledMeterColorConfig = new LabeledMeterColorConfig(LabeledMeterColorConfig.DEFAULT_NORMAL,LabeledMeterColorConfig.DEFAULT_NORMAL,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_DELTA_NEG,LabeledMeterColorConfig.DEFAULT_NORMAL,LabeledMeterColorConfig.DEFAULT_NORMAL,LabeledMeterColorConfig.DEFAULT_BACKGROUND);
      
      private const METER_CURRENT_TF_MIN_POSITION:Number = -55;
      
      private var HasPlayedIntro:Boolean = false;
      
      private var LabeledMetersA:Vector.<LabeledMeterMC>;
      
      public var CompareToObject:Boolean = false;
      
      public var CompareObject:Object = null;
      
      private var DisplayType:String = "";
      
      public function ItemInfoCard()
      {
         this.LabeledMetersA = new Vector.<LabeledMeterMC>();
         super();
         var _loc1_:int = 0;
         while(_loc1_ < MAX_METERS)
         {
            this.LabeledMetersA.push(this.GetMeterClip(_loc1_));
            this.LabeledMetersA[_loc1_].SetFillSpeed(METER_ANIM_SPEED);
            this.LabeledMetersA[_loc1_].SetEmptySpeed(METER_ANIM_SPEED);
            _loc1_++;
         }
         this.Mass_mc.InvertComparison = true;
      }
      
      protected function get Name_tf() : TextField
      {
         return this.Name_mc.Name_tf;
      }
      
      protected function get Description_tf() : TextField
      {
         return this.Content_mc.Description_mc.Description_tf;
      }
      
      protected function get AmmoInfo_mc() : AmmoInfo
      {
         return this.Content_mc.AmmoInfo_mc;
      }
      
      protected function get MagazineInfo_mc() : MovieClip
      {
         return this.Content_mc.MagazineInfo_mc;
      }
      
      protected function get MagazineValue_mc() : DeltaTextValue
      {
         return this.MagazineInfo_mc.Value_mc;
      }
      
      protected function get RateOfFire_mc() : MovieClip
      {
         return this.Content_mc.RateOfFire_mc;
      }
      
      protected function get RateOfFireValue_mc() : DeltaTextValue
      {
         return this.RateOfFire_mc.Value_mc;
      }
      
      protected function GetElementalClip(param1:uint) : DamageResistElementalStat
      {
         return this.Content_mc["Elemental" + (param1 + 1) + "_mc"];
      }
      
      protected function GetLinerClip(param1:uint) : MovieClip
      {
         return this.Content_mc["Liner" + (param1 + 1) + "_mc"];
      }
      
      protected function GetLinerNameText(param1:uint) : TextField
      {
         return this.GetLinerClip(param1).Name_tf;
      }
      
      protected function GetLinerTitleText(param1:uint) : TextField
      {
         return this.GetLinerClip(param1).Title_tf;
      }
      
      protected function GetMeterClip(param1:uint) : LabeledMeterMC
      {
         return this.Content_mc["Meter" + (param1 + 1) + "_mc"];
      }
      
      private function GetValueAndDelta(param1:Object, param2:Object, param3:String) : Object
      {
         var _loc4_:Object;
         (_loc4_ = new Object()).Value = param1 != null ? param1[param3] : 0;
         var _loc5_:Number = param2 != null ? Number(param2[param3]) : 0;
         if(this.CompareToObject)
         {
            _loc4_.Delta = _loc4_.Value - _loc5_;
         }
         else
         {
            _loc4_.Delta = 0;
         }
         return _loc4_;
      }
      
      private function UpdateMeter(param1:LabeledMeterMC, param2:Object, param3:Object, param4:String, param5:Number) : *
      {
         var _loc6_:Number = param2 != null ? Number(param2[param4]) : 0;
         var _loc7_:Number = param3 != null ? Number(param3[param4]) : 0;
         if(this.CompareToObject)
         {
            if(_loc6_ >= _loc7_)
            {
               param1.SetColorConfig(LabeledMeterColorConfig.CONFIG_DEFAULT_DELTA);
               param1.SetCurrentValue(_loc7_,_loc6_ - _loc7_);
            }
            else
            {
               param1.SetColorConfig(this.CONFIG_ALWAYS_NEGATIVE_DELTA);
               param1.SetCurrentValue(_loc6_,_loc7_ - _loc6_);
            }
            GlobalFunc.SetText(param1.Current_tf,GlobalFunc.FormatNumberToString(_loc6_,1));
            param1.Current_tf.x = Math.max(this.METER_CURRENT_TF_MIN_POSITION,param1.Background_mc.width * (_loc6_ / param5) - param1.Current_tf.width);
         }
         else
         {
            param1.SetCurrentValue(_loc6_);
         }
      }
      
      public function UpdateForItemInfo(param1:Object, param2:String, param3:String, param4:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:* = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:FrameLabel = null;
         if(!param1)
         {
            this.DisplayType = "empty";
            this.Content_mc.gotoAndStop(this.DisplayType);
            GlobalFunc.SetText(this.Name_tf,param2);
            GlobalFunc.SetText(this.Description_tf,"");
            this.Description_tf.visible = true;
            this.Mass_mc.Update(0);
            this.Value_mc.Update(0);
            _loc5_ = 0;
            while(_loc5_ < this.LabeledMetersA.length)
            {
               this.LabeledMetersA[_loc5_].SetLabel("");
               this.LabeledMetersA[_loc5_].SetMaxValue(100);
               this.LabeledMetersA[_loc5_].SetTargetCurrentValue(0);
               _loc5_++;
            }
         }
         else
         {
            GlobalFunc.SetText(this.Name_tf,param1.sName);
            if(this.ManufacturerLogo_mc)
            {
               _loc9_ = false;
               for each(_loc10_ in this.ManufacturerLogo_mc.currentLabels)
               {
                  if(_loc10_.name == param1.sManufacturer)
                  {
                     _loc9_ = true;
                     break;
                  }
               }
               if(_loc9_)
               {
                  this.ManufacturerLogo_mc.gotoAndStop(param1.sManufacturer);
               }
               else if(param1.sManufacturer == "[Missing Name]")
               {
                  this.ManufacturerLogo_mc.gotoAndStop("Generic");
               }
               else
               {
                  this.ManufacturerLogo_mc.gotoAndStop("MissingFrame");
                  GlobalFunc.TraceWarning("Missing required manufacturer label in dataCardLogos.fla: " + param1.sManufacturer);
               }
            }
            _loc6_ = this.GetValueAndDelta(param1,this.CompareObject,"fWeight");
            this.Mass_mc.Update(_loc6_.Value,_loc6_.Delta,param1.uWeightPrecision);
            this.Value_mc.Update(param1.uValue);
            _loc7_ = "";
            if(param1.sDescription != null && param1.sDescription.length > 0)
            {
               _loc7_ += param1.sDescription;
               if(param1.aEffects.length > 0)
               {
                  _loc7_ += "\n";
               }
            }
            for each(_loc8_ in param1.aEffects)
            {
               _loc7_ += "\n" + _loc8_;
            }
            if(_loc7_.length > 0)
            {
               GlobalFunc.SetText(this.Description_tf,_loc7_);
               this.Description_tf.visible = true;
            }
            else
            {
               this.Description_tf.visible = false;
            }
            this.UpdateElementalInfo(param1);
            this.DisplayType = InventoryItemUtils.GetTypeName(param1.iType);
            this.Content_mc.gotoAndStop(this.DisplayType);
            switch(param1.iType)
            {
               case InventoryItemUtils.IIT_WEAPON:
                  this.UpdateWeaponInfo(param1.WeaponInfo);
                  break;
               case InventoryItemUtils.IIT_ARMOR:
                  this.UpdateArmorInfo(param1);
                  break;
               case InventoryItemUtils.IIT_CONSUMABLE:
                  this.UpdateConsumableInfo(param1);
            }
         }
         if(this.HasPlayedIntro)
         {
            if(param4)
            {
               gotoAndPlay("AnimIn");
            }
            else
            {
               gotoAndPlay("itemHighlight");
            }
         }
         else
         {
            gotoAndPlay("rollOn");
            this.HasPlayedIntro = true;
         }
      }
      
      private function UpdateWeaponInfo(param1:Object) : void
      {
         var _loc2_:Object = this.CompareObject != null ? this.CompareObject.WeaponInfo : null;
         this.AmmoInfo_mc.Update(param1.sAmmoType,param1.uAmmoCount);
         var _loc3_:Object = this.GetValueAndDelta(param1,_loc2_,"uAmmoCapacity");
         this.MagazineValue_mc.Update(_loc3_.Value,_loc3_.Delta);
         var _loc4_:Object = this.GetValueAndDelta(param1,_loc2_,"fRateOfFire");
         this.RateOfFireValue_mc.Update(_loc4_.Value,_loc4_.Delta);
         var _loc5_:LabeledMeterMC;
         (_loc5_ = this.LabeledMetersA[0]).SetLabel("$RANGE");
         _loc5_.SetMaxValue(Math.max(200,param1.fRange));
         this.UpdateMeter(_loc5_,param1,_loc2_,"fRange",Math.max(200,param1.fRange));
         var _loc6_:LabeledMeterMC;
         (_loc6_ = this.LabeledMetersA[1]).SetLabel("$acc");
         _loc6_.SetMaxValue(Math.max(200,param1.fAccuracy));
         this.UpdateMeter(_loc6_,param1,_loc2_,"fAccuracy",Math.max(200,param1.fAccuracy));
         var _loc7_:LabeledMeterMC;
         (_loc7_ = this.LabeledMetersA[2]).SetLabel("$PENETRATION");
         _loc7_.SetMaxValue(100);
      }
      
      private function GetLinerTitle(param1:int) : String
      {
         return "$LINER_" + (param1 + 1) + "_TITLE";
      }
      
      private function UpdateArmorInfo(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < MAX_LINER_STATS)
         {
            GlobalFunc.SetText(this.GetLinerNameText(_loc2_),"$EMPTY");
            GlobalFunc.SetText(this.GetLinerTitleText(_loc2_),this.GetLinerTitle(_loc2_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.LabeledMetersA.length)
         {
            this.LabeledMetersA[_loc2_].SetLabel("");
            this.LabeledMetersA[_loc2_].SetMaxValue(100);
            this.LabeledMetersA[_loc2_].SetTargetCurrentValue(0);
            _loc2_++;
         }
      }
      
      private function UpdateElementalInfo(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:DamageResistElementalStat = null;
         var _loc2_:Array = new Array(InventoryItemUtils.ET_COUNT);
         var _loc3_:Array = new Array(InventoryItemUtils.ET_COUNT);
         _loc4_ = 0;
         while(_loc4_ < InventoryItemUtils.ET_COUNT)
         {
            _loc2_[_loc4_] = null;
            _loc3_[_loc4_] = null;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.aElementalStats.length)
         {
            _loc5_ = param1.aElementalStats[_loc4_];
            _loc2_[_loc5_.iElementalType] = _loc5_;
            _loc4_++;
         }
         if(this.CompareToObject && this.CompareObject != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.CompareObject.aElementalStats.length)
            {
               _loc5_ = this.CompareObject.aElementalStats[_loc4_];
               _loc3_[_loc5_.iElementalType] = _loc5_;
               _loc4_++;
            }
         }
         var _loc6_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length && _loc6_ < MAX_ELEMENTAL_STATS)
         {
            if(_loc2_[_loc4_] != null)
            {
               _loc7_ = this.GetValueAndDelta(_loc2_[_loc4_],_loc3_[_loc4_],"fValue");
               (_loc8_ = this.GetElementalClip(_loc6_)).SetEquipmentType(this.DisplayType);
               _loc8_.Update(_loc4_,_loc7_.Value,_loc7_.Delta);
               _loc8_.visible = true;
               _loc6_++;
            }
            _loc4_++;
         }
         while(_loc6_ < MAX_ELEMENTAL_STATS)
         {
            this.GetElementalClip(_loc6_).visible = false;
            _loc6_++;
         }
      }
      
      private function UpdateConsumableInfo(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc2_:LabeledMeterMC = this.LabeledMetersA[0];
         var _loc3_:UIDataFromClient = BSUIDataManager.GetDataFromClient("PlayerFrequentData");
         if(_loc3_.dataReady)
         {
            _loc4_ = _loc3_.data;
            _loc5_ = Math.min(_loc4_.fHealth + (param1.fHPGain + _loc4_.fHealthGainPct) * _loc4_.fMaxHealth,_loc4_.fMaxHealth);
            _loc2_.SetLabel("$HP");
            _loc2_.SetMaxValue(_loc4_.fMaxHealth);
            _loc2_.SetTargetCurrentValue(_loc4_.fHealth,_loc5_ - _loc4_.fHealth);
         }
      }
   }
}
