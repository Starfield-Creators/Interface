package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonData.UserEventManager;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.FactionUtils;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MannedObjectIcon extends DestructibleObjectIconBase
   {
      
      private static const DOCK_EVENT:String = "XButton";
      
      private static const HAIL_EVENT:String = "SelectTarget";
      
      private static var DockButtonHintData:ButtonBaseData = new ButtonBaseData("$DOCK",new UserEventData(DOCK_EVENT,null),false,false);
      
      private static var HailButtonHintData:ButtonBaseData = new ButtonBaseData("$HAIL",new UserEventData(HAIL_EVENT,null),false,false);
      
      private static var DockButton:IButton;
      
      private static var HailButton:IButton;
      
      public static const ShipHud_DockRequested:String = "ShipHud_DockRequested";
      
      public static const ShipHud_HailShip:String = "ShipHud_HailShip";
      
      protected static const ALLY_SELECTED_FRAME_LABEL:String = "AllySelected";
      
      protected static const ALLY_UNSELECTED_FRAME_LABEL:String = "AllyUnselected";
      
      protected static const ENEMY_SELECTED_FRAME_LABEL:String = "EnemySelected";
      
      protected static const ENEMY_UNSELECTED_FRAME_LABEL:String = "EnemyUnselected";
       
      
      public var LockOn_mc:MovieClip;
      
      public var Level_mc:MovieClip;
      
      public var ShieldBar_mc:MovieClip;
      
      public var SystemDamage_mc:ShipTargetComponentManager;
      
      public var FactionIcon_mc:MovieClip;
      
      public var FactionIconShadow_mc:MovieClip;
      
      private var Level_tf:TextField;
      
      private var LockOnPulse_mc:MovieClip;
      
      private var DockButtonUserEvent:UserEventManager;
      
      private var HailButtonUserEvent:UserEventManager;
      
      private var LastShieldFrame:int = 0;
      
      private var LastTargetLockFrame:int = 0;
      
      private var LastFaction:int = 0;
      
      private var LastLevel:int = -1;
      
      private var WasDialogueActive:Boolean = false;
      
      protected var IsStaticIcon:Boolean = false;
      
      protected var LastOnScreen:Boolean = true;
      
      public function MannedObjectIcon()
      {
         this.DockButtonUserEvent = new UserEventManager([new UserEventData(DOCK_EVENT,this.onDockPressed)]);
         this.HailButtonUserEvent = new UserEventManager([new UserEventData(HAIL_EVENT,this.onHailPressed)]);
         super();
         this.Level_mc = Internal_mc.Level_mc;
         this.ShieldBar_mc = Internal_mc.ShieldBar_mc;
         this.SystemDamage_mc = Internal_mc.SystemDamage_mc;
         this.FactionIcon_mc = Internal_mc.FactionIcon_mc;
         this.FactionIconShadow_mc = Internal_mc.FactionIconShadow_mc;
         if(this.Level_mc != null)
         {
            this.Level_tf = this.Level_mc.Text_tf;
         }
         else
         {
            GlobalFunc.TraceWarning("MannedObjectIcon Internal_mc missing components");
         }
         this.LockOnPulse_mc = this.LockOn_mc.PulseAnim_mc;
         this.LockOn_mc.stop();
         this.LockOnPulse_mc.stop();
      }
      
      override public function SetCombatValues(param1:Object) : *
      {
         var _loc2_:int = 0;
         super.SetCombatValues(param1);
         if(this.ShieldBar_mc.visible)
         {
            _loc2_ = int(GlobalFunc.MapLinearlyToRange(this.ShieldBar_mc.framesLoaded,1,0,1,param1.targetShield,true));
            if(this.LastShieldFrame != _loc2_)
            {
               this.ShieldBar_mc.gotoAndStop(_loc2_);
               this.LastShieldFrame = _loc2_;
            }
         }
      }
      
      override public function SetTargetLowInfo(param1:Object, param2:Object, param3:Boolean) : *
      {
         var _loc4_:String = null;
         super.SetTargetLowInfo(param1,param2,param3);
         if(this.LastLevel != param1.iLevel)
         {
            GlobalFunc.SetText(this.Level_tf,param1.iLevel + "");
            this.LastLevel = param1.iLevel;
         }
         if(this.LastFaction != param1.iFaction)
         {
            _loc4_ = FactionUtils.GetFactionIconLabel(param1.iFaction);
            this.FactionIcon_mc.gotoAndStop(_loc4_);
            this.FactionIconShadow_mc.gotoAndStop(_loc4_);
            this.LastFaction = param1.iFaction;
         }
         if(this.SystemDamage_mc.visible && !IsStaticIndicator)
         {
            this.SystemDamage_mc.ComponentsArray = param2 != null ? param2.targetComponentArray : new Array();
            this.SystemDamage_mc.UpdateComponentsArray();
         }
      }
      
      override public function SetLatestPayloadData(param1:Object) : *
      {
         super.SetLatestPayloadData(param1);
         if(this.WasDialogueActive != LatestPayloadData.bDialogueActive)
         {
            UpdateButtons();
            this.WasDialogueActive = LatestPayloadData.bDialogueActive;
         }
      }
      
      override protected function SelectFrame() : *
      {
         if(TargetLow.bBehindCelestialBody)
         {
            if(ShowAsSelected)
            {
               GoToFrame(ECLIPSED_SELECTED_FRAME_LABEL);
            }
            else
            {
               GoToFrame(ECLIPSED_UNSELECTED_FRAME_LABEL);
            }
         }
         else if(TargetLow.hostile)
         {
            if(ShowAsSelected)
            {
               GoToFrame(ENEMY_SELECTED_FRAME_LABEL);
            }
            else
            {
               GoToFrame(ENEMY_UNSELECTED_FRAME_LABEL);
            }
         }
         else if(TargetLow.bAlly)
         {
            if(ShowAsSelected)
            {
               GoToFrame(ALLY_SELECTED_FRAME_LABEL);
            }
            else
            {
               GoToFrame(ALLY_UNSELECTED_FRAME_LABEL);
            }
         }
         else if(ShowAsSelected)
         {
            GoToFrame(NEUTRAL_SELECTED_FRAME_LABEL);
         }
         else
         {
            GoToFrame(NEUTRAL_UNSELECTED_FRAME_LABEL);
         }
      }
      
      override public function UpdateOnScreenStatus(param1:Boolean) : *
      {
         var _loc2_:int = 0;
         super.UpdateOnScreenStatus(param1);
         this.LastOnScreen = param1;
         this.LockOn_mc.visible = !this.IsStaticIcon && TargetOnlyData != null && param1 && TargetLow != null;
         if(this.LockOn_mc.visible)
         {
            _loc2_ = !!TargetLow.hostile ? int(GlobalFunc.MapLinearlyToRange(1,this.LockOn_mc.framesLoaded,0,1,TargetOnlyData.fTargetLockStrength,true)) : 1;
            if(this.LastTargetLockFrame != _loc2_)
            {
               this.LockOn_mc.gotoAndStop(_loc2_);
               if(_loc2_ == this.LockOn_mc.framesLoaded)
               {
                  this.LockOnPulse_mc.play();
               }
               else if(this.LastTargetLockFrame == this.LockOn_mc.framesLoaded)
               {
                  this.LockOnPulse_mc.gotoAndStop(1);
               }
               this.LastTargetLockFrame = _loc2_;
            }
         }
      }
      
      private function onDockPressed() : *
      {
         if(TargetLow != null && TargetOnlyData != null && TargetOnlyData.bdockingAllowed && !TargetOnlyData.bdockingDisabled)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_DockRequested,{"handle":TargetLow.handle}));
         }
      }
      
      private function onHailPressed() : *
      {
         if(TargetLow != null && TargetOnlyData != null && Boolean(TargetOnlyData.canBeHailed))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_HailShip,{"handle":TargetLow.handle}));
         }
      }
      
      override protected function PopulateButtons() : *
      {
         super.PopulateButtons();
         if(DockButton == null)
         {
            DockButton = ButtonFactory.AddToButtonBar("HoldButton",DockButtonHintData,ButtonBar_mc);
         }
         if(HailButton == null)
         {
            HailButton = ButtonFactory.AddToButtonBar("HoldButton",HailButtonHintData,ButtonBar_mc);
         }
         ButtonBar_mc.RefreshButtons();
      }
      
      override protected function SetAsStaticIndicator(param1:Boolean) : *
      {
         super.SetAsStaticIndicator(param1);
         if(this.IsStaticIcon != param1)
         {
            this.IsStaticIcon = param1;
            this.UpdateOnScreenStatus(this.LastOnScreen);
         }
      }
      
      override protected function UpdateButton(param1:IButton) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:* = false;
         if(param1 == DockButton)
         {
            _loc3_ = Boolean(TargetOnlyData.bdockingAllowed) && !TargetOnlyData.bdockingDisabled && !LatestPayloadData.bDialogueActive;
            _loc2_ = _loc3_ != param1.Visible;
            param1.Visible = _loc3_;
            param1.Enabled = _loc3_;
            if(DockButtonHintData.UserEvents != this.DockButtonUserEvent)
            {
               DockButtonHintData.UserEvents = this.DockButtonUserEvent;
            }
         }
         else if(param1 == HailButton)
         {
            _loc3_ = Boolean(TargetOnlyData.canBeHailed) && !LatestPayloadData.bDialogueActive;
            _loc2_ = _loc3_ != param1.Visible;
            param1.Visible = _loc3_;
            param1.Enabled = _loc3_;
            if(HailButtonHintData.UserEvents != this.HailButtonUserEvent)
            {
               HailButtonHintData.UserEvents = this.HailButtonUserEvent;
            }
         }
         else
         {
            _loc2_ = super.UpdateButton(param1);
         }
         return _loc2_;
      }
   }
}
