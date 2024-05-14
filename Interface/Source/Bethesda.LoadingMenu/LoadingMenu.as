package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ContentLoaders.ImageLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import scaleform.gfx.Extensions;
   
   public class LoadingMenu extends IMenu
   {
      
      private static const TIME_TO_HIDE_PROGRESS_BAR_AFTER_COMPLETION:Number = 1000;
      
      private static const REFRESH_RATE_SECONDS:Number = 20;
      
      private static const LEVEL_ICON_START_WIDTH:Number = 95;
      
      private static const LEVEL_ICON_SCALE:Number = 0.7;
       
      
      public var BuildingShaders_mc:MovieClip;
      
      public var LeftText_mc:MovieClip;
      
      public var BlackRect_mc:MovieClip;
      
      public var Spinner_mc:MovieClip;
      
      public var PlayerName_mc:MovieClip;
      
      public var Texture_mc:ImageLoaderClip;
      
      public var Gradient_mc:MovieClip;
      
      private var InMinimalMode:Boolean;
      
      private var ScreenWidth:uint = 0;
      
      private var ScreenHeight:uint = 0;
      
      private var LoadingTexture:String = "";
      
      private var PhotoModeScreen:Boolean = false;
      
      private var StartPlayerNameLevel_x:Number = 0;
      
      private var ShaderProgressWidth:Number = 0;
      
      private var TotalPipelinesToGenerate:uint = 0;
      
      private var HideProgressBarTimer:Timer;
      
      public function LoadingMenu()
      {
         super();
         Extensions.enabled = true;
         this.InMinimalMode = true;
         BSUIDataManager.Subscribe("LoadingMenuData",this.OnLoadingMenuDataUpdate);
         GlobalFunc.SetText(this.LeftText_mc.LoadScreenText_tf," ",false);
         GlobalFunc.SetText(this.LeftText_mc.PlayerName_mc.text_tf,"");
         GlobalFunc.SetText(this.LeftText_mc.PlayerLevel_mc.text_tf,"");
         this.BuildingShaders_mc.visible = false;
         this.ShaderProgressWidth = this.BuildingShaders_mc.Meter_mc.Fill_mc.width;
         this.HideProgressBarTimer = new Timer(TIME_TO_HIDE_PROGRESS_BAR_AFTER_COMPLETION,1);
         this.HideProgressBarTimer.addEventListener(TimerEvent.TIMER,this.OhHideProgressBar);
         this.StartPlayerNameLevel_x = this.LeftText_mc.PlayerName_mc.x;
         var _loc1_:Timer = new Timer(REFRESH_RATE_SECONDS * 1000);
         _loc1_.addEventListener(TimerEvent.TIMER,this.refreshLoadingText);
         _loc1_.start();
         this.LeftText_mc.visible = false;
         this.Texture_mc.onLoadAttemptComplete = this.onImageLoadAttemptComplete;
      }
      
      private function onImageLoadAttemptComplete() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Rectangle = null;
         if(this.Texture_mc.imageInstance != null)
         {
            _loc1_ = this.Texture_mc.width != 0 ? this.ScreenWidth / this.Texture_mc.width : 1;
            _loc2_ = this.Texture_mc.height != 0 ? this.ScreenHeight / this.Texture_mc.height : 1;
            _loc3_ = Math.min(_loc1_,_loc2_);
            _loc3_ = this.PhotoModeScreen ? Math.min(_loc3_,1) : _loc3_;
            _loc4_ = this.ScreenWidth != 0 ? stage.stageWidth / this.ScreenWidth : 1;
            _loc5_ = this.ScreenHeight != 0 ? stage.stageHeight / this.ScreenHeight : 1;
            _loc6_ = Math.min(_loc4_,_loc5_);
            _loc7_ = _loc3_ * _loc6_;
            this.Texture_mc.scaleX = _loc7_;
            this.Texture_mc.scaleY = _loc7_;
            _loc8_ = Extensions.visibleRect;
            this.Texture_mc.x = (stage.stageWidth - this.Texture_mc.width) * 0.5 + _loc8_.x;
            this.Texture_mc.y = (stage.stageHeight - this.Texture_mc.height) * 0.5 + _loc8_.y;
         }
      }
      
      private function OnLoadingMenuDataUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:uint = 0;
         this.InMinimalMode = param1.data.bMinimalMode;
         this.ScreenWidth = param1.data.uScreenWidth;
         this.ScreenHeight = param1.data.uScreenHeight;
         this.PhotoModeScreen = param1.data.bPhotoModeScreen;
         if(param1.data.bSpinnerOnly)
         {
            this.SpinnerOnly();
         }
         else if(this.InMinimalMode)
         {
            this.SetMinimalMode();
         }
         else
         {
            this.LeftText_mc.visible = true;
            GlobalFunc.SetText(this.LeftText_mc.PlayerLevel_mc.text_tf,"$$Level " + param1.data.uLevel.toString());
            if(!this.InMinimalMode && param1.data.uLevel > 0)
            {
               this.LeftText_mc.Player_Level_Icon.visible = true;
               this.LeftText_mc.PlayerName_mc.visible = true;
               this.LeftText_mc.Player_Level_Icon.Initialize(param1.data.uLevel,false,LEVEL_ICON_SCALE);
               GlobalFunc.SetText(this.LeftText_mc.PlayerName_mc.text_tf,param1.data.sPlayerName);
               this.LeftText_mc.PlayerName_mc.x = this.StartPlayerNameLevel_x + (this.LeftText_mc.Player_Level_Icon.width - LEVEL_ICON_START_WIDTH);
               this.LeftText_mc.PlayerLevel_mc.x = this.StartPlayerNameLevel_x + (this.LeftText_mc.Player_Level_Icon.width - LEVEL_ICON_START_WIDTH);
            }
            else
            {
               this.LeftText_mc.Player_Level_Icon.visible = false;
               this.LeftText_mc.PlayerName_mc.visible = false;
            }
            this.SetLoadingText(param1.data.sLoadText);
            if(this.LoadingTexture != param1.data.sTextureName)
            {
               if(param1.data.sTextureName != "")
               {
                  this.Texture_mc.LoadImage(param1.data.sTextureName);
               }
               else
               {
                  this.Texture_mc.Unload();
               }
               this.Texture_mc.visible = true;
            }
            this.LoadingTexture = param1.data.sTextureName;
         }
         if(param1.data.ShowPipelineGenerationProgress)
         {
            this.BuildingShaders_mc.visible = true;
            this.HideProgressBarTimer.stop();
            _loc2_ = param1.data.uTotalNumOfPipelinesToGenerate - param1.data.uNumOfRemainingPipelines;
            this.TotalPipelinesToGenerate = param1.data.uTotalNumOfPipelinesToGenerate > 0 ? uint(param1.data.uTotalNumOfPipelinesToGenerate) : 1;
            GlobalFunc.SetText(this.BuildingShaders_mc.Amount_tf,_loc2_.toString() + "/" + this.TotalPipelinesToGenerate.toString());
            this.BuildingShaders_mc.Meter_mc.Fill_mc.width = Math.min(this.ShaderProgressWidth,_loc2_ / this.TotalPipelinesToGenerate * this.ShaderProgressWidth);
         }
         else if(this.BuildingShaders_mc.visible)
         {
            this.HideProgressBarTimer.stop();
            this.HideProgressBarTimer.reset();
            this.HideProgressBarTimer.start();
            GlobalFunc.SetText(this.BuildingShaders_mc.Amount_tf,this.TotalPipelinesToGenerate.toString() + "/" + this.TotalPipelinesToGenerate.toString());
            this.BuildingShaders_mc.Meter_mc.Fill_mc.width = this.ShaderProgressWidth;
         }
      }
      
      override protected function onSetSafeRect() : void
      {
         var _loc1_:Rectangle = Extensions.visibleRect;
         this.BlackRect_mc.width = _loc1_.width;
         this.BlackRect_mc.height = _loc1_.height;
         this.BlackRect_mc.x = _loc1_.x;
         this.BlackRect_mc.y = _loc1_.y;
         this.Gradient_mc.width = _loc1_.width;
         GlobalFunc.LockToSafeRect(this.Gradient_mc,"BC",SafeX,0,true);
         this.onImageLoadAttemptComplete();
      }
      
      public function SetLoadingText(param1:String) : *
      {
         this.BlackRect_mc.visible = true;
         this.LeftText_mc.LoadScreenText_tf.visible = true;
         var _loc2_:int = int(this.LeftText_mc.LoadScreenText_tf.numLines);
         GlobalFunc.SetText(this.LeftText_mc.LoadScreenText_tf,param1,false);
      }
      
      public function SetMinimalMode() : *
      {
         this.LeftText_mc.visible = false;
         this.Texture_mc.visible = false;
         this.BlackRect_mc.visible = true;
      }
      
      public function SpinnerOnly() : *
      {
         this.SetMinimalMode();
         this.BlackRect_mc.visible = false;
      }
      
      private function refreshLoadingText() : *
      {
         BSUIDataManager.dispatchEvent(new Event("LoadingMenu_RefreshText"));
      }
      
      private function OhHideProgressBar() : *
      {
         this.BuildingShaders_mc.visible = false;
      }
   }
}
