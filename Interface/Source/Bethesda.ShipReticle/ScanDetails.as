package
{
   import Components.PlanetInfoCard.ShipPlanetInfoCard;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ScanDetails extends MovieClip
   {
      
      public static const SCAN_DETAILS_CLOSED:uint = EnumHelper.GetEnum(0);
      
      public static const SCAN_DETAILS_OPENING:uint = EnumHelper.GetEnum();
      
      public static const SCAN_DETAILS_OPEN:uint = EnumHelper.GetEnum();
      
      public static const SCAN_DETAILS_CLOSING:uint = EnumHelper.GetEnum();
      
      public static const ON_TOGGLE_SCAN_DETAILS_EVENT:String = "Scan_OnToggleScanDetails";
       
      
      public var ShipInfo_mc:TargetInfoShip;
      
      public var PlanetInfo_mc:ShipPlanetInfoCard;
      
      private var State:uint;
      
      private var QueuedStateTransition:Boolean = false;
      
      private var Target:Object = null;
      
      private var TargetCombat:Object = null;
      
      private var TargetOnlyData:Object = null;
      
      private var ShipHudData:Object = null;
      
      private var ShipComponentData:Object = null;
      
      private var CanOpen:Boolean = false;
      
      private var CanOpenDirty:Boolean = false;
      
      private var PrevHealthLevel:Number = NaN;
      
      private var PrevShieldLevel:Number = NaN;
      
      private var PrevCrewCount:uint = 4294967295;
      
      public function ScanDetails()
      {
         this.State = SCAN_DETAILS_CLOSED;
         super();
         stop();
         this.ShipInfo_mc.visible = false;
         this.PlanetInfo_mc.visible = false;
         addEventListener("OnOpenAnimComplete",this.OnOpenAnimComplete);
         addEventListener("OnCloseAnimComplete",this.OnCloseAnimComplete);
      }
      
      public function Update(param1:Object, param2:Object, param3:Object, param4:Object, param5:Object) : *
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         if(!this.CanOpenDirty && param1 != null && param2 != null && this.IsValidShipType(param1.uTargetType) && this.State != SCAN_DETAILS_CLOSED)
         {
            _loc6_ = Number(param2.targetHealth);
            _loc7_ = Number(param2.targetShield);
            _loc8_ = uint(param3.uShipCrew);
            if(this.PrevHealthLevel != _loc6_)
            {
               this.PrevHealthLevel = _loc6_;
               this.CanOpenDirty = true;
            }
            if(this.PrevShieldLevel != _loc7_)
            {
               this.PrevShieldLevel = _loc7_;
               this.CanOpenDirty = true;
            }
            if(this.PrevCrewCount != _loc8_)
            {
               this.PrevCrewCount = _loc8_;
               this.CanOpenDirty = true;
            }
            if(param3.bComponentsDirty)
            {
               this.CanOpenDirty = true;
            }
         }
         if(this.Target != param1 || this.CanOpenDirty)
         {
            this.Target = param1;
            this.TargetCombat = param2;
            this.TargetOnlyData = param3;
            this.ShipHudData = param4;
            this.ShipComponentData = param5;
            this.CanOpenDirty = false;
            _loc9_ = this.Target != null && this.IsValidDisplayType(this.Target.uTargetType);
            switch(this.State)
            {
               case SCAN_DETAILS_CLOSED:
                  if(this.CanOpen && _loc9_)
                  {
                     this.PlayOpen();
                  }
                  break;
               case SCAN_DETAILS_OPEN:
                  if(!this.CanOpen || !_loc9_)
                  {
                     this.PlayClose();
                  }
                  else
                  {
                     this.SetTarget();
                  }
                  break;
               case SCAN_DETAILS_CLOSING:
                  this.QueuedStateTransition = this.CanOpen && _loc9_;
                  break;
               case SCAN_DETAILS_OPENING:
                  this.QueuedStateTransition = !this.CanOpen || !_loc9_;
            }
         }
      }
      
      private function SetShipTarget() : *
      {
         if(this.PlanetInfo_mc.visible)
         {
            this.PlanetInfo_mc.Close();
         }
         this.PlanetInfo_mc.visible = false;
         this.ShipInfo_mc.visible = true;
         this.ShipInfo_mc.SetTarget(this.Target,this.TargetCombat,this.TargetOnlyData,this.ShipHudData,this.ShipComponentData);
      }
      
      private function SetPlanetTarget() : *
      {
         this.ShipInfo_mc.visible = false;
         if(!this.PlanetInfo_mc.visible)
         {
            this.PlanetInfo_mc.Open();
         }
         this.PlanetInfo_mc.visible = true;
         this.PlanetInfo_mc.SetBodyInfo(this.TargetOnlyData.PlanetCardInfo);
      }
      
      private function IsValidShipType(param1:uint) : Boolean
      {
         return param1 == TargetIconFrameContainer.TT_SHIP || param1 == TargetIconFrameContainer.TT_HAILING || param1 == TargetIconFrameContainer.TT_STATION;
      }
      
      private function IsValidPlanetType(param1:uint) : Boolean
      {
         return param1 == TargetIconFrameContainer.TT_PLANET;
      }
      
      private function IsValidDisplayType(param1:uint) : Boolean
      {
         return this.IsValidShipType(param1) || this.IsValidPlanetType(param1);
      }
      
      private function PlayOpen() : *
      {
         this.State = SCAN_DETAILS_OPENING;
         this.SetTarget();
         dispatchEvent(new CustomEvent(ON_TOGGLE_SCAN_DETAILS_EVENT,{"Active":true}));
         gotoAndPlay("Open");
      }
      
      private function PlayClose() : *
      {
         this.State = SCAN_DETAILS_CLOSING;
         dispatchEvent(new CustomEvent(ON_TOGGLE_SCAN_DETAILS_EVENT,{"Active":false}));
         gotoAndPlay("Close");
      }
      
      private function SetTarget() : *
      {
         if(this.Target != null)
         {
            if(this.IsValidShipType(this.Target.uTargetType))
            {
               this.SetShipTarget();
            }
            else if(this.IsValidPlanetType(this.Target.uTargetType))
            {
               this.SetPlanetTarget();
            }
         }
      }
      
      private function OnOpenAnimComplete() : *
      {
         this.State = SCAN_DETAILS_OPEN;
         if(this.QueuedStateTransition)
         {
            this.QueuedStateTransition = false;
            this.PlayClose();
         }
      }
      
      private function OnCloseAnimComplete() : *
      {
         this.State = SCAN_DETAILS_CLOSED;
         if(this.QueuedStateTransition)
         {
            this.QueuedStateTransition = false;
            this.PlayOpen();
         }
      }
      
      public function SetCanOpen(param1:Boolean) : *
      {
         if(this.CanOpen != param1)
         {
            this.CanOpen = param1;
            this.CanOpenDirty = true;
            this.Update(this.Target,this.TargetCombat,this.TargetOnlyData,this.ShipHudData,this.ShipComponentData);
         }
      }
      
      public function UpdateInventoryData(param1:Object, param2:Object) : *
      {
         this.ShipInfo_mc.UpdateInventoryData(param1,param2);
      }
   }
}
