package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ChargenConfirmDestructiveChanges extends MovieClip
   {
      
      public static const CONFIRM_FINISHED:String = "DESTRUCTION_CONFIRM_FINISHED";
       
      
      public var ConfirmButtonBar_mc:ButtonBar;
      
      private var ButtonCancel:IButton = null;
      
      private var ButtonAccept:IButton = null;
      
      private var Func:Function = null;
      
      private const BUTTON_COLOR:uint = 2308933;
      
      public function ChargenConfirmDestructiveChanges()
      {
         super();
         this.ConfirmButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         this.ButtonAccept = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",[new UserEventData("Accept",this.onAccept)]),this.ConfirmButtonBar_mc);
         this.ButtonCancel = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$BACK",[new UserEventData("Cancel",this.onCancel)]),this.ConfirmButtonBar_mc);
         this.ConfirmButtonBar_mc.ButtonBarColor = this.BUTTON_COLOR;
         this.ConfirmButtonBar_mc.RefreshButtons();
         this.SetActive(false);
      }
      
      public function SetActive(param1:Boolean, param2:Function = null) : *
      {
         this.Func = param2;
         this.ButtonAccept.Enabled = param1;
         this.ButtonCancel.Enabled = param1;
         this.visible = param1;
      }
      
      public function get active() : Boolean
      {
         return this.visible;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(!param2)
         {
            if(param1 == "Cancel")
            {
               this.onCancel();
               return true;
            }
            if(param1 == "Accept")
            {
               this.onAccept();
               return true;
            }
         }
         return false;
      }
      
      private function onAccept() : *
      {
         if(this.Func != null)
         {
            this.Func();
         }
         CharGenMenu.characterDirty = false;
         dispatchEvent(new Event(CONFIRM_FINISHED,true,true));
         this.visible = false;
      }
      
      private function onCancel() : *
      {
         dispatchEvent(new Event(CONFIRM_FINISHED,true,true));
         this.visible = false;
      }
   }
}
