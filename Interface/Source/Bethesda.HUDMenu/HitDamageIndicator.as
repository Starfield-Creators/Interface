package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class HitDamageIndicator extends MovieClip
   {
       
      
      private const SCOPES_OFFSET:Number = 10;
      
      private const SKIP_FRAMES:uint = 0;
      
      private var WaitFrames:uint = 0;
      
      private var HitKillDataA:Array;
      
      public function HitDamageIndicator()
      {
         this.HitKillDataA = new Array();
         super();
         BSUIDataManager.Subscribe("HudHitKillIndicatorData",this.onHitDamageIndicatorDataChange);
      }
      
      private function SpawnNewClip(param1:Object) : *
      {
         var _loc2_:HitDamageIndicatorClip = null;
         if(param1.fDamage > 0 && Boolean(param1.bShowDamageNumber))
         {
            _loc2_ = new HitDamageIndicatorClip();
            this.addChild(_loc2_);
            if(param1.bOnScreen)
            {
               _loc2_.x = loaderInfo.width * param1.fScreenPositionX;
               _loc2_.y = loaderInfo.height * (1 - param1.fScreenPositionY);
            }
            else
            {
               _loc2_.x = HUDMenu.CENTER_GROUP_POINT.x;
               _loc2_.y = HUDMenu.CENTER_GROUP_POINT.y;
            }
            if(param1.bInScopes)
            {
               _loc2_.x += this.SCOPES_OFFSET;
            }
            if(param1.uHitType === HitKillIndicator.CRITICAL)
            {
               _loc2_.ShowCriticalHitDamage(param1.fDamage);
            }
            else
            {
               _loc2_.ShowHitDamage(param1.fDamage,param1.bIsMitigated,param1.bIsEM);
            }
            _loc2_.addEventListener(HitDamageIndicatorClip.ANIM_FINISHED,this.onHitDamageIndicatorAnimationFinish);
         }
      }
      
      private function onHitDamageIndicatorDataChange(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = null;
         this.HitKillDataA = this.HitKillDataA.concat(GlobalFunc.CloneObject(param1.data.KillDataA));
         if(this.HitKillDataA.length > 0 && this.WaitFrames >= this.SKIP_FRAMES)
         {
            _loc2_ = this.HitKillDataA.shift();
            this.SpawnNewClip(_loc2_);
            if(this.HitKillDataA.length > 0)
            {
               this.WaitFrames = 0;
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
         }
      }
      
      private function onEnterFrame(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(this.WaitFrames < this.SKIP_FRAMES)
         {
            ++this.WaitFrames;
         }
         else if(this.HitKillDataA.length > 0)
         {
            this.WaitFrames = 0;
            _loc2_ = this.HitKillDataA.shift();
            this.SpawnNewClip(_loc2_);
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onHitDamageIndicatorAnimationFinish(param1:Event) : *
      {
         var _loc2_:* = param1.target;
         this.removeChild(_loc2_);
         _loc2_ = null;
      }
   }
}
