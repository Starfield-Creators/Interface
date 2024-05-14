package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingBar;
   import Shared.AS3.BSScrollingBarPosChangeEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class DocumentView extends BSDisplayObject
   {
      
      public static const SCROLL_BUFFER:Number = 10;
      
      public static const BUTTON_SCROLL_VALUE:Number = 20;
      
      private static const DEFAULT_FILE_NAME_FONT_SIZE:* = 30;
      
      public static const CLOSE_CLICK_EVENT:String = "DocumentView::closeClickEvent";
       
      
      public var HeaderText_mc:MovieClip;
      
      public var PopupCloseBtn_mc:MovieClip;
      
      public var DocumentContent_mc:MovieClip;
      
      public var Attachments_mc:DocumentAttachments;
      
      private var _scrollPosition:Number = 0;
      
      private var StartingScrollPosition:Number = 0;
      
      private var AccumEntryHeight:Number = 0;
      
      private var IsDataPopulated:Boolean = false;
      
      public function DocumentView()
      {
         super();
         this.PopupCloseBtn_mc.addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      private function get ScrollBar() : BSScrollingBar
      {
         return this.DocumentContent_mc.ScrollBar_mc;
      }
      
      private function get EntryHolder() : MovieClip
      {
         return this.DocumentContent_mc.EntryHolder_mc;
      }
      
      private function get ScrollMask() : MovieClip
      {
         return this.DocumentContent_mc.EntryScrollMask_mc;
      }
      
      private function get MaxScrollPosition() : Number
      {
         if(this.EntryHolder.height < this.ScrollMask.height + SCROLL_BUFFER)
         {
            return 0;
         }
         return this.EntryHolder.height - this.ScrollMask.height + SCROLL_BUFFER;
      }
      
      public function set ScrollPosition(param1:Number) : void
      {
         if(param1 < 0)
         {
            this._scrollPosition = 0;
         }
         else if(param1 > this.MaxScrollPosition)
         {
            this._scrollPosition = this.MaxScrollPosition;
         }
         else
         {
            this._scrollPosition = param1;
         }
      }
      
      public function get ScrollPosition() : Number
      {
         return this._scrollPosition;
      }
      
      public function set headerText(param1:String) : void
      {
         name = param1;
         GenesisTerminalShared.SetAndScaleTextfieldText(this.HeaderText_mc.text_tf,param1,DEFAULT_FILE_NAME_FONT_SIZE);
      }
      
      public function set BodyText(param1:String) : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(this.IsDataPopulated)
         {
            return;
         }
         var _loc2_:Object = GenesisTerminalShared.GetNextToken(param1.split("\r").join(" "));
         var _loc4_:uint = 0;
         while(_loc2_.type != GenesisTerminalShared.DT_INVALID)
         {
            switch(_loc2_.type)
            {
               case GenesisTerminalShared.DT_BODY_TEXT:
                  _loc3_ = new DocumentBodyTextEntry(_loc2_);
                  _loc3_.name = "BodyText" + _loc4_;
                  break;
               case GenesisTerminalShared.DT_SUBHEADER:
                  _loc3_ = null;
                  break;
               case GenesisTerminalShared.DT_IMAGE:
                  _loc3_ = new DocumentImageEntry(_loc2_);
                  _loc3_.name = "Image" + _loc4_;
                  break;
               default:
                  throw new Error("Unsupported data entry!");
            }
            if(_loc3_ != null)
            {
               if(this.EntryHolder.numChildren > 0)
               {
                  (_loc5_ = new DocumentDivider()).name = "Divider" + _loc4_;
                  _loc5_.y = this.AccumEntryHeight;
                  this.AccumEntryHeight += _loc5_.height;
                  this.EntryHolder.addChild(_loc5_);
               }
               _loc3_.y = this.AccumEntryHeight;
               this.AccumEntryHeight += _loc3_.height;
               this.EntryHolder.addChild(_loc3_);
            }
            _loc4_++;
            _loc2_ = GenesisTerminalShared.GetNextToken(_loc2_.resultStr);
         }
         this.IsDataPopulated = true;
      }
      
      public function ClearBodyText() : void
      {
         this.IsDataPopulated = false;
         this.AccumEntryHeight = 0;
         this.EntryHolder.removeChildren();
      }
      
      public function SetFocus() : void
      {
         stage.focus = this;
      }
      
      public function get HasFocus() : Boolean
      {
         return stage.focus == this;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.Attachments_mc.ProcessUserEvent(param1,param2);
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.UP)
         {
            this.MoveScrollBar(-BUTTON_SCROLL_VALUE);
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            this.MoveScrollBar(BUTTON_SCROLL_VALUE);
            param1.stopPropagation();
         }
         else if(this.Attachments_mc.HandleInputEvent(param1))
         {
            param1.stopPropagation();
         }
      }
      
      public function Refresh(param1:String, param2:String, param3:Array) : *
      {
         var _loc4_:Number = this.MaxScrollPosition;
         this.ClearBodyText();
         this.headerText = param1;
         this.BodyText = param2;
         if(param3.length > 0)
         {
            this.Attachments_mc.visible = true;
            if(this.Attachments_mc.HasAttachments)
            {
               this.Attachments_mc.InitializeIcons(param3);
            }
            else
            {
               this.AddAttachments(param3);
            }
         }
         else
         {
            this.Attachments_mc.visible = false;
         }
         if(_loc4_ != this.MaxScrollPosition)
         {
            this.ScrollPosition = 0;
            this.MoveScrollBar(0);
         }
      }
      
      private function MoveScrollBar(param1:Number) : *
      {
         this.ScrollPosition += param1;
         this.UpdateScrollPosition(this.ScrollPosition);
         this.EntryHolder.y = this.StartingScrollPosition - this.ScrollPosition;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.StartingScrollPosition = this.ScrollMask.y;
         (this.ScrollBar as MovieClip).bLoaded = true;
         this.ScrollBar.addEventListener(BSScrollingBarPosChangeEvent.NAME,this.onScrollBarMoved);
         this.UpdateScrollPosition(0);
      }
      
      private function onScrollBarMoved(param1:BSScrollingBarPosChangeEvent) : *
      {
         this.ScrollPosition = param1.iNewScrollPosition;
         this.EntryHolder.y = this.StartingScrollPosition - this.ScrollPosition;
      }
      
      private function UpdateScrollPosition(param1:Number) : *
      {
         this.ScrollBar.Update(param1,this.MaxScrollPosition,this.EntryHolder.height);
      }
      
      public function onClick() : void
      {
         dispatchEvent(new Event(CLOSE_CLICK_EVENT,true,true));
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         this.MoveScrollBar(-(BUTTON_SCROLL_VALUE * param1.delta));
      }
      
      public function onClose() : void
      {
         this.EntryHolder.removeChildren();
         this.IsDataPopulated = false;
      }
      
      public function AddAttachments(param1:Array) : void
      {
         if(param1.length > 0)
         {
            this.ScrollBar.height -= this.Attachments_mc.height;
            this.ScrollMask.height -= this.Attachments_mc.height;
            this.Attachments_mc.InitializeIcons(param1);
         }
      }
      
      public function UpdateFaction(param1:String) : void
      {
         gotoAndStop(param1);
         this.Attachments_mc.Faction = param1;
      }
   }
}
