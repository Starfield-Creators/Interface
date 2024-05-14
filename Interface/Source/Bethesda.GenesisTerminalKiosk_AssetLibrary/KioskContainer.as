package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class KioskContainer extends BSDisplayObject
   {
       
      
      public var KioskView_mc:KioskView;
      
      public var KioskBackground_mc:MovieClip;
      
      public var BackgroundDetails_mc:MovieClip;
      
      private const VIEW_OPEN:String = "Open";
      
      private const VIEW_CLOSE:String = "Close";
      
      private const VIEW_IS_OPEN:String = "IsOpen";
      
      private var closing:Boolean = false;
      
      public function KioskContainer()
      {
         super();
         addEventListener("onCloseAnimComplete",this.onCloseAnimComplete);
         addEventListener("onOpenAnimComplete",this.onOpenAnimComplete);
      }
      
      public function get Closing() : Boolean
      {
         return this.closing;
      }
      
      public function get HasFocus() : Boolean
      {
         return visible && stage.focus == this.KioskView_mc.ButtonList;
      }
      
      public function OpenKioskView() : void
      {
         stage.focus = null;
         visible = true;
         if(currentFrameLabel != this.VIEW_IS_OPEN)
         {
            GlobalFunc.PlayMenuSound("UI_Terminal_Kiosk_Enter");
            gotoAndPlay(this.VIEW_OPEN);
         }
         else
         {
            this.SetFocus();
         }
      }
      
      public function RefreshKioskView(param1:Object) : void
      {
         this.KioskView_mc.SetData(param1);
         this.OpenKioskView();
      }
      
      public function CloseKioskView() : void
      {
         if(visible && !this.closing)
         {
            GlobalFunc.PlayMenuSound("UI_Terminal_Kiosk_Exit");
            gotoAndPlay(this.VIEW_CLOSE);
            this.closing = true;
         }
      }
      
      public function SetFocus() : void
      {
         stage.focus = this.KioskView_mc.ButtonList;
      }
      
      public function onCloseAnimComplete() : void
      {
         visible = false;
         this.closing = false;
      }
      
      public function onOpenAnimComplete() : void
      {
         this.SetFocus();
      }
      
      public function UpdateFaction(param1:String) : void
      {
         this.KioskBackground_mc.Background_mc.gotoAndStop(param1);
         this.BackgroundDetails_mc.gotoAndStop(param1);
         this.KioskView_mc.FactionName = param1;
      }
   }
}
