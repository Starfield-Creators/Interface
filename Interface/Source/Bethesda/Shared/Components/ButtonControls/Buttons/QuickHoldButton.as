package Shared.Components.ButtonControls.Buttons
{
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   
   public class QuickHoldButton extends HoldButton
   {
       
      
      public function QuickHoldButton()
      {
         super();
      }
      
      override public function HandleUserEvent(param1:String, param2:Boolean, param3:Boolean) : Boolean
      {
         var asEventName:String = param1;
         var abPressed:Boolean = param2;
         var abHandled:Boolean = param3;
         var handled:Boolean = abHandled;
         if(Enabled)
         {
            Data.UserEvents.CallForMatchingData(asEventName,function(param1:UserEventData):*
            {
               if(abPressed)
               {
                  HeldEvent = param1;
                  if(HeldEvent.bEnabled && !FinishingAnimation)
                  {
                     StartHoldAnim();
                  }
               }
               else if(!FinishingAnimation)
               {
                  StopHoldAnim();
                  handled = true;
               }
               else
               {
                  handled = true;
               }
            });
         }
         return handled;
      }
   }
}
