package
{
   import Shared.AS3.Data.BSUIDataManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class ColorSwatch extends MovieClip
   {
      
      private static const ShipEditor_OnRecentColorSwatchClicked:String = "ShipEditor_OnRecentColorSwatchClicked";
       
      
      public var Empty_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      private const EMPTY:* = "Empty";
      
      private const FILL:* = "Fill";
      
      private var SwatchColor:uint;
      
      private var SwatchID:uint;
      
      public function ColorSwatch()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function set swatchID(param1:uint) : *
      {
         this.SwatchID = param1;
      }
      
      protected function onAddedToStage(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(MouseEvent.CLICK,this.OnMouseClick);
      }
      
      protected function OnMouseClick(param1:MouseEvent) : void
      {
         if(!this.IsEmpty())
         {
            BSUIDataManager.dispatchCustomEvent(ShipEditor_OnRecentColorSwatchClicked,{"swatchIndex":this.SwatchID});
         }
      }
      
      public function SetColor(param1:uint) : void
      {
         this.SwatchColor = param1;
         if(currentFrameLabel != this.FILL)
         {
            gotoAndStop(this.FILL);
         }
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = this.SwatchColor;
         this.Fill_mc.transform.colorTransform = _loc2_;
      }
      
      public function IsEmpty() : Boolean
      {
         return currentFrameLabel == this.EMPTY;
      }
      
      public function SetEmpty() : void
      {
         if(!this.IsEmpty())
         {
            gotoAndStop(this.EMPTY);
         }
      }
   }
}
