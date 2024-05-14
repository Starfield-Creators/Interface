package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class CrewAssignConfirm extends ConfirmationPopup
   {
       
      
      public var AssignmentList_mc:ScrollingList;
      
      private var MySelectedEntry:Object = null;
      
      private var HasEntries:Boolean = false;
      
      public var NoAssignmentsTip_mc:MovieClip;
      
      private var MyCurrentCrew:Object;
      
      public function CrewAssignConfirm()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 3;
         _loc1_.EntryClassName = "AssignmentListEntry";
         this.AssignmentList_mc.Configure(_loc1_);
         this.AssignmentList_mc.SetFilterComparitor(this.AssignmentFilterComparitor);
         this.AssignmentList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.SelectedItem);
         this.AssignmentList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,onConfirm);
         this.AssignmentList_mc.visible = true;
         ConfirmButton.Enabled = false;
         ConfirmButton.Visible = false;
         stage.focus = this.AssignmentList_mc;
         ButtonBar_mc.RefreshButtons();
      }
      
      public function get NoAssignmentsTip_tf() : TextField
      {
         return this.NoAssignmentsTip_mc.Text_tf;
      }
      
      public function get SelectedEntry() : Object
      {
         return this.MySelectedEntry;
      }
      
      public function set CurrentCrew(param1:Object) : *
      {
         if(this.MyCurrentCrew != param1)
         {
            this.MyCurrentCrew = param1;
            this.UpdateMessageText();
         }
      }
      
      public function UpdateData(param1:Array) : *
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            for each(_loc5_ in _loc4_.AssignmentInfoA)
            {
               if(_loc5_.uOccupiedCrewSlots < _loc5_.uTotalCrewSlots)
               {
                  _loc3_.push(_loc5_);
               }
               else
               {
                  _loc2_.push(_loc5_);
               }
            }
         }
         this.AssignmentList_mc.InitializeEntries(_loc3_.concat(_loc2_));
         this.HasEntries = _loc3_.length > 0 || _loc2_.length > 0;
         if(this.HasEntries)
         {
            this.AssignmentList_mc.selectedIndex = 0;
         }
      }
      
      private function SelectedItem(param1:ScrollingEvent) : void
      {
         this.MySelectedEntry = this.AssignmentList_mc.selectedEntry;
         this.UpdateMessageText();
      }
      
      private function UpdateMessageText() : *
      {
         if(this.MyCurrentCrew != null)
         {
            if(this.MySelectedEntry != null)
            {
               ConfirmButton.Enabled = this.AssignmentList_mc.selectedEntry != null && this.AssignmentList_mc.selectedEntry.uOccupiedCrewSlots < this.AssignmentList_mc.selectedEntry.uAvailableCrewSlots;
               ConfirmButton.Visible = ConfirmButton.Enabled;
               SetMessageText(this.MyCurrentCrew.sAssignment == "" ? "$ShipCrewAssignTo" : "$ShipCrewChangeAssignment",this.MyCurrentCrew.sName,this.MySelectedEntry.sName);
            }
            else
            {
               ConfirmButton.Enabled = false;
               ConfirmButton.Visible = false;
               if(this.HasEntries)
               {
                  GlobalFunc.SetText(Message_tf,"$ShipCrewAssign",false,false,0,false,0,new Array(this.MyCurrentCrew.sName));
                  this.NoAssignmentsTip_tf.visible = false;
               }
               else
               {
                  GlobalFunc.SetText(Message_tf,"$ShipCrewNoAssignments",false,false,0,false,0,new Array(this.MyCurrentCrew.sName));
                  this.NoAssignmentsTip_tf.visible = true;
                  GlobalFunc.SetText(this.NoAssignmentsTip_tf,"$ShipCrewNoAssignmentsTip");
               }
            }
            ButtonBar_mc.RefreshButtons();
         }
      }
      
      override protected function onCancel() : *
      {
         super.onCancel();
      }
      
      private function CategoryFilterComparitor(param1:Object) : Boolean
      {
         return param1.AssignmentInfoA.length > 0;
      }
      
      private function AssignmentFilterComparitor(param1:Object) : Boolean
      {
         return param1.uAvailableCrewSlots > 0;
      }
   }
}
