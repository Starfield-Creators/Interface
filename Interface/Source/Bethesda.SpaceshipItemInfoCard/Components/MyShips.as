package Components
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSTabbedSelectionEvent;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MyShips extends BSDisplayObject
   {
      
      private static const SpaceshipInfoMenu_MyShipsTabChanged:String = "SpaceshipInfoMenu_MyShipsTabChanged";
      
      private static const SpaceshipInfoMenu_SelectShip:String = "SpaceshipInfoMenu_SelectShip";
      
      public static const TAB_OWNED:int = EnumHelper.GetEnum(0);
      
      public static const TAB_AVAILABLE:int = EnumHelper.GetEnum();
       
      
      public var MyShipText_mc:MovieClip;
      
      public var ShipTab_mc:MyShipsTabbedSelection;
      
      public var ShipEntry1_mc:MyShipEntry;
      
      public var ShipEntry2_mc:MyShipEntry;
      
      public var ShipEntry3_mc:MyShipEntry;
      
      public var ShipEntry4_mc:MyShipEntry;
      
      public var ShipEntry5_mc:MyShipEntry;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      private const MAX_DISPLAY_ITEMS_COUNT:uint = 5;
      
      private var AllShips:Array;
      
      private var ShipEntries:Array;
      
      private var DisplayStartIndex:uint = 0;
      
      private var DisplayEndIndex:uint = 0;
      
      private var VendorMode:Boolean = false;
      
      public function MyShips()
      {
         this.AllShips = new Array();
         this.ShipEntries = new Array();
         super();
         this.ShipEntries.push(this.ShipEntry1_mc);
         this.ShipEntries.push(this.ShipEntry2_mc);
         this.ShipEntries.push(this.ShipEntry3_mc);
         this.ShipEntries.push(this.ShipEntry4_mc);
         this.ShipEntries.push(this.ShipEntry5_mc);
         this.ShipTab_mc.Configure(MyShipsTab);
         this.LeftArrow_mc.visible = false;
         this.RightArrow_mc.visible = false;
      }
      
      public function get SelectedTabType() : int
      {
         return !!this.ShipTab_mc.selectedEntry ? int(this.ShipTab_mc.selectedEntry.iTabType) : -1;
      }
      
      override public function onAddedToStage() : void
      {
         var _loc1_:MyShipEntry = null;
         super.onAddedToStage();
         this.ShipTab_mc.addEventListener(BSTabbedSelectionEvent.NAME,this.onTabChanged);
         for each(_loc1_ in this.ShipEntries)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.onEntryClick);
         }
      }
      
      public function SetVendorMode(param1:Boolean) : void
      {
         this.VendorMode = param1;
         this.MyShipText_mc.visible = !param1;
         this.ShipTab_mc.visible = param1;
         this.UpdateShipEntriesVendorMode();
      }
      
      public function SetTabs(param1:Array, param2:uint = 0) : *
      {
         this.ShipTab_mc.SetTabsData(param1,param2);
      }
      
      public function SetShips(param1:Array, param2:uint, param3:Boolean) : *
      {
         this.AllShips = param1;
         this.DisplayStartIndex = 0;
         this.DisplayEndIndex = Math.min(param1.length,this.MAX_DISPLAY_ITEMS_COUNT);
         this.SetSelectedShip(param2,param3);
         this.UpdateDisplayedShips(this.AllShips.slice(this.DisplayStartIndex,this.DisplayEndIndex));
      }
      
      private function UpdateDisplayedShips(param1:Array) : *
      {
         var _loc3_:MyShipEntry = null;
         var _loc4_:Object = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.MAX_DISPLAY_ITEMS_COUNT)
         {
            _loc3_ = this.ShipEntries[_loc2_];
            if(_loc2_ < param1.length)
            {
               _loc4_ = param1[_loc2_];
               _loc3_.SetName(_loc4_.sShipName);
               _loc3_.SetAvailability(_loc4_.sShipAvailability);
               _loc3_.SetCost(_loc4_.uShipCost);
               _loc3_.SetIndex(_loc4_.uShipIndex);
               _loc3_.SetUnselected();
               _loc3_.visible = true;
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
      
      public function SetSelectedShip(param1:uint, param2:Boolean = false) : *
      {
         var _loc4_:MyShipEntry = null;
         if(param2 && this.AllShips.length == 0 && this.SelectedTabType != TAB_AVAILABLE)
         {
            trace("WARNING: selecting a ship in an empty list is only valid for the Available tab");
         }
         else if(this.AllShips.length > 0 && param1 >= this.AllShips.length)
         {
            trace("WARNING: selected ship index " + param1 + " is out of range.");
         }
         if(param1 + 1 > this.DisplayEndIndex)
         {
            this.DisplayEndIndex = param1 + 1;
            this.DisplayStartIndex = this.DisplayEndIndex - this.MAX_DISPLAY_ITEMS_COUNT;
            this.UpdateDisplayedShips(this.AllShips.slice(this.DisplayStartIndex,this.DisplayEndIndex));
         }
         else if(param1 < this.DisplayStartIndex)
         {
            this.DisplayStartIndex = param1;
            this.DisplayEndIndex = this.DisplayStartIndex + this.MAX_DISPLAY_ITEMS_COUNT;
            this.UpdateDisplayedShips(this.AllShips.slice(this.DisplayStartIndex,this.DisplayEndIndex));
         }
         if(!this.VendorMode)
         {
            GlobalFunc.SetText(this.MyShipText_mc.text_tf,"$MY SHIPS",false,false,0,false,0,new Array(param1 + 1,this.AllShips.length));
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.MAX_DISPLAY_ITEMS_COUNT)
         {
            _loc4_ = this.ShipEntries[_loc3_];
            if(_loc3_ == 0 && this.AllShips.length == 0)
            {
               _loc4_.visible = true;
               _loc4_.SetEmpty();
            }
            else if(_loc3_ + this.DisplayStartIndex == param1)
            {
               _loc4_.SetSelected();
            }
            else if(_loc4_.IsSelected())
            {
               _loc4_.SetUnselected();
            }
            _loc3_++;
         }
      }
      
      private function onEntryClick(param1:MouseEvent) : *
      {
         var _loc3_:uint = 0;
         var _loc2_:MyShipEntry = param1.currentTarget as MyShipEntry;
         if(_loc2_)
         {
            _loc3_ = _loc2_.GetIndex();
            BSUIDataManager.dispatchCustomEvent(SpaceshipInfoMenu_SelectShip,{"shipIndex":_loc3_});
         }
      }
      
      private function onTabChanged() : *
      {
         if(this.VendorMode)
         {
            BSUIDataManager.dispatchCustomEvent(SpaceshipInfoMenu_MyShipsTabChanged,{"tabType":this.SelectedTabType});
         }
         this.UpdateShipEntriesVendorMode();
      }
      
      private function UpdateShipEntriesVendorMode() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:MyShipEntry = null;
         if(this.VendorMode && this.ShipTab_mc.selectedIndex != -1)
         {
            _loc1_ = 0;
            while(_loc1_ < this.MAX_DISPLAY_ITEMS_COUNT)
            {
               _loc2_ = this.ShipEntries[_loc1_];
               _loc2_.SetVendorMode(this.SelectedTabType == TAB_AVAILABLE);
               _loc1_++;
            }
         }
      }
   }
}
