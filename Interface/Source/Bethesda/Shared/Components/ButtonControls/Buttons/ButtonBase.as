package Shared.Components.ButtonControls.Buttons
{
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ButtonBase extends MinimalButton
   {
      
      protected static const ROLL_ON:String = "RollOn";
      
      protected static const ROLL_OFF:String = "RollOff";
      
      protected static const BUTTON_CLICKED:String = "ButtonClicked";
      
      protected static const BUTTON_CLICKED_MOUSE:String = "ButtonClickedMouse";
      
      protected static const DISABLED_CLICK_FAILED:String = "ClickFailed";
      
      protected static const DISABLED_CLICK_FAILED_MOUSE:String = "ClickFailedMouse";
      
      protected static const DISABLED:String = "Disabled";
      
      public static const BUTTON_REDRAWN_EVENT:String = "ButtonRedrawnEvent";
       
      
      public var ButtonBackground_mc:MovieClip;
      
      protected var sLabelAlign:* = "left";
      
      protected var sButtonAlign:* = "right";
      
      protected var ButtonJustification:int;
      
      protected var OrigLabelX:Number;
      
      protected var OrigButtonX:Number;
      
      protected var _addBackgroundSpace:Boolean = false;
      
      protected var DisableRollSounds:Boolean = false;
      
      public function ButtonBase()
      {
         this.ButtonJustification = IButtonUtils.LABEL_FIRST;
         super();
         if(LabelInstance_mc != null)
         {
            this.OrigLabelX = Math.abs(LabelInstance_mc.x);
         }
         if(PCButtonInstance_mc != null)
         {
            this.OrigButtonX = Math.abs(PCButtonInstance_mc.x);
         }
         else if(ConsoleButtonInstance_mc != null)
         {
            this.OrigButtonX = Math.abs(ConsoleButtonInstance_mc.x);
         }
         this.SetupAlignment();
         this.UpdateButtonEnabledStateInfo();
      }
      
      public function set disableRollSounds(param1:Boolean) : *
      {
         this.DisableRollSounds = param1;
      }
      
      public function set justification(param1:int) : *
      {
         if(param1 != this.ButtonJustification)
         {
            this.ButtonJustification = param1;
            this.SetupAlignment();
         }
      }
      
      public function get justification() : int
      {
         return this.ButtonJustification;
      }
      
      protected function SetupAlignment() : void
      {
         if(LabelInstance_mc != null)
         {
            LabelInstance_mc.justification = this.ButtonJustification;
         }
         if(PCButtonInstance_mc != null)
         {
            PCButtonInstance_mc.justification = this.ButtonJustification;
         }
         if(ConsoleButtonInstance_mc != null)
         {
            ConsoleButtonInstance_mc.justification = this.ButtonJustification;
         }
         this.RealignClips();
      }
      
      protected function RealignClips() : void
      {
         invalidate(IButtonUtils.INVALID_ALIGNMENT);
         this.SetBackgroundSize();
      }
      
      protected function UpdateClipAlignment() : void
      {
         switch(this.ButtonJustification)
         {
            case IButtonUtils.ICON_FIRST:
               if(LabelInstance_mc != null)
               {
                  LabelInstance_mc.x = this.OrigLabelX;
               }
               if(PCButtonInstance_mc != null)
               {
                  PCButtonInstance_mc.x = -this.OrigButtonX;
               }
               if(ConsoleButtonInstance_mc != null)
               {
                  ConsoleButtonInstance_mc.x = -this.OrigButtonX;
               }
               break;
            case IButtonUtils.LABEL_FIRST:
               if(LabelInstance_mc != null)
               {
                  LabelInstance_mc.x = -this.OrigLabelX;
               }
               if(PCButtonInstance_mc != null)
               {
                  PCButtonInstance_mc.x = this.OrigButtonX;
               }
               if(ConsoleButtonInstance_mc != null)
               {
                  ConsoleButtonInstance_mc.x = this.OrigButtonX;
               }
               break;
            case IButtonUtils.CENTER_BOTH:
               if(LabelInstance_mc != null)
               {
                  LabelInstance_mc.x = this.OrigLabelX;
               }
               if(PCButtonInstance_mc != null)
               {
                  PCButtonInstance_mc.x = this.OrigButtonX;
               }
               if(ConsoleButtonInstance_mc != null)
               {
                  ConsoleButtonInstance_mc.x = this.OrigButtonX;
               }
         }
         clearInvalidation(IButtonUtils.INVALID_ALIGNMENT);
      }
      
      protected function UpdateBackground() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         if(stage != null && Data != null && this.ButtonBackground_mc != null)
         {
            _loc1_ = this.GetAdjustedBounds();
            _loc2_ = this.ButtonBackground_mc.globalToLocal(_loc1_.topLeft);
            _loc3_ = this.ButtonBackground_mc.globalToLocal(_loc1_.bottomRight);
            _loc4_ = this._addBackgroundSpace ? BACKGROUND_SPACING : 0;
            this.ButtonBackground_mc.ButtonBackgroundResizable_mc.width = _loc3_.x - _loc2_.x + _loc4_;
            this.ButtonBackground_mc.ButtonBackgroundResizable_mc.height = _loc3_.y - _loc2_.y + _loc4_;
            this.ButtonBackground_mc.ButtonBackgroundResizable_mc.x = _loc2_.x - _loc4_ / 2;
            this.ButtonBackground_mc.ButtonBackgroundResizable_mc.y = _loc2_.y - _loc4_ / 2;
         }
         clearInvalidation(IButtonUtils.INVALID_BACKGROUND);
      }
      
      protected function GetAdjustedBounds() : Rectangle
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Rectangle = null;
         var _loc13_:Point = null;
         var _loc14_:Point = null;
         var _loc15_:Point = null;
         var _loc16_:Point = null;
         this._addBackgroundSpace = true;
         var _loc1_:Rectangle = new Rectangle();
         _loc2_ = Number.MAX_VALUE;
         _loc3_ = Number.MAX_VALUE;
         _loc4_ = -Number.MAX_VALUE;
         _loc5_ = -Number.MAX_VALUE;
         if(PCButtonInstance_mc != null && PCButtonInstance_mc.visible)
         {
            _loc8_ = PCButtonInstance_mc.GetBounds();
            _loc6_ = PCButton_mc.localToGlobal(_loc8_.topLeft);
            _loc7_ = PCButton_mc.localToGlobal(_loc8_.bottomRight);
            if(_loc6_.x < _loc2_)
            {
               _loc2_ = _loc6_.x;
            }
            if(_loc6_.y < _loc3_)
            {
               _loc3_ = _loc6_.y;
            }
            if(_loc7_.x > _loc4_)
            {
               _loc4_ = _loc7_.x;
            }
            if(_loc7_.y > _loc5_)
            {
               _loc5_ = _loc7_.y;
            }
         }
         if(ConsoleButtonInstance_mc != null && ConsoleButtonInstance_mc.visible)
         {
            _loc9_ = ConsoleButtonInstance_mc.GetBounds();
            _loc10_ = ConsoleButton_mc.localToGlobal(_loc9_.topLeft);
            _loc11_ = ConsoleButton_mc.localToGlobal(_loc9_.bottomRight);
            if(_loc10_.x < _loc2_)
            {
               _loc2_ = _loc10_.x;
            }
            if(_loc10_.y < _loc3_)
            {
               _loc3_ = _loc10_.y;
            }
            if(_loc11_.x > _loc4_)
            {
               _loc4_ = _loc11_.x;
            }
            if(_loc11_.y > _loc5_)
            {
               _loc5_ = _loc11_.y;
            }
         }
         if(LabelInstance_mc != null && LabelInstance_mc.visible && GlobalFunc.StringTrim(LabelInstance_mc.Label_tf.text).length > 0)
         {
            _loc12_ = LabelInstance_mc.GetBounds();
            _loc13_ = Label_mc.localToGlobal(_loc12_.topLeft);
            _loc14_ = Label_mc.localToGlobal(_loc12_.bottomRight);
            if(_loc13_.x < _loc2_)
            {
               _loc2_ = _loc13_.x;
            }
            if(_loc13_.y < _loc3_)
            {
               _loc3_ = _loc13_.y;
            }
            if(_loc14_.x > _loc4_)
            {
               _loc4_ = _loc14_.x;
            }
            if(_loc14_.y > _loc5_)
            {
               _loc5_ = _loc14_.y;
            }
         }
         if(_loc2_ == Number.MAX_VALUE || _loc3_ == Number.MAX_VALUE || _loc4_ == -Number.MAX_VALUE || _loc5_ == -Number.MAX_VALUE)
         {
            this._addBackgroundSpace = false;
            _loc15_ = this.ButtonBackground_mc.localToGlobal(new Point(this.ButtonBackground_mc.x,this.ButtonBackground_mc.y));
            _loc16_ = this.ButtonBackground_mc.localToGlobal(new Point(this.ButtonBackground_mc.x + this.ButtonBackground_mc.width,this.ButtonBackground_mc.y + this.ButtonBackground_mc.height));
            if(_loc15_.x < _loc2_)
            {
               _loc2_ = _loc15_.x;
            }
            if(_loc15_.y < _loc3_)
            {
               _loc3_ = _loc15_.y;
            }
            if(_loc16_.x > _loc4_)
            {
               _loc4_ = _loc16_.x;
            }
            if(_loc16_.y > _loc5_)
            {
               _loc5_ = _loc16_.y;
            }
         }
         _loc1_.topLeft = new Point(_loc2_,_loc3_);
         _loc1_.bottomRight = new Point(_loc4_,_loc5_);
         return _loc1_;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.SetBackgroundSize();
      }
      
      override public function redrawDisplayObject() : void
      {
         super.redrawDisplayObject();
         if(isInvalid(IButtonUtils.INVALID_ALIGNMENT))
         {
            this.UpdateClipAlignment();
         }
         if(isInvalid(IButtonUtils.INVALID_BACKGROUND))
         {
            this.UpdateBackground();
         }
         dispatchEvent(new Event(BUTTON_REDRAWN_EVENT));
      }
      
      override public function SetButtonData(param1:ButtonData) : void
      {
         super.SetButtonData(param1);
         this.RealignClips();
      }
      
      override protected function SetButtonText() : void
      {
         super.SetButtonText();
         this.RealignClips();
      }
      
      protected function SetBackgroundSize() : void
      {
         invalidate(IButtonUtils.INVALID_BACKGROUND);
      }
      
      override protected function UpdateButtonEnabledStateInfo() : void
      {
         super.UpdateButtonEnabledStateInfo();
         if(bEnabled)
         {
            this.addEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
            this.addEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
            gotoAndStop(1);
         }
         else
         {
            this.removeEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
            this.removeEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
            gotoAndStop(DISABLED);
         }
      }
      
      protected function OnMouseRollOut(param1:Event) : void
      {
         if(Data != null)
         {
            this.gotoAndPlay(ROLL_OFF);
            bMouseOverButton = false;
            if(!this.DisableRollSounds)
            {
               GlobalFunc.PlayMenuSound(Data.sRolloverSound);
            }
         }
      }
      
      protected function OnMouseRollOver(param1:Event) : void
      {
         if(Data != null)
         {
            this.gotoAndPlay(ROLL_ON);
            bMouseOverButton = true;
            if(!this.DisableRollSounds)
            {
               GlobalFunc.PlayMenuSound(Data.sRolloverSound);
            }
         }
      }
      
      override protected function OnMouseClick(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc3_:Boolean = super.OnMouseClick(param1,param2);
         if(_loc3_)
         {
            if(Enabled)
            {
               this.gotoAndPlay(!!bMouseOverButton ? BUTTON_CLICKED_MOUSE : BUTTON_CLICKED);
            }
            else
            {
               this.gotoAndPlay(!!bMouseOverButton ? DISABLED_CLICK_FAILED_MOUSE : DISABLED_CLICK_FAILED);
            }
         }
         return _loc3_;
      }
   }
}
