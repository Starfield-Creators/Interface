package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BuilderConfirmationPopup extends MovieClip
   {
      
      public static const CONFIRM_POPUP_ACCEPT:String = "ConfirmationPopup_Accept";
      
      public static const CONFIRM_POPUP_CANCEL:String = "ConfirmationPopup_Cancel";
       
      
      public var Header_mc:MovieClip;
      
      public var Details_mc:MovieClip;
      
      public var ConfirmMessage_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var ConfirmButton:IButton = null;
      
      private var CancelButton:IButton = null;
      
      private var _active:Boolean = false;
      
      public function BuilderConfirmationPopup()
      {
         super();
         this.SetUpButtons();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         if(this._active != param1)
         {
            this._active = param1;
            if(this.active)
            {
               gotoAndPlay("rollOn");
            }
            else
            {
               gotoAndPlay("rollOff");
            }
         }
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,10);
         this.ButtonBar_mc.ButtonBarColor = WorkshopBuilderMenu.BUTTON_BAR_COLOR;
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.ConfirmBuild)),this.ButtonBar_mc);
         this.CancelButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.CancelBuild),true,true,"UIMenuGeneralCancel"),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function PopulateTextInfo(param1:String, param2:String, param3:String) : void
      {
         GlobalFunc.SetText(this.Header_mc.Text_tf,param1);
         GlobalFunc.SetText(this.Details_mc.Text_tf,param2);
         GlobalFunc.SetText(this.ConfirmMessage_mc.Text_tf,param3);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function ConfirmBuild() : void
      {
         dispatchEvent(new Event(CONFIRM_POPUP_ACCEPT,true,true));
      }
      
      private function CancelBuild() : void
      {
         dispatchEvent(new Event(CONFIRM_POPUP_CANCEL,true,true));
      }
   }
}
