package
{
   import Shared.GlobalFunc;
   import flash.geom.Rectangle;
   
   public class SystemNameplate extends INameplate
   {
      
      private static var NumBeingHighlighted:int = 0;
      
      private static var NumTextBeingShown:int = 0;
       
      
      private var bHighlight:Boolean = false;
      
      private var bAlwaysShowText:Boolean = false;
      
      private var bIsPlotPoint:Boolean = false;
      
      public function SystemNameplate()
      {
         super();
      }
      
      public static function PreUpdate() : void
      {
         NumBeingHighlighted = 0;
         NumTextBeingShown = 0;
      }
      
      private static function RequestHighlightDelay() : Number
      {
         ++NumBeingHighlighted;
         return MarkerConsts.SOLARSYSTEMMARKER_HIGHLIGHT_DELAY_BASE + MarkerConsts.SOLARSYSTEMMARKER_HIGHLIGHT_DELAY_MULTIPLIER * (NumBeingHighlighted - 1);
      }
      
      private static function RequestShowTextDelay() : Number
      {
         ++NumTextBeingShown;
         return MarkerConsts.SOLARSYSTEMMARKER_SHOW_TEXT_DELAY_BASE + MarkerConsts.SOLARSYSTEMMARKER_SHOW_TEXT_DELAY_MULTIPLIER * (NumTextBeingShown - 1);
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.bHighlight = false;
         this.bAlwaysShowText = false;
      }
      
      override protected function UpdateImpl(param1:Object) : void
      {
         var _loc2_:Number = QFullTextWidth() + MarkerConsts.BG_PADDING;
         var _loc3_:Rectangle = Nameplate_mc.getBounds(stage);
         var _loc4_:* = _loc3_.left + _loc2_ > stage.stageWidth;
         Nameplate_mc.x = param1.fMarkerRadius;
         if(_loc4_)
         {
            Nameplate_mc.x = -param1.fMarkerRadius;
            Nameplate_mc.x -= _loc2_;
         }
         if(param1.bShowHighlight)
         {
            Nameplate_mc.y = Nameplate_mc.height * param1.iGroupOrder;
         }
         if(this.bAlwaysShowText != param1.bIsTextPersistent)
         {
            this.bAlwaysShowText = param1.bIsTextPersistent;
            if(this.bAlwaysShowText)
            {
               Nameplate_mc.gotoAndPlay("system_unselected");
               HideBackgroundAssets();
            }
         }
         if(this.bIsPlotPoint != param1.bIsPlotPoint)
         {
            this.bIsPlotPoint = param1.bIsPlotPoint;
            if(this.bIsPlotPoint)
            {
               Nameplate_mc.gotoAndPlay("system_unselected");
               HideBackgroundAssets();
            }
            else
            {
               Nameplate_mc.gotoAndPlay("system_close");
            }
         }
         if(this.bHighlight != param1.bShowHighlight)
         {
            this.bHighlight = param1.bShowHighlight;
            if(this.bHighlight)
            {
               Nameplate_mc.gotoAndPlay("system_selected");
               SetBackgroundWidth();
               GlobalFunc.PlayMenuSound("UIMenuStarmapRollover");
            }
            else
            {
               if(this.bAlwaysShowText == false)
               {
                  Nameplate_mc.gotoAndPlay("system_close");
               }
               else
               {
                  Nameplate_mc.gotoAndPlay("system_unselected");
               }
               HideBackgroundAssets();
            }
         }
      }
   }
}
