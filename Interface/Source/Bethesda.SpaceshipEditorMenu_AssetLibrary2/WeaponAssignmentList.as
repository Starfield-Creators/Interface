package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSScrollingTree;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.BSInputDefines;
   import Shared.GlobalFunc;
   
   public class WeaponAssignmentList extends BSScrollingTree
   {
      
      private static const ShipEditor_OnWeaponGroupChanged:String = "ShipEditor_OnWeaponGroupChanged";
      
      private static const NUM_WEAPON_GROUPS:uint = 3;
       
      
      private var RootExpandedA:Array;
      
      private var CachedIndex:int = -1;
      
      public function WeaponAssignmentList()
      {
         this.RootExpandedA = new Array();
         super();
         this.RootExpandedA.length = NUM_WEAPON_GROUPS;
         var _loc1_:int = 0;
         while(_loc1_ < NUM_WEAPON_GROUPS)
         {
            this.RootExpandedA[_loc1_] = false;
            _loc1_++;
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.addEventListener(ScrollingEvent.ITEM_PRESS,this.onWeaponEntryPressed);
         this.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.onWeaponSelectionChanged);
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:uint) : Boolean
      {
         if(disableInput)
         {
            return false;
         }
         if(param4)
         {
            if(param6 == BSInputDefines.DV_UP)
            {
               MoveSelection(-1);
            }
            else if(param6 == BSInputDefines.DV_DOWN)
            {
               MoveSelection(1);
            }
         }
         return true;
      }
      
      public function RestoreCachedIndex() : void
      {
         selectedIndex = this.CachedIndex > -1 ? this.CachedIndex : 0;
      }
      
      public function SaveExpandedState() : *
      {
         var _loc3_:Object = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < rawEntries.length)
         {
            _loc3_ = rawEntries[_loc2_];
            if(this.IsRootEntry(_loc3_))
            {
               var _loc4_:*;
               this.RootExpandedA[_loc4_ = _loc1_++] = _loc3_.expanded;
            }
            _loc2_++;
         }
         this.CachedIndex = selectedIndex;
      }
      
      private function RestoreExpandedState() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:int = int(NUM_WEAPON_GROUPS - 1);
         var _loc2_:int = int(rawEntries.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = rawEntries[_loc2_];
            if(this.IsRootEntry(_loc3_))
            {
               if(this.RootExpandedA[_loc1_] == true)
               {
                  ExpandEntry(_loc2_);
               }
               _loc1_--;
            }
            _loc2_--;
         }
         selectedIndex = this.CachedIndex;
      }
      
      override public function InitializeEntries(param1:Array) : void
      {
         super.InitializeEntries(param1);
         this.RestoreExpandedState();
      }
      
      override protected function IsRootEntry(param1:Object) : Boolean
      {
         return WeaponAssignmentListEntry.IsWeaponGroup(param1);
      }
      
      override protected function GetChildrenOfEntry(param1:Object) : Array
      {
         return WeaponAssignmentListEntry.IsWeaponGroup(param1) ? param1.aWeapons : new Array();
      }
      
      override protected function EntryHasChildren(param1:Object) : Boolean
      {
         return WeaponAssignmentListEntry.IsWeaponGroup(param1);
      }
      
      override protected function GetNewEntry() : BSContainerEntry
      {
         var _loc1_:WeaponAssignmentListEntry = new EntryClass() as WeaponAssignmentListEntry;
         return _loc1_ as BSContainerEntry;
      }
      
      private function onWeaponEntryPressed() : *
      {
         this.SetWeaponGroup(selectedEntry);
      }
      
      private function onWeaponSelectionChanged() : *
      {
         GlobalFunc.PlayMenuSound("UIMenuGeneralFocus");
      }
      
      private function SetWeaponGroup(param1:Object) : *
      {
         this.SaveExpandedState();
         BSUIDataManager.dispatchCustomEvent(ShipEditor_OnWeaponGroupChanged,{
            "groupNum":param1.uGroupNum,
            "value":param1.uValue
         });
      }
   }
}
