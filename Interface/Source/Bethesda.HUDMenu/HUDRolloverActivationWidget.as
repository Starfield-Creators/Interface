package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.QuickContainer.QuickContainerListEntry;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.RepeatingButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.Components.ButtonControls.Buttons.ReleaseHoldComboButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import scaleform.gfx.TextFieldEx;
   
   public class HUDRolloverActivationWidget extends BSDisplayObject
   {
      
      private static const ROLLOVER_BUTTON_EVENT:String = "HUDRolloverActivationButtonEvent";
      
      private static const ROLLOVER_ITEM_PRESS_EVENT:String = "HUDRolloverActivationQCItemPressEvent";
      
      private static const BUTTON_TYPE_INVALID:int = EnumHelper.GetEnum(-1);
      
      private static const BUTTON_TYPE_A:int = EnumHelper.GetEnum();
      
      private static const BUTTON_TYPE_X:int = EnumHelper.GetEnum();
      
      private static const BUTTON_TYPE_Y:int = EnumHelper.GetEnum();
      
      private static const BUTTON_TYPE_B:int = EnumHelper.GetEnum();
      
      private static const BUTTON_TYPE_COUNT:int = EnumHelper.GetEnum();
      
      public static const BASIC:int = EnumHelper.GetEnum(0);
      
      public static const SINGLE_ITEM:int = EnumHelper.GetEnum();
      
      public static const SINGLE_ITEM_WITH_CARD:int = EnumHelper.GetEnum();
      
      public static const SCANNER_SINGLE_ITEM_WITH_CARD:int = EnumHelper.GetEnum();
      
      public static const INVENTORY:int = EnumHelper.GetEnum();
      
      public static const SCANNER_INVENTORY:int = EnumHelper.GetEnum();
       
      
      public var Header_mc:HUDRolloverHeader;
      
      public var ButtonBars_mc:MovieClip;
      
      public var ContainerList_mc:BSScrollingContainer;
      
      public var ContainerLineAnchor_mc:MovieClip;
      
      public var ItemValueWeight_mc:MovieClip;
      
      public var RolloverItemCard_mc:HUDRolloverItemCard;
      
      protected var DirectionButton_mc:IButton;
      
      private const BUTTON_COLOR:uint = 16777215;
      
      private const WEIGHT_PRECISION:uint = 1;
      
      private const BUTTON_SPACE:Number = 10;
      
      private const BUTTON_BAR_OFFSET:Number = 10;
      
      private var EmptyUserEvent:UserEventData;
      
      private var HideButton:ReleaseHoldComboButtonData;
      
      private var UpDownButton:RepeatingButtonData;
      
      private var Show:Boolean = false;
      
      private var Mode:uint;
      
      private var Direction:uint;
      
      private var OriginalLineAnchorY:Number = 0;
      
      private var ButtonTypeStrings:Array;
      
      public function HUDRolloverActivationWidget()
      {
         this.EmptyUserEvent = new UserEventData("",null,"",false);
         this.HideButton = new ReleaseHoldComboButtonData("","",[this.EmptyUserEvent,this.EmptyUserEvent],false,false);
         this.UpDownButton = new RepeatingButtonData("",[new UserEventData("Up",this.onPressUp),new UserEventData("Down",this.onPressDown)],RepeatingButtonData.DEFAULT_REPEAT_INTERVAL_MS,true,false,"","");
         this.ButtonTypeStrings = new Array("QCAButton","QCXButton","QCYButton","QCBButton");
         super();
         this.OriginalLineAnchorY = this.ContainerLineAnchor_mc.y;
         this.Mode = BASIC;
         this.Direction = InventoryItemUtils.CM_BOTH;
         this.SetupList();
         this.PopulateButtons();
      }
      
      private function get TopButtonBar_mc() : ButtonBar
      {
         return this.ButtonBars_mc.TopButtonBar_mc;
      }
      
      private function get BottomButtonBar_mc() : ButtonBar
      {
         return this.ButtonBars_mc.BottomButtonBar_mc;
      }
      
      protected function get AButton_mc() : IButton
      {
         return this.TopButtonBar_mc.Button2_mc;
      }
      
      protected function get XButton_mc() : IButton
      {
         return this.TopButtonBar_mc.Button1_mc;
      }
      
      protected function get YButton_mc() : IButton
      {
         return this.BottomButtonBar_mc.Button2_mc;
      }
      
      protected function get BButton_mc() : IButton
      {
         return this.BottomButtonBar_mc.Button1_mc;
      }
      
      private function SetupList() : void
      {
         var _loc1_:BSScrollingConfigParams = null;
         if(!this.ContainerList_mc.initialized)
         {
            _loc1_ = new BSScrollingConfigParams();
            _loc1_.VerticalSpacing = 5;
            _loc1_.EntryClassName = "Shared.AS3.QuickContainer.QuickContainerListEntry";
            _loc1_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
            _loc1_.DisableInput = true;
            this.ContainerList_mc.Configure(_loc1_);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.TopButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.BottomButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function ApplyActivationData(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Point = null;
         this.show = param1.bShowRolloverActivation;
         if(param1.bcancelActiveHolds)
         {
            this.DirectionButton_mc.Enabled = false;
         }
         this.DirectionButton_mc.Enabled = param1.bShowRolloverActivation;
         this.mode = param1.uMode;
         this.direction = param1.uDirection;
         QuickContainerListEntry.IsStealing = param1.bStealing;
         this.BuildButtonInfo(param1.aButtons,param1.bCancelActiveHolds);
         this.Header_mc.ApplyData(param1);
         GlobalFunc.SetText(this.ItemValueWeight_mc.Weight_tf,param1.fSingleItemWeight.toFixed(param1.uWeightPrecision));
         GlobalFunc.SetText(this.ItemValueWeight_mc.Value_tf,param1.iSingleItemValue);
         this.TopButtonBar_mc.visible = this.show;
         this.BottomButtonBar_mc.visible = this.show;
         _loc2_ = this.TopButtonBar_mc.height;
         this.ContainerLineAnchor_mc.y = this.OriginalLineAnchorY;
         this.TopButtonBar_mc.x = 0;
         this.TopButtonBar_mc.y = 0;
         this.BottomButtonBar_mc.x = 0;
         this.BottomButtonBar_mc.y = _loc2_;
         if(this.Mode == SINGLE_ITEM_WITH_CARD || this.Mode == SCANNER_SINGLE_ITEM_WITH_CARD)
         {
            this.RolloverItemCard_mc.ApplyData(param1,_loc2_);
            this.ContainerLineAnchor_mc.y = this.RolloverItemCard_mc.VerticalAnchorPoint;
            _loc3_ = this.RolloverItemCard_mc.CardBottomRight;
            _loc3_.y = _loc3_.y + _loc2_ / 2 + this.BUTTON_BAR_OFFSET;
            _loc3_ = this.ButtonBars_mc.globalToLocal(this.localToGlobal(_loc3_));
            this.TopButtonBar_mc.x = _loc3_.x;
            this.TopButtonBar_mc.y = _loc3_.y;
            this.BottomButtonBar_mc.x = _loc3_.x;
            this.BottomButtonBar_mc.y = _loc3_.y + _loc2_;
         }
         if(stage.focus == this.ContainerList_mc && (param1.bCancelActiveHolds || this.ContainerList_mc.selectedIndex == -1))
         {
            this.ContainerList_mc.selectedIndex = 0;
         }
      }
      
      public function ApplyContainerData(param1:Object) : void
      {
         this.SetupList();
         var _loc2_:UIDataFromClient = BSUIDataManager.GetDataFromClient("HUDRolloverActivationData");
         if(_loc2_.dataReady)
         {
            QuickContainerListEntry.IsStealing = _loc2_.data.bStealing;
         }
         this.ContainerList_mc.InitializeEntries(param1.aItems);
         if(this.ContainerList_mc.selectedIndex == -1)
         {
            this.ContainerList_mc.selectedIndex = 0;
         }
      }
      
      public function get show() : Boolean
      {
         return this.Show;
      }
      
      public function set show(param1:Boolean) : void
      {
         if(param1 != this.Show)
         {
            this.Show = param1;
         }
      }
      
      public function get mode() : uint
      {
         return this.Mode;
      }
      
      public function set mode(param1:uint) : void
      {
         if(param1 != this.Mode)
         {
            this.Mode = param1;
            this.UpdateModeAndDirection();
         }
      }
      
      public function get direction() : uint
      {
         return this.Direction;
      }
      
      public function set direction(param1:uint) : *
      {
         if(this.Direction != param1)
         {
            this.Direction = param1;
            this.UpdateModeAndDirection();
         }
      }
      
      private function UpdateModeAndDirection() : *
      {
         var _loc1_:uint = this.Mode;
         switch(this.Direction)
         {
            case InventoryItemUtils.CM_GIVE_ITEMS:
               _loc1_ = uint(BASIC);
               break;
            case InventoryItemUtils.CM_TAKE_ITEMS:
            case InventoryItemUtils.CM_BOTH:
         }
         switch(_loc1_)
         {
            case BASIC:
               gotoAndStop("Basic");
               stage.focus = null;
               break;
            case SINGLE_ITEM:
               gotoAndStop("SingleItem");
               stage.focus = null;
               break;
            case SINGLE_ITEM_WITH_CARD:
               gotoAndStop("SingleItemWithCard");
               stage.focus = null;
               break;
            case SCANNER_SINGLE_ITEM_WITH_CARD:
               gotoAndStop("ScannerSingleItemWithCard");
               stage.focus = null;
               break;
            case INVENTORY:
               gotoAndStop("Inventory");
               stage.focus = this.ContainerList_mc;
               break;
            case SCANNER_INVENTORY:
               gotoAndStop("ScannerInventory");
               stage.focus = this.ContainerList_mc;
         }
      }
      
      private function get SelectedEntry() : Object
      {
         return this.ContainerList_mc.selectedEntry;
      }
      
      private function PopulateButtons() : void
      {
         this.TopButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,this.BUTTON_SPACE);
         this.TopButtonBar_mc.ButtonBarColor = this.BUTTON_COLOR;
         this.BottomButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,this.BUTTON_SPACE);
         this.BottomButtonBar_mc.ButtonBarColor = this.BUTTON_COLOR;
         this.TopButtonBar_mc.AddButtonWithData(this.AButton_mc,this.HideButton);
         this.TopButtonBar_mc.AddButtonWithData(this.XButton_mc,this.HideButton);
         this.BottomButtonBar_mc.AddButtonWithData(this.YButton_mc,this.HideButton);
         this.BottomButtonBar_mc.AddButtonWithData(this.BButton_mc,this.HideButton);
         this.DirectionButton_mc = ButtonFactory.AddToButtonBar("RepeaterButton",this.UpDownButton,this.BottomButtonBar_mc);
         this.TopButtonBar_mc.RefreshButtons();
         this.BottomButtonBar_mc.RefreshButtons();
      }
      
      private function GetDataForButtonHint(param1:Object) : ReleaseHoldComboButtonData
      {
         var newData:ReleaseHoldComboButtonData;
         var aButtonInfo:Object = param1;
         var userEvent:String = this.GetEventFromButtonType(aButtonInfo.iType);
         var sTextPressAndRelease:String = String(aButtonInfo.sTextPressAndRelease);
         var sTextHold:String = String(aButtonInfo.sTextHold);
         while(sTextPressAndRelease.length > 0 && sTextPressAndRelease.charAt(0) == "\n")
         {
            sTextPressAndRelease = sTextPressAndRelease.substr(1);
         }
         while(sTextHold.length > 0 && sTextHold.charAt(0) == "\n")
         {
            sTextHold = sTextHold.substr(1);
         }
         newData = new ReleaseHoldComboButtonData(sTextPressAndRelease,sTextHold,[new UserEventData(userEvent,function():void
         {
            OnButtonPressAndRelease(aButtonInfo.iType);
         },"",aButtonInfo.bPressAndRelease),new UserEventData("",function():void
         {
            OnButtonHold(aButtonInfo.iType);
         },"",aButtonInfo.bPressAndHold)],aButtonInfo.bEnabled,aButtonInfo.bVisible);
         return newData;
      }
      
      private function BuildButtonInfo(param1:Array, param2:Boolean) : void
      {
         var _loc3_:ReleaseHoldComboButton = null;
         var _loc4_:ReleaseHoldComboButtonData = null;
         var _loc5_:uint = 0;
         while(_loc5_ < BUTTON_TYPE_COUNT)
         {
            if(_loc5_ < param1.length)
            {
               if(param1[_loc5_].iType > BUTTON_TYPE_INVALID)
               {
                  _loc4_ = this.GetDataForButtonHint(param1[_loc5_]);
                  _loc3_ = this.GetButtonClipFromButtonType(param1[_loc5_].iType);
                  if(param2)
                  {
                     _loc3_.CancelHold();
                  }
                  _loc3_.SetButtonData(_loc4_);
               }
            }
            else
            {
               _loc3_ = this.GetButtonClipFromButtonType(_loc5_);
               if(param2)
               {
                  _loc3_.CancelHold();
               }
               _loc3_.SetButtonData(this.HideButton);
            }
            _loc5_++;
         }
         this.TopButtonBar_mc.RefreshButtons();
         this.BottomButtonBar_mc.RefreshButtons();
      }
      
      private function GetButtonClipFromButtonType(param1:int) : ReleaseHoldComboButton
      {
         var _loc2_:IButton = null;
         switch(param1)
         {
            case BUTTON_TYPE_A:
               _loc2_ = this.AButton_mc;
               break;
            case BUTTON_TYPE_X:
               _loc2_ = this.XButton_mc;
               break;
            case BUTTON_TYPE_Y:
               _loc2_ = this.YButton_mc;
               break;
            case BUTTON_TYPE_B:
               _loc2_ = this.BButton_mc;
               break;
            default:
               GlobalFunc.TraceWarning("Button type not found.");
         }
         return _loc2_ as ReleaseHoldComboButton;
      }
      
      private function GetEventFromButtonType(param1:int) : String
      {
         var _loc2_:String = "";
         if(param1 > BUTTON_TYPE_INVALID && param1 < this.ButtonTypeStrings.length)
         {
            _loc2_ = String(this.ButtonTypeStrings[param1]);
         }
         return _loc2_;
      }
      
      private function OnButtonPressAndRelease(param1:int) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(ROLLOVER_BUTTON_EVENT,{
            "uButtonType":param1,
            "bPressAndHold":false
         }));
         if((this.mode == INVENTORY || this.mode == SCANNER_INVENTORY) && param1 == BUTTON_TYPE_A && this.SelectedEntry != null)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(ROLLOVER_ITEM_PRESS_EVENT,{"uHandleID":this.SelectedEntry.uHandleID}));
         }
      }
      
      private function OnButtonHold(param1:int) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(ROLLOVER_BUTTON_EVENT,{
            "uButtonType":param1,
            "bPressAndHold":true
         }));
      }
      
      private function onPressUp() : *
      {
         this.ContainerList_mc.MoveSelection(-1);
      }
      
      private function onPressDown() : *
      {
         this.ContainerList_mc.MoveSelection(1);
      }
   }
}
