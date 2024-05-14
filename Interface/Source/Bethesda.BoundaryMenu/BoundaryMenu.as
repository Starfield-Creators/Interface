package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   
   public class BoundaryMenu extends IMenu
   {
       
      
      public var ButtonBar_mc:ButtonBar;
      
      private const EVENT_FAST_TRAVEL:String = "BoundaryMenu_FastTravel";
      
      private const EVENT_SHOW_MAP:String = "BoundaryMenu_ShowMap";
      
      public function BoundaryMenu()
      {
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER);
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.ReturnToShipButton_mc,new ButtonBaseData("$FAST TRAVEL SHIP",[new UserEventData("YButton",this.onReturnToShip)]));
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.ShowMapButton_mc,new ButtonBaseData("$OPEN_PLANET_MAP",[new UserEventData("XButton",this.onShowMap)]));
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.CancelButton_mc,new ButtonBaseData("$CANCEL",[new UserEventData("Cancel",this.onCancel)]));
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function onReturnToShip() : void
      {
         BSUIDataManager.dispatchCustomEvent(this.EVENT_FAST_TRAVEL);
      }
      
      private function onShowMap() : void
      {
         BSUIDataManager.dispatchCustomEvent(this.EVENT_SHOW_MAP);
      }
      
      private function onCancel() : void
      {
         GlobalFunc.CloseMenu("BoundaryMenu");
      }
   }
}
