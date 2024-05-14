package
{
   import Components.LabeledMeterMC;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ShipRefuelMenu extends IMenu
   {
      
      private static const HOLD_DELAY_TIMER_MS:int = 200;
       
      
      public var FuelMeter_mc:LabeledMeterMC;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var HoldStartDelayTimer:Timer = null;
      
      private var ContainerFuel:int = 0;
      
      private var ShipFuel:Number = 0;
      
      private var ShipFuelMax:Number = 0;
      
      private var FillDirection:int = 0;
      
      private var CurrentFuelDelta:int = 0;
      
      private var UsingStick:Boolean = false;
      
      public function ShipRefuelMenu()
      {
         super();
         this.FuelMeter_mc.SetLabel("$SHIP TANK");
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.AcceptButton_mc,new ButtonBaseData("$ACCEPT",new UserEventData("Accept",this.OnAccept)));
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.CancelButton_mc,new ButtonBaseData("$Cancel",new UserEventData("Cancel",this.OnCancel)));
         this.ButtonBar_mc.RefreshButtons();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("RefuelMenuData",this.OnDataChanged);
         BSUIDataManager.Subscribe("RefuelStickData",this.OnStickInput);
         this.HoldStartDelayTimer = new Timer(HOLD_DELAY_TIMER_MS,1);
      }
      
      private function OnDataChanged(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.FuelMeter_mc.SetMaxValue(_loc2_.fMaxFuel);
         this.FuelMeter_mc.SetCurrentValue(_loc2_.fCurrentFuel);
         this.FuelMeter_mc.SetLabelPrecision(0);
         this.ContainerFuel = _loc2_.iContainerItemsAvailable;
         this.CurrentFuelDelta = Math.min(this.ContainerFuel,Math.ceil(_loc2_.fMaxFuel - _loc2_.fCurrentFuel) as int);
         this.ShipFuel = _loc2_.fCurrentFuel;
         this.ShipFuelMax = _loc2_.fMaxFuel;
         this.UpdateFuelDelta();
      }
      
      private function OnStickInput(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_.iXDirection == 0)
         {
            if(this.UsingStick && this.FillDirection != 0)
            {
               this.OnReleaseFillDirection();
            }
         }
         else if(this.UsingStick || this.FillDirection == 0)
         {
            this.FillDirection = _loc2_.iXDirection;
            this.UsingStick = true;
            this.OnHoldFillDirection();
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            if(param2)
            {
               switch(param1)
               {
                  case "StrafeLeft":
                  case "Left":
                     if(this.FillDirection == 0 || !this.UsingStick)
                     {
                        this.FillDirection = -1;
                        this.UsingStick = false;
                        this.OnHoldFillDirection();
                     }
                     break;
                  case "StrafeRight":
                  case "Right":
                     if(this.FillDirection == 0 || !this.UsingStick)
                     {
                        this.FillDirection = 1;
                        this.UsingStick = false;
                        this.OnHoldFillDirection();
                     }
               }
            }
            else
            {
               switch(param1)
               {
                  case "StrafeLeft":
                  case "Left":
                     if(this.FillDirection < 0 && !this.UsingStick)
                     {
                        this.OnReleaseFillDirection();
                     }
                     break;
                  case "StrafeRight":
                  case "Right":
                     if(this.FillDirection > 0 && !this.UsingStick)
                     {
                        this.OnReleaseFillDirection();
                     }
               }
            }
         }
         return _loc3_;
      }
      
      private function OnAccept() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("Refuel_Accept",{"iAmmount":this.CurrentFuelDelta}));
      }
      
      private function OnCancel() : *
      {
         BSUIDataManager.dispatchEvent(new Event("Refuel_Cancel"));
      }
      
      private function OnHoldFillDirection() : *
      {
         this.HoldStartDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.OnHoldDelayCompleted);
         this.HoldStartDelayTimer.reset();
         this.HoldStartDelayTimer.start();
         this.UpdateFuelDelta();
      }
      
      private function OnReleaseFillDirection() : *
      {
         this.FillDirection = 0;
         this.HoldStartDelayTimer.stop();
         removeEventListener(Event.ENTER_FRAME,this.UpdateFuelDelta);
      }
      
      private function OnHoldDelayCompleted() : *
      {
         this.HoldStartDelayTimer.stop();
         addEventListener(Event.ENTER_FRAME,this.UpdateFuelDelta);
      }
      
      private function UpdateFuelDelta() : *
      {
         var _loc1_:Number = this.ShipFuel + this.CurrentFuelDelta + this.FillDirection;
         var _loc2_:Number = this.ShipFuelMax - this.ShipFuel;
         if(_loc1_ < this.ShipFuel)
         {
            this.CurrentFuelDelta = 0;
         }
         else if(_loc1_ >= this.ShipFuelMax + 1)
         {
            this.CurrentFuelDelta = Math.ceil(_loc2_);
         }
         else
         {
            this.CurrentFuelDelta = _loc1_ - this.ShipFuel;
         }
         if(this.CurrentFuelDelta > this.ContainerFuel)
         {
            this.CurrentFuelDelta = this.ContainerFuel;
         }
         var _loc3_:* = Math.min(this.CurrentFuelDelta,_loc2_);
         this.FuelMeter_mc.SetCurrentValue(this.ShipFuel,_loc3_);
      }
   }
}
