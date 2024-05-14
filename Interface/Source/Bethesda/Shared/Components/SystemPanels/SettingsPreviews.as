package Shared.Components.SystemPanels
{
   import Components.ImageFixture;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   
   public class SettingsPreviews extends MovieClip
   {
       
      
      public var Brightness_mc:MovieClip;
      
      public var Contrast_mc:MovieClip;
      
      public var Image1_mc:ImageFixture;
      
      public var Image2_mc:ImageFixture;
      
      private const NONE_LABEL:String = "none";
      
      private const IMAGE_LABEL:String = "image";
      
      private const IMG_PREFIX:String = "img:";
      
      private const IMG_SEPARATOR:String = ", ";
      
      private var _brightnessBase:uint = 4294967295;
      
      private var _hdrScale:Number = 0;
      
      private var _img1Low:Number = 0;
      
      private var _img1High:Number = 1;
      
      private var _img2Low:Number = 0;
      
      private var _img2High:Number = 1;
      
      public function SettingsPreviews()
      {
         super();
         BSUIDataManager.Subscribe("SettingsPreviewsData",this.OnDataUpdate);
         this.Image1_mc.onLoadAttemptComplete = function():*
         {
            AdjustImage(Image1_mc,_img1Low,_img1High);
         };
         this.Image2_mc.onLoadAttemptComplete = function():*
         {
            AdjustImage(Image2_mc,_img2Low,_img2High);
         };
      }
      
      private function OnDataUpdate(param1:FromClientDataEvent) : void
      {
         this._img1Low = param1.data.fImage1Low;
         this._img1High = param1.data.fImage1High;
         this._img2Low = param1.data.fImage2Low;
         this._img2High = param1.data.fImage2High;
         this.SetBrightnessScale(param1.data.fHDRBrightness);
         this.SetBrightnessBackground(param1.data.uBrightnessBase);
      }
      
      public function SetBrightnessScale(param1:Number) : void
      {
         if(this._hdrScale != param1)
         {
            this._hdrScale = param1;
            this.AdjustImage(this.Image1_mc,this._img1Low,this._img1High);
            this.AdjustImage(this.Image2_mc,this._img2Low,this._img2High);
         }
      }
      
      private function AdjustImage(param1:ImageFixture, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:ColorMatrixFilter = null;
         var _loc15_:ColorMatrixFilter = null;
         var _loc16_:ColorMatrixFilter = null;
         if(param1.imageInstance != null)
         {
            _loc4_ = param2;
            _loc5_ = param3;
            _loc7_ = (_loc6_ = Math.max(0,_loc5_ - _loc4_)) != 0 ? 1 / _loc6_ : 1;
            _loc8_ = _loc4_ * 255;
            _loc9_ = GlobalFunc.Lerp(1,_loc7_,this._hdrScale);
            _loc10_ = GlobalFunc.Lerp(0,_loc8_,this._hdrScale) * -1;
            _loc11_ = [_loc9_,0,0,0,_loc10_,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
            _loc12_ = [1,0,0,0,0,0,_loc9_,0,0,_loc10_,0,0,1,0,0,0,0,0,1,0];
            _loc13_ = [1,0,0,0,0,0,1,0,0,0,0,0,_loc9_,0,_loc10_,0,0,0,1,0];
            _loc14_ = new ColorMatrixFilter(_loc11_);
            _loc15_ = new ColorMatrixFilter(_loc12_);
            _loc16_ = new ColorMatrixFilter(_loc13_);
            param1.imageInstance.filters = [_loc14_,_loc15_,_loc16_];
         }
      }
      
      public function UpdatePreview(param1:String) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:String = param1;
         var _loc3_:String = "";
         var _loc4_:String = "";
         if(_loc2_ == "")
         {
            _loc2_ = this.NONE_LABEL;
         }
         else if((_loc5_ = _loc2_.indexOf(this.IMG_PREFIX)) > -1)
         {
            _loc3_ = _loc2_.substring(_loc5_ + this.IMG_PREFIX.length,_loc2_.length);
            if((_loc5_ = _loc3_.indexOf(this.IMG_SEPARATOR)) > -1)
            {
               _loc4_ = _loc3_.substring(_loc5_ + this.IMG_SEPARATOR.length,_loc3_.length);
               _loc3_ = _loc3_.substring(0,_loc5_);
               if((_loc5_ = _loc4_.indexOf(this.IMG_SEPARATOR)) > -1)
               {
                  _loc4_ = _loc4_.substring(0,_loc5_);
               }
            }
            _loc2_ = this.IMAGE_LABEL;
         }
         if(this.currentFrameLabel != _loc2_)
         {
            this.gotoAndStop(_loc2_);
         }
         this.LoadImagePreview(this.Image1_mc,_loc3_);
         this.LoadImagePreview(this.Image2_mc,_loc4_);
      }
      
      private function LoadImagePreview(param1:ImageFixture, param2:String) : void
      {
         if(param2 != "")
         {
            param1.LoadInternal(param2,"SettingsImages");
         }
         else
         {
            param1.Unload();
         }
      }
      
      public function SetBrightnessBackground(param1:uint) : void
      {
         var _loc2_:* = undefined;
         if(this._brightnessBase != param1)
         {
            this._brightnessBase = param1;
            _loc2_ = new ColorTransform();
            _loc2_.color = this._brightnessBase;
            this.Brightness_mc.Left_mc.Box_mc.transform.colorTransform = _loc2_;
            this.Brightness_mc.Right_mc.Box_mc.transform.colorTransform = _loc2_;
         }
      }
   }
}
