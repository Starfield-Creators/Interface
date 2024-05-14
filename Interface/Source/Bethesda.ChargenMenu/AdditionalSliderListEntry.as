package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSSlider;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class AdditionalSliderListEntry extends BSContainerEntry
   {
       
      
      public var Slider_mc:BSSlider;
      
      public var Text_mc:MovieClip;
      
      private var MOUSE_WHEEL_VALUE_CHANGE:Number = 0.15;
      
      private var SliderID:uint = 0;
      
      private var bCodeBuiltSlider:Boolean = false;
      
      private var bInitialized:Boolean = false;
      
      private var sEventName:String = "";
      
      private var sName:String = "";
      
      private var sGroupName:String = "";
      
      public function AdditionalSliderListEntry()
      {
         super();
         this.Slider_mc.minValue = 0;
         this.Slider_mc.maxValue = 1;
         this.Slider_mc.value = 0;
         this.Slider_mc.mouseWheelValueChange = this.MOUSE_WHEEL_VALUE_CHANGE;
         this.Slider_mc.disableRounding = true;
         EnumHelper.GetEnum(0);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function IsMouseDraggingSlider() : Boolean
      {
         return this.Slider_mc.dragging;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.bInitialized = true;
         this.Slider_mc.value = param1.Value;
         this.Slider_mc.maxValue = 1;
         this.sName = param1.Name;
         this.sGroupName = param1.GroupName;
         this.SliderID = param1.ID;
         GlobalFunc.SetText(this.Text_mc.Text_tf,param1.LabelText.toString(),true);
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         this.Slider_mc.valueJump(this.MOUSE_WHEEL_VALUE_CHANGE * (param1.delta < 0 ? -1 : 1));
      }
      
      public function onValueChanged() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_CHANGE);
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetAdditionalSlider",{
            "GroupName":this.sGroupName,
            "Name":this.sName,
            "SliderValue":this.Slider_mc.value
         }));
         CharGenMenu.characterDirty = true;
      }
      
      public function get sliderValue() : Number
      {
         return this.Slider_mc.value;
      }
      
      public function set sliderValue(param1:Number) : *
      {
         this.Slider_mc.value = param1;
      }
      
      public function get sliderID() : uint
      {
         return this.SliderID;
      }
      
      override public function onRollover() : void
      {
         super.onRollover();
         this.Slider_mc.addEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
      }
      
      override public function onRollout() : void
      {
         super.onRollout();
         this.Slider_mc.removeEventListener(BSSlider.VALUE_CHANGED,this.onValueChanged);
      }
      
      public function onLeft() : *
      {
         var _loc1_:Number = this.Slider_mc.value;
         if(_loc1_ > this.Slider_mc.minValue)
         {
            _loc1_ -= (this.Slider_mc.maxValue - this.Slider_mc.minValue) * FacePage.SLIDER_KEY_MOVEMENT_PERCENT;
            if(_loc1_ < this.Slider_mc.minValue)
            {
               _loc1_ = this.Slider_mc.minValue;
            }
         }
         this.sliderValue = _loc1_;
      }
      
      public function onRight() : *
      {
         var _loc1_:Number = this.Slider_mc.value;
         if(_loc1_ < this.Slider_mc.maxValue)
         {
            _loc1_ += (this.Slider_mc.maxValue - this.Slider_mc.minValue) * FacePage.SLIDER_KEY_MOVEMENT_PERCENT;
            if(_loc1_ > this.Slider_mc.maxValue)
            {
               _loc1_ = this.Slider_mc.maxValue;
            }
         }
         this.sliderValue = _loc1_;
      }
   }
}
