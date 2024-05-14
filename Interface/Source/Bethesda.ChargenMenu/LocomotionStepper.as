package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   
   public class LocomotionStepper extends BodySelector
   {
       
      
      public function LocomotionStepper()
      {
         super();
         GlobalFunc.SetText(LabelText_mc.text_tf,"$Chargen_WalkStyle");
         BSUIDataManager.Subscribe("ChargenData",this.OnChargenDataChanged);
      }
      
      private function OnChargenDataChanged(param1:FromClientDataEvent) : void
      {
         if(param1.data.Sex != GetSelectedValue())
         {
            SetSelectedValue(param1.data.LocomotionType);
            Stepper_mc.index = param1.data.LocomotionType;
         }
      }
      
      override protected function onStepperValueChanged() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SwitchLocomotion",{"iType":GetValueIndex(Stepper_mc.index)}));
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_TRAIT_SELECT);
         CharGenMenu.characterDirty = true;
      }
   }
}
