package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import Shared.TextUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   public class TextInputMenu extends IMenu
   {
       
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Header_tf:TextField;
      
      public var Input_tf:TextField;
      
      public var UserID_UserNameSelector_mc:MovieClip;
      
      public var UserID_BG_mc:MovieClip;
      
      private var OriginalText:String;
      
      private var _maxChars:uint = 0;
      
      private var _enteringText:Boolean = false;
      
      public function TextInputMenu()
      {
         super();
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,10);
         this.ButtonBar_mc.AddButtonWithData(this.AcceptButton,new ButtonBaseData("$ACCEPT",[new UserEventData("Accept",this.onAccept)]));
         this.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ButtonBaseData("$CANCEL",[new UserEventData("Cancel",this.onCancel)]));
         this.ButtonBar_mc.RefreshButtons();
         this.Input_tf.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartTextEntry);
         BSUIDataManager.Subscribe("TextInputData",this.OnTextInputDataChanged);
      }
      
      private function get AcceptButton() : IButton
      {
         return this.ButtonBar_mc.AcceptButton_mc;
      }
      
      private function get CancelButton() : IButton
      {
         return this.ButtonBar_mc.CancelButton_mc;
      }
      
      public function get enteringText() : Boolean
      {
         return this._enteringText;
      }
      
      public function set enteringText(param1:Boolean) : void
      {
         this._enteringText = param1;
      }
      
      public function get maxChars() : uint
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:uint) : void
      {
         this._maxChars = param1;
      }
      
      private function OnTextInputDataChanged(param1:FromClientDataEvent) : void
      {
         var _loc2_:Object = param1.data;
         GlobalFunc.SetText(this.Header_tf,_loc2_.sHeader);
         GlobalFunc.SetText(this.Input_tf,_loc2_.sDefaultText);
         this.maxChars = _loc2_.uMaxChars;
         if(_loc2_.bVirtualKeyboardComplete)
         {
            this.EndEditText(true);
         }
         else if(_loc2_.bEnteringText)
         {
            this.StartTextEntry();
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function onMenuKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.EndEditText();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.onCancel();
         }
      }
      
      private function onStartTextEntry(param1:MouseEvent) : *
      {
         this.StartTextEntry();
      }
      
      public function StartTextEntry() : *
      {
         var _loc1_:String = null;
         if(!this.enteringText)
         {
            this.enteringText = true;
            _loc1_ = TextUtils.TrimString(this.Input_tf.text);
            this.Input_tf.text = _loc1_;
            this.OriginalText = _loc1_;
            this.Input_tf.type = TextFieldType.INPUT;
            this.Input_tf.selectable = true;
            this.Input_tf.maxChars = this.maxChars;
            this.Input_tf.setSelection(0,this.Input_tf.text.length);
            stage.focus = this.Input_tf;
            BSUIDataManager.dispatchEvent(new Event("TextInputMenu_StartEditText"));
            addEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
         }
      }
      
      public function EndEditText(param1:Boolean = false) : *
      {
         this.Input_tf.type = TextFieldType.DYNAMIC;
         this.Input_tf.setSelection(0,0);
         this.Input_tf.selectable = false;
         this.Input_tf.maxChars = 0;
         stage.focus = this;
         var _loc2_:String = TextUtils.TrimString(this.Input_tf.text);
         if(_loc2_ != this.Input_tf.text)
         {
            GlobalFunc.SetText(this.Input_tf,_loc2_);
         }
         if(!param1)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("TextInputMenu_EndEditText",{"sText":_loc2_}));
         }
         removeEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
         this.enteringText = false;
      }
      
      private function onAccept() : *
      {
         this.EndEditText();
      }
      
      private function onCancel() : *
      {
         BSUIDataManager.dispatchEvent(new Event("TextInputMenu_InputCanceled",true,true));
      }
   }
}
