package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class HitDamageIndicatorClip extends MovieClip
   {
      
      public static const ANIM_FINISHED:String = "ANIM_FINISHED";
      
      private static const NORMAL_STATE:String = "Normal";
      
      private static const EM_STATE:String = "EM";
      
      private static const CRITICAL_STATE:String = "Crit";
      
      private static const MITIGATED_STATE:String = "Mitigated";
      
      private static const HORIZONTAL_DISTANCE:Number = 40;
      
      private static const VERTICAL_DISTANCE:Number = 35;
      
      private static const MITIGATED_VERTICAL_DISTANCE:Number = 20;
      
      private static const SPEED_AT_SPEED_UP:Number = 0.2;
      
      private static const SLOW_DOWN_ACCELERATION:Number = 0.03;
      
      private static const SPEED_UP_TIME:Number = 250;
      
      private static const FADE_OUT_TIME:Number = 500;
      
      private static const STATE_WAITING_FOR_DATA:uint = EnumHelper.GetEnum(0);
      
      private static const STATE_START_ANIMATION:uint = EnumHelper.GetEnum();
      
      private static const STATE_SPEED_IN_DIRECTION:uint = EnumHelper.GetEnum();
      
      private static const STATE_SLOW_DOWN:uint = EnumHelper.GetEnum();
      
      private static const STATE_FADE_OUT:uint = EnumHelper.GetEnum();
      
      private static const STATE_DONE:uint = EnumHelper.GetEnum();
       
      
      public var DamageNumberText_mc:MovieClip;
      
      private var currentState:uint;
      
      private var chosenAngle:Number = 0;
      
      private var currentSpeed:Number = 0.2;
      
      private var currentTime:Number = 0;
      
      private var timeLeft:Number = 0;
      
      public function HitDamageIndicatorClip()
      {
         this.currentState = STATE_WAITING_FOR_DATA;
         super();
         visible = false;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.chosenAngle = Math.random() * 2 * Math.PI;
      }
      
      public function ShowHitDamage(param1:Number, param2:Boolean, param3:Boolean) : *
      {
         if(param1 > 0)
         {
            visible = true;
            gotoAndStop(param2 ? MITIGATED_STATE : (param3 ? EM_STATE : NORMAL_STATE));
            this.currentState = STATE_START_ANIMATION;
            GlobalFunc.SetText(this.DamageNumberText_mc.text_tf,Math.ceil(param1).toString());
         }
      }
      
      public function ShowCriticalHitDamage(param1:Number) : *
      {
         if(param1 > 0)
         {
            visible = true;
            gotoAndStop(CRITICAL_STATE);
            this.currentState = STATE_START_ANIMATION;
            GlobalFunc.SetText(this.DamageNumberText_mc.text_tf,Math.round(param1).toString());
         }
      }
      
      private function onEnterFrame() : *
      {
         if(this.currentState == STATE_START_ANIMATION)
         {
            this.currentState = STATE_SPEED_IN_DIRECTION;
            this.currentTime = getTimer();
            this.timeLeft = SPEED_UP_TIME;
            this.currentSpeed = SPEED_AT_SPEED_UP;
         }
         else if(this.currentState == STATE_SPEED_IN_DIRECTION)
         {
            this.timeLeft -= getTimer() - this.currentTime;
            this.currentTime = getTimer();
            x += this.currentSpeed * Math.cos(this.chosenAngle) * HORIZONTAL_DISTANCE;
            y += this.currentSpeed * Math.sin(this.chosenAngle) * (currentFrameLabel == MITIGATED_STATE ? MITIGATED_VERTICAL_DISTANCE : VERTICAL_DISTANCE);
            if(this.timeLeft <= 0)
            {
               this.currentState = STATE_SLOW_DOWN;
            }
         }
         else if(this.currentState == STATE_SLOW_DOWN)
         {
            this.currentSpeed -= SLOW_DOWN_ACCELERATION;
            if(this.currentSpeed <= 0)
            {
               this.timeLeft = FADE_OUT_TIME;
               this.currentTime = getTimer();
               this.currentState = STATE_FADE_OUT;
            }
            else
            {
               x += this.currentSpeed * Math.cos(this.chosenAngle) * HORIZONTAL_DISTANCE;
               y += this.currentSpeed * Math.sin(this.chosenAngle) * (currentFrameLabel == MITIGATED_STATE ? MITIGATED_VERTICAL_DISTANCE : VERTICAL_DISTANCE);
            }
         }
         else if(this.currentState == STATE_FADE_OUT)
         {
            this.timeLeft -= getTimer() - this.currentTime;
            this.currentTime = getTimer();
            alpha = Math.max(this.timeLeft / FADE_OUT_TIME,0);
            if(this.timeLeft <= 0)
            {
               this.currentState = STATE_DONE;
               dispatchEvent(new Event(ANIM_FINISHED));
            }
         }
      }
   }
}
