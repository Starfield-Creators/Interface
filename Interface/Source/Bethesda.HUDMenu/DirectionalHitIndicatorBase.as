package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Patterns.ResourcePool;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DirectionalHitIndicatorBase extends MovieClip
   {
       
      
      protected var IndicatorPool:ResourcePool;
      
      public function DirectionalHitIndicatorBase()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.IndicatorPool = new ResourcePool(DirectionalHitIndicator);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         BSUIDataManager.Subscribe("HUDDirectionalHitData",this.onDirectionalHitData);
      }
      
      private function onDirectionalHitData(param1:FromClientDataEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:DirectionalHitIndicator = null;
         var _loc2_:Array = param1.data.aDirectionalHitIndicators;
         if(_loc2_)
         {
            _loc4_ = _loc2_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc2_[_loc3_];
               if(_loc6_ = this.IndicatorPool.getResource() as DirectionalHitIndicator)
               {
                  addChild(_loc6_);
                  _loc6_.showDirection(_loc5_.iRotation);
                  _loc6_.addEventListener(DirectionalHitIndicator.ANIM_FINISHED,this.onAnimationOver,false,0,true);
               }
               _loc3_++;
            }
         }
      }
      
      private function onAnimationOver(param1:Event) : *
      {
         var _loc2_:DirectionalHitIndicator = param1.target.parent as DirectionalHitIndicator;
         if(_loc2_.hasEventListener(DirectionalHitIndicator.ANIM_FINISHED))
         {
            _loc2_.removeEventListener(DirectionalHitIndicator.ANIM_FINISHED,this.onAnimationOver);
         }
         removeChild(_loc2_);
         this.IndicatorPool.returnResource(_loc2_);
      }
   }
}
