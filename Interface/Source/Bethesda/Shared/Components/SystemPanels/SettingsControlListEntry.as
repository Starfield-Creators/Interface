package Shared.Components.SystemPanels
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   
   public class SettingsControlListEntry extends BSContainerEntry
   {
      
      public static const ACTIVE_BINDING_CHANGED:String = "SettingsControlListEnty_ActiveBindingChanged";
       
      
      public var Text_mc:MovieClip;
      
      public var MainBinding_mc:ControlBinding;
      
      public var AltBinding_mc:ControlBinding;
      
      public var Fill_mc:MovieClip;
      
      public var Divider_mc:MovieClip;
      
      public var ReadOnly_mc:MovieClip;
      
      private var _controlName:String = "";
      
      private var controlContextID:uint = 4294967295;
      
      private var _isDividerEntry:Boolean = false;
      
      private var _isReadOnly:Boolean = false;
      
      private var _activeBinding:ControlBinding = null;
      
      public function SettingsControlListEntry()
      {
         super();
         this.MainBinding_mc.bindingPriority = ControlBinding.MAIN_KEY;
         this.AltBinding_mc.bindingPriority = ControlBinding.ALT_KEY;
         this.MainBinding_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onBindingRollover);
         this.MainBinding_mc.addEventListener(MouseEvent.MOUSE_OUT,this.ClearActiveBinding);
         this.MainBinding_mc.addEventListener(MouseEvent.CLICK,this.onBindingPress);
         this.AltBinding_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onBindingRollover);
         this.AltBinding_mc.addEventListener(MouseEvent.MOUSE_OUT,this.ClearActiveBinding);
         this.AltBinding_mc.addEventListener(MouseEvent.CLICK,this.onBindingPress);
      }
      
      public function get activePriority() : int
      {
         if(this._activeBinding != null)
         {
            return this._activeBinding.bindingPriority;
         }
         return ControlBinding.NO_PRIORITY;
      }
      
      public function get isDividerEntry() : Boolean
      {
         return this._isDividerEntry;
      }
      
      public function set isDividerEntry(param1:Boolean) : void
      {
         this._isDividerEntry = param1;
      }
      
      public function get isReadOnly() : Boolean
      {
         return this._isReadOnly;
      }
      
      public function set isReadOnly(param1:Boolean) : void
      {
         this._isReadOnly = param1;
         if(this.isReadOnly)
         {
            this.ClearActiveBinding();
            this.MainBinding_mc.SetState(ControlBinding.READ_ONLY);
            this.AltBinding_mc.SetState(ControlBinding.READ_ONLY);
         }
         else
         {
            if(this.MainBinding_mc.bindingState == ControlBinding.READ_ONLY)
            {
               this.MainBinding_mc.SetState(ControlBinding.UNSELECTED);
            }
            if(this.AltBinding_mc.bindingState == ControlBinding.READ_ONLY)
            {
               this.AltBinding_mc.SetState(ControlBinding.UNSELECTED);
            }
         }
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.textField;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:TextLineMetrics = null;
         var _loc5_:String = null;
         this.isReadOnly = param1.bReadOnly === true;
         this.ReadOnly_mc.alpha = this.isReadOnly ? 0.5 : 0;
         this.isDividerEntry = param1.bIsDivider === true;
         this.Divider_mc.visible = this.isDividerEntry;
         this.MainBinding_mc.alpha = this.isDividerEntry ? 0 : 1;
         this.AltBinding_mc.alpha = this.isDividerEntry ? 0 : 1;
         this.Fill_mc.visible = !this.isDividerEntry;
         this._controlName = param1.sInputName;
         this.controlContextID = param1.uContextID;
         this.MainBinding_mc.SetBinding(param1.MainBinding);
         this.AltBinding_mc.SetBinding(param1.AltBinding);
         if(this.isDividerEntry)
         {
            GlobalFunc.SetText(this.baseTextField,"$" + param1.sContextName);
            _loc2_ = 40;
            _loc3_ = this.Divider_mc.x + this.Divider_mc.width;
            _loc4_ = this.baseTextField.getLineMetrics(0);
            this.Divider_mc.x = this.baseTextField.x + _loc4_.x + _loc4_.width + _loc2_;
            this.Divider_mc.width = _loc3_ - this.Divider_mc.x;
            this.ClearActiveBinding();
         }
         else
         {
            _loc5_ = "$" + param1.sContextName + "_" + this._controlName;
            GlobalFunc.SetText(this.baseTextField,_loc5_);
            if(this.baseTextField.text == _loc5_)
            {
               _loc5_ += !!param1.bGamepadEntry ? "_GP" : "_KBM";
            }
            if(param1.bRequired)
            {
               GlobalFunc.SetText(this.baseTextField,"$" + _loc5_ + " *");
            }
            else
            {
               GlobalFunc.SetText(this.baseTextField,_loc5_);
            }
         }
      }
      
      override public function onRollover() : void
      {
         if(!this.isDividerEntry)
         {
            super.onRollover();
         }
      }
      
      override public function onRollout() : void
      {
         super.onRollout();
         this.ClearActiveBinding();
      }
      
      public function SetActiveBinding(param1:int) : void
      {
         var _loc2_:int = this.activePriority;
         if(this._activeBinding != null)
         {
            this._activeBinding.SetState(ControlBinding.UNSELECTED);
         }
         if(this.isReadOnly || this.isDividerEntry)
         {
            param1 = ControlBinding.NO_PRIORITY;
         }
         switch(param1)
         {
            case ControlBinding.MAIN_KEY:
               this._activeBinding = this.MainBinding_mc;
               break;
            case ControlBinding.ALT_KEY:
               this._activeBinding = this.AltBinding_mc;
               break;
            default:
               this._activeBinding = null;
         }
         if(this._activeBinding != null)
         {
            this._activeBinding.SetState(ControlBinding.SELECTED);
         }
         if(_loc2_ != this.activePriority)
         {
            dispatchEvent(new Event(ACTIVE_BINDING_CHANGED,true,true));
         }
      }
      
      public function ClearActiveBinding() : void
      {
         this.SetActiveBinding(ControlBinding.NO_PRIORITY);
      }
      
      public function ClearListenState() : void
      {
         if(this._activeBinding != null)
         {
            this._activeBinding.SetState(ControlBinding.SELECTED);
         }
      }
      
      public function onEntryPressed() : void
      {
         if(!this.isDividerEntry && !this.isReadOnly)
         {
            this.onBindingPress();
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this.isDividerEntry && !this.isReadOnly && (param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT))
         {
            if(this._activeBinding == this.MainBinding_mc)
            {
               this.SetActiveBinding(ControlBinding.ALT_KEY);
               GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
            }
            else if(this._activeBinding == this.AltBinding_mc)
            {
               this.SetActiveBinding(ControlBinding.MAIN_KEY);
               GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
            }
         }
      }
      
      public function onBindingRollover(param1:Event) : void
      {
         if(!this.isDividerEntry && !this.isReadOnly)
         {
            if(this._activeBinding != param1.currentTarget as ControlBinding)
            {
               GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
            }
            this.SetActiveBinding((param1.currentTarget as ControlBinding).bindingPriority);
         }
      }
      
      public function onBindingPress(param1:Event = null) : void
      {
         if(this._activeBinding != null)
         {
            this._activeBinding.SetState(ControlBinding.LISTENING);
            BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_RemapMode",{
               "name":this._controlName,
               "keyPriority":this.activePriority,
               "contextID":this.controlContextID
            }));
         }
         if(param1 != null)
         {
            param1.stopPropagation();
         }
      }
      
      public function onDeleteBinding() : void
      {
         if(this.activePriority == ControlBinding.ALT_KEY)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("SettingsPanel_ClearBinding",{
               "name":this._controlName,
               "keyPriority":this.activePriority,
               "contextID":this.controlContextID
            }));
         }
      }
   }
}
