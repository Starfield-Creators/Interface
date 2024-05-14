package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BookPageIndicators extends BSDisplayObject
   {
      
      public static const LEFT_ARROW_PRESSED:String = "LeftArrowPressed";
      
      public static const RIGHT_ARROW_PRESSED:String = "RightArrowPressed";
      
      private static const ARROW_ENABLED:String = "ArrowEnabled";
      
      private static const ARROW_DISABLED:String = "ArrowDisabled";
       
      
      public var LeftArrow_mc:MovieClip;
      
      public var RightArrow_mc:MovieClip;
      
      public var PageNumbers_tf:TextField;
      
      private var TotalPages:int = 0;
      
      public function BookPageIndicators()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.LeftArrow_mc.addEventListener(MouseEvent.CLICK,this.onLeftArrowClick);
         this.RightArrow_mc.addEventListener(MouseEvent.CLICK,this.onRightArrowClick);
      }
      
      public function SetTotalPageNumbers(param1:int) : *
      {
         this.TotalPages = param1;
         if(param1 > 1)
         {
            visible = true;
            this.SetCurrentPage(1);
         }
         else
         {
            visible = false;
         }
      }
      
      public function SetCurrentPage(param1:int) : *
      {
         if(visible)
         {
            param1 = GlobalFunc.Clamp(param1,1,this.TotalPages);
            GlobalFunc.SetText(this.PageNumbers_tf,param1.toString() + "/" + this.TotalPages.toString());
            this.LeftArrow_mc.gotoAndStop(param1 == 1 ? ARROW_DISABLED : ARROW_ENABLED);
            this.RightArrow_mc.gotoAndStop(param1 == this.TotalPages ? ARROW_DISABLED : ARROW_ENABLED);
         }
      }
      
      private function onLeftArrowClick(param1:MouseEvent) : *
      {
         if(visible)
         {
            if(this.LeftArrow_mc.currentFrameLabel == ARROW_ENABLED)
            {
               dispatchEvent(new Event(LEFT_ARROW_PRESSED));
            }
         }
      }
      
      private function onRightArrowClick(param1:MouseEvent) : *
      {
         if(visible)
         {
            if(this.RightArrow_mc.currentFrameLabel == ARROW_ENABLED)
            {
               dispatchEvent(new Event(RIGHT_ARROW_PRESSED));
            }
         }
      }
   }
}
