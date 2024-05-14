package DataSlateMenu
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Buttons extends IMenu
   {
      
      public static const EVENT_ACCEPT_CLICKED:String = "DataSlateButtons_acceptClicked";
      
      public static const EVENT_CANCEL_CLICKED:String = "DataSlateButtons_cancelClicked";
       
      
      public var ButtonBar_mc:ButtonBar;
      
      private var ButtonBarRefreshTimer:Timer;
      
      private var PlayButtonData:ButtonBaseData;
      
      private var StopButtonData:ButtonBaseData;
      
      public function Buttons()
      {
         this.PlayButtonData = new ButtonBaseData("$HolotapePlay",new UserEventData("Accept"));
         this.StopButtonData = new ButtonBaseData("$HolotapeStop",new UserEventData("Accept"));
         super();
         BSUIDataManager.Subscribe("DataSlateData",this.onDataUpdate);
         this.ButtonBar_mc.visible = false;
         this.ButtonBar_mc.Initialize(this.ButtonBar_mc.JUSTIFY_CENTER);
         this.ButtonBar_mc.AcceptButton_mc.SetButtonData(this.StopButtonData);
         this.ButtonBar_mc.AddButton(this.ButtonBar_mc.AcceptButton_mc);
         this.ButtonBar_mc.CancelButton_mc.SetButtonData(new ButtonBaseData("$EXIT",new UserEventData("Cancel")));
         this.ButtonBar_mc.AddButton(this.ButtonBar_mc.CancelButton_mc);
         this.ButtonBar_mc.RefreshButtons();
         this.ButtonBarRefreshTimer = new Timer(60,1);
         this.ButtonBarRefreshTimer.addEventListener(TimerEvent.TIMER,this.handleButtonBarRefreshTimer);
         this.ButtonBarRefreshTimer.start();
      }
      
      private function handleButtonBarRefreshTimer(param1:TimerEvent) : *
      {
         this.ButtonBar_mc.visible = true;
         this.ButtonBarRefreshTimer = null;
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         this.StopButtonData.bVisible = param1.data.uType === DataSlateMenu.TYPE_AUDIO;
         this.PlayButtonData.bVisible = param1.data.uType === DataSlateMenu.TYPE_AUDIO;
         if(param1.data.bAudioIsPlaying)
         {
            this.ButtonBar_mc.AcceptButton_mc.SetButtonData(this.StopButtonData);
         }
         else
         {
            this.ButtonBar_mc.AcceptButton_mc.SetButtonData(this.PlayButtonData);
         }
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2 && param1 == "Click")
         {
            if(this.ButtonBar_mc.AcceptButton_mc.IsMouseOver)
            {
               BSUIDataManager.dispatchEvent(new Event(EVENT_ACCEPT_CLICKED));
            }
            if(this.ButtonBar_mc.CancelButton_mc.IsMouseOver)
            {
               BSUIDataManager.dispatchEvent(new Event(EVENT_CANCEL_CLICKED));
            }
         }
         return false;
      }
   }
}
