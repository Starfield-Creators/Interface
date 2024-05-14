package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class WeaponGroupWidget extends BSDisplayObject
   {
      
      private static const NUM_WEAPON_GROUPS:int = 3;
       
      
      public var WeaponGroup1Slot1_mc:DropDownBox;
      
      public var WeaponGroup2Slot1_mc:DropDownBox;
      
      public var WeaponGroup3Slot1_mc:DropDownBox;
      
      public var WeaponGroupLabel0_mc:TextField;
      
      public var WeaponGroupLabel1_mc:TextField;
      
      public var WeaponGroupLabel2_mc:TextField;
      
      private var ElementGroup:Array;
      
      private var ElementGroupSelectedIndex:int = -1;
      
      private var WeaponsList:Array;
      
      public function WeaponGroupWidget()
      {
         this.ElementGroup = new Array();
         this.WeaponsList = new Array();
         super();
         this.ElementGroup.push(this.WeaponGroup1Slot1_mc);
         this.ElementGroup.push(this.WeaponGroup2Slot1_mc);
         this.ElementGroup.push(this.WeaponGroup3Slot1_mc);
      }
      
      override public function onAddedToStage() : void
      {
         var labelName:* = undefined;
         var label:TextField = null;
         var i:int = 0;
         while(i < NUM_WEAPON_GROUPS)
         {
            labelName = "WeaponGroupLabel" + i + "_mc";
            label = this[labelName] as TextField;
            GlobalFunc.SetText(label,"$W",false,false,0,false,0,new Array(GlobalFunc.FormatNumberToString(i)));
            i++;
         }
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(DropDownBox.DropEntrySelectedEvent,this.onDropEntrySelected);
         BSUIDataManager.Subscribe("ShipWeaponGroupsData",function(param1:FromClientDataEvent):*
         {
            var _loc4_:* = undefined;
            var _loc2_:* = param1.data;
            var _loc3_:Array = _loc2_.WeaponGroups;
            for(_loc4_ in _loc3_)
            {
               PopulateWeaponGroup(_loc4_,_loc3_[_loc4_]);
            }
         });
         BSUIDataManager.Subscribe("ShipWeaponsData",function(param1:FromClientDataEvent):*
         {
            var _loc3_:DropDownBox = null;
            var _loc2_:* = param1.data;
            WeaponsList = _loc2_.WeaponList;
            for each(_loc3_ in ElementGroup)
            {
               _loc3_.FillDropList(WeaponsList);
            }
         });
      }
      
      public function SetPopupActive(param1:Boolean) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         if(param1)
         {
            this.visible = true;
         }
         else
         {
            _loc2_ = false;
            for each(_loc3_ in this.ElementGroup)
            {
               if(_loc3_.IsListActive())
               {
                  _loc3_.onButtonClicked();
                  _loc2_ = true;
               }
            }
            if(_loc2_ == false)
            {
               this.visible = false;
            }
         }
         return this.visible;
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.ENTER && this.ElementGroup[this.ElementGroupSelectedIndex] != null)
         {
            this.ElementGroup[this.ElementGroupSelectedIndex].onButtonClicked();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         var _loc2_:Boolean = false;
         if(param1.keyCode == Keyboard.UP)
         {
            this.MoveSelection(-1);
            _loc2_ = true;
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            this.MoveSelection(1);
            _loc2_ = true;
         }
         if(_loc2_)
         {
            GlobalFunc.PlayMenuSound("UIItemFocus");
         }
      }
      
      public function MoveSelection(param1:int) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:int = GlobalFunc.Clamp(this.ElementGroupSelectedIndex + param1,0,this.ElementGroup.length - 1);
         var _loc3_:int = this.ElementGroupSelectedIndex;
         if(_loc2_ != _loc3_)
         {
            this.ElementGroupSelectedIndex = _loc2_;
            for each(_loc4_ in this.ElementGroup)
            {
               _loc4_.Deselect();
            }
            stage.focus = this.ElementGroup[this.ElementGroupSelectedIndex];
            this.ElementGroup[this.ElementGroupSelectedIndex].Select();
         }
      }
      
      public function PopulateWeaponGroup(param1:int, param2:Object) : *
      {
         var _loc3_:DropDownBox = null;
         if(param1 == 0)
         {
            _loc3_ = this.WeaponGroup1Slot1_mc;
         }
         else if(param1 == 1)
         {
            _loc3_ = this.WeaponGroup2Slot1_mc;
         }
         else if(param1 == 2)
         {
            _loc3_ = this.WeaponGroup3Slot1_mc;
         }
         if(_loc3_)
         {
            _loc3_.SetButtonText(this.GetWeaponName(param2));
         }
      }
      
      private function GetWeaponName(param1:Object) : String
      {
         var _loc2_:* = "$unassigned";
         if(param1 != null && param1.text != "")
         {
            _loc2_ = param1.text;
         }
         return _loc2_;
      }
      
      private function onDropEntrySelected(param1:CustomEvent) : *
      {
         var _loc5_:uint = 0;
         var _loc2_:DropDownBox = param1.params.target;
         var _loc3_:Object = param1.params.object;
         var _loc4_:uint;
         if((_loc4_ = this.FindBoxIndex(_loc2_)) != uint.MAX_VALUE)
         {
            _loc5_ = _loc4_;
            BSUIDataManager.dispatchEvent(new CustomEvent("WeaponGroupAssignmentMenu_ChangeWeaponAssignment",{
               "uWeaponEntryID":_loc3_.uID,
               "uWeaponGroupID":_loc5_
            }));
         }
         GlobalFunc.PlayMenuSound("UIMenuGeneralOK");
      }
      
      private function FindBoxIndex(param1:DropDownBox) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:* = uint.MAX_VALUE;
         for(_loc3_ in this.ElementGroup)
         {
            if(this.ElementGroup[_loc3_] == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
   }
}
