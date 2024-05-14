package Components
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class SWFLoaderClip extends MovieClip
   {
       
      
      private var SWF:DisplayObject = null;
      
      private var menuLoader:Loader;
      
      private var AltMenuName:String;
      
      private var LoadSuccessCallback:Function = null;
      
      protected var ClipAlpha:Number = 1;
      
      protected var ClipScale:Number = 1;
      
      protected var ClipRotation:Number = 0;
      
      protected var ClipWidth:Number = 0;
      
      protected var ClipHeight:Number = 0;
      
      protected var ClipXOffset:Number = 0;
      
      protected var ClipYOffset:Number = 0;
      
      protected var CenterClip:Boolean = false;
      
      public function SWFLoaderClip()
      {
         this.menuLoader = new Loader();
         this.AltMenuName = new String();
         super();
      }
      
      public function get content() : DisplayObject
      {
         return this.SWF;
      }
      
      public function set clipAlpha(param1:Number) : *
      {
         this.ClipAlpha = param1;
      }
      
      public function set clipScale(param1:Number) : *
      {
         this.ClipScale = param1;
      }
      
      public function set clipRotation(param1:Number) : *
      {
         this.ClipRotation = param1;
      }
      
      public function set clipWidth(param1:Number) : *
      {
         this.ClipWidth = param1;
      }
      
      public function set clipHeight(param1:Number) : *
      {
         this.ClipHeight = param1;
      }
      
      public function get clipWidth() : Number
      {
         return this.ClipWidth;
      }
      
      public function get clipHeight() : Number
      {
         return this.ClipHeight;
      }
      
      public function get clipScale() : Number
      {
         return this.ClipScale;
      }
      
      public function set clipYOffset(param1:Number) : *
      {
         this.ClipYOffset = param1;
      }
      
      public function get clipYOffset() : Number
      {
         return this.ClipYOffset;
      }
      
      public function set clipXOffset(param1:Number) : *
      {
         this.ClipXOffset = param1;
      }
      
      public function get clipXOffset() : Number
      {
         return this.ClipXOffset;
      }
      
      public function set centerClip(param1:Boolean) : *
      {
         this.CenterClip = param1;
      }
      
      public function get centerClip() : Boolean
      {
         return this.CenterClip;
      }
      
      public function forceUnload() : *
      {
         if(this.SWF)
         {
            this.SWFUnload(this.SWF);
         }
      }
      
      public function SWFLoad(param1:String, param2:Function = null) : void
      {
         try
         {
            this.menuLoader.close();
         }
         catch(e:Error)
         {
         }
         if(this.SWF)
         {
            this.SWFUnload(this.SWF);
         }
         this.LoadSuccessCallback = param2;
         var _loc3_:URLRequest = new URLRequest(param1 + ".swf");
         this.menuLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMenuLoadComplete);
         this.menuLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this._ioErrorEventHandler,false,0,true);
         this.menuLoader.load(_loc3_);
      }
      
      public function SWFLoadAlt(param1:String, param2:String) : *
      {
         this.AltMenuName = param2;
         this.SWFLoad(param1);
      }
      
      private function _ioErrorEventHandler(param1:IOErrorEvent) : *
      {
         if(this.AltMenuName.length > 0)
         {
            this.SWFLoad(this.AltMenuName);
         }
         else
         {
            trace("Failed to load .swf. " + new Error().getStackTrace());
         }
      }
      
      public function onMenuLoadComplete(param1:Event) : void
      {
         this.SWF = param1.currentTarget.content;
         addChild(this.SWF);
         this.SWF.scaleX = this.ClipScale;
         this.SWF.scaleY = this.ClipScale;
         this.SWF.alpha = this.ClipAlpha;
         if(this.ClipWidth != 0)
         {
            this.SWF.width = this.ClipWidth;
         }
         if(this.ClipHeight != 0)
         {
            this.SWF.height = this.ClipHeight;
         }
         if(this.CenterClip)
         {
            this.SWF.x = this.SWF.width * -0.5;
            this.SWF.y = this.SWF.height * -0.5;
         }
         this.SWF.x += this.ClipXOffset;
         this.SWF.y += this.ClipYOffset;
         if(this.LoadSuccessCallback !== null)
         {
            this.LoadSuccessCallback(this.SWF);
            this.LoadSuccessCallback = null;
         }
      }
      
      public function SWFUnload(param1:DisplayObject) : void
      {
         removeChild(param1);
         param1.loaderInfo.loader.unload();
         this.SWF = null;
      }
   }
}
