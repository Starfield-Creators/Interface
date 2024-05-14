package
{
   import Shared.AS3.BSColorSlider;
   import Shared.AS3.BSColorSwatches;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class ColorControlEntry extends MovieClip
   {
      
      public static const SLIDER:int = EnumHelper.GetEnum(0);
      
      public static const SWATCHES:int = EnumHelper.GetEnum();
      
      public static const VALUE_CHANGE:String = "ColorControlEntry_ValueChanged";
      
      public static const ENTRY_ROLLED_OVER:String = "ColorControlEntry_RolledOver";
      
      private static const UNSELECTED_FRAME:String = "unselected";
      
      private static const SELECTED_FRAME:String = "selected";
      
      public static const HUE:int = EnumHelper.GetEnum(0);
      
      public static const SATURATION:int = EnumHelper.GetEnum();
      
      public static const BRIGHTNESS:int = EnumHelper.GetEnum();
      
      public static const RECENT_COLORS:int = EnumHelper.GetEnum();
      
      public static const CONTROL_COUNT:int = EnumHelper.GetEnum();
       
      
      public var Label_mc:MovieClip;
      
      public var ColorSlider_mc:BSColorSlider;
      
      public var ColorSwatches_mc:BSColorSwatches;
      
      private const SLIDER_PERCENT:Number = 100;
      
      private var _controlID:int;
      
      private var _controlType:int;
      
      public function ColorControlEntry()
      {
         super();
         this._controlID = -1;
         this._controlType = -1;
         this.ColorSlider_mc.maxValue = this.SLIDER_PERCENT;
         addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
         addEventListener(BSColorSlider.INPUT_CHANGED,this.onValueChange);
         addEventListener(BSColorSwatches.INPUT_CHANGED,this.onValueChange);
      }
      
      public function get controlID() : int
      {
         return this._controlID;
      }
      
      public function set controlID(param1:int) : *
      {
         this._controlID = param1;
         this.controlType = this._controlID == RECENT_COLORS ? SWATCHES : SLIDER;
         this.SetLabelText();
      }
      
      public function get controlType() : int
      {
         return this._controlType;
      }
      
      public function set controlType(param1:int) : *
      {
         this._controlType = param1;
         this.ColorSlider_mc.visible = this.IsSlider();
         this.ColorSwatches_mc.visible = this.IsSwatches();
      }
      
      public function IsSlider() : Boolean
      {
         return this._controlType == SLIDER;
      }
      
      public function IsSwatches() : Boolean
      {
         return this._controlType == SWATCHES;
      }
      
      public function GetActiveInnerClip() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(this.IsSlider())
         {
            _loc1_ = this.ColorSlider_mc.Slider_mc;
         }
         else if(this.IsSwatches())
         {
            _loc1_ = this.ColorSwatches_mc;
         }
         return _loc1_;
      }
      
      public function SetActive(param1:Boolean) : void
      {
         if(param1 && currentFrameLabel != SELECTED_FRAME)
         {
            this.ColorSlider_mc.gotoAndStop(SELECTED_FRAME);
            gotoAndStop(SELECTED_FRAME);
         }
         else if(!param1 && currentFrameLabel != UNSELECTED_FRAME)
         {
            this.ColorSlider_mc.gotoAndStop(UNSELECTED_FRAME);
            gotoAndStop(UNSELECTED_FRAME);
         }
      }
      
      public function SetLabel(param1:String) : void
      {
         GlobalFunc.SetText(this.Label_mc.Text_tf,param1);
      }
      
      public function GetValue() : Number
      {
         var _loc1_:Number = 0;
         if(this.IsSlider())
         {
            _loc1_ = this.ColorSlider_mc.value / this.SLIDER_PERCENT;
         }
         else if(this.IsSwatches())
         {
            _loc1_ = this.ColorSwatches_mc.selectedIndex;
         }
         return _loc1_;
      }
      
      public function SetValue(param1:Number) : void
      {
         if(this.IsSlider())
         {
            this.ColorSlider_mc.value = param1 * this.SLIDER_PERCENT;
         }
         else if(this.IsSwatches())
         {
            this.ColorSwatches_mc.selectedIndex = param1;
         }
      }
      
      public function SetColors(param1:Array) : void
      {
         if(this.IsSlider())
         {
            this.ColorSlider_mc.SetGradientColors(param1);
         }
         else if(this.IsSwatches())
         {
            this.ColorSwatches_mc.SetColorSwatches(param1);
         }
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         this.GetActiveInnerClip().onKeyDownHandler(param1);
      }
      
      private function onValueChange() : void
      {
         dispatchEvent(new CustomEvent(VALUE_CHANGE,{
            "value":this.GetValue(),
            "id":this.controlID,
            "type":this.controlType
         },true,true));
      }
      
      private function onEntryRollover() : void
      {
         dispatchEvent(new CustomEvent(ENTRY_ROLLED_OVER,{"id":this.controlID},true,true));
      }
      
      private function SetLabelText() : void
      {
         var _loc1_:String = "";
         switch(this._controlID)
         {
            case ColorControlEntry.HUE:
               _loc1_ = "$HUE";
               break;
            case ColorControlEntry.SATURATION:
               _loc1_ = "$SATURATION";
               break;
            case ColorControlEntry.BRIGHTNESS:
               _loc1_ = "$BRIGHTNESS";
               break;
            case ColorControlEntry.RECENT_COLORS:
               _loc1_ = "$RECENT";
         }
         GlobalFunc.SetText(this.Label_mc.Text_tf,_loc1_);
      }
   }
}
