package
{
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   
   public class DamageResistances extends MovieClip
   {
       
      
      public var DamageResistanceHeader_mc:MovieClip;
      
      public var DMGType0:MovieClip;
      
      public var DMGType1:MovieClip;
      
      public var DMGType2:MovieClip;
      
      public var DRThermal_mc:MovieClip;
      
      public var DRAirborne_mc:MovieClip;
      
      public var DRCorrosive_mc:MovieClip;
      
      public var DRRadiation_mc:MovieClip;
      
      public function DamageResistances()
      {
         super();
         GlobalFunc.SetText(this.DMGType0.Stat_mc.Label_tf,InventoryItemUtils.GetElementalLocString(InventoryItemUtils.ET_PHYSICAL));
         GlobalFunc.SetText(this.DMGType1.Stat_mc.Label_tf,InventoryItemUtils.GetElementalLocString(InventoryItemUtils.ET_ELECTROMAGNETIC));
         GlobalFunc.SetText(this.DMGType2.Stat_mc.Label_tf,InventoryItemUtils.GetElementalLocString(InventoryItemUtils.ET_ENERGY));
         this.DMGType1.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(InventoryItemUtils.ET_ELECTROMAGNETIC));
         this.DMGType2.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(InventoryItemUtils.ET_ENERGY));
         GlobalFunc.SetText(this.DRThermal_mc.Stat_mc.Label_tf,"$DRThermal");
         GlobalFunc.SetText(this.DRAirborne_mc.Stat_mc.Label_tf,"$DRAirborne");
         GlobalFunc.SetText(this.DRCorrosive_mc.Stat_mc.Label_tf,"$DRCorrosive");
         GlobalFunc.SetText(this.DRRadiation_mc.Stat_mc.Label_tf,"$DRRadiation");
         this.DRAirborne_mc.Icon_mc.gotoAndStop("Airborne");
         this.DRCorrosive_mc.Icon_mc.gotoAndStop("Corrosive");
         this.DRRadiation_mc.Icon_mc.gotoAndStop("Radiation");
      }
      
      public function SetEntry(param1:Object) : *
      {
         GlobalFunc.SetText(this.DMGType0.Stat_mc.Value_mc.Text_tf,String(int(param1.fPhysicalResistance)));
         GlobalFunc.SetText(this.DMGType1.Stat_mc.Value_mc.Text_tf,String(int(param1.fElectromagneticResistance)));
         GlobalFunc.SetText(this.DMGType2.Stat_mc.Value_mc.Text_tf,String(int(param1.fEnergyResistance)));
         GlobalFunc.SetText(this.DRThermal_mc.Stat_mc.Value_mc.Text_tf,String(int(param1.fThermalResistance)));
         GlobalFunc.SetText(this.DRAirborne_mc.Stat_mc.Value_mc.Text_tf,String(int(param1.fAirborneResistance)));
         GlobalFunc.SetText(this.DRCorrosive_mc.Stat_mc.Value_mc.Text_tf,String(int(param1.fCorrosiveResistance)));
         GlobalFunc.SetText(this.DRRadiation_mc.Stat_mc.Value_mc.Text_tf,String(int(param1.fRadiationResistance)));
      }
   }
}
