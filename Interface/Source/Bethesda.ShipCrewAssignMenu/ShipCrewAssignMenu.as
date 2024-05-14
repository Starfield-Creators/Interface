package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.GlobalFunc;
   
   public class ShipCrewAssignMenu extends IMenu
   {
      
      private static const ShipCrewAssignMenu_Unassign:String = "ShipCrewAssignMenu_Unassign";
      
      private static const ShipCrewAssignMenu_Assign:String = "ShipCrewAssignMenu_Assign";
       
      
      public var PopupUnassign_mc:CrewUnassignConfirm;
      
      public var PopupAssign_mc:CrewAssignConfirm;
      
      private var CrewHandle:uint;
      
      private var Assign:Boolean;
      
      private var CrewInfo:Array;
      
      private var GotAssignData:Boolean = false;
      
      private var GotCrewData:Boolean = false;
      
      private var SelectedCrew:Object = null;
      
      public function ShipCrewAssignMenu()
      {
         this.CrewInfo = new Array();
         super();
         this.PopupUnassign_mc.ConfirmFunc = this.onUnassignConfirm;
         this.PopupAssign_mc.ConfirmFunc = this.onAssignConfirm;
         this.PopupUnassign_mc.CancelFunc = this.onCloseMenu;
         this.PopupAssign_mc.CancelFunc = this.onCloseMenu;
         this.PopupUnassign_mc.visible = false;
         this.PopupAssign_mc.visible = false;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ShipCrewData",this.OnReceivedPayloadData);
         BSUIDataManager.Subscribe("ShipCrewAssignData",this.OnAssignDataUpdate);
      }
      
      private function OnReceivedPayloadData(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.CrewInfo = _loc2_.CrewInfoA;
         this.GotCrewData = true;
         this.TryShowPopup();
      }
      
      private function OnAssignDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.CrewHandle = _loc2_.uHandle;
         this.Assign = _loc2_.bAssign;
         this.PopupAssign_mc.UpdateData(_loc2_.AssignmentCategoryA);
         this.GotAssignData = true;
         this.TryShowPopup();
      }
      
      private function TryShowPopup() : *
      {
         var _loc1_:Object = null;
         this.SelectedCrew = null;
         for each(_loc1_ in this.CrewInfo)
         {
            if(_loc1_.uHandle == this.CrewHandle)
            {
               this.SelectedCrew = _loc1_;
               break;
            }
         }
         if(this.SelectedCrew != null && this.GotAssignData && this.GotCrewData)
         {
            if(this.Assign)
            {
               this.PopupUnassign_mc.Hide();
               this.PopupAssign_mc.CurrentCrew = this.SelectedCrew;
               this.PopupAssign_mc.Show();
            }
            else
            {
               this.PopupAssign_mc.Hide();
               this.PopupUnassign_mc.SetMessageText("$ShipCrewUnassign",this.SelectedCrew.sName,this.SelectedCrew.sAssignment);
               this.PopupUnassign_mc.Show();
            }
         }
      }
      
      private function onUnassignConfirm() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralCancel");
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewAssignMenu_Unassign,{"uHandle":this.SelectedCrew.uAssignmentHandle}));
         this.onCloseMenu();
      }
      
      private function onAssignConfirm() : *
      {
         var _loc1_:* = this.PopupAssign_mc.SelectedEntry.uOccupiedCrewSlots + this.SelectedCrew.uSlotCost > this.PopupAssign_mc.SelectedEntry.uAvailableCrewSlots;
         if(!_loc1_)
         {
            GlobalFunc.PlayMenuSound("UIMenuGeneralOK");
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipCrewAssignMenu_Assign,{
               "uAssignHandle":this.PopupAssign_mc.SelectedEntry.uHandle,
               "uUnassignHandle":(this.SelectedCrew != null ? this.SelectedCrew.uAssignmentHandle : uint.MAX_VALUE)
            }));
            this.onCloseMenu();
         }
      }
      
      private function onCloseMenu() : *
      {
         GlobalFunc.CloseMenu("ShipCrewAssignMenu");
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.PopupUnassign_mc.visible)
         {
            _loc3_ = this.PopupUnassign_mc.ProcessUserEvent(param1,param2);
         }
         else if(this.PopupAssign_mc.visible)
         {
            _loc3_ = this.PopupAssign_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
   }
}
