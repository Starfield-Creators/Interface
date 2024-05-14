package
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonData.UserEventManager;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import flash.events.Event;
   
   public class FarTravelIconBase extends TargetIconBase
   {
      
      private static const FAR_TRAVEL_EVENT:String = "XButton";
      
      private static var FarTravelButtonHintData:ButtonBaseData = new ButtonBaseData("$JUMP TO",new UserEventData(FAR_TRAVEL_EVENT,null),false,false);
      
      private static var FarTravelButton:IButton;
      
      public static const FAR_TRAVEL_INITIATE_JUMP:String = "FarTravelInitiateJump";
       
      
      private var FarTravelUserEvent:UserEventManager;
      
      public function FarTravelIconBase()
      {
         this.FarTravelUserEvent = new UserEventManager([new UserEventData(FAR_TRAVEL_EVENT,this.onTravelHeld)]);
         super();
      }
      
      override protected function PopulateButtons() : *
      {
         super.PopulateButtons();
         if(FarTravelButton == null)
         {
            FarTravelButtonHintData.UserEvents = this.FarTravelUserEvent;
            FarTravelButton = ButtonFactory.AddToButtonBar("HoldButton",FarTravelButtonHintData,ButtonBar_mc);
         }
         ButtonBar_mc.RefreshButtons();
      }
      
      protected function onTravelHeld() : *
      {
         dispatchEvent(new Event(FAR_TRAVEL_INITIATE_JUMP,true));
      }
      
      override protected function UpdateButton(param1:IButton) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = false;
         if(param1 == FarTravelButton)
         {
            _loc3_ = Boolean(TargetOnlyData.bFarTravelAllowed);
            _loc4_ = _loc3_ && !TargetOnlyData.bFarTravelDisabled;
            _loc2_ = _loc3_ != param1.Visible || param1.Enabled != _loc4_;
            param1.Visible = _loc3_;
            param1.Enabled = _loc4_;
            if(FarTravelButtonHintData.UserEvents != this.FarTravelUserEvent)
            {
               FarTravelButtonHintData.UserEvents = this.FarTravelUserEvent;
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
