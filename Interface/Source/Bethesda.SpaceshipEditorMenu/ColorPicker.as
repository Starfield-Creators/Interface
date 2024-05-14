package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ButtonControls.ButtonBar.ConstrainedButtonBar;
   import Shared.Components.ButtonControls.ButtonBar.TabButtonBar;
   import Shared.Components.ButtonControls.ButtonData.TabButtonBarEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   
   public class ColorPicker extends BSDisplayObject
   {
      
      public static const HUE:int = EnumHelper.GetEnum(0);
      
      public static const SATURATION:int = EnumHelper.GetEnum();
      
      public static const BRIGHTNESS:int = EnumHelper.GetEnum();
      
      public static const RECENT:int = EnumHelper.GetEnum();
      
      public static const CONTROL_COUNT:int = EnumHelper.GetEnum();
      
      private static const ShipEditor_OnColorPickerTabChanged:String = "ShipEditor_OnColorPickerTabChanged";
      
      public static const ShipEditor_OnColorPickerControlChanged:String = "ShipEditor_OnColorPickerControlChanged";
       
      
      public var TabBar_mc:TabButtonBar;
      
      public var Hue_mc:ColorHSB;
      
      public var Saturation_mc:ColorHSB;
      
      public var Brightness_mc:ColorHSB;
      
      public var RecentSwatches_mc:ColorRecentSwatches;
      
      public function ColorPicker()
      {
         super();
         GlobalFunc.SetText(this.Hue_mc.labelText,"$HUE");
         this.Hue_mc.controlType = HUE;
         GlobalFunc.SetText(this.Saturation_mc.labelText,"$SATURATION");
         this.Saturation_mc.controlType = SATURATION;
         GlobalFunc.SetText(this.Brightness_mc.labelText,"$BRIGHTNESS");
         this.Brightness_mc.controlType = BRIGHTNESS;
         GlobalFunc.SetText(this.RecentSwatches_mc.LabelText,"$RECENT");
         this.RecentSwatches_mc.controlType = RECENT;
      }
      
      override public function onAddedToStage() : void
      {
         BSUIDataManager.Subscribe("ColorSelectionData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            TabBar_mc.SetSelectedIndex(_loc2_.iSelectedTab);
            SelectControl(_loc2_.iSelectedControl);
            Hue_mc.SetValue(_loc2_.fHue);
            Saturation_mc.SetValue(_loc2_.fSaturation);
            Brightness_mc.SetValue(_loc2_.fBrightness);
            RecentSwatches_mc.SetColor(_loc2_.iRecentIndex);
         });
         BSUIDataManager.Subscribe("ColorSwatchesHue",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            Hue_mc.SetGradientColors(_loc2_.aSwatches);
         });
         BSUIDataManager.Subscribe("ColorSwatchesSaturation",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            Saturation_mc.SetGradientColors(_loc2_.aSwatches);
         });
         BSUIDataManager.Subscribe("ColorSwatchesBrightness",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            Brightness_mc.SetGradientColors(_loc2_.aSwatches);
         });
         BSUIDataManager.Subscribe("ColorSwatchesRecentUI",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data;
            RecentSwatches_mc.SetColorSwatches(_loc2_.aSwatches);
         });
         this.TabBar_mc.SetButtonSpacing(ConstrainedButtonBar.BUTTONS_PIXEL_PERFECT);
         this.TabBar_mc.addEventListener(TabButtonBarEvent.TAB_CHANGED,this.onTabChanged);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.TabBar_mc.ProcessUserEvent(param1,param2);
      }
      
      public function Show(param1:Object) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.aTabs)
         {
            _loc2_.push(new ColorPickerTab(_loc3_.sText,_loc3_.bEnabled));
         }
         this.TabBar_mc.SetTabs("TabTextButton",_loc2_,0,param1.aSelection.iSelectedTab,"PrevColor","NextColor",3);
         this.SelectControl(param1.aSelection.iSelectedControl);
         this.visible = true;
      }
      
      public function SelectControl(param1:int) : *
      {
         this.Hue_mc.SetActive(param1 == HUE);
         this.Saturation_mc.SetActive(param1 == SATURATION);
         this.Brightness_mc.SetActive(param1 == BRIGHTNESS);
         this.RecentSwatches_mc.SetActive(param1 == RECENT);
      }
      
      private function onTabChanged() : *
      {
         var _loc1_:* = this.TabBar_mc.GetSelectedIndex();
         BSUIDataManager.dispatchCustomEvent(ShipEditor_OnColorPickerTabChanged,{"tabIndex":_loc1_});
      }
   }
}
