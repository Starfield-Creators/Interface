package
{
   import Shared.AS3.BSContainerEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PickpocketListEntry extends BSContainerEntry
   {
       
      
      public var BG_mc:MovieClip;
      
      public var TextHolder_mc:MovieClip;
      
      public var DifficultyColor_mc:MovieClip;
      
      private var CanStealItem:Boolean = true;
      
      private const NAME_MAX_LENGTH:uint = 38;
      
      public function PickpocketListEntry()
      {
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.TextHolder_mc.ItemName_tf;
      }
      
      override public function get selectedFrameLabel() : String
      {
         if(!this.CanStealItem)
         {
            return "Disabled_Selected";
         }
         return "Normal_Selected";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         if(!this.CanStealItem)
         {
            return "Disabled_Unselected";
         }
         return "Normal_Unselected";
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         var _loc2_:* = String(param1.sName);
         var _loc3_:String = param1.uCount > 1 ? " (" + String(param1.uCount) + ")" : "";
         var _loc4_:String = param1.fStealChancePct >= 0 ? " (" + String(Math.floor(param1.fStealChancePct)) + "%)" : "";
         var _loc5_:int;
         if((_loc5_ = this.NAME_MAX_LENGTH - _loc3_.length - _loc4_.length) < _loc2_.length)
         {
            _loc2_ = _loc2_.slice(0,_loc5_ - 3) + "...";
         }
         return _loc2_ + _loc3_ + _loc4_;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         var _loc2_:uint = param1.uStealChanceColor + 1;
         this.CanStealItem = _loc2_ < this.DifficultyColor_mc.totalFrames;
         this.DifficultyColor_mc.gotoAndStop(_loc2_);
      }
   }
}
