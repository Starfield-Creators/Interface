package
{
   import Components.LabeledMeterLargeDataCard;
   import Components.StarMapWidgets.SystemView;
   import Components.StarMapWidgets.SystemViewHolder;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.BSEaze;
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SystemInfoPanel extends BSDisplayObject
   {
      
      private static const FULL_WIDTH:Number = 361;
      
      private static const FULL_WIDTH_LRG:Number = 500;
      
      private static const PANEL_RESIZE_TIME:Number = 0.25;
      
      public static const SYSTEM_VIEW_PLANET_SCALE:Number = 1;
      
      public static const SYSTEM_VIEW_MOON_SCALE:Number = 1;
       
      
      public var SystemViewHolder_mc:SystemViewHolder;
      
      public var SystemHeader_mc:MovieClip;
      
      public var SystemNameHeader_mc:SystemNameHeader;
      
      public var DataListLarge_mc:MovieClip;
      
      public var SurveyMeter_mc:LabeledMeterLargeDataCard;
      
      public var Background_mc:MovieClip;
      
      private var IsOpen:Boolean = false;
      
      private var PanelWidthTarget:Number;
      
      private var ContentArray:Array;
      
      public var currentSystemInfo:Object;
      
      public function SystemInfoPanel()
      {
         this.PanelWidthTarget = this.FullWidth;
         this.currentSystemInfo = new Object();
         super();
         this.ContentArray = [];
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      private function get FullWidth() : Number
      {
         return FULL_WIDTH;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         GlobalFunc.SetText(this.DataListLarge_mc.Data1_mc.Name_mc.text_tf,"$STAR TYPE");
         GlobalFunc.SetText(this.DataListLarge_mc.Data2_mc.Name_mc.text_tf,"$GI");
         GlobalFunc.SetText(this.DataListLarge_mc.Data3_mc.Name_mc.text_tf,"$TEMPERATURE");
         GlobalFunc.SetText(this.DataListLarge_mc.Data4_mc.Name_mc.text_tf,"$MASS");
         GlobalFunc.SetText(this.DataListLarge_mc.Data5_mc.Name_mc.text_tf,"$RADIUS");
         GlobalFunc.SetText(this.DataListLarge_mc.Data6_mc.Name_mc.text_tf,"$MAGNITUDE");
         GlobalFunc.SetText(this.DataListLarge_mc.Data7_mc.Name_mc.text_tf,"$PLANETS");
         GlobalFunc.SetText(this.DataListLarge_mc.Data8_mc.Name_mc.text_tf,"$MOONS");
         GlobalFunc.SetText(this.DataListLarge_mc.Data9_mc.Name_mc.text_tf,"$OUTPOSTS");
         this.ContentArray.splice(0,this.ContentArray.length);
         this.ContentArray.push(this.SystemHeader_mc);
         this.ContentArray.push(this.SystemNameHeader_mc);
         this.ContentArray.push(this.SystemViewHolder_mc);
         this.ContentArray.push(this.DataListLarge_mc);
         this.ContentArray.push(this.SurveyMeter_mc);
         this.SurveyMeter_mc.SetLabel("$SURVEY");
         this.SurveyMeter_mc.SetValueSuffix("%");
         this.SurveyMeter_mc.Max_tf.visible = false;
         this.SurveyMeter_mc.Weight_mc.visible = false;
         this.SurveyMeter_mc.SetTargetPercent(0);
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
            _loc4_ = this.PanelWidthTarget / 2;
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
      
      public function ShowSystemInfo(param1:Boolean = true) : *
      {
         var _loc2_:Number = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this.ContentArray.length)
         {
            this.ContentArray[_loc3_].gotoAndPlay("Open");
            if(this.ContentArray[_loc3_].visible)
            {
               _loc2_ += this.ContentArray[_loc3_].height;
            }
            _loc3_++;
         }
         this.PanelWidthTarget = this.FullWidth;
         BSEaze(this.Background_mc).ExpandClip(PANEL_RESIZE_TIME,this.Background_mc.width,this.Background_mc.height,this.PanelWidthTarget,_loc2_);
         this.IsOpen = true;
      }
      
      public function HideSystemInfo() : *
      {
         var _loc1_:* = undefined;
         if(this.IsOpen)
         {
            this.SurveyMeter_mc.SetPercent(0);
            this.SurveyMeter_mc.visible = false;
            _loc1_ = 0;
            while(_loc1_ < this.ContentArray.length)
            {
               this.ContentArray[_loc1_].gotoAndPlay("Close");
               _loc1_++;
            }
            this.PanelWidthTarget = 0;
            BSEaze(this.Background_mc).ExpandClip(PANEL_RESIZE_TIME,this.Background_mc.width,this.Background_mc.height,this.PanelWidthTarget,0);
            this.IsOpen = false;
         }
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
         GlobalFunc.SetText(this.DataListLarge_mc.Data1_mc.Info_mc.text_tf,param1.spectralClass);
         GlobalFunc.SetText(this.DataListLarge_mc.Data2_mc.Info_mc.text_tf,param1.catalogueID);
         GlobalFunc.SetText(this.DataListLarge_mc.Data3_mc.Info_mc.text_tf,param1.temperatureKelvin + "K");
         var _loc2_:* = GlobalFunc.FormatNumberToString(param1.solarMass,2) + "SM";
         GlobalFunc.SetText(this.DataListLarge_mc.Data4_mc.Info_mc.text_tf,_loc2_);
         GlobalFunc.SetText(this.DataListLarge_mc.Data5_mc.Info_mc.text_tf,param1.radius);
         var _loc3_:String = GlobalFunc.FormatNumberToString(param1.magnitude,2);
         GlobalFunc.SetText(this.DataListLarge_mc.Data6_mc.Info_mc.text_tf,_loc3_);
         GlobalFunc.SetText(this.DataListLarge_mc.Data7_mc.Info_mc.text_tf,param1.planets);
         GlobalFunc.SetText(this.DataListLarge_mc.Data8_mc.Info_mc.text_tf,param1.moons);
         GlobalFunc.SetText(this.DataListLarge_mc.Data9_mc.Info_mc.text_tf,param1.outposts);
         this.SurveyMeter_mc.gotoAndStop("Off");
         this.SurveyMeter_mc.SetTargetPercent(param1.surveyPercent);
         this.SurveyMeter_mc.visible = param1.entered;
         this.SystemViewHolder_mc.visible = param1.entered;
         this.DataListLarge_mc.visible = param1.entered;
         GlobalFunc.SetText(this.SystemHeader_mc.Header_mc.text_tf,BSGalaxyTypes.GetBodyTypeLabel(param1.focusedBodyType));
         this.SystemNameHeader_mc.SetSystemInfo(param1);
         this.ShowSystemInfo(param1.entered);
      }
      
      public function Hide() : *
      {
         this.HideSystemInfo();
      }
   }
}
