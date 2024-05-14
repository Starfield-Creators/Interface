package
{
   import Components.ImageFixture;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import scaleform.gfx.Extensions;
   
   public class PhotoViewer extends MovieClip
   {
      
      public static const CHANGE_PHOTO_EVENT:String = "PhotoViewer_ChangePhoto";
       
      
      public var Photo_mc:ImageFixture;
      
      public var PageIndicator_mc:PhotoPageIndicator;
      
      private const THUMBNAIL_EXT:String = "-thumbnail";
      
      private var ScreenWidth:uint = 0;
      
      private var ScreenHeight:uint = 0;
      
      private var _active:Boolean = false;
      
      public function PhotoViewer()
      {
         super();
         this.visible = false;
         this.Photo_mc.onLoadAttemptComplete = this.onImageLoadAttemptComplete;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         if(this.active != param1)
         {
            this._active = param1;
            this.visible = this.active;
         }
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
         if(this.Photo_mc.imageInstance != null)
         {
            _loc1_ = this.Photo_mc.width != 0 ? this.ScreenWidth / this.Photo_mc.width : 1;
            _loc2_ = this.Photo_mc.height != 0 ? this.ScreenHeight / this.Photo_mc.height : 1;
            _loc3_ = Math.min(Math.min(_loc1_,_loc2_),1);
            _loc4_ = this.ScreenWidth != 0 ? stage.stageWidth / this.ScreenWidth : 1;
            _loc5_ = this.ScreenHeight != 0 ? stage.stageHeight / this.ScreenHeight : 1;
            _loc6_ = Math.min(_loc4_,_loc5_);
            _loc7_ = _loc3_ * _loc6_;
            this.Photo_mc.scaleX = _loc7_;
            this.Photo_mc.scaleY = _loc7_;
            _loc8_ = Extensions.visibleRect;
            this.Photo_mc.x = (stage.stageWidth - this.Photo_mc.width) * 0.5 + _loc8_.x;
            this.Photo_mc.y = (stage.stageHeight - this.Photo_mc.height) * 0.5 + _loc8_.y;
         }
      }
      
      public function HideUI(param1:Boolean) : void
      {
         this.PageIndicator_mc.visible = !param1;
      }
      
      public function SetPhoto(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         this.Photo_mc.scaleX = 1;
         this.Photo_mc.scaleY = 1;
         if(param1.sImageName != "")
         {
            _loc3_ = int(param1.sImageName.indexOf(this.THUMBNAIL_EXT));
            _loc4_ = _loc3_ != -1 ? String(param1.sImageName.substring(0,_loc3_) + param1.sImageName.substring(_loc3_ + this.THUMBNAIL_EXT.length,param1.sImageName.length)) : String(param1.sImageName);
            _loc5_ = {
               "sImageName":_loc4_,
               "sDirectory":param1.sDirectory,
               "iFixtureType":param1.iFixtureType
            };
            this.Photo_mc.LoadImageFixtureFromUIData(_loc5_,PhotoGalleryMenu.PHOTO_GALLERY_TEXTURE_BUFFER);
         }
         else
         {
            this.Photo_mc.Unload();
         }
         this.PageIndicator_mc.SetCurrentPhoto(param2);
      }
      
      public function SetTotal(param1:uint) : void
      {
         this.PageIndicator_mc.SetTotalPhotos(param1);
      }
      
      public function SetScreenSize(param1:uint, param2:uint) : void
      {
         this.ScreenWidth = param1;
         this.ScreenHeight = param2;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.active)
         {
            _loc3_ = this.PageIndicator_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
   }
}
