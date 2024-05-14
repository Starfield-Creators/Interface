package
{
   import Components.BSButton;
   import Components.PlanetInfoCard.PlanetInfoCard;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.StarMap_QSSListStyle;
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import Shared.ViewTypes;
   import aze.motion.easing.Quadratic;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import scaleform.gfx.Extensions;
   
   public class GalaxyStarMapMenu extends IMenu
   {
      
      public static const StarMapMenu_OnCancel:String = "StarMapMenu_OnCancel";
      
      public static const StarMapMenu_OnExitStarMap:String = "StarMapMenu_OnExitStarMap";
      
      public static const StarMapMenu_ReadyToClose:String = "StarMapMenu_ReadyToClose";
      
      public static const StarMapMenu_OnClearRoute:String = "StarMapMenu_OnClearRoute";
      
      public static const StarMapMenu_ShowRealCursor:String = "StarMapMenu_ShowRealCursor";
      
      public static const StarMapMenu_OnGalaxyViewInitialized:String = "StarMapMenu_OnGalaxyViewInitialized";
      
      public static const StarMapMenu_OnInspect:String = "StarMapMenu_OnInspect";
      
      private static const CURSOR_SIZE_SMALL:Number = 30;
      
      private static const CURSOR_SIZE_LARGE:Number = 50;
      
      private static const REMOVE_BUTTON_CAN_HOLD:Boolean = true;
      
      private static const REMOVE_BUTTON_RETURN_TO_IDLE:Boolean = true;
      
      private static const REMOVE_BUTTON_JUSTIFY_HOLD_METER:Boolean = true;
      
      private static const REMOVE_BUTTON_MAX_PRESS_TIME_MS:Number = 200;
      
      internal static const ARBITRARY_INSPECT_FRAME_SIZE:Number = 100;
      
      private static const FILTER_PADDING:int = 20;
       
      
      public var __setPropDict:Dictionary;
      
      public var __lastFrameProp:int = -1;
      
      public var SystemHeader_mc:MovieClip;
      
      public var SystemHeaderBackground_mc:MovieClip;
      
      public var ButtonHintBar_mc:StarMapButtonHintBar;
      
      public var JumpData_mc:JumpDataPanel;
      
      public var MapGrid_mc:MovieClip;
      
      public var StaticSystemView_mc:Galaxy2DMap;
      
      public var FilterMenu_mc:FilterList;
      
      public var Markers_mc:GalaxyStarMapMarkers;
      
      public var GalaxyMapName_mc:MovieClip;
      
      public var MarkerSelection_mc:QuickSystemSelect;
      
      public var SystemInfo_mc:SystemInfoPanel;
      
      public var SystemInfoMini_mc:SystemInfoPanelMini;
      
      public var SystemPlanetInfoCard_mc:PlanetInfoCard;
      
      public var BodyInspect_mc:InspectMenu;
      
      public var UniversalBackButton_mc:BSButton;
      
      public var FilterCurtain_mc:MovieClip;
      
      public var InputEater_mc:InputEater;
      
      public var SurfaceMap_mc:MovieClip;
      
      public var FactionBounty_mc:FactionBounty;
      
      public var OutpostSelect_mc:OutpostSelectPopup;
      
      public var SystemNameHeader_mc:SystemNameHeader;
      
      public var Gradient_mc:MovieClip;
      
      public var MenuHider_mc:MovieClip;
      
      public var ShowQuickSelect:Boolean = false;
      
      private var StarMapInfoDataPayload:Object;
      
      private var CurrentRouteData:Object;
      
      private var BodyPOIData:Object;
      
      private var CurrentSystemInfo:Object;
      
      private var GridMarkersArray:Array;
      
      private const SYSTEMS_VIEW_STAGGER_DELAY_MULT:* = 0.01;
      
      private const BODIES_VIEW_STAGGER_DELAY_MULT:* = 0.05;
      
      private const SYSTEMS_VIEW_STAGGER_DELAY_BASE:* = 0;
      
      private const BODIES_VIEW_STAGGER_DELAY_BASE:* = 0;
      
      public var FakeCursor_mc:MovieClip;
      
      public var CursorHovering:Boolean = false;
      
      public var CursorLocked:Boolean = false;
      
      public var CursorFocused:Boolean = false;
      
      public var CursorLastX:Number = 0;
      
      public var CursorLastY:Number = 0;
      
      public var CursorSizeCustom:Number;
      
      public var CursorFadeIn:Boolean = false;
      
      public var FakeCursorVisible:Boolean = false;
      
      public var FakeCursorLastX:Number = 0;
      
      public var FakeCursorLastY:Number = 0;
      
      public var SelectedMarkerIndex:uint = 0;
      
      private var CurrentView:int = -1;
      
      private var BodyWasViewed:Boolean = false;
      
      private var bRemoveAllJumps:Boolean = false;
      
      private var TargetMarker:uint = 0;
      
      private var SystemInfoCardBaseY:int = 0;
      
      private var isSystemBodyInfoOpen:Boolean = false;
      
      private var ShowSystemScanButon:Boolean = false;
      
      private var MouseOverQSS:Boolean = false;
      
      private var QSSInitialized:Boolean = false;
      
      private var QSSBountyOffset:Number = 0;
      
      private var MouseOverFilter:Boolean = false;
      
      public function GalaxyStarMapMenu()
      {
         this.__setPropDict = new Dictionary(true);
         super();
         StyleSheet.apply(this.MarkerSelection_mc,false,StarMap_QSSListStyle);
         this.FakeCursor_mc.visible = false;
         this.FilterMenu_mc.visible = false;
         this.FilterCurtain_mc.visible = false;
         this.SurfaceMap_mc.visible = false;
         this.GridMarkersArray = [this.MapGrid_mc.TopLeft_mc,this.MapGrid_mc.Top1_mc,this.MapGrid_mc.Top2_mc,this.MapGrid_mc.Top3_mc,this.MapGrid_mc.TopRight_mc,this.MapGrid_mc.Row1Left_mc,this.MapGrid_mc.Row1Middle1_mc,this.MapGrid_mc.Row1Middle2_mc,this.MapGrid_mc.Row1Middle3_mc,this.MapGrid_mc.Row1Right_mc,this.MapGrid_mc.Row2Left_mc,this.MapGrid_mc.Row2Middle1_mc,this.MapGrid_mc.Row2Middle2_mc,this.MapGrid_mc.Row2Middle3_mc,this.MapGrid_mc.Row2Right_mc,this.MapGrid_mc.BottomLeft_mc,this.MapGrid_mc.Bottom1_mc,this.MapGrid_mc.Bottom2_mc,this.MapGrid_mc.Bottom3_mc,this.MapGrid_mc.BottomRight_mc];
         this.SystemInfoCardBaseY = this.SystemInfo_mc.y;
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
      }
      
      private function get IsGamepadInputActive() : Boolean
      {
         return IsPlatformValueValid() && uiController != PlatformUtils.PLATFORM_PC_KB_MOUSE;
      }
      
      private function get IsLargeTextMode() : Boolean
      {
         return false;
      }
      
      override protected function onSetSafeRect() : void
      {
         var _loc1_:Rectangle = Extensions.visibleRect;
         var _loc2_:Point = this.Gradient_mc.parent.globalToLocal(new Point(_loc1_.x,_loc1_.y));
         this.Gradient_mc.width = _loc1_.width;
         this.Gradient_mc.height = _loc1_.height;
         this.Gradient_mc.x = _loc2_.x;
         this.Gradient_mc.y = _loc2_.y;
         this.MenuHider_mc.width = _loc1_.width;
         this.MenuHider_mc.height = _loc1_.height;
         this.MenuHider_mc.x = _loc2_.x;
         this.MenuHider_mc.y = _loc2_.y;
         this.SurfaceMap_mc.OnSetSafeRect(_loc1_);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("StarMapMenuData",function(param1:FromClientDataEvent):*
         {
            StarMapInfoDataPayload = param1.data;
            UpdateView(StarMapInfoDataPayload.iCurrentMenuView);
            if(param1.data.bFadeToClose)
            {
               HideStarmapView(StarMapMenu_ReadyToClose);
            }
         });
         BSUIDataManager.Subscribe("StarMapMenuQuickSelectData",function(param1:FromClientDataEvent):*
         {
            var _loc3_:* = undefined;
            var _loc2_:* = param1.data;
            if(ShowQuickSelect != _loc2_.bShowMenu)
            {
               ShowQuickSelect = _loc2_.bShowMenu;
               if(ShowQuickSelect)
               {
                  _loc3_ = _loc2_.bOpenForPlot;
                  ShowQuickSelectMenu(_loc3_);
               }
               else
               {
                  HideQuickSelectMenu(true);
               }
            }
         });
         BSUIDataManager.Subscribe("StarMapMenuSystemScanData",function(param1:FromClientDataEvent):*
         {
            SystemPlanetInfoCard_mc.UpdateScanButton(param1.data.bShowSurveyor,param1.data.bNewScanAvailable);
            if(param1.data.bShowSurveyor)
            {
               SystemPlanetInfoCard_mc.SetSystemScanMode();
               ShowSystemScanButon = true;
            }
            else
            {
               SystemPlanetInfoCard_mc.SetNoScanMode();
               ShowSystemScanButon = false;
            }
         });
         BSUIDataManager.Subscribe("StarMapMenuFocusBodyData",function(param1:FromClientDataEvent):*
         {
            BodyInspect_mc.SetInspectedBodyID(param1.data.uBodyID);
         });
         BSUIDataManager.Subscribe("StarMapMenuSystemBodyInfoData",function(param1:FromClientDataEvent):*
         {
            SystemInfo_mc.SetSystemBodyInfo(param1.data);
            SystemInfoMini_mc.SetSystemBodyInfo(param1.data);
         });
         BSUIDataManager.Subscribe("StarMapMenuSystemNameHeaderData",function(param1:FromClientDataEvent):*
         {
            SystemNameHeader_mc.SetSystemInfo(param1.data);
         });
         BSUIDataManager.Subscribe("DataMenuData",function(param1:FromClientDataEvent):*
         {
            CurrentSystemInfo = param1.data.CurrentSystemBodyInfo;
         });
         BSUIDataManager.Subscribe("StarMapMenuMarkersData",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data.bHasHighlightedMarker;
            var _loc3_:uint = !!_loc2_ ? GetBodyHighlight(param1.data.aMarkersData) : 0;
            SystemInfo_mc.SystemViewHolder_mc.SetBodyHighlight(_loc3_);
            SystemInfoMini_mc.SystemViewHolder_mc.SetBodyHighlight(_loc3_);
         });
         BSUIDataManager.Subscribe("OutpostSelectData",this.onOutpostSelectDataReceived);
         BSUIDataManager.Subscribe("StarmapSystemBodyInfoProvider",function(param1:FromClientDataEvent):*
         {
            var _loc2_:* = param1.data.uBodyID != 0 && param1.data.iType != BSGalaxyTypes.BT_SATELLITE;
            if(_loc2_ && !isSystemBodyInfoOpen)
            {
               SystemPlanetInfoCard_mc.Open();
            }
            else if(!_loc2_ && isSystemBodyInfoOpen)
            {
               SystemPlanetInfoCard_mc.Close();
            }
            SystemPlanetInfoCard_mc.SetBodyInfo(param1.data);
            isSystemBodyInfoOpen = _loc2_;
         });
         this.UniversalBackButton_mc.addEventListener(BSButton.BUTTON_CLICKED_EVENT,this.OnCancelEvent);
         this.MarkerSelection_mc.addEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
         this.MarkerSelection_mc.addEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
         this.MarkerSelection_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.OnQuickSelectChange);
         this.ButtonHintBar_mc.ClearRouteButtonCallback = this.OnClearRouteEvent;
         this.ButtonHintBar_mc.ExitStarMapCallback = this.OnExitStarMapEvent;
         this.HideQuickSelectMenu();
         this.JumpData_mc.addEventListener(JumpDataPanel.JumpPanelShowEvent_MAIN,this.onShowMainJumpPanel);
         this.JumpData_mc.addEventListener(JumpDataPanel.JumpPanelShowEvent_MINI,this.onShowMiniJumpPanel);
         this.JumpData_mc.addEventListener(JumpDataPanel.JumpPanelHideEvent,this.onHideJumpPanel);
         this.InputEater_mc.RegisterBlockingUIElement(this.JumpData_mc.ExecuteButton_mc);
         this.InputEater_mc.RegisterBlockingUIElement(this.BodyInspect_mc.PlanetData_mc.Scan_mc);
         stage.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
         this.MenuHider_mc.gotoAndPlay("Open");
         GlobalFunc.PlayMenuSound("UIMenuStarmapMenuOpen");
      }
      
      public function OnMouseRollOver(param1:Event) : *
      {
         if(param1.target == this.MarkerSelection_mc)
         {
            this.MouseOverQSS = true;
         }
      }
      
      public function OnMouseRollOut(param1:Event) : *
      {
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            if(param1.target == this.MarkerSelection_mc && this.MarkerSelection_mc.visible)
            {
               this.MarkerSelection_mc.selectedIndex = -1;
               this.MouseOverQSS = false;
            }
         }
      }
      
      private function OnQuickSelectChange(param1:Event) : void
      {
         this.UpdateFakeCursor();
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
         this.MarkerSelection_mc.removeEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
         this.MarkerSelection_mc.removeEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
         this.MarkerSelection_mc.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.OnQuickSelectChange);
         stage.removeEventListener(MouseEvent.CLICK,this.OnMouseClick);
      }
      
      public function UpdateView(param1:int) : void
      {
         this.MapGrid_mc.visible = this.StarMapInfoDataPayload.bShowMapGrid;
         if(this.CurrentView != param1)
         {
            this.Markers_mc.UpdateCurrentView(param1);
            if(this.CurrentView == ViewTypes.VIEW_SURFACE_MAP || this.CurrentView == ViewTypes.VIEW_BODY_INSPECT)
            {
               this.BodyWasViewed = param1 == ViewTypes.VIEW_SYSTEM;
            }
            if(param1 == ViewTypes.VIEW_GALAXY)
            {
               if(this.FactionBounty_mc.HasFaction)
               {
                  this.FactionBounty_mc.Show();
               }
               this.SystemInfo_mc.ShowSystemInfo();
               if(this.CurrentView == ViewTypes.VIEW_SYSTEM)
               {
                  this.SystemInfoMini_mc.HideSystemInfo();
               }
               this.SystemHeader_mc.visible = false;
               this.SystemHeaderBackground_mc.visible = false;
               this.SystemNameHeader_mc.visible = false;
               this.ShowStarMapView();
               this.CurrentView = param1;
            }
            else if(param1 == ViewTypes.VIEW_SYSTEM)
            {
               if(this.BodyWasViewed)
               {
                  this.BodyInspect_mc.CloseDataWindow();
                  if(this.FactionBounty_mc.HasFaction)
                  {
                     this.FactionBounty_mc.Show();
                  }
                  this.BodyWasViewed = false;
               }
               if(this.CurrentView == ViewTypes.VIEW_GALAXY)
               {
                  this.SystemInfo_mc.HideSystemInfo();
               }
               this.SystemInfoMini_mc.ShowSystemInfo();
               this.StaticSystemView_mc.ShowStarMap();
               this.SystemHeader_mc.visible = true;
               GlobalFunc.SetText(this.SystemHeader_mc.Header_mc.text_tf,"$SYSTEM");
               this.SystemHeaderBackground_mc.visible = true;
               this.SystemHeader_mc.gotoAndPlay("Open");
               this.SystemNameHeader_mc.visible = true;
               this.SystemNameHeader_mc.gotoAndPlay("Open");
               this.CurrentView = param1;
            }
            else if(param1 == ViewTypes.VIEW_SURFACE_MAP)
            {
               this.CurrentView = param1;
               this.SystemInfo_mc.HideSystemInfo();
               this.SystemInfoMini_mc.HideSystemInfo();
               this.FactionBounty_mc.Hide();
               this.MapGrid_mc.visible = false;
               this.SystemHeader_mc.visible = false;
               this.SystemHeaderBackground_mc.visible = false;
               this.SystemNameHeader_mc.visible = false;
            }
            else if(this.CurrentView == ViewTypes.VIEW_SYSTEM || param1 == ViewTypes.VIEW_BODY_INSPECT)
            {
               this.CurrentView = param1;
               this.BodyInspect_mc.OpenDataWindow();
               this.BodyWasViewed = true;
               this.SystemInfo_mc.HideSystemInfo();
               this.SystemInfoMini_mc.HideSystemInfo();
               this.FactionBounty_mc.Hide();
               this.SystemHeader_mc.visible = false;
               this.SystemHeaderBackground_mc.visible = false;
               this.SystemNameHeader_mc.visible = false;
            }
            else
            {
               this.CurrentView = -1;
            }
         }
         this.UpdateWidgets();
         if(this.StarMapInfoDataPayload.bFakeCursorVisible != this.FakeCursorVisible)
         {
            this.FakeCursorVisible = this.StarMapInfoDataPayload.bFakeCursorVisible;
            if(this.FakeCursorVisible)
            {
               this.FakeCursor_mc.x = this.StarMapInfoDataPayload.iFakeCursorX;
               this.FakeCursor_mc.y = this.StarMapInfoDataPayload.iFakeCursorY;
               this.FakeCursor_mc.visible = true;
               eaze(this.FakeCursor_mc).apply({
                  "width":0,
                  "height":0,
                  "alpha":0
               }).delay(0.05).to(0.2,{
                  "width":CURSOR_SIZE_LARGE,
                  "height":CURSOR_SIZE_LARGE,
                  "alpha":1
               }).onComplete(this.FadeInFinished);
            }
            else
            {
               this.CursorLastX = this.FakeCursor_mc.x = mouseX;
               this.CursorLastY = this.FakeCursor_mc.y = mouseY;
               this.FakeCursor_mc.visible = true;
               eaze(this.FakeCursor_mc).apply({
                  "width":CURSOR_SIZE_LARGE,
                  "height":CURSOR_SIZE_LARGE,
                  "alpha":1
               }).delay(0.05).to(0.2,{
                  "width":0,
                  "height":0,
                  "alpha":0
               }).onComplete(this.FadeOutFinished);
            }
         }
         if(this.CursorLocked)
         {
            this.UpdateFakeCursor();
         }
      }
      
      private function UpdateFakeCursor() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:SystemMarker = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this.MarkerSelection_mc.selectedIndex < 0)
         {
            eaze(this.FakeCursor_mc).delay(0.05).to(0.2,{
               "width":0,
               "height":0
            });
         }
         else
         {
            _loc1_ = uint(this.MarkerSelection_mc.entryList[this.MarkerSelection_mc.selectedIndex].uMarkerIndex);
            _loc2_ = this.Markers_mc.QSystemMarker(_loc1_);
            this.CursorSizeCustom = CURSOR_SIZE_SMALL;
            this.TargetMarker = _loc1_;
            if(this.FakeCursor_mc != null)
            {
               if(!this.CursorFocused)
               {
                  _loc3_ = uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE;
                  _loc4_ = !!_loc3_ ? 0 : CURSOR_SIZE_LARGE;
                  _loc5_ = !!_loc3_ ? 0 : CURSOR_SIZE_LARGE;
                  _loc6_ = this.CursorLastX = !!_loc3_ ? _loc2_.x : mouseX;
                  _loc7_ = this.CursorLastY = !!_loc3_ ? _loc2_.y : mouseY;
                  this.FakeCursor_mc.gotoAndPlay("SelectionRing");
                  eaze(this.FakeCursor_mc).apply({
                     "visible":true,
                     "x":_loc6_,
                     "y":_loc7_,
                     "width":_loc4_,
                     "height":_loc5_
                  }).delay(0.05).to(0.2,{
                     "x":_loc2_.x,
                     "y":_loc2_.y,
                     "width":this.CursorSizeCustom,
                     "height":this.CursorSizeCustom
                  });
                  this.CursorFocused = true;
               }
               else
               {
                  this.FakeCursor_mc.visible = true;
                  eaze(this.FakeCursor_mc).delay(0.05).to(0.2,{
                     "x":_loc2_.x,
                     "y":_loc2_.y,
                     "width":this.CursorSizeCustom,
                     "height":this.CursorSizeCustom
                  });
               }
            }
         }
      }
      
      public function ShowQuickSelectMenu(param1:Boolean) : *
      {
         this.MarkerSelection_mc.visible = true;
         this.MarkerSelection_mc.InvalidateData();
         if(uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
         {
            this.MarkerSelection_mc.selectedIndex = -1;
         }
         else
         {
            this.MarkerSelection_mc.selectedIndex = 0;
         }
         stage.focus = null;
         stage.focus = this.MarkerSelection_mc;
         this.CursorLocked = true;
         this.MouseOverQSS = false;
         this.SelectedMarkerIndex = this.StarMapInfoDataPayload.uCursorSelectionIndex;
         this.MarkerSelection_mc.OpenForPlot = param1;
         var _loc2_:Number = this.FactionBounty_mc.Bounty_mc.visible ? 205 : 155;
         var _loc3_:Number = this.JumpData_mc.visible ? 0.47 : 0.67;
         if(this.FactionBounty_mc.HasFaction && (this.FakeCursor_mc.y < _loc2_ && mouseX > stage.stageWidth * _loc3_))
         {
            this.QSSBountyOffset = _loc2_ - this.Markers_mc.QSystemMarker(this.SelectedMarkerIndex).y;
         }
         this.addEventListener(Event.ENTER_FRAME,this.MoveQuickSelectToPosition);
         this.UpdateView(this.CurrentView);
         this.UniversalBackButton_mc.disabled = true;
      }
      
      private function QuickSelectHideComplete() : *
      {
         this.SendShowRealCursorEvent();
         stage.focus = null;
         this.UniversalBackButton_mc.disabled = false;
      }
      
      public function HideQuickSelectMenu(param1:Boolean = false) : *
      {
         this.MarkerSelection_mc.ClearList();
         this.MarkerSelection_mc.visible = false;
         if(param1)
         {
            GlobalFunc.PlayMenuSound("UIMenuStarmapInspectExit");
         }
         this.CursorLocked = false;
         this.CursorFocused = false;
         this.FakeCursor_mc.gotoAndPlay("Reverse");
         if(!this.IsGamepadInputActive)
         {
            this.FakeCursor_mc.visible = false;
            this.QuickSelectHideComplete();
         }
         else
         {
            eaze(this.FakeCursor_mc).apply({
               "width":this.CursorSizeCustom,
               "height":this.CursorSizeCustom,
               "alpha":1
            }).delay(0.05).to(0.2,{
               "x":this.CursorLastX,
               "y":this.CursorLastY,
               "width":CURSOR_SIZE_LARGE,
               "height":CURSOR_SIZE_LARGE
            }).apply({"visible":false}).onComplete(this.QuickSelectHideComplete);
         }
         this.QSSBountyOffset = 0;
         this.QSSInitialized = false;
         this.removeEventListener(Event.ENTER_FRAME,this.MoveQuickSelectToPosition);
      }
      
      private function MoveQuickSelectToPosition(param1:Event) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc2_:SystemMarker = this.Markers_mc.QSystemMarker(this.TargetMarker);
         var _loc3_:Number = stage.width;
         var _loc4_:Number = stage.height;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 40;
         var _loc8_:Number = 13;
         var _loc9_:Number = 280;
         var _loc10_:Number = this.MarkerSelection_mc.ListEntries * 30 + 20;
         var _loc11_:Number = 0.5;
         var _loc14_:SystemMarker = this.Markers_mc.QSystemMarker(this.SelectedMarkerIndex);
         var _loc15_:Number = this.JumpData_mc.visible ? 1300 : 1500;
         if(_loc2_)
         {
            _loc16_ = _loc2_.x - this.FakeCursor_mc.x;
            _loc17_ = _loc2_.y - this.FakeCursor_mc.y;
            this.FakeCursor_mc.x += _loc16_ * 0.1;
            this.FakeCursor_mc.y += _loc17_ * 0.1;
            _loc12_ = Math.abs(this.FakeCursor_mc.x - _loc2_.x);
            _loc13_ = Math.abs(this.FakeCursor_mc.y - _loc2_.y);
            if(_loc12_ <= _loc11_ && _loc13_ <= _loc11_)
            {
               this.FakeCursor_mc.x = _loc2_.x;
               this.FakeCursor_mc.y = _loc2_.y;
            }
            _loc5_ = _loc14_.x + _loc7_;
            if(this.FakeCursor_mc.x > _loc15_)
            {
               _loc5_ = _loc14_.x - (_loc9_ - _loc7_);
            }
            if(this.FakeCursor_mc.y < _loc4_ / 3)
            {
               _loc6_ = _loc14_.y - _loc8_ + this.QSSBountyOffset;
            }
            else
            {
               _loc6_ = _loc14_.y - (_loc10_ - _loc8_) + this.QSSBountyOffset;
            }
            this.MarkerSelection_mc.x = _loc5_;
            this.MarkerSelection_mc.y = _loc6_;
         }
         this.QSSInitialized = true;
      }
      
      private function FadeInFinished() : *
      {
         this.FakeCursor_mc.visible = false;
         this.SendShowRealCursorEvent();
      }
      
      private function FadeOutFinished() : *
      {
         this.FakeCursor_mc.x = this.CursorLastX;
         this.FakeCursor_mc.y = this.CursorLastY;
      }
      
      private function ShowStarMapView() : *
      {
         var _loc1_:MovieClip = null;
         var _loc3_:MovieClip = null;
         this.Markers_mc.visible = false;
         if(this.GalaxyMapName_mc != null)
         {
            this.GalaxyMapName_mc.gotoAndPlay("open");
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.GridMarkersArray.length)
         {
            _loc1_ = this.GridMarkersArray[_loc2_];
            _loc1_.visible = false;
            _loc2_++;
         }
         var _loc4_:Number = 0.08;
         _loc2_ = 0;
         while(_loc2_ < this.GridMarkersArray.length)
         {
            _loc3_ = this.GridMarkersArray[_loc2_];
            this.GridAnimation(_loc3_,_loc4_);
            _loc4_ += 0.03;
            _loc2_++;
         }
         if(this.Markers_mc != null)
         {
            eaze(this.Markers_mc).easing(Quadratic.easeIn).apply({
               "alpha":0,
               "visible":true
            }).to(1.5,{"alpha":1}).onComplete(this.OnGalaxyViewInitialized);
         }
      }
      
      private function HideStarmapView(param1:String) : *
      {
         var _loc2_:Number = 0.5;
         gotoAndPlay("Close");
         this.FactionBounty_mc.visible = false;
         if(this.CurrentView == ViewTypes.VIEW_GALAXY)
         {
            this.SystemInfo_mc.HideSystemInfo();
            this.SystemInfoMini_mc.HideSystemInfo();
         }
         else if(this.CurrentView == ViewTypes.VIEW_SYSTEM)
         {
            if(this.isSystemBodyInfoOpen)
            {
               this.SystemPlanetInfoCard_mc.Close();
            }
            this.SystemNameHeader_mc.gotoAndPlay("Close");
            this.SystemInfoMini_mc.HideSystemInfo();
         }
         else if(this.CurrentView == ViewTypes.VIEW_BODY_INSPECT)
         {
            this.BodyInspect_mc.PlanetData_mc.Close();
         }
         else if(this.CurrentView == ViewTypes.VIEW_SURFACE_MAP)
         {
            this.SurfaceMap_mc.gotoAndPlay("Close");
            this.SurfaceMap_mc.PlanetData_mc.Close();
         }
         if(this.Markers_mc != null)
         {
            eaze(this.Markers_mc).to(_loc2_,{"alpha":0});
         }
         eaze(this.Gradient_mc).to(_loc2_,{"alpha":0}).onComplete(this.OnGalaxyViewFaded,param1);
      }
      
      private function OnGalaxyViewFaded(param1:String) : *
      {
         BSUIDataManager.dispatchEvent(new Event(param1,true));
      }
      
      internal function GridAnimation(param1:MovieClip, param2:Number) : *
      {
         var _loc3_:MovieClip = param1;
         var _loc4_:Number = _loc3_.width;
         var _loc5_:Number = _loc3_.height;
         var _loc6_:Number = 0.5;
         eaze(param1).delay(param2).easing(Quadratic.easeIn).apply({
            "alpha":0,
            "visible":true,
            "width":0,
            "height":0
         }).to(_loc6_,{
            "alpha":0.4,
            "width":_loc4_,
            "height":_loc5_
         });
      }
      
      public function OnExitStarMapEvent() : *
      {
         GlobalFunc.StartGameRender();
         this.HideStarmapView(StarMapMenu_OnExitStarMap);
      }
      
      public function UpdateWidgets() : void
      {
         var _loc1_:TextField = this.GalaxyMapName_mc.GalaxyMapText_mc.text_tf;
         GlobalFunc.SetText(_loc1_,this.CurrentView == ViewTypes.VIEW_SURFACE_MAP ? "$SURFACE MAP" : "$STARMAP");
         if(this.CurrentView == ViewTypes.VIEW_BODY_INSPECT)
         {
            this.BodyInspect_mc.OpenView();
            if(this.SurfaceMap_mc.visible)
            {
               GlobalFunc.PlayMenuSound("UIMenuSurfaceMapMenuClose");
            }
            this.SystemInfoMini_mc.visible = false;
            this.FactionBounty_mc.visible = false;
            this.EnableGalaxy2DMap(false);
            this.SurfaceMap_mc.visible = false;
            this.UniversalBackButton_mc.visible = true;
            this.GalaxyMapName_mc.visible = true;
         }
         else if(this.CurrentView == ViewTypes.VIEW_SURFACE_MAP)
         {
            this.BodyInspect_mc.CloseView();
            this.SurfaceMap_mc.visible = true;
            this.SurfaceMap_mc.SetFocus();
            this.SurfaceMap_mc.gotoAndPlay("Open");
            this.SurfaceMap_mc.PlanetData_mc.Open();
            GlobalFunc.PlayMenuSound("UIMenuSurfaceMapMenuOpen");
            this.SystemInfoMini_mc.visible = false;
            this.FactionBounty_mc.visible = false;
            this.EnableGalaxy2DMap(false);
            this.UniversalBackButton_mc.visible = true;
            this.GalaxyMapName_mc.visible = true;
         }
         else
         {
            this.BodyInspect_mc.CloseView();
            if(this.SurfaceMap_mc.visible)
            {
               GlobalFunc.PlayMenuSound("UIMenuSurfaceMapMenuClose");
            }
            this.SurfaceMap_mc.visible = false;
            this.SystemInfoMini_mc.visible = this.CurrentView == ViewTypes.VIEW_SYSTEM;
            this.FactionBounty_mc.visible = true;
            this.UniversalBackButton_mc.visible = true;
            this.GalaxyMapName_mc.visible = true;
            this.EnableGalaxy2DMap(false);
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = this.InputEater_mc.ProcessUserEvent(param1,param2);
         var _loc4_:* = param1 == "Cancel";
         var _loc5_:Boolean = !param2 && this.UniversalBackButton_mc.over && param1 == "Select";
         if(this.OutpostSelect_mc.visible)
         {
            if(!_loc4_)
            {
               return false;
            }
            this.OnCancelEvent();
            _loc3_ = true;
         }
         var _loc6_:* = this.ShowQuickSelect && _loc4_;
         if(param1 == "Select" && this.QSSInitialized && uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE && !this.MouseOverQSS)
         {
            return false;
         }
         if(_loc6_ || _loc5_)
         {
            this.OnCancelEvent();
            _loc3_ = true;
         }
         if(!_loc3_ && this.ShowQuickSelect)
         {
            _loc3_ = this.MarkerSelection_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.JumpData_mc.visible == true)
         {
            _loc3_ = this.JumpData_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.Markers_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.CurrentView == ViewTypes.VIEW_SURFACE_MAP)
         {
            _loc3_ = Boolean(this.SurfaceMap_mc.ProcessUserEvent(param1,param2));
         }
         if(!_loc3_ && this.CurrentView == ViewTypes.VIEW_BODY_INSPECT)
         {
            _loc3_ = this.BodyInspect_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.CurrentView == ViewTypes.VIEW_SYSTEM)
         {
            _loc3_ = this.SystemPlanetInfoCard_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonHintBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function OnMouseClick(param1:MouseEvent) : *
      {
         if(this.QSSInitialized && !this.MouseOverQSS)
         {
            this.OnCancelEvent();
         }
      }
      
      private function OnCancelEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event(StarMapMenu_OnCancel,true));
      }
      
      private function OnClearRouteEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event(StarMapMenu_OnClearRoute,true));
      }
      
      private function SendShowRealCursorEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event(StarMapMenu_ShowRealCursor,true));
      }
      
      private function OnGalaxyViewInitialized() : void
      {
         BSUIDataManager.dispatchEvent(new Event(StarMapMenu_OnGalaxyViewInitialized,true));
      }
      
      public function OnInspect() : void
      {
         BSUIDataManager.dispatchEvent(new Event(StarMapMenu_OnInspect,true));
      }
      
      private function GetBodyHighlight(param1:Array) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         for each(_loc3_ in param1)
         {
            if(_loc3_.bIsInHighlightRadius)
            {
               _loc2_ = _loc3_.uBodyID;
               break;
            }
         }
         return _loc2_;
      }
      
      private function onOutpostSelectDataReceived(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         if(_loc2_.bShowMenu)
         {
            this.OutpostSelect_mc.Show();
         }
         else
         {
            this.OutpostSelect_mc.Hide();
         }
         this.OutpostSelect_mc.SetListData(_loc2_.OutpostsA);
      }
      
      private function onShowMainJumpPanel() : *
      {
         this.FactionBounty_mc.AdjustForJumpPanel();
         if(this.IsLargeTextMode)
         {
            this.SystemPlanetInfoCard_mc.SetResourcePanelVisible(false);
            if(this.ShowSystemScanButon)
            {
               this.SystemPlanetInfoCard_mc.SetNoScanMode();
            }
         }
      }
      
      private function onShowMiniJumpPanel() : *
      {
         this.FactionBounty_mc.ResetPosition();
         if(this.IsLargeTextMode)
         {
            this.SystemPlanetInfoCard_mc.SetResourcePanelVisible(false);
            if(this.ShowSystemScanButon)
            {
               this.SystemPlanetInfoCard_mc.SetNoScanMode();
            }
         }
      }
      
      private function onHideJumpPanel() : *
      {
         this.FactionBounty_mc.ResetPosition();
         if(this.IsLargeTextMode)
         {
            this.SystemPlanetInfoCard_mc.SetResourcePanelVisible(true);
            if(this.ShowSystemScanButon)
            {
               this.SystemPlanetInfoCard_mc.SetSystemScanMode();
            }
         }
      }
      
      private function EnableGalaxy2DMap(param1:Boolean) : void
      {
         this.StaticSystemView_mc.visible = param1;
         this.SystemInfoMini_mc.y = param1 ? this.SystemInfoCardBaseY : this.StaticSystemView_mc.y;
      }
      
      public function IsHoveringInputEater() : Boolean
      {
         return this.InputEater_mc.IsMouseOver;
      }
      
      internal function __setProp_InputEater_mc__Main_InputEater_mc_0() : *
      {
         if(this.__setPropDict[this.InputEater_mc] == undefined || int(this.__setPropDict[this.InputEater_mc]) != 1)
         {
            this.__setPropDict[this.InputEater_mc] = 1;
            try
            {
               this.InputEater_mc["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.InputEater_mc.EnableDebugging = false;
            this.InputEater_mc.InputEvent = "Click";
            this.InputEater_mc.MimicClips = ["StaticSystemView_mc","UniversalBackButton_mc"];
            try
            {
               this.InputEater_mc["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_InputEater_mc__Main_InputEater_mc_1(param1:int) : *
      {
         if(this.InputEater_mc != null && param1 >= 2 && param1 <= 16 && (this.__setPropDict[this.InputEater_mc] == undefined || !(int(this.__setPropDict[this.InputEater_mc]) >= 2 && int(this.__setPropDict[this.InputEater_mc]) <= 16)))
         {
            this.__setPropDict[this.InputEater_mc] = param1;
            try
            {
               this.InputEater_mc["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.InputEater_mc.EnableDebugging = false;
            this.InputEater_mc.InputEvent = "Click";
            this.InputEater_mc.MimicClips = ["SystemBodyDataInfo_mc","StaticSystemView_mc","UniversalBackButton_mc"];
            try
            {
               this.InputEater_mc["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_handler(param1:Object) : *
      {
         var _loc2_:int = currentFrame;
         if(this.__lastFrameProp == _loc2_)
         {
            return;
         }
         this.__lastFrameProp = _loc2_;
         this.__setProp_InputEater_mc__Main_InputEater_mc_1(_loc2_);
      }
   }
}
