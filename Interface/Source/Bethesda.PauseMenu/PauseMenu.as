package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.SystemPanels.HelpPanel;
   import Shared.Components.SystemPanels.IPanel;
   import Shared.Components.SystemPanels.LoadPanel;
   import Shared.Components.SystemPanels.MainPanel;
   import Shared.Components.SystemPanels.PanelUtils;
   import Shared.Components.SystemPanels.SavePanel;
   import Shared.Components.SystemPanels.SettingsPanel;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   
   public class PauseMenu extends IMenu
   {
      
      public static const BUTTON_SPACING:uint = 10;
       
      
      public var MainPanel_mc:MainPanel;
      
      public var SavePanel_mc:SavePanel;
      
      public var LoadPanel_mc:LoadPanel;
      
      public var HelpPanel_mc:HelpPanel;
      
      public var SettingsPanel_mc:SettingsPanel;
      
      public var Background_mc:MovieClip;
      
      public var Spinner_mc:MovieClip;
      
      public var BlackLoading_mc:MovieClip;
      
      public var VersionText_tf:TextField;
      
      public var GameLogo_mc:MovieClip;
      
      private var ActivePanel:IPanel = null;
      
      private var CurrentState:int;
      
      private var LogoShowing:Boolean;
      
      private var AllowQuitToDesktop:Boolean;
      
      private const PMS_MAIN_PANEL_INTERACT:int = EnumHelper.GetEnum(0);
      
      private const PMS_SAVE_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const PMS_LOAD_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const PMS_HELP_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const PMS_SETTINGS_PANEL_INTERACT:int = EnumHelper.GetEnum();
      
      private const PMS_CONFIRMING_ACTION:int = EnumHelper.GetEnum();
      
      private const PMS_PERFORMING_ACTION:int = EnumHelper.GetEnum();
      
      private const PMA_NONE:int = EnumHelper.GetEnum(0);
      
      private const PMA_QUICKSAVE:int = EnumHelper.GetEnum();
      
      private const PMA_SAVE_PANEL:int = EnumHelper.GetEnum();
      
      private const PMA_LOAD_PANEL:int = EnumHelper.GetEnum();
      
      private const PMA_HELP_PANEL:int = EnumHelper.GetEnum();
      
      private const PMA_SETTINGS_PANEL:int = EnumHelper.GetEnum();
      
      private const PMA_PHOTO_MODE:int = EnumHelper.GetEnum();
      
      private const PMA_PHOTO_GALLERY:int = EnumHelper.GetEnum();
      
      private const PMA_RETURN_TO_GAME:int = EnumHelper.GetEnum();
      
      private const PMA_QUIT_GAME:int = EnumHelper.GetEnum();
      
      public function PauseMenu()
      {
         super();
         this.HelpPanel_mc.ConfigureLists();
         this.CurrentState = -1;
         this.LogoShowing = true;
         this.SavePanel_mc.visible = false;
         this.LoadPanel_mc.visible = false;
         this.HelpPanel_mc.visible = false;
         this.SettingsPanel_mc.visible = false;
         this.Spinner_mc.visible = false;
         this.BlackLoading_mc.visible = false;
         this.VersionText_tf.visible = false;
         addEventListener(PanelUtils.ACTIVE_LIST_CHANGED,this.UpdateFocus);
         addEventListener(PanelUtils.CLOSE_PANEL,this.onSubPanelClose);
         addEventListener(MainPanel.MAIN_PANEL_PRESS,this.onMainPanelEntryPressed);
         addEventListener(MainPanel.MAIN_PANEL_CONFIRM,this.onMainPanelActionConfirmed);
         addEventListener(MainPanel.MAIN_PANEL_Y_BTN,this.onMainPanelYButton);
         addEventListener(MainPanel.MAIN_PANEL_CANCEL,this.onMainPanelActionCanceled);
         addEventListener(SavePanel.SAVE_PANEL_CONFIRM,this.onSavePanelConfirmSave);
         addEventListener(SavePanel.SAVE_PANEL_DELETE,this.onPanelDeleteSave);
         addEventListener(SavePanel.SAVE_PANEL_SET_CHARACTER,this.onLoadOrSavePanelSetCharacter);
         addEventListener(LoadPanel.LOAD_PANEL_PRESS,this.onLoadPanelEntryPressed);
         addEventListener(LoadPanel.LOAD_PANEL_CONFIRM,this.onLoadPanelConfirmLoad);
         addEventListener(LoadPanel.LOAD_PANEL_DELETE,this.onPanelDeleteSave);
         addEventListener(LoadPanel.LOAD_PANEL_SET_CHARACTER,this.onLoadOrSavePanelSetCharacter);
         addEventListener(LoadPanel.LOAD_PANEL_UPLOAD_SAVE,this.onLoadPanelUploadSave);
         this.PopulateButtonBar();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("PauseMenuStateData",this.OnStateDataUpdate);
         BSUIDataManager.Subscribe("PauseMenuListData",this.OnPauseListDataUpdate);
         BSUIDataManager.Subscribe("PauseMenuConfirmationData",this.OnConfirmationDataUpdate);
         BSUIDataManager.Subscribe("LoadSavePanelData",this.OnLoadSaveDataUpdate);
         BSUIDataManager.Subscribe("HelpPanelData",this.OnHelpDataUpdate);
         BSUIDataManager.Subscribe("GraphicsInfoData",function(param1:FromClientDataEvent):*
         {
            Extensions.enabled = true;
            Background_mc.x = Extensions.visibleRect.x;
            Background_mc.y = Extensions.visibleRect.y;
            Background_mc.width = Extensions.visibleRect.width;
            Background_mc.height = Extensions.visibleRect.height;
            SettingsPanel_mc.SetBackground(Extensions.visibleRect.x,Extensions.visibleRect.y,Extensions.visibleRect.width,Extensions.visibleRect.height);
         });
      }
      
      private function PopulateButtonBar() : void
      {
         this.MainPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.SavePanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.LoadPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.HelpPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_RIGHT,BUTTON_SPACING);
         this.SettingsPanel_mc.PopulateButtonBar(ButtonBar.JUSTIFY_CENTER,BUTTON_SPACING);
         this.MainPanel_mc.SetYButtonLabel("$DESKTOP");
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
         var _loc3_:* = false;
         var _loc1_:* = this.CurrentState == this.PMS_MAIN_PANEL_INTERACT;
         var _loc2_:* = this.CurrentState == this.PMS_SAVE_PANEL_INTERACT;
         _loc3_ = this.CurrentState == this.PMS_LOAD_PANEL_INTERACT;
         var _loc4_:* = this.CurrentState == this.PMS_HELP_PANEL_INTERACT;
         var _loc5_:* = this.CurrentState == this.PMS_SETTINGS_PANEL_INTERACT;
         var _loc6_:* = this.CurrentState == this.PMS_CONFIRMING_ACTION;
         var _loc7_:* = this.CurrentState == this.PMS_PERFORMING_ACTION;
         var _loc8_:Boolean = this.MainPanel_mc.visible;
         this.MainPanel_mc.SetListInteractive(_loc1_);
         if(_loc1_ || _loc2_ || _loc3_ || _loc5_ || (_loc6_ || _loc7_) && _loc8_)
         {
            this.MainPanel_mc.Open();
            this.ActivePanel = this.MainPanel_mc;
            if(_loc6_ && this.MainPanel_mc.currentAction == this.PMA_QUIT_GAME)
            {
               this.MainPanel_mc.UpdateYButton(this.AllowQuitToDesktop);
            }
            else
            {
               this.MainPanel_mc.UpdateYButton(false);
            }
         }
         else
         {
            this.MainPanel_mc.Close();
         }
         _loc8_ = this.SavePanel_mc.visible;
         if(_loc2_ || (_loc6_ || _loc7_) && _loc8_)
         {
            this.SavePanel_mc.Open();
            this.ActivePanel = this.SavePanel_mc;
         }
         else
         {
            this.SavePanel_mc.Close();
         }
         _loc8_ = this.LoadPanel_mc.visible;
         if(_loc3_ || (_loc6_ || _loc7_) && _loc8_)
         {
            this.LoadPanel_mc.Open();
            this.ActivePanel = this.LoadPanel_mc;
         }
         else
         {
            this.LoadPanel_mc.Close();
         }
         if(_loc4_)
         {
            this.HelpPanel_mc.Open();
            this.ActivePanel = this.HelpPanel_mc;
         }
         else
         {
            this.HelpPanel_mc.Close();
         }
         _loc8_ = this.SettingsPanel_mc.visible;
         if(_loc5_ || (_loc6_ || _loc7_) && _loc8_)
         {
            this.SettingsPanel_mc.Open();
            this.ActivePanel = this.SettingsPanel_mc;
         }
         else
         {
            this.SettingsPanel_mc.Close();
         }
         this.Spinner_mc.visible = _loc7_;
         this.BlackLoading_mc.visible = false;
         _loc8_ = this.VersionText_tf.visible;
         this.VersionText_tf.visible = _loc5_ || (_loc6_ || _loc7_) && _loc8_;
         var _loc9_:Boolean = !_loc2_ && !_loc3_ && !_loc4_ && !_loc5_ && !_loc6_ && !_loc7_ || _loc6_ && this.MainPanel_mc.currentAction == this.PMA_QUIT_GAME || _loc7_ && this.MainPanel_mc.currentAction == this.PMA_QUIT_GAME;
         this.UpdateGameLogo(_loc9_);
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
         if(!_loc3_ && this.ActivePanel != null)
         {
            _loc3_ = this.ActivePanel.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function OnRightStickInput(param1:Number, param2:Number) : *
      {
         if(this.ActivePanel == this.HelpPanel_mc)
         {
            this.HelpPanel_mc.ProcessStickData(param2);
         }
      }
      
      private function OnStateDataUpdate(param1:FromClientDataEvent) : void
      {
         if(this.CurrentState != param1.data.uCurrentState)
         {
            if(this.CurrentState == this.PMS_CONFIRMING_ACTION)
            {
               this.MainPanel_mc.ClearConfirmPrompt();
            }
            this.CurrentState = param1.data.uCurrentState;
            this.UpdateComponentsVisibility();
            GlobalFunc.SetText(this.VersionText_tf,param1.data.sVersionText);
            this.SettingsPanel_mc.SetVersion(param1.data.sVersionText);
         }
      }
      
      private function OnPauseListDataUpdate(param1:FromClientDataEvent) : void
      {
         this.MainPanel_mc.PopulateMainList(param1.data.aPauseMenuList);
         this.AllowQuitToDesktop = param1.data.bAllowQuitToDesktop;
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
         this.SavePanel_mc.UpdateSaveData(param1.data);
         this.LoadPanel_mc.UpdateLoadData(param1.data);
      }
      
      private function OnHelpDataUpdate(param1:FromClientDataEvent) : void
      {
         this.HelpPanel_mc.UpdateTopicData(param1.data);
      }
      
      private function onSubPanelClose() : void
      {
         BSUIDataManager.dispatchEvent(new Event("PauseMenu_ActionCanceled"));
      }
      
      private function onMainPanelEntryPressed(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("PauseMenu_StartAction",{"actionType":param1.params.entryAction}));
      }
      
      private function onMainPanelActionConfirmed() : void
      {
         BSUIDataManager.dispatchEvent(new Event("PauseMenu_ConfirmAction"));
      }
      
      private function onMainPanelYButton() : void
      {
         BSUIDataManager.dispatchEvent(new Event("PauseMenu_QuitToDesktop"));
      }
      
      private function onMainPanelActionCanceled() : void
      {
         BSUIDataManager.dispatchEvent(new Event("PauseMenu_ActionCanceled"));
      }
      
      private function onSavePanelConfirmSave(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("PauseMenu_ConfirmSave",{"index":param1.params.saveIndex}));
      }
      
      private function onLoadPanelEntryPressed(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("PauseMenu_StartLoad",{"index":param1.params.loadIndex}));
      }
      
      private function onLoadPanelConfirmLoad() : void
      {
         BSUIDataManager.dispatchEvent(new Event("PauseMenu_ConfirmLoad"));
      }
      
      private function onLoadOrSavePanelSetCharacter(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("PauseMenu_SetCharacter",{"characterID":param1.params.characterID}));
      }
      
      private function onPanelDeleteSave(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("PauseMenu_DeleteSave",{"index":param1.params.deleteIndex}));
      }
      
      private function onLoadPanelUploadSave(param1:CustomEvent) : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent("PauseMenu_UploadSave",{"index":param1.params.loadIndex}));
      }
   }
}
