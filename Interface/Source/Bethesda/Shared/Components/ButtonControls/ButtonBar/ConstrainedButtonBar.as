package Shared.Components.ButtonControls.ButtonBar
{
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class ConstrainedButtonBar extends ButtonBar
   {
      
      public static const BUTTONS_SPACE_EVENLY:uint = EnumHelper.GetEnum(0);
      
      public static const BUTTONS_STRETCH_TO_FIT:uint = EnumHelper.GetEnum();
      
      public static const BUTTONS_PIXEL_PERFECT:uint = EnumHelper.GetEnum();
      
      public static const BUTTONS_SHRINK_TO_FIT:uint = EnumHelper.GetEnum();
      
      public static const BUTTONS_SCALE_TO_FIT:uint = EnumHelper.GetEnum();
       
      
      public var Border_mc:MovieClip;
      
      protected var bounds:Rectangle;
      
      protected var spacing:Number;
      
      protected var buttonSpacing:uint;
      
      protected var vertical:Boolean = false;
      
      protected var scrollIndexOffset:int = 0;
      
      public function ConstrainedButtonBar()
      {
         this.buttonSpacing = BUTTONS_SPACE_EVENLY;
         super();
         if(this.Border_mc !== null)
         {
            this.bounds = new Rectangle(0,0,this.Border_mc.width,this.Border_mc.height);
            this.removeChild(this.Border_mc);
         }
         else
         {
            GlobalFunc.TraceWarning("ConstrainedButtonBar requires a stage instance named \'Border_mc\' to define it\'s boundary");
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         mouseEnabled = param1;
         mouseChildren = param1;
      }
      
      public function SetVertical(param1:Boolean) : void
      {
         if(this.vertical != param1)
         {
            this.vertical = param1;
            RefreshButtons();
         }
      }
      
      public function get NumVisibleButtons() : int
      {
         return MyButtonManager.GetNumFilteredButtons(this.isButtonVisible);
      }
      
      override public function redrawDisplayObject() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         this.spacing = iSpacing;
         var _loc1_:Number = this.vertical ? this.bounds.height : this.bounds.width;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         var _loc6_:uint = uint(MyButtonManager.NumButtons);
         var _loc7_:Boolean = this.buttonSpacing === BUTTONS_PIXEL_PERFECT || this.buttonSpacing === BUTTONS_SPACE_EVENLY || this.buttonSpacing === BUTTONS_STRETCH_TO_FIT;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_ = MyButtonManager.GetButtonByIndex(_loc4_);
            if(_loc4_ >= this.scrollIndexOffset)
            {
               _loc5_.Visible = true;
               _loc12_ = (this.vertical ? _loc5_.height : _loc5_.width) + this.spacing;
               if(_loc2_ + _loc12_ > _loc1_ && _loc7_)
               {
                  _loc5_.Visible = false;
               }
               else
               {
                  _loc2_ += _loc12_;
                  _loc3_ += this.vertical ? _loc5_.height : _loc5_.width;
               }
            }
            else
            {
               _loc5_.Visible = false;
            }
            _loc4_++;
         }
         var _loc8_:Number = _loc1_ - _loc2_;
         var _loc9_:Number = 0;
         var _loc10_:int = this.NumVisibleButtons + 1;
         var _loc11_:Number = 0;
         if(this.buttonSpacing === BUTTONS_PIXEL_PERFECT)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if((_loc5_ = MyButtonManager.GetButtonByIndex(_loc4_)).Visible)
               {
                  if(this.vertical)
                  {
                     _loc5_.y = _loc9_;
                     _loc9_ += _loc5_.Height + this.spacing;
                  }
                  else
                  {
                     _loc5_.x = _loc9_;
                     _loc9_ += _loc5_.Width + this.spacing;
                  }
               }
               _loc4_++;
            }
         }
         else if(this.buttonSpacing === BUTTONS_SPACE_EVENLY)
         {
            if(_loc8_ > 0)
            {
               this.spacing = (_loc1_ - _loc3_) / _loc10_;
            }
            _loc9_ = this.spacing;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if((_loc5_ = MyButtonManager.GetButtonByIndex(_loc4_)).Visible)
               {
                  if(this.vertical)
                  {
                     _loc5_.y = _loc9_;
                     _loc9_ += _loc5_.Height + this.spacing;
                  }
                  else
                  {
                     _loc5_.x = _loc9_;
                     _loc9_ += _loc5_.Width + this.spacing;
                  }
               }
               _loc4_++;
            }
         }
         else if(this.buttonSpacing === BUTTONS_STRETCH_TO_FIT)
         {
            if(_loc8_ > 0)
            {
               this.spacing = iSpacing;
               _loc11_ = (_loc1_ - this.spacing) / _loc10_ - this.spacing;
               _loc9_ = this.spacing;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if((_loc5_ = MyButtonManager.GetButtonByIndex(_loc4_)).Visible)
               {
                  if(this.vertical)
                  {
                     _loc5_.y = _loc9_;
                  }
                  else
                  {
                     _loc5_.x = _loc9_;
                  }
                  if(_loc11_ > 0)
                  {
                     if(this.vertical)
                     {
                        _loc5_.Height = _loc11_;
                     }
                     else
                     {
                        _loc5_.Width = _loc11_;
                     }
                  }
                  _loc9_ += (this.vertical ? _loc5_.Height : _loc5_.Width) + this.spacing;
               }
               _loc4_++;
            }
         }
         else if(this.buttonSpacing === BUTTONS_SHRINK_TO_FIT)
         {
            if(_loc8_ <= 0)
            {
               this.spacing = iSpacing;
               _loc11_ = (_loc1_ - this.spacing) / _loc10_ - this.spacing;
               _loc9_ = this.spacing;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if((_loc5_ = MyButtonManager.GetButtonByIndex(_loc4_)).Visible)
               {
                  if(this.vertical)
                  {
                     _loc5_.y = _loc9_;
                  }
                  else
                  {
                     _loc5_.x = _loc9_;
                  }
                  if(_loc11_ > 0)
                  {
                     if(this.vertical)
                     {
                        _loc5_.Height = _loc11_;
                     }
                     else
                     {
                        _loc5_.Width = _loc11_;
                     }
                  }
                  _loc9_ += (this.vertical ? _loc5_.Height : _loc5_.Width) + this.spacing;
               }
               _loc4_++;
            }
         }
         else if(this.buttonSpacing === BUTTONS_SCALE_TO_FIT)
         {
            this.spacing = iSpacing;
            _loc13_ = Math.min(_loc10_,_loc6_);
            _loc11_ = (_loc1_ - this.spacing) / _loc13_ - this.spacing;
            _loc9_ = this.spacing;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if((_loc5_ = MyButtonManager.GetButtonByIndex(_loc4_)).Visible)
               {
                  if(this.vertical)
                  {
                     _loc5_.y = _loc9_;
                  }
                  else
                  {
                     _loc5_.x = _loc9_;
                  }
                  if(_loc11_ > 0)
                  {
                     if(this.vertical)
                     {
                        _loc5_.Height = _loc11_;
                     }
                     else
                     {
                        _loc5_.Width = _loc11_;
                     }
                  }
                  _loc9_ += (this.vertical ? _loc5_.Height : _loc5_.Width) + this.spacing;
               }
               _loc4_++;
            }
         }
      }
      
      public function SetButtonSpacing(param1:uint) : void
      {
         var _loc2_:* = this.buttonSpacing;
         this.buttonSpacing = param1;
         if(_loc2_ != this.buttonSpacing && MyButtonManager.NumButtons > 0)
         {
            this.redrawDisplayObject();
         }
      }
      
      public function SetScrollOffset(param1:uint) : void
      {
         if(param1 !== this.scrollIndexOffset && MyButtonManager.NumButtons > 0)
         {
            this.scrollIndexOffset = param1;
            RefreshButtons();
         }
      }
      
      protected function isButtonVisible(param1:IButton, param2:int, param3:Array) : Boolean
      {
         return param1.Visible == true;
      }
      
      public function get WillBeVisibleButtons() : int
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc8_:Number = NaN;
         this.spacing = iSpacing;
         var _loc1_:Number = this.vertical ? this.bounds.height : this.bounds.width;
         var _loc2_:Number = 0;
         var _loc5_:uint = uint(MyButtonManager.NumButtons);
         var _loc6_:uint = 0;
         var _loc7_:Boolean = this.buttonSpacing === BUTTONS_PIXEL_PERFECT || this.buttonSpacing === BUTTONS_SPACE_EVENLY || this.buttonSpacing === BUTTONS_STRETCH_TO_FIT;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = MyButtonManager.GetButtonByIndex(_loc3_);
            if(_loc3_ >= this.scrollIndexOffset)
            {
               _loc8_ = (this.vertical ? _loc4_.height : _loc4_.width) + this.spacing;
               if(_loc2_ + _loc8_ <= _loc1_ || !_loc7_)
               {
                  _loc6_++;
                  _loc2_ += _loc8_;
               }
            }
            _loc3_++;
         }
         return _loc6_;
      }
   }
}
