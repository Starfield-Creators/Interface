package
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import flash.events.Event;
   
   public class WeaponButton extends ButtonBase
   {
      
      private static const NameEnabledColor:String = "4FA6B0";
      
      private static const NameDisabledColor:String = "000000";
      
      private static const AmmoEnabledColor:String = "8FCFD4";
      
      private static const AmmoDisabledColor:String = "B83838";
      
      public static var SystemAlertThreshold:Number = 0;
      
      public static var REDRAW_EVENT:String = "WeaponButton_RedrawEvent";
       
      
      private var LastCount:uint = 4294967295;
      
      private var LastWeaponName:String = "";
      
      private var StoredButtonData:ButtonBaseData;
      
      public function WeaponButton()
      {
         super();
      }
      
      public function StoreButtonData(param1:ButtonBaseData) : *
      {
         this.StoredButtonData = param1;
         this.StoredButtonData.UseHTML = true;
      }
      
      public function UpdateWeaponComponent(param1:Object) : *
      {
         var _loc5_:uint = 0;
         var _loc2_:Boolean = false;
         var _loc3_:String = String(param1.abbreviation);
         if(!_loc3_ || _loc3_.length == 0)
         {
            _loc3_ = String(param1.componentName.slice(0,3));
         }
         _loc2_ = this.UpdateName(_loc3_) || _loc2_;
         var _loc4_:* = param1.componentPower + param1.uBonusPower;
         if(param1.bUseAmmo)
         {
            _loc5_ = _loc4_ == 0 ? 0 : uint(param1.uiAmmoCount);
         }
         else
         {
            _loc5_ = Math.round(100 * (_loc4_ == 0 ? 0 : param1.componentRechargePercent));
         }
         _loc2_ = this.UpdateCount(_loc5_) || _loc2_;
         var _loc6_:* = 1 - (param1.damagePhys + param1.damageEM) / param1.componentMaxPower >= SystemAlertThreshold;
         _loc2_ ||= this.StoredButtonData.bEnabled != _loc6_;
         this.StoredButtonData.bEnabled = _loc6_;
         if(_loc2_)
         {
            this.StoredButtonData.sButtonText = this.GetButtonText();
            SetButtonData(this.StoredButtonData);
         }
      }
      
      override public function redrawDisplayObject() : void
      {
         super.redrawDisplayObject();
         dispatchEvent(new Event("WeaponButton_RedrawEvent"));
      }
      
      public function UpdateName(param1:String) : Boolean
      {
         var _loc2_:* = this.LastWeaponName != param1;
         this.LastWeaponName = param1;
         return _loc2_;
      }
      
      public function UpdateCount(param1:uint) : Boolean
      {
         var _loc2_:* = this.LastCount != param1;
         this.LastCount = param1;
         return _loc2_;
      }
      
      public function GetButtonText() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = this.StoredButtonData.bEnabled ? NameEnabledColor : NameDisabledColor;
         var _loc3_:String = this.StoredButtonData.bEnabled ? AmmoEnabledColor : AmmoDisabledColor;
         var _loc4_:* = "<font color=\"#" + _loc2_ + "\">" + this.LastWeaponName + "</font>";
         var _loc5_:* = "<font color=\"#" + _loc3_ + "\">" + this.LastCount.toString() + "</font>";
         if(ButtonJustification == IButtonUtils.ICON_FIRST)
         {
            _loc1_ = _loc4_ + " " + _loc5_;
         }
         else if(ButtonJustification == IButtonUtils.LABEL_FIRST)
         {
            _loc1_ = _loc5_ + " " + _loc4_;
         }
         return _loc1_;
      }
   }
}
