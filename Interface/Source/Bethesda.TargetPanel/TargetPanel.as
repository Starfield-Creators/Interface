package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.MinimalButton;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TargetPanel extends BSDisplayObject
   {
      
      public static const ShipHud_UntargetShipSystem:String = "ShipHud_UntargetShipSystem";
       
      
      public var ComponentManager_mc:TargetPanelComponentManager;
      
      public var ButtonHint_mc:MinimalButton;
      
      public var PCArrows_mc:MovieClip;
      
      public var NoSystem_mc:MovieClip;
      
      private var TargetOnlyData:Object;
      
      private var WasInTargetingMode:Boolean = false;
      
      private var LastTargetID:uint = 4294967295;
      
      private var LeftRightButtonHintData:ButtonBaseData;
      
      private var LeftRightAlternateButtonHintData:ButtonBaseData;
      
      private var SelectTargetData:ButtonBaseData;
      
      public function TargetPanel()
      {
         this.LeftRightButtonHintData = new ButtonBaseData("$SELECT SYSTEM",[new UserEventData("SelectLeft"),new UserEventData("SelectRight")],true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,false);
         this.LeftRightAlternateButtonHintData = new ButtonBaseData("$SELECT SYSTEM",[new UserEventData("Left"),new UserEventData("Right")],true,true,"",GlobalFunc.CANCEL_SOUND,GlobalFunc.FOCUS_SOUND,null,false);
         this.SelectTargetData = new ButtonBaseData("",new UserEventData("LeftStick",null));
         super();
         this.ButtonHint_mc.SetButtonData(this.SelectTargetData);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         visible = false;
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         this.ButtonHint_mc.visible = uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
         this.PCArrows_mc.visible = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
      
      private function UpdateSelectedTarget() : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:Object = null;
         visible = this.TargetOnlyData.bTargetModeActive;
         if(this.TargetOnlyData.bTargetModeActive)
         {
            _loc1_ = false;
            for each(_loc2_ in this.TargetOnlyData.targetComponentArray)
            {
               if(_loc2_.bTargetComponent)
               {
                  _loc1_ = true;
                  break;
               }
            }
            this.NoSystem_mc.visible = !_loc1_;
            if(!this.WasInTargetingMode && this.LastTargetID != this.TargetOnlyData.uniqueID)
            {
               this.LastTargetID = this.TargetOnlyData.uniqueID;
               this.ComponentManager_mc.Reset();
               this.ComponentManager_mc.CycleTarget(0);
            }
         }
         this.ComponentManager_mc.ComponentsArray = this.TargetOnlyData.targetComponentArray;
         this.ComponentManager_mc.UpdateComponentsArray();
         this.WasInTargetingMode = this.TargetOnlyData.bTargetModeActive;
      }
      
      public function UpdateTargetOnlyData(param1:Object) : *
      {
         this.TargetOnlyData = param1;
         this.UpdateSelectedTarget();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2 && !_loc3_ && this.TargetOnlyData != null && Boolean(this.TargetOnlyData.bTargetModeActive))
         {
            switch(param1)
            {
               case "SelectLeft":
                  this.ComponentManager_mc.CycleTarget(-1);
                  _loc3_ = true;
                  break;
               case "SelectRight":
                  this.ComponentManager_mc.CycleTarget(1);
                  _loc3_ = true;
                  break;
               case "SelectUp":
                  this.ComponentManager_mc.CycleTarget(0);
                  _loc3_ = true;
                  break;
               case "SelectDown":
                  BSUIDataManager.dispatchEvent(new Event(ShipHud_UntargetShipSystem));
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function GetCurrentLeftRightButtonHintData(param1:Boolean) : ButtonBaseData
      {
         return param1 ? this.LeftRightAlternateButtonHintData : this.LeftRightButtonHintData;
      }
   }
}
