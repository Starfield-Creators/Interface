package
{
   import Shared.AS3.BSGridList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.IMenu;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.Components.ButtonControls.Buttons.IButton;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class PhotoGalleryMenu extends IMenu
   {
      
      public static const PHOTO_GALLERY_TEXTURE_BUFFER:String = "PhotoGalleryTextureBuffer";
       
      
      public var ConfirmPrompt_mc:MovieClip;
      
      public var Gallery_mc:PhotoGallery;
      
      public var Viewer_mc:PhotoViewer;
      
      public var ButtonBar_mc:ButtonBar;
      
      private const BUTTON_BAR_BG_HORIZONTAL_PADDING:Number = 5;
      
      private const INIT_MODE:int = EnumHelper.GetEnum(0);
      
      private const GALLERY_MODE:int = EnumHelper.GetEnum();
      
      private const VIEW_MODE:int = EnumHelper.GetEnum();
      
      private const CONFIRM_MODE:int = EnumHelper.GetEnum();
      
      private var ViewButton:IButton = null;
      
      private var ToggleUIButton:IButton = null;
      
      private var DeleteButton:IButton = null;
      
      private var ExitButtonData:ButtonBaseData;
      
      private var ConfirmButton:IButton = null;
      
      private var _currentMode:int;
      
      private var _numberOfPhotos:uint = 0;
      
      private var _hideMenu:Boolean = false;
      
      public function PhotoGalleryMenu()
      {
         this.ExitButtonData = new ButtonBaseData("$EXIT",new UserEventData("Cancel",this.ExitMenu));
         this._currentMode = this.INIT_MODE;
         super();
         this.ConfirmPrompt_mc.visible = false;
      }
      
      private function get ExitButton() : IButton
      {
         return this.ButtonBar_mc.ExitButton_mc;
      }
      
      private function get CancelButton() : IButton
      {
         return this.ConfirmPrompt_mc.ButtonBar_mc.ExitButton_mc;
      }
      
      public function get hideMenu() : Boolean
      {
         return this._hideMenu;
      }
      
      public function set hideMenu(param1:Boolean) : void
      {
         if(this.hideMenu != param1)
         {
            this._hideMenu = param1;
            this.ButtonBar_mc.visible = !this.hideMenu;
            this.Viewer_mc.HideUI(this.hideMenu);
            this.UpdateButtons();
         }
      }
      
      public function get currentMode() : int
      {
         return this._currentMode;
      }
      
      public function set currentMode(param1:int) : void
      {
         if(this.currentMode != param1)
         {
            this._currentMode = param1;
            switch(this._currentMode)
            {
               case this.GALLERY_MODE:
                  this.Gallery_mc.active = true;
                  this.Viewer_mc.active = false;
                  this.ConfirmPrompt_mc.visible = false;
                  this.hideMenu = false;
                  break;
               case this.VIEW_MODE:
                  this.Gallery_mc.active = false;
                  this.Viewer_mc.active = true;
                  this.ConfirmPrompt_mc.visible = false;
                  break;
               case this.CONFIRM_MODE:
                  this.hideMenu = true;
                  this.Gallery_mc.active = false;
                  this.ConfirmPrompt_mc.visible = true;
            }
            this.UpdateButtons();
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.SetUpButtons();
         addEventListener(PhotoGallery.THUMBNAIL_PRESSED_EVENT,this.ViewPhoto);
         addEventListener(PhotoViewer.CHANGE_PHOTO_EVENT,this.ChangePhoto);
         BSUIDataManager.Subscribe("PhotoGalleryData",this.OnPhotoGalleryDataUpdate);
         this.currentMode = this.GALLERY_MODE;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this.currentMode == this.CONFIRM_MODE)
         {
            _loc3_ = Boolean(this.ConfirmPrompt_mc.ButtonBar_mc.ProcessUserEvent(param1,param2));
         }
         if(!_loc3_)
         {
            _loc3_ = this.Viewer_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            _loc3_ = this.ButtonBar_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      private function SetUpButtons() : void
      {
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT);
         this.ButtonBar_mc.SetBackgroundPadding(this.BUTTON_BAR_BG_HORIZONTAL_PADDING,0);
         this.ViewButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$ENLARGE",new UserEventData("Accept",this.ViewPhoto),true,true,"UIPhotomodeEnlarge"),this.ButtonBar_mc);
         this.ToggleUIButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$HIDE UI",new UserEventData("Select",this.ToggleUI),true,true,"UIPhotomodeHideUI"),this.ButtonBar_mc);
         this.DeleteButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$DELETE",new UserEventData("XButton",this.DeletePhoto),true,true,"UIToolTipPopUpStart"),this.ButtonBar_mc);
         this.ButtonBar_mc.AddButtonWithData(this.ExitButton,this.ExitButtonData);
         this.ButtonBar_mc.RefreshButtons();
         this.ConfirmPrompt_mc.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_CENTER);
         this.ConfirmPrompt_mc.ButtonBar_mc.SetBackgroundPadding(this.BUTTON_BAR_BG_HORIZONTAL_PADDING,0);
         this.ConfirmButton = ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$CONFIRM",new UserEventData("Accept",this.DeletePhoto),true,true,"UIPhotomodeDelete"),this.ConfirmPrompt_mc.ButtonBar_mc);
         this.ConfirmPrompt_mc.ButtonBar_mc.AddButtonWithData(this.CancelButton,new ButtonBaseData("$CANCEL",new UserEventData("Cancel",this.HidePrompt),true,true,"UIMenuGeneralCancel"));
         this.ConfirmPrompt_mc.ButtonBar_mc.RefreshButtons();
      }
      
      private function UpdateButtons() : void
      {
         var _loc1_:* = this.currentMode == this.GALLERY_MODE;
         var _loc2_:* = this.currentMode == this.VIEW_MODE;
         var _loc3_:* = this.currentMode == this.CONFIRM_MODE;
         var _loc4_:* = this._numberOfPhotos > 0;
         this.ViewButton.Enabled = _loc1_ && _loc4_;
         this.ViewButton.Visible = _loc1_;
         this.ToggleUIButton.Enabled = _loc2_;
         this.ToggleUIButton.Visible = _loc2_;
         this.DeleteButton.Enabled = !this.hideMenu && _loc4_;
         this.DeleteButton.Visible = !this.hideMenu;
         this.ExitButtonData.sButtonText = _loc2_ ? "$BACK" : "$EXIT";
         this.ExitButton.SetButtonData(this.ExitButtonData);
         this.ExitButton.Enabled = !_loc3_;
         this.ButtonBar_mc.RefreshButtons();
         this.ConfirmButton.Enabled = _loc3_;
         this.ConfirmButton.Visible = _loc3_;
         this.CancelButton.Enabled = _loc3_;
         this.CancelButton.Visible = _loc3_;
         this.ConfirmPrompt_mc.ButtonBar_mc.RefreshButtons();
      }
      
      private function OnPhotoGalleryDataUpdate(param1:FromClientDataEvent) : void
      {
         this._numberOfPhotos = param1.data.aPhotos.length;
         this.Gallery_mc.SetPhotoThumbnails(param1.data.aPhotos);
         this.Viewer_mc.SetTotal(this._numberOfPhotos);
         this.Viewer_mc.SetScreenSize(param1.data.uScreenWidth,param1.data.uScreenHeight);
         if(this.currentMode == this.VIEW_MODE)
         {
            this.ViewPhoto();
         }
         this.UpdateButtons();
      }
      
      private function ViewPhoto() : void
      {
         var _loc1_:* = this.Gallery_mc.ThumbnailGrid_mc.selectedEntry;
         if(_loc1_ != null)
         {
            this.Viewer_mc.SetPhoto(_loc1_,this.Gallery_mc.ThumbnailGrid_mc.selectedIndex + 1);
            this.currentMode = this.VIEW_MODE;
         }
         else
         {
            this.currentMode = this.GALLERY_MODE;
         }
      }
      
      private function ChangePhoto(param1:CustomEvent) : void
      {
         this.Gallery_mc.ThumbnailGrid_mc.MoveSelection(!!param1.params.nextPhoto ? BSGridList.DIRECTION_RIGHT : BSGridList.DIRECTION_LEFT);
         this.ViewPhoto();
      }
      
      private function DeletePhoto() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         if(this.currentMode == this.CONFIRM_MODE)
         {
            _loc1_ = this.Gallery_mc.ThumbnailGrid_mc.selectedEntry;
            if(_loc1_ != null)
            {
               _loc2_ = String(_loc1_.sDirectory + _loc1_.sImageName);
               BSUIDataManager.dispatchCustomEvent("PhotoGallery_DeletePhoto",{"photoName":_loc2_});
            }
            this.HidePrompt();
         }
         else
         {
            this.currentMode = this.CONFIRM_MODE;
         }
      }
      
      private function HidePrompt() : void
      {
         this.hideMenu = false;
         if(this.Viewer_mc.active)
         {
            this.currentMode = this.VIEW_MODE;
         }
         else
         {
            this.currentMode = this.GALLERY_MODE;
         }
      }
      
      private function ToggleUI() : void
      {
         this.hideMenu = !this.hideMenu;
      }
      
      private function ExitMenu() : void
      {
         if(this.currentMode == this.VIEW_MODE)
         {
            this.currentMode = this.GALLERY_MODE;
         }
         else
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
            GlobalFunc.CloseMenu("PhotoGalleryMenu");
         }
      }
   }
}
