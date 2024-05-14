package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   public class BodyPage extends MovieClip implements IChargenPage
   {
      
      internal static const INPUT_SCALE:Number = 0.1;
      
      internal static const SKINTONE_ID:uint = 1;
       
      
      public var BodyModifier_mc:MovieClip;
      
      public var Scroll_mc:MovieClip;
      
      public var RadialHighlight_mc:MovieClip;
      
      public var SkintoneStepper_mc:MovieClip;
      
      public var LocomotionStepper_mc:ToggleOption;
      
      public var BodyTypeStepper_mc:ToggleOption;
      
      public var IndicatorDot_mc:MovieClip;
      
      private var DotLocation:Point;
      
      private const CIRCLE_RADIUS:Number = 95;
      
      private var IsDragging:Boolean = false;
      
      private const ROW_THRESHOLDS:Array = [5,19,36,56,76];
      
      private const NUM_OF_HIGHLIGHT_ROWS:int = 4;
      
      private const NUM_OF_HIGHLIGHT_COLUMNS:int = 5;
      
      private const HIGHLIGHT_MAX_ALPHA:Number = 0.8;
      
      private const HIGHLIGHT_MID_ALPHA:Number = 0.4;
      
      private const HIGHLIGHT_LOW_ALPHA:Number = 0.2;
      
      private const ACTIVE_ROW_ALPHA:Array = [this.HIGHLIGHT_LOW_ALPHA,this.HIGHLIGHT_MID_ALPHA,this.HIGHLIGHT_MAX_ALPHA,this.HIGHLIGHT_MID_ALPHA,this.HIGHLIGHT_LOW_ALPHA];
      
      private const ONE_ROW_DIFF_ALPHA:Array = [0,this.HIGHLIGHT_LOW_ALPHA,this.HIGHLIGHT_MID_ALPHA,this.HIGHLIGHT_LOW_ALPHA,0];
      
      private const TWO_ROW_DIFF_ALPHA:Array = [0,0,this.HIGHLIGHT_LOW_ALPHA,0,0];
      
      private const RADIAL_ANGLE_OFFSET:Number = 9;
      
      private const RADIAL_ANGLE_DIVISION:Number = 18;
      
      private const CharGen_SkintoneChange:String = "CharGen_SkintoneChange";
      
      private const CharGen_RollOnLocomotion:String = "CharGen_RollOnLocomotion";
      
      private const CharGen_RollOffLocomotion:String = "CharGen_RollOffLocomotion";
      
      private const BodyModSpeedScalar:Number = 0.15;
      
      private const WEIGHT:uint = 0;
      
      private const BODY_TYPE:int = 1;
      
      private const LOCOMOTION_TYPE:uint = 2;
      
      private const SKIN_TONE:uint = 3;
      
      private const NO_EDIT_MODE:uint = 4;
      
      private var EditMode:uint = 4;
      
      private var FocusItemsA:Array;
      
      private var FocusItem:uint = 4;
      
      private var LastSkintoneValue:uint = 0;
      
      private var uiController:uint = 0;
      
      private var StoredDirectionVector:Point;
      
      public function BodyPage()
      {
         this.DotLocation = new Point();
         this.FocusItemsA = new Array();
         this.StoredDirectionVector = new Point();
         super();
         this.IndicatorDot_mc = this.BodyModifier_mc.IndicatorDot_mc;
         this.RadialHighlight_mc = this.BodyModifier_mc.RadialHighlight_mc;
         this.DotLocation.x = this.IndicatorDot_mc.x;
         this.DotLocation.y = this.IndicatorDot_mc.y;
         this.UpdateRadialHighlight();
         this.SetFocus(this.WEIGHT);
         this.LocomotionStepper_mc.callback = "CharGen_SwitchLocomotion";
         this.LocomotionStepper_mc.labelText = "$Chargen_WalkStyle";
         this.BodyTypeStepper_mc.callback = "CharGen_SwitchBodyType";
         this.BodyTypeStepper_mc.labelText = "$Chargen_BodyType";
         this.FocusItemsA.push(this.BodyModifier_mc);
         this.FocusItemsA.push(this.BodyTypeStepper_mc);
         this.FocusItemsA.push(this.LocomotionStepper_mc);
         this.FocusItemsA.push(this.SkintoneStepper_mc);
      }
      
      private function onWeightRollOn() : *
      {
         this.SetFocus(this.WEIGHT);
         this.onCancel();
      }
      
      private function onBodyTypeRollOn() : *
      {
         this.SetFocus(this.BODY_TYPE);
         this.onCancel();
      }
      
      private function onLocomotionRollOn() : *
      {
         this.SetFocus(this.LOCOMOTION_TYPE);
         this.onCancel();
      }
      
      private function onSkintoneRollOn() : *
      {
         this.SetFocus(this.SKIN_TONE);
         this.onCancel();
      }
      
      public function SetFocus(param1:uint, param2:Boolean = false) : *
      {
         var _loc3_:uint = 0;
         if(this.FocusItem != param1 || param2)
         {
            if(this.FocusItem < this.FocusItemsA.length)
            {
               this.FocusItemsA[this.FocusItem].gotoAndStop("Unselected");
            }
            _loc3_ = this.FocusItem;
            this.FocusItem = param1;
            switch(param1)
            {
               case this.WEIGHT:
                  this.BodyModifier_mc.gotoAndStop("Selected");
                  stage.focus = this.BodyModifier_mc;
                  break;
               case this.SKIN_TONE:
                  this.SkintoneStepper_mc.gotoAndStop("Selected");
                  stage.focus = this.SkintoneStepper_mc.FacePartStepper_mc;
                  break;
               case this.LOCOMOTION_TYPE:
                  this.LocomotionStepper_mc.gotoAndStop("Selected");
                  stage.focus = this.LocomotionStepper_mc;
                  break;
               case this.BODY_TYPE:
                  this.BodyTypeStepper_mc.gotoAndStop("Selected");
                  stage.focus = this.BodyTypeStepper_mc;
            }
            this.LocomotionStepper_mc.SetActive(param1 == this.LOCOMOTION_TYPE);
            this.BodyTypeStepper_mc.SetActive(param1 == this.BODY_TYPE);
            if(_loc3_ == this.LOCOMOTION_TYPE)
            {
               BSUIDataManager.dispatchEvent(new Event("CharGen_RollOffLocomotion"));
            }
            else if(this.FocusItem == this.LOCOMOTION_TYPE)
            {
               BSUIDataManager.dispatchEvent(new Event("CharGen_RollOnLocomotion"));
            }
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_FOCUS);
         }
      }
      
      private function OnStickDataChanged(param1:FromClientDataEvent) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc2_:CharGenMenu = this.GetCharGenMenu();
         if(_loc2_ && _loc2_.IsCompletePopupActive() || this.EditMode != this.WEIGHT)
         {
            return;
         }
         var _loc3_:Point = new Point(param1.data.fInputX,param1.data.fInputY);
         if(_loc3_.length > 0.1)
         {
            _loc3_.normalize(INPUT_SCALE);
            (_loc4_ = new Point()).x = _loc3_.x * this.BodyModSpeedScalar * this.CIRCLE_RADIUS + this.IndicatorDot_mc.x - this.DotLocation.x;
            _loc4_.y = -_loc3_.y * this.BodyModSpeedScalar * this.CIRCLE_RADIUS + this.IndicatorDot_mc.y - this.DotLocation.y;
            if(_loc4_.length > this.CIRCLE_RADIUS)
            {
               _loc4_.normalize(this.CIRCLE_RADIUS);
            }
            this.IndicatorDot_mc.x = _loc4_.x + this.DotLocation.x;
            this.IndicatorDot_mc.y = _loc4_.y + this.DotLocation.y;
            this.UpdateRadialHighlight();
         }
         if(param1.data.fInputX != 0 && param1.data.fInputY != 0)
         {
            _loc5_ = new Point(this.IndicatorDot_mc.x - this.DotLocation.x,-(this.IndicatorDot_mc.y - this.DotLocation.y));
            this.DispatchBodyChange(_loc5_);
         }
      }
      
      private function GetBodyVectorFromMouse() : Point
      {
         var _loc1_:Point = new Point(stage.mouseX,stage.mouseY);
         var _loc2_:Point = new Point(this.DotLocation.x,this.DotLocation.y);
         return this.BodyModifier_mc.globalToLocal(_loc1_).subtract(_loc2_);
      }
      
      private function UpdateDotPositionByMouse(param1:Boolean) : *
      {
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc2_:CharGenMenu = this.GetCharGenMenu();
         if(_loc2_ && _loc2_.IsCompletePopupActive() || this.EditMode != this.WEIGHT)
         {
            return;
         }
         var _loc3_:Point = this.GetBodyVectorFromMouse();
         if(this.IsDragging)
         {
            if(_loc3_.length > this.CIRCLE_RADIUS)
            {
               _loc4_ = new Point(0,1);
               _loc5_ = (Math.atan2(_loc4_.y,_loc4_.x) - Math.atan2(_loc3_.y,_loc3_.x)) * -1 + Math.PI / 2;
               _loc3_.x = this.CIRCLE_RADIUS * Math.cos(_loc5_);
               _loc3_.y = this.CIRCLE_RADIUS * Math.sin(_loc5_);
            }
         }
         if(_loc3_.length <= this.CIRCLE_RADIUS)
         {
            this.IndicatorDot_mc.x = _loc3_.x + this.DotLocation.x;
            this.IndicatorDot_mc.y = _loc3_.y + this.DotLocation.y;
            if(param1)
            {
               _loc3_.y = -_loc3_.y;
               this.DispatchBodyChange(_loc3_);
            }
            this.UpdateRadialHighlight();
         }
      }
      
      public function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.GetBodyVectorFromMouse();
         if(_loc2_.length <= this.CIRCLE_RADIUS)
         {
            this.SetWeightActive();
            this.UpdateDotPositionByMouse(false);
            this.IsDragging = true;
         }
      }
      
      public function OnMouseMove(param1:MouseEvent) : void
      {
         if(this.IsDragging)
         {
            this.UpdateDotPositionByMouse(true);
         }
      }
      
      public function OnMouseUp(param1:MouseEvent) : void
      {
         if(this.IsDragging)
         {
            this.UpdateDotPositionByMouse(true);
            this.IsDragging = false;
            this.StoredDirectionVector.x = this.IndicatorDot_mc.x;
            this.StoredDirectionVector.y = this.IndicatorDot_mc.y;
            this.onCancel();
         }
      }
      
      private function UpdateRadialHighlight() : *
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc1_:Point = new Point(0,1);
         var _loc2_:Number = (Math.atan2(_loc1_.y,_loc1_.x) - Math.atan2(this.IndicatorDot_mc.y,this.IndicatorDot_mc.x)) * (180 / Math.PI) * -1;
         var _loc3_:Number = new Point(this.IndicatorDot_mc.x,this.IndicatorDot_mc.y).length;
         this.RadialHighlight_mc.rotation = Math.round((_loc2_ - 9) / this.RADIAL_ANGLE_DIVISION) * this.RADIAL_ANGLE_DIVISION + 9;
         var _loc4_:int = -1;
         var _loc5_:int = int(this.ROW_THRESHOLDS.length - 1);
         while(_loc5_ >= 0)
         {
            if(_loc3_ >= this.ROW_THRESHOLDS[_loc5_])
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_--;
         }
         this.RadialHighlight_mc.Center_mc.alpha = _loc4_ <= 1 ? this.HIGHLIGHT_MID_ALPHA : (_loc4_ <= 2 ? this.HIGHLIGHT_LOW_ALPHA : 0);
         var _loc6_:int = 1;
         while(_loc6_ <= this.NUM_OF_HIGHLIGHT_ROWS)
         {
            _loc7_ = int.MAX_VALUE;
            if(_loc4_ != -1)
            {
               _loc7_ = Math.abs(_loc6_ - _loc4_);
            }
            _loc8_ = 0;
            while(_loc8_ < this.NUM_OF_HIGHLIGHT_COLUMNS)
            {
               _loc9_ = 0;
               switch(_loc7_)
               {
                  case 0:
                     _loc9_ = Number(this.ACTIVE_ROW_ALPHA[_loc8_]);
                     break;
                  case 1:
                     _loc9_ = Number(this.ONE_ROW_DIFF_ALPHA[_loc8_]);
                     break;
                  case 2:
                     _loc9_ = Number(this.TWO_ROW_DIFF_ALPHA[_loc8_]);
                     break;
                  default:
                     _loc9_ = 0;
                     break;
               }
               this.RadialHighlight_mc["Row" + _loc6_ + "Column" + (_loc8_ + 1) + "_mc"].alpha = _loc9_;
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      private function DispatchBodyChange(param1:Point) : *
      {
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Point = new Point(0,1);
         var _loc6_:Number = param1.length > this.CIRCLE_RADIUS ? 1 : param1.length / this.CIRCLE_RADIUS;
         param1.normalize(1);
         var _loc7_:Number;
         if((_loc7_ = (Math.atan2(_loc5_.y,_loc5_.x) - Math.atan2(param1.y,param1.x)) * (180 / Math.PI)) < 0)
         {
            _loc7_ += 360;
         }
         var _loc8_:Number = 0;
         if(_loc7_ < 120)
         {
            _loc8_ = _loc7_ / 120;
            _loc2_ = (1 - _loc8_) * _loc6_;
            _loc3_ = 0;
            _loc4_ = _loc8_ * _loc6_;
         }
         else if(_loc7_ < 240)
         {
            _loc8_ = (_loc7_ - 120) / 120;
            _loc2_ = 0;
            _loc3_ = _loc8_ * _loc6_;
            _loc4_ = (1 - _loc8_) * _loc6_;
         }
         else
         {
            _loc2_ = (_loc8_ = (_loc7_ - 240) / 120) * _loc6_;
            _loc3_ = (1 - _loc8_) * _loc6_;
            _loc4_ = 0;
         }
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetBodyValues",{
            "fMuscular":_loc2_,
            "fLean":_loc3_,
            "fHeavy":_loc4_
         }));
         CharGenMenu.characterDirty = true;
      }
      
      public function SetWeightActive() : *
      {
         if(this.FocusItem == this.WEIGHT)
         {
            this.BodyModifier_mc.gotoAndStop("Active");
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_BODY_TYPE_SELECT);
            this.EditMode = this.WEIGHT;
            this.StoredDirectionVector.x = this.IndicatorDot_mc.x;
            this.StoredDirectionVector.y = this.IndicatorDot_mc.y;
            BSUIDataManager.dispatchEvent(new Event("CharGen_StartBodyChange"));
         }
         dispatchEvent(new Event(CharGenMenu.UPDATE_BUTTONS));
      }
      
      public function ForceWeightInactive() : *
      {
         if(this.EditMode == this.WEIGHT)
         {
            this.BodyModifier_mc.gotoAndStop("Selected");
            this.EditMode = this.NO_EDIT_MODE;
            dispatchEvent(new Event(CharGenMenu.UPDATE_BUTTONS));
         }
      }
      
      public function onConfirm() : *
      {
         if(this.FocusItem == this.WEIGHT)
         {
            this.BodyModifier_mc.gotoAndStop("Selected");
            GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_BODY_TYPE_DESELECT);
            if(this.EditMode == this.WEIGHT)
            {
               this.StoredDirectionVector.x = this.IndicatorDot_mc.x;
               this.StoredDirectionVector.y = this.IndicatorDot_mc.y;
               BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_EndBodyChange",{"bCancel":false}));
            }
         }
         this.EditMode = this.NO_EDIT_MODE;
         dispatchEvent(new Event(CharGenMenu.UPDATE_BUTTONS));
      }
      
      private function onCancel() : *
      {
         if(this.FocusItem == this.WEIGHT)
         {
            this.BodyModifier_mc.gotoAndStop("Selected");
            if(this.EditMode == this.WEIGHT)
            {
               this.IndicatorDot_mc.x = this.StoredDirectionVector.x;
               this.IndicatorDot_mc.y = this.StoredDirectionVector.y;
               BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_EndBodyChange",{"bCancel":(this.uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE ? true : false)}));
            }
         }
         this.EditMode = this.NO_EDIT_MODE;
         dispatchEvent(new Event(CharGenMenu.UPDATE_BUTTONS));
      }
      
      public function UpdateData(param1:Object) : *
      {
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == false)
         {
            if(param1 == "Accept")
            {
               if(this.EditMode == this.WEIGHT)
               {
                  this.onConfirm();
               }
               else
               {
                  this.SetWeightActive();
               }
               _loc3_ = true;
            }
            else if(param1 == "Cancel")
            {
               this.onCancel();
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(this.EditMode == this.NO_EDIT_MODE)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               if(this.FocusItem > 0)
               {
                  this.SetFocus(this.FocusItem - 1);
               }
               dispatchEvent(new Event(CharGenMenu.UPDATE_BUTTONS));
               param1.stopPropagation();
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               if(this.FocusItem < this.SKIN_TONE)
               {
                  this.SetFocus(this.FocusItem + 1);
               }
               dispatchEvent(new Event(CharGenMenu.UPDATE_BUTTONS));
               param1.stopPropagation();
            }
         }
      }
      
      public function ShowSelect() : Boolean
      {
         return this.EditMode == this.NO_EDIT_MODE && this.FocusItem == this.WEIGHT;
      }
      
      public function ShowBack() : Boolean
      {
         return this.EditMode == this.WEIGHT;
      }
      
      public function ShowModify() : Boolean
      {
         return this.EditMode == this.WEIGHT;
      }
      
      public function onEnterPage() : *
      {
         BSUIDataManager.Subscribe("StickData",this.OnStickDataChanged);
         BSUIDataManager.Subscribe("ChargenMetadata",this.OnChargenMetaDataChanged);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         this.BodyModifier_mc.addEventListener(MouseEvent.ROLL_OVER,this.onWeightRollOn,false,0,true);
         this.BodyTypeStepper_mc.addEventListener(MouseEvent.ROLL_OVER,this.onBodyTypeRollOn,false,0,true);
         this.LocomotionStepper_mc.addEventListener(MouseEvent.ROLL_OVER,this.onLocomotionRollOn,false,0,true);
         this.SkintoneStepper_mc.addEventListener(MouseEvent.ROLL_OVER,this.onSkintoneRollOn,false,0,true);
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetCameraPosition",{"uNewCameraPositions":CharGenMenu.BODY_CAMERA_POSITION}));
         gotoAndPlay("Open");
         var _loc1_:UIDataFromClient = BSUIDataManager.GetDataFromClient("ChargenData");
         if(_loc1_.dataReady)
         {
            this.SetBodyWeightPosition(_loc1_.data.MorphWeights);
            this.LocomotionStepper_mc.SetSelectedValue(_loc1_.data.LocomotionType,true);
            this.BodyTypeStepper_mc.SetSelectedValue(_loc1_.data.Sex,true);
         }
         this.SetFocus(this.FocusItem,true);
      }
      
      public function onExitPage() : *
      {
         BSUIDataManager.Unsubscribe("StickData",this.OnStickDataChanged);
         BSUIDataManager.Unsubscribe("ChargenMetadata",this.OnChargenMetaDataChanged);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         this.BodyModifier_mc.removeEventListener(MouseEvent.ROLL_OVER,this.onWeightRollOn);
         this.BodyTypeStepper_mc.removeEventListener(MouseEvent.ROLL_OVER,this.onBodyTypeRollOn);
         this.LocomotionStepper_mc.removeEventListener(MouseEvent.ROLL_OVER,this.onLocomotionRollOn);
         this.SkintoneStepper_mc.removeEventListener(MouseEvent.ROLL_OVER,this.onSkintoneRollOn);
         gotoAndPlay("Close");
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
         this.uiController = param1.uiController;
      }
      
      public function InitFocus() : *
      {
         this.SetFocus(this.WEIGHT);
      }
      
      private function OnChargenMetaDataChanged(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = uint.MAX_VALUE;
         var _loc3_:uint = 0;
         while(_loc2_ == uint.MAX_VALUE && _loc3_ < param1.data.StepperDataA.length)
         {
            if(param1.data.StepperDataA[_loc3_].sCallbackName == this.CharGen_SkintoneChange)
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         if(_loc2_ != uint.MAX_VALUE)
         {
            this.SkintoneStepper_mc.SetData(param1.data.StepperDataA[_loc2_]);
         }
      }
      
      private function SetBodyWeightPosition(param1:Object) : void
      {
         var _loc2_:Point = new Point(-0.866,0.5);
         var _loc3_:Point = new Point(0,-1);
         var _loc4_:Point = new Point(0.866,0.5);
         var _loc5_:Point = new Point(0,0);
         _loc2_.x *= param1.x;
         _loc2_.y *= param1.x;
         _loc3_.x *= param1.y;
         _loc3_.y *= param1.y;
         _loc4_.x *= param1.z;
         _loc4_.y *= param1.z;
         _loc5_.x = _loc2_.x + _loc3_.x + _loc4_.x;
         _loc5_.y = _loc2_.y + _loc3_.y + _loc4_.y;
         var _loc6_:Number = param1.x + param1.y + param1.z;
         _loc5_.normalize(1);
         this.IndicatorDot_mc.x = _loc5_.x * _loc6_ * this.CIRCLE_RADIUS + this.DotLocation.x;
         this.IndicatorDot_mc.y = _loc5_.y * _loc6_ * this.CIRCLE_RADIUS + this.DotLocation.y;
         this.UpdateRadialHighlight();
      }
      
      private function GetCharGenMenu() : CharGenMenu
      {
         var _loc1_:CharGenMenu = null;
         if(parent != null)
         {
            _loc1_ = parent as CharGenMenu;
         }
         return _loc1_;
      }
   }
}
