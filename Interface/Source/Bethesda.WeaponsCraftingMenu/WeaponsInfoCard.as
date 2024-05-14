package
{
   import Shared.AS3.Inventory.DeltaStat;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class WeaponsInfoCard extends InfoCard
   {
       
      
      public var Damage1_mc:MovieClip;
      
      public var Damage2_mc:MovieClip;
      
      public var Ammo_mc:DeltaStat;
      
      public var AmmoCount_mc:DeltaStat;
      
      public var Mag_mc:DeltaStat;
      
      public var ROF_mc:DeltaStat;
      
      public var Range_mc:DeltaStat;
      
      public var Accuracy_mc:DeltaStat;
      
      public var Mods_mc:DeltaStat;
      
      private var BaseData:Object = null;
      
      private var ModData:Object = null;
      
      public function WeaponsInfoCard()
      {
         super();
      }
      
      public function ArmorInfoCard() : *
      {
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Damage1_mc.Stat_mc.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Damage2_mc.Stat_mc.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function PopulateCard(param1:Object) : void
      {
         super.PopulateCard(param1);
         this.BaseData = param1;
         var _loc2_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(this.BaseData,this.BaseData);
         var _loc3_:Array = [this.Damage1_mc,this.Damage2_mc];
         CraftingUtils.PopulateCardDamageClips(this.BaseData.aElementalStats,_loc2_,_loc3_);
         this.Ammo_mc.SetData(largeTextMode ? "$AMMO_LRG" : "$AMMO",this.BaseData.WeaponInfo.sAmmoType);
         if(this.BaseData.WeaponInfo.uAmmoCapacity == uint.MAX_VALUE)
         {
            this.Mag_mc.SetData(largeTextMode ? "$MAG_LRG" : "$MAG","--");
         }
         else
         {
            this.Mag_mc.SetData(largeTextMode ? "$MAG_LRG" : "$MAG",this.BaseData.WeaponInfo.uAmmoCapacity.toString());
         }
         this.AmmoCount_mc.SetData(largeTextMode ? "$ROUNDS_LRG" : "$ROUNDS",this.BaseData.WeaponInfo.uAmmoCount.toString());
         this.ROF_mc.SetData(largeTextMode ? "$ROF_LRG" : "$ROF",this.BaseData.WeaponInfo.fRateOfFire.toFixed(CraftingUtils.PRECISION));
         this.Range_mc.SetData(largeTextMode ? "$RANGE_LRG" : "$RANGE",this.BaseData.WeaponInfo.fRange.toFixed(CraftingUtils.PRECISION));
         this.Accuracy_mc.SetData(largeTextMode ? "$ACCURACY_LRG" : "$ACCURACY",this.BaseData.WeaponInfo.fAccuracy.toFixed(CraftingUtils.PRECISION) + "%");
         var _loc4_:uint = InventoryItemUtils.GetNonLegendaryModCount(this.BaseData.WeaponInfo.aMods);
         this.Mods_mc.SetData(largeTextMode ? "$MODS_LRG" : "$MODS",_loc4_.toString() + " / " + this.BaseData.WeaponInfo.uModSlots.toString());
         var _loc5_:Array = InventoryItemUtils.RetrieveModsToDisplay(this.BaseData.WeaponInfo.aMods);
         var _loc6_:String = InventoryItemUtils.BuildModDescriptionString(_loc5_);
         GlobalFunc.SetText(Description_mc.Text_tf,_loc6_);
      }
      
      public function PopulateModData(param1:Object) : void
      {
         this.ModData = param1;
         var _loc2_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(this.ModData,this.BaseData);
         var _loc3_:Array = [this.Damage1_mc,this.Damage2_mc];
         CraftingUtils.PopulateCardDamageClips(this.ModData.aElementalStats,_loc2_,_loc3_);
         this.Ammo_mc.SetData(largeTextMode ? "$AMMO_LRG" : "$AMMO",this.ModData.WeaponInfo.sAmmoType);
         var _loc4_:Number = this.ModData.WeaponInfo.uAmmoCapacity - this.BaseData.WeaponInfo.uAmmoCapacity;
         if(this.ModData.WeaponInfo.uAmmoCapacity == uint.MAX_VALUE)
         {
            this.Mag_mc.SetData(largeTextMode ? "$MAG_LRG" : "$MAG","--");
         }
         else
         {
            this.Mag_mc.SetData(largeTextMode ? "$MAG_LRG" : "$MAG",this.ModData.WeaponInfo.uAmmoCapacity.toString(),_loc4_);
         }
         _loc4_ = this.ModData.WeaponInfo.uAmmoCount - this.BaseData.WeaponInfo.uAmmoCount;
         this.AmmoCount_mc.SetData(largeTextMode ? "$ROUNDS_LRG" : "$ROUNDS",this.ModData.WeaponInfo.uAmmoCount.toString(),_loc4_);
         _loc4_ = this.ModData.WeaponInfo.fRateOfFire - this.BaseData.WeaponInfo.fRateOfFire;
         this.ROF_mc.SetData(largeTextMode ? "$ROF_LRG" : "$ROF",this.ModData.WeaponInfo.fRateOfFire.toFixed(CraftingUtils.PRECISION),_loc4_);
         _loc4_ = this.ModData.WeaponInfo.fRange - this.BaseData.WeaponInfo.fRange;
         this.Range_mc.SetData(largeTextMode ? "$RANGE_LRG" : "$RANGE",this.ModData.WeaponInfo.fRange.toFixed(CraftingUtils.PRECISION),_loc4_);
         _loc4_ = this.ModData.WeaponInfo.fAccuracy - this.BaseData.WeaponInfo.fAccuracy;
         this.Accuracy_mc.SetData(largeTextMode ? "$ACCURACY_LRG" : "$ACCURACY",this.ModData.WeaponInfo.fAccuracy.toFixed(CraftingUtils.PRECISION) + "%",_loc4_);
         _loc4_ = this.ModData.fWeight - this.BaseData.fWeight;
         Mass_mc.SetData(largeTextMode ? "$MASS_LRG" : "$MASS",this.ModData.fWeight.toFixed(this.ModData.uWeightPrecision),_loc4_,true);
         _loc4_ = this.ModData.uValue - this.BaseData.uValue;
         Value_mc.SetData(largeTextMode ? "$VALUE_LRG" : "$VALUE",this.ModData.uValue,_loc4_);
         var _loc5_:uint = InventoryItemUtils.GetNonLegendaryModCount(this.ModData.WeaponInfo.aMods);
         var _loc6_:uint = InventoryItemUtils.GetNonLegendaryModCount(this.BaseData.WeaponInfo.aMods);
         this.Mods_mc.SetData(largeTextMode ? "$MODS_LRG" : "$MODS",_loc5_.toString() + " / " + this.ModData.WeaponInfo.uModSlots.toString(),_loc5_ - _loc6_);
         var _loc7_:Array = InventoryItemUtils.RetrieveModsToDisplay(this.ModData.WeaponInfo.aMods);
         var _loc8_:String = InventoryItemUtils.BuildModDescriptionString(_loc7_);
         GlobalFunc.SetText(Description_mc.Text_tf,_loc8_);
      }
   }
}
