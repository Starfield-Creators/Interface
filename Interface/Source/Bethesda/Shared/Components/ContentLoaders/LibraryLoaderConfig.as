package Shared.Components.ContentLoaders
{
   public class LibraryLoaderConfig
   {
      
      public static const MAP_ICONS_LIBRARY_CONFIG:LibraryLoaderConfig = new LibraryLoaderConfig("MapIcons","Structure_Unknown","MapIconsLibrary_LibraryLoaded");
      
      public static const ORGANIC_ICONS_LIBRARY_CONFIG:LibraryLoaderConfig = new LibraryLoaderConfig("OrganicIcons","Generic","OrganicIconsLibrary_Loaded");
      
      public static const SKILL_PATCHES_LIBRARY_CONFIG:LibraryLoaderConfig = new LibraryLoaderConfig("SkillPatches","PatchFull_Default","SkillPatchesLibrary_Loaded");
      
      public static const PLANET_TRAITS_LIBRARY_CONFIG:LibraryLoaderConfig = new LibraryLoaderConfig("PlanetTraitIcons","","PlanetTraitIconsLibrary_Loaded");
      
      public static const LIBRARY_LOADED:String = "LibraryLoader_Loaded";
       
      
      public var LibraryName:String = "";
      
      public var DefaultClipName:String = "";
      
      public var LoadCompleteEventName:String = "";
      
      public function LibraryLoaderConfig(param1:String, param2:String = "", param3:String = "LibraryLoader_Loaded")
      {
         super();
         this.LibraryName = param1;
         this.DefaultClipName = param2;
         this.LoadCompleteEventName = param3;
      }
   }
}
