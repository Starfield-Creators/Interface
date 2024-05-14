package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.ShipPower.MyShipComponentManager;
   import Shared.AS3.ShipPower.MyShipComponentMeter;
   import Shared.AS3.ShipPower.ShipComponentManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ReleaseHoldComboButton;
   import Shared.GlobalFunc;
   import Shared.ShipInfoUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class PowerAllocationComponent extends MyShipComponentManager
   {
      
      public static const ShipHud_UpdateComponentPower:String = "ShipHud_UpdateComponentPower";
      
      public static const ShipHud_ChangeComponentSelection:String = "ShipHud_ChangeComponentSelection";
       
      
      public var DPadButton_mc:PowerPanelButton;
      
      public var UpButton_mc:ReleaseHoldComboButton;
      
      public var DownButton_mc:ReleaseHoldComboButton;
      
      public var BarCount_mc:MovieClip;
      
      private var DPadButtonHintData:ButtonBaseData;
      
      private var PowerUpDataData:ReleaseHoldComboButtonData;
      
      private var PowerDownDataData:ReleaseHoldComboButtonData;
      
      private var GravJumpFuel:Number;
      
      public function PowerAllocationComponent()
      {
         this.DPadButtonHintData = new ButtonBaseData("",[new UserEventData("Left",this.onSelectLeft),new UserEventData("Right",this.onSelectRight),new UserEventData("Up",this.onPowerUp),new UserEventData("Down",this.onPowerDown)],true,true,"");
         this.PowerUpDataData = new ReleaseHoldComboButtonData("","",[new UserEventData("Up",this.onPowerUpReleased),new UserEventData("",this.onPowerUpHeld)],true,true,"");
         this.PowerDownDataData = new ReleaseHoldComboButtonData("","",[new UserEventData("Down",this.onPowerDownReleased),new UserEventData("",this.onPowerDownHeld)],true,true,"");
         super();
         BSUIDataManager.Subscribe("ComponentFlashEventProvider",this.OnComponentFlashEventUpdated);
         this.DPadButton_mc.SetButtonData(this.DPadButtonHintData);
         this.UpButton_mc.SetButtonData(this.PowerUpDataData);
         this.DownButton_mc.SetButtonData(this.PowerDownDataData);
      }
      
      private function get BarCount_tf() : TextField
      {
         return this.BarCount_mc.Text_tf;
      }
      
      private function OnComponentFlashEventUpdated(param1:FromClientDataEvent) : *
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc2_:Array = param1.data.aEvents;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = GetStartingClipIndexForComponentType(_loc3_.uiType);
            if(_loc3_.uiType == ShipInfoUtils.MT_WEAPON)
            {
               _loc4_ += _loc3_.uiWeaponGroup;
            }
            ComponentMeters[_loc4_].PlayInvalidActionAnimation();
         }
      }
      
      public function UpdateGravJumpFuel(param1:Number) : *
      {
         this.GravJumpFuel = param1;
         this.UpdateOnShipHudDataChange();
      }
      
      public function UpdateOnShipHudDataChange() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < ComponentMeters.length)
         {
            ComponentMeters[_loc1_].SetSelected(_loc1_ == SelectedComponent && ComponentMeters[_loc1_].ComponentObject != null);
            _loc1_++;
         }
      }
      
      protected function GetSelectedPowerComponentTypes() : PowerComponentType
      {
         var _loc1_:PowerComponentType = new PowerComponentType();
         _loc1_.type = ComponentsArray[SelectedComponent].type;
         _loc1_.weaponGroup = ComponentsArray[SelectedComponent].weaponGroup;
         return _loc1_;
      }
      
      private function onSelectLeft() : *
      {
         this.CycleTarget(-1);
      }
      
      private function onSelectRight() : *
      {
         this.CycleTarget(1);
      }
      
      override public function CycleTarget(param1:int) : Boolean
      {
         var _loc2_:Boolean = super.CycleTarget(param1);
         if(_loc2_)
         {
            BSUIDataManager.dispatchEvent(new Event(ShipHud_ChangeComponentSelection));
         }
         this.UpdateOnShipHudDataChange();
         GlobalFunc.PlayMenuSound("UIMenuPowerAllocFocus");
         return _loc2_;
      }
      
      private function onPowerUp() : *
      {
      }
      
      private function onPowerUpReleased() : *
      {
         this.IncrementPower(1);
      }
      
      private function onPowerUpHeld() : *
      {
         var _loc1_:MyShipComponentMeter = null;
         var _loc2_:Object = null;
         _loc1_ = ComponentMeters[SelectedComponent];
         _loc2_ = _loc1_.ComponentObject;
         var _loc3_:uint = uint(_loc2_.componentMaxPower);
         var _loc4_:uint;
         if((_loc4_ = uint(_loc2_.componentPower)) < _loc3_ && ShipPower_mc.HasPowerAllocated)
         {
            this.IncrementPower(Math.min(_loc3_ - _loc4_,ShipPower_mc.ComponentObject.componentPower));
         }
         else
         {
            _loc1_.PlayInvalidActionAnimation();
         }
      }
      
      private function onPowerDown() : *
      {
      }
      
      private function onPowerDownReleased() : *
      {
         this.IncrementPower(-1);
      }
      
      private function onPowerDownHeld() : *
      {
         var _loc1_:MyShipComponentMeter = null;
         var _loc2_:Object = null;
         _loc1_ = ComponentMeters[SelectedComponent];
         _loc2_ = _loc1_.ComponentObject;
         var _loc3_:uint = uint(_loc2_.componentPower);
         var _loc4_:uint = uint(_loc2_.uBonusPower);
         if(_loc3_ > _loc4_)
         {
            this.IncrementPower(_loc4_ - _loc3_);
         }
         else
         {
            _loc1_.PlayInvalidActionAnimation();
         }
      }
      
      private function IncrementPower(param1:int) : *
      {
         var _loc2_:MyShipComponentMeter = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc9_:PowerComponentType = null;
         var _loc10_:Object = null;
         _loc2_ = ComponentMeters[SelectedComponent];
         _loc3_ = _loc2_.ComponentObject;
         _loc4_ = uint(_loc3_.componentPower);
         _loc5_ = uint(param1 + _loc4_);
         _loc6_ = 0;
         _loc7_ = _loc3_.componentMaxPower - _loc3_.uBonusPower;
         var _loc8_:Boolean;
         if(_loc8_ = param1 < 0 && -param1 <= _loc4_ && _loc5_ >= _loc6_ || param1 >= 0 && _loc5_ <= _loc7_ && !ShipPower_mc.IsPowerEmpty)
         {
            _loc9_ = this.GetSelectedPowerComponentTypes();
            _loc10_ = {
               "componentType":_loc9_.type,
               "weaponGroup":_loc9_.weaponGroup,
               "iIncrement":param1
            };
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_UpdateComponentPower,_loc10_));
         }
         else
         {
            _loc2_.PlayInvalidActionAnimation();
         }
      }
      
      override public function OnShipComponentUpdate(param1:Object, param2:Array) : *
      {
         super.OnShipComponentUpdate(param1,param2);
         GlobalFunc.SetText(this.BarCount_tf,"<font color=\"#A7DDDF\">" + param1.componentPower + "</font>/" + param1.componentMaxPower,true);
      }
      
      public function InitiateFarTravel() : *
      {
         gotoAndPlay("FarTravelUp");
      }
      
      public function CompleteFarTravel() : *
      {
         gotoAndPlay("FarTravelDown");
      }
      
      public function UpdateShipHudData(param1:Object) : *
      {
         UpdateRepairData(param1.repairPercentPhys);
         this.UpdateGravJumpFuel(param1.gravJumpFuel);
         ShipComponentManager.NumWeaponGroups = param1.uNumWeaponGroups;
      }
   }
}
