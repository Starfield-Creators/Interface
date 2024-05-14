package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class BSColorSwatches extends BSDisplayObject
   {
      
      public static const VALUE_CHANGED:String = "BSColorSwatches_ValueChanged";
      
      public static const INPUT_CHANGED:String = "BSColorSwatches_InputChanged";
       
      
      public var SwatchHolder_mc:MovieClip;
      
      public var Arrow_mc:MovieClip;
      
      private var _selectedIndex:int;
      
      private var _wrapAround:Boolean;
      
      private var bDisableListWrap:Boolean = false;
      
      public function BSColorSwatches()
      {
         super();
         this._selectedIndex = 0;
         this._wrapAround = true;
         BSUIDataManager.Subscribe("ListWrapData",this.OnListWrapDataUpdate);
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         this.SetSelectedIndex(param1);
      }
      
      public function get wrapAround() : Boolean
      {
         return this.bDisableListWrap ? false : this._wrapAround;
      }
      
      public function set wrapAround(param1:Boolean) : void
      {
         this._wrapAround = param1;
      }
      
      public function get numSwatches() : int
      {
         return this.SwatchHolder_mc.numChildren;
      }
      
      public function get selectedSwatch() : BSColorSwatch
      {
         return this.GetColorSwatch(this._selectedIndex);
      }
      
      private function OnListWrapDataUpdate(param1:FromClientDataEvent) : void
      {
         this.bDisableListWrap = param1.data.bDisableListWrap;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(BSColorSwatch.COLOR_SWATCH_CLICKED,this.OnColorClicked);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         removeEventListener(BSColorSwatch.COLOR_SWATCH_CLICKED,this.OnColorClicked);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      private function SetSelectedIndex(param1:int) : void
      {
         var _loc2_:int = param1;
         var _loc3_:int = this._selectedIndex;
         var _loc4_:int = this.numSwatches;
         if(this.wrapAround)
         {
            _loc2_ = (param1 + _loc4_) % _loc4_;
         }
         if(_loc2_ === this._selectedIndex || _loc2_ < 0 || _loc2_ >= _loc4_)
         {
            return;
         }
         this._selectedIndex = _loc2_;
         if(this.Arrow_mc != null && this.selectedSwatch != null)
         {
            this.Arrow_mc.x = this.selectedSwatch.x;
         }
         dispatchEvent(new CustomEvent(VALUE_CHANGED,{"index":this._selectedIndex}));
      }
      
      public function SetColorSwatches(param1:Array) : void
      {
         var _loc4_:BSColorSwatch = null;
         var _loc2_:int = this.numSwatches;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.GetColorSwatch(_loc3_);
            if(_loc3_ < param1.length)
            {
               _loc4_.SetColor(param1[_loc3_]);
            }
            else
            {
               _loc4_.SetEmpty();
            }
            _loc3_++;
         }
      }
      
      private function GetColorSwatch(param1:int) : BSColorSwatch
      {
         return param1 < this.SwatchHolder_mc.numChildren ? this.SwatchHolder_mc.getChildAt(param1) as BSColorSwatch : null;
      }
      
      private function OnColorClicked(param1:CustomEvent) : void
      {
         this.selectedIndex = param1.params.id;
         dispatchEvent(new Event(INPUT_CHANGED,true,true));
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT)
         {
            this.selectedIndex = this._selectedIndex - 1;
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            this.selectedIndex = this._selectedIndex + 1;
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
            param1.stopPropagation();
         }
      }
   }
}
