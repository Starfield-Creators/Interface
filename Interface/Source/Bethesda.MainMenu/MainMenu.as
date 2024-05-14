package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ContentLoaders.ImageLoaderClip;
   import Shared.Components.SystemPanels.IPanel;
   import Shared.Components.SystemPanels.LoadPanel;
   import Shared.Components.SystemPanels.MainPanel;
   import Shared.Components.SystemPanels.PanelUtils;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   
   public class MainMenu extends IMenu
   {
      
      private static const TIME_TO_HIDE_PROGRESS_BAR_AFTER_COMPLETION:Number = 1000;
      
      public static const BUTTON_SPACING:uint = 10;
      
      public static const LEGAL_SCREEN_COMPLETE:String = "FadeOutFinished";
      
      public static const STANDARD_SIZE_FRAME:String = "Standard";
      
      public static const LARGE_SIZE_FRAME:String = "Large";
      
      public static const LOAD_PANEL_OFFSET:Number = 150;
       
      
      public var MainPanel_mc:MainMenu_MainPanel;
      
      public var LoadPanel_mc:MainMenu_LoadPanel;
      
      public var SettingsPanel_mc:MainMenu_SettingsPanel;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Spinner_mc:MovieClip;
      
      public var BlackLoading_mc:MovieClip;
      
      public var VersionText_mc:MovieClip;
      
      public var BethesdaLogo_mc:MovieClip;
      
      public var EngagementPrompt_mc:MovieClip;
      
      public var GamerTag_mc:MovieClip;
      
      public var GamerIcon_mc:ImageLoaderClip;
      
      public var GameLogo_mc:MovieClip;
      
      public var MOTDHolder_mc:MovieClip;
      
      public var BuildingShaders_mc:MovieClip;
      
      public var PSE_mc:MovieClip;
      
      private var ActivePanel:IPanel = null;
      
      private var CurrentState:uint;
      
      private var LogoShowing:Boolean;
      
      private var LegalScreenShown:Boolean = false;
      
      private var UseLargeInterface:Boolean = false;
      
      private var MOTDEnabled:Boolean = false;
      
      private var ShaderProgressWidth:Number = 0;
      
      private var TotalPipelinesToGenerate:uint = 0;
      
      private var BethesdaLogoFinished:Boolean = false;
      
      private var ShadersBuilding:Boolean = false;
      
      private var CanShowEngagement:Boolean = true;
      
      private var HideProgressBarTimer:Timer;
      
      private var _gamerTag:String = "";
      
      private var LoadPanelStartX:Number = 0;
      
      private const MMS_INITIAL_LOAD:int = EnumHelper.GetEnum(0);
      
      private const MMS_OPEN_FROM_STARTUP:int = EnumHelper.GetEnum();
      
      private const MMS_OPEN_FROM_INSTALL:int = EnumHelper.GetEnum();
      
      private const MMS_LEGAL_SCREEN:int = EnumHelper.GetEnum();
      
      private const MMS_INTRO_VIDEO:int = EnumHelper.GetEnum();
      
      private const MMS_OPEN_FROM_RESET:int = EnumHelper.GetEnum();
      
      private const MMS_WAITING_ON_LOAD:int = EnumHelper.GetEnum();
      
      private const MMS_SPLASH_SCREEN:int = EnumHelper.GetEnum();
      
      private const MMS_ENGAGEMENT_PROMPT:int = EnumHelper.GetEnum();
      
      private const MMS_MAIN_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const MMS_LOAD_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const MMS_SETTINGS_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const MMS_CONFIRMING_ACTION:int = EnumHelper.GetEnum();
      
      private const MMS_PERFORMING_ACTION:int = EnumHelper.GetEnum();
      
      private const MMS_OTHER_MENU_OPEN:int = EnumHelper.GetEnum();
      
      private const MMA_NONE:int = EnumHelper.GetEnum(0);
      
      private const MMA_CONTINUE_GAME:int = EnumHelper.GetEnum();
      
      private const MMA_NEW_GAME:int = EnumHelper.GetEnum();
      
      private const MMA_LOAD_PANEL:int = EnumHelper.GetEnum();
      
      private const MMA_SETTINGS_PANEL:int = EnumHelper.GetEnum();
      
      private const MMA_PHOTO_GALLERY:int = EnumHelper.GetEnum();
      
      private const MMA_SHOW_CREDITS:int = EnumHelper.GetEnum();
      
      private const MMA_QUIT_GAME:int = EnumHelper.GetEnum();
      
      public function MainMenu()
      {
         super();
         this.CurrentState = this.MMS_INITIAL_LOAD;
         this.LogoShowing = true;
         this.MainPanel_mc.visible = false;
         this.LoadPanel_mc.visible = false;
         this.SettingsPanel_mc.visible = false;
         this.Spinner_mc.visible = false;
         this.BlackLoading_mc.visible = false;
         this.VersionText_mc.visible = false;
         this.BethesdaLogo_mc.visible = false;
         this.EngagementPrompt_mc.visible = false;
         this.GamerTag_mc.visible = false;
         this.GamerIcon_mc.visible = false;
         this.GamerIcon_mc.loadingClassName = "GamerIconLoading";
         this.GamerIcon_mc.errorClassName = "GamerIconError";
         this.BuildingShaders_mc.visible = false;
         this.ShaderProgressWidth = this.BuildingShaders_mc.Meter_mc.Fill_mc.width;
         this.HideProgressBarTimer = new Timer(TIME_TO_HIDE_PROGRESS_BAR_AFTER_COMPLETION,1);
         this.HideProgressBarTimer.addEventListener(TimerEvent.TIMER,this.OnHideProgressBar);
         this.LoadPanelStartX = this.LoadPanel_mc.x;
         addEventListener(PanelUtils.ACTIVE_LIST_CHANGED,this.UpdateFocus);
         addEventListener(PanelUtils.CLOSE_PANEL,this.onSubPanelClose);
         addEventListener(MainPanel.MAIN_PANEL_PRESS,this.onMainPanelEntryPressed);
         addEventListener(MainPanel.MAIN_PANEL_CONFIRM,this.onMainPanelActionConfirmed);
         addEventListener(MainPanel.MAIN_PANEL_CANCEL,this.onMainPanelActionCanceled);
         addEventListener(LoadPanel.LOAD_PANEL_PRESS,this.onLoadPanelEntryPressed);
         addEventListener(LoadPanel.LOAD_PANEL_CONFIRM,this.onLoadPanelConfirmLoad);
         addEventListener(LoadPanel.LOAD_PANEL_CANCEL,this.onLoadPanelCancelLoad);
         addEventListener(LoadPanel.LOAD_PANEL_DELETE,this.onLoadPanelDeleteSave);
         addEventListener(LoadPanel.LOAD_PANEL_SET_CHARACTER,this.onLoadPanelSetCharacter);
         addEventListener(LoadPanel.LOAD_PANEL_UPLOAD_SAVE,this.onLoadPanelUploadSave);
         addEventListener(LEGAL_SCREEN_COMPLETE,this.LegalScreenComplete);
         this.PopulateButtonBar();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("MainMenuPipelineProgressData",this.OnPipelineProgressData);
         BSUIDataManager.Subscribe("MainMenuStateData",this.OnStateDataUpdate);
         BSUIDataManager.Subscribe("MainMenuListData",this.OnMainListDataUpdate);
         BSUIDataManager.Subscribe("MainMenuConfirmationData",this.OnConfirmationDataUpdate);
         BSUIDataManager.Subscribe("LoadSavePanelData",this.OnLoadSaveDataUpdate);
         BSUIDataManager.Subscribe("MainMenuMOTDData",this.OnMOTDDataUpdate);
         BSUIDataManager.Subscribe("MainMenuGamerInfoData",this.OnGamerInfoDataUpdate);
         BSUIDataManager.Subscribe("GraphicsInfoData",function(param1:FromClientDataEvent):*
         {
            Extensions.enabled = true;
            SettingsPanel_mc.SetBackground(Extensions.visibleRect.x,Extensions.visibleRect.y,Extensions.visibleRect.width,Extensions.visibleRect.height);
         });
         BSUIDataManager.Subscribe("FireForgetEventData",function(param1:FromClientDataEvent):*
         {
            if(GlobalFunc.HasFireForgetEvent(param1.data,"MainMenu_LogoFinishedPlaying"))
            {
               BethesdaLogoFinished = true;
               if(ShadersBuilding)
               {
                  BuildingShaders_mc.visible = true;
                  CanShowEngagement = false;
               }
               else
               {
                  CanShowEngagement = true;
                  UpdateComponentsVisibility();
               }
            }
         });
      }
      
      private function PopulateButtonBar() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.MainPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.LoadPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.SettingsPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
      }
      
      private function UpdateGameLogo(param1:Boolean) : void
      {
         if(!this.LogoShowing && param1)
         {
            this.GameLogo_mc.gotoAndPlay("rollOnShort");
            this.LogoShowing = true;
         }
         else if(this.LogoShowing && !param1)
         {
            this.GameLogo_mc.gotoAndPlay("rollOff");
            this.LogoShowing = false;
         }
      }
      
      private function UpdateComponentsVisibility() : void
      {
         var _loc1_:* = this.CurrentState == this.MMS_WAITING_ON_LOAD;
         var _loc2_:* = this.CurrentState == this.MMS_SPLASH_SCREEN;
         var _loc3_:* = this.CurrentState == this.MMS_ENGAGEMENT_PROMPT;
         var _loc4_:* = this.CurrentState == this.MMS_MAIN_PANEL_INTERACT;
         var _loc5_:* = this.CurrentState == this.MMS_LOAD_PANEL_INTERACT;
         var _loc6_:* = this.CurrentState == this.MMS_SETTINGS_PANEL_INTERACT;
         var _loc7_:* = this.CurrentState == this.MMS_CONFIRMING_ACTION;
         var _loc8_:* = this.CurrentState == this.MMS_PERFORMING_ACTION;
         var _loc9_:* = this.CurrentState == this.MMS_OTHER_MENU_OPEN;
         var _loc10_:* = this.CurrentState == this.MMS_LEGAL_SCREEN;
         var _loc11_:* = this.CurrentState == this.MMS_INTRO_VIDEO;
         var _loc12_:Boolean = this.MainPanel_mc.visible;
         this.MainPanel_mc.SetListInteractive(_loc4_);
         if(_loc4_ || _loc5_ || _loc6_ || (_loc1_ || _loc7_ || _loc8_) && _loc12_)
         {
            this.MainPanel_mc.Open();
            this.ActivePanel = this.MainPanel_mc;
         }
         else
         {
            this.MainPanel_mc.Close();
         }
         _loc12_ = this.LoadPanel_mc.visible;
         if(_loc5_ || (_loc1_ || _loc7_ || _loc8_) && _loc12_)
         {
            this.LoadPanel_mc.Open();
            this.ActivePanel = this.LoadPanel_mc;
         }
         else if(_loc7_ && this.MainPanel_mc.currentAction == this.MMA_CONTINUE_GAME)
         {
            this.LoadPanel_mc.DisplayContinueInfo();
         }
         else
         {
            this.LoadPanel_mc.Close();
         }
         _loc12_ = this.SettingsPanel_mc.visible;
         if(_loc6_ || (_loc1_ || _loc7_ || _loc8_) && _loc12_)
         {
            this.SettingsPanel_mc.Open();
            this.ActivePanel = this.SettingsPanel_mc;
         }
         else
         {
            this.SettingsPanel_mc.Close();
         }
         this.Spinner_mc.visible = _loc1_ || _loc8_;
         this.BlackLoading_mc.visible = false;
         _loc12_ = this.VersionText_mc.visible;
         this.VersionText_mc.visible = _loc6_ || (_loc1_ || _loc7_ || _loc8_) && _loc12_;
         _loc12_ = this.BethesdaLogo_mc.visible;
         this.BethesdaLogo_mc.visible = _loc4_ || _loc5_ || _loc6_ || (_loc1_ || _loc7_ || _loc8_) && _loc12_;
         this.EngagementPrompt_mc.visible = _loc3_ && this.CanShowEngagement;
         this.GamerTag_mc.visible = !_loc1_ && !_loc2_ && !_loc3_;
         this.GamerIcon_mc.visible = !_loc1_ && !_loc2_ && !_loc3_;
         var _loc13_:Boolean = !_loc5_ && !_loc6_ && !_loc7_ && !_loc8_ && !_loc9_ || _loc7_ && (this.MainPanel_mc.currentAction == this.MMA_NEW_GAME || this.MainPanel_mc.currentAction == this.MMA_QUIT_GAME) || _loc8_ && (this.MainPanel_mc.currentAction == this.MMA_NEW_GAME || this.MainPanel_mc.currentAction == this.MMA_QUIT_GAME);
         this.UpdateGameLogo(_loc13_);
         this.MOTDHolder_mc.visible = _loc4_ && this.MOTDEnabled;
         if(!this.LegalScreenShown && _loc10_)
         {
            this.PSE_mc.gotoAndPlay("rollOn");
            this.LegalScreenShown = true;
         }
         this.UpdateFocus();
      }
      
      private function UpdateFocus() : void
      {
         stage.focus = null;
         if(this.ActivePanel != null)
         {
            stage.focus = this.ActivePanel.activeList;
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && this.ActivePanel != null)
         {
            _loc3_ = this.ActivePanel.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function OnHideProgressBar() : *
      {
         this.BuildingShaders_mc.visible = false;
      }
      
      private function OnStateDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.UseLargeInterface != param1.data.bUseLargeInterface)
         {
            this.UseLargeInterface = param1.data.bUseLargeInterface;
            this.VersionText_mc.gotoAndStop(this.UseLargeInterface ? LARGE_SIZE_FRAME : STANDARD_SIZE_FRAME);
            this.GamerTag_mc.gotoAndStop(this.UseLargeInterface ? LARGE_SIZE_FRAME : STANDARD_SIZE_FRAME);
            GlobalFunc.SetText(this.GamerTag_mc.Text_mc.GamerTagText_tf,this._gamerTag);
            this.MOTDHolder_mc.MOTD_mc.UpdateSize(this.UseLargeInterface);
            this.MainPanel_mc.UpdateSize(this.UseLargeInterface);
            this.LoadPanel_mc.UpdateSize(this.UseLargeInterface);
            this.SettingsPanel_mc.UpdateSize(this.UseLargeInterface);
            this.LoadPanel_mc.x = this.UseLargeInterface ? this.LoadPanelStartX + LOAD_PANEL_OFFSET : this.LoadPanelStartX;
         }
         if(this.CurrentState != param1.data.uCurrentState)
         {
            if(this.CurrentState == this.MMS_CONFIRMING_ACTION)
            {
               this.MainPanel_mc.ClearConfirmPrompt();
            }
            this.CurrentState = param1.data.uCurrentState;
            this.UpdateComponentsVisibility();
         }
         if((this.CurrentState == this.MMS_SPLASH_SCREEN || this.CurrentState == this.MMS_OPEN_FROM_RESET) && currentFrame == 1)
         {
            this.GameLogo_mc.gotoAndPlay("rollOn");
         }
         GlobalFunc.SetText(this.VersionText_mc.Text_mc.VersionText_tf,param1.data.sVersionText);
         this.SettingsPanel_mc.SetVersion(param1.data.sVersionText);
      }
      
      private function OnMainListDataUpdate(param1:FromClientDataEvent) : void
      {
         this.MainPanel_mc.PopulateMainList(param1.data.aMainMenuList);
      }
      
      private function OnConfirmationDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.ActivePanel != null)
         {
            this.ActivePanel.OnConfirmDataUpdate(param1.data.bCanConfirm);
         }
      }
      
      private function OnLoadSaveDataUpdate(param1:FromClientDataEvent) : void
      {
         this.LoadPanel_mc.UpdateLoadData(param1.data);
      }
      
      private function OnMOTDDataUpdate(param1:FromClientDataEvent) : void
      {
         this.MOTDEnabled = param1.data.bShowMessage;
         this.MOTDHolder_mc.MOTD_mc.UpdateData(param1.data);
         this.MOTDHolder_mc.visible = this.CurrentState == this.MMS_MAIN_PANEL_INTERACT && this.MOTDEnabled;
      }
      
      private function OnGamerInfoDataUpdate(param1:FromClientDataEvent) : void
      {
         this._gamerTag = param1.data.sGamerTag;
         GlobalFunc.SetText(this.GamerTag_mc.Text_mc.GamerTagText_tf,this._gamerTag);
         if(param1.data.sGamerIcon != "")
         {
            this.GamerIcon_mc.LoadImage(param1.data.sGamerIcon);
         }
         else
         {
            this.GamerIcon_mc.Unload();
         }
      }
      
      private function OnPipelineProgressData(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1.data.ShowPipelineGenerationProgress)
         {
            this.BuildingShaders_mc.visible = this.BethesdaLogoFinished;
            this.ShadersBuilding = true;
            this.HideProgressBarTimer.stop();
            _loc2_ = param1.data.uTotalNumOfPipelinesToGenerate - param1.data.uNumOfRemainingPipelines;
            this.TotalPipelinesToGenerate = param1.data.uTotalNumOfPipelinesToGenerate > 0 ? uint(param1.data.uTotalNumOfPipelinesToGenerate) : 1;
            GlobalFunc.SetText(this.BuildingShaders_mc.Amount_tf,_loc2_.toString() + "/" + this.TotalPipelinesToGenerate.toString());
            this.BuildingShaders_mc.Meter_mc.Fill_mc.width = Math.min(this.ShaderProgressWidth,_loc2_ / this.TotalPipelinesToGenerate * this.ShaderProgressWidth);
         }
         else
         {
            if(this.BuildingShaders_mc.visible)
            {
               this.HideProgressBarTimer.stop();
               this.HideProgressBarTimer.reset();
               this.HideProgressBarTimer.start();
               GlobalFunc.SetText(this.BuildingShaders_mc.Amount_tf,this.TotalPipelinesToGenerate.toString() + "/" + this.TotalPipelinesToGenerate.toString());
               this.BuildingShaders_mc.Meter_mc.Fill_mc.width = this.ShaderProgressWidth;
            }
            this.ShadersBuilding = false;
            if(!this.CanShowEngagement)
            {
               this.CanShowEngagement = true;
               this.UpdateComponentsVisibility();
            }
         }
      }
      
      private function onSubPanelClose() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MainMenu_ActionCanceled"));
      }
      
      private function onMainPanelEntryPressed(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MainMenu_StartAction",{"actionType":param1.params.entryAction}));
      }
      
      private function onMainPanelActionConfirmed() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MainMenu_ActionConfirmed"));
      }
      
      private function onMainPanelActionCanceled() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MainMenu_ActionCanceled"));
      }
      
      private function onLoadPanelEntryPressed(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MainMenu_StartLoad",{"index":param1.params.loadIndex}));
      }
      
      private function onLoadPanelConfirmLoad() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MainMenu_ConfirmLoad"));
      }
      
      private function onLoadPanelDeleteSave(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MainMenu_DeleteSave",{"index":param1.params.deleteIndex}));
      }
      
      private function onLoadPanelCancelLoad() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MainMenu_ActionCanceled"));
      }
      
      private function onLoadPanelSetCharacter(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MainMenu_SetCharacter",{"characterID":param1.params.characterID}));
      }
      
      private function onLoadPanelUploadSave(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("MainMenu_UploadSave",{"index":param1.params.loadIndex}));
      }
      
      private function LegalScreenComplete() : void
      {
         BSUIDataManager.dispatchEvent(new Event("MainMenu_LegalScreenComplete"));
      }
   }
}
