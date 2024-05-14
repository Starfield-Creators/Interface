package
{
   import flash.display.MovieClip;
   
   public class ModulePaletteVariantGroup extends MovieClip
   {
      
      private static const NORMAL:String = "Normal";
      
      private static const ACTIVE:String = "Active";
      
      private static const HIGHLIGHT_NORMAL:String = "HighlightedNormal";
      
      private static const HIGHLIGHT_ACTIVE:String = "HighlightedActive";
       
      
      private var VisiblePipsCount:int;
      
      private var CurrentPipIndex:int = 0;
      
      public function ModulePaletteVariantGroup()
      {
         super();
      }
      
      public function SetVisiblePips(param1:int) : void
      {
         var _loc3_:MovieClip = null;
         if(param1 > this.numChildren)
         {
            trace("Module has more variants than pips in group.");
         }
         this.VisiblePipsCount = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.numChildren)
         {
            _loc3_ = getChildAt(_loc2_) as MovieClip;
            _loc3_.visible = _loc2_ < this.VisiblePipsCount && this.VisiblePipsCount > 1;
            _loc2_++;
         }
         this.SetHighlightState(false);
      }
      
      public function SetActivePip(param1:Number) : void
      {
         if(this.VisiblePipsCount <= 1)
         {
            return;
         }
         var _loc2_:MovieClip = getChildAt(this.CurrentPipIndex) as MovieClip;
         _loc2_.gotoAndStop(HIGHLIGHT_NORMAL);
         var _loc3_:* = (this.CurrentPipIndex + param1) % this.VisiblePipsCount;
         if(_loc3_ < 0)
         {
            _loc3_ = this.VisiblePipsCount - 1;
         }
         _loc2_ = getChildAt(_loc3_) as MovieClip;
         _loc2_.gotoAndStop(HIGHLIGHT_ACTIVE);
         this.CurrentPipIndex = _loc3_;
      }
      
      public function SetHighlightState(param1:Boolean) : void
      {
         this.CurrentPipIndex = 0;
         var _loc2_:MovieClip = getChildAt(this.CurrentPipIndex) as MovieClip;
         _loc2_.gotoAndStop(param1 ? HIGHLIGHT_ACTIVE : ACTIVE);
         var _loc3_:int = 1;
         while(_loc3_ < this.VisiblePipsCount)
         {
            _loc2_ = getChildAt(_loc3_) as MovieClip;
            _loc2_.gotoAndStop(param1 ? HIGHLIGHT_NORMAL : NORMAL);
            _loc3_++;
         }
      }
   }
}
