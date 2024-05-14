package Components
{
   import Shared.GlobalFunc;
   import flash.events.MouseEvent;
   
   public class DataMenuUniversalBackButton extends BSButton
   {
       
      
      public function DataMenuUniversalBackButton()
      {
         super();
      }
      
      override public function onRollover(param1:MouseEvent) : *
      {
         super.onRollover(param1);
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      override public function onRollout() : *
      {
         super.onRollout();
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
   }
}
