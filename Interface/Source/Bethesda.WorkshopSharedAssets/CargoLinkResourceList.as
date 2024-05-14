package
{
   import Components.DisplayList;
   
   public class CargoLinkResourceList extends DisplayList
   {
       
      
      public function CargoLinkResourceList()
      {
         super();
      }
      
      override public function set entryData(param1:Array) : *
      {
         super.entryData = param1;
         var _loc2_:CargoLinkResourceEntry = null;
         var _loc3_:int = totalEntryClips - 1;
         var _loc4_:* = totalEntryClips < entryCount;
         var _loc5_:uint = 0;
         while(_loc5_ < totalEntryClips)
         {
            _loc2_ = GetClipByIndex(_loc5_) as CargoLinkResourceEntry;
            if(_loc2_ != null)
            {
               _loc2_.showAsContinue = _loc4_ && _loc5_ == _loc3_;
            }
            _loc5_++;
         }
      }
   }
}
