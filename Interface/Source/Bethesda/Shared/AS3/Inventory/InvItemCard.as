package Shared.AS3.Inventory
{
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class InvItemCard extends MovieClip
   {
       
      
      public var Header_mc:MovieClip;
      
      public var Content_mc:MovieClip;
      
      private var LargeTextMode:Boolean = false;
      
      public function InvItemCard()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.ItemName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Rarity_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      private function get ItemName_tf() : TextField
      {
         return this.Header_mc.Text_mc.Name_tf;
      }
      
      private function get Rarity_tf() : TextField
      {
         return this.Header_mc.Text_mc.Rarity_tf;
      }
      
      public function set largeTextMode(param1:Boolean) : *
      {
         this.LargeTextMode = param1;
      }
      
      public function GetVisibleHeight() : Number
      {
         var _loc1_:Number = this.GetModsBackgroundBottom();
         if(!this.Content_mc.BGMods_mc.Internal_mc.visible)
         {
            _loc1_ -= this.Content_mc.BGMods_mc.height;
         }
         return _loc1_;
      }
      
      public function SetItemData(param1:Object, param2:Object) : void
      {
         this.ClearItemDescription();
         this.Header_mc.gotoAndStop(InventoryItemUtils.GetFrameLabelFromRarity(param1.uRarity));
         GlobalFunc.SetText(this.ItemName_tf,param1.sName);
         if(this.Header_mc.ResourceRarity_mc != null)
         {
            this.Header_mc.ResourceRarity_mc.gotoAndStop(param1.uResourceScarcity + 1);
         }
         var _loc3_:String = "";
         if(param1.WeaponInfo)
         {
            _loc3_ = String(param1.WeaponInfo.sWeaponType);
         }
         if(param1.uRarity == InventoryItemUtils.RARITY_STANDARD)
         {
            GlobalFunc.SetText(this.Rarity_tf,_loc3_);
         }
         else if(_loc3_.length == 0)
         {
            GlobalFunc.SetText(this.Rarity_tf,"$ItemRarity_" + InventoryItemUtils.GetFrameLabelFromRarity(param1.uRarity));
         }
         else
         {
            GlobalFunc.SetText(this.Rarity_tf,"$WeaponRarityAndType_" + InventoryItemUtils.GetFrameLabelFromRarity(param1.uRarity) + " {0}",false,false,0,false,0,new Array(_loc3_));
         }
         this.Content_mc.gotoAndStop(this.GetContentFrameFromFilter(param1));
         this.PopulateGeneralStats(param1,param2);
         if((param1.iFilterFlag & InventoryItemUtils.ICF_WEAPONS) != 0)
         {
            this.PopulateWeaponStats(param1,param2);
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_SPACESUITS) != 0 || (param1.iFilterFlag & InventoryItemUtils.ICF_BACKPACKS) != 0 || (param1.iFilterFlag & InventoryItemUtils.ICF_HELMETS) != 0 || (param1.iFilterFlag & InventoryItemUtils.ICF_APPAREL) != 0)
         {
            this.PopulateArmorStats(param1,param2);
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_THROWABLES) != 0)
         {
            this.PopulateThrowableStats(param1,param2);
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_AID) != 0)
         {
            this.PopulateMedicineStats(param1);
         }
         if(this.Content_mc.Description_mc.visible)
         {
            this.PopulateItemDescription(param1);
         }
         var _loc4_:Boolean = this.ModDescription_tf.text == "" || this.ModDescription_tf.text == " ";
         this.Content_mc.BGMods_mc.Internal_mc.visible = this.Content_mc.ModsDescription_mc.visible && !_loc4_;
      }
      
      private function get Mass_mc() : DeltaStat
      {
         return this.Content_mc.Mass_mc;
      }
      
      private function get Value_mc() : DeltaStat
      {
         return this.Content_mc.Value_mc;
      }
      
      private function PopulateGeneralStats(param1:Object, param2:Object) : void
      {
         var _loc3_:Number = param2 != null ? param1.fWeight - param2.fWeight : 1;
         this.Mass_mc.SetData(this.LargeTextMode ? "$MASS_LRG" : "$MASS",param1.fWeight.toFixed(param1.uWeightPrecision),_loc3_,true);
         this.Value_mc.SetData(this.LargeTextMode ? "$VALUE_LRG" : "$VALUE",param1.uValue);
      }
      
      private function get ModDescription_tf() : TextField
      {
         return this.Content_mc.ModsDescription_mc.Text_tf;
      }
      
      private function PopulateModStats(param1:Array) : void
      {
         var _loc2_:String = InventoryItemUtils.BuildModDescriptionString(param1,this.ModDescription_tf);
         GlobalFunc.SetText(this.ModDescription_tf,_loc2_);
         var _loc3_:Number = _loc2_.length > 0 ? this.ModDescription_tf.textHeight : 0;
         var _loc4_:Number = 45 + (_loc2_.length > 0 ? 10 : 0);
         this.Content_mc.BGMods_mc.Internal_mc.height = _loc3_ + _loc4_;
      }
      
      private function get Ammo_mc() : DeltaStat
      {
         return this.Content_mc.Ammo_mc;
      }
      
      private function get Mag_mc() : DeltaStat
      {
         return this.Content_mc.Magazine_mc;
      }
      
      private function get Rounds_mc() : DeltaStat
      {
         return this.Content_mc.Rounds_mc;
      }
      
      private function get ROF_mc() : DeltaStat
      {
         return this.Content_mc.ROF_mc;
      }
      
      private function get Range_mc() : DeltaStat
      {
         return this.Content_mc.Range_mc;
      }
      
      private function get Accuracy_mc() : DeltaStat
      {
         return this.Content_mc.Accuracy_mc;
      }
      
      private function get NumMods_mc() : DeltaStat
      {
         return this.Content_mc.NumMods_mc;
      }
      
      private function DamageTypeDisplay(param1:uint) : *
      {
         switch(param1)
         {
            case 0:
               return this.Content_mc.DMGType0;
            case 1:
               return this.Content_mc.DMGType1;
            case 2:
               return this.Content_mc.DMGType2;
            default:
               return null;
         }
      }
      
      private function PopulateDamage(param1:Object, param2:Object, param3:Object) : *
      {
         var _loc6_:MovieClip = null;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:uint = 0;
         var _loc4_:Number = 0;
         if(Boolean(param2) && Boolean(param3))
         {
            for each(_loc8_ in param2)
            {
               _loc4_ += _loc8_;
            }
         }
         var _loc5_:* = 0;
         var _loc7_:uint = 0;
         while(_loc7_ < InventoryItemUtils.ET_ITEM_CARD_COUNT)
         {
            _loc9_ = uint(InventoryItemUtils.GetElementByItemCardSortOrder(_loc7_));
            _loc10_ = 0;
            _loc11_ = _loc4_;
            if(Boolean(param2) && _loc11_ == 0)
            {
               if(_loc9_ < param2.length)
               {
                  _loc11_ = param2[InventoryItemUtils.GetElementItemCardSortOrder(_loc9_)];
               }
            }
            _loc12_ = 0;
            while(_loc12_ < param1.length)
            {
               if(param1[_loc12_].iElementalType == _loc9_)
               {
                  _loc10_ = param1[_loc12_].fValue;
                  break;
               }
               _loc12_++;
            }
            if(Math.round(_loc10_) > 0)
            {
               (_loc6_ = this.DamageTypeDisplay(_loc5_++)).Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(_loc9_));
               _loc6_.Stat_mc.SetData(InventoryItemUtils.GetElementalLocString(_loc9_),_loc10_.toFixed(0),_loc11_);
               _loc6_.visible = true;
            }
            _loc7_++;
         }
         while(_loc5_ < InventoryItemUtils.ET_ITEM_CARD_COUNT)
         {
            if(_loc6_ = this.DamageTypeDisplay(_loc5_))
            {
               _loc6_.visible = false;
            }
            _loc5_++;
         }
      }
      
      private function PopulateWeaponStats(param1:Object, param2:Object) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc3_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(param1,param2);
         this.PopulateDamage(param1.aElementalStats,_loc3_,true);
         if(this.Ammo_mc != null)
         {
            this.Ammo_mc.SetData(this.LargeTextMode ? "$AMMO_LRG" : "$AMMO",param1.WeaponInfo.sAmmoType,0,false,this.LargeTextMode ? 10 : 0);
         }
         if(this.Mag_mc != null)
         {
            if(param1.WeaponInfo.uAmmoCapacity == uint.MAX_VALUE)
            {
               this.Mag_mc.SetData(this.LargeTextMode ? "$MAG_LRG" : "$MAG","--",0);
            }
            else
            {
               if(param2.WeaponInfo.uAmmoCapacity == uint.MAX_VALUE)
               {
                  _loc4_ = 0;
               }
               else
               {
                  _loc4_ = param2 != null ? param1.WeaponInfo.uAmmoCapacity - param2.WeaponInfo.uAmmoCapacity : 1;
               }
               this.Mag_mc.SetData(this.LargeTextMode ? "$MAG_LRG" : "$MAG",param1.WeaponInfo.uAmmoCapacity.toString(),_loc4_);
            }
         }
         if(this.Rounds_mc != null)
         {
            _loc4_ = param2 != null ? param1.WeaponInfo.uAmmoCount - param2.WeaponInfo.uAmmoCount : 1;
            this.Rounds_mc.SetData(this.LargeTextMode ? "$ROUNDS_LRG" : "$ROUNDS",param1.WeaponInfo.uAmmoCount.toString(),_loc4_);
         }
         if(this.ROF_mc != null)
         {
            _loc4_ = param2 != null ? param1.WeaponInfo.fRateOfFire - param2.WeaponInfo.fRateOfFire : 1;
            this.ROF_mc.SetData(this.LargeTextMode ? "$ROF_LRG" : "$ROF",param1.WeaponInfo.fRateOfFire.toFixed(0),_loc4_);
         }
         if(this.Range_mc != null)
         {
            _loc4_ = param2 != null ? param1.WeaponInfo.fRange - param2.WeaponInfo.fRange : 1;
            this.Range_mc.SetData(this.LargeTextMode ? "$RANGE_LRG" : "$RANGE",param1.WeaponInfo.fRange.toFixed(0),_loc4_);
         }
         if(this.Accuracy_mc != null)
         {
            _loc4_ = param2 != null ? param1.WeaponInfo.fAccuracy - param2.WeaponInfo.fAccuracy : 1;
            this.Accuracy_mc.SetData(this.LargeTextMode ? "$ACCURACY_LRG" : "$ACCURACY",param1.WeaponInfo.fAccuracy.toFixed(1) + "%",_loc4_);
         }
         if(this.NumMods_mc != null)
         {
            _loc5_ = InventoryItemUtils.GetNonLegendaryModCount(param1.WeaponInfo.aMods);
            _loc6_ = InventoryItemUtils.GetNonLegendaryModCount(param2 != null ? param2.WeaponInfo.aMods : null);
            this.NumMods_mc.SetData(this.LargeTextMode ? "$MODS_LRG" : "$MODS",_loc5_.toString() + " / " + param1.WeaponInfo.uModSlots.toString(),_loc5_ - _loc6_);
         }
         if(this.ModDescription_tf != null)
         {
            _loc7_ = InventoryItemUtils.RetrieveModsToDisplay(param1.WeaponInfo.aMods);
            this.PopulateModStats(_loc7_);
         }
      }
      
      private function PopulateThrowableStats(param1:Object, param2:Object) : void
      {
         var _loc3_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(param1,param2);
         this.PopulateDamage(param1.aElementalStats,_loc3_,true);
      }
      
      private function get Thermal_mc() : DeltaStat
      {
         return this.Content_mc.DRThermal_mc.Stat_mc;
      }
      
      private function get Airborne_mc() : DeltaStat
      {
         return this.Content_mc.DRAirborne_mc.Stat_mc;
      }
      
      private function get Corrosive_mc() : DeltaStat
      {
         return this.Content_mc.DRCorrosive_mc.Stat_mc;
      }
      
      private function get Radiation_mc() : DeltaStat
      {
         return this.Content_mc.DRRadiation_mc.Stat_mc;
      }
      
      private function PopulateArmorStats(param1:Object, param2:Object) : void
      {
         this.Content_mc.DRThermal_mc.Icon_mc.gotoAndStop("Thermal");
         this.Content_mc.DRAirborne_mc.Icon_mc.gotoAndStop("Airborne");
         this.Content_mc.DRCorrosive_mc.Icon_mc.gotoAndStop("Corrosive");
         this.Content_mc.DRRadiation_mc.Icon_mc.gotoAndStop("Radiation");
         var _loc3_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(param1,param2);
         this.PopulateDamage(param1.aElementalStats,_loc3_,false);
         var _loc4_:Number = param2 != null ? param1.ArmorInfo.fThermalResist - param2.ArmorInfo.fThermalResist : 1;
         this.Thermal_mc.SetData(this.LargeTextMode ? "$DRThermal_LRG" : "$DRThermal",param1.ArmorInfo.fThermalResist.toFixed(0),_loc4_);
         _loc4_ = param2 != null ? param1.ArmorInfo.fAirborneResist - param2.ArmorInfo.fAirborneResist : 1;
         this.Airborne_mc.SetData(this.LargeTextMode ? "$DRAirborne_LRG" : "$DRAirborne",param1.ArmorInfo.fAirborneResist.toFixed(0),_loc4_);
         _loc4_ = param2 != null ? param1.ArmorInfo.fCorrosiveResist - param2.ArmorInfo.fCorrosiveResist : 1;
         this.Corrosive_mc.SetData(this.LargeTextMode ? "$DRCorrosive_LRG" : "$DRCorrosive",param1.ArmorInfo.fCorrosiveResist.toFixed(0),_loc4_);
         _loc4_ = param2 != null ? param1.ArmorInfo.fRadiationResist - param2.ArmorInfo.fRadiationResist : 1;
         this.Radiation_mc.SetData(this.LargeTextMode ? "$DRRadiation_LRG" : "$DRRadiation",param1.ArmorInfo.fRadiationResist.toFixed(0),_loc4_);
         var _loc5_:Array = InventoryItemUtils.RetrieveModsToDisplay(param1.ArmorInfo.aMods);
         this.PopulateModStats(_loc5_);
      }
      
      private function get Description_tf() : TextField
      {
         return this.Content_mc.Description_mc.Text_tf;
      }
      
      private function PopulateMedicineStats(param1:Object) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:uint = 5;
         param1.aTreatments.sort();
         var _loc3_:uint = 0;
         while(this.Content_mc.TreatmentIcons_mc != null && _loc3_ < _loc2_)
         {
            _loc4_ = this.Content_mc.TreatmentIcons_mc["Icon" + _loc3_];
            if(_loc3_ < param1.aTreatments.length)
            {
               _loc4_.gotoAndStop(param1.aTreatments[_loc3_]);
               _loc4_.visible = true;
            }
            else
            {
               _loc4_.visible = false;
            }
            _loc3_++;
         }
      }
      
      private function PopulateItemDescription(param1:Object) : void
      {
         var _loc5_:String = null;
         GlobalFunc.SetText(this.Description_tf,param1.sDescription,true);
         var _loc2_:* = "";
         if(param1.aEffects.length > 0)
         {
            for each(_loc5_ in param1.aEffects)
            {
               if(_loc5_.length > 0)
               {
                  if(_loc2_.length > 0)
                  {
                     _loc2_ += "\n";
                  }
                  _loc2_ += "• ";
                  if(_loc5_.length > 0 && _loc5_.charAt(0) == "%")
                  {
                     _loc2_ += "<b>" + _loc5_.substring(1) + "</b>";
                  }
                  else
                  {
                     _loc2_ += "<b>" + _loc5_ + "</b>";
                  }
               }
            }
         }
         GlobalFunc.SetText(this.ModDescription_tf,_loc2_,true);
         var _loc3_:Number = _loc2_.length > 0 ? this.ModDescription_tf.textHeight : 0;
         var _loc4_:Number = 75 + (_loc2_.length > 0 ? 10 : 0);
         this.Content_mc.BGMods_mc.Internal_mc.height = _loc3_ + _loc4_;
      }
      
      private function ClearItemDescription() : void
      {
         GlobalFunc.SetText(this.Description_tf,"",true);
         GlobalFunc.SetText(this.ModDescription_tf,"",true);
         var _loc1_:Number = 75;
         this.Content_mc.BGMods_mc.Internal_mc.height = _loc1_;
      }
      
      private function GetContentFrameFromFilter(param1:Object) : String
      {
         var _loc2_:String = "Misc";
         if((param1.iFilterFlag & InventoryItemUtils.ICF_WEAPONS) != 0)
         {
            if(param1.WeaponInfo.sMeleeAttackSpeed == "")
            {
               _loc2_ = "Weapons";
            }
            else
            {
               _loc2_ = "Melee";
            }
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_SPACESUITS) != 0)
         {
            _loc2_ = "Spacesuits";
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_BACKPACKS) != 0)
         {
            _loc2_ = "Packs";
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_HELMETS) != 0)
         {
            _loc2_ = "Helmets";
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_APPAREL) != 0)
         {
            _loc2_ = "Apparel";
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_THROWABLES) != 0)
         {
            _loc2_ = "Throwables";
         }
         else if((param1.iFilterFlag & InventoryItemUtils.ICF_AID) != 0 && param1.aTreatments != null && param1.aTreatments.length > 0)
         {
            _loc2_ = "Medicine";
         }
         if(_loc2_ == "Misc" && param1.sDescription != null && param1.sDescription.length > 0)
         {
            _loc2_ = "MiscDescription";
         }
         return _loc2_;
      }
      
      public function GetModsBackgroundBottom() : Number
      {
         return this.Content_mc.y + this.Content_mc.BGMods_mc.y + this.Content_mc.BGMods_mc.height;
      }
   }
}
