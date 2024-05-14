package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ClockWidget extends MovieClip
   {
       
      
      public var LocalTime_tf:TextField;
      
      public var GSTime_tf:TextField;
      
      private var InSpaceship:Boolean = false;
      
      private var LocalPlanetTime:Number = 0;
      
      private var LocalPlanetHoursPerDay:Number = 0;
      
      private var GalacticStandardTime:Number = 0;
      
      public function ClockWidget()
      {
         super();
         BSUIDataManager.Subscribe("LocalEnvironmentData",this.onDataUpdate);
         BSUIDataManager.Subscribe("LocalEnvData_Frequent",this.onFrequentDataUpdate);
      }
      
      private function onDataUpdate(param1:FromClientDataEvent) : void
      {
         this.InSpaceship = param1.data.bInSpaceship;
         this.UpdateTime();
      }
      
      private function onFrequentDataUpdate(param1:FromClientDataEvent) : void
      {
         this.LocalPlanetTime = param1.data.fLocalPlanetTime;
         this.LocalPlanetHoursPerDay = param1.data.fLocalPlanetHoursPerDay;
         this.GalacticStandardTime = param1.data.fGalacticStandardTime;
         this.UpdateTime();
      }
      
      private function UpdateTime() : *
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(this.InSpaceship || this.LocalPlanetHoursPerDay <= 0)
         {
            GlobalFunc.SetText(this.LocalTime_tf,"");
         }
         else
         {
            _loc3_ = this.LocalPlanetTime * 24;
            _loc4_ = Math.floor(_loc3_);
            _loc5_ = Math.floor((_loc3_ - _loc4_) * 60);
            GlobalFunc.SetText(this.LocalTime_tf,GlobalFunc.PadNumber(_loc4_,2) + ":" + GlobalFunc.PadNumber(_loc5_,2) + " $$LocalTime $$LocalTime_Suffix",false,false,0,false,0,[GlobalFunc.RoundDecimal(this.LocalPlanetHoursPerDay,0)]);
         }
         var _loc1_:uint = Math.floor(this.GalacticStandardTime);
         var _loc2_:uint = Math.floor((this.GalacticStandardTime - _loc1_) * 60);
         GlobalFunc.SetText(this.GSTime_tf,GlobalFunc.PadNumber(_loc1_,2) + ":" + GlobalFunc.PadNumber(_loc2_,2) + " $$UT");
      }
   }
}
