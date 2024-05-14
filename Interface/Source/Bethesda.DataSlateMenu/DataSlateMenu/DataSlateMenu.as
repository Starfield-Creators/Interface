package DataSlateMenu
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class DataSlateMenu extends IMenu
   {
      
      public static const TYPE_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const TYPE_TEXT:uint = EnumHelper.GetEnum();
      
      public static const TYPE_IMAGE:uint = EnumHelper.GetEnum();
      
      public static const TYPE_AUDIO:uint = EnumHelper.GetEnum();
      
      public static const FOCUS_SOUND:uint = EnumHelper.GetEnum(0);
      
      public static const AUDIO_PLAY_SOUND:uint = EnumHelper.GetEnum();
      
      public static const AUDIO_STOP_SOUND:uint = EnumHelper.GetEnum();
      
      public static const LIST_SCROLL_SOUND:uint = EnumHelper.GetEnum();
      
      public static const EVENT_PLAY_SFX:String = "DataSlateMenu_playSFX";
       
      
      public var EntryHolder_mc:MovieClip;
      
      public var Mask_mc:MovieClip;
      
      public var Header_mc:MainHeader;
      
      public var ScrollIndicator_mc:MovieClip;
      
      private var AccumEntryHeight:Number = 0;
      
      private var IsDataPopulated:Boolean = false;
      
      private var MainAudioEntry:AudioEntry = null;
      
      private const MOUSE_WHEEL_SCROLL_DIST:Number = 40;
      
      private const KEY_SCROLL_DIST:Number = 40;
      
      private const PAGE_SCROLL_DIST:Number = 160;
      
      private const MAX_SCROLL_INDICATOR_Y:Number = 915;
      
      private var ORIG_ENTRY_Y:Number;
      
      private var MIN_SCROLL_Y:Number;
      
      private const IMAGE_TAG:String = "<image";
      
      private const HEADER_TAG:String = "<header";
      
      private const DT_BODY_TEXT:uint = EnumHelper.GetEnum(0);
      
      private const DT_SUBHEADER:uint = EnumHelper.GetEnum();
      
      private const DT_IMAGE:uint = EnumHelper.GetEnum();
      
      private const DT_INVALID:uint = EnumHelper.GetEnum();
      
      public function DataSlateMenu()
      {
         super();
         BSUIDataManager.Subscribe("DataSlateData",this.onDataUpdate);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFFEvent);
         this.ORIG_ENTRY_Y = this.EntryHolder_mc.y;
         this.Mask_mc.mouseEnabled = false;
         this.Mask_mc.mouseChildren = false;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         this.ScrollContent(param1.delta < 0 ? -this.MOUSE_WHEEL_SCROLL_DIST : this.MOUSE_WHEEL_SCROLL_DIST);
      }
      
      private function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.UP)
         {
            this.ScrollContent(this.KEY_SCROLL_DIST);
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            this.ScrollContent(-this.KEY_SCROLL_DIST);
         }
         else if(param1.keyCode == Keyboard.PAGE_UP)
         {
            this.ScrollContent(this.PAGE_SCROLL_DIST);
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN)
         {
            this.ScrollContent(-this.PAGE_SCROLL_DIST);
         }
      }
      
      private function ScrollContent(param1:Number) : void
      {
         if(param1 < 0 && this.EntryHolder_mc.y > this.MIN_SCROLL_Y)
         {
            this.EntryHolder_mc.y += param1;
            if(this.EntryHolder_mc.y < this.MIN_SCROLL_Y)
            {
               this.EntryHolder_mc.y = this.MIN_SCROLL_Y;
            }
         }
         else if(param1 > 0 && this.EntryHolder_mc.y < this.ORIG_ENTRY_Y)
         {
            this.EntryHolder_mc.y += param1;
            if(this.EntryHolder_mc.y > this.ORIG_ENTRY_Y)
            {
               this.EntryHolder_mc.y = this.ORIG_ENTRY_Y;
            }
         }
         var _loc2_:Number = (this.EntryHolder_mc.y - this.ORIG_ENTRY_Y) / (this.MIN_SCROLL_Y - this.ORIG_ENTRY_Y);
         this.ScrollIndicator_mc.y = _loc2_ * this.MAX_SCROLL_INDICATOR_Y;
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_PLAY_SFX,{"uType":LIST_SCROLL_SOUND}));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            switch(param1)
            {
               case "Cancel":
                  this.onCancelPressed();
                  _loc3_ = true;
                  break;
               case "Accept":
               case "Activate":
                  this.onAcceptPressed();
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function onFFEvent(param1:FromClientDataEvent) : void
      {
         if(GlobalFunc.HasFireForgetEvent(param1.data,Buttons.EVENT_ACCEPT_CLICKED))
         {
            this.onAcceptPressed();
         }
         if(GlobalFunc.HasFireForgetEvent(param1.data,Buttons.EVENT_CANCEL_CLICKED))
         {
            this.onCancelPressed();
         }
      }
      
      private function onAcceptPressed() : void
      {
         if(this.MainAudioEntry != null)
         {
            this.MainAudioEntry.ToggleAudio();
         }
      }
      
      private function onCancelPressed() : void
      {
         GlobalFunc.CloseMenu("DataSlateMenu");
         GlobalFunc.CloseMenu("DataSlateButtons");
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         if(!this.IsDataPopulated && param1.data.uType != TYPE_NONE)
         {
            GlobalFunc.SetText(this.Header_mc.Title_tf,param1.data.sTitle);
            GlobalFunc.SetText(this.Header_mc.LeftHeaderText_tf,param1.data.sLeftHeaderText.replace("\r"," "));
            GlobalFunc.SetText(this.Header_mc.RightHeaderText_tf,param1.data.sRightHeaderText.replace("\r"," "));
            if(param1.data.uType == TYPE_AUDIO)
            {
               this.MainAudioEntry = new AudioEntry();
               this.MainAudioEntry.name = "MainAudioEntry";
               this.MainAudioEntry.y = this.AccumEntryHeight;
               this.AccumEntryHeight += this.MainAudioEntry.height;
               this.EntryHolder_mc.addChild(this.MainAudioEntry);
            }
            _loc2_ = false;
            _loc3_ = this.GetNextToken(param1.data.sBodyText.split("\r").join(" "));
            _loc5_ = 0;
            while(_loc3_.type != this.DT_INVALID)
            {
               switch(_loc3_.type)
               {
                  case this.DT_BODY_TEXT:
                     (_loc4_ = new BodyTextEntry()).name = "BodyText" + _loc5_;
                     break;
                  case this.DT_SUBHEADER:
                     (_loc4_ = new SubheaderEntry()).name = "Subheader" + _loc5_;
                     break;
                  case this.DT_IMAGE:
                     (_loc4_ = new ImageEntry()).name = "Image" + _loc5_;
                     _loc2_ = true;
                     break;
                  default:
                     throw new Error("Unsupported data entry!");
               }
               (_loc4_ as IDataSlateEntry).SetData(_loc3_);
               if(_loc4_ != null)
               {
                  if(this.EntryHolder_mc.numChildren > 0)
                  {
                     (_loc6_ = new Divider()).name = "Divider" + _loc5_;
                     _loc6_.y = this.AccumEntryHeight;
                     this.AccumEntryHeight += _loc6_.height;
                     this.EntryHolder_mc.addChild(_loc6_);
                  }
                  _loc4_.y = this.AccumEntryHeight;
                  this.AccumEntryHeight += _loc4_.height;
                  this.EntryHolder_mc.addChild(_loc4_);
               }
               _loc5_++;
               _loc3_ = this.GetNextToken(_loc3_.resultStr);
            }
            switch(param1.data.uType)
            {
               case TYPE_IMAGE:
                  GlobalFunc.SetText(this.Header_mc.Type_tf,"$DataSlate_ImageLog");
                  break;
               case TYPE_AUDIO:
                  GlobalFunc.SetText(this.Header_mc.Type_tf,"$DataSlate_AudioLog");
                  break;
               default:
                  GlobalFunc.SetText(this.Header_mc.Type_tf,"$DataSlate_TextLog");
            }
            this.MIN_SCROLL_Y = this.ORIG_ENTRY_Y - this.AccumEntryHeight + this.Mask_mc.height;
            this.IsDataPopulated = true;
         }
      }
      
      private function GetSubTags(param1:String) : Vector.<String>
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc3_:int = param1.indexOf(">");
         var _loc4_:int;
         if((_loc4_ = param1.indexOf("<")) != -1)
         {
            _loc4_ = param1.indexOf("<",_loc4_ + 1);
            if(_loc3_ == -1)
            {
               throw new Error("Malformed tag -- No closing bracket! " + param1.substr(0,64));
            }
            if(_loc4_ != -1 && _loc4_ < _loc3_)
            {
               throw new Error("Malformed tag -- No closing bracket! " + param1.substr(0,64));
            }
            _loc6_ = (_loc5_ = param1.indexOf("\'")) != -1 ? param1.indexOf("\'",_loc5_ + 1) : -1;
            while(_loc5_ != -1 && _loc6_ != -1 && _loc5_ < _loc3_)
            {
               _loc2_.push(param1.slice(_loc5_ + 1,_loc6_));
               _loc6_ = (_loc5_ = param1.indexOf("\'",_loc6_ + 1)) != -1 ? param1.indexOf("\'",_loc5_ + 1) : -1;
            }
            if(_loc5_ == -1 && _loc6_ != -1 || _loc5_ != -1 && _loc6_ == -1)
            {
               throw new Error("Malformed tag -- Quote mismatch! " + param1.substr(0,64));
            }
            if(_loc2_.length == 0)
            {
               throw new Error("Malformed tag -- No subtags! " + param1.substr(0,64));
            }
            return _loc2_;
         }
         throw new Error("Malformed tag -- No open bracket! " + param1.substr(0,64));
      }
      
      private function GetNextToken(param1:String) : Object
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc2_:Object = new Object();
         if(param1 == null || param1 == "")
         {
            _loc2_.type = this.DT_INVALID;
         }
         else if(param1.indexOf(this.IMAGE_TAG) == 0)
         {
            _loc3_ = true;
            _loc2_.type = this.DT_IMAGE;
            if((_loc4_ = this.GetSubTags(param1)).length != 2)
            {
               throw new Error("Malformed tag -- Wrong number of subtags! Expected: 2 " + param1.substr(0,64));
            }
            _loc2_.arg0 = _loc4_[0];
            _loc2_.arg1 = _loc4_[1];
            _loc5_ = param1.indexOf(">");
            _loc2_.resultStr = param1.slice(_loc5_ + 1);
         }
         else if(param1.indexOf(this.HEADER_TAG) == 0)
         {
            _loc2_.type = this.DT_SUBHEADER;
            if((_loc6_ = this.GetSubTags(param1)).length != 2)
            {
               throw new Error("Malformed tag -- Wrong number of subtags! Expected: 2 " + param1.substr(0,64));
            }
            _loc2_.arg0 = _loc6_[0];
            _loc2_.arg1 = _loc6_[1];
            _loc7_ = param1.indexOf(">");
            _loc2_.resultStr = param1.slice(_loc7_ + 1);
         }
         else
         {
            _loc2_.type = this.DT_BODY_TEXT;
            if((_loc8_ = this.GetNextValidTagIndex(param1)) == -1)
            {
               _loc2_.arg0 = param1.slice();
               _loc2_.resultStr = "";
            }
            else
            {
               _loc2_.arg0 = param1.slice(0,_loc8_);
               _loc2_.resultStr = param1.slice(_loc8_);
            }
         }
         return _loc2_;
      }
      
      private function GetNextValidTagIndex(param1:String) : int
      {
         var _loc2_:int = param1.indexOf(this.IMAGE_TAG);
         if(_loc2_ == -1)
         {
            _loc2_ = param1.indexOf(this.HEADER_TAG);
         }
         return _loc2_;
      }
   }
}
