package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.BSTabbedSelection;
   import Shared.AS3.BSTabbedSelectionEvent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.PlatformUtils;
   import scaleform.gfx.TextFieldEx;
   
   public class FlightCheck extends BSDisplayObject
   {
      
      private static const ShipEditor_OnFlightCheckTabChanged:String = "ShipEditor_OnFlightCheckTabChanged";
       
      
      public var FlightCheckCategories_mc:FlightCheckTabbedSelection;
      
      public var FlightCheckEntries_mc:BSScrollingContainer;
      
      public var WeaponAssignment_mc:WeaponAssignmentList;
      
      private const MKB:String = "MKB";
      
      private const Gamepad:String = "Gamepad";
      
      public function FlightCheck()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "FlightCheckEntry";
         _loc1_.DisableInput = true;
         _loc1_.DisableSelection = true;
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.FlightCheckEntries_mc.Configure(_loc1_);
         _loc1_ = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "WeaponAssignmentListEntry";
         _loc1_.DisableInput = false;
         _loc1_.DisableSelection = false;
         _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.WeaponAssignment_mc.Configure(_loc1_);
         this.FlightCheckCategories_mc.Configure(FlightCheckTab,BSTabbedSelection.CENTER_ALIGNED,BSTabbedSelection.DEFAULT_SPACING,["PrevCategory"],["NextCategory"]);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.FlightCheckCategories_mc.addEventListener(BSTabbedSelectionEvent.NAME,this.onTabChanged);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.FlightCheckCategories_mc.ProcessUserEvent(param1,param2);
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:uint) : Boolean
      {
         var _loc7_:Boolean = false;
         if(this.WeaponAssignment_mc.visible)
         {
            _loc7_ = this.WeaponAssignment_mc.OnLeftStickInput(param1,param2,param3,param4,param5,param6);
         }
         return _loc7_;
      }
      
      public function UpdateFlightCheck(param1:Object) : *
      {
         var _loc2_:Array = param1.aFlightCheckTabs;
         if(_loc2_.length > 0)
         {
            this.FlightCheckCategories_mc.SetTabsData(_loc2_);
         }
         this.FlightCheckEntries_mc.visible = param1.bShowMessages;
         this.WeaponAssignment_mc.visible = param1.bShowWeapons;
         if(param1.bShowMessages)
         {
            this.SetMessages(param1.aMessages);
         }
         else if(param1.bShowWeapons)
         {
            this.SetWeaponGroups(param1.aWeaponGroups);
            stage.focus = this.WeaponAssignment_mc;
            if(uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE)
            {
               this.WeaponAssignment_mc.RestoreCachedIndex();
            }
         }
      }
      
      private function SetMessages(param1:Array) : *
      {
         this.FlightCheckEntries_mc.InitializeEntries(param1);
      }
      
      private function SetWeaponGroups(param1:Array) : *
      {
         this.WeaponAssignment_mc.InitializeEntries(param1);
      }
      
      private function onTabChanged() : *
      {
         BSUIDataManager.dispatchCustomEvent(ShipEditor_OnFlightCheckTabChanged,{"tabType":this.FlightCheckCategories_mc.selectedEntry.iTabType});
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.FlightCheckCategories_mc.gotoAndStop(this.MKB);
         }
         else
         {
            this.FlightCheckCategories_mc.gotoAndStop(this.Gamepad);
         }
      }
      
      override protected function OnPlatformChanged(param1:Object) : void
      {
         super.OnPlatformChanged(param1);
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.FlightCheckCategories_mc.gotoAndStop(this.MKB);
         }
         else
         {
            this.FlightCheckCategories_mc.gotoAndStop(this.Gamepad);
         }
      }
   }
}
