package
{
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class KioskPaginationDot extends MovieClip
   {
      
      public static const ON_PAGE_DOT_CLICKED:String = "KioskPaginationDot::onClicked";
      
      private static const ON_FRAME:String = "Dark";
      
      private static const OFF_FRAME:String = "Light";
       
      
      private var PageIndex:int = 0;
      
      public function KioskPaginationDot()
      {
         super();
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.active = false;
      }
      
      public function set pageIndex(param1:int) : *
      {
         this.PageIndex = param1;
      }
      
      public function get pageIndex() : int
      {
         return this.PageIndex;
      }
      
      public function set active(param1:Boolean) : *
      {
         gotoAndStop(param1 ? ON_FRAME : OFF_FRAME);
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         dispatchEvent(new CustomEvent(ON_PAGE_DOT_CLICKED,{"iPageIndex":this.PageIndex},true,true));
      }
   }
}
