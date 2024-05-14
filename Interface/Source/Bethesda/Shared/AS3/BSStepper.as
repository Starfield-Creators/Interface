package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BSStepper extends BSDisplayObject
   {
      
      public static const VALUE_CHANGED:String = "Stepper::VALUE_CHANGE";
      
      public static const INPUT_CHANGED:String = "Stepper::INPUT_CHANGE";
      
      public static const CONFIRM_INPUT_CHANGED:String = "Stepper::CONFIRM_INPUT_CHANGE";
      
      private static const CURSOR_LERP_TIME:Number = 0.25;
       
      
      public var textField:TextField;
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      public var LeftCatcher_mc:MovieClip;
      
      public var RightCatcher_mc:MovieClip;
      
      public var Cursor_mc:MovieClip;
      
      private const ARROW_SPACING:uint = 6;
      
      private var OptionArray:Array;
      
      private var uiSelectedIndex:uint = 0;
      
      private var _wrapAround:Boolean;
      
      private var _stationaryArrows:Boolean = false;
      
      private var _cursorLeftBound:Number = 36;
      
      private var _cursorRightBound:Number = 453;
      
      private var _stepperUpperBound:Number = 53;
      
      private var _stepperLowerBound:Number = 78;
      
      private var _cursorInitialLerpPosition:Number;
      
      private var _cursorFinalLerpPosition:Number;
      
      private var _cursorCurrentLerpTime:Number = -1;
      
      private var _previousTime:Number;
      
      private var _nextCursorRefreshIsAnimation:Boolean = false;
      
      private var OriginalLeftArrowX:uint = 0;
      
      private var OriginalRightArrowX:uint = 0;
      
      private var _stepperEnabled:Boolean = true;
      
      private var ConfirmDestructiveBehavior:Boolean = false;
      
      private var bDisableListWrap:Boolean = false;
      
      private var _characterLimit:uint = 0;
      
      public function BSStepper()
      {
         super();
         this.OriginalLeftArrowX = this.LeftArrow_mc.x;
         this.OriginalRightArrowX = this.RightArrow_mc.x;
         this.uiSelectedIndex = 0;
         this._wrapAround = true;
         Extensions.enabled = true;
         if(this._characterLimit == 0)
         {
            TextFieldEx.setTextAutoSize(this.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         BSUIDataManager.Subscribe("ListWrapData",this.OnListWrapDataUpdate);
      }
      
      public function set confirmBeforeChange(param1:Boolean) : *
      {
         this.ConfirmDestructiveBehavior = param1;
      }
      
      public function get confirmBeforeChange() : *
      {
         return this.ConfirmDestructiveBehavior;
      }
      
      public function set nextCursorRefreshIsAnimation(param1:Boolean) : *
      {
         this._nextCursorRefreshIsAnimation = param1;
      }
      
      public function get cursorLeftBound() : Number
      {
         return this._cursorLeftBound;
      }
      
      public function set cursorLeftBound(param1:Number) : void
      {
         this._cursorLeftBound = param1;
         this.RefreshCursor();
      }
      
      public function get cursorRightBound() : Number
      {
         return this._cursorRightBound;
      }
      
      public function set cursorRightBound(param1:Number) : void
      {
         this._cursorRightBound = param1;
         this.RefreshCursor();
      }
      
      public function get stepperUpperBound() : Number
      {
         return this._stepperUpperBound;
      }
      
      public function set stepperUpperBound(param1:Number) : void
      {
         this._stepperUpperBound = param1;
      }
      
      public function get stepperLowerBound() : Number
      {
         return this._stepperLowerBound;
      }
      
      public function set stepperLowerBound(param1:Number) : void
      {
         this._stepperLowerBound = param1;
         this.RefreshCursor();
      }
      
      public function get wrapAround() : Boolean
      {
         return this.bDisableListWrap ? false : this._wrapAround;
      }
      
      public function set wrapAround(param1:Boolean) : void
      {
         this._wrapAround = param1;
      }
      
      public function set stationaryArrows(param1:Boolean) : void
      {
         this._stationaryArrows = param1;
      }
      
      public function set characterLimit(param1:uint) : void
      {
         this._characterLimit = param1;
         if(this._characterLimit == 0)
         {
            TextFieldEx.setTextAutoSize(this.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         else
         {
            TextFieldEx.setTextAutoSize(this.textField,TextFieldEx.TEXTAUTOSZ_NONE);
         }
      }
      
      private function OnListWrapDataUpdate(param1:FromClientDataEvent) : void
      {
         this.bDisableListWrap = param1.data.bDisableListWrap;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.RefreshText();
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function get options() : Array
      {
         return this.OptionArray;
      }
      
      public function set options(param1:Array) : void
      {
         this.OptionArray = param1;
         this.RefreshText();
      }
      
      public function get index() : uint
      {
         return this.uiSelectedIndex;
      }
      
      public function set index(param1:uint) : void
      {
         if(this.OptionArray != null)
         {
            this.uiSelectedIndex = Math.min(param1,this.OptionArray.length - 1);
         }
         else
         {
            this.uiSelectedIndex = 0;
         }
         this.RefreshText();
      }
      
      public function get stepperEnabled() : Boolean
      {
         return this._stepperEnabled;
      }
      
      public function set stepperEnabled(param1:Boolean) : void
      {
         if(param1 != this._stepperEnabled)
         {
            this._stepperEnabled = param1;
            if(this._stepperEnabled)
            {
               addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
               addEventListener(MouseEvent.CLICK,this.onClick);
            }
            else
            {
               removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
               removeEventListener(MouseEvent.CLICK,this.onClick);
            }
         }
      }
      
      public function RefreshCursor() : void
      {
         var _loc1_:Number = NaN;
         if(this.OptionArray != null && this.OptionArray.length > 1)
         {
            if(this.Cursor_mc != null)
            {
               if(this._nextCursorRefreshIsAnimation)
               {
                  this._nextCursorRefreshIsAnimation = false;
                  _loc1_ = this.GetCursorPositionAtIndex(this.uiSelectedIndex);
                  if(this.Cursor_mc.x != _loc1_)
                  {
                     this._cursorCurrentLerpTime = CURSOR_LERP_TIME;
                     this._cursorInitialLerpPosition = this.Cursor_mc.x;
                     this._cursorFinalLerpPosition = _loc1_;
                     this._previousTime = -1;
                     addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
                  }
               }
               else
               {
                  this._cursorFinalLerpPosition = this.GetCursorPositionAtIndex(this.uiSelectedIndex);
                  this.Cursor_mc.x = this.GetCurrentCursorPosition();
               }
            }
         }
      }
      
      private function RefreshText() : void
      {
         if(this.OptionArray != null)
         {
            GlobalFunc.SetText(this.textField,this.OptionArray[this.uiSelectedIndex],false,false,this._characterLimit);
         }
         var _loc1_:Boolean = this.OptionArray != null && this.OptionArray.length > 1;
         this.LeftArrow_mc.visible = _loc1_ && (this.index > 0 || this.wrapAround);
         this.RightArrow_mc.visible = _loc1_ && (this.index < this.OptionArray.length - 1 || this.wrapAround);
         this.RefreshCursor();
         var _loc2_:TextLineMetrics = this.textField.getLineMetrics(0);
         this.LeftArrow_mc.x = this._stationaryArrows ? this.OriginalLeftArrowX : this.textField.x + _loc2_.x;
         this.RightArrow_mc.x = this._stationaryArrows ? this.OriginalRightArrowX : this.textField.x + _loc2_.x + _loc2_.width + this.ARROW_SPACING;
      }
      
      public function DecrementCallback() : *
      {
         this._nextCursorRefreshIsAnimation = true;
         if(this.wrapAround && this.index == 0)
         {
            this.index = this.OptionArray.length - 1;
         }
         else
         {
            --this.index;
         }
         dispatchEvent(new Event(VALUE_CHANGED,true,true));
      }
      
      private function Decrement() : void
      {
         if(this.confirmBeforeChange)
         {
            dispatchEvent(new CustomEvent(CONFIRM_INPUT_CHANGED,{"Func":this.DecrementCallback}));
         }
         else
         {
            this.DecrementCallback();
         }
      }
      
      public function IncrementCallback() : void
      {
         this._nextCursorRefreshIsAnimation = true;
         if(this.wrapAround)
         {
            this.index = (this.index + 1) % this.OptionArray.length;
         }
         else
         {
            this.index += 1;
         }
         dispatchEvent(new Event(VALUE_CHANGED,true,true));
      }
      
      private function Increment() : void
      {
         if(this.confirmBeforeChange)
         {
            dispatchEvent(new CustomEvent(CONFIRM_INPUT_CHANGED,{"Func":this.IncrementCallback}));
         }
         else
         {
            this.IncrementCallback();
         }
      }
      
      public function PressCallback() : *
      {
         this._nextCursorRefreshIsAnimation = true;
         this.index = (this.index + 1) % this.OptionArray.length;
         dispatchEvent(new Event(VALUE_CHANGED,true,true));
         dispatchEvent(new Event(INPUT_CHANGED,true,true));
      }
      
      public function PressHandler() : void
      {
         if(this.stepperEnabled)
         {
            if(this.confirmBeforeChange)
            {
               dispatchEvent(new CustomEvent(CONFIRM_INPUT_CHANGED,{"Func":this.PressCallback}));
            }
            else
            {
               this.PressCallback();
            }
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(this.stepperEnabled && param1.keyCode == Keyboard.LEFT && (this.index > 0 || this.wrapAround))
         {
            this.Decrement();
            param1.stopPropagation();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
         else if(this.stepperEnabled && param1.keyCode == Keyboard.RIGHT && (this.index < this.OptionArray.length - 1 || this.wrapAround))
         {
            this.Increment();
            param1.stopPropagation();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
      }
      
      public function onRollover() : void
      {
         if(currentFrameLabel != "Selected")
         {
            gotoAndPlay("Selected");
            this.RefreshCursor();
         }
      }
      
      public function onRollout() : void
      {
         if(currentFrameLabel != "Unselected")
         {
            gotoAndPlay("Unselected");
            this.RefreshCursor();
         }
      }
      
      public function SelectCallback() : *
      {
         this.nextCursorRefreshIsAnimation = false;
         var _loc1_:Point = globalToLocal(new Point(stage.mouseX,stage.mouseY));
         var _loc2_:Number = (_loc1_.x - this.cursorLeftBound) / (this.cursorRightBound - this.cursorLeftBound);
         this.index = Math.round(_loc2_ * Number(this.OptionArray.length));
         dispatchEvent(new Event(VALUE_CHANGED,true,true));
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this.stepperEnabled && this.OptionArray.length > 1)
         {
            _loc2_ = globalToLocal(new Point(stage.mouseX,stage.mouseY));
            if(_loc2_.x >= this.cursorLeftBound && _loc2_.x <= this.cursorRightBound && _loc2_.y >= this.stepperUpperBound && _loc2_.y <= this.stepperLowerBound)
            {
               if(this.confirmBeforeChange)
               {
                  dispatchEvent(new CustomEvent(CONFIRM_INPUT_CHANGED,{"Func":this.SelectCallback}));
               }
               else
               {
                  this.SelectCallback();
               }
            }
            else if(param1.target == this.LeftCatcher_mc && (this.index > 0 || this.wrapAround))
            {
               this.Decrement();
               param1.stopPropagation();
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
            else if(param1.target == this.RightCatcher_mc && (this.index < this.OptionArray.length - 1 || this.wrapAround))
            {
               this.Increment();
               param1.stopPropagation();
               dispatchEvent(new Event(INPUT_CHANGED,true,true));
            }
         }
      }
      
      private function GetCurrentCursorPosition() : Number
      {
         var _loc1_:Number = 0;
         if(this._cursorCurrentLerpTime == -1)
         {
            _loc1_ = this.GetCursorPositionAtIndex(this.uiSelectedIndex);
         }
         else
         {
            _loc1_ = this._cursorInitialLerpPosition + (this._cursorFinalLerpPosition - this._cursorInitialLerpPosition) * ((CURSOR_LERP_TIME - this._cursorCurrentLerpTime) / CURSOR_LERP_TIME);
         }
         return _loc1_;
      }
      
      private function GetCursorPositionAtIndex(param1:int) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = 0;
         if(this.OptionArray.length > 1)
         {
            _loc3_ = Number(this.uiSelectedIndex) / Number(this.OptionArray.length - 1);
            _loc3_ = Math.min(1,_loc3_);
            _loc2_ = this.cursorLeftBound + (this.cursorRightBound - this.cursorLeftBound) * _loc3_;
         }
         return _loc2_;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this._previousTime == -1)
         {
            this._previousTime = getTimer();
            return;
         }
         var _loc2_:Number = getTimer();
         var _loc3_:Number = (_loc2_ - this._previousTime) / 1000;
         this._previousTime = _loc2_;
         this._cursorCurrentLerpTime -= _loc3_;
         if(this._cursorCurrentLerpTime <= 0)
         {
            this._cursorCurrentLerpTime = -1;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.Cursor_mc.x = this._cursorFinalLerpPosition;
         }
         else
         {
            this.Cursor_mc.x = this.GetCurrentCursorPosition();
         }
      }
   }
}
