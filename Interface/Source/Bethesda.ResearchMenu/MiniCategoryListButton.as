package
{
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import Shared.Components.ButtonControls.Buttons.PipButton;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MiniCategoryListButton extends PipButton
   {
       
      
      public var EntryIcon_mc:MovieClip;
      
      public var NewIcon_mc:MovieClip;
      
      public function MiniCategoryListButton()
      {
         super();
      }
      
      public function GetData() : MiniCategoryButtonData
      {
         return Data as MiniCategoryButtonData;
      }
      
      override protected function UpdateButtonText() : void
      {
         var _loc1_:MiniCategoryButtonData = this.GetData();
         if(_loc1_ != null)
         {
            dispatchEvent(new Event(BUTTON_DATA_CHANGE));
            this.EntryIcon_mc.gotoAndStop(_loc1_.Payload.IconName);
            this.NewIcon_mc.visible = _loc1_.Payload.HasNew;
         }
         clearInvalidation(IButtonUtils.INVALID_BINDING_TEXT);
      }
      
      override protected function HandleButtonHit(param1:Event, param2:UserEventData = null) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param2 == null && Data.UserEvents.NumUserEvents == 1)
         {
            param2 = Data.UserEvents.GetUserEventByIndex(0);
         }
         if(param2 != null)
         {
            if(Enabled && param2.bEnabled && param2.funcCallback != null && Data is MiniCategoryButtonData)
            {
               param2.funcCallback(this.GetData().CategoryIndex);
            }
            if(Enabled && param2.bEnabled && param2.sCodeCallback.length > 0)
            {
               SendEvent(param2);
            }
            _loc3_ = Enabled && param2.bEnabled;
         }
         return _loc3_;
      }
      
      override public function set Height(param1:Number) : void
      {
         ButtonBackground_mc.ButtonBackgroundResizable_mc.height = param1;
      }
   }
}
