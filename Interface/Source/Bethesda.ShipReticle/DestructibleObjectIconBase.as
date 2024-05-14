package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class DestructibleObjectIconBase extends TargetIconBase
   {
       
      
      public var HealthBar_mc:MovieClip;
      
      private var LastHealthFrame:int = 0;
      
      public function DestructibleObjectIconBase()
      {
         super();
         this.HealthBar_mc = Internal_mc.HealthBar_mc;
         if(this.HealthBar_mc == null)
         {
            GlobalFunc.TraceWarning("DestructibleObjectIcon Internal_mc missing components");
         }
         if(Divider_mc != null)
         {
            Divider_mc.visible = false;
         }
      }
      
      override public function SetCombatValues(param1:Object) : *
      {
         var _loc2_:int = 0;
         super.SetCombatValues(param1);
         if(this.HealthBar_mc.visible)
         {
            _loc2_ = int(GlobalFunc.MapLinearlyToRange(this.HealthBar_mc.framesLoaded,1,0,1,param1.targetHealth,true));
            if(this.LastHealthFrame != _loc2_)
            {
               this.HealthBar_mc.gotoAndStop(_loc2_);
               this.LastHealthFrame = _loc2_;
            }
         }
      }
   }
}
