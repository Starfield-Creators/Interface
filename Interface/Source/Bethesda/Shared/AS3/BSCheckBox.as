package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   
   public class BSCheckBox extends BSDisplayObject
   {
      
      public static const VALUE_CHANGED:String = "Checkbox::VALUE_CHANGE";
      
      public static const INPUT_CHANGED:String = "Checkbox::INPUT_CHANGE";
       
      
      public var FocusRect_mc:MovieClip;
      
      public var ToggleText_mc:MovieClip;
      
      private var _Checked:Boolean;
      
      private var _checkboxEnabled:Boolean = true;
      
      private const CHECKED_FRAME_LABEL:String = "checked";
      
      private const UNCHECKED_FRAME_LABEL:String = "unchecked";
      
      public function BSCheckBox()
      {
         super();
         this._Checked = false;
         if(this.FocusRect_mc != null)
         {
            this.FocusRect_mc.visible = false;
         }
         if(this.ToggleText_tf != null)
         {
            this.ToggleText_tf.autoSize = TextFieldAutoSize.CENTER;
         }
      }
      
      protected function get ToggleText_tf() : TextField
      {
         return this.ToggleText_mc.ToggleText_tf;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         addEventListener(MouseEvent.CLICK,this.onCheckboxClick);
         addEventListener(KeyboardEvent.KEY_UP,this.onCheckboxPressed);
         stage.addEventListener(FocusEvent.FOCUS_IN,this.onFocusChanged);
         stage.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusChanged);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         removeEventListener(MouseEvent.CLICK,this.onCheckboxClick);
         removeEventListener(KeyboardEvent.KEY_UP,this.onCheckboxPressed);
         stage.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusChanged);
         stage.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusChanged);
      }
      
      public function get checked() : Boolean
      {
         return this._Checked;
      }
      
      public function set checked(param1:Boolean) : *
      {
         this._Checked = param1;
         SetIsDirty();
      }
      
      public function get checkboxEnabled() : Boolean
      {
         return this._checkboxEnabled;
      }
      
      public function set checkboxEnabled(param1:Boolean) : void
      {
         if(param1 != this._checkboxEnabled)
         {
            this._checkboxEnabled = param1;
            if(this._checkboxEnabled)
            {
               addEventListener(MouseEvent.CLICK,this.onCheckboxClick);
               addEventListener(KeyboardEvent.KEY_UP,this.onCheckboxPressed);
            }
            else
            {
               removeEventListener(MouseEvent.CLICK,this.onCheckboxClick);
               removeEventListener(KeyboardEvent.KEY_UP,this.onCheckboxPressed);
            }
         }
      }
      
      override public function redrawDisplayObject() : void
      {
         var _loc1_:String = null;
         if(this._Checked && this.currentFrameLabel != this.CHECKED_FRAME_LABEL)
         {
            this.gotoAndStop(this.CHECKED_FRAME_LABEL);
         }
         else if(!this._Checked && this.currentFrameLabel != this.UNCHECKED_FRAME_LABEL)
         {
            this.gotoAndStop(this.UNCHECKED_FRAME_LABEL);
         }
         if(this.ToggleText_tf != null)
         {
            _loc1_ = this._Checked ? "$ON" : "$OFF";
            GlobalFunc.SetText(this.ToggleText_tf,_loc1_,false);
         }
         if(this.FocusRect_mc != null)
         {
            this.FocusRect_mc.visible = stage.focus == this;
         }
      }
      
      public function PressHandler() : void
      {
         if(this.checkboxEnabled)
         {
            this.Toggle();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
      }
      
      private function onCheckboxClick(param1:Event) : *
      {
         if(this.checkboxEnabled)
         {
            this.Toggle();
            param1.stopPropagation();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
      }
      
      public function onCheckboxPressed(param1:KeyboardEvent) : *
      {
         if(this.checkboxEnabled && param1.keyCode == Keyboard.ENTER)
         {
            this.Toggle();
            param1.stopPropagation();
            dispatchEvent(new Event(INPUT_CHANGED,true,true));
         }
      }
      
      private function Toggle() : void
      {
         this._Checked = !this._Checked;
         dispatchEvent(new Event(VALUE_CHANGED,true,true));
         SetIsDirty();
      }
      
      private function onFocusChanged(param1:Event) : *
      {
         SetIsDirty();
      }
   }
}
