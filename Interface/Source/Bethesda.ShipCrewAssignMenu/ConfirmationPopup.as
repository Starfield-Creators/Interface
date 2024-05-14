package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ConfirmationPopup extends MovieClip
   {
       
      
      public var Message_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      protected var ConfirmButtonData:ButtonBaseData;
      
      protected var CancelButtonData:ButtonBaseData;
      
      protected var ConfirmButton:IButton;
      
      public var ConfirmFunc:Function = null;
      
      public var CancelFunc:Function = null;
      
      public function ConfirmationPopup()
      {
         this.ConfirmButtonData = new ButtonBaseData("$Confirm",new UserEventData("Accept",this.onConfirm),true,true);
         this.CancelButtonData = new ButtonBaseData("$Cancel",new UserEventData("Cancel",this.onCancel),true,true);
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",this.ConfirmButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,this.CancelButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function get Message_tf() : TextField
      {
         return this.Message_mc.Text_tf;
      }
      
      protected function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function Show() : *
      {
         if(visible == false)
         {
            visible = true;
            GlobalFunc.PlayMenuSound("UIToolTipPopUpStart");
         }
      }
      
      public function Hide() : *
      {
         visible = false;
      }
      
      protected function onConfirm() : *
      {
         if(this.ConfirmFunc != null)
         {
            this.ConfirmFunc();
         }
      }
      
      protected function onCancel() : *
      {
         if(this.CancelFunc != null)
         {
            GlobalFunc.PlayMenuSound("UIMenuGeneralCancel");
            this.CancelFunc();
         }
      }
      
      public function SetMessageText(param1:String, param2:String, param3:String) : *
      {
         GlobalFunc.SetText(this.Message_tf,param1,false,false,0,false,0,new Array(param2,param3));
      }
   }
}
