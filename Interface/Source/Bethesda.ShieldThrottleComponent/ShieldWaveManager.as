package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   
   public class ShieldWaveManager extends MovieClip
   {
      
      private static const FRAME_OFF:uint = EnumHelper.GetEnum(1);
      
      private static const FRAME_ON:uint = EnumHelper.GetEnum();
      
      private static const MAX_SHIELD_CLIPS:uint = 4;
       
      
      private var ShieldClips:Array;
      
      private var FrameLabelsFound:Boolean = false;
      
      private var FullFrame:uint = 0;
      
      private var OverFullFrame:uint = 0;
      
      private var LastPercent:Number = -1;
      
      private var LastMax:uint = 4294967295;
      
      public function ShieldWaveManager()
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Array = null;
         var _loc4_:FrameLabel = null;
         this.ShieldClips = new Array();
         super();
         var _loc1_:uint = 0;
         while(_loc1_ < MAX_SHIELD_CLIPS)
         {
            _loc2_ = new ShieldWaveClip();
            _loc2_.name = "ShieldClip" + _loc1_;
            _loc2_.LineHolder_mc.gotoAndStop(this.ShieldClips.length % _loc2_.framesLoaded + 1);
            addChild(_loc2_);
            this.ShieldClips.push(_loc2_);
            if(!this.FrameLabelsFound)
            {
               _loc3_ = _loc2_.currentLabels;
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_.name == "Full")
                  {
                     this.FullFrame = _loc4_.frame;
                  }
                  else if(_loc4_.name == "OverFull")
                  {
                     this.OverFullFrame = _loc4_.frame;
                  }
               }
               this.FrameLabelsFound = true;
            }
            _loc1_++;
         }
      }
      
      public function SetPower(param1:uint, param2:Number) : *
      {
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc3_:* = Math.min(param1,MAX_SHIELD_CLIPS);
         var _loc4_:Boolean = false;
         if(this.LastPercent != param2)
         {
            _loc5_ = param2 == 0 ? FRAME_OFF : FRAME_ON;
            if(currentFrame != _loc5_)
            {
               gotoAndStop(_loc5_);
            }
            this.LastPercent = param2;
            _loc4_ = true;
         }
         if(_loc4_ || this.LastMax != _loc3_)
         {
            _loc7_ = param2 * _loc3_;
            _loc6_ = 0;
            while(_loc7_ - _loc6_ >= 2 && _loc6_ < _loc3_)
            {
               this.ShieldClips[_loc6_].UpdateFrame(this.OverFullFrame);
               _loc6_++;
            }
            if(_loc6_ < _loc3_ && _loc7_ - _loc6_ >= 1)
            {
               this.ShieldClips[_loc6_].UpdateFrame(Math.round(GlobalFunc.MapLinearlyToRange(this.FullFrame,this.OverFullFrame,1,2,_loc7_ - _loc6_,true)));
               _loc6_++;
            }
            if(_loc6_ < _loc3_ && _loc7_ - _loc6_ > 0)
            {
               this.ShieldClips[_loc6_].UpdateFrame(Math.round(GlobalFunc.MapLinearlyToRange(1,this.FullFrame,0,1,_loc7_ - _loc6_,true)));
               _loc6_++;
            }
            while(_loc6_ < MAX_SHIELD_CLIPS)
            {
               this.ShieldClips[_loc6_].UpdateFrame(1);
               _loc6_++;
            }
            this.LastMax = _loc3_;
         }
      }
   }
}
