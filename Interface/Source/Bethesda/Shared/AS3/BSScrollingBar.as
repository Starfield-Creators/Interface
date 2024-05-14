package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BSScrollingBar extends MovieClip
   {
      
      public static const SCROLL_START:String = "BSScrollingBar:scrollStart";
      
      public static const SCROLL_END:String = "BSScrollingBar:scrollEnd";
       
      
      public var BackgroundBar_mc:MovieClip;
      
      public var ScrollIndicator_mc:MovieClip;
      
      protected var fMinIndicatorSize:Number = 20;
      
      protected var uiScrollIndex:uint = 4294967295;
      
      protected var uiMaxScrollIndex:uint = 4294967295;
      
      protected var uiTotalNumEntries:uint = 4294967295;
      
      protected var fMaxScrollDeltaY:Number;
      
      protected var fBackgroundUpperBound:Number;
      
      protected var fBaseIndicatorYPos:Number;
      
      protected var bLoaded:Boolean = false;
      
      protected var PendingUpdateInfo:Object = null;
      
      protected var bDraggingIndicator:Boolean = false;
      
      protected var fInitDragMousePos:Number;
      
      protected var fInitDragIndicatorPos:Number;
      
      public function BSScrollingBar()
      {
         super();
         if(loaderInfo != null)
         {
            loaderInfo.addEventListener(Event.INIT,this.onComponentInit);
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
         this.ScrollIndicator_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         var _loc1_:Rectangle = this.BackgroundBar_mc.getBounds(this);
         this.fBackgroundUpperBound = _loc1_.y;
         this.UpdateBaseYPos();
      }
      
      public function get MinIndicatorSize_Inspectable() : Number
      {
         return this.fMinIndicatorSize;
      }
      
      public function set MinIndicatorSize_Inspectable(param1:Number) : *
      {
         this.fMinIndicatorSize = param1;
      }
      
      public function get scrolling() : Boolean
      {
         return this.bDraggingIndicator;
      }
      
      public function ResetScrolling() : *
      {
         this.bDraggingIndicator = false;
      }
      
      protected function onComponentInit(param1:Event) : void
      {
         if(loaderInfo != null)
         {
            loaderInfo.removeEventListener(Event.INIT,this.onComponentInit);
         }
         if(this.PendingUpdateInfo != null)
         {
            this.Update(this.PendingUpdateInfo.auiScrollIndex,this.PendingUpdateInfo.auiMaxScrollIndex,this.PendingUpdateInfo.auiTotalNumEntries);
         }
         this.bLoaded = true;
      }
      
      protected function onStageInit(param1:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
      }
      
      protected function onStageDestruct(param1:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
      }
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
         this.bDraggingIndicator = true;
         this.fInitDragMousePos = globalToLocal(new Point(0,param1.stageY)).y;
         this.fInitDragIndicatorPos = this.ScrollIndicator_mc.y;
         dispatchEvent(new Event(SCROLL_START,true,true));
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         this.bDraggingIndicator = false;
         dispatchEvent(new Event(SCROLL_END,true,true));
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         if(this.bDraggingIndicator)
         {
            _loc2_ = globalToLocal(new Point(0,param1.stageY)).y;
            _loc3_ = _loc2_ - this.fInitDragMousePos;
            _loc4_ = this.fInitDragIndicatorPos + _loc3_;
            this.ScrollIndicator_mc.y = GlobalFunc.Clamp(_loc4_,this.fBaseIndicatorYPos,this.fBaseIndicatorYPos + this.fMaxScrollDeltaY);
            _loc5_ = this.ScrollIndicator_mc.y - this.fBaseIndicatorYPos;
            _loc6_ = GlobalFunc.MapLinearlyToRange(0,this.uiMaxScrollIndex,0,this.fMaxScrollDeltaY,_loc5_,true);
            if((_loc7_ = Math.round(_loc6_)) != this.uiScrollIndex)
            {
               this.uiScrollIndex = _loc7_;
               dispatchEvent(new BSScrollingBarPosChangeEvent(_loc7_,true,true));
            }
         }
      }
      
      public function Update(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:* = undefined;
         if(param2 == 0)
         {
            visible = false;
            return;
         }
         if(!this.bLoaded)
         {
            this.PendingUpdateInfo = {
               "auiScrollIndex":param1,
               "auiMaxScrollIndex":param2,
               "auiTotalNumEntries":param3
            };
            return;
         }
         this.PendingUpdateInfo = null;
         var _loc4_:Boolean;
         if(_loc4_ = param2 != this.uiMaxScrollIndex || param3 != this.uiTotalNumEntries)
         {
            this.uiMaxScrollIndex = param2;
            this.uiTotalNumEntries = param3;
            _loc5_ = 1 - this.uiMaxScrollIndex / param3;
            if((_loc6_ = this.BackgroundBar_mc.height * _loc5_) < this.MinIndicatorSize_Inspectable)
            {
               _loc6_ = this.MinIndicatorSize_Inspectable;
            }
            if(this.ScrollIndicator_mc.height != _loc6_)
            {
               this.ScrollIndicator_mc.height = _loc6_;
               this.UpdateBaseYPos();
               this.fMaxScrollDeltaY = this.BackgroundBar_mc.height - this.ScrollIndicator_mc.height;
            }
         }
         visible = true;
         this.UpdateScrollInfo(param1,_loc4_);
      }
      
      public function UpdateScrollInfo(param1:uint, param2:Boolean = false) : void
      {
         if(!this.bLoaded || !visible)
         {
            return;
         }
         if(this.uiScrollIndex == param1 && !param2)
         {
            return;
         }
         this.uiScrollIndex = param1;
         var _loc3_:Number = GlobalFunc.MapLinearlyToRange(0,this.fMaxScrollDeltaY,0,this.uiMaxScrollIndex,this.uiScrollIndex,true);
         this.ScrollIndicator_mc.y = this.fBaseIndicatorYPos + _loc3_;
      }
      
      protected function UpdateBaseYPos() : void
      {
         var _loc1_:Rectangle = this.ScrollIndicator_mc.getBounds(this);
         var _loc2_:Number = this.ScrollIndicator_mc.y - _loc1_.y;
         this.fBaseIndicatorYPos = this.fBackgroundUpperBound + _loc2_;
      }
   }
}
