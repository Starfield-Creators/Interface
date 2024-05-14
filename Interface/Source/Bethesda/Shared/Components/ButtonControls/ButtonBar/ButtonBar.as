package Shared.Components.ButtonControls.ButtonBar
{
   import Shared.AS3.BSDisplayObject;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.MinimalButton;
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public dynamic class ButtonBar extends BSDisplayObject
   {
      
      public static const JUSTIFY_LEFT:uint = 0;
      
      public static const JUSTIFY_RIGHT:uint = 1;
      
      public static const JUSTIFY_CENTER:uint = 2;
      
      protected static const DEFAULT_SPACING:int = 15;
      
      private static const ROUNDING_PRECISION:uint = 2;
      
      public static const BUTTON_BAR_REDRAWN_EVENT:String = "ButtonBarRedrawnEvent";
       
      
      public var Background_mc:MovieClip;
      
      protected var uJustification:uint = 0;
      
      protected var iSpacing:int = 15;
      
      protected var uColor:uint;
      
      protected var bCustomColor:Boolean = false;
      
      protected var fTotalWidth:Number = 0;
      
      protected var fHorizontalPadding:Number = 0;
      
      protected var fVerticalPadding:Number = 0;
      
      protected var bRedrawOnFrameEnter:Boolean = false;
      
      public var MyButtonManager:ButtonManager;
      
      private var _buttonBarRedrawnCount:uint = 0;
      
      public function ButtonBar()
      {
         this.MyButtonManager = new ButtonManager();
         super();
      }
      
      public function set RedrawOnFrameEnter(param1:Boolean) : void
      {
         this.bRedrawOnFrameEnter = param1;
      }
      
      public function get TotalWidth() : Number
      {
         return this.fTotalWidth;
      }
      
      public function AddButton(param1:IButton) : void
      {
         if(this.bCustomColor)
         {
            param1.ButtonColor = this.uColor;
         }
         this.MyButtonManager.AddButton(param1);
         if((param1 as DisplayObject).parent != this)
         {
            addChild(param1 as DisplayObject);
         }
         (param1 as MovieClip).addEventListener(MinimalButton.BUTTON_DATA_CHANGE,this.RefreshButtons);
      }
      
      public function AddButtonWithData(param1:IButton, param2:ButtonData) : void
      {
         param1.SetButtonData(param2);
         this.AddButton(param1);
      }
      
      public function Initialize(param1:uint, param2:int = 15) : *
      {
         this.iSpacing = param2;
         this.uJustification = param1;
      }
      
      public function SetBackgroundPadding(param1:int, param2:int) : *
      {
         this.fHorizontalPadding = param1;
         this.fVerticalPadding = param2;
      }
      
      public function set ButtonBarColor(param1:uint) : void
      {
         var _loc2_:Object = null;
         this.bCustomColor = true;
         this.uColor = param1;
         var _loc3_:uint = 0;
         while(_loc3_ < this.MyButtonManager.NumButtons)
         {
            _loc2_ = this.MyButtonManager.GetButtonByIndex(_loc3_);
            (_loc2_ as IButton).ButtonColor = this.uColor;
            _loc3_++;
         }
      }
      
      public function RefreshButtons() : void
      {
         SetIsDirty();
      }
      
      public function ClearButtons() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.MyButtonManager.NumButtons)
         {
            _loc2_ = this.MyButtonManager.GetButtonByIndex(_loc1_) as MovieClip;
            _loc2_.removeEventListener(MinimalButton.BUTTON_DATA_CHANGE,this.RefreshButtons);
            removeChild(_loc2_);
            _loc1_++;
         }
         this.MyButtonManager.ClearButtons();
      }
      
      protected function RefreshAfterRedraw() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.RefreshAfterRedraw);
         SetIsDirty();
      }
      
      override public function redrawDisplayObject() : void
      {
         var _loc1_:Object = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         super.redrawDisplayObject();
         this.fTotalWidth = 0;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this.MyButtonManager.NumButtons)
         {
            _loc1_ = this.MyButtonManager.GetButtonByIndex(_loc3_);
            _loc1_.removeEventListener(MinimalButton.BUTTON_DATA_CHANGE,this.RefreshButtons);
            _loc1_.redrawWithParent();
            _loc1_.addEventListener(MinimalButton.BUTTON_DATA_CHANGE,this.RefreshButtons);
            if(_loc1_.Visible)
            {
               _loc2_ = Number(_loc1_.height);
               this.fTotalWidth += _loc1_.Width + this.iSpacing;
            }
            _loc3_++;
         }
         this.fTotalWidth -= this.iSpacing;
         this.UpdateBackground(this.fTotalWidth,_loc2_);
         var _loc4_:Number = this.fHorizontalPadding;
         switch(this.uJustification)
         {
            case JUSTIFY_RIGHT:
               _loc4_ = -this.fTotalWidth - this.fHorizontalPadding;
               break;
            case JUSTIFY_CENTER:
               _loc4_ = -(this.fTotalWidth / 2);
         }
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:uint = 0;
         while(_loc6_ < this.MyButtonManager.NumButtons)
         {
            _loc1_ = this.MyButtonManager.GetButtonByIndex(_loc6_);
            if(_loc1_.Visible)
            {
               _loc7_ = _loc1_.getBounds(stage);
               _loc8_ = _loc1_.localToGlobal(new Point(0,0));
               _loc9_ = this.globalToLocal(_loc7_.topLeft);
               _loc11_ = (_loc10_ = this.globalToLocal(_loc8_)).x - _loc9_.x;
               _loc11_ = GlobalFunc.RoundDecimal(_loc11_,ROUNDING_PRECISION);
               _loc4_ = GlobalFunc.RoundDecimal(_loc4_,ROUNDING_PRECISION);
               if(_loc5_ == Number.MAX_VALUE)
               {
                  _loc5_ = _loc11_;
               }
               _loc1_.x = _loc4_ + _loc11_;
               _loc4_ += _loc1_.Width + this.iSpacing;
            }
            _loc6_++;
         }
         dispatchEvent(new Event(BUTTON_BAR_REDRAWN_EVENT));
         if(this.bRedrawOnFrameEnter)
         {
            ++this._buttonBarRedrawnCount;
            if(this._buttonBarRedrawnCount % 2 != 0)
            {
               addEventListener(Event.ENTER_FRAME,this.RefreshAfterRedraw);
            }
         }
      }
      
      public function GetButton(param1:uint) : IButton
      {
         return param1 < this.MyButtonManager.NumButtons ? this.MyButtonManager.GetButtonByIndex(param1) as IButton : null;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      protected function UpdateBackground(param1:Number, param2:Number) : void
      {
         if(this.Background_mc != null)
         {
            if(param1 > 0)
            {
               this.Background_mc.width = param1 + this.fHorizontalPadding * 2;
               this.Background_mc.height = param2 + this.fVerticalPadding * 2;
               this.Background_mc.visible = true;
            }
            else
            {
               this.Background_mc.visible = false;
            }
            this.Background_mc.x = 0;
            switch(this.uJustification)
            {
               case JUSTIFY_RIGHT:
                  this.Background_mc.x = -this.Background_mc.width;
                  break;
               case JUSTIFY_CENTER:
                  this.Background_mc.x = -(param1 / 2) - this.fHorizontalPadding;
            }
            this.Background_mc.y = -this.fVerticalPadding - param2 / 2;
         }
      }
   }
}
