package
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.Buttons.MinimalButton;
   
   public class MiniCategoryList extends ConstrainedButtonBar
   {
       
      
      public var Wrap:Boolean = true;
      
      protected var SelectedCategory:MiniCategoryListButton = null;
      
      protected var SelectedIndex:int = -1;
      
      public function MiniCategoryList()
      {
         super();
      }
      
      public function GetSelectedCategoryData() : MiniCategoryButtonData
      {
         var _loc1_:* = null;
         if(this.SelectedIndex !== -1)
         {
            _loc1_ = this.SelectedCategory.GetData();
         }
         return _loc1_;
      }
      
      public function GetSelectedID() : uint
      {
         var _loc1_:uint = 0;
         if(this.SelectedIndex !== -1)
         {
            _loc1_ = this.SelectedCategory.GetData().Payload.CategoryID;
         }
         return _loc1_;
      }
      
      public function GetSelectedIndex() : int
      {
         return this.SelectedIndex;
      }
      
      override public function ClearButtons() : void
      {
         var _loc2_:MiniCategoryListButton = null;
         var _loc1_:uint = 0;
         while(_loc1_ < MyButtonManager.NumButtons)
         {
            _loc2_ = MyButtonManager.GetButtonByIndex(_loc1_) as MiniCategoryListButton;
            _loc2_.removeEventListener(MinimalButton.BUTTON_DATA_CHANGE,RefreshButtons);
            removeChild(_loc2_);
            _loc1_++;
         }
         MyButtonManager.ClearButtons();
      }
      
      public function SetSelectedCategory(param1:uint = 0) : void
      {
         var _loc5_:MiniCategoryListButton = null;
         var _loc2_:int = MyButtonManager.NumButtons;
         var _loc3_:int = -1;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_ && _loc3_ == -1)
         {
            if((_loc5_ = MyButtonManager.GetButtonByIndex(_loc4_) as MiniCategoryListButton).GetData().Payload.CategoryID == param1)
            {
               _loc3_ = int(_loc4_);
            }
            _loc4_++;
         }
         if(_loc3_ != -1)
         {
            this.SetSelectedIndex(_loc3_);
         }
      }
      
      public function SetSelectedIndex(param1:int = 0) : void
      {
         var _loc7_:int = 0;
         var _loc8_:MiniCategoryListButton = null;
         var _loc2_:int = param1;
         var _loc3_:int = this.SelectedIndex;
         var _loc4_:int = MyButtonManager.NumButtons;
         var _loc5_:int = NumVisibleButtons;
         var _loc6_:int = scrollIndexOffset;
         if(this.Wrap)
         {
            _loc2_ = (param1 + _loc4_) % _loc4_;
         }
         if(_loc2_ < 0 || _loc2_ >= _loc4_)
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
            _loc8_ = MyButtonManager.GetButtonByIndex(_loc7_) as MiniCategoryListButton;
            if(_loc7_ === _loc2_)
            {
               this.SelectedIndex = _loc2_;
               this.SelectedCategory = _loc8_;
               _loc8_.selected = true;
            }
            else
            {
               _loc8_.selected = false;
            }
            _loc7_++;
         }
         SetScrollOffset(_loc6_);
         if(_loc3_ != _loc2_)
         {
            dispatchEvent(new CustomEvent(ResearchUtils.CATEGORY_CHANGED,{"categoryID":this.GetSelectedID()},true,true));
         }
      }
      
      public function Open() : void
      {
         this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
      }
      
      public function Close() : void
      {
         this.gotoAndStop(ResearchUtils.CLOSE_FRAME_LABEL);
      }
   }
}
