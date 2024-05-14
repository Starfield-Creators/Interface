package Components.PlanetInfoCard
{
   import Components.LabeledMeterColorConfig;
   
   public class ShipHudBodyDataInfo extends BodyDataInfo
   {
      
      public static const METER_TEXT:uint = 10870494;
      
      public static const METER_BACKGROUND:uint = 8698811;
      
      public static const METER_FILL:uint = 10870494;
       
      
      public function ShipHudBodyDataInfo()
      {
         super();
         SurveyMeter_mc.SetColorConfig(new LabeledMeterColorConfig(METER_FILL,METER_FILL,METER_FILL,METER_FILL,METER_FILL,METER_TEXT,METER_TEXT,METER_TEXT,METER_TEXT,METER_TEXT,METER_TEXT,METER_BACKGROUND));
      }
   }
}
