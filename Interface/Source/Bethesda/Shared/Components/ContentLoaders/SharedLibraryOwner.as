package Shared.Components.ContentLoaders
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class SharedLibraryOwner
   {
       
      
      private var _sharedLibrary:LibraryLoader = null;
      
      private var _eventListener:EventDispatcher = null;
      
      private var _libraryConfig:LibraryLoaderConfig = null;
      
      private var _requestEventName:String = "";
      
      public function SharedLibraryOwner(param1:EventDispatcher, param2:LibraryLoaderConfig, param3:String)
      {
         super();
         this._eventListener = param1;
         this._libraryConfig = param2;
         this._requestEventName = param3;
         this._eventListener.addEventListener(this._requestEventName,this.SetLibraryLoader);
      }
      
      public function RemoveEventListener() : void
      {
         this._eventListener.removeEventListener(this._requestEventName,this.SetLibraryLoader);
         if(this._sharedLibrary != null)
         {
            this._sharedLibrary.UnloadLibrary();
         }
      }
      
      public function SetLibraryLoader(param1:Event) : void
      {
         if(this._sharedLibrary == null)
         {
            this._sharedLibrary = new LibraryLoader(this._libraryConfig);
         }
         param1.target.sharedLibrary = this._sharedLibrary;
      }
   }
}
