package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.BSInputDefines;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PowerDisplay extends BSDisplayObject
   {
      
      private static const POWERED:String = "Powered";
      
      private static const UNPOWERED:String = "Unpowered";
      
      private static const REPAIRING:String = "Repairing";
      
      private static const EM_DAMAGE:String = "EMDamage";
      
      private static const PHYS_DAMAGE:String = "PhysDamage";
      
      private static const EMPTY:String = "Empty";
      
      private static const ADD:String = "Add";
      
      private static const REMOVE:String = "Remove";
      
      private static const POWERED_HIGHLIGHT:String = "Powered_Highlight";
      
      private static const UNPOWERED_HIGHLIGHT:String = "Unpowered_Highlight";
      
      private static const CONNECTION_HIGHLIGHTSYSTEM:String = "Highlight_SelectSystem";
      
      private static const CONNECTION_HIGHLIGHTPANEL1:String = "Highlight_SelectPanel1";
      
      private static const CONNECTION_HIGHLIGHTPANEL2:String = "Highlight_SelectPanel2";
      
      private static const NORMAL:String = "Normal";
      
      private static const HIGHLIGHT:String = "Highlight";
      
      public static const SYSTEM_WEAPONGROUP1:int = EnumHelper.GetEnum(0);
      
      public static const SYSTEM_WEAPONGROUP2:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_WEAPONGROUP3:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_ENGINE:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_SHIELD:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_GRAVDRIVE:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_REACTOR:int = EnumHelper.GetEnum();
      
      public static const SYSTEM_GENERAL:int = EnumHelper.GetEnum();
      
      private static const HangarShipSelection_ChangeSystemDisplay:String = "HangarShipSelection_ChangeSystemDisplay";
      
      public static const HangarShipSelection_UpgradeSystem:String = "HangarShipSelection_UpgradeSystem";
       
      
      public var ComponentMeter1_mc:MovieClip;
      
      public var ComponentMeter2_mc:MovieClip;
      
      public var ComponentMeter3_mc:MovieClip;
      
      public var ComponentMeter4_mc:MovieClip;
      
      public var ComponentMeter5_mc:MovieClip;
      
      public var ComponentMeter6_mc:MovieClip;
      
      public var ShipOverview_mc:MovieClip;
      
      public var ShipPower_mc:MovieClip;
      
      public var ConnectionLines_mc:MovieClip;
      
      private var Selectables:Vector.<SystemCollection>;
      
      private var SelectedIndex:int = 0;
      
      private var PreviousIndex:int = 0;
      
      private var LastSelectedComponent:int;
      
      private const NUM_METERS:int = 6;
      
      private const NUM_BARS_FOR_METER:int = 12;
      
      private const NUM_BARS_FOR_REACTOR_METER:int = 38;
      
      private const SHIP_POWER_METER_INDEX:* = 0;
      
      private const SHIP_OVERVIEW_INDEX:* = 1;
      
      private const SHIP_COMPONENT_START_INDEX:* = 2;
      
      public function PowerDisplay()
      {
         var _loc1_:SystemCollection = null;
         this.LastSelectedComponent = this.SHIP_COMPONENT_START_INDEX;
         super();
         this.Selectables = new Vector.<SystemCollection>();
         this.Selectables.push(new SystemCollection(this.ShipPower_mc,SYSTEM_REACTOR));
         this.Selectables.push(new SystemCollection(this.ShipOverview_mc,SYSTEM_GENERAL));
         this.Selectables.push(new SystemCollection(this.ComponentMeter1_mc,SYSTEM_WEAPONGROUP1));
         this.Selectables.push(new SystemCollection(this.ComponentMeter2_mc,SYSTEM_WEAPONGROUP2));
         this.Selectables.push(new SystemCollection(this.ComponentMeter3_mc,SYSTEM_WEAPONGROUP3));
         this.Selectables.push(new SystemCollection(this.ComponentMeter4_mc,SYSTEM_ENGINE));
         this.Selectables.push(new SystemCollection(this.ComponentMeter5_mc,SYSTEM_SHIELD));
         this.Selectables.push(new SystemCollection(this.ComponentMeter6_mc,SYSTEM_GRAVDRIVE));
         for each(_loc1_ in this.Selectables)
         {
            _loc1_.Clip.addEventListener(MouseEvent.ROLL_OVER,this.onRollover);
         }
      }
      
      private function get Weapon1MeterText() : TextField
      {
         return this.ComponentMeter1_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get Weapon2MeterText() : TextField
      {
         return this.ComponentMeter2_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get Weapon3MeterText() : TextField
      {
         return this.ComponentMeter3_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get EngineMeterText() : TextField
      {
         return this.ComponentMeter4_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get ShieldMeterText() : TextField
      {
         return this.ComponentMeter5_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get GravDriveMeterText() : TextField
      {
         return this.ComponentMeter6_mc.ComponentName_mc.Name_mc.Name_tf;
      }
      
      private function get ShipPowerMeter() : MovieClip
      {
         return this.ShipPower_mc.PowerMeter_mc;
      }
      
      private function get Weapon1Meter() : MovieClip
      {
         return this.ComponentMeter1_mc.PowerMeter_mc;
      }
      
      private function get Weapon2Meter() : MovieClip
      {
         return this.ComponentMeter2_mc.PowerMeter_mc;
      }
      
      private function get Weapon3Meter() : MovieClip
      {
         return this.ComponentMeter3_mc.PowerMeter_mc;
      }
      
      private function get EngineMeter() : MovieClip
      {
         return this.ComponentMeter4_mc.PowerMeter_mc;
      }
      
      private function get ShieldMeter() : MovieClip
      {
         return this.ComponentMeter5_mc.PowerMeter_mc;
      }
      
      private function get GravDriveMeter() : MovieClip
      {
         return this.ComponentMeter6_mc.PowerMeter_mc;
      }
      
      private function get ConnectionAnimActiveComponent() : MovieClip
      {
         return this.ConnectionLines_mc.ComponentFrameAnim_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("ShipStatsData",this.onShipStatsDataUpdate);
         BSUIDataManager.Subscribe("ShipHangarPowerAllocationData",this.onPowerAllocationDataUpdate);
         GlobalFunc.SetText(this.EngineMeterText,"$ENG");
         GlobalFunc.SetText(this.GravDriveMeterText,"$GRV");
         GlobalFunc.SetText(this.ShieldMeterText,"$SHD");
         this.ShipOverview_mc.SelectSystemText_mc.LSButton_mc.SetButtonData(new ButtonBaseData("",new UserEventData("Pan"),false,true,"","","",null,false));
         this.HighlightSelectable(this.SHIP_OVERVIEW_INDEX);
         this.PlayConnectionAnim();
      }
      
      private function onShipStatsDataUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = param1.data;
         GlobalFunc.SetText(this.Weapon1MeterText,_loc2_.aWeaponGroupNames[0]);
         GlobalFunc.SetText(this.Weapon2MeterText,_loc2_.aWeaponGroupNames[1]);
         GlobalFunc.SetText(this.Weapon3MeterText,_loc2_.aWeaponGroupNames[2]);
         this.visible = !_loc2_.bShowNoShip;
      }
      
      public function onPowerAllocationDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         this.UpdateComponentMeter(this.Selectables[this.SHIP_POWER_METER_INDEX],this.NUM_BARS_FOR_REACTOR_METER,_loc2_.iReactor,_loc2_.iReactorDiff);
         this.UpdateComponentMeter(this.Selectables[this.SHIP_COMPONENT_START_INDEX],this.NUM_BARS_FOR_METER,_loc2_.iWeapon1,_loc2_.iWeapon1Diff);
         this.UpdateComponentMeter(this.Selectables[this.SHIP_COMPONENT_START_INDEX + 1],this.NUM_BARS_FOR_METER,_loc2_.iWeapon2,_loc2_.iWeapon2Diff);
         this.UpdateComponentMeter(this.Selectables[this.SHIP_COMPONENT_START_INDEX + 2],this.NUM_BARS_FOR_METER,_loc2_.iWeapon3,_loc2_.iWeapon3Diff);
         this.UpdateComponentMeter(this.Selectables[this.SHIP_COMPONENT_START_INDEX + 3],this.NUM_BARS_FOR_METER,_loc2_.iEngine,_loc2_.iEngineDiff);
         var _loc3_:String = _loc2_.iEngine > 0 ? "$ENG" : "";
         GlobalFunc.SetText(this.EngineMeterText,_loc3_);
         this.UpdateComponentMeter(this.Selectables[this.SHIP_COMPONENT_START_INDEX + 4],this.NUM_BARS_FOR_METER,_loc2_.iShield,_loc2_.iShieldDiff);
         var _loc4_:String = _loc2_.iShield > 0 ? "$SHD" : "";
         GlobalFunc.SetText(this.ShieldMeterText,_loc4_);
         this.UpdateComponentMeter(this.Selectables[this.SHIP_COMPONENT_START_INDEX + 5],this.NUM_BARS_FOR_METER,_loc2_.iGravDrive,_loc2_.iGravDriveDiff);
         var _loc5_:String = _loc2_.iGravDrive > 0 ? "$GRV" : "";
         GlobalFunc.SetText(this.GravDriveMeterText,_loc5_);
         if(this.Selectables[this.SelectedIndex].Disabled)
         {
            this.HighlightSelectable(this.SHIP_OVERVIEW_INDEX);
         }
         else
         {
            this.UpdateSelectedHighlight();
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            if(param1 == "UpgradeShip")
            {
               this.Selectables[this.SelectedIndex].onUpgradeSystem();
               _loc3_ = true;
            }
            else if(param1 == "PanUp" || param1 == "Up")
            {
               this.OnUpInput();
               _loc3_ = true;
            }
            else if(param1 == "PanDown" || param1 == "Down")
            {
               this.OnDownInput();
               _loc3_ = true;
            }
            else if(param1 == "PanLeft" || param1 == "Left")
            {
               this.OnLeftInput();
               _loc3_ = true;
            }
            else if(param1 == "PanRight" || param1 == "Right")
            {
               this.OnRightInput();
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function OnLeftStickInput(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:uint) : Boolean
      {
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         if(param4)
         {
            if(Math.abs(param1) < Math.abs(param2))
            {
               if(param6 == BSInputDefines.DV_UP)
               {
                  this.OnUpInput();
                  _loc7_ = true;
               }
               else if(param6 == BSInputDefines.DV_DOWN)
               {
                  this.OnDownInput();
                  _loc7_ = true;
               }
            }
            else if(this.SelectedIndex >= this.SHIP_COMPONENT_START_INDEX)
            {
               if(param6 == BSInputDefines.DV_LEFT)
               {
                  this.OnLeftInput();
                  _loc7_ = true;
               }
               else if(param6 == BSInputDefines.DV_RIGHT)
               {
                  this.OnRightInput();
                  _loc7_ = true;
               }
            }
         }
         return _loc7_;
      }
      
      private function UpdateComponentMeter(param1:SystemCollection, param2:int, param3:int, param4:int) : *
      {
         var _loc5_:MovieClip = param1.PowerMeter;
         var _loc6_:int = param4 > 0 ? param3 - param4 : param3;
         var _loc7_:int = Math.abs(param4);
         var _loc8_:String = param4 < 0 ? REMOVE : ADD;
         if(_loc6_ + _loc7_ > param2)
         {
            if(_loc6_ > param2)
            {
               _loc6_ = param2;
            }
            _loc7_ = param2 - _loc6_;
         }
         var _loc9_:int = 1;
         param1.Disabled = param3 <= 0;
         if(param3 > 0)
         {
            while(_loc9_ <= _loc6_)
            {
               _loc5_["Bar" + _loc9_ + "_mc"].gotoAndStop(POWERED);
               _loc9_++;
            }
            while(_loc9_ <= _loc6_ + _loc7_)
            {
               _loc5_["Bar" + _loc9_ + "_mc"].gotoAndStop(_loc8_);
               _loc9_++;
            }
         }
         while(_loc9_ <= param2)
         {
            _loc5_["Bar" + _loc9_ + "_mc"].gotoAndStop(EMPTY);
            _loc9_++;
         }
      }
      
      private function HighlightSelectable(param1:int) : void
      {
         if(param1 != this.SelectedIndex && !this.Selectables[param1].Disabled)
         {
            GlobalFunc.PlayMenuSound("UIMenuShipBuilderPartHighlight");
            this.PreviousIndex = this.SelectedIndex;
            this.Selectables[this.PreviousIndex].Clip.gotoAndStop(NORMAL);
            this.UpdatePowerBarsHighlight(this.PreviousIndex,false);
            if(this.PreviousIndex >= this.SHIP_COMPONENT_START_INDEX)
            {
               this.LastSelectedComponent = this.PreviousIndex;
            }
            this.SelectedIndex = param1;
            this.UpdateSelectedHighlight();
            BSUIDataManager.dispatchEvent(new CustomEvent(HangarShipSelection_ChangeSystemDisplay,{"iSystemIndex":this.Selectables[this.SelectedIndex].SystemType}));
         }
      }
      
      private function UpdateSelectedHighlight() : void
      {
         this.Selectables[this.SelectedIndex].Clip.gotoAndStop(HIGHLIGHT);
         this.UpdatePowerBarsHighlight(this.SelectedIndex,true);
         this.ConnectionAnimActiveComponent.gotoAndStop(this.Selectables[this.SelectedIndex].Clip.name);
      }
      
      public function onRollover(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.Selectables.length)
         {
            if(this.Selectables[_loc2_].Clip == param1.currentTarget)
            {
               this.HighlightSelectable(_loc2_);
               this.PlayConnectionAnim();
            }
            _loc2_++;
         }
      }
      
      private function UpdatePowerBarsHighlight(param1:int, param2:Boolean) : *
      {
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         if(param1 >= 0 && param1 < this.Selectables.length && param1 != this.SHIP_OVERVIEW_INDEX)
         {
            _loc3_ = this.Selectables[param1].PowerMeter;
            _loc4_ = param1 == this.SHIP_POWER_METER_INDEX ? this.NUM_BARS_FOR_REACTOR_METER : this.NUM_BARS_FOR_METER;
         }
         if(_loc3_)
         {
            _loc5_ = 1;
            while(_loc5_ <= _loc4_)
            {
               if(_loc6_ = _loc3_["Bar" + _loc5_ + "_mc"] as MovieClip)
               {
                  if(param2)
                  {
                     if(_loc6_.currentFrameLabel == POWERED)
                     {
                        _loc6_.gotoAndStop(POWERED_HIGHLIGHT);
                     }
                     else if(_loc6_.currentFrameLabel == UNPOWERED)
                     {
                        _loc6_.gotoAndStop(UNPOWERED_HIGHLIGHT);
                     }
                  }
                  else if(_loc6_.currentFrameLabel == POWERED_HIGHLIGHT)
                  {
                     _loc6_.gotoAndStop(POWERED);
                  }
                  else if(_loc6_.currentFrameLabel == UNPOWERED_HIGHLIGHT)
                  {
                     _loc6_.gotoAndStop(UNPOWERED);
                  }
               }
               _loc5_++;
            }
         }
      }
      
      private function PlayConnectionAnim() : void
      {
         if(this.SelectedIndex == this.SHIP_POWER_METER_INDEX && this.ConnectionLines_mc.currentFrameLabel != CONNECTION_HIGHLIGHTPANEL2)
         {
            this.ConnectionLines_mc.gotoAndPlay(CONNECTION_HIGHLIGHTPANEL2);
         }
         else if(this.SelectedIndex == this.SHIP_OVERVIEW_INDEX && this.ConnectionLines_mc.currentFrameLabel != CONNECTION_HIGHLIGHTSYSTEM)
         {
            this.ConnectionLines_mc.gotoAndPlay(CONNECTION_HIGHLIGHTSYSTEM);
         }
         else if(this.ConnectionLines_mc.currentFrameLabel != CONNECTION_HIGHLIGHTPANEL1)
         {
            this.ConnectionLines_mc.gotoAndPlay(CONNECTION_HIGHLIGHTPANEL1);
         }
      }
      
      override protected function OnControlMapChanged(param1:Object) : void
      {
         super.OnControlMapChanged(param1);
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.ShipOverview_mc.SelectSystemText_mc.gotoAndStop("MKB");
         }
         else
         {
            this.ShipOverview_mc.SelectSystemText_mc.gotoAndStop("Gamepad");
         }
      }
      
      private function OnLeftInput() : void
      {
         this.MoveComponentSelection(-1);
      }
      
      private function OnRightInput() : void
      {
         this.MoveComponentSelection(1);
      }
      
      private function MoveComponentSelection(param1:int) : void
      {
         var _loc2_:* = this.SelectedIndex + param1;
         var _loc3_:int = this.Selectables.length - this.SHIP_COMPONENT_START_INDEX;
         while(_loc3_ > 0)
         {
            if(_loc2_ < this.SHIP_COMPONENT_START_INDEX)
            {
               _loc2_ = this.Selectables.length - 1;
            }
            else if(_loc2_ >= this.Selectables.length)
            {
               _loc2_ = this.SHIP_COMPONENT_START_INDEX;
            }
            if(!this.Selectables[_loc2_].Disabled)
            {
               break;
            }
            _loc2_ += param1;
            _loc3_--;
         }
         this.HighlightSelectable(_loc2_);
      }
      
      private function OnUpInput() : void
      {
         if(this.SelectedIndex >= this.SHIP_COMPONENT_START_INDEX)
         {
            return;
         }
         var _loc1_:int = this.SelectedIndex == this.SHIP_OVERVIEW_INDEX ? this.LastSelectedComponent : this.SelectedIndex + 1;
         if(this.Selectables[_loc1_].Disabled)
         {
            this.MoveComponentSelection(1);
         }
         this.HighlightSelectable(_loc1_);
         if(this.PreviousIndex != this.SelectedIndex)
         {
            this.PlayConnectionAnim();
         }
      }
      
      private function OnDownInput() : void
      {
         var _loc1_:int = this.SelectedIndex > this.SHIP_COMPONENT_START_INDEX ? this.SHIP_OVERVIEW_INDEX : int(Math.max(this.SelectedIndex - 1,this.SHIP_POWER_METER_INDEX));
         this.HighlightSelectable(_loc1_);
         if(this.PreviousIndex != this.SelectedIndex)
         {
            this.PlayConnectionAnim();
         }
      }
   }
}

import Shared.AS3.Data.BSUIDataManager;
import flash.display.MovieClip;
import flash.events.MouseEvent;

class SystemCollection
{
    
   
   public var Clip:MovieClip;
   
   public var SystemType:int;
   
   public var Disabled:Boolean = false;
   
   public function SystemCollection(param1:MovieClip, param2:int)
   {
      var aClip:MovieClip = param1;
      var aType:int = param2;
      super();
      this.Clip = aClip;
      this.SystemType = aType;
      this.Clip.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
      {
         onUpgradeSystem();
      });
   }
   
   public function get PowerMeter() : MovieClip
   {
      return this.Clip.PowerMeter_mc;
   }
   
   public function onUpgradeSystem() : void
   {
      if(!this.Disabled)
      {
         BSUIDataManager.dispatchCustomEvent(PowerDisplay.HangarShipSelection_UpgradeSystem);
      }
   }
}
