package
{
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ConfirmationPopup extends MovieClip
   {
       
      
      public var Header_mc:MovieClip;
      
      public var Details_mc:MovieClip;
      
      public var ConfirmMessage_mc:MovieClip;
      
      public var ConfirmList_mc:ConfirmList;
      
      public var Quantity_mc:QuantitySection;
      
      public var ButtonBar_mc:ButtonBar;
      
      private var ConfirmButton:IButton = null;
      
      private var CancelButton:IButton = null;
      
      private var _active:Boolean = false;
      
      private var _buttonBarColor:uint = 0;
      
      public function ConfirmationPopup()
      {
         super();
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = CraftingUtils.LIST_SPACING;
         _loc1_.EntryClassName = "ComponentsList_EntryWide";
         this.ConfirmList_mc.Configure(_loc1_);
         this.ConfirmList_mc.disableSelection = true;
         if(this.Quantity_mc != null)
         {
            this.Quantity_mc.minQuantity = 1;
            addEventListener(QuantitySection.QUANTITY_CHANGED,this.onQuantityChange);
         }
         this.SetUpButtons();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         if(this._active != param1)
         {
            this._active = param1;
            if(this.active)
            {
               gotoAndPlay("rollOn");
               if(this.Quantity_mc != null)
               {
                  this.Quantity_mc.quantity = 1;
                  stage.focus = this.Quantity_mc.Slider_mc;
               }
            }
            else
            {
               gotoAndPlay("rollOff");
            }
         }
      }
      
      public function get buttonBarColor() : uint
      {
         return this._buttonBarColor;
      }
      
      public function set buttonBarColor(param1:uint) : void
      {
         if(this._buttonBarColor != param1)
         {
            this._buttonBarColor = param1;
            this.ButtonBar_mc.ButtonBarColor = this.buttonBarColor;
            this.ButtonBar_mc.RefreshButtons();
         }
      }
      
      public function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,CraftingUtils.BUTTON_SPACING);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.ConfirmBuild)),this.ButtonBar_mc);
         this.CancelButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.CancelBuild),true,true,"UIMenuGeneralCancel"),this.ButtonBar_mc);
         this.ButtonBar_mc.ButtonBarColor = this.buttonBarColor;
         this.ButtonBar_mc.RefreshButtons();
      }
      
      public function PopulateList(param1:Array, param2:uint = 1) : void
      {
         this.ConfirmList_mc.InitializeEntries(param1);
         if(this.Quantity_mc != null)
         {
            this.Quantity_mc.PopulateSection(param2);
         }
      }
      
      public function PopulateTextInfo(param1:String, param2:String, param3:String) : void
      {
         GlobalFunc.SetText(this.Header_mc.Text_tf,param1);
         GlobalFunc.SetText(this.Details_mc.Text_tf,param2);
         GlobalFunc.SetText(this.ConfirmMessage_mc.Text_tf,param3);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.Quantity_mc != null)
         {
            _loc3_ = this.Quantity_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function onQuantityChange(param1:Event) : void
      {
         if(this.Quantity_mc != null)
         {
            this.ConfirmList_mc.multipler = this.Quantity_mc.quantity;
         }
      }
      
      private function ConfirmBuild() : void
      {
         var _loc1_:uint = this.Quantity_mc != null ? uint(this.Quantity_mc.quantity) : 1;
         dispatchEvent(new CustomEvent(CraftingUtils.CONFIRM_POPUP_ACCEPT,{"itemQuantity":_loc1_},true,true));
      }
      
      private function CancelBuild() : void
      {
         dispatchEvent(new Event(CraftingUtils.CONFIRM_POPUP_CANCEL,true,true));
      }
   }
}
