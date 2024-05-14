package
{
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ArmorInfoCard extends InfoCard
   {
       
      
      public var Resist1_mc:MovieClip;
      
      public var Resist2_mc:MovieClip;
      
      public var Resist3_mc:MovieClip;
      
      public var Thermal_mc:MovieClip;
      
      public var Airborne_mc:MovieClip;
      
      public var Corrosive_mc:MovieClip;
      
      public var Radiation_mc:MovieClip;
      
      private var BaseData:Object = null;
      
      private var ModData:Object = null;
      
      public function ArmorInfoCard()
      {
         super();
         this.Thermal_mc.Icon_mc.gotoAndStop("Thermal");
         this.Airborne_mc.Icon_mc.gotoAndStop("Airborne");
         this.Corrosive_mc.Icon_mc.gotoAndStop("Corrosive");
         this.Radiation_mc.Icon_mc.gotoAndStop("Radiation");
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Resist1_mc.Stat_mc.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Resist2_mc.Stat_mc.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Resist3_mc.Stat_mc.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function PopulateCard(param1:Object) : void
      {
         super.PopulateCard(param1);
         this.BaseData = param1;
         var _loc2_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(this.BaseData,this.BaseData);
         var _loc3_:Array = [this.Resist1_mc,this.Resist2_mc,this.Resist3_mc];
         CraftingUtils.PopulateCardDamageClips(this.BaseData.aElementalStats,_loc2_,_loc3_);
         this.Thermal_mc.Stat_mc.SetData(largeTextMode ? "$DRThermal_LRG" : "$DRThermal",this.BaseData.ArmorInfo.fThermalResist.toFixed(CraftingUtils.PRECISION));
         this.Airborne_mc.Stat_mc.SetData(largeTextMode ? "$DRAirborne_LRG" : "$DRAirborne",this.BaseData.ArmorInfo.fAirborneResist.toFixed(CraftingUtils.PRECISION));
         this.Corrosive_mc.Stat_mc.SetData(largeTextMode ? "$DRCorrosive_LRG" : "$DRCorrosive",this.BaseData.ArmorInfo.fCorrosiveResist.toFixed(CraftingUtils.PRECISION));
         this.Radiation_mc.Stat_mc.SetData(largeTextMode ? "$DRRadiation_LRG" : "$DRRadiation",this.BaseData.ArmorInfo.fRadiationResist.toFixed(CraftingUtils.PRECISION));
         var _loc4_:Array = InventoryItemUtils.RetrieveModsToDisplay(this.BaseData.ArmorInfo.aMods);
         var _loc5_:String = InventoryItemUtils.BuildModDescriptionString(_loc4_);
         GlobalFunc.SetText(Description_mc.Text_tf,_loc5_);
      }
      
      public function PopulateModData(param1:Object) : void
      {
         this.ModData = param1;
         var _loc2_:Array = InventoryItemUtils.CreateCompareArrayForElemStats(this.ModData,this.BaseData);
         var _loc3_:Array = [this.Resist1_mc,this.Resist2_mc,this.Resist3_mc];
         CraftingUtils.PopulateCardDamageClips(this.ModData.aElementalStats,_loc2_,_loc3_);
         var _loc4_:Number = this.ModData.ArmorInfo.fThermalResist - this.BaseData.ArmorInfo.fThermalResist;
         this.Thermal_mc.Stat_mc.SetData(largeTextMode ? "$DRThermal_LRG" : "$DRThermal",this.ModData.ArmorInfo.fThermalResist.toFixed(CraftingUtils.PRECISION),_loc4_);
         _loc4_ = this.ModData.ArmorInfo.fAirborneResist - this.BaseData.ArmorInfo.fAirborneResist;
         this.Airborne_mc.Stat_mc.SetData(largeTextMode ? "$DRAirborne_LRG" : "$DRAirborne",this.ModData.ArmorInfo.fAirborneResist.toFixed(CraftingUtils.PRECISION),_loc4_);
         _loc4_ = this.ModData.ArmorInfo.fCorrosiveResist - this.BaseData.ArmorInfo.fCorrosiveResist;
         this.Corrosive_mc.Stat_mc.SetData(largeTextMode ? "$DRCorrosive_LRG" : "$DRCorrosive",this.ModData.ArmorInfo.fCorrosiveResist.toFixed(CraftingUtils.PRECISION),_loc4_);
         _loc4_ = this.ModData.ArmorInfo.fRadiationResist - this.BaseData.ArmorInfo.fRadiationResist;
         this.Radiation_mc.Stat_mc.SetData(largeTextMode ? "$DRRadiation_LRG" : "$DRRadiation",this.ModData.ArmorInfo.fRadiationResist.toFixed(CraftingUtils.PRECISION),_loc4_);
         _loc4_ = this.ModData.fWeight - this.BaseData.fWeight;
         Mass_mc.SetData(largeTextMode ? "$MASS_LRG" : "$MASS",this.ModData.fWeight.toFixed(this.ModData.uWeightPrecision),_loc4_,true);
         _loc4_ = this.ModData.uValue - this.BaseData.uValue;
         Value_mc.SetData(largeTextMode ? "$VALUE_LRG" : "$VALUE",this.ModData.uValue,_loc4_);
         var _loc5_:Array = InventoryItemUtils.RetrieveModsToDisplay(this.ModData.ArmorInfo.aMods);
         var _loc6_:String = InventoryItemUtils.BuildModDescriptionString(_loc5_);
         GlobalFunc.SetText(Description_mc.Text_tf,_loc6_);
      }
   }
}
