package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class AlertMessage extends BSDisplayObject
   {
      
      public static const STATE_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const STATE_MESSAGE:uint = EnumHelper.GetEnum();
      
      public static const STATE_WARNING:uint = EnumHelper.GetEnum();
      
      public static const STATE_ALERT:uint = EnumHelper.GetEnum();
      
      public static const ALERT_FLASH_PULSE_EVENT:String = "AlertFlashPulseEvent";
      
      public static const ENEMY_MISSILE_LOCKED_ON_SOUND:String = "UICockpitHUDMissileLockEnemyThreat";
       
      
      public var Message_mc:MovieClip;
      
      public var Warning_mc:MovieClip;
      
      public var Alert_mc:MovieClip;
      
      private var _lastState:* = "";
      
      private var _lastMessage:* = "";
      
      private var _isEnemyMissile:Boolean = false;
      
      public function AlertMessage()
      {
         super();
         TextFieldEx.setVerticalAlign(this.Message_mc.Text_tf,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(this.Warning_mc.Text_tf,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(this.Alert_mc.Text_tf,TextFieldEx.VALIGN_CENTER);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(ALERT_FLASH_PULSE_EVENT,this.OnAlertFlashPulseEvent);
      }
      
      public function SetStateAndMessage(param1:uint, param2:String, param3:Boolean) : *
      {
         if(this._lastState != param1 || this._lastMessage != param2)
         {
            switch(param1)
            {
               case STATE_MESSAGE:
                  gotoAndStop("Message");
                  GlobalFunc.SetText(this.Message_mc.Text_tf,param2);
                  break;
               case STATE_WARNING:
                  gotoAndStop("Warning");
                  GlobalFunc.SetText(this.Warning_mc.Text_tf,param2);
                  break;
               case STATE_ALERT:
                  gotoAndStop("Alert");
                  GlobalFunc.SetText(this.Alert_mc.Text_tf,param2);
                  break;
               case STATE_NONE:
                  gotoAndStop("None");
                  break;
               default:
                  GlobalFunc.TraceWarning("Unknown alert state");
            }
         }
         this._isEnemyMissile = param3;
      }
      
      public function OnAlertFlashPulseEvent(param1:Event) : *
      {
         if(this._isEnemyMissile)
         {
            GlobalFunc.PlayMenuSound(ENEMY_MISSILE_LOCKED_ON_SOUND);
         }
      }
   }
}
