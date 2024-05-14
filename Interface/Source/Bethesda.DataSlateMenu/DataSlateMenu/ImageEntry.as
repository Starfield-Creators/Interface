package DataSlateMenu
{
   import Components.ImageFixture;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ImageEntry extends MovieClip implements IDataSlateEntry
   {
       
      
      public var Image_mc:ImageFixture;
      
      public var Caption_mc:MovieClip;
      
      public var LoadingBG_mc:MovieClip;
      
      public function ImageEntry()
      {
         super();
         this.Image_mc.onLoadAttemptComplete = this.onImageLoadAttemptComplete;
      }
      
      public function SetData(param1:Object) : void
      {
         this.Image_mc.LoadInternal("Textures/Interface/Objects/DataSlate/" + param1.arg0 + ".dds","DataSlateImages");
         GlobalFunc.SetText(this.Caption_mc.Text_tf,param1.arg1);
      }
      
      private function onImageLoadAttemptComplete() : void
      {
         var _loc1_:Number = NaN;
         if(this.Image_mc.imageInstance != null)
         {
            _loc1_ = this.Image_mc.imageInstance.width / this.Image_mc.imageInstance.height;
            if(_loc1_ >= 1)
            {
               this.Image_mc.imageInstance.width = this.LoadingBG_mc.width;
               this.Image_mc.imageInstance.height = this.LoadingBG_mc.width / _loc1_;
            }
            else
            {
               this.Image_mc.imageInstance.width = this.LoadingBG_mc.height / _loc1_;
               this.Image_mc.imageInstance.height = this.LoadingBG_mc.height;
            }
            this.LoadingBG_mc.visible = false;
            this.Caption_mc.y = this.Image_mc.y + this.Image_mc.imageInstance.height;
         }
      }
   }
}
