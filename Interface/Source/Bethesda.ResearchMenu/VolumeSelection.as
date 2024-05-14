package
{
   import Shared.AS3.BSLabeledSlider;
   import Shared.AS3.BSSlider;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class VolumeSelection extends MovieClip implements IResearchComponent
   {
       
      
      public var Header_mc:MovieClip;
      
      public var Blur_mc:MovieClip;
      
      public var ItemInfo_mc:MovieClip;
      
      public var Quantity_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var ConfirmButton:IButton = null;
      
      private var BackButton:IButton = null;
      
      private var _maxAmount:uint = 0;
      
      private var _materialID:uint = 0;
      
      public function VolumeSelection()
      {
         super();
         this.Slider_mc.minValue = 1;
         this.Slider_mc.maxTextLabel = "$$REQUIRED: ";
         this.Slider_mc.showCurrentOverMax = true;
         this.SetUpButtons();
      }
      
      public function get Slider_mc() : BSLabeledSlider
      {
         return this.Quantity_mc.Slider_mc;
      }
      
      public function get currentAmount() : int
      {
         return this.Slider_mc.value;
      }
      
      public function set maxAmount(param1:uint) : void
      {
         this._maxAmount = param1;
         this.Slider_mc.maxValue = this._maxAmount;
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,ResearchUtils.BUTTON_SPACING);
         this.ButtonBar_mc.ButtonBarColor = ResearchMenu.BUTTON_COLOR;
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.OnConfirm)),this.ButtonBar_mc);
         this.BackButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.OnBack)),this.ButtonBar_mc);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function UpdatePopupData(param1:Object) : void
      {
         removeEventListener(BSSlider.VALUE_CHANGED,this.onValueChange);
         this.maxAmount = param1.maxAmount;
         this.Slider_mc.value = this._maxAmount;
         this._materialID = param1.materialID;
         GlobalFunc.SetText(this.ItemInfo_mc.ItemName_mc.Text_tf,param1.materialName);
         GlobalFunc.SetText(this.ItemInfo_mc.InventoryAmount_mc.Text_tf,"$$Inventory: " + param1.inventoryAmount);
         addEventListener(BSSlider.VALUE_CHANGED,this.onValueChange);
      }
      
      public function Open() : void
      {
         this.gotoAndPlay(ResearchUtils.OPEN_FRAME_LABEL);
      }
      
      public function Close() : void
      {
         this.gotoAndPlay(ResearchUtils.CLOSE_FRAME_LABEL);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = this.Slider_mc.ProcessUserEvent(param1,param2);
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onValueChange() : void
      {
         GlobalFunc.PlayMenuSound(ResearchUtils.COUNTER_SOUND);
      }
      
      private function OnConfirm() : void
      {
         dispatchEvent(new CustomEvent(ResearchUtils.VOLUME_POPUP_ACCEPT,{
            "inputAmount":this.currentAmount,
            "materialFormID":this._materialID
         },true,true));
      }
      
      private function OnBack() : void
      {
         dispatchEvent(new Event(ResearchUtils.CLOSE_POPUP,true,true));
      }
   }
}
