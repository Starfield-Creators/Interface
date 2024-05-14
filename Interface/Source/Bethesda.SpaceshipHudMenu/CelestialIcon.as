package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonData.UserEventManager;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import flash.events.Event;
   
   public class CelestialIcon extends TargetIconBase
   {
      
      private static const JUMP_EVENT:String = "XButton";
      
      private static var QuestJumpButtonHintData:ButtonBaseData = new ButtonBaseData("$Quest",new UserEventData(JUMP_EVENT,null),false,false);
      
      private static var QuestJumpButton:IButton;
      
      public static const ShipHud_OpenMapWithStar:String = "ShipHud_OpenMapWithStar";
      
      public static const ShipHud_JumpToQuestMarker:String = "ShipHud_JumpToQuestMarker";
       
      
      private var QuestJumpUserEvent:UserEventManager;
      
      private var LastQuestTarget:Boolean = false;
      
      public function CelestialIcon()
      {
         this.QuestJumpUserEvent = new UserEventManager([new UserEventData(JUMP_EVENT,this.onQuestHeld)]);
         super();
      }
      
      override protected function PopulateButtons() : *
      {
         super.PopulateButtons();
         if(QuestJumpButton == null)
         {
            QuestJumpButton = ButtonFactory.AddToButtonBar("HoldButton",QuestJumpButtonHintData,ButtonBar_mc);
         }
         ButtonBar_mc.RefreshButtons();
      }
      
      protected function onQuestHeld() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipHud_JumpToQuestMarker));
      }
      
      override protected function UpdateButton(param1:IButton) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = false;
         if(param1 == QuestJumpButton)
         {
            _loc3_ = Boolean(TargetOnlyData.bFarTravelAllowed);
            _loc4_ = _loc3_ && !TargetOnlyData.bFarTravelDisabled;
            _loc2_ = _loc3_ != param1.Visible || param1.Enabled != _loc4_;
            param1.Visible = _loc3_;
            param1.Enabled = _loc4_;
            if(_loc3_ && QuestJumpButtonHintData.UserEvents != this.QuestJumpUserEvent)
            {
               QuestJumpButtonHintData.UserEvents = this.QuestJumpUserEvent;
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
