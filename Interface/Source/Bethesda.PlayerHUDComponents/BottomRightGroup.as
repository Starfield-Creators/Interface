package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ExplosiveIndicator.ExplosiveIndicatorBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BottomRightGroup extends BSDisplayObject
   {
      
      private static const FADE_IN_FRAME_NO_POWER:uint = 1;
      
      private static const FADE_OUT_FRAME_NO_POWER:uint = 31;
      
      private static const FADE_IN_FRAME_POWER:uint = 61;
      
      private static const FADE_OUT_FRAME_POWER:uint = 91;
      
      private static const END_FRAME_NO_POWER:uint = 60;
      
      private static const END_FRAME_POWER:uint = 120;
      
      private static const FADE_SEQUENCE_LENGTH:uint = 60;
      
      private static const EQUIPPED_WEAPON_BUFFER:uint = 20;
       
      
      public var HealthBar_mc:MovieClip;
      
      public var HealthBarGhost_mc:MovieClip;
      
      public var HealthBarDamage_mc:MovieClip;
      
      public var PowerBar_mc:MovieClip;
      
      public var PowerBarEmpty_mc:MovieClip;
      
      public var PowerBarIncrease_mc:MovieClip;
      
      public var EquippedWeaponAmmoTotal_mc:MovieClip;
      
      public var EquippedWeaponAmmo_mc:MovieClip;
      
      public var JetpackMeterWrapper_mc:MovieClip;
      
      public var VerticalDivider_mc:MovieClip;
      
      public var VerticalDivider2_mc:MovieClip;
      
      public var Health_mc:MovieClip;
      
      public var HealthBarEmpty_mc:MovieClip;
      
      public var EquippedWeaponIconHolder_mc:MovieClip;
      
      public var EquippedGrenadeIcon_mc:MovieClip;
      
      public var EquippedGrenadeCount_mc:MovieClip;
      
      public var HealthBarIncrease_mc:MovieClip;
      
      private var CurrHealthBarFrame:int = -1;
      
      private var CurrPowerBarFrame:int = -1;
      
      public function BottomRightGroup()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         gotoAndPlay(FADE_IN_FRAME_NO_POWER);
         this.EquippedWeaponIconHolder_mc.EquippedWeaponIcon_mc.onLoadAttemptComplete = this.onWeaponIconLoadAttemptComplete;
         BSUIDataManager.Subscribe("PlayerFrequentData",this.OnPlayerFrequentDataUpdate);
         BSUIDataManager.Subscribe("WeaponData",this.OnWeaponDataUpdate);
         BSUIDataManager.Subscribe("PlayerHealthBoostData",this.OnPlayerHealthDataUpdate);
         BSUIDataManager.Subscribe("HUDStarbornPowersData",this.OnStarbornPowersDataUpdate);
         BSUIDataManager.Subscribe("FireForgetEventData",function(param1:FromClientDataEvent):*
         {
            if(GlobalFunc.HasFireForgetEvent(param1.data,"Hud_OnPlayerSpellCastFailed"))
            {
               if(PowerBar_mc.PowerBarFill_mc)
               {
                  PowerBar_mc.PowerBarFill_mc.gotoAndPlay("Flashing");
               }
            }
         });
      }
      
      public function FadeOut() : void
      {
         if(currentFrame < FADE_OUT_FRAME_NO_POWER)
         {
            gotoAndPlay(FADE_OUT_FRAME_NO_POWER);
         }
         else if(currentFrame < FADE_OUT_FRAME_POWER)
         {
            gotoAndPlay(FADE_OUT_FRAME_POWER);
         }
      }
      
      private function FadeInImmediately() : void
      {
         if(currentFrame >= FADE_OUT_FRAME_POWER)
         {
            gotoAndPlay(Math.max(END_FRAME_POWER - currentFrame,1));
         }
         else if(currentFrame >= FADE_OUT_FRAME_NO_POWER && currentFrame < FADE_IN_FRAME_POWER)
         {
            gotoAndPlay(Math.max(END_FRAME_NO_POWER - currentFrame,1));
         }
      }
      
      private function OnPlayerFrequentDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc4_:int = 0;
         this.FadeInImmediately();
         var _loc2_:Object = param1.data;
         var _loc3_:int = GlobalFunc.MapLinearlyToRange(this.HealthBar_mc.totalFrames,1,0,_loc2_.fMaxHealth,_loc2_.fHealth,true);
         if(_loc3_ != this.CurrHealthBarFrame)
         {
            this.CurrHealthBarFrame = _loc3_;
            this.HealthBar_mc.gotoAndStop(_loc3_);
         }
         if(this.PowerBar_mc)
         {
            if((_loc4_ = GlobalFunc.MapLinearlyToRange(this.PowerBar_mc.totalFrames,1,0,_loc2_.fMaxStarPower,_loc2_.fStarPower,true)) != this.CurrPowerBarFrame)
            {
               this.CurrPowerBarFrame = _loc4_;
               this.PowerBar_mc.gotoAndStop(_loc4_);
            }
         }
         if(_loc2_.fHealthGainPct != 0)
         {
            this.HealthBarGhost_mc.gotoAndStop(GlobalFunc.MapLinearlyToRange(this.HealthBarGhost_mc.totalFrames,1,0,_loc2_.fMaxHealth,_loc2_.fHealth + _loc2_.fMaxHealth * _loc2_.fHealthGainPct,true));
            this.HealthBarGhost_mc.visible = true;
         }
         else
         {
            this.HealthBarGhost_mc.visible = false;
         }
         if(_loc2_.fHealthBarDamage != 0)
         {
            this.HealthBarDamage_mc.gotoAndStop(GlobalFunc.MapLinearlyToRange(this.HealthBarDamage_mc.totalFrames,1,0,_loc2_.fMaxHealth,_loc2_.fHealthBarDamage,true));
            this.HealthBarDamage_mc.visible = true;
         }
         else
         {
            this.HealthBarDamage_mc.visible = false;
         }
      }
      
      private function OnPlayerHealthDataUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.fHealthBoost > 0)
         {
            this.HealthBarIncrease_mc.visible = true;
            this.HealthBarIncrease_mc.gotoAndPlay("Open");
            this.HealthBarIncrease_mc.addEventListener("AnimCompleteEvent",this.HealthBoostAnimationDone);
         }
      }
      
      private function HealthBoostAnimationDone(param1:Event) : void
      {
         this.HealthBarIncrease_mc.removeEventListener("AnimCompleteEvent",this.HealthBoostAnimationDone);
         this.HealthBarIncrease_mc.visible = false;
      }
      
      private function OnWeaponDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc3_:uint = 0;
         this.FadeInImmediately();
         var _loc2_:Object = param1.data;
         if(_loc2_.bShowAmmoAsPercent === true)
         {
            GlobalFunc.SetText(this.EquippedWeaponAmmoTotal_mc.EquippedWeaponAmmoTotal_tf,"100");
            GlobalFunc.SetText(this.EquippedWeaponAmmo_mc.EquippedWeaponAmmo_tf,Math.floor(_loc2_.uClipAmmo / _loc2_.uTotalAmmo * 100).toString());
         }
         else
         {
            _loc3_ = _loc2_.uTotalAmmo <= _loc2_.uClipAmmo ? 0 : uint(_loc2_.uTotalAmmo - _loc2_.uClipAmmo);
            GlobalFunc.SetText(this.EquippedWeaponAmmoTotal_mc.EquippedWeaponAmmoTotal_tf,_loc3_.toString());
            GlobalFunc.SetText(this.EquippedWeaponAmmo_mc.EquippedWeaponAmmo_tf,_loc2_.uClipAmmo);
         }
         this.EquippedWeaponAmmoTotal_mc.visible = _loc2_.bDisplayAmmo;
         this.EquippedWeaponAmmo_mc.visible = _loc2_.bDisplayAmmo;
         this.VerticalDivider_mc.visible = this.EquippedWeaponAmmo_mc.visible && Boolean(this.EquippedWeaponAmmoTotal_mc);
         this.EquippedGrenadeIcon_mc.visible = _loc2_.uExplosiveCount > 0;
         this.EquippedGrenadeIcon_mc.gotoAndStop(_loc2_.uExplosiveIndicatorType == ExplosiveIndicatorBase.EXPLOSIVE_TYPE_GRENADE ? "Grenade" : "Mine");
         this.EquippedGrenadeCount_mc.visible = _loc2_.uExplosiveCount > 0;
         GlobalFunc.SetText(this.EquippedGrenadeCount_mc.EquippedGrenadeCount_tf,String(Math.min(_loc2_.uExplosiveCount,99)));
         this.VerticalDivider2_mc.visible = this.EquippedGrenadeIcon_mc.visible;
         if(_loc2_.sIconLinkageName != "")
         {
            this.EquippedWeaponIconHolder_mc.EquippedWeaponIcon_mc.LoadSymbol(_loc2_.sIconLinkageName,"WeaponIcons");
         }
         else
         {
            this.EquippedWeaponIconHolder_mc.EquippedWeaponIcon_mc.Unload();
         }
      }
      
      private function onWeaponIconLoadAttemptComplete() : *
      {
         this.EquippedWeaponIconHolder_mc.EquippedWeaponIcon_mc.x = this.EquippedWeaponIconHolder_mc.EquippedWeaponIcon_mc.width / 2 + EQUIPPED_WEAPON_BUFFER;
         this.EquippedWeaponIconHolder_mc.EquippedWeaponIcon_mc.y = this.EquippedWeaponIconHolder_mc.height * 3 / 4;
      }
      
      private function OnStarbornPowersDataUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.bHasSpell)
         {
            if(currentFrame < FADE_IN_FRAME_POWER)
            {
               gotoAndPlay(currentFrame + FADE_SEQUENCE_LENGTH);
               if(this.PowerBar_mc)
               {
                  this.PowerBar_mc.PowerBarFill_mc.gotoAndStop("Normal");
               }
            }
         }
         else if(currentFrame >= FADE_IN_FRAME_POWER)
         {
            gotoAndPlay(currentFrame - FADE_SEQUENCE_LENGTH);
         }
      }
   }
}
