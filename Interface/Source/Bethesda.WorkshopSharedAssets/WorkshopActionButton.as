package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.Buttons.ReleaseHoldComboButton;
   import Shared.WorkshopUtils;
   import flash.events.Event;
   
   public class WorkshopActionButton extends ReleaseHoldComboButton
   {
       
      
      public var buttonAction:uint = 0;
      
      public function WorkshopActionButton()
      {
         super();
      }
      
      override protected function StartHoldAnim() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(WorkshopUtils.SET_ACTION_HANDLES,{"actionType":this.buttonAction}));
         super.StartHoldAnim();
      }
      
      override protected function StopHoldAnim() : *
      {
         if(finishingAnimation)
         {
            if(Enabled && HeldEvent.bEnabled && HeldEvent.funcCallback != null)
            {
               HeldEvent.funcCallback();
            }
            if(Enabled && HeldEvent.bEnabled && HeldEvent.sCodeCallback.length > 0)
            {
               SendEvent(HeldEvent);
            }
         }
         BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopActionButton_HoldStopped",{"actionType":this.buttonAction}));
         super.StopHoldAnim();
      }
      
      override protected function OnHoldFinished(param1:Event) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("WorkshopActionButton_HoldFinished",{"actionType":this.buttonAction}));
         super.OnHoldFinished(param1);
      }
   }
}
