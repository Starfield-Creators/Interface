package Components.Icons
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class MapIconsLibrary extends EventDispatcher
   {
      
      public static const LIBRARY_LOADED:String = "MapIconsLibrary::LIBRARY_LOADED";
      
      private static const STRUCTURE_SIMPLE:String = "Structure_Simple";
      
      private static const STRUCTURE_UNKNOWN:String = "Structure_Unknown";
       
      
      private var _Loader:Loader = null;
      
      private var _LibraryClip:DisplayObject = null;
      
      public function MapIconsLibrary()
      {
         super();
         this._Loader = new Loader();
         var _loc1_:URLRequest = new URLRequest("MapIcons.swf");
         var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this._Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onIconLoadComplete);
         this._Loader.load(_loc1_,_loc2_);
      }
      
      public function isLoaded() : Boolean
      {
         return this._LibraryClip != null;
      }
      
      private function onIconLoadComplete(param1:Event) : *
      {
         param1.target.removeEventListener(Event.COMPLETE,this.onIconLoadComplete);
         this._LibraryClip = param1.target.content;
         dispatchEvent(new Event(LIBRARY_LOADED,true,true));
      }
      
      public function LoadIcon(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         if(this.isLoaded())
         {
            _loc3_ = param1 != null && param1 != "" ? this._LibraryClip.loaderInfo.applicationDomain.getDefinition(param1) as Class : null;
            if(_loc3_)
            {
               _loc2_ = new _loc3_();
            }
            else
            {
               _loc3_ = this._LibraryClip.loaderInfo.applicationDomain.getDefinition(STRUCTURE_UNKNOWN) as Class;
               if(_loc3_)
               {
                  _loc2_ = new _loc3_();
               }
            }
         }
         return _loc2_;
      }
   }
}
