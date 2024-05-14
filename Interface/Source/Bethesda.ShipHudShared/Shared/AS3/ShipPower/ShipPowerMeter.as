package Shared.AS3.ShipPower
{
   import Shared.AS3.IntegerRange;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ShipPowerMeter extends ShipComponentBase
   {
      
      private static const POWER_EMPTY:uint = EnumHelper.GetEnum(1);
      
      private static const POWER_REPAIR:uint = EnumHelper.GetEnum();
      
      private static const POWER_DAMAGE_EM:uint = EnumHelper.GetEnum();
      
      private static const POWER_DAMAGE_PHYS:uint = EnumHelper.GetEnum();
      
      private static const POWER_BUFF:uint = EnumHelper.GetEnum();
      
      private static const POWER_POWERED:uint = EnumHelper.GetEnum();
      
      private static const POWER_UNPOWERED:uint = EnumHelper.GetEnum();
       
      
      public var ShipPowerFrame_mc:MovieClip;
      
      public var PowerMeter_mc:MovieClip;
      
      protected var PowerBars:Array;
      
      protected var LastUpdateFrame:uint = 4294967295;
      
      protected var isPowerMaxed:Boolean = false;
      
      protected var isPowerEmpty:Boolean = false;
      
      protected var hasPowerAllocated:Boolean = false;
      
      protected var bPhysicalRepair:Boolean = false;
      
      private var ChangedToOrFromNull:Boolean = false;
      
      private var ExpandedPowerBarIndex:int = -1;
      
      private var Expanded:Boolean = false;
      
      protected var isDamaged:Boolean = false;
      
      protected var isDestroyed:Boolean = false;
      
      protected var isRepairing:Boolean = false;
      
      protected var currentPowerLevel:Number = 0;
      
      protected var MaxPower:int = 0;
      
      protected var PowerRange:IntegerRange;
      
      protected var BonusPowerRange:IntegerRange;
      
      protected var ManualRepairRange:IntegerRange;
      
      protected var EmRepairRange:IntegerRange;
      
      protected var EmRange:IntegerRange;
      
      protected var PhysRepairRange:IntegerRange;
      
      protected var PhysRange:IntegerRange;
      
      protected var UnpoweredRange:IntegerRange;
      
      protected var BeyondMaxRange:IntegerRange;
      
      public function ShipPowerMeter()
      {
         this.PowerBars = new Array();
         this.PowerRange = new IntegerRange(0,0);
         this.BonusPowerRange = new IntegerRange(0,0);
         this.ManualRepairRange = new IntegerRange(0,0);
         this.EmRepairRange = new IntegerRange(0,0);
         this.EmRange = new IntegerRange(0,0);
         this.PhysRepairRange = new IntegerRange(0,0);
         this.PhysRange = new IntegerRange(0,0);
         this.UnpoweredRange = new IntegerRange(0,0);
         this.BeyondMaxRange = new IntegerRange(0,0);
         super();
         var _loc1_:uint = 1;
         var _loc2_:MovieClip = this.PowerMeter_mc["Bar" + _loc1_.toString() + "_mc"];
         while(_loc2_ != null)
         {
            if(!_loc2_.visible && this.ExpandedPowerBarIndex == -1)
            {
               this.ExpandedPowerBarIndex = _loc1_;
            }
            this.PowerBars.push(_loc2_);
            _loc1_++;
            _loc2_ = this.PowerMeter_mc["Bar" + _loc1_.toString() + "_mc"];
         }
         this.BeyondMaxRange = new IntegerRange(0,this.PowerBars.length);
      }
      
      public function get IsPowerMaxed() : Boolean
      {
         return this.isPowerMaxed;
      }
      
      public function get IsPowerEmpty() : Boolean
      {
         return this.isPowerEmpty;
      }
      
      public function get HasPowerAllocated() : Boolean
      {
         return this.hasPowerAllocated;
      }
      
      public function set PhysicalRepair(param1:Boolean) : *
      {
         if(this.bPhysicalRepair != param1)
         {
            this.bPhysicalRepair = param1;
            if(componentObject != null && componentObject.damagePhys > 0)
            {
               this.LastUpdateFrame = 0;
            }
            this.Update();
         }
      }
      
      public function get PhysicalRepair() : Boolean
      {
         return this.bPhysicalRepair;
      }
      
      override public function set ComponentObject(param1:Object) : *
      {
         super.ComponentObject = param1;
         this.UpdatePowerBars();
      }
      
      protected function UpdateBars(param1:IntegerRange, param2:IntegerRange, param3:uint) : *
      {
         var aNewRange:IntegerRange = param1;
         var aOldRange:IntegerRange = param2;
         var asFrame:uint = param3;
         aNewRange.ForEachExclusiveValue(aOldRange,function(param1:int):*
         {
            if(param1 < PowerBars.length)
            {
               PowerBars[param1].gotoAndStop(asFrame);
            }
         });
      }
      
      protected function UpdatePowerBars() : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:IntegerRange = null;
         var _loc11_:int = 0;
         var _loc12_:IntegerRange = null;
         var _loc13_:IntegerRange = null;
         var _loc14_:IntegerRange = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:IntegerRange = null;
         var _loc18_:IntegerRange = null;
         var _loc19_:IntegerRange = null;
         var _loc20_:IntegerRange = null;
         var _loc21_:IntegerRange = null;
         var _loc22_:* = false;
         var _loc23_:IntegerRange = null;
         var _loc1_:* = 0;
         this.PowerMeter_mc.visible = componentObject != null;
         if(componentObject != null && this.LastUpdateFrame != componentObject.uLastUpdate)
         {
            _loc3_ = componentObject.componentMaxPower - componentObject.damagePhys;
            _loc4_ = _loc3_ - componentObject.damageEM;
            _loc5_ = componentObject.componentPower + componentObject.uBonusPower;
            _loc6_ = Number(componentObject.uBonusPower);
            _loc7_ = this.PhysicalRepair ? _loc3_ : Number(componentObject.componentMaxPower);
            this.MaxPower = componentObject.componentMaxPower;
            this.isPowerMaxed = _loc5_ == this.MaxPower;
            this.isPowerEmpty = _loc5_ == 0;
            this.hasPowerAllocated = _loc5_ > _loc6_;
            this.isDamaged = false;
            this.isRepairing = false;
            this.currentPowerLevel = _loc5_;
            _loc8_ = componentObject.damagePhys + componentObject.damageEM;
            this.isDestroyed = _loc8_ >= componentObject.componentMaxPower;
            _loc9_ = Math.min(_loc6_,_loc4_);
            _loc10_ = new IntegerRange(0,_loc9_);
            _loc11_ = Math.min(_loc5_,_loc4_);
            _loc12_ = new IntegerRange(_loc9_,_loc11_);
            _loc13_ = new IntegerRange(_loc11_,_loc5_);
            _loc14_ = new IntegerRange(_loc13_.HighBoundExclusive,_loc4_);
            _loc15_ = _loc4_;
            _loc16_ = _loc3_ > _loc4_ ? _loc15_ + 1 : _loc15_;
            _loc17_ = new IntegerRange(_loc15_,_loc16_);
            _loc18_ = new IntegerRange(_loc16_,_loc3_);
            _loc15_ = Math.max(_loc5_,_loc3_);
            _loc16_ = this.PhysicalRepair ? int(Math.min(_loc15_ + 1,componentObject.componentMaxPower)) : _loc15_;
            _loc19_ = new IntegerRange(_loc15_,_loc16_);
            _loc20_ = new IntegerRange(_loc16_,componentObject.componentMaxPower);
            _loc21_ = new IntegerRange(componentObject.componentMaxPower,this.PowerBars.length);
            this.UpdateBars(_loc10_,this.BonusPowerRange,POWER_BUFF);
            this.UpdateBars(_loc12_,this.PowerRange,POWER_POWERED);
            this.UpdateBars(_loc13_,this.ManualRepairRange,POWER_REPAIR);
            this.UpdateBars(_loc14_,this.UnpoweredRange,POWER_UNPOWERED);
            this.UpdateBars(_loc17_,this.EmRepairRange,POWER_REPAIR);
            this.UpdateBars(_loc18_,this.EmRange,POWER_DAMAGE_EM);
            this.UpdateBars(_loc19_,this.PhysRepairRange,POWER_REPAIR);
            this.UpdateBars(_loc20_,this.PhysRange,POWER_DAMAGE_PHYS);
            this.UpdateBars(_loc21_,this.BeyondMaxRange,POWER_EMPTY);
            this.PowerRange = _loc12_;
            this.ManualRepairRange = _loc13_;
            this.UnpoweredRange = _loc14_;
            this.EmRepairRange = _loc17_;
            this.EmRange = _loc18_;
            this.PhysRepairRange = _loc19_;
            this.PhysRange = _loc20_;
            this.BeyondMaxRange = _loc21_;
            _loc22_ = Math.min(componentObject.componentMaxPower,this.PowerBars.length) - 1 >= this.ExpandedPowerBarIndex;
            if(this.Expanded != _loc22_)
            {
               this.PowerMeter_mc.gotoAndStop(_loc22_ ? "Expanded" : "Normal");
               this.Expanded = _loc22_;
            }
            this.LastUpdateFrame = componentObject.uLastUpdate;
         }
         else if(componentObject == null && this.LastUpdateFrame != 0)
         {
            if(ComponentName_mc != null)
            {
               GlobalFunc.SetText(Name_tf,"",true);
            }
            _loc23_ = new IntegerRange(0,this.PowerBars.length);
            this.UpdateBars(_loc23_,this.BeyondMaxRange,POWER_EMPTY);
            this.BeyondMaxRange = _loc23_;
            this.LastUpdateFrame = 0;
         }
      }
      
      override public function Update() : *
      {
         this.UpdatePowerBars();
         super.Update();
      }
   }
}
