package
{
   import Components.ImageFixture;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class PhotoModeMenu extends IMenu
   {
      
      public static const PHOTO_MODE_TEXTURE_BUFFER:String = "PhotoModeTextureBuffer";
       
      
      public var PanelContainer_mc:PhotoModePanelContainer;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Frame_mc:ImageFixture;
      
      public var Texture_mc:MovieClip;
      
      public var CameraOverlay_mc:MovieClip;
      
      private var SnapshotButton:IButton = null;
      
      private var ToggleUIButton:IButton = null;
      
      private var ToggleHelmetButton:IButton = null;
      
      private var ResetButton:IButton = null;
      
      private var RefineButton:IButton = null;
      
      private var RefineButtonData:ButtonBaseData;
      
      private var ResetButtonData:ButtonBaseData;
      
      private var ResetRefinementsButtonData:ButtonBaseData;
      
      private var ExitButtonData:ButtonBaseData;
      
      private var _hideMenu:Boolean = false;
      
      private var _textureData:Object = null;
      
      private var _frameData:Object = null;
      
      private var _textureName:String = "";
      
      private const BUTTON_BAR_BG_HORIZONTAL_PADDING:Number = 5;
      
      private const IMAGE_SCALE:Number = 0.5;
      
      private const MAX_WIDTH:Number = 3840;
      
      private const MAX_HEIGHT:Number = 2160;
      
      public function PhotoModeMenu()
      {
         this.RefineButtonData = new ButtonBaseData("$REFINE",new UserEventData("NextMode",this.RefineSetting),false,false);
         this.ResetButtonData = new ButtonBaseData("$RESET CATEGORY",new UserEventData("Reset",this.ResetCategory));
         this.ResetRefinementsButtonData = new ButtonBaseData("$RESET SETTINGS",new UserEventData("Reset",this.ResetRefinements));
         this.ExitButtonData = new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.ExitMenu));
         super();
         this.SetUpButtons();
         BSUIDataManager.Subscribe("PhotoModeSettingsData",this.OnSettingsDataUpdate);
         BSUIDataManager.Subscribe("RefineSettingsData",this.OnRefineSettingsDataUpdate);
         BSUIDataManager.Subscribe("PhotoModeStateData",this.OnStateDataUpdate);
         BSUIDataManager.Subscribe("PhotoModeOverlayData",this.OnOverlayDataUpdate);
         this.Texture_mc.TextureClip0_mc.onLoadAttemptComplete = function():*
         {
            MainTextureLoaded(Texture_mc.TextureClip0_mc,_textureData);
         };
         this.Frame_mc.onLoadAttemptComplete = function():*
         {
            if(Frame_mc.imageInstance != null)
            {
               PlaceImageClip(Frame_mc,_frameData);
            }
         };
         addEventListener(PhotoModePanelContainer.ACTIVE_LIST_CHANGED,this.OnPanelListChanged);
         addEventListener(PhotoModePanelContainer.REFRESH_BUTTONS,this.UpdateButtons);
      }
      
      private function get ExitButton() : IButton
      {
         return this.ButtonBar_mc.ExitButton_mc;
      }
      
      public function get hideMenu() : Boolean
      {
         return this._hideMenu;
      }
      
      public function set hideMenu(param1:Boolean) : void
      {
         if(this.hideMenu != param1)
         {
            this._hideMenu = param1;
            this.CameraOverlay_mc.visible = !this.hideMenu;
            this.PanelContainer_mc.visible = !this.hideMenu;
            this.ButtonBar_mc.visible = !this.hideMenu;
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         stage.focus = this.PanelContainer_mc.activeList;
         GlobalFunc.PlayMenuSound("UIPhotomodeEnter");
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = this.PanelContainer_mc.ProcessUserEvent(param1,param2);
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.SetBackgroundPadding(this.BUTTON_BAR_BG_HORIZONTAL_PADDING,0);
         this.SnapshotButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$TAKE PHOTO",new UserEventData("Snapshot",this.TakeSnapshot)),this.ButtonBar_mc);
         this.ToggleUIButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$TOGGLE MENU",new UserEventData("ToggleUI",this.ToggleUI)),this.ButtonBar_mc);
         this.ToggleHelmetButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$TOGGLE HELMET",new UserEventData("ToggleHelmet",this.ToggleHelmet),false,false),this.ButtonBar_mc);
         this.ResetButton = ButtonFactory.AddToButtonBar("BasicButton",this.ResetButtonData,this.ButtonBar_mc);
         this.RefineButton = ButtonFactory.AddToButtonBar("BasicButton",this.RefineButtonData,this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.ExitButton,this.ExitButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateButtons() : void
      {
         var _loc1_:* = this.PanelContainer_mc.currentMode == PhotoModePanelContainer.SETTINGS_MODE;
         var _loc2_:* = this.PanelContainer_mc.currentMode == PhotoModePanelContainer.REFINE_MODE;
         this.RefineButtonData.sButtonText = _loc1_ ? "$REFINE SETTING" : "$CONFIRM SETTINGS";
         this.RefineButton.SetButtonData(this.RefineButtonData);
         this.RefineButton.Visible = _loc1_ && this.PanelContainer_mc.canRefineSetting || _loc2_;
         this.RefineButton.Enabled = this.RefineButton.Visible;
         this.ResetButton.SetButtonData(_loc2_ ? this.ResetRefinementsButtonData : this.ResetButtonData);
         this.ButtonBar_mc.RefreshButtons();
      }
      
      private function PlaceImageClip(param1:MovieClip, param2:Object) : void
      {
         param1.scaleX = this.IMAGE_SCALE;
         param1.scaleY = this.IMAGE_SCALE;
         var _loc3_:Number = (1 + param2.fXOffset) / 2;
         _loc3_ *= stage.stageWidth;
         _loc3_ -= param1.width / 2;
         var _loc4_:Number = (_loc4_ = (_loc4_ = 1 - (1 + param2.fYOffset) / 2) * stage.stageHeight) - param1.height / 2;
         param1.x = _loc3_;
         param1.y = _loc4_;
      }
      
      private function LoadFrame() : void
      {
         this.Frame_mc.scaleX = 1;
         this.Frame_mc.scaleY = 1;
         if(this._frameData.imageData.sImageName != "")
         {
            this.Frame_mc.LoadImageFixtureFromUIData(this._frameData.imageData,PHOTO_MODE_TEXTURE_BUFFER);
         }
         else
         {
            this.Frame_mc.Unload();
         }
      }
      
      private function LoadTexture() : void
      {
         var _loc2_:ImageFixture = null;
         this.Texture_mc.visible = false;
         var _loc1_:uint = 0;
         while(_loc1_ < this.Texture_mc.numChildren)
         {
            _loc2_ = this.Texture_mc.getChildAt(_loc1_) as ImageFixture;
            if(_loc1_ != 0)
            {
               _loc2_.onLoadAttemptComplete = null;
            }
            _loc2_.Unload();
            _loc1_++;
         }
         this.Texture_mc.scaleX = 1;
         this.Texture_mc.scaleY = 1;
         if(this._textureData.imageData.sImageName != "")
         {
            this.Texture_mc.TextureClip0_mc.LoadImageFixtureFromUIData(this._textureData.imageData,PHOTO_MODE_TEXTURE_BUFFER);
         }
      }
      
      private function MainTextureLoaded(param1:ImageFixture, param2:Object) : void
      {
         var totalNeededHorizontal:uint = 0;
         var totalNeededVertical:uint = 0;
         var totalNeeded:uint = 0;
         var textureClipClass:Class = null;
         var currentIndex:uint = 0;
         var xIdx:uint = 0;
         var yIdx:uint = 0;
         var nextX:Number = NaN;
         var nextY:Number = NaN;
         var textureClip:* = undefined;
         var aImageClip:ImageFixture = param1;
         var aData:Object = param2;
         if(aImageClip.imageInstance != null)
         {
            if(Boolean(aData.bTileX) || Boolean(aData.bTileY))
            {
               totalNeededHorizontal = aImageClip.width != 0 && Boolean(aData.bTileX) ? uint(Math.ceil(this.MAX_WIDTH / aImageClip.width / 2) * 2) : 1;
               totalNeededVertical = aImageClip.height != 0 && Boolean(aData.bTileY) ? uint(Math.ceil(this.MAX_HEIGHT / aImageClip.height / 2) * 2) : 1;
               totalNeeded = totalNeededHorizontal * totalNeededVertical;
               textureClipClass = getDefinitionByName("TextureClip") as Class;
               currentIndex = 1;
               xIdx = 0;
               yIdx = 1;
               nextX = 0;
               nextY = aImageClip.height;
               while(xIdx < totalNeededHorizontal)
               {
                  while(yIdx < totalNeededVertical)
                  {
                     textureClip = currentIndex < this.Texture_mc.numChildren ? this.Texture_mc.getChildAt(currentIndex) as textureClipClass : null;
                     if(textureClip == null)
                     {
                        textureClip = new textureClipClass();
                        this.Texture_mc.addChild(textureClip);
                     }
                     textureClip.x = nextX;
                     textureClip.y = nextY;
                     nextY += aImageClip.height;
                     if(currentIndex == totalNeeded - 1)
                     {
                        textureClip.onLoadAttemptComplete = function():*
                        {
                           PlaceImageClip(Texture_mc,aData);
                           Texture_mc.visible = true;
                        };
                     }
                     textureClip.LoadImageFixtureFromUIData(this._textureData.imageData,PHOTO_MODE_TEXTURE_BUFFER);
                     currentIndex++;
                     yIdx++;
                  }
                  nextX += aImageClip.width;
                  nextY = 0;
                  yIdx = 0;
                  xIdx++;
               }
            }
            else
            {
               this.PlaceImageClip(this.Texture_mc,aData);
               this.Texture_mc.visible = true;
            }
         }
      }
      
      private function OnPanelListChanged(param1:Event) : void
      {
         stage.focus = this.PanelContainer_mc.activeList;
         this.UpdateButtons();
      }
      
      private function OnSettingsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.PanelContainer_mc.UpdateCategories(param1.data.aCategories);
         this.PanelContainer_mc.UpdateSettings(param1.data.aSettings);
      }
      
      private function OnRefineSettingsDataUpdate(param1:FromClientDataEvent) : void
      {
         this.PanelContainer_mc.UpdateRefinementData(param1.data.uRefinementCategory,param1.data.aRefineSettings);
      }
      
      private function OnStateDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.data.bCanToggleHelmet);
         if(_loc2_ != this.ToggleHelmetButton.Enabled)
         {
            this.ToggleHelmetButton.Enabled = _loc2_;
            this.ToggleHelmetButton.Visible = _loc2_;
            this.ButtonBar_mc.RefreshButtons();
         }
         this.hideMenu = param1.data.bHideMenu;
      }
      
      private function OnOverlayDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = this._textureName != param1.data.textureData.imageData.sImageName;
         this._textureData = param1.data.textureData;
         this._textureName = this._textureData.imageData.sImageName;
         if(_loc2_)
         {
            this.LoadTexture();
         }
         this.Texture_mc.alpha = this._textureData.fIntensity;
         this._frameData = param1.data.frameData;
         this.LoadFrame();
         if(getChildIndex(this.Frame_mc) < getChildIndex(this.Texture_mc))
         {
            if(Boolean(this._frameData.bTopmost) || this._frameData.bTopmost == this._textureData.bTopmost)
            {
               swapChildren(this.Frame_mc,this.Texture_mc);
            }
         }
         else if(Boolean(this._textureData.bTopmost) && !this._frameData.bTopmost)
         {
            swapChildren(this.Frame_mc,this.Texture_mc);
         }
      }
      
      private function TakeSnapshot() : void
      {
         this.hideMenu = true;
         GlobalFunc.PlayMenuSound("UIPhotomodeTakePhoto");
         BSUIDataManager.dispatchEvent(new Event("PhotoMode_TakeSnapshot"));
      }
      
      private function ToggleUI() : void
      {
         GlobalFunc.PlayMenuSound("UIPhotomodeToggleMenu");
         this.hideMenu = !this.hideMenu;
         BSUIDataManager.dispatchEvent(new Event("PhotoMode_ToggleUI"));
      }
      
      private function ToggleHelmet() : void
      {
         GlobalFunc.PlayMenuSound("UIPhotomodeToggleMenu");
         BSUIDataManager.dispatchEvent(new Event("PhotoMode_ToggleHelmet"));
      }
      
      private function ResetCategory() : void
      {
         GlobalFunc.PlayMenuSound("UIPhotomodeResetCategory");
         BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_ResetToDefaults",{
            "uCategoryID":this.PanelContainer_mc.currentCategoryID,
            "bRefinement":false
         }));
      }
      
      private function ResetRefinements() : void
      {
         GlobalFunc.PlayMenuSound("UIPhotomodeResetCategory");
         BSUIDataManager.dispatchEvent(new CustomEvent("PhotoMode_ResetToDefaults",{
            "uCategoryID":this.PanelContainer_mc.refinementFilter,
            "bRefinement":true
         }));
      }
      
      private function RefineSetting() : void
      {
         this.PanelContainer_mc.OnRefineButton();
      }
      
      private function ExitMenu() : void
      {
         GlobalFunc.PlayMenuSound("UIPhotomodeExit");
         GlobalFunc.CloseMenu("PhotoModeMenu");
      }
   }
}
