package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class HailComponent extends BSDisplayObject
   {
      
      public static const ShipHud_HailCancelled:String = "ShipHud_HailCancelled";
      
      public static const ShipHud_HailAccepted:String = "ShipHud_HailAccepted";
      
      public static const HAIL_ACCEPTED:String = "OnHailAccepted";
      
      public static const HAIL_NOTIFICATION_SOUND:String = "UICockpitHUDNotificationHailNotification";
      
      public static const HAIL_ACCEPT_SOUND:String = "UICockpitHUDNotificationHailAccept";
      
      public static const HAIL_CANCEL_SOUND:String = "UICockpitHUDNotificationHailCancel";
      
      public static const HAIL_OPEN_SOUND:String = "UICockpitHUDNotificationHailOpen";
      
      public static const HAIL_CLOSE_SOUND:String = "UICockpitHUDNotificationHailClose";
      
      public static const HAIL_INCOMING_TRANSMISSION:String = "UICockpitHUDNotificationHailTransmissionIncoming";
      
      public static const HAIL_INCOMING_TRANSMISSION_STOP:String = "UICockpitHUDNotificationHailTransmissionIncoming_Stop";
      
      public static const HAIL_NOTIFICATION_PING_SOUND:String = "UICockpitHUDNotificationHailNotificationPing";
      
      public static const HAIL_ON_NOTIFICATION_PULSE_EVENT:String = "HailOnNotificationPulseEvent";
       
      
      public var Name_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var AcceptButtonHintData:ButtonBaseData;
      
      private var DeclineButtonHintData:ButtonBaseData;
      
      private var Name_tf:TextField;
      
      private var PendingHailArray:Array = null;
      
      private var CurrentTarget:Object = null;
      
      private var InScene:Boolean = false;
      
      private var bShown:Boolean = false;
      
      public function HailComponent()
      {
         this.AcceptButtonHintData = new ButtonBaseData("$ACCEPT",new UserEventData("SelectTarget",this.onAccept));
         this.DeclineButtonHintData = new ButtonBaseData("$IGNORE",new UserEventData("XButton",this.onIgnore));
         super();
         gotoAndStop("Idle");
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.AcceptButton,this.AcceptButtonHintData);
         this.ButtonBar_mc.AddButtonWithData(this.DeclineButton,this.DeclineButtonHintData);
         this.ButtonBar_mc.RefreshButtons();
         this.Name_tf = this.Name_mc.Text_tf;
      }
      
      private function get AcceptButton() : IButton
      {
         return this.ButtonBar_mc.AcceptButton_mc;
      }
      
      private function get DeclineButton() : IButton
      {
         return this.ButtonBar_mc.DeclineButton_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(HAIL_ON_NOTIFICATION_PULSE_EVENT,this.OnHailNotificationPulseSound);
      }
      
      private function OnReadyForNextHail() : *
      {
         if(!this.InScene && this.PendingHailArray != null && this.PendingHailArray.length > 0 && visible && (this.CurrentTarget == null || this.CurrentTarget.uHandle != this.PendingHailArray[0].uHandle))
         {
            this.CurrentTarget = this.PendingHailArray[0];
            this.Show();
         }
      }
      
      public function UpdateData(param1:Object) : *
      {
         this.PendingHailArray = param1.HailingDataA;
         this.InScene = Boolean(param1.bPlayerInDialogueScene) || Boolean(param1.bPlayerInScene);
         switch(currentFrameLabel)
         {
            case "Idle":
               this.OnReadyForNextHail();
               break;
            case "On":
               if(this.PendingHailArray.length == 0 || this.CurrentTarget.uHandle != this.PendingHailArray[0].uHandle)
               {
                  this.CurrentTarget = null;
                  this.Hide(false);
               }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(currentFrameLabel == "On")
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onAccept() : *
      {
         this.Hide(false);
         dispatchEvent(new Event(HAIL_ACCEPTED));
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_HailAccepted,{"uValue":this.CurrentTarget.uHandle}));
         GlobalFunc.PlayMenuSound(HAIL_ACCEPT_SOUND);
      }
      
      private function onIgnore() : *
      {
         this.Hide(false);
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_HailCancelled,{"uValue":this.CurrentTarget.uHandle}));
         GlobalFunc.PlayMenuSound(HAIL_CANCEL_SOUND);
      }
      
      private function Show() : *
      {
         GlobalFunc.SetText(this.Name_tf,this.CurrentTarget.sName);
         this.DeclineButton.Enabled = this.CurrentTarget.bCanBeCancelled;
         gotoAndPlay("rollOn");
         GlobalFunc.PlayMenuSound(HAIL_NOTIFICATION_SOUND);
         GlobalFunc.PlayMenuSound(HAIL_INCOMING_TRANSMISSION);
         this.bShown = true;
      }
      
      public function Hide(param1:Boolean) : *
      {
         if(param1)
         {
            gotoAndStop("Idle");
         }
         else
         {
            gotoAndPlay("rollOff");
            GlobalFunc.PlayMenuSound(HAIL_INCOMING_TRANSMISSION_STOP);
         }
         this.bShown = false;
      }
      
      public function OnHailNotificationPulseSound(param1:Event) : *
      {
         if(this.bShown)
         {
            GlobalFunc.PlayMenuSound(HAIL_NOTIFICATION_PING_SOUND);
         }
      }
   }
}
