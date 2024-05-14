package Shared.AS3.ShipPower
{
   import Shared.GlobalFunc;
   import Shared.ShipInfoUtils;
   import flash.display.MovieClip;
   
   public class ShipComponentManager extends MovieClip
   {
      
      protected static var NumWeaponGroups:uint = 3;
      
      public static const DEFAULT_SELECTED_COMPONENT:* = 3;
       
      
      public var ComponentMeter1_mc:MovieClip;
      
      public var ComponentMeter2_mc:MovieClip;
      
      public var ComponentMeter3_mc:MovieClip;
      
      public var ComponentMeter4_mc:MovieClip;
      
      public var ComponentMeter5_mc:MovieClip;
      
      public var ComponentMeter6_mc:MovieClip;
      
      protected var ComponentMeters:Array;
      
      protected var componentsArray:Array = null;
      
      protected var SelectedComponent:int = 3;
      
      protected var Abbreviations:Array;
      
      public function ShipComponentManager()
      {
         this.Abbreviations = ["","$W","$ENG","$SHD","$GRV"];
         super();
         this.ComponentMeters = new Array();
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = this[this.GetMeterClipName(_loc1_)];
         while(_loc2_ != null)
         {
            this.ComponentMeters.push(_loc2_);
            _loc1_++;
            _loc2_ = this[this.GetMeterClipName(_loc1_)];
         }
      }
      
      public function set ComponentsArray(param1:Array) : *
      {
         this.componentsArray = param1;
      }
      
      public function get ComponentsArray() : Array
      {
         return this.componentsArray;
      }
      
      public function GetStartingClipIndexForComponentType(param1:uint) : *
      {
         return param1 > ShipInfoUtils.MT_WEAPON ? param1 + NumWeaponGroups - 1 : param1;
      }
      
      private function GetMeterClipName(param1:uint) : String
      {
         return "ComponentMeter" + (param1 + 1).toString() + "_mc";
      }
      
      public function UpdateComponentsArray() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Object = null;
         var _loc3_:ShipComponentBase = null;
         if(this.ComponentsArray != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.ComponentsArray.length && _loc1_ < this.ComponentMeters.length)
            {
               _loc2_ = this.ComponentsArray[_loc1_];
               _loc3_ = this.ComponentMeters[_loc1_];
               _loc3_.ComponentObject = _loc2_;
               if(_loc2_.bTargetComponent)
               {
                  this.SelectedComponent = _loc1_;
               }
               _loc1_++;
            }
            while(_loc1_ < this.ComponentMeters.length)
            {
               this.ComponentMeters[_loc1_].ComponentObject = null;
               _loc1_++;
            }
         }
      }
      
      public function CycleTarget(param1:int) : Boolean
      {
         var _loc2_:int = GlobalFunc.Clamp(this.SelectedComponent + param1,0,this.ComponentsArray.length - 1);
         var _loc3_:int = 0;
         while(param1 != 0 && _loc3_ < this.ComponentsArray.length && _loc2_ > 0 && _loc2_ < this.ComponentsArray.length - 1 && (this.ComponentsArray[_loc2_] == null || this.ComponentsArray[_loc2_].type == ShipInfoUtils.MT_COUNT))
         {
            _loc2_ += param1;
            _loc3_++;
         }
         if(_loc3_ == this.ComponentsArray.length)
         {
            GlobalFunc.TraceWarning("No valid target components found");
         }
         var _loc4_:* = this.SelectedComponent != _loc2_;
         this.SelectedComponent = _loc2_;
         return _loc4_;
      }
   }
}
