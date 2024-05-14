package
{
   import Components.ImageFixture;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class MOTD extends MovieClip
   {
      
      public static const MOTD_TEXTURE_BUFFER:String = "MOTDTextureBuffer";
       
      
      public var MessageTitle_mc:MovieClip;
      
      public var Message_mc:MovieClip;
      
      public var FallbackImage_mc:MovieClip;
      
      public var Image_mc:ImageFixture;
      
      private var _largeTextMode:Boolean = false;
      
      private var _messageTitle:String = "";
      
      private var _messageText:String = "";
      
      public function MOTD()
      {
         super();
         this.FallbackImage_mc.Image_mc.visible = false;
         this.Image_mc.onLoadAttemptComplete = function():*
         {
            FallbackImage_mc.Image_mc.visible = Image_mc.imageInstance == null;
         };
      }
      
      public function UpdateSize(param1:Boolean) : void
      {
         if(this._largeTextMode != param1)
         {
            this._largeTextMode = param1;
            if(this._largeTextMode)
            {
               this.gotoAndStop(MainMenu.LARGE_SIZE_FRAME);
            }
            else
            {
               this.gotoAndStop(MainMenu.STANDARD_SIZE_FRAME);
            }
            GlobalFunc.SetText(this.MessageTitle_mc.MessageTitle_tf,this._messageTitle);
            GlobalFunc.SetText(this.Message_mc.Message_tf,this._messageText);
         }
      }
      
      public function UpdateData(param1:Object) : void
      {
         this._messageTitle = param1.sMessageTitle;
         this._messageText = param1.sMessage;
         GlobalFunc.SetText(this.MessageTitle_mc.MessageTitle_tf,this._messageTitle);
         GlobalFunc.SetText(this.Message_mc.Message_tf,this._messageText);
         if(param1.Image.sImageName.length > 0)
         {
            this.LoadImage(this.Image_mc,param1.Image);
         }
      }
      
      private function LoadImage(param1:ImageFixture, param2:Object) : void
      {
         if(param2.sImageName != "")
         {
            param1.LoadImageFixtureFromUIData(param2,MOTD_TEXTURE_BUFFER);
         }
         else
         {
            param1.Unload();
         }
      }
   }
}
