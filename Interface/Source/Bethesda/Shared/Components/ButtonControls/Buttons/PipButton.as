package Shared.Components.ButtonControls.Buttons
{
   import Shared.Components.ButtonControls.ButtonData.PipButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class PipButton extends ButtonBase
   {
      
      protected static const SELECTED:String = "Selected";
      
      protected static const UNSELECTED:String = "Unselected";
      
      public static const ANIMATION_FINISHED:String = "AnimationFinished";
       
      
      private var AnimationQueue:Array;
      
      protected var _selected:Boolean = false;
      
      private var _playingAnimation:Boolean = false;
      
      public function PipButton()
      {
         this.AnimationQueue = new Array();
         super();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         if(this._selected != param1)
         {
            this._selected = param1;
            _loc2_ = {
               "bUseStop":true,
               "sFrameLabel":(this.selected ? SELECTED : UNSELECTED)
            };
            this.PlayAnimation(_loc2_);
         }
      }
      
      private function set playingAnimation(param1:Boolean) : void
      {
         this._playingAnimation = param1;
         if(this._playingAnimation)
         {
            addEventListener(ANIMATION_FINISHED,this.AnimationFinished);
         }
         else
         {
            removeEventListener(ANIMATION_FINISHED,this.AnimationFinished);
         }
      }
      
      override protected function OnMouseRollOut(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(Data != null && !this.selected)
         {
            _loc2_ = {
               "bUseStop":false,
               "sFrameLabel":ROLL_OFF
            };
            this.PlayAnimation(_loc2_);
            bMouseOverButton = false;
            GlobalFunc.PlayMenuSound(Data.sRolloverSound);
         }
      }
      
      override protected function OnMouseRollOver(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(Data != null && !this.selected)
         {
            _loc2_ = {
               "bUseStop":false,
               "sFrameLabel":ROLL_ON
            };
            this.PlayAnimation(_loc2_);
            bMouseOverButton = true;
            GlobalFunc.PlayMenuSound(Data.sRolloverSound);
         }
      }
      
      override public function set Enabled(param1:Boolean) : void
      {
         bEnabled = param1;
         var _loc2_:Object = null;
         if(bEnabled)
         {
            this.addEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
            this.addEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
            _loc2_ = {
               "bUseStop":true,
               "sFrameLabel":(this.selected ? SELECTED : UNSELECTED)
            };
            this.PlayAnimation(_loc2_);
         }
         else
         {
            this.removeEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
            this.removeEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
            _loc2_ = {
               "bUseStop":true,
               "sFrameLabel":DISABLED
            };
            this.PlayAnimation(_loc2_);
         }
      }
      
      override protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc3_:Boolean = false;
         if(!this.selected)
         {
            if(param2 != null)
            {
               if(Enabled && param2.bEnabled)
               {
                  if(Data.sClickSound.length > 0)
                  {
                     GlobalFunc.PlayMenuSound(Data.sClickSound);
                  }
               }
               else if(Visible && Data.sClickFailedSound.length > 0)
               {
                  GlobalFunc.PlayMenuSound(Data.sClickFailedSound);
               }
            }
            _loc3_ = this.HandleButtonHit(param1,param2);
            if(_loc3_)
            {
               _loc4_ = "";
               if(Enabled)
               {
                  _loc4_ = !!bMouseOverButton ? BUTTON_CLICKED_MOUSE : BUTTON_CLICKED;
               }
               else
               {
                  _loc4_ = !!bMouseOverButton ? DISABLED_CLICK_FAILED_MOUSE : DISABLED_CLICK_FAILED;
               }
               _loc5_ = {
                  "bUseStop":false,
                  "sFrameLabel":_loc4_
               };
               this.PlayAnimation(_loc5_);
            }
         }
         return _loc3_;
      }
      
      override protected function HandleButtonHit(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == null && Data.UserEvents.NumUserEvents == 1)
         {
            param2 = Data.UserEvents.GetUserEventByIndex(0);
         }
         if(param2 != null)
         {
            if(Enabled && param2.bEnabled && param2.funcCallback != null && Data is PipButtonData)
            {
               param2.funcCallback((Data as PipButtonData).PipIndex);
            }
            if(Enabled && param2.bEnabled && param2.sCodeCallback.length > 0)
            {
               SendEvent(param2);
            }
            _loc3_ = Enabled && param2.bEnabled;
         }
         return _loc3_;
      }
      
      override public function set Width(param1:Number) : void
      {
         ButtonBackground_mc.ButtonBackgroundResizable_mc.width = param1;
      }
      
      override protected function UpdateColor() : void
      {
         var _loc1_:ColorTransform = null;
         if(bCustomColor)
         {
            super.UpdateColor();
            _loc1_ = ButtonBackground_mc.ButtonBackgroundResizable_mc.transform.colorTransform;
            _loc1_.color = uButtonColor;
            ButtonBackground_mc.ButtonBackgroundResizable_mc.transform.colorTransform = _loc1_;
         }
      }
      
      private function PlayAnimation(param1:Object) : void
      {
         if(!this._playingAnimation)
         {
            if(param1.sFrameLabel != currentFrameLabel)
            {
               this.playingAnimation = true;
               if(param1.bUseStop)
               {
                  gotoAndStop(param1.sFrameLabel);
               }
               else
               {
                  gotoAndPlay(param1.sFrameLabel);
               }
            }
            else
            {
               this.AnimationFinished();
            }
         }
         else
         {
            this.AnimationQueue.push(param1);
         }
      }
      
      private function AnimationFinished() : void
      {
         this.playingAnimation = false;
         var _loc1_:Object = this.AnimationQueue.shift();
         if(_loc1_ != null)
         {
            this.PlayAnimation(_loc1_);
         }
      }
   }
}
