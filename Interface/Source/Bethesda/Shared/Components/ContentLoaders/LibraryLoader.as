package Shared.Components.ContentLoaders
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class LibraryLoader extends EventDispatcher
   {
       
      
      private var _loader:Loader = null;
      
      private var _libraryClip:DisplayObject = null;
      
      private var _libraryName:String = "";
      
      private var _defaultClipName:String = "";
      
      private var _loadCompleteEventName:String = "";
      
      public function LibraryLoader(param1:LibraryLoaderConfig)
      {
         super();
         this._libraryName = param1.LibraryName;
         this._defaultClipName = param1.DefaultClipName;
         this._loadCompleteEventName = param1.LoadCompleteEventName;
         var _loc2_:URLRequest = new URLRequest(this._libraryName + ".swf");
         var _loc3_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.load(_loc2_,_loc3_);
      }
      
      public function get loadCompleteEventName() : String
      {
         return this._loadCompleteEventName;
      }
      
      public function UnloadLibrary() : void
      {
         this._libraryClip = null;
         try
         {
            this._loader.close();
         }
         catch(e:Error)
         {
         }
      }
      
      public function isLoaded() : Boolean
      {
         return this._libraryClip != null;
      }
      
      private function onLoadComplete(param1:Event) : *
      {
         param1.target.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this._libraryClip = param1.target.content;
         dispatchEvent(new Event(this._loadCompleteEventName,true,true));
      }
      
      public function LoadClip(param1:String, param2:String = "") : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         if(this.isLoaded())
         {
            if(_loc4_ = param1 != null && param1 != "" ? this._libraryClip.loaderInfo.applicationDomain.getDefinition(param1) as Class : null)
            {
               _loc3_ = new _loc4_();
            }
            else
            {
               if(param2 != "")
               {
                  if(_loc4_ = this._libraryClip.loaderInfo.applicationDomain.getDefinition(param2) as Class)
                  {
                     _loc3_ = new _loc4_();
                  }
               }
               if(_loc4_ == null && this._defaultClipName != "")
               {
                  if(_loc4_ = this._libraryClip.loaderInfo.applicationDomain.getDefinition(this._defaultClipName) as Class)
                  {
                     _loc3_ = new _loc4_();
                  }
               }
            }
         }
         return _loc3_;
      }
   }
}
