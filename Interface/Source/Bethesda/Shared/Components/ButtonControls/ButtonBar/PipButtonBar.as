package Shared.Components.ButtonControls.ButtonBar
{
   import Shared.Components.ButtonControls.Buttons.MinimalButton;
   
   public class PipButtonBar extends ConstrainedButtonBar
   {
       
      
      public var Wrap:Boolean = true;
      
      protected var SelectedPip:PipButton;
      
      protected var SelectedPipIndex:int = -1;
      
      public function PipButtonBar()
      {
         super();
      }
      
      public function GetSelectedIndex() : int
      {
         return this.SelectedPipIndex;
      }
      
      public function SetSelectedIndex(param1:int = 0) : void
      {
         var _loc7_:int = 0;
         var _loc8_:PipButton = null;
         var _loc2_:int = param1;
         var _loc3_:int = this.SelectedPipIndex;
         var _loc4_:int = MyButtonManager.NumButtons;
         var _loc5_:int = NumVisibleButtons;
         var _loc6_:int = scrollIndexOffset;
         if(this.Wrap)
         {
            _loc2_ = (param1 + _loc4_) % _loc4_;
         }
         if(_loc2_ === this.SelectedPipIndex || _loc2_ < 0 || _loc2_ >= _loc4_)
         {
            return;
         }
         if(_loc2_ < _loc6_)
         {
            _loc6_ -= _loc6_ - _loc2_;
         }
         else if(_loc2_ - _loc6_ > _loc5_ - 1)
         {
            _loc6_ += _loc2_ - _loc6_ - (_loc5_ - 1);
         }
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = MyButtonManager.GetButtonByIndex(_loc7_) as PipButton;
            if(_loc7_ === _loc2_)
            {
               this.SelectedPipIndex = _loc2_;
               this.SelectedPip = _loc8_;
               _loc8_.selected = true;
            }
            else
            {
               _loc8_.selected = false;
            }
            _loc7_++;
         }
         SetScrollOffset(_loc6_);
      }
      
      override public function ClearButtons() : void
      {
         var _loc2_:PipButton = null;
         var _loc1_:uint = 0;
         while(_loc1_ < MyButtonManager.NumButtons)
         {
            _loc2_ = MyButtonManager.GetButtonByIndex(_loc1_) as PipButton;
            _loc2_.removeEventListener(MinimalButton.BUTTON_DATA_CHANGE,RefreshButtons);
            removeChild(_loc2_);
            _loc1_++;
         }
         MyButtonManager.ClearButtons();
         this.SelectedPipIndex = -1;
         this.SelectedPip = null;
      }
   }
}
