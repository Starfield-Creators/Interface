package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class InputEater extends MovieClip
   {
       
      
      private var MimicClipsA:Vector.<MovieClip>;
      
      private var _mimicClips:Array;
      
      private var _inputEvent:String = "";
      
      private var _enableDebugging:Boolean = false;
      
      private var _IsMouseOver:Boolean = false;
      
      private var ActionPressEaten:Boolean = false;
      
      public function InputEater()
      {
         this.MimicClipsA = new Vector.<MovieClip>();
         this._mimicClips = new Array();
         super();
         this.mouseEnabled = false;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function get MimicClips() : Array
      {
         return this._mimicClips;
      }
      
      public function set MimicClips(param1:Array) : *
      {
         this._mimicClips = param1;
      }
      
      public function get InputEvent() : String
      {
         return this._inputEvent;
      }
      
      public function set InputEvent(param1:String) : *
      {
         this._inputEvent = param1;
      }
      
      public function get EnableDebugging() : Boolean
      {
         return this._enableDebugging;
      }
      
      public function set EnableDebugging(param1:Boolean) : *
      {
         this._enableDebugging = param1;
      }
      
      public function get IsMouseOver() : Boolean
      {
         return this._IsMouseOver;
      }
      
      private function onMouseOver() : void
      {
         if(this.EnableDebugging)
         {
            this.alpha = 0.5;
         }
         this._IsMouseOver = true;
      }
      
      private function onMouseOut() : void
      {
         if(this.EnableDebugging)
         {
            this.alpha = 0;
         }
         this._IsMouseOver = false;
      }
      
      private function onEnterFrame() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         for each(_loc1_ in this.MimicClips)
         {
            _loc2_ = this.parent.getChildByName(_loc1_) as MovieClip;
            if(_loc2_ != null)
            {
               this.RegisterBlockingUIElement(_loc2_);
            }
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:* = param1 == this._inputEvent && this.IsMouseOver;
         _loc3_ &&= param2 || this.ActionPressEaten;
         this.ActionPressEaten = param2 && _loc3_;
         return _loc3_;
      }
      
      public function RegisterBlockingUIElement(param1:MovieClip) : void
      {
         if(this.MimicClipsA.indexOf(param1) == -1)
         {
            this.MimicClipsA.push(param1);
            param1.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            param1.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         }
      }
   }
}
