package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class SystemUpgrade extends BSDisplayObject
   {
      
      private static const MOVE_SELECTION_SFX:* = "UIMenuGeneralCategory";
       
      
      public var SystemEntry1_mc:SystemEntry;
      
      public var SystemEntry2_mc:SystemEntry;
      
      public var SystemEntry3_mc:SystemEntry;
      
      public var SystemEntry4_mc:SystemEntry;
      
      public var SystemEntry5_mc:SystemEntry;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      private const MAX_DISPLAY_ITEMS_COUNT:int = 5;
      
      private const MAX_DISPLAY_ITEMS_COUNT_LRG:int = 2;
      
      private var AllSystems:Array;
      
      private var DisplaySystemEntries:Vector.<SystemEntry>;
      
      private var DisplayStartIndex:int = 0;
      
      private var SelectedIndex:int = 0;
      
      private var HasEnabledSystems:Boolean = false;
      
      public function SystemUpgrade()
      {
         this.AllSystems = new Array();
         this.DisplaySystemEntries = new Vector.<SystemEntry>();
         super();
         this.DisplaySystemEntries.push(this.SystemEntry1_mc);
         this.DisplaySystemEntries.push(this.SystemEntry2_mc);
         this.DisplaySystemEntries.push(this.SystemEntry3_mc);
         this.DisplaySystemEntries.push(this.SystemEntry4_mc);
         this.DisplaySystemEntries.push(this.SystemEntry5_mc);
         this.LeftArrow_mc.visible = false;
         this.RightArrow_mc.visible = false;
      }
      
      private function get MaxDisplayItems() : int
      {
         return this.MAX_DISPLAY_ITEMS_COUNT;
      }
      
      override public function onAddedToStage() : void
      {
         var _loc1_:SystemEntry = null;
         super.onAddedToStage();
         for each(_loc1_ in this.DisplaySystemEntries)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onEntryClick);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            if(param1 == "PrevCategory")
            {
               this.MoveSelectionLeft();
               _loc3_ = true;
            }
            else if(param1 == "NextCategory")
            {
               this.MoveSelectionRight();
               _loc3_ = true;
            }
            else if(param1 == "Accept")
            {
               BSUIDataManager.dispatchCustomEvent("ShipEditor_SystemSelected",{"systemIndex":this.SelectedIndex});
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean) : Boolean
      {
         var _loc6_:Boolean = false;
         if(param4 && Math.abs(param1) > Math.abs(param2))
         {
            if(param1 < 0)
            {
               this.MoveSelectionLeft();
               _loc6_ = true;
            }
            else
            {
               this.MoveSelectionRight();
               _loc6_ = true;
            }
         }
         return _loc6_;
      }
      
      public function MoveSelectionLeft() : void
      {
         if(!this.HasEnabledSystems)
         {
            return;
         }
         do
         {
            --this.SelectedIndex;
            if(this.SelectedIndex < 0)
            {
               this.SelectedIndex = this.AllSystems.length - 1;
            }
         }
         while(this.AllSystems[this.SelectedIndex].bSystemDisabled);
         
         this.SetSelectedSystem(this.SelectedIndex);
         GlobalFunc.PlayMenuSound(MOVE_SELECTION_SFX);
      }
      
      public function MoveSelectionRight() : void
      {
         if(!this.HasEnabledSystems)
         {
            return;
         }
         do
         {
            ++this.SelectedIndex;
            if(this.SelectedIndex >= this.AllSystems.length)
            {
               this.SelectedIndex = 0;
            }
         }
         while(this.AllSystems[this.SelectedIndex].bSystemDisabled);
         
         this.SetSelectedSystem(this.SelectedIndex);
         GlobalFunc.PlayMenuSound(MOVE_SELECTION_SFX);
      }
      
      public function SetUpgradeableSystems(param1:Array, param2:uint) : *
      {
         this.AllSystems = param1;
         this.DisplayStartIndex = 0;
         var _loc3_:int = Math.min(param1.length,this.MaxDisplayItems);
         this.LeftArrow_mc.visible = this.AllSystems.length > this.MaxDisplayItems;
         this.RightArrow_mc.visible = this.AllSystems.length > this.MaxDisplayItems;
         this.UpdateDisplayedSystems(this.AllSystems.slice(this.DisplayStartIndex,_loc3_));
         this.SetSelectedSystem(param2);
         this.HasEnabledSystems = false;
         var _loc4_:int = 0;
         while(_loc4_ < this.AllSystems.length)
         {
            if(!this.AllSystems[_loc4_].bSystemDisabled)
            {
               this.HasEnabledSystems = true;
               break;
            }
            _loc4_++;
         }
      }
      
      private function UpdateDisplayedSystems(param1:Array) : *
      {
         var _loc3_:SystemEntry = null;
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.MaxDisplayItems)
         {
            _loc3_ = this.DisplaySystemEntries[_loc2_];
            if(_loc2_ < param1.length)
            {
               _loc4_ = param1[_loc2_];
               _loc3_.Name = _loc4_.sSystemName;
               _loc3_.Type = _loc4_.sSystemType;
               _loc3_.Disabled = _loc4_.bSystemDisabled;
               _loc3_.Index = this.DisplayStartIndex + _loc2_;
               _loc3_.visible = true;
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function SetSelectedSystem(param1:int) : void
      {
         var _loc3_:SystemEntry = null;
         this.SelectedIndex = param1;
         if(this.AllSystems.length > this.MaxDisplayItems)
         {
            if(this.SelectedIndex >= this.DisplayStartIndex + this.MaxDisplayItems)
            {
               this.DisplayStartIndex = this.SelectedIndex - (this.MaxDisplayItems - 1);
               this.UpdateDisplayedSystems(this.AllSystems.slice(this.DisplayStartIndex,this.DisplayStartIndex + this.MaxDisplayItems));
            }
            else if(this.SelectedIndex < this.DisplayStartIndex)
            {
               this.DisplayStartIndex = this.SelectedIndex;
               this.UpdateDisplayedSystems(this.AllSystems.slice(this.DisplayStartIndex,this.DisplayStartIndex + this.MaxDisplayItems));
            }
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.MaxDisplayItems)
         {
            _loc3_ = this.DisplaySystemEntries[_loc2_];
            if(_loc3_.visible)
            {
               _loc3_.SetSelected(_loc3_.Index == this.SelectedIndex);
            }
            _loc2_++;
         }
      }
      
      private function onEntryClick(param1:MouseEvent) : *
      {
         var _loc2_:SystemEntry = param1.currentTarget as SystemEntry;
         if(Boolean(_loc2_) && !_loc2_.Disabled)
         {
            this.SetSelectedSystem(_loc2_.Index);
            GlobalFunc.PlayMenuSound(MOVE_SELECTION_SFX);
            BSUIDataManager.dispatchCustomEvent("ShipEditor_SystemSelected",{"systemIndex":_loc2_.Index});
         }
      }
   }
}
