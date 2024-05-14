package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class TurnRateSweetSpotIndicator extends MovieClip
   {
       
      
      public var Mask_mc:MovieClip;
      
      public var ScaleClip_mc:MovieClip;
      
      private var ScaleClipInternal:MovieClip = null;
      
      private var LastSweetSpot:Boolean = false;
      
      private var LastSweetSpotFrame:int = 0;
      
      public function TurnRateSweetSpotIndicator()
      {
         super();
         this.ScaleClipInternal = this.ScaleClip_mc.Internal_mc;
      }
      
      public function OnStickDataUpdate(param1:Object) : *
      {
         var _loc2_:Number = NaN;
         this.ScaleClip_mc.y = GlobalFunc.MapLinearlyToRange(0,-this.Mask_mc.height,0,1,param1.fTurnRateSweetSpot,false);
         this.ScaleClipInternal.height = param1.fTurnRateSweetSpotRange * this.Mask_mc.height;
         _loc2_ = param1.fTurnRateSweetSpotRange / 2;
         var _loc3_:int = GlobalFunc.MapLinearlyToRange(1,this.ScaleClipInternal.framesLoaded,param1.fTurnRateSweetSpot - _loc2_,param1.fTurnRateSweetSpot * 2,param1.throttle,true);
         if(this.LastSweetSpotFrame != _loc3_)
         {
            this.ScaleClipInternal.gotoAndStop(_loc3_);
            this.LastSweetSpotFrame = _loc3_;
         }
      }
   }
}
