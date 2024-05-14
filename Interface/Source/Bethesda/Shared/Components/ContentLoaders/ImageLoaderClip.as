package Shared.Components.ContentLoaders
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class ImageLoaderClip extends BaseLoaderClip
   {
       
      
      private var _ImageInstance:Bitmap = null;
      
      private var _ImageName:String = "";
      
      public function ImageLoaderClip()
      {
         super();
      }
      
      public function get imageInstance() : Bitmap
      {
         return this._ImageInstance;
      }
      
      public function LoadImage(param1:String) : void
      {
         var _loc2_:URLRequest = null;
         if(this._ImageName != param1)
         {
            this.Unload();
            this._ImageName = param1;
            _loc2_ = new URLRequest("img://" + this._ImageName);
            super.Load(_loc2_);
         }
         else if(_OnLoadAttemptComplete != null)
         {
            _OnLoadAttemptComplete();
         }
      }
      
      override public function Unload() : void
      {
         super.Unload();
         this.destroyImage();
      }
      
      override protected function onLoadFailed(param1:Event) : void
      {
         trace("WARNING: ImageLoaderClip:onLoadFailed | " + this._ImageName);
         super.onLoadFailed(param1);
      }
      
      override protected function onLoaded(param1:Event) : void
      {
         this._ImageInstance = param1.target.content;
         if(this._ImageInstance != null)
         {
            this._ImageInstance.name = "ImageInstance";
            this._ImageInstance.smoothing = true;
         }
         AddDisplayObject(this._ImageInstance);
         super.onLoaded(param1);
      }
      
      private function destroyImage() : void
      {
         RemoveDisplayObject(this._ImageInstance);
         this._ImageName = "";
      }
   }
}
