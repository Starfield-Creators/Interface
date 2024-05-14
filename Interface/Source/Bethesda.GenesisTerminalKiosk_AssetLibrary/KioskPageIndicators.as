package
{
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class KioskPageIndicators extends MovieClip
   {
       
      
      public var LeftButton_mc:PageIndicatorButton;
      
      public var RightButton_mc:PageIndicatorButton;
      
      public var DotContainer_mc:*;
      
      private var IndicatorsV:Vector.<KioskPaginationDot>;
      
      private const MAX_INDICATORS:* = 20;
      
      private const DOT_SPACING:* = 5;
      
      private const DOT_CONTAINER_PADDING:* = 15;
      
      public function KioskPageIndicators()
      {
         var _loc2_:KioskPaginationDot = null;
         this.IndicatorsV = new Vector.<KioskPaginationDot>();
         super();
         this.LeftButton_mc.SetButtonData(new ButtonBaseData("",new UserEventData("Left",this.onPageLeft)));
         this.RightButton_mc.SetButtonData(new ButtonBaseData("",new UserEventData("Right",this.onPageRight)));
         var _loc1_:int = 0;
         while(_loc1_ < this.MAX_INDICATORS)
         {
            _loc2_ = new KioskPaginationDot();
            _loc2_.name = "Dot_" + _loc1_;
            _loc2_.pageIndex = _loc1_;
            _loc2_.visible = false;
            _loc2_.x = _loc1_ * (_loc2_.width + this.DOT_SPACING);
            this.IndicatorsV.push(_loc2_);
            this.DotContainer_mc.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function onPageLeft() : void
      {
         dispatchEvent(new Event("onPageLeft",true,true));
      }
      
      private function onPageRight() : void
      {
         dispatchEvent(new Event("onPageRight",true,true));
      }
      
      public function UpdateIndicators(param1:uint) : void
      {
         var _loc2_:KioskPaginationDot = null;
         var _loc3_:Number = NaN;
         if(param1 > 1)
         {
            visible = true;
            for each(_loc2_ in this.IndicatorsV)
            {
               _loc2_.visible = _loc2_.pageIndex < param1;
            }
            _loc3_ = param1 * (this.DOT_SPACING + this.IndicatorsV[0].width) - this.DOT_SPACING;
            this.DotContainer_mc.x = this.RightButton_mc.x - this.DOT_CONTAINER_PADDING - _loc3_;
            this.LeftButton_mc.x = this.DotContainer_mc.x - this.LeftButton_mc.width - this.DOT_CONTAINER_PADDING;
         }
         else
         {
            visible = false;
         }
      }
      
      public function SetActiveIndicator(param1:uint) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.MAX_INDICATORS)
         {
            this.IndicatorsV[_loc2_].active = _loc2_ == param1;
            _loc2_++;
         }
      }
   }
}
