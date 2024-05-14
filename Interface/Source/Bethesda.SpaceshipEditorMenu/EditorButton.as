package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   
   public class EditorButton extends ButtonBase
   {
       
      
      public function EditorButton()
      {
         super();
      }
      
      override protected function SendEvent(param1:UserEventData) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("ShipEditor_OnHintButtonActivated",{"buttonAction":param1.sCodeCallback}));
      }
   }
}
