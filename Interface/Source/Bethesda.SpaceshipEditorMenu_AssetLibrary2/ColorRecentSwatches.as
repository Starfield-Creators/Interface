package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class ColorRecentSwatches extends BSDisplayObject
   {
      
      private static const NORMAL:* = "Normal";
      
      private static const ACTIVE:* = "Active";
      
      private static const EMPTY:* = "Empty";
      
      private static const FILL:* = "Fill";
      
      public static const NUM_SWATCHES:uint = 12;
       
      
      public var Label_mc:MovieClip;
      
      public var Pointer_mc:MovieClip;
      
      public var Swatch1_mc:ColorSwatch;
      
      public var Swatch2_mc:ColorSwatch;
      
      public var Swatch3_mc:ColorSwatch;
      
      public var Swatch4_mc:ColorSwatch;
      
      public var Swatch5_mc:ColorSwatch;
      
      public var Swatch6_mc:ColorSwatch;
      
      public var Swatch7_mc:ColorSwatch;
      
      public var Swatch8_mc:ColorSwatch;
      
      public var Swatch9_mc:ColorSwatch;
      
      public var Swatch10_mc:ColorSwatch;
      
      public var Swatch11_mc:ColorSwatch;
      
      public var Swatch12_mc:ColorSwatch;
      
      private var ColorIndex:int = 0;
      
      private var SwatchClips:Array;
      
      private var Type:uint;
      
      public function ColorRecentSwatches()
      {
         var _loc2_:* = null;
         var _loc3_:ColorSwatch = null;
         this.SwatchClips = new Array();
         this.Type = ColorPicker.CONTROL_COUNT;
         super();
         var _loc1_:* = 0;
         while(_loc1_ < NUM_SWATCHES)
         {
            _loc2_ = "Swatch" + (_loc1_ + 1) + "_mc";
            _loc3_ = this[_loc2_];
            _loc3_.swatchID = _loc1_;
            this.SwatchClips.push(_loc3_);
            _loc1_++;
         }
      }
      
      public function get LabelText() : TextField
      {
         return this.Label_mc.text_tf;
      }
      
      public function get controlType() : uint
      {
         return this.Type;
      }
      
      public function set controlType(param1:uint) : *
      {
         this.Type = param1;
      }
      
      override public function onAddedToStage() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollover);
      }
      
      public function SetActive(param1:Boolean) : *
      {
         if(param1)
         {
            stage.focus = this;
         }
         gotoAndStop(param1 ? ACTIVE : NORMAL);
      }
      
      public function SetColor(param1:int) : *
      {
         var _loc2_:* = null;
         var _loc3_:MovieClip = null;
         this.ColorIndex = param1;
         if(param1 >= 0)
         {
            _loc2_ = "Swatch" + (param1 + 1) + "_mc";
            _loc3_ = this[_loc2_];
            this.Pointer_mc.x = _loc3_.x;
            this.Pointer_mc.visible = true;
         }
         else
         {
            this.Pointer_mc.visible = false;
         }
      }
      
      public function SetColorSwatches(param1:Array) : *
      {
         var _loc3_:MovieClip = null;
         var _loc4_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < NUM_SWATCHES)
         {
            _loc3_ = this.SwatchClips[_loc2_];
            _loc4_ = new ColorTransform();
            if(_loc2_ < param1.length)
            {
               (_loc3_ as ColorSwatch).SetColor(param1[_loc2_]);
            }
            else
            {
               (_loc3_ as ColorSwatch).SetEmpty();
            }
            _loc2_++;
         }
      }
      
      private function onMouseRollover() : void
      {
         BSUIDataManager.dispatchCustomEvent(ColorPicker.ShipEditor_OnColorPickerControlChanged,{"control":this.Type});
      }
   }
}
