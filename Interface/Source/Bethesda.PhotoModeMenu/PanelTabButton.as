package
{
   import Shared.Components.ButtonControls.ButtonData.ButtonData;
   import Shared.Components.ButtonControls.Buttons.TabTextButton;
   import flash.display.MovieClip;
   
   public class PanelTabButton extends TabTextButton
   {
       
      
      public var Icon_mc:MovieClip;
      
      public function PanelTabButton()
      {
         super();
      }
      
      override public function SetButtonData(param1:ButtonData) : void
      {
         var _loc2_:String = null;
         if(Data != param1)
         {
            super.SetButtonData(param1);
            if(Data != null)
            {
               _loc2_ = this.CategoryFrameLabel(Data.Payload.CategoryID);
               if(this.Icon_mc.currentFrameLabel != _loc2_)
               {
                  this.Icon_mc.gotoAndStop(_loc2_);
               }
            }
         }
      }
      
      private function CategoryFrameLabel(param1:uint) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case PhotoModePanelContainer.CAMERA_CATEGORY:
               _loc2_ = "camera";
               break;
            case PhotoModePanelContainer.PLAYER_CATEGORY:
               _loc2_ = "player";
               break;
            case PhotoModePanelContainer.CINEMATIC_CATEGORY:
               _loc2_ = "cinematic";
               break;
            case PhotoModePanelContainer.FILTERS_CATEGORY:
               _loc2_ = "filters";
               break;
            case PhotoModePanelContainer.OVERLAYS_CATEGORY:
               _loc2_ = "overlays";
         }
         return _loc2_;
      }
   }
}
