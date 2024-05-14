package
{
   import Components.ImageFixture;
   import Shared.AS3.BSGridListEntry;
   
   public class PhotoThumbnail_Entry extends BSGridListEntry
   {
       
      
      public var Thumbnail_mc:ImageFixture;
      
      public function PhotoThumbnail_Entry()
      {
         super();
         this.Thumbnail_mc.centerClip = true;
      }
      
      override public function SetEntryData(param1:Object) : *
      {
         this.Thumbnail_mc.LoadImageFixtureFromUIData(param1,PhotoGalleryMenu.PHOTO_GALLERY_TEXTURE_BUFFER);
      }
   }
}
