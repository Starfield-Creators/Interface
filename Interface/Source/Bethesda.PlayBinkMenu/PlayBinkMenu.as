package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.Extensions;
   
   public class PlayBinkMenu extends IMenu
   {
      
      public static const PlayBink_CloseMenu:String = "PlayBink_CloseMenu";
       
      
      public var MyButtonManager:ButtonManager;
      
      public var SkipButton_mc:*;
      
      public var FadeRect_mc:MovieClip;
      
      public var BGSCodeObj:Object;
      
      private var bAllowConfirm:* = true;
      
      public function PlayBinkMenu()
      {
         this.MyButtonManager = new ButtonManager();
         super();
         this.BGSCodeObj = new Object();
         this.SkipButton_mc.SetButtonData(new ButtonBaseData("$SKIP",new UserEventData("YButton",this.Skip,"")));
         this.MyButtonManager.AddButton(this.SkipButton_mc);
      }
      
      public function set allowConfirm(param1:Boolean) : *
      {
         this.bAllowConfirm = param1;
      }
      
      public function showBlackRect() : *
      {
         this.FadeRect_mc.visible = true;
      }
      
      override protected function onSetSafeRect() : void
      {
         this.FadeRect_mc.x = Extensions.visibleRect.x;
         this.FadeRect_mc.y = Extensions.visibleRect.y;
         this.FadeRect_mc.width = Extensions.visibleRect.width;
         this.FadeRect_mc.height = Extensions.visibleRect.height;
      }
      
      private function Skip() : *
      {
         if(this.bAllowConfirm)
         {
            BSUIDataManager.dispatchEvent(new Event(PlayBink_CloseMenu,true));
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
   }
}
