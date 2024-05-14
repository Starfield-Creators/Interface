package Components.StarMapWidgets
{
   import Shared.BSEaze;
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import aze.motion.EazeTween;
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   
   public class BodyView extends MovieClip
   {
      
      private static const NO_COLOR:* = 0;
      
      private static const UNSCANNED_COLOR:* = 1909807;
      
      private static const SCANNED_COLOR_NO_DATA:* = 8355711;
      
      private static const BODY_TO_SHIP_SPACING:Number = 4;
      
      private static const CHILD_TO_CHILD_SPACING:uint = 4;
      
      private static const X_BODY_OFFSET:Number = 0;
      
      private static const START_TIME_TO_EXPAND:Number = 0.1;
      
      private static const START_EXPAND_TIME_PER_BODY:Number = 0.1;
      
      private static const START_EXPAND_TIME:Number = 0.5;
      
      private static const EXPAND_TIME_PER_BODY:Number = 0.05;
      
      private static const FOCUS_PUSH_TIME:Number = 0.5;
      
      private static const MIN_FOCUS_PUSH_DISTANCE:Number = 50;
      
      private static const MIN_CHILD_SIZE:Number = 10;
      
      private static const MAX_CHILD_SIZE:Number = 100;
       
      
      public var Body_mc:Body;
      
      public var ShipIcon_mc:MovieClip;
      
      public var ChildContainer_mc:MovieClip;
      
      protected var BodyInfo:Object;
      
      public var NumChildren:* = 0;
      
      protected var MaxChildSize:* = 0;
      
      protected var ChildClipsA:Array;
      
      protected var bExpanding:Boolean = false;
      
      protected var bChildrenExpanded:Boolean = false;
      
      protected var PlayerCelestialBodyID:uint = 0;
      
      protected var BodySize:Number = 0;
      
      protected var StageShipSize:Number = 0;
      
      public function BodyView()
      {
         this.ChildClipsA = new Array();
         super();
         this.Body_mc.SetColor(16777215 * Math.random());
         this.StageShipSize = this.ShipIcon_mc.height;
         GlobalFunc.BSASSERT(this.ChildContainer_mc != null,"ChildContainer_mc is null on BodyView object!");
      }
      
      private static function HasBodyRecursive(param1:BodyView, param2:uint, param3:Boolean) : Boolean
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc4_:Boolean = false;
         var _loc5_:Object;
         if((_loc5_ = param1.BodyInfo).bodyID == param2)
         {
            _loc4_ = true;
         }
         if(!_loc4_ && _loc5_.childInfoA != null && (!param3 || param1.bChildrenExpanded))
         {
            _loc6_ = 0;
            while(!_loc4_ && _loc6_ < param1.NumChildren)
            {
               _loc7_ = param1.ChildClipsA[_loc6_];
               _loc4_ = HasBodyRecursive(_loc7_,param2,param3);
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      public function GetChildSpacingX() : Number
      {
         return this.MaxChildSize + CHILD_TO_CHILD_SPACING;
      }
      
      protected function GetMinChildSize() : Number
      {
         return MIN_CHILD_SIZE;
      }
      
      protected function GetMaxChildSize() : Number
      {
         return MAX_CHILD_SIZE;
      }
      
      protected function GetChildBodyClass() : Class
      {
         return BodyView;
      }
      
      protected function GetTotalViewSpacingX() : Number
      {
         var _loc1_:* = this.Body_mc.width;
         if(this.bChildrenExpanded)
         {
            _loc1_ = Math.max(_loc1_,this.GetChildSpacingX() * this.NumChildren);
         }
         return _loc1_;
      }
      
      public function UpdateInfo(param1:Object, param2:Number, param3:uint) : *
      {
         var _loc7_:* = undefined;
         var _loc8_:BodyView = null;
         var _loc9_:* = undefined;
         this.BodyInfo = param1;
         this.PlayerCelestialBodyID = param3;
         this.BodySize = GlobalFunc.Clamp(param2 * this.BodyInfo.sunRadiusPercent,this.GetMinChildSize(),this.GetMaxChildSize());
         this.Body_mc.width = this.Body_mc.height = this.BodySize;
         var _loc4_:uint = UNSCANNED_COLOR;
         if(this.BodyInfo.scanned == true)
         {
            if((_loc4_ = uint(this.BodyInfo.color)) == NO_COLOR)
            {
               _loc4_ = SCANNED_COLOR_NO_DATA;
            }
         }
         this.Body_mc.SetColor(_loc4_);
         var _loc5_:* = 0;
         _loc5_ = 0;
         while(_loc5_ < this.ChildClipsA.length)
         {
            this.ChildContainer_mc.removeChild(this.ChildClipsA[_loc5_]);
            _loc5_++;
         }
         this.ChildClipsA = null;
         this.NumChildren = 0;
         this.bChildrenExpanded = false;
         this.ChildClipsA = new Array();
         var _loc6_:Class;
         if((_loc6_ = this.GetChildBodyClass()) == null)
         {
            throw Error("BodyView class derivative does not have a valid child class");
         }
         if(this.BodyInfo.hasOwnProperty("childInfoA"))
         {
            this.NumChildren = this.BodyInfo.childInfoA.length;
            _loc5_ = 0;
            while(_loc5_ < this.NumChildren)
            {
               if((_loc8_ = (_loc7_ = new _loc6_()) as BodyView) == null)
               {
                  throw Error("BodyView class derivative does not inherit BodyView");
               }
               _loc9_ = this.BodyInfo.childInfoA[_loc5_];
               this.ChildClipsA.push(_loc8_);
               this.ChildContainer_mc.addChild(_loc8_);
               _loc8_.visible = false;
               _loc8_.UpdateInfo(_loc9_,param2,param3);
               this.MaxChildSize = Math.max(this.MaxChildSize,_loc8_.Body_mc.width);
               _loc5_++;
            }
         }
         this.ShipIcon_mc.visible = this.ShouldShowPlayerIcon(param3);
         this.ShipIcon_mc.x = 0;
         this.UpdateShipMarker(1,0);
      }
      
      private function ShouldShowPlayerIcon(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.BodyInfo.bodyID == param1 && this.BodyInfo.bodyType != BSGalaxyTypes.BT_MOON)
         {
            _loc2_ = true;
         }
         else if(HasBodyRecursive(this,param1,false))
         {
            _loc2_ = !HasBodyRecursive(this,param1,true) && !this.ChildrenShowingPlayerIcon(param1);
         }
         return _loc2_;
      }
      
      private function ChildrenShowingPlayerIcon(param1:uint) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:BodyView = null;
         var _loc2_:Boolean = false;
         if(this.bChildrenExpanded)
         {
            _loc3_ = 0;
            while(!_loc2_ && _loc3_ < this.NumChildren)
            {
               _loc2_ = (_loc4_ = this.ChildClipsA[_loc3_] as BodyView).ShouldShowPlayerIcon(param1);
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      private function GetFocusedExpansionDistance(param1:uint, param2:uint) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:* = -1;
         var _loc5_:BodyView = null;
         var _loc6_:* = 0;
         while(_loc6_ < this.NumChildren)
         {
            _loc5_ = this.ChildClipsA[_loc6_] as BodyView;
            if(HasBodyRecursive(_loc5_,param2,true))
            {
               _loc4_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         if(_loc4_ >= 0)
         {
            if(param1 < _loc4_)
            {
               _loc3_ -= Math.max(_loc5_.GetTotalViewSpacingX(),MIN_FOCUS_PUSH_DISTANCE);
            }
            else if(param1 > _loc4_)
            {
               _loc3_ += Math.max(_loc5_.GetTotalViewSpacingX(),MIN_FOCUS_PUSH_DISTANCE);
            }
         }
         return _loc3_;
      }
      
      public function GetTargetChildX(param1:uint) : *
      {
         var _loc2_:Number = this.GetChildSpacingX();
         var _loc3_:* = _loc2_ * (this.NumChildren - 1);
         var _loc4_:Number;
         return (_loc4_ = -(_loc3_ / 2)) + param1 * _loc2_ + X_BODY_OFFSET;
      }
      
      public function ExpandChildBodies(param1:uint) : *
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc8_:BodyView = null;
         var _loc9_:uint = 0;
         var _loc10_:* = undefined;
         var _loc11_:BodyView = null;
         var _loc12_:BodyView = null;
         var _loc13_:* = undefined;
         var _loc14_:EazeTween = null;
         var _loc2_:* = 0;
         if(this.bChildrenExpanded == false)
         {
            _loc3_ = this.GetChildSpacingX();
            _loc4_ = Math.ceil(this.NumChildren / 2);
            _loc5_ = START_TIME_TO_EXPAND;
            _loc6_ = START_EXPAND_TIME + EXPAND_TIME_PER_BODY * _loc4_;
            _loc2_ = 0;
            while(_loc2_ < this.NumChildren / 2)
            {
               _loc7_ = this.BodyInfo.childInfoA[_loc2_];
               _loc8_ = this.ChildClipsA[_loc2_];
               _loc9_ = this.NumChildren - _loc2_ - 1;
               _loc10_ = this.BodyInfo.childInfoA[_loc9_];
               _loc11_ = this.ChildClipsA[_loc9_];
               this.ExpandChildBody(_loc8_,0,this.GetTargetChildX(_loc2_) + this.GetFocusedExpansionDistance(_loc2_,param1),_loc5_,_loc6_);
               if(_loc8_ != _loc11_)
               {
                  this.ExpandChildBody(_loc11_,0,this.GetTargetChildX(_loc9_) + this.GetFocusedExpansionDistance(_loc9_,param1),_loc5_,_loc6_);
               }
               _loc5_ += START_EXPAND_TIME_PER_BODY;
               _loc6_ -= EXPAND_TIME_PER_BODY;
               _loc2_++;
            }
            this.bChildrenExpanded = true;
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.NumChildren)
            {
               _loc12_ = this.ChildClipsA[_loc2_];
               _loc13_ = this.GetTargetChildX(_loc2_) + this.GetFocusedExpansionDistance(_loc2_,param1);
               _loc14_ = BSEaze(_loc12_).LerpTo(FOCUS_PUSH_TIME,_loc13_,0).eaze;
               if(_loc12_.bExpanding == true)
               {
                  _loc14_.onComplete(this.onExpansionComplete,_loc12_);
               }
               _loc2_++;
            }
         }
         this.ShipIcon_mc.visible = this.ShouldShowPlayerIcon(this.PlayerCelestialBodyID);
      }
      
      public function ExpandChildBody(param1:BodyView, param2:Number, param3:Number, param4:Number, param5:Number = 0.5) : *
      {
         if(param1 != null)
         {
            param1.visible = true;
            param1.bExpanding = true;
            eaze(param1).apply({
               "x":param2,
               "y":0
            }).delay(param4).easing(Quadratic.easeInOut).to(param5,{"x":param3}).onComplete(this.onExpansionComplete,param1);
         }
      }
      
      protected function onExpansionComplete(param1:BodyView) : *
      {
         param1.bExpanding = false;
      }
      
      public function ContractChildBodies() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:BodyView = null;
         var _loc7_:uint = 0;
         var _loc8_:* = undefined;
         var _loc9_:BodyView = null;
         if(this.bChildrenExpanded == true)
         {
            _loc1_ = Math.ceil(this.NumChildren / 2);
            _loc2_ = START_TIME_TO_EXPAND + START_EXPAND_TIME_PER_BODY * _loc1_;
            _loc3_ = START_EXPAND_TIME;
            _loc4_ = 0;
            while(_loc4_ < this.NumChildren / 2)
            {
               _loc5_ = this.BodyInfo.childInfoA[_loc4_];
               _loc6_ = this.ChildClipsA[_loc4_];
               _loc7_ = this.NumChildren - _loc4_ - 1;
               _loc8_ = this.BodyInfo.childInfoA[_loc7_];
               _loc9_ = this.ChildClipsA[_loc7_];
               this.ContractChildBody(_loc6_,0,_loc2_,_loc3_);
               if(_loc6_ != _loc9_)
               {
                  this.ContractChildBody(_loc9_,0,_loc2_,_loc3_);
               }
               _loc2_ -= START_EXPAND_TIME_PER_BODY;
               _loc3_ += EXPAND_TIME_PER_BODY;
               _loc4_++;
            }
            this.bChildrenExpanded = false;
         }
      }
      
      public function ContractChildBody(param1:BodyView, param2:Number, param3:Number, param4:Number = 0.5) : *
      {
         if(param1 != null)
         {
            this.ShipIcon_mc.visible = false;
            eaze(param1).apply({"y":0}).delay(param3).easing(Quadratic.easeInOut).to(param4,{"x":param2}).onComplete(this.onContractionComplete,param1);
         }
      }
      
      protected function onContractionComplete(param1:BodyView) : *
      {
         var _loc4_:BodyView = null;
         param1.visible = false;
         var _loc2_:* = true;
         var _loc3_:* = 0;
         while(_loc2_ && _loc3_ < this.NumChildren)
         {
            _loc2_ = !(_loc4_ = this.ChildClipsA[_loc3_] as BodyView).visible;
            _loc3_++;
         }
         if(_loc2_)
         {
            this.ShipIcon_mc.visible = this.ShouldShowPlayerIcon(this.PlayerCelestialBodyID);
         }
      }
      
      public function GetChildBodyTargetXRecursive(param1:uint) : Number
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:BodyView = null;
         var _loc2_:int = int(this.GetChildBodyIndex(param1));
         var _loc3_:Number = 0;
         if(this.BodyInfo.bodyID == param1)
         {
            _loc3_ += this.x;
         }
         else if(_loc2_ >= 0)
         {
            _loc3_ += this.GetTargetChildX(_loc2_);
         }
         else if(HasBodyRecursive(this,param1,true))
         {
            _loc4_ = 0;
            while(_loc4_ < this.NumChildren)
            {
               _loc5_ = this.BodyInfo.childInfoA[_loc4_];
               _loc6_ = this.ChildClipsA[_loc4_] as BodyView;
               if(HasBodyRecursive(_loc6_,param1,true))
               {
                  _loc2_ = _loc4_;
                  _loc3_ += _loc6_.GetChildBodyTargetXRecursive(param1);
                  _loc3_ += this.GetTargetChildX(_loc2_);
                  break;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public function GetChildBodyIndex(param1:uint) : uint
      {
         var _loc4_:BodyView = null;
         var _loc2_:int = -1;
         var _loc3_:* = 0;
         while(_loc3_ < this.NumChildren)
         {
            if((Boolean(_loc4_ = this.ChildClipsA[_loc3_] as BodyView)) && _loc4_.BodyInfo.bodyID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function UpdateShipMarker(param1:Number, param2:Number) : *
      {
         var _loc3_:Number = 1 / param1;
         var _loc4_:Number = this.BodySize / 2 + this.StageShipSize / 2 * _loc3_ + BODY_TO_SHIP_SPACING;
         eaze(this.ShipIcon_mc).easing(Quadratic.easeInOut).to(param2,{
            "scaleX":_loc3_,
            "scaleY":_loc3_,
            "y":_loc4_
         });
      }
      
      public function FocusBody(param1:uint, param2:Number, param3:Number) : *
      {
         var _loc5_:BodyView = null;
         this.UpdateShipMarker(param2,param3);
         var _loc4_:* = 0;
         while(_loc4_ < this.NumChildren)
         {
            (_loc5_ = this.ChildClipsA[_loc4_] as BodyView).FocusBody(param1,param2,param3);
            _loc4_++;
         }
         if(HasBodyRecursive(this,param1,false))
         {
            this.ExpandChildBodies(param1);
         }
         else
         {
            this.ContractChildBodies();
         }
      }
      
      public function ShowHighlight(param1:uint) : void
      {
         if(this.BodyInfo != null)
         {
            this.Body_mc.ShowHighlight(this.BodyInfo.bodyID == param1);
            this.SetChildrenHighlights(param1);
         }
      }
      
      public function SetChildrenHighlights(param1:uint) : void
      {
         var _loc2_:BodyView = null;
         for each(_loc2_ in this.ChildClipsA)
         {
            if(_loc2_)
            {
               _loc2_.ShowHighlight(param1);
            }
         }
      }
   }
}
