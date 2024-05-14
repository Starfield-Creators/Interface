package Components
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ContentLoaders.ImageLoaderClip;
   import Shared.Components.ContentLoaders.SymbolLoaderClip;
   import Shared.EnumHelper;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class ImageFixture extends MovieClip
   {
      
      private static const REQUEST_IMAGE:String = "ImageFixtureEvent_RequestImage";
      
      private static const UNREGISTER_IMAGE:String = "ImageFixtureEvent_UnregisterImage";
      
      private static const NONE_LOADED:int = EnumHelper.GetEnum(0);
      
      private static const SWF_LOADED:int = EnumHelper.GetEnum();
      
      private static const IN_LOADED:int = EnumHelper.GetEnum();
      
      private static const EX_LOADED:int = EnumHelper.GetEnum();
      
      public static const FT_INVALID:int = EnumHelper.GetEnum(-1);
      
      public static const FT_INTERNAL:int = EnumHelper.GetEnum();
      
      public static const FT_EXTERNAL:int = EnumHelper.GetEnum();
      
      public static const FT_SYMBOL:int = EnumHelper.GetEnum();
       
      
      public var BoundClip_mc:MovieClip;
      
      private var _State:int;
      
      private var _ImageLoader:ImageLoaderClip;
      
      private var _SymbolLoader:SymbolLoaderClip;
      
      private var _ImageName:String = "";
      
      private var _BufferName:String = "";
      
      private var _RequestSent:Boolean = false;
      
      private var _FixtureType:int;
      
      public function ImageFixture()
      {
         this._State = NONE_LOADED;
         this._FixtureType = FT_INVALID;
         super();
         this._ImageLoader = new ImageLoaderClip();
         this._SymbolLoader = new SymbolLoaderClip();
         this.addChild(this._ImageLoader);
         this.addChild(this._SymbolLoader);
         if(this.BoundClip_mc != null)
         {
            this._ImageLoader.BoundClip_mc = this.BoundClip_mc;
            this._SymbolLoader.BoundClip_mc = this.BoundClip_mc;
         }
      }
      
      public function set fixtureType(param1:int) : void
      {
         this._FixtureType = param1;
      }
      
      public function get fixtureType() : int
      {
         return this._FixtureType;
      }
      
      public function get imageInstance() : Bitmap
      {
         return this._ImageLoader.imageInstance;
      }
      
      public function get symbolInstance() : MovieClip
      {
         return this._SymbolLoader.symbolInstance;
      }
      
      public function set centerClip(param1:Boolean) : void
      {
         this._ImageLoader.centerClip = param1;
         this._SymbolLoader.centerClip = param1;
      }
      
      public function set clipSizer(param1:String) : void
      {
         this._SymbolLoader.clipSizer = param1;
      }
      
      public function set clipAlpha(param1:Number) : void
      {
         this._ImageLoader.clipAlpha = param1;
         this._SymbolLoader.clipAlpha = param1;
      }
      
      public function set clipScale(param1:Number) : void
      {
         this._ImageLoader.clipScale = param1;
         this._SymbolLoader.clipScale = param1;
      }
      
      public function set clipRotation(param1:Number) : void
      {
         this._ImageLoader.clipRotation = param1;
         this._SymbolLoader.clipRotation = param1;
      }
      
      public function set clipWidth(param1:Number) : void
      {
         this._ImageLoader.clipWidth = param1;
         this._SymbolLoader.clipWidth = param1;
      }
      
      public function set clipHeight(param1:Number) : void
      {
         this._ImageLoader.clipHeight = param1;
         this._SymbolLoader.clipHeight = param1;
      }
      
      public function set clipYOffset(param1:Number) : void
      {
         this._ImageLoader.clipYOffset = param1;
         this._SymbolLoader.clipYOffset = param1;
      }
      
      public function set clipXOffset(param1:Number) : void
      {
         this._ImageLoader.clipXOffset = param1;
         this._SymbolLoader.clipXOffset = param1;
      }
      
      public function set onLoadAttemptComplete(param1:Function) : void
      {
         this._ImageLoader.onLoadAttemptComplete = param1;
         this._SymbolLoader.onLoadAttemptComplete = param1;
      }
      
      public function set errorClassName(param1:String) : void
      {
         this._ImageLoader.errorClassName = param1;
         this._SymbolLoader.errorClassName = param1;
      }
      
      public function set loadingClassName(param1:String) : void
      {
         this._ImageLoader.loadingClassName = param1;
         this._SymbolLoader.loadingClassName = param1;
      }
      
      public function LoadImageFixtureFromUIData(param1:Object, param2:String) : void
      {
         this.fixtureType = param1.iFixtureType;
         switch(param1.iFixtureType)
         {
            case FT_INTERNAL:
               this.LoadInternal(param1.sDirectory + param1.sImageName,param2);
               break;
            case FT_EXTERNAL:
               this.LoadExternal(param1.sDirectory + param1.sImageName,param2);
               break;
            case FT_SYMBOL:
               this.LoadSymbol(param1.sImageName,param1.sDirectory);
               break;
            default:
               trace("ImageFixture::LoadImageFixtureFromUIData: Fixture type is invalid, cannot load.");
         }
      }
      
      public function LoadSymbol(param1:String, param2:String = "") : void
      {
         if(this._ImageName != param1 || this._State != SWF_LOADED)
         {
            this.Unload();
            this._ImageName = param1;
            this._State = SWF_LOADED;
            this._SymbolLoader.LoadSymbol(param1,param2);
         }
         else if(this._SymbolLoader.onLoadAttemptComplete != null)
         {
            this._SymbolLoader.onLoadAttemptComplete.call();
         }
      }
      
      public function LoadInternal(param1:String, param2:String) : void
      {
         if(this._ImageName != param1 || this._State != IN_LOADED)
         {
            this.Unload();
            this._ImageName = param1;
            this._State = IN_LOADED;
            this._BufferName = param2;
            this.LoadBitmap();
         }
         else if(this._ImageLoader.onLoadAttemptComplete != null)
         {
            this._ImageLoader.onLoadAttemptComplete.call();
         }
      }
      
      public function LoadExternal(param1:String, param2:String) : void
      {
         if(this._ImageName != param1 || this._State != EX_LOADED)
         {
            this.Unload();
            this._ImageName = param1;
            this._State = EX_LOADED;
            this._BufferName = param2;
            this.LoadBitmap();
         }
         else if(this._ImageLoader.onLoadAttemptComplete != null)
         {
            this._ImageLoader.onLoadAttemptComplete.call();
         }
      }
      
      public function Unload() : void
      {
         this.UnloadBitmap();
         this._SymbolLoader.Unload();
         this._State = NONE_LOADED;
         this._ImageName = "";
         this._BufferName = "";
      }
      
      private function LoadBitmap() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(REQUEST_IMAGE,{
            "imageName":this._ImageName,
            "isExternal":this._State == EX_LOADED,
            "bufferName":this._BufferName
         }));
         this._RequestSent = true;
         this._ImageLoader.LoadImage(this._ImageName);
      }
      
      private function UnloadBitmap() : void
      {
         this._ImageLoader.Unload();
         if(this._RequestSent)
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(UNREGISTER_IMAGE,{
               "imageName":this._ImageName,
               "isExternal":this._State == EX_LOADED,
               "bufferName":this._BufferName
            }));
            this._RequestSent = false;
         }
      }
   }
}
