package Shared.Components.ExplosiveIndicator
{
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   
   public class ExplosiveIndicatorBase extends MovieClip
   {
      
      public static const EXPLOSIVE_TYPE_GRENADE:uint = EnumHelper.GetEnum(0);
      
      public static const EXPLOSIVE_TYPE_MINE:uint = EnumHelper.GetEnum();
      
      public static const DISPLAY_RADIUS:Number = 133.2;
       
      
      public var Icon_mc:MovieClip;
      
      public var Arrow_mc:MovieClip;
      
      public function ExplosiveIndicatorBase()
      {
         super();
      }
      
      public function SetExplosive(param1:Object) : *
      {
         switch(param1.uIndicatorType)
         {
            case EXPLOSIVE_TYPE_GRENADE:
               gotoAndStop("Grenade");
               break;
            case EXPLOSIVE_TYPE_MINE:
               gotoAndStop("Mine");
         }
         this.Arrow_mc.rotation = param1.fAngleToPlayer * 180 / Math.PI;
         this.Icon_mc.x = Math.cos(param1.fAngleToPlayer) * DISPLAY_RADIUS;
         this.Icon_mc.y = Math.sin(param1.fAngleToPlayer) * DISPLAY_RADIUS;
         this.Icon_mc.gotoAndStop(!!param1.bInBlastRadius ? "Near" : "Far");
         this.Arrow_mc.gotoAndStop(!!param1.bInBlastRadius ? "Near" : "Far");
      }
   }
}
