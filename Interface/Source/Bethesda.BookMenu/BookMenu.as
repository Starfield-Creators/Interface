package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import scaleform.gfx.Extensions;
   
   public class BookMenu extends IMenu
   {
      
      public static const FOCUS_SOUND:uint = EnumHelper.GetEnum(0);
      
      public static const AUDIO_PLAY_SOUND:uint = EnumHelper.GetEnum();
      
      public static const AUDIO_STOP_SOUND:uint = EnumHelper.GetEnum();
      
      public static const LIST_SCROLL_SOUND:uint = EnumHelper.GetEnum();
      
      private static const SPACE_AFTER_DIVIDER:Number = 10;
      
      private static const EXTRA_BUTTON_BAR_BG_WIDTH:Number = 15;
      
      private static const EXTRA_SPACE_FROM_HEADER:Number = 10;
      
      private static const MAX_HEADER_TEXT:Number = 55;
       
      
      public var EntryHolder_mc:MovieClip;
      
      public var Mask_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var ButtonBarBG_mc:MovieClip;
      
      public var PageIndicator_mc:BookPageIndicators;
      
      public var FullBG_mc:MovieClip;
      
      private var AccumEntryHeight:Number = 0;
      
      private var IsDataPopulated:Boolean = false;
      
      private var NumberOfPages:uint = 0;
      
      private var CurrentPageIndex:int = 0;
      
      private const MOUSE_WHEEL_SCROLL_DIST:Number = 40;
      
      private const KEY_SCROLL_DIST:Number = 40;
      
      private const PAGE_SCROLL_DIST:Number = 160;
      
      private const MAX_SCROLL_INDICATOR_Y:Number = 915;
      
      private var ORIG_ENTRY_Y:Number;
      
      private const ENTER_SFX:String = "UI_Book_Enter";
      
      private const EXIT_SFX:String = "UI_Book_Exit";
      
      private const TURN_FORWARD_SFX:String = "UI_Book_PageTurn_Forward";
      
      private const TURN_BACKWARD_SFX:String = "UI_Book_PageTurn_Backward";
      
      public function BookMenu()
      {
         super();
         BSUIDataManager.Subscribe("BookData",this.onDataUpdate);
         this.ORIG_ENTRY_Y = this.EntryHolder_mc.y;
         this.Mask_mc.mouseEnabled = false;
         this.Mask_mc.mouseChildren = false;
         this.PageIndicator_mc.addEventListener(BookPageIndicators.LEFT_ARROW_PRESSED,this.onLeftArrowPressed);
         this.PageIndicator_mc.addEventListener(BookPageIndicators.RIGHT_ARROW_PRESSED,this.onRightArrowPressed);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,15);
         this.ButtonBar_mc.addEventListener(ButtonBar.BUTTON_BAR_REDRAWN_EVENT,this.OnButtonBarRedrawn);
         GlobalFunc.PlayMenuSound(this.ENTER_SFX);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         this.PageIndicator_mc.visible = false;
      }
      
      override protected function onSetSafeRect() : void
      {
         Extensions.enabled = true;
         this.FullBG_mc.x = Extensions.visibleRect.x;
         this.FullBG_mc.y = Extensions.visibleRect.y;
         this.FullBG_mc.width = Extensions.visibleRect.width;
         this.FullBG_mc.height = Extensions.visibleRect.height;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         this.SetCurrentPage(param1.delta < 0 ? this.CurrentPageIndex + 1 : this.CurrentPageIndex - 1);
      }
      
      private function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(this.NumberOfPages > 1)
         {
            if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.LEFT)
            {
               this.SetCurrentPage(this.CurrentPageIndex - 1);
            }
            else if(param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.RIGHT)
            {
               this.SetCurrentPage(this.CurrentPageIndex + 1);
            }
         }
      }
      
      private function SetCurrentPage(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:int = this.CurrentPageIndex;
         this.CurrentPageIndex = GlobalFunc.Clamp(param1,1,this.NumberOfPages);
         if(!param2)
         {
            if(_loc3_ != this.CurrentPageIndex)
            {
               if(param1 < _loc3_)
               {
                  GlobalFunc.PlayMenuSound(this.TURN_BACKWARD_SFX);
               }
               else
               {
                  GlobalFunc.PlayMenuSound(this.TURN_FORWARD_SFX);
               }
            }
         }
         this.PageIndicator_mc.SetCurrentPage(this.CurrentPageIndex);
         this.EntryHolder_mc.y = this.Mask_mc.y - this.Mask_mc.height * (this.CurrentPageIndex - 1);
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.ButtonBar_mc.ProcessUserEvent(param1,param2);
      }
      
      private function onCancelPressed() : void
      {
         GlobalFunc.PlayMenuSound(this.EXIT_SFX);
         GlobalFunc.CloseMenu("BookMenu");
      }
      
      private function onLeftArrowPressed(param1:Event) : *
      {
         this.SetCurrentPage(this.CurrentPageIndex - 1);
      }
      
      private function onRightArrowPressed(param1:Event) : *
      {
         this.SetCurrentPage(this.CurrentPageIndex + 1);
      }
      
      private function GoToNextPage() : *
      {
         if(this.CurrentPageIndex == this.NumberOfPages)
         {
            this.onCancelPressed();
         }
         else
         {
            this.SetCurrentPage(this.CurrentPageIndex + 1);
         }
      }
      
      private function OnButtonBarRedrawn(param1:Event) : *
      {
         var _loc2_:Number = this.ButtonBarBG_mc.width;
         this.ButtonBarBG_mc.width = this.ButtonBar_mc.TotalWidth + EXTRA_BUTTON_BAR_BG_WIDTH;
         this.ButtonBarBG_mc.x += (_loc2_ - this.ButtonBarBG_mc.width) / 2;
      }
      
      private function CalculateNewClipPosition(param1:Number, param2:Number) : Object
      {
         var _loc3_:Object = {
            "newPosition":this.AccumEntryHeight,
            "newPageHeight":0,
            "addedHeight":param2
         };
         if(param2 >= this.Mask_mc.height)
         {
            _loc3_.newPageHeight = param1 + param2;
            while(_loc3_.newPageHeight >= this.Mask_mc.height)
            {
               _loc3_.newPageHeight -= this.Mask_mc.height;
            }
         }
         else if(param2 + param1 >= this.Mask_mc.height)
         {
            _loc3_.addedHeight += this.Mask_mc.height - param1;
            _loc3_.newPosition += this.Mask_mc.height - param1;
            _loc3_.newPageHeight = param2;
         }
         else
         {
            _loc3_.newPageHeight = param1 + param2;
         }
         return _loc3_;
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:BookMainHeader = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:MovieClip = null;
         var _loc7_:String = null;
         var _loc8_:BookBodyTextEntry = null;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Rectangle = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         if(!this.IsDataPopulated && param1.data.sLanguage.length > 0)
         {
            _loc2_ = new BookMainHeader();
            _loc3_ = 0;
            _loc4_ = 0;
            GlobalFunc.SetText(_loc2_.Title_tf,param1.data.sTitle,true);
            _loc2_.y = this.AccumEntryHeight;
            this.AccumEntryHeight += _loc2_.Title_tf.textHeight + EXTRA_SPACE_FROM_HEADER;
            _loc4_ += this.AccumEntryHeight;
            this.EntryHolder_mc.addChild(_loc2_);
            (_loc6_ = new BookDivider()).name = "Divider" + _loc3_;
            _loc5_ = this.CalculateNewClipPosition(_loc4_,_loc6_.height + SPACE_AFTER_DIVIDER);
            _loc6_.y = _loc5_.newPosition;
            this.AccumEntryHeight += _loc5_.addedHeight;
            _loc4_ = Number(_loc5_.newPageHeight);
            this.EntryHolder_mc.addChild(_loc6_);
            _loc7_ = String(param1.data.sBodyText);
            if(param1.data.sLanguage == "ru" || param1.data.sLanguage == "pl")
            {
               _loc11_ = (_loc10_ = _loc7_).replace("HandwrittenFont","$MAIN_Font");
               while(_loc11_ != _loc10_)
               {
                  _loc11_ = (_loc10_ = _loc11_).replace("HandwrittenFont","$MAIN_Font");
               }
               _loc11_ = (_loc10_ = _loc11_).replace("Handwritten_Institute","$MAIN_Font");
               while(_loc11_ != _loc10_)
               {
                  _loc11_ = (_loc10_ = _loc11_).replace("Handwritten_Institute","$MAIN_Font");
               }
               _loc11_ = (_loc10_ = _loc11_).replace("$$MAIN_Font","$MAIN_Font");
               while(_loc11_ != _loc10_)
               {
                  _loc11_ = (_loc10_ = _loc11_).replace("$$MAIN_Font","$MAIN_Font");
               }
               _loc7_ = _loc11_;
            }
            (_loc8_ = new BookBodyTextEntry()).SetData(_loc7_);
            _loc8_.y = this.AccumEntryHeight;
            this.EntryHolder_mc.addChild(_loc8_);
            while(_loc4_ + _loc8_.height > this.Mask_mc.height)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc8_.NumLines)
               {
                  _loc13_ = _loc8_.GetLineOffset(_loc12_);
                  if((_loc14_ = _loc8_.GetCharBoundaries(_loc13_)) != null && _loc14_.bottom + _loc4_ >= this.Mask_mc.height)
                  {
                     _loc15_ = _loc8_.CurrentText.substring(0,_loc13_);
                     _loc16_ = _loc8_.CurrentText.substring(_loc13_);
                     _loc8_.SetData(_loc15_);
                     this.AccumEntryHeight += this.Mask_mc.height - _loc4_;
                     _loc4_ = 0;
                     _loc3_++;
                     (_loc8_ = new BookBodyTextEntry()).name = "BodyText" + _loc3_;
                     _loc8_.SetData(_loc16_);
                     _loc8_.y = this.AccumEntryHeight;
                     this.EntryHolder_mc.addChild(_loc8_);
                     break;
                  }
                  _loc12_++;
               }
               if(_loc12_ == _loc8_.NumLines)
               {
                  break;
               }
            }
            this.AccumEntryHeight += _loc8_.height;
            _loc4_ += _loc8_.height;
            _loc9_ = this.AccumEntryHeight / this.Mask_mc.height;
            this.NumberOfPages = Math.ceil(_loc9_);
            this.PageIndicator_mc.SetTotalPageNumbers(this.NumberOfPages);
            this.SetCurrentPage(1,true);
            if(this.NumberOfPages > 1)
            {
               ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$FLIPPAGE",[new UserEventData("Left",null),new UserEventData("Right",null),new UserEventData("Up",null),new UserEventData("Down",null)]),this.ButtonBar_mc);
            }
            this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.NextButton_mc,new ButtonBaseData("$NEXT",[new UserEventData("Accept",this.GoToNextPage)]));
            this.ButtonBar_mc.AddButtonWithData(this.ButtonBar_mc.BackButton_mc,new ButtonBaseData("$CLOSE",[new UserEventData("Cancel",this.onCancelPressed)]));
            this.ButtonBar_mc.RefreshButtons();
            this.IsDataPopulated = true;
         }
      }
   }
}
