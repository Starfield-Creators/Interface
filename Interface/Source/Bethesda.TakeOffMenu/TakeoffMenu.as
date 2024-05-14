package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.HoldButton;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class TakeoffMenu extends IMenu
   {
      
      public static const CLOSE_MENU_EVENT:* = "TakeoffMenu_CloseMenu";
      
      public static const LAUNCH_EVENT:* = "TakeoffMenu_Launch";
      
      public static const UNDOCK_EVENT:* = "TakeoffMenu_Undock";
      
      public static const EXIT_SHIP_EVENT:* = "TakeoffMenu_ExitShip";
      
      private static const DOCKING_SOUND:String = "UICockpitHUDDockSequence";
      
      private static const LANDING_SOUND:String = "UICockpitHUDLandSequence";
       
      
      public var TakeoffButton_mc:HoldButton;
      
      public var ExitSeatButton_mc:HoldButton;
      
      public var ExitShipButton_mc:HoldButton;
      
      public var State_mc:MovieClip;
      
      private var TakeoffButtonHintData:ButtonBaseData;
      
      private var ExitSeatButtonHintData:ButtonBaseData;
      
      private var ExitShipButtonHintData:ButtonBaseData;
      
      private var MyButtonManager:ButtonManager;
      
      public function TakeoffMenu()
      {
         this.TakeoffButtonHintData = new ButtonBaseData("$TAKE OFF",new UserEventData("TakeOff",this.OnTakeoffFinished));
         this.ExitSeatButtonHintData = new ButtonBaseData("$GET UP",new UserEventData("Cancel",this.OnExitSeatFinished));
         this.ExitShipButtonHintData = new ButtonBaseData("$EXIT SHIP",new UserEventData("ExitShip",this.OnExitShipFinished));
         this.MyButtonManager = new ButtonManager();
         super();
         this.TakeoffButton_mc.Visible = false;
         this.ExitSeatButton_mc.Visible = false;
         this.ExitShipButton_mc.Visible = true;
      }
      
      public function get State_tf() : TextField
      {
         return this.State_mc.Text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         this.ExitSeatButton_mc.SetButtonData(this.ExitSeatButtonHintData);
         this.ExitShipButton_mc.SetButtonData(this.ExitShipButtonHintData);
         this.TakeoffButton_mc.SetButtonData(this.TakeoffButtonHintData);
         this.MyButtonManager.AddButton(this.TakeoffButton_mc);
         this.MyButtonManager.AddButton(this.ExitSeatButton_mc);
         this.MyButtonManager.AddButton(this.ExitShipButton_mc);
         BSUIDataManager.Subscribe("TakeoffData",function(param1:FromClientDataEvent):*
         {
            if(param1.data.bUndockMode)
            {
               GlobalFunc.SetText(State_tf,"$DOCKED");
               GlobalFunc.PlayMenuSound(DOCKING_SOUND);
               TakeoffButtonHintData.sButtonText = "$UNDOCK";
               ExitShipButtonHintData.sButtonText = "$BOARD";
               TakeoffButton_mc.SetButtonData(TakeoffButtonHintData);
               ExitShipButton_mc.SetButtonData(ExitShipButtonHintData);
               TakeoffButton_mc.Enabled = Boolean(param1.data.bUndockEnabled) && Boolean(param1.data.bInputEnabled);
            }
            else
            {
               GlobalFunc.SetText(State_tf,"$LANDED");
               GlobalFunc.PlayMenuSound(LANDING_SOUND);
               TakeoffButtonHintData.sButtonText = "$TAKE OFF";
               ExitShipButtonHintData.sButtonText = "$EXIT SHIP";
               TakeoffButton_mc.SetButtonData(TakeoffButtonHintData);
               ExitShipButton_mc.SetButtonData(ExitShipButtonHintData);
               TakeoffButton_mc.Enabled = param1.data.bInputEnabled;
            }
         });
      }
      
      public function OnTakeoffFinished() : *
      {
         this.CloseMenu(LAUNCH_EVENT,this.TakeoffButton_mc);
      }
      
      public function OnExitSeatFinished() : *
      {
         this.CloseMenu(CLOSE_MENU_EVENT,this.ExitSeatButton_mc);
      }
      
      public function OnExitShipFinished() : *
      {
         this.CloseMenu(EXIT_SHIP_EVENT,this.ExitSeatButton_mc);
      }
      
      private function CloseMenu(param1:String, param2:IButton) : *
      {
         if(param2.Visible && param2.Enabled)
         {
            BSUIDataManager.dispatchEvent(new Event(param1,true));
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
   }
}
