package
{
   import Components.IconOrganizer;
   
   public class BodyIconsAbove extends IconOrganizer
   {
       
      
      private const OUTPOST_ICON:String = "OutpostIcon_mc";
      
      private const PLOT_TARGET_ICON:String = "PlotTargetIcon_mc";
      
      private const CITY_ICON:String = "CityIcon_mc";
      
      private const CANT_PLOT_ICON:String = "CantPlotIcon_mc";
      
      private const MISSION_ICON_CONTAINER:String = "MissionIconContainer_mc";
      
      public function BodyIconsAbove()
      {
         super();
         Icons_mc.setChildIndex(Icons_mc[this.MISSION_ICON_CONTAINER],Icons_mc.numChildren - 1);
         this.Align_Inspectable = IconOrganizer.ALIGN_CENTER;
         this.IconSpacing_Inspectable = 12;
      }
      
      public function get IsLargeTextMode() : Boolean
      {
         return false;
      }
      
      final public function Update(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Boolean = Boolean(param1.bForceHideText);
         SetIconVisible(this.OUTPOST_ICON,Boolean(param1.bHasOutpost) && !_loc3_);
         SetIconVisible(this.PLOT_TARGET_ICON,Boolean(param1.bIsPlotPoint) && !_loc3_ && !param2);
         SetIconVisible(this.CITY_ICON,Boolean(param1.bIsSettled) && !_loc3_);
         this.UpdateMissionIcon(param1);
         if(param1.hasOwnProperty("bAllowPlot"))
         {
            SetIconVisible(this.CANT_PLOT_ICON,!param1.bAllowPlot && !_loc3_);
         }
         else
         {
            SetIconVisible(this.CANT_PLOT_ICON,false);
         }
         this.x = 0;
         var _loc4_:Number = param1.fMarkerHeight + MarkerConsts.BODY_ICON_PADDING;
         if(this.IsLargeTextMode && _loc4_ < MarkerConsts.BODY_ICON_SPACING_MIN_LRG)
         {
            _loc4_ = MarkerConsts.BODY_ICON_SPACING_MIN_LRG;
         }
         this.y = -_loc4_;
      }
      
      internal function UpdateMissionIcon(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1.bHasQuestTarget);
         SetIconVisible(this.MISSION_ICON_CONTAINER,_loc2_ && !param1.bForceHideText);
         if(_loc2_)
         {
            (Icons_mc[this.MISSION_ICON_CONTAINER] as MissionIconContainer).Update(param1);
         }
      }
   }
}
