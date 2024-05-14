package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   
   public class HitKillIndicator extends MovieClip
   {
      
      public static const STANDARD_HIT:uint = EnumHelper.GetEnum(0);
      
      public static const HIGH_DMG:uint = EnumHelper.GetEnum();
      
      public static const SNEAK_ATTACK:uint = EnumHelper.GetEnum();
      
      public static const CRITICAL:uint = EnumHelper.GetEnum();
      
      public static const KILL:uint = EnumHelper.GetEnum();
       
      
      public var KillIndicator_mc:MovieClip;
      
      public var HitIndicator_mc:MovieClip;
      
      public function HitKillIndicator()
      {
         super();
         this.KillIndicator_mc.gotoAndStop("End");
         this.HitIndicator_mc.gotoAndStop("End");
         BSUIDataManager.Subscribe("HudHitKillIndicatorData",this.onHitKillDataChange);
      }
      
      public function onHitKillDataChange(param1:FromClientDataEvent) : *
      {
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc2_:Object = param1.data;
         if(_loc2_.KillDataA != null && _loc2_.KillDataA.length > 0)
         {
            _loc3_ = 0;
            _loc4_ = false;
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc2_.KillDataA.length)
            {
               _loc3_ += _loc2_.KillDataA[_loc6_].fDamage;
               _loc4_ = true;
               _loc5_ ||= _loc2_.KillDataA[_loc6_].uHitType === CRITICAL;
               _loc6_++;
            }
            if(_loc4_)
            {
               switch(_loc2_.KillDataA[0].uHitType)
               {
                  case HIGH_DMG:
                     this.HitIndicator_mc.gotoAndPlay("Hit_HighDmg");
                     break;
                  case KILL:
                     this.KillIndicator_mc.gotoAndPlay(1);
                     break;
                  default:
                     this.HitIndicator_mc.gotoAndPlay("Hit_Standard");
               }
               if(_loc3_ > 0 && _loc5_)
               {
                  this.HitIndicator_mc.CritBanner_mc.gotoAndPlay("CriticalHit");
               }
            }
         }
      }
   }
}
