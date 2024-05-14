package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GravJumpAnim extends MovieClip
   {
      
      public static const GRAV_JUMP_INITIATED:String = "GravJumpInitiated";
       
      
      public var Countdown_mc:MovieClip;
      
      public var JumpPercentText_mc:MovieClip;
      
      private var LastSeconds:uint = 0;
      
      private var LastAnimFrame:uint = 0;
      
      private var bWasGravJumping:Boolean = false;
      
      protected var EndFrameTimePercent:Number;
      
      public function GravJumpAnim()
      {
         super();
         this.SetEndFrame();
      }
      
      public function get WasGravJumping() : Boolean
      {
         return this.bWasGravJumping;
      }
      
      public function get Countdown_tf() : TextField
      {
         return this.Countdown_mc.Text_tf;
      }
      
      public function get JumpPercentText_tf() : TextField
      {
         return this.JumpPercentText_mc.jumpPercent_tf;
      }
      
      protected function SetEndFrame() : *
      {
         this.EndFrameTimePercent = 1;
      }
      
      public function Hide() : *
      {
         gotoAndStop(framesLoaded);
      }
      
      public function RefreshGravJumpComponent(param1:Object) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:* = null;
         if(param1.gravJumpCalculatedPercentage > 0 || Boolean(param1.bGravJumpAnimStarted))
         {
            if(param1.fGravJump_SecsUntilJump < 0 && !param1.bGravJumpAnimStarted)
            {
               GlobalFunc.SetText(this.Countdown_tf,"--:--");
            }
            else
            {
               _loc3_ = param1.fGravJump_SecsUntilJump / (1 - param1.gravJumpCalculatedPercentage);
               _loc4_ = _loc3_ * this.EndFrameTimePercent;
               _loc5_ = Math.max(param1.fGravJump_SecsUntilJump - _loc4_,0);
               _loc6_ = Math.floor(_loc5_);
               if(this.LastSeconds != _loc6_)
               {
                  GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceXSecond");
                  this.LastSeconds = _loc6_;
               }
               _loc7_ = (_loc5_ - _loc6_) * 100;
               _loc8_ = "";
               if(_loc6_ < 10)
               {
                  _loc8_ = (_loc8_ += "0") + _loc6_;
               }
               else if(_loc6_ > 99)
               {
                  _loc8_ += "99";
               }
               else
               {
                  _loc8_ += _loc6_;
               }
               _loc8_ += ":";
               if(_loc7_ < 10)
               {
                  _loc8_ = (_loc8_ += "0") + _loc7_;
               }
               else if(_loc7_ > 99)
               {
                  _loc8_ += "99";
               }
               else
               {
                  _loc8_ += _loc7_;
               }
               GlobalFunc.SetText(this.Countdown_tf,_loc8_);
            }
            GlobalFunc.SetText(this.JumpPercentText_tf,Math.round(param1.gravJumpCalculatedPercentage * 100).toString() + "%");
            _loc2_ = Math.floor(GlobalFunc.MapLinearlyToRange(1,framesLoaded,0,1,param1.gravJumpCalculatedPercentage,true));
            if(this.LastAnimFrame != _loc2_)
            {
               gotoAndStop(_loc2_);
               this.LastAnimFrame = _loc2_;
            }
            this.bWasGravJumping = true;
         }
         else
         {
            this.Hide();
            this.bWasGravJumping = false;
         }
      }
      
      protected function PlayLoad() : *
      {
         GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceBLoad");
      }
      
      protected function PlayMod() : *
      {
         GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceCMod");
      }
      
      protected function PlaySpool() : *
      {
         GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceDSpool");
      }
      
      protected function PlayCalc() : *
      {
         GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceECalc");
      }
      
      protected function PlayReady() : *
      {
         GlobalFunc.PlayMenuSound("UICockpitHUDAGravJumpSequenceYReady");
      }
   }
}
