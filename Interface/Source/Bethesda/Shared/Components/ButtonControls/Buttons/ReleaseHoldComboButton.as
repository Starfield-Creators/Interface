package Shared.Components.ButtonControls.Buttons
{
   import Shared.ColorUtils;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class ReleaseHoldComboButton extends ButtonBase
   {
      
      public static const HOLD_IDLE:String = "Idle";
      
      public static const HOLD_START:String = "StartHold";
      
      public static const HOLD_COMPLETE:String = "buttonHoldComplete";
      
      public static const HOLD_FINISHED:String = "HoldFinished";
      
      public static const HOLD_END_ANIM_COMPLETE:String = "HoldEndAnimComplete";
      
      private static const BRIGHTNESS_PERCENTAGE:Number = 0.5;
      
      private static const LABEL_DOWN:Number = 10;
      
      private static const LABEL_UP:Number = -10;
       
      
      public var HoldLabel_mc:MovieClip = null;
      
      public var HoldAnimClip_mc:MovieClip;
      
      protected var HoldStartDelayTimer:Timer;
      
      protected var PressAndReleaseEvent:UserEventData;
      
      protected var HeldEvent:UserEventData;
      
      protected var LastHoldLabelText:String = "";
      
      private const BUTTON_STATE_NONE:uint = EnumHelper.GetEnum(0);
      
      private const BUTTON_STATE_DOWN:uint = EnumHelper.GetEnum();
      
      private const BUTTON_STATE_HELD:uint = EnumHelper.GetEnum();
      
      private const BUTTON_STATE_UP:uint = EnumHelper.GetEnum();
      
      private var _baseTextColor:uint;
      
      private var _dimmedTextColor:uint;
      
      private var _labelDefaultY:Number;
      
      private var _holdEnabled:Boolean = false;
      
      private var _pressAndReleaseEnabled:Boolean = false;
      
      private var _pressAndReleaseVisible:Boolean = false;
      
      private var _finishingAnimation:Boolean = false;
      
      private var _buttonState:uint;
      
      private var HoldAnimScaler:HoldButtonTimeScaler;
      
      public function ReleaseHoldComboButton()
      {
         this._buttonState = this.BUTTON_STATE_NONE;
         super();
         if(LabelInstance_mc != null)
         {
            this.baseTextColor = LabelInstance_mc.Label_tf.textColor;
            this._labelDefaultY = LabelInstance_mc.y;
         }
         if(this.HoldLabelInstance_mc != null)
         {
            this.HoldLabelInstance_mc.labelColor = this._dimmedTextColor;
            this.LastHoldLabelText = this.HoldLabelInstance_mc.Label_tf.text;
         }
         this.HoldStartDelayTimer = new Timer(IButtonUtils.DEFAULT_HOLD_START_DELAY_TIME_MS,1);
         this.HoldStartDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHoldStartDelayTimerCompleted);
      }
      
      protected function get HoldLabelInstance_mc() : ButtonLabel
      {
         return this.HoldLabel_mc != null && this.HoldLabel_mc.LabelInstance_mc != null ? this.HoldLabel_mc.LabelInstance_mc as ButtonLabel : null;
      }
      
      protected function get HoldAnimationClip_mc() : MovieClip
      {
         return this.HoldAnimClip_mc != null ? this.HoldAnimClip_mc : (KeyHelper != null && KeyHelper.usingController ? ConsoleButtonInstance_mc.HoldAnim_mc : PCButtonInstance_mc.HoldAnim_mc);
      }
      
      protected function get finishingAnimation() : Boolean
      {
         return this._finishingAnimation;
      }
      
      public function get Held() : *
      {
         return this._buttonState == this.BUTTON_STATE_HELD;
      }
      
      private function set baseTextColor(param1:uint) : void
      {
         this._baseTextColor = param1;
         var _loc2_:Object = ColorUtils.HexToHSB(this._baseTextColor);
         var _loc3_:Number = _loc2_.b * BRIGHTNESS_PERCENTAGE;
         _loc2_.b = Math.floor(_loc3_);
         this._dimmedTextColor = ColorUtils.HSBToHex(_loc2_);
      }
      
      override public function get HandlePriority() : int
      {
         return IButtonUtils.BUTTON_PRIORITY_HOLD;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      override protected function SetupAlignment() : void
      {
         this.HoldLabelInstance_mc.justification = ButtonJustification;
         super.SetupAlignment();
      }
      
      public function CancelHold() : void
      {
         this.HoldStartDelayTimer.reset();
         this.StopHoldAnim();
      }
      
      protected function StartHoldAnim() : *
      {
         this._finishingAnimation = false;
         if(PCButtonInstance_mc != null)
         {
            PCButtonInstance_mc.holdArrowVisible = !KeyHelper.usingController;
         }
         if(ConsoleButtonInstance_mc != null)
         {
            ConsoleButtonInstance_mc.holdArrowVisible = KeyHelper.usingController;
         }
         if(LabelInstance_mc != null)
         {
            LabelInstance_mc.labelColor = this._dimmedTextColor;
         }
         if(this.HoldLabelInstance_mc != null)
         {
            this.HoldLabelInstance_mc.labelColor = this._baseTextColor;
         }
         if(Enabled)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_START_SOUND);
            if(this.HoldAnimationClip_mc != null)
            {
               this.HoldAnimScaler = new HoldButtonTimeScaler(this.HoldAnimationClip_mc,HOLD_IDLE,HOLD_START,HOLD_COMPLETE);
               this.HoldAnimationClip_mc.addEventListener(HOLD_FINISHED,this.OnHoldFinished);
               this.HoldAnimationClip_mc.addEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
            }
            if(this.HoldAnimScaler != null)
            {
               this.HoldAnimScaler.PlayScaledHoldAnimation();
            }
         }
         else if(Visible && Data.sClickFailedSound.length > 0)
         {
            GlobalFunc.PlayMenuSound(Data.sClickFailedSound);
         }
      }
      
      protected function StopHoldAnim() : *
      {
         if(this.Held)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_ABORT_SOUND);
         }
         this._finishingAnimation = false;
         var _loc1_:Boolean = this._pressAndReleaseEnabled && this._pressAndReleaseVisible;
         if(PCButtonInstance_mc != null)
         {
            PCButtonInstance_mc.holdArrowVisible = !KeyHelper.usingController && this._holdEnabled && !_loc1_;
         }
         if(ConsoleButtonInstance_mc != null)
         {
            ConsoleButtonInstance_mc.holdArrowVisible = KeyHelper.usingController && this._holdEnabled && !_loc1_;
         }
         if(LabelInstance_mc != null)
         {
            LabelInstance_mc.labelColor = this._holdEnabled && !_loc1_ ? this._dimmedTextColor : this._baseTextColor;
         }
         if(this.HoldLabelInstance_mc != null)
         {
            this.HoldLabelInstance_mc.labelColor = this._holdEnabled && !_loc1_ ? this._baseTextColor : this._dimmedTextColor;
         }
         if(this.HoldAnimScaler != null)
         {
            this.HoldAnimScaler.StopScaledHoldAnimation();
            this.HoldAnimScaler = null;
         }
         if(this.HoldAnimClip_mc != null)
         {
            this.HoldAnimClip_mc.removeEventListener(HOLD_FINISHED,this.OnHoldFinished);
            this.HoldAnimClip_mc.removeEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
         }
         if(PCButtonInstance_mc != null)
         {
            PCButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_FINISHED,this.OnHoldFinished);
            PCButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
         }
         if(ConsoleButtonInstance_mc != null)
         {
            ConsoleButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_FINISHED,this.OnHoldFinished);
            ConsoleButtonInstance_mc.HoldAnim_mc.removeEventListener(HOLD_END_ANIM_COMPLETE,this.OnHoldEndAnimComplete);
         }
      }
      
      protected function OnHoldFinished(param1:Event) : *
      {
         this._finishingAnimation = true;
         if(Enabled)
         {
            this.gotoAndPlay(!!bMouseOverButton ? BUTTON_CLICKED_MOUSE : BUTTON_CLICKED);
            if(Data.sClickSound.length > 0)
            {
               GlobalFunc.PlayMenuSound(Data.sClickSound);
            }
            else
            {
               GlobalFunc.PlayMenuSound(GlobalFunc.LONG_PRESS_COMPLETE_SOUND);
            }
         }
         else
         {
            this.gotoAndPlay(!!bMouseOverButton ? DISABLED_CLICK_FAILED_MOUSE : DISABLED_CLICK_FAILED);
            if(Visible && Data.sClickFailedSound.length > 0)
            {
               GlobalFunc.PlayMenuSound(Data.sClickFailedSound);
            }
         }
      }
      
      private function OnHoldEndAnimComplete(param1:Event) : *
      {
         if(Enabled && this.HeldEvent.bEnabled && this.HeldEvent.funcCallback != null)
         {
            this.HeldEvent.funcCallback();
         }
         if(Enabled && this.HeldEvent.bEnabled && this.HeldEvent.sCodeCallback.length > 0)
         {
            SendEvent(this.HeldEvent);
         }
         this._buttonState = this.BUTTON_STATE_NONE;
         this.StopHoldAnim();
      }
      
      override protected function UpdateLabelText() : void
      {
         if(Data != null)
         {
            if(this.HoldLabelInstance_mc != null)
            {
               this.HoldLabelInstance_mc.SetText(this.LastHoldLabelText,Data.SubstitutionsA,Data.UseHTML);
            }
         }
         super.UpdateLabelText();
      }
      
      override protected function UpdateButtonText() : void
      {
         var _loc1_:Boolean = false;
         if(!this.Held)
         {
            _loc1_ = this._pressAndReleaseEnabled && this._pressAndReleaseVisible;
            if(PCButtonInstance_mc != null)
            {
               PCButtonInstance_mc.holdArrowVisible = !KeyHelper.usingController && this._holdEnabled && !_loc1_;
            }
            if(ConsoleButtonInstance_mc != null)
            {
               ConsoleButtonInstance_mc.holdArrowVisible = KeyHelper.usingController && this._holdEnabled && !_loc1_;
            }
         }
         super.UpdateButtonText();
      }
      
      protected function set HoldLabelText(param1:String) : void
      {
         this.LastHoldLabelText = param1;
         invalidate(IButtonUtils.INVALID_LABEL_TEXT);
      }
      
      override public function SetButtonData(param1:ButtonData) : void
      {
         var _loc2_:Boolean = false;
         super.SetButtonData(param1);
         if(Data != null)
         {
            if(this.LastHoldLabelText != Data.sHoldText)
            {
               this.HoldLabelText = Data.sHoldText;
            }
            this.PressAndReleaseEvent = Data.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.PRESS_AND_RELEASE_EVENT_INDEX);
            this.HeldEvent = Data.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.HOLD_EVENT_INDEX);
            this._holdEnabled = this.HeldEvent.bEnabled;
            this._pressAndReleaseEnabled = this.PressAndReleaseEvent.bEnabled;
            this._pressAndReleaseVisible = Data.bPressAndReleaseVisible;
            _loc2_ = this._pressAndReleaseEnabled && this._pressAndReleaseVisible;
            if(this._holdEnabled && _loc2_)
            {
               if(PCButtonInstance_mc != null)
               {
                  PCButtonInstance_mc.holdArrowVisible = false;
               }
               if(ConsoleButtonInstance_mc != null)
               {
                  ConsoleButtonInstance_mc.holdArrowVisible = false;
               }
               if(LabelInstance_mc != null)
               {
                  LabelInstance_mc.labelColor = this._baseTextColor;
                  LabelInstance_mc.y = this._labelDefaultY + LABEL_UP;
                  LabelInstance_mc.visible = true;
               }
               if(this.HoldLabelInstance_mc != null)
               {
                  this.HoldLabelInstance_mc.labelColor = this._dimmedTextColor;
                  this.HoldLabelInstance_mc.y = this._labelDefaultY + LABEL_DOWN;
                  this.HoldLabelInstance_mc.visible = true;
               }
            }
            else if(this._holdEnabled)
            {
               if(PCButtonInstance_mc != null)
               {
                  PCButtonInstance_mc.holdArrowVisible = !KeyHelper.usingController;
               }
               if(ConsoleButtonInstance_mc != null)
               {
                  ConsoleButtonInstance_mc.holdArrowVisible = KeyHelper.usingController;
               }
               if(this.HoldLabelInstance_mc != null)
               {
                  this.HoldLabelInstance_mc.labelColor = this._baseTextColor;
                  this.HoldLabelInstance_mc.y = this._labelDefaultY;
                  this.HoldLabelInstance_mc.visible = true;
               }
               if(LabelInstance_mc != null)
               {
                  LabelInstance_mc.y = this._labelDefaultY;
                  LabelInstance_mc.visible = false;
               }
            }
            else if(_loc2_)
            {
               if(PCButtonInstance_mc != null)
               {
                  PCButtonInstance_mc.holdArrowVisible = false;
               }
               if(ConsoleButtonInstance_mc != null)
               {
                  ConsoleButtonInstance_mc.holdArrowVisible = false;
               }
               if(LabelInstance_mc != null)
               {
                  LabelInstance_mc.labelColor = this._baseTextColor;
                  LabelInstance_mc.y = this._labelDefaultY;
                  LabelInstance_mc.visible = true;
               }
               if(this.HoldLabelInstance_mc != null)
               {
                  this.HoldLabelInstance_mc.y = this._labelDefaultY;
                  this.HoldLabelInstance_mc.visible = false;
               }
            }
            SetBackgroundSize();
         }
      }
      
      override protected function UpdateClipAlignment() : void
      {
         switch(ButtonJustification)
         {
            case IButtonUtils.ICON_FIRST:
               if(this.HoldLabelInstance_mc != null)
               {
                  this.HoldLabelInstance_mc.x = OrigLabelX;
               }
               break;
            case IButtonUtils.LABEL_FIRST:
               if(this.HoldLabelInstance_mc != null)
               {
                  this.HoldLabelInstance_mc.x = -OrigLabelX;
               }
               break;
            case IButtonUtils.CENTER_BOTH:
               if(this.HoldLabelInstance_mc != null)
               {
                  this.HoldLabelInstance_mc.x = OrigLabelX;
               }
         }
         super.UpdateClipAlignment();
      }
      
      override protected function UpdateColor() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = undefined;
         if(bCustomColor)
         {
            super.UpdateColor();
            this.baseTextColor = uButtonColor;
            _loc1_ = this._dimmedTextColor;
            if(Data != null)
            {
               this.PressAndReleaseEvent = Data.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.PRESS_AND_RELEASE_EVENT_INDEX);
               this.HeldEvent = Data.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.HOLD_EVENT_INDEX);
               if(this.HeldEvent.bEnabled && (!this.PressAndReleaseEvent.bEnabled || !this._pressAndReleaseVisible))
               {
                  _loc1_ = this._baseTextColor;
               }
            }
            if(LabelInstance_mc != null)
            {
               LabelInstance_mc.labelColor = this._baseTextColor;
            }
            if(this.HoldLabelInstance_mc != null)
            {
               this.HoldLabelInstance_mc.labelColor = _loc1_;
            }
            if(this.HoldAnimClip_mc != null)
            {
               _loc2_ = new ColorTransform();
               _loc2_.color = this._baseTextColor;
               this.HoldAnimClip_mc.transform.colorTransform = _loc2_;
            }
         }
      }
      
      protected function OnMouseDown(param1:Event) : void
      {
         if(Enabled)
         {
            this._buttonState = this.BUTTON_STATE_DOWN;
            this.HeldEvent = Data.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.HOLD_EVENT_INDEX);
            if(this.HeldEvent.bEnabled)
            {
               this.HoldStartDelayTimer.start();
            }
         }
      }
      
      protected function OnMouseUp(param1:Event) : void
      {
         if(this._buttonState == this.BUTTON_STATE_DOWN)
         {
            this._buttonState = this.BUTTON_STATE_UP;
         }
         this.HoldStartDelayTimer.reset();
         if(!this._finishingAnimation)
         {
            this.StopHoldAnim();
         }
      }
      
      override protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!this._finishingAnimation && this._buttonState == this.BUTTON_STATE_UP)
         {
            if(param2 == null)
            {
               param2 = Data.UserEvents.GetUserEventByIndex(ReleaseHoldComboButtonData.PRESS_AND_RELEASE_EVENT_INDEX);
            }
            this.HoldStartDelayTimer.reset();
            this.StopHoldAnim();
            if(this._pressAndReleaseVisible)
            {
               _loc3_ = super.OnMouseClick(param1,param2);
            }
            else
            {
               _loc3_ = HandleButtonHit(param1,param2);
            }
         }
         this._buttonState = this.BUTTON_STATE_NONE;
         return _loc3_;
      }
      
      override public function HandleUserEvent(param1:String, param2:Boolean, param3:Boolean) : Boolean
      {
         var _loc4_:Boolean = param3;
         if(Enabled && param1 == this.PressAndReleaseEvent.sUserEvent)
         {
            if(param2)
            {
               this._buttonState = this.BUTTON_STATE_DOWN;
               if(this.HeldEvent.bEnabled)
               {
                  this.HoldStartDelayTimer.start();
               }
            }
            else
            {
               if(this._buttonState == this.BUTTON_STATE_DOWN)
               {
                  this._buttonState = this.BUTTON_STATE_UP;
               }
               else if(this._buttonState == this.BUTTON_STATE_HELD)
               {
                  if(!this._finishingAnimation)
                  {
                     this.StopHoldAnim();
                     _loc4_ = true;
                  }
               }
               this.HoldStartDelayTimer.reset();
               if(!_loc4_)
               {
                  _loc4_ = this.OnMouseClick(null,this.PressAndReleaseEvent);
               }
               this._buttonState = this.BUTTON_STATE_NONE;
            }
         }
         return _loc4_;
      }
      
      private function onHoldStartDelayTimerCompleted() : *
      {
         this._buttonState = this.BUTTON_STATE_HELD;
         this.StartHoldAnim();
         this.HoldStartDelayTimer.reset();
      }
      
      override protected function GetAdjustedBounds() : Rectangle
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc1_:Rectangle = super.GetAdjustedBounds();
         _loc2_ = _loc1_.topLeft.x;
         _loc3_ = _loc1_.topLeft.y;
         _loc4_ = _loc1_.bottomRight.x;
         _loc5_ = _loc1_.bottomRight.y;
         if(this.HoldLabelInstance_mc != null && this.HoldLabelInstance_mc.visible && GlobalFunc.StringTrim(this.HoldLabelInstance_mc.Label_tf.text).length > 0)
         {
            _addBackgroundSpace = true;
            _loc6_ = this.HoldLabelInstance_mc.GetBounds();
            _loc7_ = this.HoldLabel_mc.localToGlobal(_loc6_.topLeft);
            _loc8_ = this.HoldLabel_mc.localToGlobal(_loc6_.bottomRight);
            if(_loc7_.x < _loc2_)
            {
               _loc2_ = _loc7_.x;
            }
            if(_loc7_.y < _loc3_)
            {
               _loc3_ = _loc7_.y;
            }
            if(_loc8_.x > _loc4_)
            {
               _loc4_ = _loc8_.x;
            }
            if(_loc8_.y > _loc5_)
            {
               _loc5_ = _loc8_.y;
            }
         }
         _loc1_.topLeft = new Point(_loc2_,_loc3_);
         _loc1_.bottomRight = new Point(_loc4_,_loc5_);
         return _loc1_;
      }
   }
}
