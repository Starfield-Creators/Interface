package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.ShipInfoUtils;
   import flash.display.MovieClip;
   
   public class GravJumpComponent extends MovieClip
   {
      
      public static const ShipHud_AbortJump:String = "ShipHud_AbortJump";
       
      
      public var GravNeedsPower_mc:MovieClip;
      
      public var GravJumpProgress_mc:GravJumpAnim;
      
      public var CancelButton_mc:ButtonBase;
      
      private var CancelButtonHintData:ButtonBaseData;
      
      private var LastGravJumpPercentage:Number = 0;
      
      private var GravDrivePowered:Boolean = false;
      
      private var GravDriveStalled:Boolean = false;
      
      public function GravJumpComponent()
      {
         this.CancelButtonHintData = new ButtonBaseData("$ABORT JUMP",new UserEventData("Cancel",this.onAbortJump));
         super();
         this.CancelButton_mc.SetButtonData(this.CancelButtonHintData);
      }
      
      public function get WasGravJumping() : Boolean
      {
         return this.GravJumpProgress_mc.WasGravJumping;
      }
      
      public function SetGravDriveHudData(param1:Object) : *
      {
         var _loc2_:Boolean = param1.gravJumpCalculatedPercentage == this.LastGravJumpPercentage && Boolean(param1.bGravJumpInitiated) && !param1.bGravJumpAnimStarted;
         this.LastGravJumpPercentage = param1.gravJumpCalculatedPercentage;
         if(this.GravDriveStalled != _loc2_)
         {
            this.GravDriveStalled = _loc2_;
            this.UpdatePowerNotificationVisibility();
         }
      }
      
      private function UpdatePowerNotificationVisibility() : *
      {
         this.GravNeedsPower_mc.visible = this.GravDriveStalled && !this.GravDrivePowered;
         if(this.GravNeedsPower_mc.visible && this.GravJumpProgress_mc.WasGravJumping)
         {
            this.GravJumpProgress_mc.Hide();
         }
      }
      
      public function RefreshGravJumpComponent(param1:Object) : *
      {
         this.GravJumpProgress_mc.RefreshGravJumpComponent(param1);
         this.GravNeedsPower_mc.visible = this.GravNeedsPower_mc.visible && !(param1.gravJumpCalculatedPercentage > 0 || param1.bGravJumpAnimStarted);
         var _loc2_:Boolean = !param1.bGravJumpInitiated && Boolean(param1.bGravJumpAnimStarted);
         if(this.CancelButtonHintData.bEnabled != _loc2_)
         {
            this.CancelButtonHintData.bEnabled = _loc2_;
            this.CancelButtonHintData.bVisible = _loc2_;
            this.CancelButton_mc.SetButtonData(this.CancelButtonHintData);
         }
      }
      
      public function Disable() : *
      {
         this.GravJumpProgress_mc.Hide();
         if(this.CancelButtonHintData.bEnabled)
         {
            this.CancelButtonHintData.bEnabled = false;
            this.CancelButtonHintData.bVisible = false;
            this.CancelButton_mc.SetButtonData(this.CancelButtonHintData);
         }
      }
      
      private function onAbortJump() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(ShipHud_AbortJump,{}));
      }
      
      public function GetGravDrivePowered(param1:Array) : *
      {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         for each(_loc2_ in param1)
         {
            if(_loc2_.type == ShipInfoUtils.MT_GRAV)
            {
               _loc3_ = _loc2_.componentPower > 0;
               if(this.GravDrivePowered != _loc3_)
               {
                  this.GravDrivePowered = _loc3_;
                  this.UpdatePowerNotificationVisibility();
               }
               break;
            }
         }
      }
   }
}
