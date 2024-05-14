package
{
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TargetConfirmationPopup extends MovieClip
   {
      
      public static const CREATE_LINK:int = EnumHelper.GetEnum(0);
      
      public static const CHANGE_LINK:int = EnumHelper.GetEnum();
      
      public static const REMOVE_LINK:int = EnumHelper.GetEnum();
      
      public static const CONFIRM_POPUP_ACCEPT:String = "ConfirmationPopup_Accept";
      
      public static const CONFIRM_POPUP_CANCEL:String = "ConfirmationPopup_Cancel";
       
      
      public var PromptText_mc:MovieClip;
      
      public var CurrentLinkText_mc:MovieClip;
      
      public var NewLinkText_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      private const BUTTON_SPACING:uint = 10;
      
      private var ConfirmButton:IButton = null;
      
      private var CancelButton:IButton = null;
      
      private var _active:Boolean = false;
      
      public function TargetConfirmationPopup()
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
               gotoAndPlay("Open");
            }
            else
            {
               gotoAndPlay("Close");
            }
         }
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,this.BUTTON_SPACING);
         var _loc1_:ButtonFactory = new ButtonFactory();
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.ConfirmLink)),this.ButtonBar_mc);
         this.CancelButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.CancelLink),true,true,"UIMenuGeneralCancel"),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function SetPopupText(param1:uint, param2:String, param3:String) : void
      {
         switch(param1)
         {
            case CREATE_LINK:
               GlobalFunc.SetText(this.PromptText_mc.text_tf,"$OutpostTargetMenu_CreateLink");
               GlobalFunc.SetText(this.CurrentLinkText_mc.text_tf,"$$CURRENT_LINK: " + "$$NONE");
               GlobalFunc.SetText(this.NewLinkText_mc.text_tf,"$$NEW_LINK: " + param3);
               break;
            case CHANGE_LINK:
               GlobalFunc.SetText(this.PromptText_mc.text_tf,"$OutpostTargetMenu_ChangeLink");
               GlobalFunc.SetText(this.CurrentLinkText_mc.text_tf,"$$CURRENT_LINK: " + param2);
               GlobalFunc.SetText(this.NewLinkText_mc.text_tf,"$$NEW_LINK: " + param3);
               break;
            case REMOVE_LINK:
               GlobalFunc.SetText(this.PromptText_mc.text_tf,"$OutpostTargetMenu_RemoveLink");
               GlobalFunc.SetText(this.CurrentLinkText_mc.text_tf,"$$CURRENT_LINK: " + param2);
               GlobalFunc.SetText(this.NewLinkText_mc.text_tf,"$$NEW_LINK: " + "$$NONE");
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function ConfirmLink() : void
      {
         dispatchEvent(new Event(CONFIRM_POPUP_ACCEPT,true,true));
      }
      
      private function CancelLink() : void
      {
         dispatchEvent(new Event(CONFIRM_POPUP_CANCEL,true,true));
      }
   }
}
