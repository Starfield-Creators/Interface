package
{
   import Components.Icons.DynamicPoiIcon;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import Shared.MapMarkerUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class MonocleMenu extends IMenu
   {
      
      {
         trace("Open monocle");
      }
      
      public var RightInfoDisplay_mc:MovieClip;
      
      public var PlanetInfo_mc:MovieClip;
      
      public var range_mc:MovieClip;
      
      public var MaxScannerRange_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var OuterCircle_mc:MovieClip;
      
      public var ScanMapMarkerHolder_mc:ScanMapMarkerHolder;
      
      public var NearbyPOIDisplay_mc:MovieClip;
      
      public var TraitIcon_mc:MovieClip;
      
      public var ResourceArc_mc:ResourceArc;
      
      public var Gradient_mc:MovieClip;
      
      private var isMenuOpening:Boolean = true;
      
      private var isMenuClosing:Boolean = false;
      
      private var bDoingSocialScan:Boolean = false;
      
      private var HarvestButtonData:ButtonBaseData;
      
      private var SocialScanButtonData:ButtonBaseData;
      
      private var BioscanButtonData:ButtonBaseData;
      
      private var OpenDoorButtonData:ButtonBaseData;
      
      private var ShowResourcesButtonData:ButtonBaseData;
      
      private var FastTravelButtonData:ButtonBaseData;
      
      private var SocialSpellButtonData:ButtonBaseData;
      
      private var PlaceBeaconButtonData:ButtonBaseData;
      
      private var PhotoModeButtonData:ButtonBaseData;
      
      private var SurfaceMapButtonData:ButtonBaseData;
      
      private var ZoomButtonData:ButtonBaseData;
      
      private var HiddenButtonData:ButtonBaseData;
      
      private var ContainerTakeData:ButtonBaseData;
      
      private var ContainerTransferData:ButtonBaseData;
      
      private const PICK_TYPE_NONE:int = EnumHelper.GetEnum(0);
      
      private const PICK_TYPE_RESOURCE:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_FLORA:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_FAUNA:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_NPC:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_OBJECT:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_MAP_MARKER:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_CONTAINER:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_LOOSE_ITEM:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_SPACESHIP:int = EnumHelper.GetEnum();
      
      private const PICK_TYPE_DOOR:int = EnumHelper.GetEnum();
      
      private const EVENT_TYPE_NONE:int = EnumHelper.GetEnum(0);
      
      private const EVENT_TYPE_TRAIT_DISCOVERED:int = EnumHelper.GetEnum();
      
      private const EVENT_TYPE_SCAN_FULLY_COMPLETE:int = EnumHelper.GetEnum();
      
      private const SOCIAL_TYPE_NONE:int = EnumHelper.GetEnum(0);
      
      private const SOCIAL_TYPE_NPC:int = EnumHelper.GetEnum();
      
      private const SOCIAL_TYPE_XENOSOCIAL:int = EnumHelper.GetEnum();
      
      private const SOCIAL_TYPE_HACK:int = EnumHelper.GetEnum();
      
      private const VIEW_CAST_TYPE_STANDARD:int = EnumHelper.GetEnum(0);
      
      private const VIEW_CAST_TYPE_HANDSCANNER:int = EnumHelper.GetEnum();
      
      private const NAME_MAX_LENGTH:* = 31;
      
      private var CurrentPickRefType:uint;
      
      private var CurrentViewCastType:uint;
      
      private var CurrentFormID:uint = 0;
      
      private var CurrentPickRefHandle:uint = 0;
      
      private var CurrentPOIName:String = "";
      
      private var PickRefIsScannable:Boolean = false;
      
      private var PickRefIsScanned:Boolean = false;
      
      private var CanFastTravel:Boolean = false;
      
      private var UseItemCard:Boolean = false;
      
      private var RolloverShowing:Boolean = false;
      
      private var CurrentUsePickFrameDelay:Boolean = false;
      
      private var FrameDelayPickRefData:FromClientDataEvent = null;
      
      private var FrameDelayCounter:uint = 0;
      
      private const PICK_FRAME_DELAY_LEN:uint = 5;
      
      private var SocialList_OrigCenterY:Number = 0;
      
      private var ResourceArcDisplayTimer:Timer;
      
      private var StoredSurveyPercent:Number = 0;
      
      private var LocationTraitRefsScanned:uint = 0;
      
      private var LocationTraitRefsRequired:uint = 0;
      
      private const START_CONTAINER_VIEW:String = "MonocleMenu_StartContainerView";
      
      private const STOP_CONTAINER_VIEW:String = "MonocleMenu_StopContainerView";
      
      private const USE_LIST_CONTROLS:String = "MonocleMenu_UseListScrollControls";
      
      public function MonocleMenu()
      {
         var configParams:BSScrollingConfigParams;
         this.HarvestButtonData = new ButtonBaseData("$HARVEST",new UserEventData("Scan",this.onHarvestPressed));
         this.SocialScanButtonData = new ButtonBaseData("$SOCIAL",new UserEventData("Scan",this.onSocialScan));
         this.BioscanButtonData = new ButtonBaseData("$BIOSCAN",new UserEventData("Scan",this.onBioscanPressed));
         this.OpenDoorButtonData = new ButtonBaseData("$Open",new UserEventData("Scan",this.onOpenDoorPressed));
         this.ShowResourcesButtonData = new ButtonBaseData("$SHOW_RESOURCES",new UserEventData("Scan",this.onShowResourcesPressed));
         this.FastTravelButtonData = new ButtonBaseData("$FastTravel",new UserEventData("Scan",this.onFastTravel));
         this.SocialSpellButtonData = new ButtonBaseData("$ACTIVATE",new UserEventData("Scan",this.onSocialSpellCast));
         this.PlaceBeaconButtonData = new ButtonBaseData("$OUTPOST",new UserEventData("PlaceBeacon",this.onPlaceBeacon));
         this.PhotoModeButtonData = new ButtonBaseData("$PHOTOMODE",new UserEventData("PhotoMode",this.onPhotoMode));
         this.SurfaceMapButtonData = new ButtonBaseData("$SURFACE MAP",new UserEventData("SurfaceMap",this.onSurfaceMap));
         this.ZoomButtonData = new ButtonBaseData("$ADJUST_ZOOM",[new UserEventData("ScrollListUp",this.onZoomIn),new UserEventData("ScrollListDown",this.onZoomOut),new UserEventData("ScannerZoomIn",this.onZoomIn),new UserEventData("ScannerZoomOut",this.onZoomOut)]);
         this.HiddenButtonData = new ButtonBaseData("",new UserEventData("",null),false,false);
         this.ContainerTakeData = new ButtonBaseData("$TAKE",new UserEventData("QCAButton",null));
         this.ContainerTransferData = new ButtonBaseData("$QuickContainerTransfer",new UserEventData("QCXButton",null));
         this.CurrentPickRefType = this.PICK_TYPE_NONE;
         this.CurrentViewCastType = this.VIEW_CAST_TYPE_STANDARD;
         this.ResourceArcDisplayTimer = new Timer(2000,1);
         super();
         addEventListener("onOpenAnimComplete",this.onOpenAnimCompleteCallbk);
         addEventListener("onCloseAnimComplete",this.onCloseAnimCompleteCallbk);
         this.ResourceArcDisplayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onResourceDisplayTimerDone);
         this.ResourceArc_mc.addEventListener("ResourceArcClosed",this.onResourceCloseAnimComplete);
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.RightInfoDisplay_mc.Resource_mc.element_mc.symbol_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.PlanetInfo_mc.Trait1_mc.mouseEnabled = false;
         this.PlanetInfo_mc.Trait2_mc.mouseEnabled = false;
         this.PlanetInfo_mc.Trait3_mc.mouseEnabled = false;
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,15);
         this.ButtonBar_mc.SetBackgroundPadding(50,7);
         this.ButtonBar_mc.AddButtonWithData(this.AButton_mc,this.BioscanButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.XButton_mc,this.PlaceBeaconButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.SurfaceMapButton_mc,this.SurfaceMapButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.PhotoModeButton_mc,this.PhotoModeButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.ZoomButton_mc,this.ZoomButtonData);
         this.ButtonBar_mc.AddButtonWithData(this.BackButton_mc,new ButtonBaseData("$BACK",new UserEventData("Monocle",this.onCancelPressed)));
         this.ButtonBar_mc.RefreshButtons();
         configParams = new BSScrollingConfigParams();
         configParams.VerticalSpacing = 10;
         configParams.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         configParams.EntryClassName = "SocialSkillListEntry";
         this.socialSpellList.Configure(configParams);
         this.socialSpellList.addEventListener(ScrollingEvent.ITEM_PRESS,this.onSocialSpellCast);
         this.SocialList_OrigCenterY = this.socialSpellList.y + this.socialSpellList.containerHeight / 2 + 15;
         this.socialSpellList.SetFilterComparitor(function(param1:Object):Boolean
         {
            return param1.bVisible === true;
         },false);
         BSUIDataManager.Subscribe("MonocleMenuData",this.onMonocleDataUpdate);
         BSUIDataManager.Subscribe("MonocleMenuFreqData",this.onMonocleFreqDataUpdate);
         BSUIDataManager.Subscribe("MonoclePickRefData",this.onPickDataUpdate);
         BSUIDataManager.Subscribe("MonocleKnownResourcesData",this.onResourcesUpdate);
         BSUIDataManager.Subscribe("MonocleEventsData",this.onNewEvent);
         BSUIDataManager.Subscribe("FireForgetEventData",this.onFireForgetEvent);
         BSUIDataManager.Subscribe("HUDRolloverActivationData",this.onHUDActivationDataUpdate);
      }
      
      private function get AButton_mc() : IButton
      {
         return this.ButtonBar_mc.AButton_mc;
      }
      
      private function get XButton_mc() : IButton
      {
         return this.ButtonBar_mc.XButton_mc;
      }
      
      private function get PhotoModeButton_mc() : IButton
      {
         return this.ButtonBar_mc.PhotoModeButton_mc;
      }
      
      private function get SurfaceMapButton_mc() : IButton
      {
         return this.ButtonBar_mc.SurfaceMapButton_mc;
      }
      
      private function get ZoomButton_mc() : IButton
      {
         return this.ButtonBar_mc.ZoomButton_mc;
      }
      
      private function get BackButton_mc() : IButton
      {
         return this.ButtonBar_mc.BackButton_mc;
      }
      
      private function get socialSpellList() : BSScrollingContainer
      {
         return this.RightInfoDisplay_mc.Bioscan_mc.SocialList_mc;
      }
      
      override protected function onSetSafeRect() : void
      {
         var _loc1_:Rectangle = Extensions.visibleRect;
         var _loc2_:Point = this.Gradient_mc.parent.globalToLocal(new Point(_loc1_.x,_loc1_.y));
         this.Gradient_mc.width = _loc1_.width;
         this.Gradient_mc.height = _loc1_.height;
         this.Gradient_mc.x = _loc2_.x;
         this.Gradient_mc.y = _loc2_.y;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!this.isMenuClosing)
         {
            if(param1 != "QCAButton" && param1 != "QCXButton")
            {
               _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
            }
            if(!_loc3_ && !param2)
            {
               switch(param1)
               {
                  case "Monocle":
                  case "Flashlight":
                  case "Cancel":
                  case "Pause":
                  case "DataMenu":
                     this.onCancelPressed();
                     _loc3_ = true;
                     break;
                  case "ScannerZoomIn":
                     if(stage.focus == this.socialSpellList)
                     {
                        this.socialSpellList.MoveSelection(-1);
                        _loc3_ = true;
                     }
                     break;
                  case "ScannerZoomOut":
                     if(stage.focus == this.socialSpellList)
                     {
                        this.socialSpellList.MoveSelection(1);
                        _loc3_ = true;
                     }
               }
            }
         }
         return _loc3_;
      }
      
      private function onHarvestPressed() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_Harvest"));
      }
      
      private function onBioscanPressed() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_Bioscan"));
      }
      
      private function onOpenDoorPressed() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_OpenDoor"));
      }
      
      private function onShowResourcesPressed() : void
      {
         if(!this.ResourceArc_mc.visible)
         {
            this.ShowResourceArcAnim();
         }
      }
      
      private function onSocialScan() : void
      {
         this.StartSocialScanMode();
      }
      
      private function get doingSocialScan() : Boolean
      {
         return this.bDoingSocialScan;
      }
      
      private function set doingSocialScan(param1:Boolean) : void
      {
         this.bDoingSocialScan = param1;
         this.UpdateButtonData();
      }
      
      private function StartSocialScanMode() : void
      {
         this.socialSpellList.y = this.SocialList_OrigCenterY - this.socialSpellList.itemsShown * this.socialSpellList.GetClipByIndex(0).height / 2;
         this.socialSpellList.visible = true;
         this.doingSocialScan = true;
         this.socialSpellList.selectedIndex = 0;
         stage.focus = this.socialSpellList;
         (this.socialSpellList.parent as MovieClip).gotoAndPlay("SocialList");
         GlobalFunc.PlayMenuSound("UIMenuMonocleScannerNPCScanProcess");
         BSUIDataManager.dispatchCustomEvent(this.USE_LIST_CONTROLS,{"isShowing":true});
      }
      
      private function EndSocialScanMode() : void
      {
         this.doingSocialScan = false;
         stage.focus = null;
         this.socialSpellList.visible = false;
         (this.socialSpellList.parent as MovieClip).gotoAndPlay("Show");
         BSUIDataManager.dispatchCustomEvent(this.USE_LIST_CONTROLS,{"isShowing":false});
      }
      
      private function onSocialSpellCast() : void
      {
         if(this.socialSpellList.selectedEntry != null)
         {
            BSUIDataManager.dispatchCustomEvent("MonocleMenu_SocialSpell",{
               "selectedIndex":this.socialSpellList.selectedEntry.uSpellIndex,
               "isAvailable":this.socialSpellList.selectedEntry.bCastable
            });
         }
      }
      
      private function onCancelPressed() : void
      {
         if(this.doingSocialScan)
         {
            this.EndSocialScanMode();
         }
         else
         {
            this.doCloseMenu();
         }
      }
      
      private function doCloseMenu() : void
      {
         this.isMenuClosing = true;
         GlobalFunc.PlayMenuSound("UIMenuMonocleClose");
         if(this.CurrentPickRefType == this.PICK_TYPE_CONTAINER || this.CurrentPickRefType == this.PICK_TYPE_LOOSE_ITEM && this.UseItemCard)
         {
            BSUIDataManager.dispatchEvent(new Event(this.STOP_CONTAINER_VIEW));
         }
         gotoAndPlay("Close");
      }
      
      public function OnForceClose() : void
      {
         this.doCloseMenu();
      }
      
      private function onPlaceBeacon() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_Outpost"));
      }
      
      private function onSurfaceMap() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_SurfaceMap"));
         this.onCancelPressed();
      }
      
      private function onPhotoMode() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_PhotoMode"));
         this.onCancelPressed();
      }
      
      private function onZoomIn() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_ZoomIn"));
      }
      
      private function onZoomOut() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MonocleMenu_ZoomOut"));
      }
      
      private function onOpenAnimCompleteCallbk() : void
      {
         this.isMenuOpening = false;
         if(this.CurrentPickRefType == this.PICK_TYPE_CONTAINER && this.CurrentViewCastType == this.VIEW_CAST_TYPE_STANDARD || this.CurrentPickRefType == this.PICK_TYPE_LOOSE_ITEM && this.UseItemCard)
         {
            BSUIDataManager.dispatchEvent(new Event(this.START_CONTAINER_VIEW));
         }
      }
      
      private function onCloseAnimCompleteCallbk() : void
      {
         GlobalFunc.CloseMenu("MonocleMenu");
      }
      
      private function processFrameDelayedPick() : void
      {
         ++this.FrameDelayCounter;
         if(this.FrameDelayCounter >= this.PICK_FRAME_DELAY_LEN)
         {
            this.onPickDataUpdate(this.FrameDelayPickRefData);
            this.FrameDelayPickRefData = null;
            this.FrameDelayCounter = 0;
            removeEventListener(Event.ENTER_FRAME,this.processFrameDelayedPick);
         }
      }
      
      private function onPickDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:* = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = undefined;
         var _loc14_:uint = 0;
         var _loc15_:DynamicPoiIcon = null;
         var _loc16_:uint = 0;
         if(this.CurrentUsePickFrameDelay && param1.data.uFormID != this.CurrentFormID && this.FrameDelayCounter < this.PICK_FRAME_DELAY_LEN)
         {
            if(this.FrameDelayPickRefData == null)
            {
               addEventListener(Event.ENTER_FRAME,this.processFrameDelayedPick);
            }
            this.FrameDelayPickRefData = param1;
            return;
         }
         if(this.FrameDelayPickRefData != null)
         {
            this.FrameDelayPickRefData = null;
            this.FrameDelayCounter = 0;
            removeEventListener(Event.ENTER_FRAME,this.processFrameDelayedPick);
         }
         var _loc2_:Boolean = param1.data.uFormID != this.CurrentFormID || param1.data.uPickRefType != this.CurrentPickRefType;
         var _loc3_:String = "";
         var _loc4_:String = this.BuildDescriptionString(param1.data);
         var _loc5_:uint = this.CurrentViewCastType;
         this.CurrentUsePickFrameDelay = param1.data.bShouldApplyPickFrameDelay;
         this.CurrentPickRefType = param1.data.uPickRefType;
         this.CurrentViewCastType = param1.data.uScanType;
         this.PickRefIsScannable = param1.data.bIsScannable;
         this.PickRefIsScanned = param1.data.bIsDiscovered;
         this.UseItemCard = param1.data.bUseItemCard;
         this.HarvestButtonData.sButtonText = param1.data.sHarvestableString;
         this.HarvestButtonData.bEnabled = param1.data.bIsHarvestable;
         this.BioscanButtonData.bEnabled = this.PickRefIsScannable && !this.PickRefIsScanned;
         this.OpenDoorButtonData.sButtonText = param1.data.sDoorText;
         this.SocialScanButtonData.bEnabled = param1.data.bCanCastSocialSpells === true;
         switch(param1.data.uSocialType)
         {
            case this.SOCIAL_TYPE_NPC:
               this.SocialScanButtonData.sButtonText = "$SOCIAL";
               break;
            case this.SOCIAL_TYPE_XENOSOCIAL:
               this.SocialScanButtonData.sButtonText = "$SOCIAL_XENO";
               break;
            case this.SOCIAL_TYPE_HACK:
               this.SocialScanButtonData.sButtonText = "$SOCIAL_ROBOT";
               break;
            default:
               this.SocialScanButtonData.sButtonText = "";
         }
         if(_loc2_ && param1.data.sSoundToPlay.length > 0)
         {
            GlobalFunc.PlayMenuSound(param1.data.sSoundToPlay);
         }
         if((_loc6_ = this.GetRightInfoInternalClip(param1.data.uPickRefType)) != null)
         {
            switch(param1.data.uPickRefType)
            {
               case this.PICK_TYPE_RESOURCE:
                  _loc7_ = 20;
                  GlobalFunc.SetText(_loc6_.element_mc.symbol_tf,param1.data.sSymbol);
                  GlobalFunc.SetText(_loc6_.element_mc.name_tf,param1.data.sName,false,false,_loc7_);
                  GlobalFunc.SetText(_loc6_.description_mc.description_tf,_loc4_);
                  GlobalFunc.SetText(_loc6_.classification_mc.classification_tf,param1.data.sBioscanType);
                  _loc6_.Rarity_mc.gotoAndStop(param1.data.uScarcity + 1);
                  _loc6_.Tagged_mc.visible = param1.data.bIsTrackedForCrafting;
                  if(_loc2_)
                  {
                     (_loc13_ = new ColorTransform()).color = param1.data.uColor;
                     _loc6_.color_mc.transform.colorTransform = _loc13_;
                  }
                  break;
               case this.PICK_TYPE_FAUNA:
               case this.PICK_TYPE_FLORA:
               case this.PICK_TYPE_NPC:
               case this.PICK_TYPE_OBJECT:
               case this.PICK_TYPE_LOOSE_ITEM:
               case this.PICK_TYPE_CONTAINER:
               case this.PICK_TYPE_SPACESHIP:
               case this.PICK_TYPE_DOOR:
                  if(param1.data.uPickRefType == this.PICK_TYPE_FAUNA)
                  {
                     if(param1.data.bIsAlive === false)
                     {
                        _loc6_.DisplayName_mc.gotoAndStop("Dead");
                     }
                     else if(param1.data.bIsDiseased === true)
                     {
                        _loc6_.DisplayName_mc.gotoAndStop("Diseased");
                     }
                     else
                     {
                        _loc6_.DisplayName_mc.gotoAndStop("Alive");
                     }
                  }
                  else
                  {
                     _loc6_.DisplayName_mc.gotoAndStop(InventoryItemUtils.GetFrameLabelFromRarity(param1.data.uRarity));
                  }
                  GlobalFunc.SetText(_loc6_.DisplayName_mc.Name_mc.Text_tf,param1.data.sName,false,true,this.NAME_MAX_LENGTH);
                  _loc8_ = false;
                  _loc9_ = false;
                  if(param1.data.sBioscanType.length > 0)
                  {
                     GlobalFunc.SetText(_loc6_.TextHolder_mc.ScanObjectType_tf,param1.data.uScanTypeProgressPct + "% $$scanned\n$" + param1.data.sBioscanType);
                     _loc9_ = param1.data.uScanTypeProgressPct == 100;
                     _loc8_ = true;
                  }
                  else if(param1.data.uPickRefType == this.PICK_TYPE_OBJECT && this.LocationTraitRefsRequired > 0)
                  {
                     if(this.LocationTraitRefsScanned != this.LocationTraitRefsRequired)
                     {
                        GlobalFunc.SetText(_loc6_.TextHolder_mc.ScanObjectType_tf,this.LocationTraitRefsScanned + "/" + this.LocationTraitRefsRequired + " $$scanned");
                     }
                     else
                     {
                        GlobalFunc.SetText(_loc6_.TextHolder_mc.ScanObjectType_tf,"");
                        _loc9_ = true;
                     }
                     _loc8_ = true;
                  }
                  else
                  {
                     GlobalFunc.SetText(_loc6_.TextHolder_mc.ScanObjectType_tf,"");
                  }
                  this.CreateInfoTextClips(_loc6_.TextHolder_mc.InfoTextHolder_mc,param1.data.PickRefDetailsA);
                  _loc8_ ||= param1.data.PickRefDetailsA.length > 0;
                  this.RightInfoDisplay_mc.Bioscan_mc.Complete_mc.visible = _loc9_ && !this.doingSocialScan;
                  if(!_loc8_ && _loc6_.BG_mc.currentFrameLabel != "Hide")
                  {
                     _loc6_.BG_mc.gotoAndStop("Hide");
                  }
                  else if(_loc8_ && _loc6_.BG_mc.currentFrameLabel == "Hide")
                  {
                     _loc6_.BG_mc.gotoAndPlay("Show");
                  }
                  _loc10_ = 12;
                  _loc11_ = 5;
                  _loc12_ = _loc6_.DisplayName_mc.Name_mc.x + _loc6_.DisplayName_mc.Name_mc.Text_tf.textWidth + _loc10_;
                  _loc6_.DisplayName_mc.Contraband_mc.visible = param1.data.bIsContraband;
                  _loc6_.DisplayName_mc.Stealing_mc.visible = !param1.data.bIsContraband && param1.data.bIsStealing;
                  _loc6_.DisplayName_mc.Tagged_mc.visible = param1.data.bIsTrackedForCrafting;
                  if(_loc6_.DisplayName_mc.Contraband_mc.visible)
                  {
                     _loc6_.DisplayName_mc.Contraband_mc.x = _loc12_;
                     _loc12_ += _loc6_.DisplayName_mc.Contraband_mc.width + _loc11_;
                  }
                  if(_loc6_.DisplayName_mc.Stealing_mc.visible)
                  {
                     _loc6_.DisplayName_mc.Stealing_mc.x = _loc12_;
                     _loc12_ += _loc6_.DisplayName_mc.Stealing_mc.width + _loc11_;
                  }
                  if(_loc6_.DisplayName_mc.Tagged_mc.visible)
                  {
                     _loc6_.DisplayName_mc.Tagged_mc.x = _loc12_;
                     _loc12_ += _loc6_.DisplayName_mc.Tagged_mc.width + _loc11_;
                  }
                  break;
               case this.PICK_TYPE_MAP_MARKER:
                  _loc14_ = 35;
                  GlobalFunc.SetText(_loc6_.description_mc.description_tf,_loc4_,false,false,_loc14_);
                  _loc15_ = (_loc6_.Icon_mc as ScanMapMarker).internalIcon;
                  _loc16_ = MapMarkerUtils.LMS_ONLY_TYPE_KNOWN;
                  if(Boolean(param1.data.bIsDiscovered) || !param1.data.bIsScannable)
                  {
                     _loc16_ = MapMarkerUtils.LMS_FULL_REVEAL;
                  }
                  if(_loc15_.locationType != param1.data.uMapMarkerType || _loc15_.locationState != _loc16_)
                  {
                     _loc15_.ClearLocation();
                     _loc15_.SetLocation(param1.data.uMapMarkerType,param1.data.uMapMarkerCategory,_loc16_);
                     _loc15_.SetFrame(!!param1.data.bIsDiscovered ? "Discovered" : "Undiscovered");
                  }
                  this.CanFastTravel = param1.data.bCanFastTravel === true;
            }
         }
         if(_loc2_)
         {
            if(this.doingSocialScan)
            {
               this.EndSocialScanMode();
            }
            this.SetRightInfoDisplayState(param1.data.uPickRefType);
            if(!this.isMenuOpening && !this.isMenuClosing)
            {
               if(this.CurrentPickRefType == this.PICK_TYPE_CONTAINER && this.CurrentViewCastType == this.VIEW_CAST_TYPE_STANDARD || this.CurrentPickRefType == this.PICK_TYPE_LOOSE_ITEM && this.UseItemCard)
               {
                  BSUIDataManager.dispatchEvent(new Event(this.START_CONTAINER_VIEW));
               }
               else
               {
                  BSUIDataManager.dispatchEvent(new Event(this.STOP_CONTAINER_VIEW));
               }
            }
         }
         else if(this.CurrentViewCastType != _loc5_ && (this.CurrentPickRefType == this.PICK_TYPE_CONTAINER || this.CurrentPickRefType == this.PICK_TYPE_LOOSE_ITEM && this.UseItemCard))
         {
            if(!this.isMenuOpening && !this.isMenuClosing)
            {
               if(this.CurrentViewCastType == this.VIEW_CAST_TYPE_STANDARD || this.CurrentPickRefType == this.PICK_TYPE_LOOSE_ITEM && this.UseItemCard)
               {
                  BSUIDataManager.dispatchEvent(new Event(this.START_CONTAINER_VIEW));
               }
               else
               {
                  BSUIDataManager.dispatchEvent(new Event(this.STOP_CONTAINER_VIEW));
               }
            }
         }
         this.CurrentFormID = param1.data.uFormID;
         this.CurrentPickRefHandle = param1.data.uHandle;
         this.UpdateButtonData();
      }
      
      private function BuildDescriptionString(param1:Object) : String
      {
         var _loc3_:* = undefined;
         var _loc2_:* = "";
         for each(_loc3_ in param1.PickRefDetailsA)
         {
            if(_loc2_ != "")
            {
               _loc2_ += "\n";
            }
            _loc2_ += _loc3_;
         }
         return _loc2_;
      }
      
      private function CreateInfoTextClips(param1:DisplayObjectContainer, param2:Array) : void
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:TextField = null;
         while(param1.numChildren < param2.length)
         {
            param1.addChild(new BioscanInfoTextEntry());
         }
         while(param1.numChildren > param2.length)
         {
            param1.removeChildAt(0);
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 5;
         var _loc5_:Number = 6;
         var _loc6_:uint = 0;
         while(_loc6_ < param2.length)
         {
            _loc8_ = (_loc7_ = param1.getChildAt(_loc6_))["Text_tf"];
            GlobalFunc.SetText(_loc8_,param2[_loc6_]);
            _loc8_.height = _loc8_.textHeight + _loc4_;
            _loc7_.y = _loc3_;
            _loc3_ += _loc7_.height + _loc5_;
            _loc6_++;
         }
      }
      
      private function UpdateButtonData() : void
      {
         if(this.doingSocialScan)
         {
            this.ButtonBar_mc.AButton_mc.SetButtonData(this.SocialSpellButtonData);
            this.ButtonBar_mc.XButton_mc.SetButtonData(this.HiddenButtonData);
            this.ButtonBar_mc.SurfaceMapButton_mc.SetButtonData(this.HiddenButtonData);
            this.ButtonBar_mc.PhotoModeButton_mc.SetButtonData(this.HiddenButtonData);
            this.ButtonBar_mc.ZoomButton_mc.SetButtonData(this.HiddenButtonData);
         }
         else
         {
            switch(this.CurrentPickRefType)
            {
               case this.PICK_TYPE_RESOURCE:
               case this.PICK_TYPE_FLORA:
                  if(this.HarvestButtonData.bEnabled)
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.HarvestButtonData);
                  }
                  else if(this.CurrentPickRefType == this.PICK_TYPE_RESOURCE)
                  {
                     if(this.ResourceArc_mc.visible === false && this.PickRefIsScanned)
                     {
                        this.ButtonBar_mc.AButton_mc.SetButtonData(this.ShowResourcesButtonData);
                     }
                     else
                     {
                        this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                     }
                  }
                  else
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                  }
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  break;
               case this.PICK_TYPE_FAUNA:
                  if(this.SocialScanButtonData.sButtonText.length > 0 && !this.BioscanButtonData.bEnabled)
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.SocialScanButtonData);
                  }
                  else
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                  }
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  break;
               case this.PICK_TYPE_OBJECT:
                  this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  break;
               case this.PICK_TYPE_MAP_MARKER:
                  if(this.CanFastTravel)
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.FastTravelButtonData);
                  }
                  else
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                  }
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  break;
               case this.PICK_TYPE_LOOSE_ITEM:
                  if(this.UseItemCard && this.RolloverShowing)
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.ContainerTakeData);
                  }
                  else
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.HarvestButtonData);
                  }
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  break;
               case this.PICK_TYPE_CONTAINER:
                  if(this.CurrentViewCastType == this.VIEW_CAST_TYPE_STANDARD && this.RolloverShowing)
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.ContainerTakeData);
                     this.ButtonBar_mc.XButton_mc.SetButtonData(this.ContainerTransferData);
                  }
                  else
                  {
                     this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                     this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  }
                  break;
               case this.PICK_TYPE_NPC:
                  this.ButtonBar_mc.AButton_mc.SetButtonData(this.SocialScanButtonData);
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
                  break;
               case this.PICK_TYPE_DOOR:
                  this.ButtonBar_mc.AButton_mc.SetButtonData(this.OpenDoorButtonData);
                  break;
               default:
                  this.ButtonBar_mc.AButton_mc.SetButtonData(this.BioscanButtonData);
                  this.ButtonBar_mc.XButton_mc.SetButtonData(this.PlaceBeaconButtonData);
            }
            this.ButtonBar_mc.SurfaceMapButton_mc.SetButtonData(this.SurfaceMapButtonData);
            this.ButtonBar_mc.PhotoModeButton_mc.SetButtonData(this.PhotoModeButtonData);
            this.ButtonBar_mc.ZoomButton_mc.SetButtonData(this.ZoomButtonData);
         }
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function SetRightInfoDisplayState(param1:uint) : void
      {
         switch(param1)
         {
            case this.PICK_TYPE_NONE:
               this.RightInfoDisplay_mc.gotoAndStop("None");
               break;
            case this.PICK_TYPE_LOOSE_ITEM:
               if(this.UseItemCard)
               {
                  this.RightInfoDisplay_mc.gotoAndStop("None");
               }
               else
               {
                  this.RightInfoDisplay_mc.gotoAndStop("Bioscan");
                  this.RightInfoDisplay_mc.Bioscan_mc.gotoAndPlay("Show");
               }
               break;
            case this.PICK_TYPE_RESOURCE:
               this.RightInfoDisplay_mc.gotoAndStop("Resource");
               this.RightInfoDisplay_mc.Resource_mc.gotoAndPlay("Show");
               break;
            case this.PICK_TYPE_FAUNA:
            case this.PICK_TYPE_FLORA:
            case this.PICK_TYPE_NPC:
            case this.PICK_TYPE_OBJECT:
            case this.PICK_TYPE_CONTAINER:
            case this.PICK_TYPE_SPACESHIP:
            case this.PICK_TYPE_DOOR:
               this.RightInfoDisplay_mc.gotoAndStop("Bioscan");
               this.RightInfoDisplay_mc.Bioscan_mc.gotoAndPlay("Show");
               break;
            case this.PICK_TYPE_MAP_MARKER:
               this.RightInfoDisplay_mc.gotoAndStop("MapMarker");
               this.RightInfoDisplay_mc.MapMarkerInfo_mc.gotoAndPlay("Show");
         }
      }
      
      private function GetRightInfoInternalClip(param1:uint) : MovieClip
      {
         var _loc2_:MovieClip = null;
         switch(param1)
         {
            case this.PICK_TYPE_RESOURCE:
               _loc2_ = this.RightInfoDisplay_mc.Resource_mc;
               break;
            case this.PICK_TYPE_LOOSE_ITEM:
               if(!this.UseItemCard)
               {
                  _loc2_ = this.RightInfoDisplay_mc.Bioscan_mc;
               }
               break;
            case this.PICK_TYPE_FAUNA:
            case this.PICK_TYPE_FLORA:
            case this.PICK_TYPE_NPC:
            case this.PICK_TYPE_OBJECT:
            case this.PICK_TYPE_CONTAINER:
            case this.PICK_TYPE_SPACESHIP:
            case this.PICK_TYPE_DOOR:
               _loc2_ = this.RightInfoDisplay_mc.Bioscan_mc;
               break;
            case this.PICK_TYPE_MAP_MARKER:
               _loc2_ = this.RightInfoDisplay_mc.MapMarkerInfo_mc;
         }
         return _loc2_;
      }
      
      private function onMonocleDataUpdate(param1:FromClientDataEvent) : void
      {
         var updatedScannedTrait:*;
         var numOutposts:*;
         var newFrame:String = null;
         var getCurrFrame:Function = null;
         var MAX_TRAITS:uint = 0;
         var traitIdx:uint = 0;
         var traitClip:* = undefined;
         var currInfoClip:MovieClip = null;
         var arEvent:FromClientDataEvent = param1;
         if(arEvent.data.bShowPlanetInfo === false)
         {
            this.PlanetInfo_mc.visible = false;
         }
         else
         {
            this.PlanetInfo_mc.visible = true;
            GlobalFunc.SetText(this.PlanetInfo_mc.SurveyMeter_mc.Percent_tf,(arEvent.data.fSurveyPercentage * 100).toFixed(0) + "%");
            this.PlanetInfo_mc.SurveyMeter_mc.Meter_mc.Fill_mc.width = GlobalFunc.MapLinearlyToRange(0,this.PlanetInfo_mc.SurveyMeter_mc.Meter_mc.BG_mc.width,0,100,arEvent.data.fSurveyPercentage * 100,true);
            if(arEvent.data.fSurveyPercentage == 1)
            {
               if(this.StoredSurveyPercent != 0 && this.StoredSurveyPercent != arEvent.data.fSurveyPercentage)
               {
                  this.PlanetInfo_mc.SurveyedBanner_mc.gotoAndPlay("animStart");
               }
               else
               {
                  this.PlanetInfo_mc.SurveyedBanner_mc.gotoAndStop("shown");
               }
               this.PlanetInfo_mc.SurveyedBanner_mc.visible = true;
            }
            else
            {
               this.PlanetInfo_mc.SurveyedBanner_mc.visible = false;
            }
            this.StoredSurveyPercent = arEvent.data.fSurveyPercentage;
            newFrame = "Info_Resources";
            if(arEvent.data.uFaunaMax > 0 && arEvent.data.uFloraMax > 0)
            {
               newFrame = "Info_Fauna_Flora_Resources";
            }
            else if(arEvent.data.uFaunaMax > 0)
            {
               newFrame = "Info_Fauna_Resources";
            }
            else if(arEvent.data.uFloraMax > 0)
            {
               newFrame = "Info_Flora_Resources";
            }
            if(newFrame != this.PlanetInfo_mc.currentFrameLabel)
            {
               this.PlanetInfo_mc.gotoAndStop(newFrame);
            }
            getCurrFrame = function(param1:uint, param2:uint):String
            {
               return param1 == param2 ? "Complete" : "Standard";
            };
            newFrame = getCurrFrame(arEvent.data.uFaunaCurrent,arEvent.data.uFaunaMax);
            if(newFrame != this.PlanetInfo_mc.Fauna_mc.currentFrameLabel)
            {
               this.PlanetInfo_mc.Fauna_mc.gotoAndStop(newFrame);
            }
            newFrame = getCurrFrame(arEvent.data.uFloraCurrent,arEvent.data.uFloraMax);
            if(newFrame != this.PlanetInfo_mc.Flora_mc.currentFrameLabel)
            {
               this.PlanetInfo_mc.Flora_mc.gotoAndStop(newFrame);
            }
            newFrame = getCurrFrame(arEvent.data.uResourcesCurrent,arEvent.data.uResourcesMax);
            if(newFrame != this.PlanetInfo_mc.Resources_mc.currentFrameLabel)
            {
               this.PlanetInfo_mc.Resources_mc.gotoAndStop(newFrame);
            }
            this.PlanetInfo_mc.Fauna_mc.BiomeComplete_mc.visible = arEvent.data.bBiomeFaunaComplete === true;
            this.PlanetInfo_mc.Flora_mc.BiomeComplete_mc.visible = arEvent.data.bBiomeFloraComplete === true;
            GlobalFunc.SetText(this.PlanetInfo_mc.Fauna_mc.Value_mc.Text_tf,arEvent.data.uFaunaCurrent + "/" + arEvent.data.uFaunaMax);
            GlobalFunc.SetText(this.PlanetInfo_mc.Flora_mc.Value_mc.Text_tf,arEvent.data.uFloraCurrent + "/" + arEvent.data.uFloraMax);
            GlobalFunc.SetText(this.PlanetInfo_mc.Resources_mc.Value_mc.Text_tf,arEvent.data.uResourcesCurrent + "/" + arEvent.data.uResourcesMax);
            MAX_TRAITS = 5;
            traitIdx = 0;
            while(traitIdx < MAX_TRAITS)
            {
               traitClip = this.PlanetInfo_mc["Trait" + (traitIdx + 1) + "_mc"];
               if(traitClip != null)
               {
                  if(traitIdx < arEvent.data.aPlanetTraits.length)
                  {
                     traitClip.LoadIcon("",arEvent.data.aPlanetTraits[traitIdx]);
                     traitClip.visible = true;
                  }
                  else
                  {
                     traitClip.visible = false;
                  }
               }
               traitIdx++;
            }
         }
         GlobalFunc.SetText(this.MaxScannerRange_mc.Text_tf,"$$RANGE " + arEvent.data.uMaxScanDistance + "M");
         updatedScannedTrait = arEvent.data.uLocationTraitRefsScanned != this.LocationTraitRefsScanned;
         this.LocationTraitRefsScanned = arEvent.data.uLocationTraitRefsScanned;
         this.LocationTraitRefsRequired = arEvent.data.uLocationTraitRefsRequired;
         if(updatedScannedTrait && this.CurrentPickRefType == this.PICK_TYPE_OBJECT)
         {
            currInfoClip = this.GetRightInfoInternalClip(this.CurrentPickRefType);
            if(currInfoClip != null)
            {
               if(this.LocationTraitRefsScanned != this.LocationTraitRefsRequired)
               {
                  GlobalFunc.SetText(currInfoClip.TextHolder_mc.ScanObjectType_tf,this.LocationTraitRefsScanned + "/" + this.LocationTraitRefsRequired + " $$scanned");
               }
               else
               {
                  GlobalFunc.SetText(currInfoClip.TextHolder_mc.ScanObjectType_tf,"");
                  this.RightInfoDisplay_mc.Bioscan_mc.Complete_mc.visible = !this.bDoingSocialScan;
               }
            }
         }
         numOutposts = arEvent.data.uMaxOutposts - arEvent.data.uNumOutposts;
         this.PlaceBeaconButtonData.bEnabled = arEvent.data.bOutpostAllowed;
         this.PlaceBeaconButtonData.sButtonText = !!arEvent.data.bDecorateMode ? "$DECORATE" : "$$OUTPOST (" + numOutposts + ")";
         this.SurfaceMapButtonData.bEnabled = arEvent.data.bSurfaceMapAllowed;
         this.PhotoModeButtonData.bEnabled = arEvent.data.bPhotoModeAllowed;
         this.ZoomButtonData.bEnabled = arEvent.data.bScannerZoomAllowed;
         this.ZoomButtonData.bVisible = arEvent.data.bScannerZoomAllowed;
         this.UpdateButtonData();
         this.socialSpellList.InitializeEntries(arEvent.data.aSocialSpells);
      }
      
      private function onResourcesUpdate(param1:FromClientDataEvent) : void
      {
         this.ResourceArc_mc.SetResourceArcInfo(param1.data);
         if(param1.data.bShowArcOnUpdate === true)
         {
            this.ShowResourceArcAnim();
         }
      }
      
      private function ShowResourceArcAnim() : void
      {
         this.ResourceArc_mc.visible = true;
         this.ResourceArc_mc.Open();
         this.ResourceArcDisplayTimer.reset();
         this.ResourceArcDisplayTimer.start();
      }
      
      private function onFireForgetEvent(param1:FromClientDataEvent) : void
      {
         if(GlobalFunc.HasFireForgetEvent(param1.data,"MonocleMenu_OutpostOpening"))
         {
            this.onCancelPressed();
         }
      }
      
      private function onHUDActivationDataUpdate(param1:FromClientDataEvent) : void
      {
         if(param1.data.aButtons.length > 0 && Boolean(param1.data.aButtons[0].bPressAndRelease))
         {
            this.ContainerTakeData.sButtonText = param1.data.aButtons[0].sTextPressAndRelease;
            this.ContainerTakeData.bEnabled = param1.data.aButtons[0].bEnabled;
         }
         else
         {
            this.ContainerTakeData.sButtonText = "$TAKE";
            this.ContainerTakeData.bEnabled = false;
         }
         if(param1.data.aButtons.length > 1 && Boolean(param1.data.aButtons[1].bPressAndRelease))
         {
            this.ContainerTransferData.sButtonText = param1.data.aButtons[1].sTextPressAndRelease;
            this.ContainerTransferData.bEnabled = param1.data.aButtons[1].bEnabled;
         }
         else
         {
            this.ContainerTransferData.sButtonText = "$QuickContainerTransfer";
            this.ContainerTransferData.bEnabled = false;
         }
         this.RolloverShowing = param1.data.bShowRolloverActivation;
         this.UpdateButtonData();
      }
      
      private function onNewEvent(param1:FromClientDataEvent) : void
      {
         switch(param1.data.uType)
         {
            case this.EVENT_TYPE_SCAN_FULLY_COMPLETE:
               this.RightInfoDisplay_mc.Bioscan_mc.Complete_mc.gotoAndPlay("fadeIn");
         }
      }
      
      private function onResourceDisplayTimerDone() : void
      {
         this.ResourceArc_mc.Close();
      }
      
      private function onResourceCloseAnimComplete() : void
      {
         this.ResourceArc_mc.visible = false;
         this.UpdateButtonData();
      }
      
      private function onMonocleFreqDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.FrameDelayPickRefData == null)
         {
            if(param1.data.iScanDistance == -1)
            {
               GlobalFunc.SetText(this.range_mc.range_tf,"---");
            }
            else
            {
               GlobalFunc.SetText(this.range_mc.range_tf,param1.data.iScanDistance + "M");
            }
         }
         var _loc2_:String = String(param1.data.sCurrentNearbyMarker);
         if(_loc2_ != null && _loc2_ != this.CurrentPOIName)
         {
            this.CurrentPOIName = param1.data.sCurrentNearbyMarker;
            GlobalFunc.SetText(this.NearbyPOIDisplay_mc.location_mc.LocationName_tf,this.CurrentPOIName);
            if(this.CurrentPOIName.length > 0)
            {
               this.NearbyPOIDisplay_mc.gotoAndPlay("Show");
            }
            else
            {
               this.NearbyPOIDisplay_mc.gotoAndPlay("Hide");
            }
         }
         this.OuterCircle_mc.gotoAndStop("Distortion" + String(param1.data.uDistortionLevel));
      }
      
      private function onFastTravel() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MonocleMenu_FastTravel",{"toRef":this.CurrentPickRefHandle}));
      }
   }
}
