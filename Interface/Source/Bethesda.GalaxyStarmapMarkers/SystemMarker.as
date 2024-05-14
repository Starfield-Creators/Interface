package
{
   import Shared.EnumHelper;
   import aze.motion.EazeTween;
   import aze.motion.eaze;
   import flash.display.MovieClip;
   
   public class SystemMarker extends IMarker
   {
      
      private static const DOT_RADIUS:* = 5;
      
      public static const PLOT_POINT_NONE:uint = 0;
      
      public static const PLOT_POINT_START_END:uint = 1;
      
      public static const PLOT_POINT_CIRCLE:uint = 2;
      
      public static const GLOW_COLOR:* = 11590135;
      
      public static const GLOW_ALPHA:* = 1;
      
      public static const GLOW_QUALITY:* = 3;
      
      public static const ON_INTENSITY:* = 0.2;
      
      public static const ON_RADIUS:* = 4;
      
      public static const MARKER_COLOR_VALID_JUMP:* = EnumHelper.GetEnum(0);
      
      public static const MARKER_COLOR_INVALID_JUMP:* = EnumHelper.GetEnum();
      
      public static const MARKER_COLOR_PREVIEW:* = EnumHelper.GetEnum();
      
      public static const MARKER_COLOR_INVALID_PREVIEW:* = EnumHelper.GetEnum();
       
      
      public var poiSelected_mc:MovieClip;
      
      public var SystemPlot_mc:MovieClip;
      
      public var EndCircleMask_mc:MovieClip;
      
      public var EndPointPlot_mc:MovieClip;
      
      public var EndSystem_mc:MovieClip;
      
      private var nameplate:SystemNameplate;
      
      private var IconsTop:BodyIconsAbove;
      
      private var PlotType:uint = 0;
      
      private var HasQuest:Boolean = false;
      
      private var QuestActive:Boolean = false;
      
      private var MarkerRadius:Number = 0;
      
      public function SystemMarker()
      {
         super();
         this.nameplate = new SystemNameplate();
         addChild(this.nameplate);
         this.IconsTop = new BodyIconsAbove();
         addChild(this.IconsTop);
         this.ResetValues();
      }
      
      override public function QWidth() : Number
      {
         return DOT_RADIUS * this.MarkerRadius;
      }
      
      override public function QHeight() : Number
      {
         return DOT_RADIUS * this.MarkerRadius;
      }
      
      override public function ResetValues() : void
      {
         this.poiSelected_mc.visible = false;
         this.SystemPlot_mc.visible = false;
         this.EndPointPlot_mc.visible = false;
         this.EndSystem_mc.visible = false;
         this.IconsTop.ResetIcons();
      }
      
      override public function Update(param1:Object) : void
      {
         this.name = param1.sMarkerText;
         if(param1.bShowHighlight)
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this.nameplate.Update(param1);
         this.IconsTop.Update(param1,true);
         this.MarkerRadius = param1.fMarkerRadius;
         this.HasQuest = param1.bHasQuestTarget;
         this.QuestActive = param1.bQuestActive;
         bodyID = param1.uBodyID;
      }
      
      public function SetPlotCircleColor(param1:int) : *
      {
         switch(param1)
         {
            case MARKER_COLOR_VALID_JUMP:
               this.SystemPlot_mc.gotoAndStop("CanJump");
               break;
            case MARKER_COLOR_INVALID_JUMP:
               this.SystemPlot_mc.gotoAndStop("CannotJump");
               break;
            case MARKER_COLOR_PREVIEW:
               this.SystemPlot_mc.gotoAndStop("Preview");
               break;
            case MARKER_COLOR_INVALID_PREVIEW:
               this.SystemPlot_mc.gotoAndStop("PreviewInvalid");
         }
      }
      
      public function SetStartEndPlotColor(param1:int) : *
      {
         switch(param1)
         {
            case MARKER_COLOR_VALID_JUMP:
               this.EndPointPlot_mc.gotoAndStop("CanJump");
               break;
            case MARKER_COLOR_INVALID_JUMP:
               this.EndPointPlot_mc.gotoAndStop("CannotJump");
               break;
            case MARKER_COLOR_PREVIEW:
               this.EndPointPlot_mc.gotoAndStop("Preview");
               break;
            case MARKER_COLOR_INVALID_PREVIEW:
               this.EndPointPlot_mc.gotoAndStop("PreviewInvalid");
         }
      }
      
      public function SetPlotPointType(param1:uint) : void
      {
         this.PlotType = param1;
         switch(this.PlotType)
         {
            case PLOT_POINT_NONE:
               EazeTween.killTweensOf(this.EndPointPlot_mc);
               EazeTween.killTweensOf(this.SystemPlot_mc);
               this.SystemPlot_mc.visible = false;
               this.EndPointPlot_mc.visible = false;
               this.EndSystem_mc.visible = false;
               break;
            case PLOT_POINT_START_END:
               EazeTween.killTweensOf(this.SystemPlot_mc);
               this.SystemPlot_mc.visible = false;
               this.EndPointPlot_mc.visible = true;
               this.EndPointPlot_mc.alpha = 1;
               this.EndPointPlot_mc.EndCircleMask_mc.gotoAndStop("on");
               this.EndSystem_mc.visible = false;
               break;
            case PLOT_POINT_CIRCLE:
               EazeTween.killTweensOf(this.EndPointPlot_mc);
               this.SystemPlot_mc.visible = true;
               this.SystemPlot_mc.alpha = 1;
               this.EndPointPlot_mc.visible = false;
               this.EndSystem_mc.visible = false;
         }
      }
      
      public function FadePlotPointVisuals(param1:Number, param2:Number, param3:Number) : *
      {
         switch(this.PlotType)
         {
            case PLOT_POINT_START_END:
               EazeTween.killTweensOf(this.EndPointPlot_mc);
               eaze(this.EndPointPlot_mc).apply({"alpha":param1}).to(param3,{"alpha":param2});
               break;
            case PLOT_POINT_CIRCLE:
               EazeTween.killTweensOf(this.SystemPlot_mc);
               eaze(this.SystemPlot_mc).apply({"alpha":param1}).to(param3,{"alpha":param2});
         }
      }
      
      public function FadeIcons(param1:Number, param2:Number, param3:Number) : *
      {
         EazeTween.killTweensOf(this.IconsTop);
         eaze(this.IconsTop).apply({"alpha":param1}).to(param3,{"alpha":param2});
      }
      
      public function UpdateEndStartRotation(param1:Number, param2:Number) : void
      {
         this.EndPointPlot_mc.rotation = -(Math.atan2(x - param1,y - param2) * 180 / Math.PI);
      }
      
      public function OnRemovedFromRoute() : *
      {
         this.EndPointPlot_mc.EndCircleMask_mc.gotoAndPlay("closeEnd");
      }
   }
}
