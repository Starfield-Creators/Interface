package
{
   import Shared.Components.ButtonControls.Buttons.TabTextButton;
   
   public class TabTextButton extends Shared.Components.ButtonControls.Buttons.TabTextButton
   {
      
      public static const STATE_DISABLED:String = "disabled";
       
      
      public function TabTextButton()
      {
         super();
         buttonStates.addState(STATE_DISABLED,["*"],{"enter":onClickEnter});
      }
      
      override public function SetSelected(param1:Boolean) : void
      {
         if(param1)
         {
            buttonStates.changeState(STATE_SELECTED);
         }
         else
         {
            buttonStates.changeState(Enabled ? STATE_UNSELECTED : STATE_DISABLED);
         }
      }
      
      override public function set Enabled(param1:Boolean) : void
      {
         if(bEnabled != param1)
         {
            bEnabled = param1;
            buttonStates.changeState(param1 ? STATE_UNSELECTED : STATE_DISABLED);
         }
      }
   }
}
