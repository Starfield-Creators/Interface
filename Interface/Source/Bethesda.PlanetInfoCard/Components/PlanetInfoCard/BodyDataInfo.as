package Components.PlanetInfoCard
{
   import Components.LabeledMeterMC;
   import Shared.AS3.BSDisplayObject;
   import Shared.BSGalaxyTypes;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BodyDataInfo extends BSDisplayObject
   {
      
      private static const NONE_STR:String = "None";
       
      
      public var Title_mc:MovieClip;
      
      public var Subtitle_mc:MovieClip;
      
      public var PlanetTraits_mc:MovieClip;
      
      public var Type_mc:MovieClip;
      
      public var Gravity_mc:MovieClip;
      
      public var Temperature_mc:MovieClip;
      
      public var Atmosphere_mc:MovieClip;
      
      public var Magnetosphere_mc:MovieClip;
      
      public var Fauna_mc:MovieClip;
      
      public var Flora_mc:MovieClip;
      
      public var Water_mc:MovieClip;
      
      public var SurveyMeter_mc:LabeledMeterMC;
      
      public var SurveyedBanner_mc:MovieClip;
      
      public var BGLarge_mc:MovieClip;
      
      public var ResourcesAmount_mc:MovieClip;
      
      public var Resource1_mc:PlanetInfoResourceIcon;
      
      public var Resource2_mc:PlanetInfoResourceIcon;
      
      public var Resource3_mc:PlanetInfoResourceIcon;
      
      public var Resource4_mc:PlanetInfoResourceIcon;
      
      public var Resource5_mc:PlanetInfoResourceIcon;
      
      public var Resource6_mc:PlanetInfoResourceIcon;
      
      public var Resource7_mc:PlanetInfoResourceIcon;
      
      public var Resource8_mc:PlanetInfoResourceIcon;
      
      public var Resources:Array;
      
      private var IsOpen:Boolean = false;
      
      public function BodyDataInfo()
      {
         this.Resources = new Array();
         super();
         var _loc1_:int = 1;
         var _loc2_:PlanetInfoResourceIcon = this["Resource" + _loc1_ + "_mc"];
         while(_loc2_ != null)
         {
            this.Resources.push(_loc2_);
            _loc1_++;
            _loc2_ = this["Resource" + _loc1_ + "_mc"];
         }
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.InitStaticText();
         this.Title_mc.mouseChildren = false;
         this.Subtitle_mc.mouseChildren = false;
         this.Title_mc.mouseEnabled = false;
         this.Subtitle_mc.mouseEnabled = false;
      }
      
      public function Open() : *
      {
         gotoAndPlay("Open");
         this.IsOpen = true;
      }
      
      public function Close() : *
      {
         gotoAndPlay("Close");
         this.IsOpen = false;
      }
      
      private function InitStaticText() : *
      {
         Extensions.enabled = true;
         GlobalFunc.SetText(this.Type_mc.Name_mc.Text_tf,"$TYPE");
         GlobalFunc.SetText(this.Gravity_mc.Name_mc.Text_tf,"$GRAVITY");
         GlobalFunc.SetText(this.Temperature_mc.Name_mc.Text_tf,"$TEMPERATURE");
         GlobalFunc.SetText(this.Atmosphere_mc.Name_mc.Text_tf,"$ATMOSPHERE");
         GlobalFunc.SetText(this.Magnetosphere_mc.Name_mc.Text_tf,"$MAGNETOSPHERE");
         GlobalFunc.SetText(this.Fauna_mc.Name_mc.Text_tf,"$FAUNA");
         GlobalFunc.SetText(this.Flora_mc.Name_mc.Text_tf,"$FLORA");
         GlobalFunc.SetText(this.Water_mc.Name_mc.Text_tf,"$WATER");
         TextFieldEx.setTextAutoSize(this.Type_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Gravity_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Temperature_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Atmosphere_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Magnetosphere_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Fauna_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Flora_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Water_mc.Info_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.SurveyMeter_mc.SetLabel("$SURVEY");
         this.SurveyMeter_mc.SetValueSuffix("%");
         this.SurveyMeter_mc.SetMode(LabeledMeterMC.MODE_PERCENTAGE);
      }
      
      public function SetBodyInfo(param1:Object) : *
      {
         visible = param1.uBodyID != 0 && param1.iType != BSGalaxyTypes.BT_SATELLITE;
         if(visible)
         {
            if(!this.IsOpen)
            {
               this.Open();
            }
            GlobalFunc.SetText(this.Title_mc.Text_tf,param1.sBodyName);
            this.SetSystemSubtitle(param1);
            this.SetTraits(param1);
            GlobalFunc.SetText(this.Type_mc.Info_mc.Text_tf,param1.sTerrain);
            GlobalFunc.SetText(this.Gravity_mc.Info_mc.Text_tf,this.GetGravityText(param1));
            GlobalFunc.SetText(this.Temperature_mc.Info_mc.Text_tf,this.GetTemperatureText(param1));
            GlobalFunc.SetText(this.Atmosphere_mc.Info_mc.Text_tf,this.GetAtmosphereText(param1));
            GlobalFunc.SetText(this.Magnetosphere_mc.Info_mc.Text_tf,this.GetMagnetosphereText(param1));
            GlobalFunc.SetText(this.Fauna_mc.Info_mc.Text_tf,this.GetFaunaText(param1));
            GlobalFunc.SetText(this.Flora_mc.Info_mc.Text_tf,this.GetFloraText(param1));
            GlobalFunc.SetText(this.Water_mc.Info_mc.Text_tf,this.GetWaterText(param1));
            this.UpdateResourceInfo(param1.ResourcesA,param1.iScanLevel);
            this.SurveyMeter_mc.SetTargetPercent(param1.fSurveyPercent);
            this.SurveyedBanner_mc.visible = param1.fSurveyPercent >= 1;
         }
      }
      
      private function SetSystemSubtitle(param1:Object) : *
      {
         if(param1.iType == BSGalaxyTypes.BT_MOON)
         {
            GlobalFunc.SetText(this.Subtitle_mc.Text_tf,"$BODY INFO SUBTITLE MOON",false,false,0,false,0,new Array(param1.sParentBodyName));
         }
         else
         {
            GlobalFunc.SetText(this.Subtitle_mc.Text_tf,"$SYSTEM SUBTITLE",false,false,0,false,0,new Array(param1.sSystemName));
         }
      }
      
      protected function SetTraits(param1:Object) : *
      {
         var _loc2_:* = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         if(param1.uTraitsTotal == 0)
         {
            GlobalFunc.SetText(this.PlanetTraits_mc.Text_tf,"");
         }
         else
         {
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < param1.TraitsA.length)
            {
               _loc4_ = String(param1.TraitsA[_loc3_]);
               _loc2_ += _loc4_;
               if(_loc3_ + 1 < param1.TraitsA.length)
               {
                  _loc2_ += ", ";
               }
               _loc3_++;
            }
            GlobalFunc.SetText(this.PlanetTraits_mc.Text_tf,"$TRAITS",false,false,0,false,0,new Array(_loc2_));
            if(Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL)
            {
               _loc2_ = String(this.PlanetTraits_mc.Text_tf.text);
               _loc2_ += " (" + param1.uTraitsCurrent + "/" + param1.uTraitsTotal + ")";
               GlobalFunc.SetText(this.PlanetTraits_mc.Text_tf,_loc2_);
            }
         }
      }
      
      private function GetGravityText(param1:Object) : String
      {
         var _loc2_:* = String(param1.sGravityDescriptor);
         if(param1.bPlayerEnteredSystem)
         {
            _loc2_ = GlobalFunc.RoundDecimalToFixedString(param1.fGravity,2) + " $$UNIT_GRAVITY";
         }
         return _loc2_;
      }
      
      private function GetTemperatureText(param1:Object) : String
      {
         return String(param1.sTempDescriptor);
      }
      
      private function GetAtmosphereText(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:String = "$UNKNOWN";
         if(param1.bPlayerEnteredSystem)
         {
            GlobalFunc.SetText(this.Atmosphere_mc.Info_mc.Text_tf,"$UNIT_ATMOSPHERE");
            _loc3_ = String(this.Atmosphere_mc.Info_mc.Text_tf.text);
            _loc2_ = param1.sAtmospherePressure + " " + param1.sAtmosphereType;
            if((_loc4_ = String(param1.sAtmosphereToxicity)).length > 0 && (Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_ADVANCED && _loc4_))
            {
               _loc2_ += " (" + _loc4_ + ")";
            }
         }
         return _loc2_;
      }
      
      private function GetMagnetosphereText(param1:Object) : String
      {
         var _loc2_:String = "$UNKNOWN";
         if(Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL)
         {
            _loc2_ = String(param1.sMagnetosphere);
         }
         return _loc2_;
      }
      
      private function GetInorganicsText(param1:Object) : String
      {
         var _loc2_:String = "$UNKNOWN";
         if(param1.bPlayerEnteredSystem)
         {
            _loc2_ = String(param1.sInorganicResourceDescriptor);
            if(Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL)
            {
               _loc2_ += " (" + param1.uInorganicResourceCurrent + "/" + param1.uInorganicResourceTotal + ")";
            }
         }
         return _loc2_;
      }
      
      private function GetOrganicsText(param1:Object) : String
      {
         var _loc2_:String = "$UNKNOWN";
         if(param1.bPlayerEnteredSystem)
         {
            _loc2_ = String(param1.sInorganicResourceDescriptor);
            if(Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL)
            {
               _loc2_ += " (" + param1.uOrganicResourceCurrent + "/" + param1.uOrganicResourceTotal + ")";
            }
         }
         return _loc2_;
      }
      
      private function GetFaunaText(param1:Object) : String
      {
         var _loc2_:String = "$UNKNOWN";
         if(param1.bPlayerEnteredSystem)
         {
            _loc2_ = String(param1.sFaunaDescriptor);
            if(Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL)
            {
               _loc2_ += " (" + param1.uFaunaCurrent + "/" + param1.uFaunaTotal + ")";
            }
         }
         else
         {
            _loc2_ = String(param1.sFaunaProbability);
         }
         return _loc2_;
      }
      
      private function GetFloraText(param1:Object) : String
      {
         var _loc2_:String = "$UNKNOWN";
         if(param1.bPlayerEnteredSystem)
         {
            _loc2_ = String(param1.sFloraDescriptor);
            if(Boolean(param1.bPlayerVisited) || param1.iScanLevel >= BSGalaxyTypes.SL_MINIMAL)
            {
               _loc2_ += " (" + param1.uFloraCurrent + "/" + param1.uFloraTotal + ")";
            }
         }
         else
         {
            _loc2_ = String(param1.sFloraProbability);
         }
         return _loc2_;
      }
      
      private function GetWaterText(param1:Object) : String
      {
         var _loc2_:String = "$UNKNOWN";
         if(param1.bPlayerEnteredSystem)
         {
            _loc2_ = String(param1.sWaterDescriptor);
            if(_loc2_ != NONE_STR)
            {
               _loc2_ = String(param1.sWaterQuality);
            }
         }
         return _loc2_;
      }
      
      private function UpdateResourceInfo(param1:Array, param2:int) : *
      {
         var _loc6_:Object = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         var _loc5_:Number = 0;
         while(_loc5_ < this.Resources.length)
         {
            if(_loc5_ < _loc3_)
            {
               if((_loc6_ = param1[_loc5_]) != null)
               {
                  this.Resources[_loc5_].SetResource(_loc6_);
                  this.Resources[_loc5_].visible = true;
                  if(!_loc6_.bDisabled)
                  {
                     _loc4_++;
                  }
               }
            }
            else
            {
               this.Resources[_loc5_].visible = false;
            }
            _loc5_++;
         }
         if(this.ResourcesAmount_mc != null)
         {
            if(_loc3_ > 0)
            {
               GlobalFunc.SetText(this.ResourcesAmount_mc.text_tf,"(" + _loc4_ + "/" + _loc3_ + ")");
            }
            else if(param2 >= BSGalaxyTypes.SL_MINIMAL)
            {
               GlobalFunc.SetText(this.ResourcesAmount_mc.text_tf,"$NONE");
            }
            else
            {
               GlobalFunc.SetText(this.ResourcesAmount_mc.text_tf,"$UNKNOWN");
            }
         }
      }
      
      public function SetBackgroundVisible(param1:Boolean) : *
      {
         this.BGLarge_mc.visible = param1;
      }
   }
}
