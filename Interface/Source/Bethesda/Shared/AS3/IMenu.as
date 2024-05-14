package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.InteractiveObject;
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class IMenu extends BSDisplayObject
   {
       
      
      private var _bRestoreLostFocus:Boolean;
      
      private var safeX:Number = 0;
      
      private var safeY:Number = 0;
      
      private var textFieldSizeMap:Object;
      
      public function IMenu()
      {
         this.textFieldSizeMap = new Object();
         super();
         this._bRestoreLostFocus = false;
         GlobalFunc.MaintainTextFormat();
      }
      
      public function get SafeX() : Number
      {
         return this.safeX;
      }
      
      public function get SafeY() : Number
      {
         return this.safeY;
      }
      
      override public function onAddedToStage() : void
      {
         stage.stageFocusRect = false;
         stage.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusLostEvent);
         stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onMouseFocusEvent);
      }
      
      override public function onRemovedFromStage() : void
      {
         stage.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusLostEvent);
         stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onMouseFocusEvent);
      }
      
      public function SetSafeRect(param1:Number, param2:Number) : *
      {
         this.safeX = param1;
         this.safeY = param2;
         this.onSetSafeRect();
      }
      
      protected function onSetSafeRect() : void
      {
      }
      
      private function onFocusLostEvent(param1:FocusEvent) : *
      {
         if(this._bRestoreLostFocus)
         {
            this._bRestoreLostFocus = false;
            stage.focus = param1.target as InteractiveObject;
         }
         this.onFocusLost(param1);
      }
      
      public function onFocusLost(param1:FocusEvent) : *
      {
      }
      
      protected function onMouseFocusEvent(param1:FocusEvent) : *
      {
         if(param1.target == null || !(param1.target is InteractiveObject))
         {
            stage.focus = null;
         }
         else
         {
            this._bRestoreLostFocus = true;
         }
      }
      
      public function ShrinkFontToFit(param1:TextField, param2:int) : *
      {
         var _loc5_:int = 0;
         var _loc3_:TextFormat = param1.getTextFormat();
         if(this.textFieldSizeMap[param1] == null)
         {
            this.textFieldSizeMap[param1] = _loc3_.size;
         }
         _loc3_.size = this.textFieldSizeMap[param1];
         param1.setTextFormat(_loc3_);
         var _loc4_:int = param1.maxScrollV;
         while(_loc4_ > param2 && _loc3_.size > 4)
         {
            _loc5_ = _loc3_.size as int;
            _loc3_.size = _loc5_ - 1;
            param1.setTextFormat(_loc3_);
            _loc4_ = param1.maxScrollV;
         }
      }
   }
}
