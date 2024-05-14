package Shared.AS3
{
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class BSColorSwatch extends MovieClip
   {
      
      public static const COLOR_SWATCH_CLICKED:String = "ColorSwatch_Clicked";
       
      
      public var Empty_mc:MovieClip;
      
      public var Fill_mc:MovieClip;
      
      private var _swatchID:uint;
      
      private var _swatchColor:uint;
      
      private const EMPTY:* = "Empty";
      
      private const FILL:* = "Fill";
      
      public function BSColorSwatch()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function get swatchColor() : uint
      {
         return this._swatchColor;
      }
      
      public function get swatchID() : uint
      {
         return this._swatchID;
      }
      
      public function set swatchID(param1:uint) : void
      {
         this._swatchID = param1;
      }
      
      public function IsEmpty() : Boolean
      {
         return currentFrameLabel == this.EMPTY;
      }
      
      protected function onAddedToStage(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
      }
      
      protected function OnMouseClick(param1:MouseEvent) : void
      {
         if(!this.IsEmpty())
         {
            dispatchEvent(new CustomEvent(COLOR_SWATCH_CLICKED,{
               "id":this.swatchID,
               "color":this.swatchColor
            }));
         }
      }
      
      public function SetColor(param1:uint) : void
      {
         this._swatchColor = param1;
         if(currentFrameLabel != this.FILL)
         {
            gotoAndStop(this.FILL);
         }
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = this._swatchColor;
         this.Fill_mc.transform.colorTransform = _loc2_;
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
