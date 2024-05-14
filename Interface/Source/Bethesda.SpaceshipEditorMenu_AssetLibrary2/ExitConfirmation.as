package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class ExitConfirmation extends BSDisplayObject
   {
      
      private static const ROLL_ON:String = "rollOn";
      
      private static const NOMINAL:String = "Nominal";
      
      private static const WARNING:String = "Warning";
      
      private static const ERROR:String = "Error";
      
      private static const MESSAGE_TYPE_NOMINAL:uint = 0;
      
      private static const MESSAGE_TYPE_WARNING:uint = 1;
      
      private static const MESSAGE_TYPE_ERROR:uint = 2;
      
      public static const ShipEditor_OnExitConfirmExit:String = "ShipEditor_OnExitConfirmExit";
      
      public static const ShipEditor_OnExitConfirmCancel:String = "ShipEditor_OnExitConfirmCancel";
      
      public static const ShipEditor_OnExitConfirmSaveAndExit:String = "ShipEditor_OnExitConfirmSaveAndExit";
       
      
      public var Header_mc:MovieClip;
      
      public var Content_mc:MovieClip;
      
      public var FullscreenBG_mc:MovieClip;
      
      private var ExitButton:IButton = null;
      
      private var CancelButton:IButton = null;
      
      private var SaveAndExitButton:IButton = null;
      
      public function ExitConfirmation()
      {
         super();
         this.ButtonBar_mc.Initialize(1,1);
      }
      
      private function get HeaderText() : TextField
      {
         return this.Header_mc.text_tf;
      }
      
      private function get ButtonBar_mc() : ButtonBar
      {
         return this.Content_mc.ButtonBar_mc;
      }
      
      private function get ExitConfirmMessage() : ExitConfirmationMessage
      {
         return this.Content_mc.ExitConfirmMessage_mc;
      }
      
      override public function onAddedToStage() : void
      {
         GlobalFunc.SetText(this.HeaderText,"$ExitConfirmHeader");
         this.PopulateHintBar();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function PopulateHintBar() : void
      {
         this.SaveAndExitButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$ACCEPT",[new UserEventData("Accept",this.onSaveAndExit)]),this.ButtonBar_mc);
         this.ExitButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL MODIFICATION",[new UserEventData("Exit",this.onExit)]),this.ButtonBar_mc);
         this.CancelButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$BACK",[new UserEventData("Cancel",this.onCancel)]),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function UpdateValues(param1:Object) : *
      {
         this.gotoAndPlay(ROLL_ON);
         var _loc2_:String = "Error";
         switch(param1.uType)
         {
            case MESSAGE_TYPE_NOMINAL:
               _loc2_ = NOMINAL;
               this.SaveAndExitButton.Visible = true;
               this.SaveAndExitButton.Enabled = true;
               break;
            case MESSAGE_TYPE_WARNING:
               _loc2_ = WARNING;
               this.SaveAndExitButton.Visible = true;
               this.SaveAndExitButton.Enabled = true;
               break;
            case MESSAGE_TYPE_ERROR:
            default:
               _loc2_ = ERROR;
               this.SaveAndExitButton.Visible = false;
               this.SaveAndExitButton.Enabled = false;
         }
         this.ExitConfirmMessage.UpdateValues(_loc2_,param1.sHeaderText,param1.sBodyText);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function onExit() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipEditor_OnExitConfirmExit));
      }
      
      private function onCancel() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipEditor_OnExitConfirmCancel));
      }
      
      private function onSaveAndExit() : *
      {
         BSUIDataManager.dispatchEvent(new Event(ShipEditor_OnExitConfirmSaveAndExit));
      }
   }
}
