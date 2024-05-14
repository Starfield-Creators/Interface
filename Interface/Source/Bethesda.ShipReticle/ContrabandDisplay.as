package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class ContrabandDisplay extends MovieClip
   {
      
      public static const NOT_SCANNING_FRAME:uint = EnumHelper.GetEnum(1);
      
      public static const SCANNING_FRAME:uint = EnumHelper.GetEnum();
      
      public static const NO_CHANCE_FRAME:uint = EnumHelper.GetEnum();
      
      public static const PASSED_FRAME:uint = EnumHelper.GetEnum();
      
      public static const FAILED_FRAME:uint = EnumHelper.GetEnum();
      
      public static const CONTRABAND_WARNING_FLASH_EVENT:String = "ShipReticle_ContrabandWarningFlashEvent";
      
      private static const CONTRABAND_WARNING_FLASH_SOUND:String = "UICockpitHUDNotificationContrabandDetectionWarning";
      
      private static const SHIELDED_HAS_CONTRABAND:String = "$UNSHIELDED CONTRABAND";
      
      private static const SHIELDED_NO_CONTRABAND:String = "$NO CONTRABAND";
      
      private static const WAIT_FOR_SCAN:String = "$WAIT FOR SCAN";
       
      
      public var Internal_mc:MovieClip;
      
      private var ScanPassed_mc:MovieClip;
      
      private var ScanFailed_mc:MovieClip;
      
      private var Scanning_mc:MovieClip;
      
      private var NoChance_mc:MovieClip;
      
      private var EvasionText_tf:TextField;
      
      private var Contraband_mc:MovieClip;
      
      private var Contraband_tf:TextField;
      
      private var ContrabandScanWarningActive:Boolean = false;
      
      private var ContrabandScanWarningScanInProgress:Boolean = false;
      
      private var LastFrame:uint;
      
      public function ContrabandDisplay()
      {
         this.LastFrame = NOT_SCANNING_FRAME;
         super();
         visible = false;
         this.ScanPassed_mc = this.Internal_mc.ScanPassed_mc;
         this.ScanFailed_mc = this.Internal_mc.ScanFailed_mc;
         this.Scanning_mc = this.Internal_mc.Scanning_mc;
         this.NoChance_mc = this.Internal_mc.NoChance_mc;
         this.EvasionText_tf = this.Internal_mc.EvasionText_tf;
         this.Contraband_tf = this.Internal_mc.Contraband_mc.Text_tf;
         addEventListener(CONTRABAND_WARNING_FLASH_EVENT,this.onContrbandWarningFlash);
      }
      
      public function UpdateDisplay(param1:Object) : *
      {
         var _loc2_:* = this.ContrabandScanWarningActive != param1.bContrabandScanWarningActive;
         var _loc3_:* = this.ContrabandScanWarningScanInProgress != param1.bContrabandScanWarningScanInProgress;
         if(Boolean(param1.bContrabandScanWarningScanInProgress) && _loc2_)
         {
            GlobalFunc.PlayMenuSound("UICockpitHUDNotificationContrabandDetectionScanInProgress");
         }
         else if(Boolean(param1.bContrabandScanWarningActive) && !this.ContrabandScanWarningActive)
         {
            GlobalFunc.PlayMenuSound("UICockpitHUDNotificationContrabandDetectionScanEntering");
         }
         if(_loc2_ || _loc3_)
         {
            this.ContrabandScanWarningActive = param1.bContrabandScanWarningActive;
            this.ContrabandScanWarningScanInProgress = param1.bContrabandScanWarningScanInProgress;
            if(this.ContrabandScanWarningActive)
            {
               gotoAndPlay("AnimIn");
               visible = true;
               GlobalFunc.SetText(this.Contraband_tf,!!param1.bHasContraband ? "$UNSHIELDED CONTRABAND" : "$NO CONTRABAND");
               GlobalFunc.SetText(this.ScanPassed_mc.Text_tf,!!param1.bHasContraband ? "$SCAN EVADED" : "$SCAN PASSED");
               if(Boolean(param1.bHasContraband) && param1.iContrabandScanWarningChanceToEvadeDetection == 0)
               {
                  if(!this.ContrabandScanWarningScanInProgress)
                  {
                     GlobalFunc.SetText(this.EvasionText_tf,"$CHANCE TO EVADE SCAN: {0}%",false,false,0,false,0,new Array(param1.iContrabandScanWarningChanceToEvadeDetection.toString()));
                     this.UpdateContrabandFrame(NOT_SCANNING_FRAME);
                  }
                  else
                  {
                     this.UpdateContrabandFrame(NO_CHANCE_FRAME);
                  }
               }
               else
               {
                  if(param1.bHasContraband)
                  {
                     GlobalFunc.SetText(this.EvasionText_tf,"$CHANCE TO EVADE SCAN: {0}%",false,false,0,false,0,new Array(param1.iContrabandScanWarningChanceToEvadeDetection.toString()));
                  }
                  else
                  {
                     GlobalFunc.SetText(this.EvasionText_tf,"$WAIT FOR SCAN");
                  }
                  this.UpdateContrabandFrame(this.ContrabandScanWarningScanInProgress ? SCANNING_FRAME : NOT_SCANNING_FRAME);
               }
            }
            else if(param1.bContrabandScanWarningSkipCompletionAnim)
            {
               visible = false;
            }
            else
            {
               gotoAndPlay("AnimOut");
               visible = true;
               GlobalFunc.PlayMenuSound(!!param1.bContrabandScanWarningWasDetectionEvaded ? "UICockpitHUDNotificationContrabandDetectionScanCompletePass" : "UICockpitHUDNotificationContrabandDetectionScanCompleteFail");
               this.UpdateContrabandFrame(!!param1.bContrabandScanWarningWasDetectionEvaded ? PASSED_FRAME : FAILED_FRAME);
               GlobalFunc.SetText(this.EvasionText_tf,"");
            }
         }
      }
      
      private function UpdateContrabandFrame(param1:uint) : *
      {
         if(this.LastFrame != param1)
         {
            this.Internal_mc.gotoAndStop(param1);
            this.LastFrame = param1;
         }
      }
      
      private function onContrbandWarningFlash(param1:Event) : *
      {
         GlobalFunc.PlayMenuSound(CONTRABAND_WARNING_FLASH_SOUND);
      }
   }
}
