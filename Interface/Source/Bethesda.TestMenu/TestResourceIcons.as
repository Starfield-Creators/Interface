package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.Components.ContentLoaders.SharedLibraryOwner;
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import flash.events.Event;
   
   public class TestResourceIcons extends BSDisplayObject
   {
       
      
      public var ResourcesList_mc:BSScrollingContainer;
      
      private var _organicLibrary:SharedLibraryOwner = null;
      
      public function TestResourceIcons()
      {
         super();
         this._organicLibrary = new SharedLibraryOwner(this,LibraryLoaderConfig.ORGANIC_ICONS_LIBRARY_CONFIG,SharedLibraryUserLoaderClip.REQUEST_LIBRARY);
         var _loc1_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc1_.VerticalSpacing = 2;
         _loc1_.EntryClassName = "TestResource_Entry";
         this.ResourcesList_mc.Configure(_loc1_);
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("TestResourcesData",this.OnTestResourcesUpdated);
      }
      
      override public function onRemovedFromStage() : void
      {
         this._organicLibrary.RemoveEventListener();
         super.onRemovedFromStage();
      }
      
      public function ShowResources() : void
      {
         BSUIDataManager.dispatchEvent(new Event("TestMenu_ShowResources"));
      }
      
      public function OnTestResourcesUpdated(param1:FromClientDataEvent) : void
      {
         this.ResourcesList_mc.InitializeEntries(param1.data.aResources);
      }
   }
}
