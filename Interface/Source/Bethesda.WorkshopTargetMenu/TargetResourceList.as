package
{
   import flash.display.MovieClip;
   
   public class TargetResourceList extends MovieClip
   {
      
      public static const MAX_RESOURCES:uint = 8;
       
      
      public var ResourceList_mc:MovieClip;
      
      public function TargetResourceList()
      {
         super();
         this.HideResources();
      }
      
      public function ForceHideCheckmarks() : void
      {
         var _loc1_:ResourceEntry = null;
         var _loc2_:uint = 0;
         while(_loc2_ < MAX_RESOURCES)
         {
            _loc1_ = this.GetResourceClipAtIndex(_loc2_);
            if(_loc1_ != null)
            {
               _loc1_.neededResource = false;
            }
            _loc2_++;
         }
      }
      
      public function HideResources() : void
      {
         var _loc1_:ResourceEntry = null;
         var _loc2_:uint = 0;
         while(_loc2_ < MAX_RESOURCES)
         {
            _loc1_ = this.GetResourceClipAtIndex(_loc2_);
            if(_loc1_ != null)
            {
               _loc1_.visible = false;
            }
            _loc2_++;
         }
      }
      
      public function SetResources(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ResourceEntry = null;
         var _loc4_:* = param1.length > MAX_RESOURCES;
         while(_loc2_ < param1.length && _loc2_ < MAX_RESOURCES)
         {
            _loc3_ = this.GetResourceClipAtIndex(_loc2_);
            if(_loc3_ != null)
            {
               _loc3_.visible = true;
               _loc3_.SetResourceData(param1[_loc2_]);
               _loc3_.showAsContinue = _loc4_ && _loc2_ == MAX_RESOURCES - 1;
            }
            _loc2_++;
         }
         while(_loc2_ < MAX_RESOURCES)
         {
            _loc3_ = this.GetResourceClipAtIndex(_loc2_);
            if(_loc3_ != null)
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function GetResourceClipAtIndex(param1:uint) : ResourceEntry
      {
         return this.ResourceList_mc["Resource" + param1 + "_mc"];
      }
   }
}
