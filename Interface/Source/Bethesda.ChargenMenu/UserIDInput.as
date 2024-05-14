package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import Shared.TextUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   public class UserIDInput extends MovieClip
   {
       
      
      public var InputUserName_tf:TextField;
      
      public var NameClip_mc:MovieClip;
      
      private var bEnteringText:Boolean = false;
      
      private var OrigName:String;
      
      public function UserIDInput()
      {
         super();
         this.InputUserName_tf.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartTextEntry);
         this.InputUserName_tf.addEventListener(TextEvent.TEXT_INPUT,this.onNameTextInput);
         BSUIDataManager.Subscribe("ChargenData",this.OnChargenDataChanged);
      }
      
      public function get enteringText() : Boolean
      {
         return this.bEnteringText;
      }
      
      public function get playerNameChanged() : Boolean
      {
         return CharGenMenu.nameChanged && this.InputUserName_tf.text.length > 0;
      }
      
      private function OnChargenDataChanged(param1:FromClientDataEvent) : void
      {
         GlobalFunc.SetText(this.InputUserName_tf,param1.data.sPlayerName);
      }
      
      private function onMenuKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this.enteringText)
            {
               this.EndEditText();
            }
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            GlobalFunc.SetText(this.InputUserName_tf,this.OrigName);
            this.EndEditText(false,true);
         }
      }
      
      private function onStartTextEntry(param1:MouseEvent) : *
      {
         this.StartTextEntry();
      }
      
      public function StartTextEntry(param1:* = false) : *
      {
         var _loc2_:String = null;
         if(!this.bEnteringText)
         {
            _loc2_ = TextUtils.TrimString(this.InputUserName_tf.text);
            this.InputUserName_tf.text = _loc2_;
            this.OrigName = _loc2_;
            this.InputUserName_tf.type = TextFieldType.INPUT;
            this.InputUserName_tf.selectable = true;
            this.InputUserName_tf.maxChars = 26;
            GlobalFunc.SetText(this.InputUserName_tf,"");
            stage.focus = this.InputUserName_tf;
            BSUIDataManager.dispatchEvent(new Event("CharGen_StartTextEntry"));
            GlobalFunc.PlayMenuSound(GlobalFunc.OK_SOUND);
            this.bEnteringText = true;
            addEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
         }
      }
      
      public function EndEditText(param1:Boolean = false, param2:Boolean = false) : *
      {
         stage.focus = this;
         var _loc3_:String = TextUtils.TrimString(this.InputUserName_tf.text);
         if(_loc3_ != this.InputUserName_tf.text)
         {
            GlobalFunc.SetText(this.InputUserName_tf,_loc3_);
         }
         this.bEnteringText = false;
         this.InputUserName_tf.type = TextFieldType.DYNAMIC;
         this.InputUserName_tf.setSelection(0,0);
         this.InputUserName_tf.selectable = false;
         this.InputUserName_tf.maxChars = 0;
         if(!param1)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_EndTextEntry",{
               "sPlayerName":_loc3_,
               "bCancelled":param2 || _loc3_.length == 0
            }));
         }
         removeEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
         dispatchEvent(new Event(CompleteConfirm.UPDATE_BUTTONS));
      }
      
      public function CancelEditText() : *
      {
         stage.focus = this;
         this.bEnteringText = false;
         GlobalFunc.SetText(this.InputUserName_tf,this.OrigName);
         this.InputUserName_tf.type = TextFieldType.DYNAMIC;
         this.InputUserName_tf.setSelection(0,0);
         this.InputUserName_tf.selectable = false;
         this.InputUserName_tf.maxChars = 0;
         BSUIDataManager.dispatchEvent(new Event("CharGen_CancelTextEntry"));
         removeEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
      }
      
      public function SetActive(param1:Boolean) : *
      {
      }
      
      public function SetPlayerName(param1:String) : *
      {
         GlobalFunc.SetText(this.InputUserName_tf,param1);
      }
      
      private function onNameTextInput() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_CHARACTER_NAME_TYPE);
      }
   }
}
