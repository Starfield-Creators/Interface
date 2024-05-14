package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   
   public class KioskView extends BSDisplayObject
   {
      
      public static const MENU_ITEM_CLICK_EVENT:String = "Terminal_MenuItemClick";
       
      
      public var Title_mc:MovieClip;
      
      public var Subtitle_mc:MovieClip;
      
      public var KioskButtonListContainer_mc:MovieClip;
      
      public var PageContents_mc:MovieClip;
      
      private const DEFAULT_TITLE_TEXT_SIZE:* = 62;
      
      private const DEFAULT_SUBTITLE_TEXT_SIZE:* = 36;
      
      private const SHOW_BODY_TEXT:String = "ShowBodyText";
      
      private const SHOW_LARGE_BODY_TEXT:String = "ShowLargeBodyText";
      
      private const HIDE_BODY_TEXT:String = "HideBodyText";
      
      private const SHORT_ENTRY_CLASS:String = "KioskButtonListShortEntry";
      
      private const LONG_ENTRY_CLASS:String = "KioskButtonListLongEntry";
      
      internal var configParams:BSScrollingConfigParams;
      
      private var KioskData:Object;
      
      private var Pages:Vector.<KioskPage>;
      
      private var CurrentPageIndex:int = 0;
      
      private var Faction:String = "Generic";
      
      public function KioskView()
      {
         this.Pages = new Vector.<KioskPage>();
         super();
         this.configParams = new BSScrollingConfigParams();
         this.configParams.VerticalSpacing = 10;
         this.configParams.EntryClassName = this.SHORT_ENTRY_CLASS;
         this.configParams.WrapAround = false;
         this.ButtonList.Configure(this.configParams);
         this.ButtonList.addEventListener(ScrollingEvent.ITEM_PRESS,this.onKioskButtonListEntryPressed);
         this.ButtonList.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.onKioskListPlayFocusSound);
         addEventListener(KioskPaginationDot.ON_PAGE_DOT_CLICKED,this.onPaginationDotClicked);
         addEventListener("onPageLeft",this.onPageLeft);
         addEventListener("onPageRight",this.onPageRight);
      }
      
      public function set Title(param1:String) : void
      {
         GenesisTerminalShared.SetAndScaleTextfieldText(this.Title_mc.TitleText_mc.text_tf,param1,this.DEFAULT_TITLE_TEXT_SIZE);
      }
      
      public function set Subtitle(param1:String) : void
      {
         GenesisTerminalShared.SetAndScaleTextfieldText(this.Subtitle_mc.text_tf,param1,this.DEFAULT_SUBTITLE_TEXT_SIZE);
      }
      
      public function get PageContent() : MovieClip
      {
         return this.PageContents_mc.PageContent_mc;
      }
      
      public function get PageContentMask() : MovieClip
      {
         return this.PageContents_mc.PageContentMask_mc;
      }
      
      public function get PageIndicator() : KioskPageIndicators
      {
         return this.PageContents_mc.PageIndicator_mc;
      }
      
      public function get ButtonList() : KioskButtonList
      {
         return this.KioskButtonListContainer_mc.KioskButtonList_mc;
      }
      
      public function set FactionName(param1:String) : void
      {
         this.Faction = param1;
         this.ButtonList.FactionName = this.Faction;
      }
      
      public function SetData(param1:Object) : void
      {
         this.KioskData = param1;
         this.Title = param1.sHeader;
         if(param1.bUseKioskLongEntry)
         {
            this.KioskButtonListContainer_mc.gotoAndStop(2);
            this.ButtonList.gotoAndStop(2);
            this.ButtonList.SetEntryClass(this.LONG_ENTRY_CLASS);
         }
         else
         {
            this.KioskButtonListContainer_mc.gotoAndStop(1);
            this.ButtonList.gotoAndStop(1);
            this.ButtonList.SetEntryClass(this.SHORT_ENTRY_CLASS);
         }
         this.ButtonList.FactionName = this.Faction;
         this.ButtonList.InitializeEntries(param1.aIcons);
         this.ClearBodyText();
         if(param1.sBody)
         {
            if(param1.aIcons.length == 0)
            {
               gotoAndStop(this.SHOW_LARGE_BODY_TEXT);
               this.PageContents_mc.gotoAndStop("Long");
            }
            else
            {
               gotoAndStop(this.SHOW_BODY_TEXT);
               this.PageContents_mc.gotoAndStop("Short");
            }
            this.SetBodyText(param1.sBody);
         }
         else
         {
            gotoAndStop(this.HIDE_BODY_TEXT);
         }
         this.PageIndicator.UpdateIndicators(this.Pages.length);
         this.SetPage(0);
         if(this.ButtonList.selectedIndex < 0)
         {
            this.ButtonList.SetInitSelection();
         }
      }
      
      public function ClearBodyText() : void
      {
         this.CurrentPageIndex = 0;
         this.Pages.splice(0,this.Pages.length);
         this.PageContent.removeChildren();
         this.PageIndicator.UpdateIndicators(0);
      }
      
      private function SetBodyText(param1:String) : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:TextField = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:TextLineMetrics = null;
         var _loc2_:Object = GenesisTerminalShared.GetNextToken(param1.split("\r").join(" "));
         var _loc4_:uint = 0;
         while(_loc2_.type != GenesisTerminalShared.DT_INVALID)
         {
            switch(_loc2_.type)
            {
               case GenesisTerminalShared.DT_BODY_TEXT:
                  _loc3_ = new KioskBodyTextEntry(_loc2_,this.PageContentMask.height);
                  _loc3_.name = "BodyText" + _loc4_;
                  break;
               case GenesisTerminalShared.DT_SUBHEADER:
                  _loc3_ = null;
                  break;
               case GenesisTerminalShared.DT_IMAGE:
                  _loc3_ = new KioskImageEntry(_loc2_);
                  _loc3_.name = "Image" + _loc4_;
                  break;
               default:
                  throw new Error("Unsupported data entry!");
            }
            if(_loc3_ != null)
            {
               _loc3_.y = this.Pages.length > 0 ? this.PageContentMask.height + this.Pages[this.Pages.length - 1].Position : 0;
               if(_loc3_ is KioskBodyTextEntry)
               {
                  _loc6_ = (_loc5_ = _loc3_.Text_tf as TextField).bottomScrollV;
                  _loc7_ = Math.ceil(_loc5_.numLines / _loc6_);
                  _loc8_ = 1;
                  _loc9_ = 0;
                  while(_loc9_ < _loc7_)
                  {
                     if(_loc8_ > _loc5_.maxScrollV)
                     {
                        _loc10_ = _loc5_.getLineMetrics(0);
                        this.Pages.push(new KioskPage(_loc3_,_loc5_.maxScrollV,(_loc8_ - _loc5_.maxScrollV) * _loc10_.height));
                     }
                     else
                     {
                        this.Pages.push(new KioskPage(_loc3_,_loc8_));
                     }
                     _loc8_ += _loc6_;
                     _loc9_++;
                  }
               }
               else
               {
                  this.Pages.push(new KioskPage(_loc3_));
               }
               this.PageContent.addChild(_loc3_);
            }
            _loc4_++;
            _loc2_ = GenesisTerminalShared.GetNextToken(_loc2_.resultStr);
         }
      }
      
      private function SetPage(param1:int) : void
      {
         if(this.Pages.length == 0)
         {
            return;
         }
         this.CurrentPageIndex = Math.min(Math.max(param1,0),this.Pages.length - 1);
         var _loc2_:KioskPage = this.Pages[this.CurrentPageIndex];
         this.PageContent.y = this.PageContentMask.y - _loc2_.Position;
         if(_loc2_.LineOffset >= 0)
         {
            _loc2_.Clip.Text_tf.scrollV = _loc2_.LineOffset;
         }
         this.PageIndicator.SetActiveIndicator(this.CurrentPageIndex);
      }
      
      private function onPaginationDotClicked(param1:CustomEvent) : void
      {
         this.SetPage(param1.params.iPageIndex);
         GlobalFunc.PlayMenuSound("UITerminalGeneralScroll");
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2)
         {
            if(param1 == "Accept")
            {
               this.onKioskButtonListEntryPressed();
               _loc3_ = true;
            }
            else if(param1 == "Left")
            {
               this.SetPage(this.CurrentPageIndex - 1);
               GlobalFunc.PlayMenuSound("UITerminalGeneralScroll");
               _loc3_ = true;
            }
            else if(param1 == "Right")
            {
               this.SetPage(this.CurrentPageIndex + 1);
               GlobalFunc.PlayMenuSound("UITerminalGeneralScroll");
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function onKioskButtonListEntryPressed() : *
      {
         var _loc1_:Object = this.ButtonList.selectedEntry;
         if(_loc1_ != null)
         {
            GlobalFunc.PlayMenuSound("Play_UI_Terminal_General_OK");
            dispatchEvent(new CustomEvent(MENU_ITEM_CLICK_EVENT,{
               "iconId":_loc1_.iIconId,
               "parentStackLevel":_loc1_.iParentStackLevel
            },true,true));
         }
      }
      
      private function onKioskListPlayFocusSound() : *
      {
         GlobalFunc.PlayMenuSound("UITerminalGeneralFocus");
      }
      
      private function onPageLeft(param1:Event) : void
      {
         this.SetPage(this.CurrentPageIndex - 1);
         GlobalFunc.PlayMenuSound("UITerminalGeneralScroll");
         param1.stopPropagation();
      }
      
      private function onPageRight(param1:Event) : void
      {
         this.SetPage(this.CurrentPageIndex + 1);
         GlobalFunc.PlayMenuSound("UITerminalGeneralScroll");
         param1.stopPropagation();
      }
   }
}

import flash.display.MovieClip;

class KioskPage
{
    
   
   public var Clip:MovieClip = null;
   
   public var LineOffset:int = -1;
   
   public var MaskOffset:Number = 0;
   
   public function KioskPage(param1:MovieClip, param2:int = -1, param3:Number = 0)
   {
      super();
      this.Clip = param1;
      this.LineOffset = param2;
      this.MaskOffset = param3;
   }
   
   public function get Position() : Number
   {
      return this.Clip.y + this.MaskOffset;
   }
}
