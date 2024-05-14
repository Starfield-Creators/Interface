package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class PersuasionData extends MovieClip
   {
      
      public static const CLOSE_PERSUASION_DATA_AFTER_SUCCESS_FAIL:String = "ClosePersuasionDataAfterSuccessFail";
       
      
      public var PersuasionLabel_tf:TextField;
      
      public var TurnsData_mc:MovieClip;
      
      public var ScoreMeter_mc:MovieClip;
      
      public var SuccessAnim_mc:MovieClip;
      
      public var FailAnim_mc:MovieClip;
      
      private var ScoreMeterBarsA:Array;
      
      private var CurrScore:uint = 4294967295;
      
      private var PlayTurnChangeAnim:Boolean = false;
      
      private var ClosePersuasionDataTimer:Timer;
      
      public const TIMELINE_EVENT_SUCCESS_DONE:String = "onSuccessAnimDone";
      
      private const SFX_RESPONSE_SUCCESS:String = "UIMenuSpeechChallengeResponseSuccess";
      
      private const SFX_RESPONSE_FAIL:String = "UIMenuSpeechChallengeResponseFail";
      
      private const SFX_GAME_SUCCESS:String = "UIMenuSpeechChallengeGameSuccess";
      
      private const SFX_GAME_FAIL:String = "UIMenuSpeechChallengeGameFail";
      
      private const CLOSE_PERSUASION_DATA_AFTER_SUCCESS_FAIL_TIME:Number = 5000;
      
      public function PersuasionData()
      {
         this.ScoreMeterBarsA = new Array();
         this.ClosePersuasionDataTimer = new Timer(this.CLOSE_PERSUASION_DATA_AFTER_SUCCESS_FAIL_TIME,1);
         super();
         this.ClosePersuasionDataTimer.stop();
         this.ClosePersuasionDataTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onClosePersuasionDataTimerEvent);
      }
      
      public function set numTurns(param1:uint) : void
      {
         if(param1 >= 10)
         {
            GlobalFunc.SetText(this.TurnsData_mc.Text_mc.text_tf,param1.toString());
         }
         else
         {
            GlobalFunc.SetText(this.TurnsData_mc.Text_mc.text_tf,"0" + param1);
         }
         if(this.PlayTurnChangeAnim === true)
         {
            this.TurnsData_mc.gotoAndPlay("onChange");
            this.PlayTurnChangeAnim = false;
         }
      }
      
      public function QueueTurnsChangeAnim() : void
      {
         this.PlayTurnChangeAnim = true;
      }
      
      public function SetPersuasionScore(param1:uint, param2:int = -1) : void
      {
         GlobalFunc.BSASSERT(this.ScoreMeterBarsA.length > 0,"Score meter array is empty.  Can\'t set value yet!");
         var _loc3_:uint = 0;
         while(_loc3_ < this.ScoreMeterBarsA.length)
         {
            if(param2 > 0 && this.CurrScore != uint.MAX_VALUE)
            {
               if(param1 > this.CurrScore && _loc3_ < param1 && _loc3_ >= param1 - param2)
               {
                  this.SuccessAnim_mc.gotoAndPlay("Success");
                  this.ScoreMeterBarsA[_loc3_].gotoAndPlay("Success");
               }
               else if(param1 <= this.CurrScore && _loc3_ >= param1 && _loc3_ < param1 + param2)
               {
                  this.FailAnim_mc.gotoAndPlay("Flash");
                  this.ScoreMeterBarsA[_loc3_].gotoAndPlay("Fail_to_Off");
               }
            }
            else
            {
               this.ScoreMeterBarsA[_loc3_].gotoAndStop(_loc3_ < param1 ? "On" : "Off");
            }
            _loc3_++;
         }
         if(param2 > 0 && this.CurrScore != uint.MAX_VALUE)
         {
            if(param1 > this.CurrScore)
            {
               GlobalFunc.PlayMenuSound(this.SFX_RESPONSE_SUCCESS);
            }
            else
            {
               GlobalFunc.PlayMenuSound(this.SFX_RESPONSE_FAIL);
            }
         }
         this.CurrScore = param1;
      }
      
      public function PlayAutoWinAnim(param1:Boolean) : void
      {
         this.SuccessAnim_mc.gotoAndPlay("Success");
         this.doNextAutoWinAnim();
         if(param1)
         {
            GlobalFunc.PlayMenuSound(this.SFX_GAME_SUCCESS);
         }
      }
      
      public function PlayCriticalSuccessAnim() : void
      {
         this.DoSuccessClipAnim("CriticalSuccess");
         GlobalFunc.PlayMenuSound(this.SFX_GAME_SUCCESS);
      }
      
      private function doNextAutoWinAnim() : void
      {
         if(this.CurrScore < this.ScoreMeterBarsA.length)
         {
            if(!hasEventListener(this.TIMELINE_EVENT_SUCCESS_DONE))
            {
               addEventListener(this.TIMELINE_EVENT_SUCCESS_DONE,this.doNextAutoWinAnim);
            }
            this.ScoreMeterBarsA[this.CurrScore++].gotoAndPlay("Success");
         }
         else
         {
            if(hasEventListener(this.TIMELINE_EVENT_SUCCESS_DONE))
            {
               removeEventListener(this.TIMELINE_EVENT_SUCCESS_DONE,this.doNextAutoWinAnim);
            }
            this.DoSuccessClipAnim("WinGame");
         }
      }
      
      public function PlayFailureAnim() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.ScoreMeterBarsA.length)
         {
            if(this.ScoreMeterBarsA[_loc1_].currentFrameLabel == "On")
            {
               this.ScoreMeterBarsA[_loc1_].gotoAndPlay("Fail_to_On");
            }
            else
            {
               this.ScoreMeterBarsA[_loc1_].gotoAndPlay("Fail_to_Off");
            }
            _loc1_++;
         }
         this.DoSuccessClipAnim("LoseGame");
         GlobalFunc.PlayMenuSound(this.SFX_GAME_FAIL);
      }
      
      private function DoSuccessClipAnim(param1:String) : void
      {
         this.ScoreMeter_mc.visible = false;
         this.PersuasionLabel_tf.visible = false;
         this.SuccessAnim_mc.gotoAndPlay(param1);
         this.ClosePersuasionDataTimer.reset();
         this.ClosePersuasionDataTimer.start();
      }
      
      public function ResetGameElements() : void
      {
         this.ScoreMeter_mc.visible = true;
         this.PersuasionLabel_tf.visible = true;
         this.SuccessAnim_mc.gotoAndStop("Off");
      }
      
      public function set maxPersuasionScore(param1:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc2_:int = param1 - this.ScoreMeterBarsA.length;
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               (_loc4_ = new PersuasionMeter_Bar()).name = "ScoreRect" + _loc3_ + "_mc";
               if(this.ScoreMeterBarsA.length > 0)
               {
                  _loc4_.x = this.ScoreMeterBarsA[this.ScoreMeterBarsA.length - 1].x + this.ScoreMeterBarsA[this.ScoreMeterBarsA.length - 1].width;
               }
               this.ScoreMeter_mc.addChild(_loc4_);
               this.ScoreMeterBarsA.push(_loc4_);
               _loc3_++;
            }
         }
         else if(_loc2_ < 0)
         {
            _loc5_ = 0;
            while(_loc5_ < -_loc2_)
            {
               this.ScoreMeter_mc.removeChild(this.ScoreMeterBarsA[this.ScoreMeterBarsA.length - 1 - _loc5_]);
               _loc5_++;
            }
            this.ScoreMeterBarsA.splice(_loc2_,-_loc2_);
         }
      }
      
      private function onClosePersuasionDataTimerEvent(param1:TimerEvent) : *
      {
         this.dispatchEvent(new Event(CLOSE_PERSUASION_DATA_AFTER_SUCCESS_FAIL));
      }
      
      public function HidePersuasionDataElements() : *
      {
         gotoAndPlay("Close_PersuasionData");
         this.ClosePersuasionDataTimer.stop();
      }
   }
}
