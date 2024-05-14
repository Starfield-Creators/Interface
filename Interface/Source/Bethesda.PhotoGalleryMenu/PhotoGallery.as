package
{
   import Shared.AS3.BSGridList;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.GlobalFunc;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PhotoGallery extends MovieClip
   {
      
      public static const THUMBNAIL_PRESSED_EVENT:String = "PhotoGallery_ThumbnailPressed";
       
      
      public var ThumbnailGrid_mc:BSGridList;
      
      private var _active:Boolean = false;
      
      private const COL_SPACING:Number = 11;
      
      private const ROW_SPACING:Number = 10;
      
      private const MAX_COLUMNS:Number = 4;
      
      private const MAX_ROWS:Number = 3;
      
      public function PhotoGallery()
      {
         super();
         this.ThumbnailGrid_mc.Configure(PhotoThumbnail_Entry,this.MAX_COLUMNS,this.MAX_ROWS,this.COL_SPACING,this.ROW_SPACING);
         addEventListener(ScrollingEvent.ITEM_PRESS,this.OnEntryPress);
         addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         if(this.active != param1)
         {
            this._active = param1;
            stage.focus = this.active ? this.ThumbnailGrid_mc : null;
         }
      }
      
      public function SetPhotoThumbnails(param1:Array) : void
      {
         this.ThumbnailGrid_mc.entryData = param1;
         if(this.ThumbnailGrid_mc.selectedIndex == -1 && this.ThumbnailGrid_mc.entryCount > 0)
         {
            this.ThumbnailGrid_mc.selectedIndex = 0;
         }
         else if(this.ThumbnailGrid_mc.entryCount == 0)
         {
            this.ThumbnailGrid_mc.selectedIndex = -1;
         }
      }
      
      private function OnEntryPress(param1:Event) : void
      {
         var _loc2_:* = this.ThumbnailGrid_mc.selectedEntry;
         if(_loc2_ != null)
         {
            GlobalFunc.PlayMenuSound("UIPhotomodeEnlarge");
            dispatchEvent(new Event(THUMBNAIL_PRESSED_EVENT,true,true));
         }
      }
      
      private function PlayFocusSound(param1:Event) : void
      {
         GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
      }
   }
}
