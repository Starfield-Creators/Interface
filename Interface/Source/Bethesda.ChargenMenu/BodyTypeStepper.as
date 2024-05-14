package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   
   public class BodyTypeStepper extends BodySelector
   {
      
      public static const TYPE_1:uint = 0;
      
      public static const TYPE_2:uint = 1;
      
      public static const ON_BODY_TYPE_CHANGED:String = "OnBodyTypeChanged";
       
      
      public function BodyTypeStepper()
      {
         super();
         GlobalFunc.SetText(LabelText_mc.text_tf,"$Chargen_BodyType");
         BSUIDataManager.Subscribe("ChargenData",this.OnChargenDataChanged);
      }
      
      private function OnChargenDataChanged(param1:FromClientDataEvent) : void
      {
         if(param1.data.Sex != GetSelectedValue())
         {
            SetSelectedValue(param1.data.Sex);
            Stepper_mc.index = param1.data.Sex;
         }
      }
      
      override protected function onStepperValueChanged() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SwitchBodyType",{"iType":GetValueIndex(Stepper_mc.index)}));
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_TRAIT_SELECT);
         stage.dispatchEvent(new CustomEvent(ON_BODY_TYPE_CHANGED,{"iBodyType":GetValueIndex(Stepper_mc.index)}));
         CharGenMenu.characterDirty = true;
      }
   }
}
