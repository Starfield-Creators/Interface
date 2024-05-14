package
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonManager;
   import Shared.Components.ButtonControls.ButtonData.RepeatingButtonData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.RepeatingButton;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class PhotoPageIndicator extends MovieClip
   {
      
      public static const NUMBER_PADDING:uint = 3;
      
      public static const REPEAT_INTERVAL_MS:uint = 500;
       
      
      public var LeftArrow_mc:RepeatingButton;
      
      public var RightArrow_mc:RepeatingButton;
      
      public var Current_tf:TextField;
      
      public var Total_tf:TextField;
      
      public var Background_mc:MovieClip;
      
      private var MyButtonManager:ButtonManager;
      
      private var _currentPhoto:uint = 0;
      
      private var _totalPhotos:uint = 0;
      
      private var _numPadding:uint = 0;
      
      public function PhotoPageIndicator()
      {
         this.MyButtonManager = new ButtonManager();
         super();
         this.Current_tf.autoSize = TextFieldAutoSize.RIGHT;
         this.Total_tf.autoSize = TextFieldAutoSize.LEFT;
         this.LeftArrow_mc.SetButtonData(new RepeatingButtonData("",new UserEventData("Left",function():void
         {
            ChangePhoto(false);
         }),REPEAT_INTERVAL_MS));
         this.RightArrow_mc.SetButtonData(new RepeatingButtonData("",new UserEventData("Right",function():void
         {
            ChangePhoto(true);
         }),REPEAT_INTERVAL_MS));
         this.MyButtonManager.AddButton(this.LeftArrow_mc);
         this.MyButtonManager.AddButton(this.RightArrow_mc);
      }
      
      public function SetCurrentPhoto(param1:uint) : void
      {
         this._currentPhoto = param1;
         this.LeftArrow_mc.Enabled = this._currentPhoto > 1;
         this.RightArrow_mc.Enabled = this._currentPhoto < this._totalPhotos;
         GlobalFunc.SetText(this.Current_tf,GlobalFunc.PadNumber(this._currentPhoto,this._numPadding));
      }
      
      public function SetTotalPhotos(param1:uint) : void
      {
         this._totalPhotos = param1;
         this.LeftArrow_mc.Enabled = this._currentPhoto > 1;
         this.RightArrow_mc.Enabled = this._currentPhoto < this._totalPhotos;
         this._numPadding = Math.max(NUMBER_PADDING,this._totalPhotos.toString().length);
         GlobalFunc.SetText(this.Current_tf,GlobalFunc.PadNumber(this._currentPhoto,this._numPadding));
         GlobalFunc.SetText(this.Total_tf,GlobalFunc.PadNumber(this._totalPhotos,this._numPadding));
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.MyButtonManager.ProcessUserEvent(param1,param2);
      }
      
      private function ChangePhoto(param1:Boolean) : void
      {
         dispatchEvent(new CustomEvent(PhotoViewer.CHANGE_PHOTO_EVENT,{"nextPhoto":param1},true,true));
      }
   }
}
