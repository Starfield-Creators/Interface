package Shared.Components.SystemPanels
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingBar;
   import Shared.AS3.BSScrollingBarPosChangeEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class HelpPanelScrollableDescription extends BSDisplayObject
   {
      
      public static const SCROLL_DELTA:Number = 25;
       
      
      public var HelpDescription_mc:MovieClip;
      
      public var ScrollBar:BSScrollingBar;
      
      public var Mask_mc:MovieClip;
      
      private var StartingDescriptionPosition:Number = 0;
      
      private var ScrollDelta:Number = 0;
      
      private var Scrollable:Boolean = false;
      
      private var _scrollPosition:int = 0;
      
      private var _maxScrollPosition:int = 1;
      
      private const HEIGHT_FOR_EXTRA_INDEX:Number = 25;
      
      private const EXTRA_CLIP_HEIGHT:Number = 25;
      
      private const GUTTER_OFFSET:Number = 2;
      
      public function HelpPanelScrollableDescription()
      {
         super();
         this.StartingDescriptionPosition = this.HelpDescription_mc.y;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function get maxScrollPosition() : int
      {
         return this._maxScrollPosition;
      }
      
      public function set maxScrollPosition(param1:int) : *
      {
         this._maxScrollPosition = param1;
      }
      
      public function get maxDescriptionPosition() : Number
      {
         return this.StartingDescriptionPosition - this.textHeight + this.Mask_mc.height;
      }
      
      public function get maxDescriptionRange() : Number
      {
         return this.textHeight - this.Mask_mc.height;
      }
      
      public function get textField() : TextField
      {
         return this.HelpDescription_mc.textField;
      }
      
      public function get scrollPosition() : int
      {
         return this._scrollPosition;
      }
      
      private function UpdateScrollPosition() : *
      {
         if(this.Scrollable)
         {
            this._scrollPosition = Math.ceil((this.StartingDescriptionPosition - this.HelpDescription_mc.y) / this.maxDescriptionRange * Number(this.maxScrollPosition));
            this.ScrollBar.Update(this.scrollPosition,this.maxScrollPosition,this.maxScrollPosition + 5);
         }
         else
         {
            this._scrollPosition = 0;
            this.ScrollBar.Update(0,0,0);
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.ScrollBar.addEventListener(BSScrollingBarPosChangeEvent.NAME,this.onScrollBarMoved);
         this.ScrollBar.Update(0,0,0);
      }
      
      public function get textHeight() : Number
      {
         return this.textField.textHeight + this.GUTTER_OFFSET;
      }
      
      public function MoveScroll(param1:Number) : *
      {
         if(this.Scrollable)
         {
            this.ScrollDelta += param1;
            this.HelpDescription_mc.y = this.StartingDescriptionPosition + this.ScrollDelta;
            this.HelpDescription_mc.y = GlobalFunc.Clamp(this.HelpDescription_mc.y,this.maxDescriptionPosition,this.StartingDescriptionPosition);
            this.ScrollDelta = this.HelpDescription_mc.y - this.StartingDescriptionPosition;
            this.UpdateScrollPosition();
         }
      }
      
      public function ResetScroll() : *
      {
         this.HelpDescription_mc.y = this.StartingDescriptionPosition;
         this.ScrollDelta = 0;
         this.UpdateScrollPosition();
      }
      
      public function SetData(param1:Object) : void
      {
         this.ResetScroll();
         this.ScrollBar.ResetScrolling();
         if(param1.sDescription != null)
         {
            GlobalFunc.SetText(this.textField,param1.sDescription,true);
         }
         else
         {
            GlobalFunc.SetText(this.textField,"");
         }
         this.textField.height = Math.max(this.textHeight + this.EXTRA_CLIP_HEIGHT,this.Mask_mc.height);
         var _loc2_:Number = this.textHeight - this.Mask_mc.height;
         if(_loc2_ > 0)
         {
            this.Scrollable = true;
            this.maxScrollPosition = Math.ceil(_loc2_ / this.HEIGHT_FOR_EXTRA_INDEX);
         }
         else
         {
            this.Scrollable = false;
         }
         this.UpdateScrollPosition();
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         if(this.Scrollable)
         {
            if(param1.delta != 0)
            {
               if(param1.delta > 0)
               {
                  this.MoveScroll(SCROLL_DELTA);
               }
               else
               {
                  this.MoveScroll(-1 * SCROLL_DELTA);
               }
            }
            param1.stopPropagation();
         }
      }
      
      protected function onScrollBarMoved(param1:BSScrollingBarPosChangeEvent) : *
      {
         this.MoveScroll(Number(this.scrollPosition - param1.iNewScrollPosition) / this.maxScrollPosition * this.maxDescriptionRange);
      }
   }
}
