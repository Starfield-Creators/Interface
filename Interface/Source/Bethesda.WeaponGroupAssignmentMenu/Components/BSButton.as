package Components
{
   import Shared.AS3.BSDisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BSButton extends BSDisplayObject
   {
      
      public static const BUTTON_CLICKED_EVENT:String = "onButtonClicked";
       
      
      private var Over:Boolean = false;
      
      private var Down:Boolean = false;
      
      public function BSButton()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.onRollover);
         addEventListener(MouseEvent.MOUSE_OUT,this.onRollout);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onUp);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function get over() : Boolean
      {
         return this.Over;
      }
      
      public function get down() : Boolean
      {
         return this.Down;
      }
      
      public function get disabled() : Boolean
      {
         return currentLabel == "disabled";
      }
      
      public function set disabled(param1:*) : *
      {
         if(param1 && !this.disabled)
         {
            gotoAndPlay("disabled");
         }
         else if(!param1 && this.disabled)
         {
            gotoAndPlay(this.Down ? "down" : (this.Over ? "over" : "idle"));
         }
      }
      
      public function onRollover(param1:MouseEvent) : *
      {
         if(param1.buttonDown && this.Down)
         {
            this.onDown();
         }
         else
         {
            if(!this.disabled)
            {
               gotoAndPlay("idle_to_over");
            }
            this.Down = false;
         }
         this.Over = true;
      }
      
      public function onRollout() : *
      {
         if(!this.disabled)
         {
            gotoAndPlay(this.Down ? "down_to_idle" : "over_to_idle");
         }
         this.Over = false;
      }
      
      public function onDown() : *
      {
         if(!this.disabled)
         {
            gotoAndPlay(this.Over ? "over_to_down" : "idle_to_down");
         }
         this.Down = true;
      }
      
      public function onUp() : *
      {
         if(!this.disabled && this.Down)
         {
            gotoAndPlay("up");
         }
         this.Down = false;
      }
      
      public function onClick() : *
      {
         if(!this.disabled)
         {
            gotoAndPlay("click");
            dispatchEvent(new Event(BUTTON_CLICKED_EVENT,true,true));
         }
      }
   }
}
