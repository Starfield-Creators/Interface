package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ExtraIndicator extends BSDisplayObject
   {
      
      private static const KEYFRAME_MIN:int = 0;
      
      private static const KEYFRAME_MAX:int = 21;
      
      private static const KEYFRAME_OFFSET:int = 11;
       
      
      public var FloorText_mc:MovieClip;
      
      private var CurrentFloor:int = 0;
      
      public function ExtraIndicator()
      {
         super();
      }
      
      private function get FloorText() : TextField
      {
         return this.FloorText_mc.text_tf;
      }
      
      override public function onAddedToStage() : void
      {
      }
      
      public function Initialize(param1:int) : *
      {
         this.CurrentFloor = param1;
         GlobalFunc.SetText(this.FloorText,GlobalFunc.FormatNumberToString(param1));
         this.ChangeFloor();
         this.visible = true;
      }
      
      public function ScrollUp() : *
      {
         ++this.CurrentFloor;
         this.ChangeFloor();
      }
      
      public function ScrollDown() : *
      {
         --this.CurrentFloor;
         this.ChangeFloor();
      }
      
      private function ChangeFloor() : *
      {
         var _loc1_:* = -(this.CurrentFloor * 2) + KEYFRAME_OFFSET;
         _loc1_ = Math.min(_loc1_,KEYFRAME_MAX);
         _loc1_ = Math.max(_loc1_,KEYFRAME_MIN);
         gotoAndStop(_loc1_);
      }
   }
}
