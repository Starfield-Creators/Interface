package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.BSEaze;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ReleaseHoldComboButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.ReleaseHoldComboButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class StarMapButtonHintBar extends MovieClip
   {
      
      public static const StarMapMenu_OnHintButtonClicked:String = "StarMapMenu_OnHintButtonClicked";
      
      private static const HELD_BUTTON_CAN_HOLD:Boolean = true;
      
      private static const HELD_BUTTON_RETURN_TO_IDLE:Boolean = false;
      
      private static const HELD_BUTTON_JUSTIFY_HOLD_METER:Boolean = true;
      
      private static const HELD_BUTTON_MAX_PRESS_TIME_MS:Number = 200;
      
      internal static const FADE_TIME:Number = 0.35;
       
      
      public var HintBar_mc:ButtonBar;
      
      public var BackButtonData:ReleaseHoldComboButtonData = null;
      
      public var SurfaceMapButtonData:ButtonBaseData = null;
      
      public var ShowMeButtonData:ButtonBaseData = null;
      
      public var ZoomInButtonData:ButtonBaseData = null;
      
      public var ZoomOutButtonData:ButtonBaseData = null;
      
      public var FastTravelShipButtonData:ButtonBaseData = null;
      
      public var MissionButtonData:ButtonBaseData = null;
      
      public var ResetCameraButtonData:ButtonBaseData = null;
      
      public var NextStateButtonData:ButtonBaseData = null;
      
      public var PreviousStateButtonData:ButtonBaseData = null;
      
      public var SetRouteDestinationButtonData:ButtonBaseData = null;
      
      public var LandingMarkerButtonGamePadData:ButtonBaseData = null;
      
      public var LandingMarkerButtonMKBData:ButtonBaseData = null;
      
      private var BackButton:ReleaseHoldComboButton = null;
      
      public var BodyInspectButtonData:ButtonBaseData = null;
      
      internal var buttonV:Vector.<ButtonBase>;
      
      private var clearRouteButtonCallback:Function;
      
      private var exitStarMapCallback:Function;
      
      public function StarMapButtonHintBar()
      {
         this.buttonV = new Vector.<ButtonBase>();
         super();
         this.PopulateButtons();
      }
      
      public function set ClearRouteButtonCallback(param1:Function) : *
      {
         this.clearRouteButtonCallback = param1;
      }
      
      public function set ExitStarMapCallback(param1:Function) : *
      {
         this.exitStarMapCallback = param1;
      }
      
      public function set largeTextMode(param1:Boolean) : *
      {
         if(param1)
         {
            this.BackButtonData = new ReleaseHoldComboButtonData("$BACK","$EXIT HOLD_LRG",[new UserEventData("Cancel",this.OnCancelEvent),new UserEventData("",this.OnExitStarMapEvent)]);
            this.BackButton.SetButtonData(this.BackButtonData);
         }
         this.HintBar_mc.RefreshButtons();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!param2 && param1 == "Map")
         {
            this.OnExitStarMapEvent();
            _loc3_ = true;
         }
         else
         {
            _loc3_ = this.HintBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function RefreshButtons() : *
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this.buttonV)
         {
            _loc1_.RefreshButtonData();
         }
         this.HintBar_mc.RefreshButtons();
      }
      
      private function PopulateButtons() : *
      {
         var MissionButton:ButtonBase;
         var PreviousStateButton:ButtonBase;
         var NextStateButton:ButtonBase;
         var ShowMeButton:ButtonBase;
         var BodyInspectButton:ButtonBase;
         var SurfaceMapButton:ButtonBase;
         var ResetCameraButton:ButtonBase;
         var ZoomOutButton:ButtonBase;
         var ZoomInButton:ButtonBase;
         var LandingMarkerButtonGamePad:ButtonBase;
         var LandingMarkerButtonMKB:ButtonBase;
         var SetRouteDestinationButton:ButtonBase;
         var FastTravelShipButton:ButtonBase;
         this.HintBar_mc.Initialize(1);
         this.MissionButtonData = new ButtonBaseData("$MISSIONS",[new UserEventData("OpenMissionMenu",function():void
         {
            SendHintButtonClicked("OpenMissionMenu");
         })]);
         MissionButton = ButtonFactory.AddToButtonBar("BasicButton",this.MissionButtonData,this.HintBar_mc) as ButtonBase;
         MissionButton.name = "MissionButton";
         this.PreviousStateButtonData = new ButtonBaseData("$PREVIOUSSTATE",[new UserEventData("Left",null)]);
         PreviousStateButton = ButtonFactory.AddToButtonBar("BasicButton",this.PreviousStateButtonData,this.HintBar_mc) as ButtonBase;
         PreviousStateButton.name = "PreviousStateButton";
         this.NextStateButtonData = new ButtonBaseData("$NEXTSTATE",[new UserEventData("Right",null)]);
         NextStateButton = ButtonFactory.AddToButtonBar("BasicButton",this.NextStateButtonData,this.HintBar_mc) as ButtonBase;
         NextStateButton.name = "NextStateButton";
         this.ShowMeButtonData = new ButtonBaseData("$SHOW ME",[new UserEventData("ShowMe",function():void
         {
            SendHintButtonClicked("ShowMe");
         })]);
         ShowMeButton = ButtonFactory.AddToButtonBar("BasicButton",this.ShowMeButtonData,this.HintBar_mc) as ButtonBase;
         ShowMeButton.name = "ShowMeButton";
         this.BodyInspectButtonData = new ButtonBaseData("$BODY INSPECT",[new UserEventData("XButton",function():void
         {
            SendHintButtonClicked("XButton");
         })]);
         BodyInspectButton = ButtonFactory.AddToButtonBar("BasicButton",this.BodyInspectButtonData,this.HintBar_mc) as ButtonBase;
         BodyInspectButton.name = "BodyInspectButton";
         this.SurfaceMapButtonData = new ButtonBaseData("$SURFACE MAP",[new UserEventData("SurfaceMap",function():void
         {
            SendHintButtonClicked("SurfaceMap");
         })]);
         SurfaceMapButton = ButtonFactory.AddToButtonBar("BasicButton",this.SurfaceMapButtonData,this.HintBar_mc) as ButtonBase;
         SurfaceMapButton.name = "SurfaceMapButton";
         this.ResetCameraButtonData = new ButtonBaseData("$RESET CAMERA",[new UserEventData("ResetCamera",null)]);
         ResetCameraButton = ButtonFactory.AddToButtonBar("BasicButton",this.ResetCameraButtonData,this.HintBar_mc) as ButtonBase;
         ResetCameraButton.name = "ResetCameraButton";
         this.ZoomOutButtonData = new ButtonBaseData("$ZOOM OUT",[new UserEventData("ZoomOut",null)]);
         ZoomOutButton = ButtonFactory.AddToButtonBar("BasicButton",this.ZoomOutButtonData,this.HintBar_mc) as ButtonBase;
         ZoomOutButton.name = "ZoomOutButton";
         this.ZoomInButtonData = new ButtonBaseData("$ZOOM IN",[new UserEventData("ZoomIn",null)]);
         ZoomInButton = ButtonFactory.AddToButtonBar("BasicButton",this.ZoomInButtonData,this.HintBar_mc) as ButtonBase;
         ZoomInButton.name = "ZoomInButton";
         this.LandingMarkerButtonGamePadData = new ButtonBaseData("$PLOT LANDINGMARKER",[new UserEventData("Select",function():void
         {
            SendHintButtonClicked("Select");
         })]);
         LandingMarkerButtonGamePad = ButtonFactory.AddToButtonBar("BasicButton",this.LandingMarkerButtonGamePadData,this.HintBar_mc) as ButtonBase;
         LandingMarkerButtonGamePad.name = "LandingMarkerButtonGamePad";
         this.LandingMarkerButtonMKBData = new ButtonBaseData("$PLOT LANDINGMARKER",[new UserEventData("Select",null)]);
         LandingMarkerButtonMKB = ButtonFactory.AddToButtonBar("BasicButton",this.LandingMarkerButtonMKBData,this.HintBar_mc) as ButtonBase;
         LandingMarkerButtonMKB.name = "LandingMarkerButtonMKB";
         this.SetRouteDestinationButtonData = new ButtonBaseData("$SET COURSE",[new UserEventData("SetRouteDestination",function():void
         {
            SendHintButtonClicked("SetRouteDestination");
         })]);
         SetRouteDestinationButton = ButtonFactory.AddToButtonBar("BasicButton",this.SetRouteDestinationButtonData,this.HintBar_mc) as ButtonBase;
         SetRouteDestinationButton.name = "SetRouteDestinationButton";
         this.FastTravelShipButtonData = new ButtonBaseData("$FAST TRAVEL SHIP",[new UserEventData("FastTravelShip",function():void
         {
            SendHintButtonClicked("FastTravelShip");
         })]);
         FastTravelShipButton = ButtonFactory.AddToButtonBar("BasicButton",this.FastTravelShipButtonData,this.HintBar_mc) as ButtonBase;
         FastTravelShipButton.name = "FastTravelShipButton";
         this.BackButtonData = new ReleaseHoldComboButtonData("$BACK","$EXIT HOLD",[new UserEventData("Cancel",this.OnCancelEvent),new UserEventData("",this.OnExitStarMapEvent)]);
         this.BackButton = ButtonFactory.AddToButtonBar("ReleaseHoldComboButton",this.BackButtonData,this.HintBar_mc) as ReleaseHoldComboButton;
         this.BackButton.name = "BackButton";
         this.buttonV.push(MissionButton);
         this.buttonV.push(PreviousStateButton);
         this.buttonV.push(NextStateButton);
         this.buttonV.push(ShowMeButton);
         this.buttonV.push(BodyInspectButton);
         this.buttonV.push(SurfaceMapButton);
         this.buttonV.push(ResetCameraButton);
         this.buttonV.push(ZoomOutButton);
         this.buttonV.push(ZoomInButton);
         this.buttonV.push(LandingMarkerButtonGamePad);
         this.buttonV.push(LandingMarkerButtonMKB);
         this.buttonV.push(SetRouteDestinationButton);
         this.buttonV.push(FastTravelShipButton);
         this.buttonV.push(this.BackButton);
         this.RefreshButtons();
      }
      
      private function OnCancelEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event(GalaxyStarMapMenu.StarMapMenu_OnCancel,true));
      }
      
      private function OnExitStarMapEvent() : void
      {
         BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
         this.exitStarMapCallback();
      }
      
      private function OnClearPlotRoute() : void
      {
         this.clearRouteButtonCallback();
      }
      
      private function OnFastTravelShipEvent() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_OnHintButtonClicked,{"buttonAction":"FastTravelShip"}));
      }
      
      private function SendHintButtonClicked(param1:String) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(StarMapMenu_OnHintButtonClicked,{"buttonAction":param1}));
      }
      
      public function SetButtonHintBarActive(param1:Boolean) : void
      {
         if(param1)
         {
            BSEaze(this).FadeIn(FADE_TIME);
         }
         else
         {
            BSEaze(this).FadeOut(FADE_TIME);
         }
      }
      
      private function onCloseSubMenuToGame() : *
      {
         BSUIDataManager.dispatchEvent(new Event("DataMenu_SetMenuForQuickEntry"));
         GlobalFunc.CloseAllMenus();
      }
   }
}
