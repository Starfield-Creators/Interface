package
{
   import Components.ImageFixture;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import flash.events.Event;
   
   public class TestImages extends BSDisplayObject
   {
       
      
      public var Image1_mc:ImageFixture;
      
      public var Image2_mc:ImageFixture;
      
      public var Image3_mc:ImageFixture;
      
      private const TEST_IMAGE_BUFFER:String = "TestPhotoTextureBuffer";
      
      private const MAX_IMAGES:uint = 3;
      
      public function TestImages()
      {
         super();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("TestImagesData",this.OnTestImagesUpdated);
      }
      
      override public function onRemovedFromStage() : void
      {
         super.onRemovedFromStage();
      }
      
      public function ShowImages() : void
      {
         BSUIDataManager.dispatchEvent(new Event("TestMenu_ShowImages"));
      }
      
      public function OnTestImagesUpdated(param1:FromClientDataEvent) : void
      {
         var _loc3_:ImageFixture = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.aImages.length && _loc2_ < this.MAX_IMAGES)
         {
            _loc3_ = this["Image" + (_loc2_ + 1) + "_mc"];
            _loc3_.LoadImageFixtureFromUIData(param1.data.aImages[_loc2_],this.TEST_IMAGE_BUFFER);
            _loc2_++;
         }
      }
   }
}
