package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class HeadPartsPlusSelector extends MovieClip
   {
      
      private static const NUM_OF_BOXES_IN_ROW:int = 5;
      
      public static const CANCEL_CLICKED:String = "CANCEL_CLICKED";
       
      
      public var Dot_mc:MovieClip;
      
      public var FaceSlider_mc:MovieClip;
      
      private var OriginalDotLoc:Point;
      
      private var TRAVEL_DIST:Number = 70;
      
      private var CENTER_CIRCLE:Number = 10;
      
      private var MOVEMENT_AMOUNT:Number = 5;
      
      private var IsDragging:Boolean = false;
      
      private var Active:Boolean = false;
      
      private var SliderIDsA:Array;
      
      private var Square:Number = 0;
      
      private var Round:Number = 0;
      
      private var Wide:Number = 0;
      
      private var Thin:Number = 0;
      
      private var MouseDotSoundTimer:Timer;
      
      private var bAllowMouseDotSound:Boolean = true;
      
      private const HIGHLIGHT_MAX_ALPHA:Number = 0.8;
      
      private const HIGHLIGHT_MID_ALPHA:Number = 0.4;
      
      private const HIGHLIGHT_LOW_ALPHA:Number = 0.2;
      
      public function HeadPartsPlusSelector()
      {
         this.OriginalDotLoc = new Point();
         this.SliderIDsA = new Array();
         this.MouseDotSoundTimer = new Timer(100,1);
         super();
         this.OriginalDotLoc.x = this.Dot_mc.x;
         this.OriginalDotLoc.y = this.Dot_mc.y;
         this.Dot_mc.alpha = 0;
         this.MouseDotSoundTimer.addEventListener(TimerEvent.TIMER,this.onMouseDotSoundTimerRefresh);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
      }
      
      public function get active() : *
      {
         return this.Active;
      }
      
      public function set active(param1:Boolean) : *
      {
         this.Active = param1;
         if(this.Active)
         {
            addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
            addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
            addEventListener(Event.FRAME_CONSTRUCTED,this.onFrameChanged);
         }
         else
         {
            removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
            removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
            removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameChanged);
         }
      }
      
      protected function onRollOver(param1:MouseEvent) : void
      {
         this.active = true;
      }
      
      protected function onRollOut(param1:MouseEvent) : void
      {
         this.active = false;
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         switch(param1.keyCode)
         {
            case Keyboard.LEFT:
               this.onLeft();
               break;
            case Keyboard.RIGHT:
               this.onRight();
               break;
            case Keyboard.UP:
               this.onUp();
               break;
            case Keyboard.DOWN:
               this.onDown();
         }
         this.onSelectorChange();
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         this.onSelectorChange();
      }
      
      public function UpdateDotPositionByMouse(param1:Boolean) : *
      {
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         var _loc3_:Point = globalToLocal(_loc2_);
         var _loc4_:Point = _loc3_.subtract(this.OriginalDotLoc);
         var _loc5_:* = Math.abs(_loc4_.y) > Math.abs(_loc4_.x);
         this.Dot_mc.x = (_loc5_ ? 0 : GlobalFunc.Clamp(_loc4_.x,-this.TRAVEL_DIST,this.TRAVEL_DIST)) + this.OriginalDotLoc.x;
         this.Dot_mc.y = (_loc5_ ? GlobalFunc.Clamp(_loc4_.y,-this.TRAVEL_DIST,this.TRAVEL_DIST) : 0) + this.OriginalDotLoc.y;
         if(this.bAllowMouseDotSound)
         {
            this.bAllowMouseDotSound = false;
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
            this.MouseDotSoundTimer.stop();
            this.MouseDotSoundTimer.reset();
            this.MouseDotSoundTimer.start();
         }
         if(param1)
         {
            this.onSelectorChange();
         }
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         if(this.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.UpdateDotPositionByMouse(false);
            this.IsDragging = true;
         }
      }
      
      public function OnMouseMove(param1:MouseEvent) : void
      {
         if(this.IsDragging)
         {
            this.UpdateDotPositionByMouse(false);
            this.onSelectorChange();
         }
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         if(this.IsDragging)
         {
            this.UpdateDotPositionByMouse(true);
            this.IsDragging = false;
         }
      }
      
      public function InitializeSliders(param1:Array, param2:uint) : *
      {
         this.SliderIDsA.splice(0);
         if(param1.length == 4)
         {
            switch(param2)
            {
               case 0:
                  this.SliderIDsA.push(param1[0].ID);
                  this.SliderIDsA.push(param1[3].ID);
                  this.SliderIDsA.push(param1[2].ID);
                  this.SliderIDsA.push(param1[1].ID);
                  this.Dot_mc.x = this.OriginalDotLoc.x + param1[2].Value * this.TRAVEL_DIST + -param1[3].Value * this.TRAVEL_DIST;
                  this.Dot_mc.y = this.OriginalDotLoc.y + -param1[0].Value * this.TRAVEL_DIST + param1[1].Value * this.TRAVEL_DIST;
                  break;
               case 1:
                  this.SliderIDsA.push(param1[0].ID);
                  this.SliderIDsA.push(param1[1].ID);
                  this.SliderIDsA.push(param1[3].ID);
                  this.SliderIDsA.push(param1[2].ID);
                  this.Dot_mc.x = this.OriginalDotLoc.x + -param1[2].Value * this.TRAVEL_DIST + param1[3].Value * this.TRAVEL_DIST;
                  this.Dot_mc.y = this.OriginalDotLoc.y + -param1[0].Value * this.TRAVEL_DIST + param1[1].Value * this.TRAVEL_DIST;
            }
            this.SetFocus(true);
         }
      }
      
      private function onSelectorChange() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = 0;
         this.Square = 0;
         this.Round = 0;
         this.Wide = 0;
         this.Thin = 0;
         if(this.Dot_mc.y - this.OriginalDotLoc.y > 0)
         {
            this.Round = GlobalFunc.MapLinearlyToRange(0,1,0,this.TRAVEL_DIST,this.Dot_mc.y - this.OriginalDotLoc.y,true);
         }
         else if(this.Dot_mc.y - this.OriginalDotLoc.y < 0)
         {
            this.Square = GlobalFunc.MapLinearlyToRange(0,1,0,this.TRAVEL_DIST,this.OriginalDotLoc.y - this.Dot_mc.y,true);
         }
         else if(this.Dot_mc.x - this.OriginalDotLoc.x > 0)
         {
            this.Wide = GlobalFunc.MapLinearlyToRange(0,1,0,this.TRAVEL_DIST,this.Dot_mc.x - this.OriginalDotLoc.x,true);
         }
         else if(this.Dot_mc.x - this.OriginalDotLoc.x < 0)
         {
            this.Thin = GlobalFunc.MapLinearlyToRange(0,1,0,this.TRAVEL_DIST,this.OriginalDotLoc.x - this.Dot_mc.x,true);
         }
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_HeadpartPlusSelectorChange",{
            "fSquare":this.Square,
            "uSquareID":this.SliderIDsA[0],
            "fRound":this.Round,
            "uRoundID":this.SliderIDsA[1],
            "fWide":this.Wide,
            "uWideID":this.SliderIDsA[2],
            "fThin":this.Thin,
            "uThinID":this.SliderIDsA[3]
         }));
         CharGenMenu.characterDirty = true;
         this.UpdateSliderBoxes();
      }
      
      private function onLeft() : *
      {
         if(Math.abs(this.Dot_mc.y - this.OriginalDotLoc.y) < this.CENTER_CIRCLE && this.Dot_mc.x > this.OriginalDotLoc.x - this.TRAVEL_DIST)
         {
            this.Dot_mc.y = this.OriginalDotLoc.y;
            this.Dot_mc.x -= this.MOVEMENT_AMOUNT;
            if(this.Dot_mc.x < this.OriginalDotLoc.x - this.TRAVEL_DIST)
            {
               this.Dot_mc.x = this.OriginalDotLoc.x - this.TRAVEL_DIST;
            }
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
         }
      }
      
      private function onRight() : *
      {
         if(Math.abs(this.Dot_mc.y - this.OriginalDotLoc.y) < this.CENTER_CIRCLE && this.Dot_mc.x < this.OriginalDotLoc.x + this.TRAVEL_DIST)
         {
            this.Dot_mc.y = this.OriginalDotLoc.y;
            this.Dot_mc.x += this.MOVEMENT_AMOUNT;
            if(this.Dot_mc.x > this.OriginalDotLoc.x + this.TRAVEL_DIST)
            {
               this.Dot_mc.x = this.OriginalDotLoc.x + this.TRAVEL_DIST;
            }
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
         }
      }
      
      private function onUp() : *
      {
         if(Math.abs(this.Dot_mc.x - this.OriginalDotLoc.x) < this.CENTER_CIRCLE && this.Dot_mc.y > this.OriginalDotLoc.y - this.TRAVEL_DIST)
         {
            this.Dot_mc.x = this.OriginalDotLoc.x;
            this.Dot_mc.y -= this.MOVEMENT_AMOUNT;
            if(this.Dot_mc.y < this.OriginalDotLoc.y - this.TRAVEL_DIST)
            {
               this.Dot_mc.y = this.OriginalDotLoc.y - this.TRAVEL_DIST;
            }
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
         }
      }
      
      private function onDown() : *
      {
         if(Math.abs(this.Dot_mc.x - this.OriginalDotLoc.x) < this.CENTER_CIRCLE && this.Dot_mc.y < this.OriginalDotLoc.y + this.TRAVEL_DIST)
         {
            this.Dot_mc.x = this.OriginalDotLoc.x;
            this.Dot_mc.y += this.MOVEMENT_AMOUNT;
            if(this.Dot_mc.y > this.OriginalDotLoc.y + this.TRAVEL_DIST)
            {
               this.Dot_mc.y = this.OriginalDotLoc.y + this.TRAVEL_DIST;
            }
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
         }
      }
      
      private function onCancelClicked() : *
      {
         dispatchEvent(new Event(CANCEL_CLICKED));
      }
      
      private function onFrameChanged(param1:Event) : *
      {
         this.UpdateSliderBoxes();
      }
      
      private function GetSliderBoxAlpha(param1:int, param2:int, param3:Boolean) : Number
      {
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         if(param3)
         {
            _loc5_ = param2;
         }
         else
         {
            _loc5_ = Math.abs(param2 + 1 - param1);
         }
         switch(_loc5_)
         {
            case 0:
               _loc4_ = this.HIGHLIGHT_MAX_ALPHA;
               break;
            case 1:
               _loc4_ = this.HIGHLIGHT_MID_ALPHA;
               break;
            case 2:
               _loc4_ = this.HIGHLIGHT_LOW_ALPHA;
               break;
            default:
               _loc4_ = 0;
         }
         return _loc4_;
      }
      
      public function SetFocus(param1:Boolean) : *
      {
         var _loc2_:int = 0;
         if(param1)
         {
            this.Dot_mc.alpha = 1;
            this.UpdateSliderBoxes();
         }
         else
         {
            this.Dot_mc.alpha = 0;
            this.UpdateSliderBoxes();
            _loc2_ = 0;
            while(_loc2_ < NUM_OF_BOXES_IN_ROW)
            {
               this.FaceSlider_mc.SliderBoxes_mc["Top" + _loc2_.toString() + "_mc"].alpha = 0;
               this.FaceSlider_mc.SliderBoxes_mc["Bottom" + _loc2_.toString() + "_mc"].alpha = 0;
               this.FaceSlider_mc.SliderBoxes_mc["Left" + _loc2_.toString() + "_mc"].alpha = 0;
               this.FaceSlider_mc.SliderBoxes_mc["Right" + _loc2_.toString() + "_mc"].alpha = 0;
               _loc2_++;
            }
         }
      }
      
      private function UpdateSliderBoxes() : *
      {
         var _loc1_:MovieClip = this.FaceSlider_mc.SliderBoxes_mc;
         var _loc2_:Boolean = this.Round == 0 && this.Thin == 0 && this.Wide == 0 && this.Square == 0;
         var _loc3_:Number = Math.max(this.Round,this.Thin,this.Wide,this.Square);
         var _loc4_:int = (Math.max(Math.round(_loc3_ * NUM_OF_BOXES_IN_ROW),1) - 1) * -1;
         var _loc5_:int = _loc2_ ? 0 : (this.Square > 0 ? int(Math.max(Math.round(this.Square * NUM_OF_BOXES_IN_ROW),1)) : _loc4_);
         var _loc6_:int = _loc2_ ? 0 : (this.Round > 0 ? int(Math.max(Math.round(this.Round * NUM_OF_BOXES_IN_ROW),1)) : _loc4_);
         var _loc7_:int = _loc2_ ? 0 : (this.Thin > 0 ? int(Math.max(Math.round(this.Thin * NUM_OF_BOXES_IN_ROW),1)) : _loc4_);
         var _loc8_:int = _loc2_ ? 0 : (this.Wide > 0 ? int(Math.max(Math.round(this.Wide * NUM_OF_BOXES_IN_ROW),1)) : _loc4_);
         var _loc9_:int = 0;
         while(_loc9_ < NUM_OF_BOXES_IN_ROW)
         {
            _loc1_["Top" + _loc9_.toString() + "_mc"].alpha = this.GetSliderBoxAlpha(_loc5_,_loc9_,_loc2_);
            _loc1_["Bottom" + _loc9_.toString() + "_mc"].alpha = this.GetSliderBoxAlpha(_loc6_,_loc9_,_loc2_);
            _loc1_["Left" + _loc9_.toString() + "_mc"].alpha = this.GetSliderBoxAlpha(_loc7_,_loc9_,_loc2_);
            _loc1_["Right" + _loc9_.toString() + "_mc"].alpha = this.GetSliderBoxAlpha(_loc8_,_loc9_,_loc2_);
            _loc9_++;
         }
      }
      
      private function onMouseDotSoundTimerRefresh() : *
      {
         this.bAllowMouseDotSound = true;
      }
   }
}
