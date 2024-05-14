package Shared.Components.ContentLoaders
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SharedLibraryUserLoaderClip extends BaseLoaderClip
   {
      
      public static const REQUEST_LIBRARY:String = "SharedLibraryClip_RequestLibrary";
       
      
      protected var _clipInstance:MovieClip = null;
      
      protected var _sharedLibrary:LibraryLoader = null;
      
      protected var _clipClass:String = "";
      
      protected var _refreshClip:Boolean = false;
      
      public function SharedLibraryUserLoaderClip()
      {
         super();
      }
      
      public function get clipInstance() : MovieClip
      {
         return this._clipInstance;
      }
      
      public function set sharedLibrary(param1:LibraryLoader) : void
      {
         this._sharedLibrary = param1;
         if(this._sharedLibrary != null)
         {
            if(!this._sharedLibrary.isLoaded())
            {
               this._sharedLibrary.addEventListener(this._sharedLibrary.loadCompleteEventName,this.SharedLibraryLoaded);
            }
            else
            {
               this.CreateClip();
            }
         }
      }
      
      private function RequestSharedLibrary(param1:String) : void
      {
         if(this._sharedLibrary == null)
         {
            dispatchEvent(new Event(param1,true,true));
         }
      }
      
      public function SharedLibraryLoaded(param1:Event) : void
      {
         if(this._sharedLibrary != null)
         {
            this._sharedLibrary.removeEventListener(this._sharedLibrary.loadCompleteEventName,this.SharedLibraryLoaded);
            this.CreateClip();
         }
      }
      
      public function LoadClip(param1:Object, param2:String = "SharedLibraryClip_RequestLibrary") : void
      {
         this.UpdateData(param1);
         if(this._refreshClip)
         {
            this.Unload();
            this.RequestSharedLibrary(param2);
            this.CreateClip();
         }
         else if(_OnLoadAttemptComplete != null)
         {
            _OnLoadAttemptComplete();
         }
      }
      
      override public function Unload() : void
      {
         super.Unload();
         this.destroyClip();
      }
      
      private function destroyClip() : void
      {
         RemoveDisplayObject(this._clipInstance);
      }
      
      private function CreateClip() : void
      {
         if(this._sharedLibrary != null && this._sharedLibrary.isLoaded() && this._refreshClip)
         {
            this.ClipSetup();
            if(this._clipInstance != null)
            {
               AddDisplayObject(this._clipInstance);
            }
            else
            {
               this.Unload();
               ShowError();
            }
            if(_OnLoadAttemptComplete != null)
            {
               _OnLoadAttemptComplete();
            }
            this._refreshClip = false;
         }
      }
      
      protected function ClipSetup() : void
      {
         this._clipInstance = this._sharedLibrary.LoadClip(this._clipClass);
         if(this._clipInstance != null)
         {
            this._clipInstance.name = "ClipInstance";
         }
      }
      
      protected function UpdateData(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            _loc2_ = param1 as String;
            if(this._clipClass != _loc2_)
            {
               this._clipClass = _loc2_;
               this._refreshClip = true;
            }
         }
      }
   }
}
