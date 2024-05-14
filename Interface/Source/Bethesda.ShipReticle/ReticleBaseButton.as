package
{
   import Shared.Components.ButtonControls.Buttons.ButtonBase;
   import Shared.Components.ButtonControls.Buttons.IButtonUtils;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class ReticleBaseButton extends ButtonBase
   {
      
      private static const BACKGROUND_BUFFER:Number = 20;
       
      
      public var BackgroundCenter_mc:MovieClip;
      
      public function ReticleBaseButton()
      {
         super();
      }
      
      override protected function UpdateBackground() : void
      {
         var _loc1_:Rectangle = null;
         if(stage != null && Data != null)
         {
            _loc1_ = GetAdjustedBounds();
            if(PCButtonInstance_mc != null && PCButtonInstance_mc.visible)
            {
               this.BackgroundCenter_mc.x = globalToLocal(_loc1_.topLeft).x - 19;
               this.BackgroundCenter_mc.width = _loc1_.bottomRight.x - _loc1_.topLeft.x + 27;
            }
            if(ConsoleButtonInstance_mc != null && ConsoleButtonInstance_mc.visible)
            {
               this.BackgroundCenter_mc.x = globalToLocal(_loc1_.topLeft).x - 18;
               this.BackgroundCenter_mc.width = _loc1_.bottomRight.x - _loc1_.topLeft.x + 20;
            }
         }
         clearInvalidation(IButtonUtils.INVALID_BACKGROUND);
      }
      
      public function SetBackgroundVisibility(param1:Boolean) : *
      {
         this.BackgroundCenter_mc.visible = param1;
      }
   }
}
