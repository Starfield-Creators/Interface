package Shared.Components.ContentLoaders
{
   import Shared.GlobalFunc;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class BaseLoaderClip extends MovieClip
   {
       
      
      protected var _Loader:Loader;
      
      public var ErrorClip_mc:MovieClip;
      
      public var LoadingClip_mc:MovieClip;
      
      public var BoundClip_mc:MovieClip;
      
      private var _ErrorClassName:String = "ErrorClip";
      
      private var _LoadingClassName:String = "LoadingClip";
      
      private var _errorClipDefinedOnStage:Boolean = false;
      
      private var _loadingClipDefinedOnStage:Boolean = false;
      
      protected var _OnLoadAttemptComplete:Function = null;
      
      protected var ClipAlpha:Number = 1;
      
      protected var ClipScale:Number = 1;
      
      protected var ClipRotation:Number = 0;
      
      protected var ClipWidth:Number = 0;
      
      protected var ClipHeight:Number = 0;
      
      protected var ClipXOffset:Number = 0;
      
      protected var ClipYOffset:Number = 0;
      
      protected var CenterClip:Boolean = false;
      
      protected var ClipSizer:String = "";
      
      public function BaseLoaderClip()
      {
         this._Loader = new Loader();
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
      }
      
      public function set errorClassName(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(this._ErrorClassName != param1)
         {
            this._ErrorClassName = param1;
            _loc2_ = this.ErrorClip_mc != null && this.ErrorClip_mc.visible;
            this.RemoveDisplayObject(this.ErrorClip_mc);
            this.ErrorClip_mc = this.RecreateClipFromClass(this._ErrorClassName,"ErrorClip_mc");
            this.ErrorClip_mc.visible = _loc2_;
         }
      }
      
      public function set loadingClassName(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(this._LoadingClassName != param1)
         {
            this._LoadingClassName = param1;
            _loc2_ = this.LoadingClip_mc != null && this.LoadingClip_mc.visible;
            this.RemoveDisplayObject(this.LoadingClip_mc);
            this.LoadingClip_mc = this.RecreateClipFromClass(this._LoadingClassName,"LoadingClip_mc");
            this.LoadingClip_mc.visible = _loc2_;
         }
      }
      
      public function set clipAlpha(param1:Number) : void
      {
         this.ClipAlpha = param1;
      }
      
      public function set clipScale(param1:Number) : void
      {
         this.ClipScale = param1;
      }
      
      public function set clipRotation(param1:Number) : void
      {
         this.ClipRotation = param1;
      }
      
      public function set clipWidth(param1:Number) : void
      {
         this.ClipWidth = param1;
      }
      
      public function set clipHeight(param1:Number) : void
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
      
      public function set clipYOffset(param1:Number) : void
      {
         this.ClipYOffset = param1;
      }
      
      public function get clipYOffset() : Number
      {
         return this.ClipYOffset;
      }
      
      public function set clipXOffset(param1:Number) : void
      {
         this.ClipXOffset = param1;
      }
      
      public function get clipXOffset() : Number
      {
         return this.ClipXOffset;
      }
      
      public function set centerClip(param1:Boolean) : void
      {
         this.CenterClip = param1;
      }
      
      public function get centerClip() : Boolean
      {
         return this.CenterClip;
      }
      
      public function get onLoadAttemptComplete() : Function
      {
         return this._OnLoadAttemptComplete;
      }
      
      public function set onLoadAttemptComplete(param1:Function) : void
      {
         this._OnLoadAttemptComplete = param1;
      }
      
      public function set clipSizer(param1:String) : void
      {
         this.ClipSizer = param1;
      }
      
      public function get clipSizer() : String
      {
         return this.ClipSizer;
      }
      
      protected function get loader() : Loader
      {
         return this._Loader;
      }
      
      protected function Load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         this.ShowLoading();
         this._Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this._Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
         this._Loader.load(param1,param2);
      }
      
      public function Unload() : void
      {
         this.cancelLoader();
         this.HideError();
         this.HideLoading();
      }
      
      protected function onLoadFailed(param1:Event) : void
      {
         this._Loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this._Loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
         this.Unload();
         this.ShowError();
         if(this._OnLoadAttemptComplete != null)
         {
            this._OnLoadAttemptComplete();
         }
      }
      
      protected function onLoaded(param1:Event) : void
      {
         this.HideLoading();
         this._Loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this._Loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
         if(this._OnLoadAttemptComplete != null)
         {
            this._OnLoadAttemptComplete();
         }
      }
      
      private function cancelLoader() : void
      {
         try
         {
            this._Loader.close();
         }
         catch(e:Error)
         {
         }
      }
      
      protected function ShowError() : void
      {
         if(this.ErrorClip_mc == null)
         {
            this.ErrorClip_mc = this.RecreateClipFromClass(this._ErrorClassName,"ErrorClip_mc");
         }
         if(this.ErrorClip_mc != null)
         {
            this.ErrorClip_mc.visible = true;
         }
      }
      
      protected function ShowLoading() : void
      {
         if(this.LoadingClip_mc == null)
         {
            this.LoadingClip_mc = this.RecreateClipFromClass(this._LoadingClassName,"LoadingClip_mc");
         }
         if(this.LoadingClip_mc != null)
         {
            this.LoadingClip_mc.visible = true;
         }
      }
      
      protected function HideError() : void
      {
         if(this.ErrorClip_mc != null)
         {
            this.ErrorClip_mc.visible = false;
         }
      }
      
      protected function HideLoading() : void
      {
         if(this.LoadingClip_mc != null)
         {
            this.LoadingClip_mc.visible = false;
         }
      }
      
      private function RecreateClipFromClass(param1:String, param2:String = "") : MovieClip
      {
         var _loc4_:Class = null;
         var _loc3_:MovieClip = null;
         if(param1 != "" && ApplicationDomain.currentDomain.hasDefinition(param1))
         {
            if((_loc4_ = getDefinitionByName(param1) as Class) != null)
            {
               _loc3_ = new _loc4_();
               if(_loc3_ != null)
               {
                  _loc3_.name = param2;
                  this.AddDisplayObject(_loc3_);
               }
            }
         }
         return _loc3_;
      }
      
      private function onRemoveFromStageEvent(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageEvent);
         this._Loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this._Loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
         this.Unload();
      }
      
      protected function AddDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:MovieClip = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         if(param1 != null)
         {
            this.addChild(param1);
            param1.alpha = this.ClipAlpha;
            if(this.BoundClip_mc != null)
            {
               _loc2_ = param1;
               if(this.ClipSizer.length > 0)
               {
                  if((_loc6_ = param1 as MovieClip) == null)
                  {
                     GlobalFunc.TraceWarning("Only movie clips can be resized using a sizer chid. " + param1.name + " is not a movie clip.");
                  }
                  else
                  {
                     _loc2_ = _loc6_.getChildByName(this.ClipSizer) as DisplayObject;
                     if(_loc2_ == null)
                     {
                        GlobalFunc.TraceWarning(param1.name + " does not have a sizer child clip with name " + this.ClipSizer + ".");
                        _loc2_ = param1;
                     }
                  }
               }
               _loc3_ = this.BoundClip_mc.width / _loc2_.width;
               _loc4_ = this.BoundClip_mc.height / _loc2_.height;
               _loc5_ = Math.min(_loc3_,_loc4_);
               param1.scaleX = _loc5_;
               param1.scaleY = _loc5_;
               if(this.CenterClip)
               {
                  _loc7_ = GlobalFunc.GetRectangleCenter(_loc2_.getBounds(this));
                  _loc9_ = (_loc8_ = GlobalFunc.GetRectangleCenter(this.BoundClip_mc.getBounds(this))).subtract(_loc7_);
                  param1.x = _loc9_.x;
                  param1.y = _loc9_.y;
               }
               else
               {
                  param1.x = this.BoundClip_mc.x;
                  param1.y = this.BoundClip_mc.y;
               }
            }
            else
            {
               param1.scaleX = this.ClipScale;
               param1.scaleY = this.ClipScale;
               if(this.ClipWidth != 0)
               {
                  param1.width = this.ClipWidth;
               }
               if(this.ClipHeight != 0)
               {
                  param1.height = this.ClipHeight;
               }
               if(this.CenterClip)
               {
                  param1.x -= this.ClipWidth / 2;
                  param1.y -= this.ClipHeight / 2;
               }
               param1.x += this.ClipXOffset;
               param1.y += this.ClipYOffset;
            }
         }
      }
      
      protected function RemoveDisplayObject(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            this.removeChild(param1);
            if(param1.loaderInfo != null)
            {
               param1.loaderInfo.loader.unload();
            }
            param1 = null;
         }
      }
   }
}
