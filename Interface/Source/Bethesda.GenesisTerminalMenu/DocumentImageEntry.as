package
{
   import Components.ImageFixture;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class DocumentImageEntry extends MovieClip implements IDocumentEntry
   {
      
      internal static const TextureFilePath:String = "Textures/Interface/Objects/Terminal/";
       
      
      public var Image_mc:ImageFixture;
      
      public var Caption_tf:TextField;
      
      public var LoadingBG_mc:MovieClip;
      
      public function DocumentImageEntry(param1:Object)
      {
         super();
         this.Image_mc.onLoadAttemptComplete = this.onImageLoadAttemptComplete;
         this.Image_mc.clipWidth = this.LoadingBG_mc.width;
         this.Image_mc.clipHeight = this.LoadingBG_mc.height;
         this.SetData(param1);
      }
      
      public function SetData(param1:Object) : void
      {
         this.Image_mc.LoadInternal(TextureFilePath + param1.arg0 + ".dds","TerminalImages");
         GlobalFunc.SetText(this.Caption_tf,param1.arg1);
      }
      
      private function onImageLoadAttemptComplete() : void
      {
         if(this.Image_mc.imageInstance != null)
         {
            this.LoadingBG_mc.visible = false;
         }
      }
   }
}
