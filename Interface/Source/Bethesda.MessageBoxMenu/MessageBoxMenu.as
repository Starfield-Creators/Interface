package
{
   import Components.ImageFixture;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.MessageBoxButtonListStyle;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class MessageBoxMenu extends IMenu
   {
      
      private static const ICON_NONE:int = EnumHelper.GetEnum(0);
      
      private static const ICON_WARNING:int = EnumHelper.GetEnum();
      
      private static const ICON_DIMENSIONS:Point = new Point(40,36);
      
      private static const ICONS:Array = ["","OutpostMarker"];
      
      private static const BORDER_HEIGHT:Number = 211.5;
      
      private static const SPACE_BETWEEN_ICON_AND_HEADER:Number = 10;
      
      private static const BODY_HEIGHT_BUFFER:Number = 50;
      
      private static const MINIMUM_BUFFER:Number = 15;
      
      private static const DEFAULT_LINE_SPACING:Number = 3;
      
      private static const CONTROLLER_ICON_LINE_SPACING:Number = 15;
       
      
      public var UpperHeader_mc:MovieClip;
      
      public var LowerFooter_mc:MovieClip;
      
      public var Body_tf:TextField;
      
      public var List_mc:BSScrollingList;
      
      public var BGRect_mc:MovieClip;
      
      public var BGRectBlack_mc:MovieClip;
      
      private var fCenterY:Number;
      
      private var DisableInputCounter:uint;
      
      private var ListYBuffer:Number;
      
      private var MenuMode:Boolean = false;
      
      private var RefreshTimer:Timer = null;
      
      private var StartingBodyYPosition:Number = 0;
      
      private var StartingTitlePosition:Number = 0;
      
      private var ButtonHintCallbacks:Array;
      
      public function MessageBoxMenu()
      {
         this.ButtonHintCallbacks = [this.onButtonOneCallback,this.onButtonTwoCallback,this.onButtonThreeCallback,this.onButtonFourCallback];
         super();
         (this.List_mc as BSScrollingList).dataFieldForText = "sButtonText";
         StyleSheet.apply(this.List_mc,false,MessageBoxButtonListStyle);
         this.StartingTitlePosition = this.Header_tf.x;
         this.StartingBodyYPosition = this.Body_tf.y;
         this.Body_tf.autoSize = TextFieldAutoSize.LEFT;
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
         this.List_mc.addEventListener(BSScrollingList.PLAY_FOCUS_SOUND,this.playFocusSound);
         addEventListener(Event.ENTER_FRAME,this.initDisableInputCounter);
         this.List_mc.disableInput_Inspectable = true;
         this.fCenterY = this.y + this.BGRect_mc.height / 2;
         this.DisableInputCounter = 0;
         this.ListYBuffer = Math.max(MINIMUM_BUFFER,this.BGRect_mc.height - (this.List_mc.y + this.List_mc.height));
         BSUIDataManager.Subscribe("MessageBoxMenuData",this.OnMessageBoxMenuDataChanged);
         this.ButtonBar_mc.visible = false;
         visible = false;
      }
      
      private function get ButtonBar_mc() : ButtonBar
      {
         return this.LowerFooter_mc.ButtonBar_mc;
      }
      
      private function get Header_tf() : TextField
      {
         return this.UpperHeader_mc.Header_tf;
      }
      
      private function get IconImageFixture_mc() : ImageFixture
      {
         return this.UpperHeader_mc.IconImageFixture_mc;
      }
      
      private function OnMessageBoxMenuDataChanged(param1:FromClientDataEvent) : void
      {
         var _loc4_:int = 0;
         if(!param1.data.bInitializedData)
         {
            return;
         }
         var _loc2_:uint = DEFAULT_LINE_SPACING;
         if(uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            if(param1.data.sBodyText.indexOf("$Controller_Buttons") != -1)
            {
               _loc2_ = CONTROLLER_ICON_LINE_SPACING;
            }
         }
         GlobalFunc.SetText(this.Body_tf,param1.data.sBodyText,true,false,0,false,0,null,_loc2_);
         this.buttonArray = param1.data.ButtonsA;
         this.Body_tf.y = this.StartingBodyYPosition;
         this.ButtonBar_mc.ClearButtons();
         var _loc3_:Boolean = false;
         if(this.buttonArray.length > 0)
         {
            if(this.buttonArray[0].sButtonEventName.length > 0)
            {
               _loc3_ = true;
               _loc4_ = 0;
               while(_loc4_ < this.buttonArray.length && _loc4_ < this.ButtonHintCallbacks.length)
               {
                  ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData(this.buttonArray[_loc4_].sButtonText,[new UserEventData(this.buttonArray[_loc4_].sButtonEventName,this.ButtonHintCallbacks[_loc4_])]),this.ButtonBar_mc);
                  _loc4_++;
               }
               this.RefreshButtonBar();
            }
         }
         if(!_loc3_)
         {
            this.List_mc.InvalidateData();
            this.List_mc.selectedIndex = 0;
            stage.focus = this.List_mc;
            ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$Confirm",new UserEventData("Accept",this.ConfirmSelectedIndex)),this.ButtonBar_mc);
            if(param1.data.bAllowBackOut)
            {
               ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$Cancel",new UserEventData("Cancel",this.BackOut)),this.ButtonBar_mc);
            }
            this.RefreshButtonBar();
         }
         else
         {
            this.List_mc.visible = false;
            stage.focus = this;
         }
         if(this.Body_tf.text.length > 0 && this.Body_tf.getCharBoundaries(this.Body_tf.text.length - 1) != null)
         {
            this.List_mc.y = this.Body_tf.y + this.Body_tf.getCharBoundaries(this.Body_tf.text.length - 1).bottom + 20;
         }
         this.BGRect_mc.height = _loc3_ ? this.Body_tf.textHeight + BODY_HEIGHT_BUFFER : this.List_mc.y + this.List_mc.shownItemsHeight + this.ListYBuffer;
         this.menuMode = param1.data.bMenuMode;
         if(this.BGRectBlack_mc != null)
         {
            this.BGRectBlack_mc.height = this.BGRect_mc.height;
            if(this.MenuMode)
            {
               this.BGRectBlack_mc.alpha = 1;
            }
         }
         this.y = this.fCenterY - this.BGRect_mc.height / 2;
         this.LowerFooter_mc.y = this.BGRect_mc.y + this.BGRect_mc.height;
         if(_loc3_)
         {
            this.Body_tf.y = this.BGRect_mc.y + (this.BGRect_mc.height - this.Body_tf.getCharBoundaries(this.Body_tf.text.length - 1).bottom) / 2;
         }
         GlobalFunc.SetText(this.Header_tf,param1.data.sHeaderText,true);
         if(param1.data.sHeaderText.length > 0)
         {
            if(param1.data.bHasImageData)
            {
               this.IconImageFixture_mc.visible = true;
               this.IconImageFixture_mc.LoadImageFixtureFromUIData(param1.data.IconImage,"MessageBoxIconImageBuffer");
               this.IconImageFixture_mc.clipWidth = ICON_DIMENSIONS.x;
               this.IconImageFixture_mc.clipHeight = ICON_DIMENSIONS.y;
               this.Header_tf.x = this.StartingTitlePosition + this.IconImageFixture_mc.width;
            }
            else
            {
               this.IconImageFixture_mc.visible = false;
               this.Header_tf.x = this.StartingTitlePosition;
            }
         }
         else
         {
            this.IconImageFixture_mc.visible = false;
         }
         stage.stageFocusRect = false;
         visible = true;
      }
      
      private function RefreshButtonBar() : *
      {
         this.RefreshTimer = new Timer(30,1);
         this.RefreshTimer.addEventListener(TimerEvent.TIMER,this.handleRefreshTimer);
         this.RefreshTimer.start();
      }
      
      private function handleRefreshTimer(param1:TimerEvent) : *
      {
         this.ButtonBar_mc.RefreshButtons();
         this.ButtonBar_mc.visible = true;
         this.RefreshTimer = null;
         this.List_mc.SetInitSelection();
      }
      
      public function get bodyText() : String
      {
         return this.Body_tf.text;
      }
      
      public function set bodyText(param1:String) : *
      {
         GlobalFunc.SetText(this.Body_tf,param1,true);
      }
      
      public function get buttonArray() : Array
      {
         return this.List_mc.entryList;
      }
      
      public function set buttonArray(param1:Array) : *
      {
         this.List_mc.entryList = param1;
      }
      
      public function get selectedIndex() : uint
      {
         return this.List_mc.selectedIndex;
      }
      
      public function set menuMode(param1:Boolean) : *
      {
         this.MenuMode = param1;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.LowerFooter_mc.visible)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function initDisableInputCounter(param1:Event) : *
      {
         ++this.DisableInputCounter;
         if(this.DisableInputCounter > 3)
         {
            removeEventListener(Event.ENTER_FRAME,this.initDisableInputCounter);
            this.List_mc.disableInput_Inspectable = false;
         }
      }
      
      private function SendButtonPressEvent(param1:uint) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MessageBoxMenu_OnButtonPress",{"iButtonPressed":param1}));
      }
      
      private function onItemPress(param1:Event) : *
      {
         if(this.List_mc.selectedEntry.uiButtonIndex != undefined)
         {
            this.SendButtonPressEvent(this.List_mc.selectedEntry.uiButtonIndex);
         }
      }
      
      private function ConfirmSelectedIndex() : *
      {
         this.onItemPress(null);
      }
      
      private function BackOut() : *
      {
         BSUIDataManager.dispatchEvent(new Event("MessageBoxMenu_OnBackOut"));
      }
      
      private function onButtonOneCallback() : *
      {
         this.SendButtonPressEvent(this.buttonArray[0].uiButtonIndex);
      }
      
      private function onButtonTwoCallback() : *
      {
         this.SendButtonPressEvent(this.buttonArray[1].uiButtonIndex);
      }
      
      private function onButtonThreeCallback() : *
      {
         this.SendButtonPressEvent(this.buttonArray[2].uiButtonIndex);
      }
      
      private function onButtonFourCallback() : *
      {
         this.SendButtonPressEvent(this.buttonArray[3].uiButtonIndex);
      }
      
      private function playFocusSound() : *
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
   }
}
