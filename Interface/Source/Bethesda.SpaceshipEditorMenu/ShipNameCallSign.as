package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ShipNameCallSign extends BSDisplayObject
   {
       
      
      public var PreviousShip_mc:IButton;
      
      public var NextShip_mc:IButton;
      
      public var ShipName_mc:MovieClip;
      
      public var CallSign_mc:MovieClip;
      
      public var ShipCount_mc:MovieClip;
      
      public var HomeshipText_mc:MovieClip;
      
      private const SpaceshipInfoMenu_NextShip:String = "SpaceshipInfoMenu_NextShip";
      
      private const SpaceshipInfoMenu_PreviousShip:String = "SpaceshipInfoMenu_PreviousShip";
      
      public function ShipNameCallSign()
      {
         super();
      }
      
      private function get ShipNameText() : TextField
      {
         return this.ShipName_mc.text_tf;
      }
      
      private function get CallSignText() : TextField
      {
         return this.CallSign_mc.CallSignText_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ShipNameData",this.onShipNameDataUpdate);
         BSUIDataManager.Subscribe("ShipCountData",this.onShipCountDataUpdate);
         this.PreviousShip_mc.SetButtonData(new ButtonBaseData("",[new UserEventData("PreviousShip",this.onPreviousShip)]));
         this.NextShip_mc.SetButtonData(new ButtonBaseData("",[new UserEventData("NextShip",this.onNextShip)]));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         return this.PreviousShip_mc.HandleUserEvent(param1,param2,_loc3_) || this.NextShip_mc.HandleUserEvent(param1,param2,_loc3_);
      }
      
      public function SetButtonsEnabled(param1:Boolean, param2:Boolean) : void
      {
         this.PreviousShip_mc.Enabled = param1;
         this.NextShip_mc.Enabled = param2;
      }
      
      public function SetButtonsVisible(param1:Boolean) : void
      {
         this.PreviousShip_mc.Visible = param1;
         this.NextShip_mc.Visible = param1;
      }
      
      private function onShipNameDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         GlobalFunc.SetText(this.ShipNameText,_loc2_.sShipName);
         GlobalFunc.SetText(this.CallSignText,_loc2_.sShipCallsign);
         this.HomeshipText_mc.visible = _loc2_.bIsHomeShip;
      }
      
      private function onShipCountDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         this.visible = _loc2_.uCurrentShipCount > 0;
         GlobalFunc.SetText(this.ShipCount_mc.text_tf,"$SHIP");
         var _loc3_:String = this.ShipCount_mc.text_tf.text + " " + (_loc2_.uCurrentShipIndex + 1) + "/" + _loc2_.uCurrentShipCount;
         GlobalFunc.SetText(this.ShipCount_mc.text_tf,_loc3_);
      }
      
      private function onPreviousShip() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_OnHintButtonActivated",{"buttonAction":"PreviousShip"}));
      }
      
      private function onNextShip() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_OnHintButtonActivated",{"buttonAction":"NextShip"}));
      }
   }
}
