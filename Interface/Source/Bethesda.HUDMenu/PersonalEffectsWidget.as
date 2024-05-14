package
{
   import flash.display.MovieClip;
   
   public class PersonalEffectsWidget extends MovieClip
   {
       
      
      public var BioCondition0_mc:MovieClip;
      
      public var BioCondition1_mc:MovieClip;
      
      public var BioCondition2_mc:MovieClip;
      
      public var BioCondition3_mc:MovieClip;
      
      public var BioCondition4_mc:MovieClip;
      
      private const MAX_CONDITIONS:uint = 5;
      
      private const INACTIVE_FRAME:uint = 1;
      
      public function PersonalEffectsWidget()
      {
         super();
      }
      
      public function UpdateEffects(param1:Array) : *
      {
         var _loc3_:MovieClip = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length && _loc2_ < this.MAX_CONDITIONS)
         {
            _loc3_ = this["BioCondition" + _loc2_ + "_mc"];
            if(!this.IsIconInUse(_loc2_,param1[_loc2_].sEffectIcon) && _loc3_.currentFrameLabel != param1[_loc2_].sEffectIcon)
            {
               _loc3_.gotoAndStop(param1[_loc2_].sEffectIcon);
               _loc3_.sEffectIcon = param1[_loc2_].sEffectIcon;
            }
            _loc2_++;
         }
         while(_loc2_ < this.MAX_CONDITIONS)
         {
            _loc3_ = this["BioCondition" + _loc2_ + "_mc"];
            if(_loc3_.currentFrame != this.INACTIVE_FRAME)
            {
               _loc3_.gotoAndStop(this.INACTIVE_FRAME);
               _loc3_.sEffectIcon = "";
            }
            _loc2_++;
         }
      }
      
      private function IsIconInUse(param1:uint, param2:String) : Boolean
      {
         var _loc5_:MovieClip = null;
         var _loc3_:* = false;
         var _loc4_:uint = 0;
         while(_loc4_ <= param1 && !_loc3_)
         {
            _loc3_ = (_loc5_ = this["BioCondition" + _loc4_ + "_mc"]).sEffectIcon == param2;
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
