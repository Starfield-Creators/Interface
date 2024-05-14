package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class LockOnIndicator extends MovieClip
   {
      
      public static const LOCK_ON_PRESSED:String = "LockOnIndicator_LockOnPressed";
      
      public static const IN_ANIM_COMPLETE:String = "LockOnIndicator_InAnimComplete";
      
      public static const OUT_ANIM_COMPLETE:String = "LockOnIndicator_OutAnimComplete";
       
      
      public var LockProgress_mc:MovieClip;
      
      public var Button_mc:ButtonBase;
      
      public var LockText_tf:TextField;
      
      public var InAnim_mc:MovieClip;
      
      public var OutAnim_mc:MovieClip;
      
      private var MyButtonManager:ButtonManager;
      
      private var LockProgress_tf:TextField;
      
      private var LastLockPercent:int = 0;
      
      private var TargetOnlyData:Object = null;
      
      private var LowFrequencyData:Object = null;
      
      private var ShipHudData:Object = null;
      
      private var TargetComputerButtonData:ButtonBaseData;
      
      private var WasTargeting:Boolean = false;
      
      private var LostTargetAnim:Boolean = false;
      
      public function LockOnIndicator()
      {
         this.MyButtonManager = new ButtonManager();
         this.TargetComputerButtonData = new ButtonBaseData("",new UserEventData("XButton",this.onTargetComputerPressed));
         super();
         this.LockProgress_tf = this.LockProgress_mc.Text_tf;
         this.Button_mc.SetButtonData(this.TargetComputerButtonData);
         this.MyButtonManager.AddButton(this.Button_mc);
         this.LockProgress_tf.autoSize = TextFieldAutoSize.CENTER;
         this.LockText_tf.autoSize = TextFieldAutoSize.CENTER;
         gotoAndStop("NotLocked");
         this.OutAnim_mc.gotoAndStop("End");
      }
      
      public function UpdateTargetOnly(param1:Object) : *
      {
         this.TargetOnlyData = param1;
         this.Update(true);
      }
      
      public function UpdateLowFrequency(param1:Object) : *
      {
         this.LowFrequencyData = param1;
         this.Update(false);
      }
      
      public function UpdateShipHudData(param1:Object) : *
      {
         this.ShipHudData = param1;
         this.Update(false);
      }
      
      private function Update(param1:Boolean) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this.TargetOnlyData != null && this.LowFrequencyData != null && this.ShipHudData != null)
         {
            _loc2_ = this.ShipHudData.bTargetModeAllowed && !this.TargetOnlyData.bTargetModeActive && !this.LowFrequencyData.bPlayerInScene && !this.ShipHudData.bDialogueActive;
            _loc3_ = false;
            if(this.WasTargeting)
            {
               this.ShowTargetLostAnim();
            }
            if(_loc2_ && !this.LostTargetAnim && (param1 || !visible))
            {
               _loc3_ = (_loc4_ = this.TargetOnlyData.fTargetLockStrength * 100) == 100 && Boolean(this.TargetOnlyData.bCanTarget);
               if(_loc4_ != this.LastLockPercent)
               {
                  if(_loc4_ == 100)
                  {
                     GlobalFunc.SetText(this.LockText_tf,"$TARGET LOCK");
                     gotoAndStop("LockOn");
                     this.InAnim_mc.gotoAndPlay(1);
                  }
                  else if(_loc4_ == 0)
                  {
                     gotoAndStop("NotLocked");
                  }
                  else
                  {
                     if(this.LastLockPercent == 100 || this.LastLockPercent == 0)
                     {
                        GlobalFunc.SetText(this.LockText_tf,"");
                        gotoAndStop("Locking");
                     }
                     GlobalFunc.SetText(this.LockProgress_tf,"$$LOCKING " + _loc4_ + "%");
                  }
                  this.LastLockPercent = _loc4_;
               }
               this.Button_mc.Enabled = _loc3_;
               this.Button_mc.Visible = _loc3_;
            }
            this.WasTargeting = this.TargetOnlyData.bTargetModeActive;
            visible = _loc2_;
         }
      }
      
      private function ShowTargetLostAnim() : *
      {
         if(this.TargetOnlyData.sTargetLockEndReason != "")
         {
            GlobalFunc.SetText(this.LockText_tf,this.TargetOnlyData.sTargetLockEndReason);
            gotoAndStop("TargetLost");
            this.OutAnim_mc.gotoAndStop("End");
            addEventListener(IN_ANIM_COMPLETE,this.OnInAnimComplete);
            this.InAnim_mc.gotoAndPlay(1);
            this.LostTargetAnim = true;
         }
      }
      
      private function OnInAnimComplete() : *
      {
         removeEventListener(IN_ANIM_COMPLETE,this.OnInAnimComplete);
         addEventListener(OUT_ANIM_COMPLETE,this.OnOutAnimComplete);
         this.InAnim_mc.gotoAndStop(1);
         this.OutAnim_mc.gotoAndPlay(1);
         GlobalFunc.SetText(this.LockText_tf,"");
      }
      
      private function OnOutAnimComplete() : *
      {
         removeEventListener(OUT_ANIM_COMPLETE,this.OnOutAnimComplete);
         this.LostTargetAnim = false;
         this.LastLockPercent = 0;
         this.Update(true);
      }
      
      private function OnNotLocked() : *
      {
         GlobalFunc.SetText(this.LockText_tf,"");
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      private function onTargetComputerPressed() : *
      {
         dispatchEvent(new Event(LOCK_ON_PRESSED,true));
      }
   }
}
