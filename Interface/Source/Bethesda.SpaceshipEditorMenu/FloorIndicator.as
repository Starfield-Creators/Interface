package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FloorIndicator extends BSDisplayObject
   {
      
      private static const SCROLL_UP:String = "Scroll_Up";
      
      private static const SCROLL_DOWN:String = "Scroll_Down";
       
      
      public var Indicator_mc:MovieClip;
      
      public var FloorBars_mc:MovieClip;
      
      public var ExtraIndicator_mc:ExtraIndicator;
      
      public var FloorUpButton_mc:TextField;
      
      public var FloorDownButton_mc:TextField;
      
      public var UpKey_mc:MovieClip;
      
      public var DownKey_mc:MovieClip;
      
      private var CurrentFloor:int = 0;
      
      public function FloorIndicator()
      {
         super();
         GlobalFunc.SetText(this.FloorText,GlobalFunc.FormatNumberToString(this.CurrentFloor));
         this.ExtraIndicator_mc.visible = false;
      }
      
      private function get FloorText() : TextField
      {
         return this.Indicator_mc.FloorText_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
         this.UpKey_mc.SetButtonData(new ButtonBaseData("",[new UserEventData("FloorUp",null)],false));
         this.DownKey_mc.SetButtonData(new ButtonBaseData("",[new UserEventData("FloorDown",null)],false));
      }
      
      public function ChangeFloor(param1:int) : *
      {
         if(param1 == this.CurrentFloor)
         {
            return;
         }
         GlobalFunc.SetText(this.FloorText,GlobalFunc.FormatNumberToString(param1));
         if(param1 > this.CurrentFloor)
         {
            this.FloorBars_mc.gotoAndPlay(SCROLL_UP);
            if(this.ExtraIndicator_mc.visible)
            {
               this.ExtraIndicator_mc.ScrollDown();
            }
         }
         else
         {
            this.FloorBars_mc.gotoAndPlay(SCROLL_DOWN);
            if(this.ExtraIndicator_mc.visible)
            {
               this.ExtraIndicator_mc.ScrollUp();
            }
         }
         this.CurrentFloor = param1;
      }
   }
}
