package
{
   import Components.LabeledMeterLargeDataCard;
   import Components.ModularPanelObject;
   import Components.StarMapWidgets.SystemView;
   import Components.StarMapWidgets.SystemViewHolder;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class SystemInfoPanelMini extends ModularPanelObject
   {
      
      private static const DESIRED_VIEW_WIDTH:Number = 320;
      
      private static const DESIRED_VIEW_WIDTH_LRG:Number = 500;
      
      public static const SYSTEM_VIEW_PLANET_SCALE:Number = 1;
      
      public static const SYSTEM_VIEW_MOON_SCALE:Number = 1;
       
      
      public var SystemViewHolder_mc:SystemViewHolder;
      
      public var SurveyMeter_mc:LabeledMeterLargeDataCard;
      
      public var Background_mc:MovieClip;
      
      public var currentSystemInfo:Object;
      
      public function SystemInfoPanelMini()
      {
         this.currentSystemInfo = new Object();
         super();
      }
      
      private function get desiredSystemViewWidth() : Number
      {
         return DESIRED_VIEW_WIDTH;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.SurveyMeter_mc.SetLabel("$SURVEY");
         this.SurveyMeter_mc.SetValueSuffix("%");
         this.SurveyMeter_mc.Max_tf.visible = false;
         this.SurveyMeter_mc.Weight_mc.visible = false;
         if(this.SurveyMeter_mc != null)
         {
            this.SurveyMeter_mc.SetTargetPercent(0);
         }
         this.LoadPlanets();
      }
      
      public function SetSystemBodyInfo(param1:Object) : *
      {
         this.UpdateData(param1);
      }
      
      public function GetDesiredSystemScale() : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = 1;
         var _loc2_:SystemView = this.SystemViewHolder_mc.SystemView_mc;
         if(Boolean(_loc2_) && _loc2_.NumChildren > 0)
         {
            _loc3_ = _loc2_.GetTargetChildX(_loc2_.NumChildren - 1) + _loc2_.GetChildSpacingX() / 2;
            _loc4_ = this.desiredSystemViewWidth / 2;
            _loc1_ = GlobalFunc.Clamp(_loc4_ / _loc3_,0.01,1);
         }
         return _loc1_;
      }
      
      private function UpdateData(param1:Object) : *
      {
         this.SystemViewHolder_mc.UpdateSystemView(param1,this.currentSystemInfo.focusedCelestialBodyID);
         if(param1.focusedBodyType == BSGalaxyTypes.BT_PLANET)
         {
            this.SystemViewHolder_mc.FocusBody(param1.focusedBodyID,SYSTEM_VIEW_PLANET_SCALE);
         }
         else if(param1.focusedBodyType == BSGalaxyTypes.BT_MOON)
         {
            this.SystemViewHolder_mc.FocusBody(param1.focusedBodyID,SYSTEM_VIEW_MOON_SCALE);
         }
         else
         {
            this.SystemViewHolder_mc.FocusBody(0,this.GetDesiredSystemScale());
         }
      }
      
      public function ShowSystemInfo() : *
      {
         AddToInfoPanelArray(this.SystemViewHolder_mc);
         AddToInfoPanelArray(this.SurveyMeter_mc);
         addEventListener("OpenBackground",this.SetBackground);
         addEventListener("NextAnimation",PlayNextAnimation);
         gotoAndPlay("Open");
      }
      
      private function SetBackground() : *
      {
         OpenBackgroundAnimation(this.Background_mc);
      }
      
      public function HideSystemInfo() : *
      {
         gotoAndPlay("Close");
         OnClose(this.Background_mc);
      }
      
      private function LoadPlanets() : *
      {
         BSUIDataManager.Subscribe("DataMenuData",function(param1:FromClientDataEvent):*
         {
            currentSystemInfo = param1.data.CurrentSystemBodyInfo;
         });
      }
      
      public function SetSystemInfo(param1:Object) : *
      {
         if(this.SurveyMeter_mc != null)
         {
            this.SurveyMeter_mc.SetTargetPercent(param1.surveyPercent);
         }
      }
   }
}
