package
{
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import flash.display.MovieClip;
   
   public class SitWaitMenu extends IMenu
   {
       
      
      public var BGSCodeObj:Object;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var ButtonBackground_mc:MovieClip;
      
      private const BUTTON_BACKGROUND_LEFT_BUFFER:uint = 3;
      
      private const BUTTON_BACKGROUND_RIGHT_BUFFER:uint = 20;
      
      public function SitWaitMenu()
      {
         super();
         this.BGSCodeObj = new Object();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER);
         this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.WaitButton_mc,new ButtonBaseData("$Wait",new UserEventData("StartWait",this.onWaitButtonClicked)));
         this.ButtonBar_mc.RefreshButtons();
         this.ButtonBackground_mc.width = this.ButtonBar_mc.width + this.BUTTON_BACKGROUND_LEFT_BUFFER + this.BUTTON_BACKGROUND_RIGHT_BUFFER;
         this.ButtonBackground_mc.x = this.ButtonBar_mc.x - this.BUTTON_BACKGROUND_LEFT_BUFFER;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function onWaitButtonClicked() : void
      {
         this.BGSCodeObj.StartWaiting();
      }
   }
}
