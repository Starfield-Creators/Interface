package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class JetpackMeter extends MovieClip
   {
      
      internal static const METER_FULL:uint = 1;
      
      internal static const METER_EMPTY:uint = 60;
      
      internal static const FADED_IN_FRAME:uint = 10;
       
      
      public var JetpackMeter_mc:MovieClip;
      
      public function JetpackMeter()
      {
         super();
         gotoAndStop("FadedOut");
         BSUIDataManager.Subscribe("HudJetpackData",this.onDataChange);
      }
      
      private function onDataChange(param1:FromClientDataEvent) : *
      {
         if((param1.data.fJetpackCharge >= 1 || param1.data.fJetpackCharge < 0) && (this.currentLabel == "FadeIn" || this.currentLabel == "FadedIn"))
         {
            gotoAndPlay("FadeOut");
         }
         else if(param1.data.fJetpackCharge < 1 && param1.data.fJetpackCharge > 0 && (this.currentLabel == "FadedOut" || this.currentLabel == "FadeOut"))
         {
            gotoAndPlay("FadeIn");
         }
         if(param1.data.fJetpackCharge > 0)
         {
            this.JetpackMeter_mc.gotoAndStop(Math.ceil(GlobalFunc.Lerp(METER_EMPTY,METER_FULL,GlobalFunc.Clamp(param1.data.fJetpackCharge,0,1))));
         }
      }
   }
}
