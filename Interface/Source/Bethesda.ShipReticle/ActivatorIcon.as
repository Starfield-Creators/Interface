package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonData.UserEventManager;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import flash.events.Event;
   
   public class ActivatorIcon extends TargetIconBase
   {
      
      private static const ACTIVATE_EVENT:String = "XButton";
      
      private static var ActivateButtonHintData:ButtonBaseData = new ButtonBaseData("$Activate",new UserEventData(ACTIVATE_EVENT,null),false,false);
      
      private static var ActivateButton:ReticleBaseButton;
      
      public static const ShipHud_Activate:String = "ShipHud_Activate";
       
      
      private var ActivateUserEvent:UserEventManager;
      
      public function ActivatorIcon()
      {
         this.ActivateUserEvent = new UserEventManager([new UserEventData(ACTIVATE_EVENT,this.onActivatePressed)]);
         super();
      }
      
      override protected function PopulateButtons() : *
      {
         super.PopulateButtons();
         if(ActivateButton == null)
         {
            ActivateButton = ButtonFactory.AddToButtonBar("ReticleBaseButton",ActivateButtonHintData,ButtonBar_mc) as ReticleBaseButton;
         }
         ButtonBar_mc.RefreshButtons();
      }
      
      private function onActivatePressed() : *
      {
         if(TargetOnlyData != null && TargetOnlyData.bActivateAllowed && !TargetOnlyData.bActivateDisabled)
         {
            BSUIDataManager.dispatchEvent(new Event(ShipHud_Activate));
         }
      }
      
      override protected function UpdateButton(param1:IButton) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc2_:Boolean = false;
         if(param1 == ActivateButton)
         {
            _loc3_ = String(TargetOnlyData.sActivateText);
            if(ActivateButtonHintData.sButtonText != _loc3_)
            {
               ActivateButtonHintData.sButtonText = _loc3_;
               ActivateButton.SetButtonData(ActivateButtonHintData);
               _loc2_ = true;
            }
            _loc5_ = (_loc4_ = Boolean(TargetOnlyData.bActivateAllowed)) && !TargetOnlyData.bActivateDisabled;
            _loc2_ = _loc2_ || _loc4_ != param1.Visible || param1.Enabled != _loc5_;
            param1.Visible = _loc4_;
            param1.Enabled = _loc5_;
            if(ActivateButtonHintData.UserEvents != this.ActivateUserEvent)
            {
               ActivateButtonHintData.UserEvents = this.ActivateUserEvent;
            }
         }
         else
         {
            _loc2_ = super.UpdateButton(param1);
         }
         return _loc2_;
      }
   }
}
