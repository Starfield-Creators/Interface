package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   public class FooterContainer extends MovieClip
   {
       
      
      public var DividerHolder_mc:MovieClip;
      
      public var Info_mc:MovieClip;
      
      public var Stats_mc:MovieClip;
      
      private var _openStarted:Boolean = false;
      
      private var _dataReady:Boolean = false;
      
      private var _largeTextMode:Boolean = false;
      
      private const PRECISION:uint = 2;
      
      private const POWER_INSUFFICIENT_COLOR:uint = 16711680;
      
      private const POWER_SUFFICIENT_COLOR:uint = 13153632;
      
      public function FooterContainer()
      {
         super();
         if(!this._largeTextMode)
         {
            TextFieldEx.setTextAutoSize(this.Info_mc.NameLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Info_mc.SubtextLabel_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.CargoStatus_mc.IconLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.CrewStatus_mc.IconLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.NeededPowerStatus_mc.IconLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.TotalPowerStatus_mc.IconLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.ProductionStatus_mc.IconLabel_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.CargoStatus_mc.IconCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.CrewStatus_mc.IconCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.NeededPowerStatus_mc.IconCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.TotalPowerStatus_mc.IconCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Stats_mc.ProductionStatus_mc.IconCount_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         WorkshopUtils.SetSingleLineText(this.Info_mc.BuildLimitLabel_mc.Text_tf,"$BUILD LIMIT",this._largeTextMode);
         WorkshopUtils.SetSingleLineText(this.Stats_mc.CargoStatus_mc.IconLabel_tf,"$CARGO",this._largeTextMode);
         WorkshopUtils.SetSingleLineText(this.Stats_mc.CrewStatus_mc.IconLabel_tf,"$CREW",this._largeTextMode);
         WorkshopUtils.SetSingleLineText(this.Stats_mc.NeededPowerStatus_mc.IconLabel_tf,"$NEEDED PWR",this._largeTextMode);
         WorkshopUtils.SetSingleLineText(this.Stats_mc.TotalPowerStatus_mc.IconLabel_tf,"$TOTAL PWR",this._largeTextMode);
         WorkshopUtils.SetSingleLineText(this.Stats_mc.ProductionStatus_mc.IconLabel_tf,"$PRODUCTION",this._largeTextMode);
         this.Stats_mc.CargoStatus_mc.Icon_mc.gotoAndStop("cargo");
         this.Stats_mc.CrewStatus_mc.Icon_mc.gotoAndStop("crew");
         this.Stats_mc.NeededPowerStatus_mc.Icon_mc.gotoAndStop("power");
         this.Stats_mc.TotalPowerStatus_mc.Icon_mc.gotoAndStop("totalpower");
         this.Stats_mc.ProductionStatus_mc.Icon_mc.gotoAndStop("production");
         BSUIDataManager.Subscribe("WorkshopStatusData",this.OnStatusDataUpdate);
      }
      
      public function set show(param1:Boolean) : void
      {
         this.visible = param1;
         this.Open();
      }
      
      private function Open() : void
      {
         if(!this._openStarted && this._dataReady && this.visible)
         {
            this._openStarted = true;
            this.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
            this.Info_mc.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
            this.Stats_mc.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
         }
      }
      
      public function Close(param1:Boolean) : void
      {
         if(param1)
         {
            this.gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
            this.Info_mc.gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
            this.Stats_mc.gotoAndPlay(WorkshopUtils.CLOSE_FRAME);
         }
         else
         {
            this.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
            this.Info_mc.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
            this.Stats_mc.gotoAndStop(WorkshopUtils.HIDDEN_FRAME);
         }
      }
      
      public function UpdateFooterInfo(param1:Object) : void
      {
         this._dataReady = param1.sOutpostName != "";
         GlobalFunc.SetText(this.Info_mc.NameLabel_mc.Text_tf,param1.sOutpostName);
         GlobalFunc.SetText(this.Info_mc.SubtextLabel_mc.Text_tf,param1.sOutpostLocation);
         this.Open();
      }
      
      private function OnStatusDataUpdate(param1:FromClientDataEvent) : void
      {
         this.Info_mc.BuildLimitMeter_mc.gotoAndStop(Math.round(this.Info_mc.BuildLimitMeter_mc.framesLoaded * param1.data.fBuildLimit));
         GlobalFunc.SetText(this.Stats_mc.CargoStatus_mc.IconCount_tf,param1.data.uCargo);
         GlobalFunc.SetText(this.Stats_mc.CrewStatus_mc.IconCount_tf,param1.data.uCrew);
         this.Stats_mc.NeededPowerStatus_mc.IconCount_tf.textColor = param1.data.uPowerRequired > param1.data.uPowerGenerated ? this.POWER_INSUFFICIENT_COLOR : this.POWER_SUFFICIENT_COLOR;
         GlobalFunc.SetText(this.Stats_mc.NeededPowerStatus_mc.IconCount_tf,param1.data.uPowerRequired);
         GlobalFunc.SetText(this.Stats_mc.TotalPowerStatus_mc.IconCount_tf,param1.data.uPowerGenerated);
         GlobalFunc.SetText(this.Stats_mc.ProductionStatus_mc.IconCount_tf,GlobalFunc.FormatNumberToString(param1.data.fProduction,this.PRECISION) + "/$$MinuteAbbreviation");
      }
   }
}
