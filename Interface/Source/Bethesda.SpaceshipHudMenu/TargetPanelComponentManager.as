package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.ShipPower.ShipComponentManager;
   import Shared.GlobalFunc;
   import Shared.ShipInfoUtils;
   
   public class TargetPanelComponentManager extends ShipComponentManager
   {
      
      public static const ShipHud_TargetShipSystem:String = "ShipHud_TargetShipSystem";
       
      
      public function TargetPanelComponentManager()
      {
         super();
      }
      
      override public function CycleTarget(param1:int) : Boolean
      {
         var _loc2_:Boolean = super.CycleTarget(param1);
         if(SelectedComponent != -1)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_TargetShipSystem,{"uValue":ComponentsArray[SelectedComponent].uPartIndex}));
         }
         return _loc2_;
      }
      
      public function Reset() : *
      {
         SelectedComponent = GetStartingClipIndexForComponentType(ShipInfoUtils.MT_SHIELD);
         if(SelectedComponent == -1)
         {
            GlobalFunc.TraceWarning("Failed to select the default ship component");
         }
      }
   }
}
