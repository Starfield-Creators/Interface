package Shared.Components.SystemPanels
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ControlBinding extends MovieClip
   {
      
      public static const MAIN_KEY:int = EnumHelper.GetEnum(0);
      
      public static const ALT_KEY:int = EnumHelper.GetEnum();
      
      public static const NO_PRIORITY:int = EnumHelper.GetEnum();
      
      public static const UNSELECTED:String = "unselected";
      
      public static const SELECTED:String = "selected";
      
      public static const LISTENING:String = "listening";
      
      public static const READ_ONLY:String = "readOnly";
       
      
      public var Icon_mc:MovieClip;
      
      public var PCKey_mc:MovieClip;
      
      private var _bindingPriority:int;
      
      private var _bindingState:String = "unselected";
      
      public function ControlBinding()
      {
         this._bindingPriority = MAIN_KEY;
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.iconTextField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.pcKeyTextField,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function get bindingPriority() : int
      {
         return this._bindingPriority;
      }
      
      public function set bindingPriority(param1:int) : *
      {
         this._bindingPriority = param1;
      }
      
      public function get bindingState() : String
      {
         return this._bindingState;
      }
      
      protected function get iconTextField() : TextField
      {
         return this.Icon_mc.Icon_tf;
      }
      
      protected function get pcKeyTextField() : TextField
      {
         return this.PCKey_mc.PCKey_tf;
      }
      
      public function SetBinding(param1:Object) : void
      {
         var _loc2_:String = "";
         var _loc3_:uint = 1;
         if(param1.aButtonName.length > 0)
         {
            _loc2_ = String(GlobalFunc.NameToTextMap[param1.aButtonName[0]]);
            while(_loc3_ < param1.aButtonName.length)
            {
               _loc2_ += " " + GlobalFunc.NameToTextMap[param1.aButtonName[_loc3_]];
               _loc3_++;
            }
            GlobalFunc.SetText(this.iconTextField,_loc2_);
            GlobalFunc.SetText(this.pcKeyTextField," ");
            this.iconTextField.visible = true;
         }
         else if(param1.aPCKeyName.length > 0)
         {
            _loc2_ = String(param1.aPCKeyName[0]);
            while(_loc3_ < param1.aPCKeyName.length)
            {
               _loc2_ += " " + param1.aPCKeyName[_loc3_];
               _loc3_++;
            }
            GlobalFunc.SetText(this.pcKeyTextField,_loc2_ + ")");
            this.iconTextField.visible = false;
         }
         else
         {
            GlobalFunc.SetText(this.pcKeyTextField," ");
            this.iconTextField.visible = false;
         }
      }
      
      public function SetState(param1:String) : void
      {
         this._bindingState = param1;
         if(currentFrameLabel != this._bindingState)
         {
            gotoAndStop(this._bindingState);
         }
      }
   }
}
