package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import flash.display.MovieClip;
   
   public class ScanMapMarkerHolder extends MovieClip
   {
       
      
      private const MAX_MARKERS:uint = 10;
      
      public function ScanMapMarkerHolder()
      {
         var _loc2_:ScanMapMarker = null;
         super();
         var _loc1_:* = 0;
         while(_loc1_ < this.MAX_MARKERS)
         {
            _loc2_ = new ScanMapMarker();
            _loc2_.name = "ScanMarker" + _loc1_;
            _loc2_.visible = false;
            addChild(_loc2_);
            _loc1_++;
         }
         BSUIDataManager.Subscribe("MonocleMenuFreqData",this.onMonocleFreqDataUpdate);
      }
      
      private function onMonocleFreqDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:ScanMapMarker = null;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < this.MAX_MARKERS)
         {
            getChildAt(_loc2_).visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.data.aScannableMarkers.length)
         {
            _loc3_ = param1.data.aScannableMarkers[_loc2_];
            (_loc4_ = getChildAt(_loc2_) as ScanMapMarker).x = (_loc3_.fScreenXPct - 0.5) * stage.stageWidth;
            _loc4_.y = (_loc3_.fScreenYPct - 0.5) * stage.stageHeight;
            _loc4_.Internal_mc.SetLocation(_loc3_.uType,_loc3_.uCategory,_loc3_.uLocationMarkerState);
            _loc4_.Internal_mc.SetFrame(!!_loc3_.bIsDiscovered ? "Discovered" : "Undiscovered");
            _loc4_.range = _loc3_.uRangeM;
            _loc4_.Internal_mc.SetMarkerScale(_loc3_.fDistancePct);
            _loc4_.visible = true;
            _loc2_++;
         }
      }
   }
}
