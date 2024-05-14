package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import flash.display.MovieClip;
   
   public class HUDSocialCommandIconWidget extends MovieClip
   {
       
      
      private const MAX_MARKERS:uint = 5;
      
      public function HUDSocialCommandIconWidget()
      {
         var _loc2_:HUDSocialCommandIcon = null;
         super();
         var _loc1_:* = 0;
         while(_loc1_ < this.MAX_MARKERS)
         {
            _loc2_ = new HUDSocialCommandIcon();
            _loc2_.name = "SocialIcon" + _loc1_;
            _loc2_.visible = false;
            addChild(_loc2_);
            _loc1_++;
         }
         BSUIDataManager.Subscribe("HUDSocialCommandData",this.OnSocialCommandData);
      }
      
      private function OnSocialCommandData(param1:FromClientDataEvent) : void
      {
         var _loc3_:HUDSocialCommandIcon = null;
         var _loc4_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this.MAX_MARKERS)
         {
            _loc3_ = getChildAt(_loc2_) as HUDSocialCommandIcon;
            if(_loc2_ < param1.data.aCommandIcons.length)
            {
               _loc4_ = param1.data.aCommandIcons[_loc2_];
               _loc3_.x = _loc4_.fScreenX - x;
               _loc3_.y = _loc4_.fScreenY - y;
               _loc3_.SetData(_loc4_);
               _loc3_.visible = true;
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
   }
}
