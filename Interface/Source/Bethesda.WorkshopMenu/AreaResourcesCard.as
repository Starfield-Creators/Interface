package
{
   import Components.ModularPanelObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   
   public class AreaResourcesCard extends ModularPanelObject
   {
       
      
      public var TitleSection_mc:MovieClip;
      
      public var ResourcesSection_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      public var BottomDivider_mc:MovieClip;
      
      private var _dataReady:Boolean = false;
      
      private var _openStarted:Boolean = false;
      
      private const RES_COLUMNS:Number = 1;
      
      private const RES_ROWS:Number = 12;
      
      private const RES_COLUMNS_SPACING:Number = 0;
      
      private const RES_ROWS_SPACING:Number = 3;
      
      private const RES_HORIZONTAL_PADDING:Number = 0;
      
      private const RES_VERTICAL_PADDING:Number = 8;
      
      public function AreaResourcesCard()
      {
         super();
         this.ResourcesSection_mc.ResourcesList_mc.Configure(AreaResourceList_Entry,this.RES_COLUMNS,this.RES_ROWS,this.RES_COLUMNS_SPACING,this.RES_ROWS_SPACING,this.RES_HORIZONTAL_PADDING,this.RES_VERTICAL_PADDING);
      }
      
      public function set show(param1:Boolean) : void
      {
         this.visible = param1;
         this.Open();
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("WorkshopAreaResourcesData",this.OnResourcesDataUpdate);
         AddToInfoPanelArray(this.TitleSection_mc);
         AddToInfoPanelArray(this.ResourcesSection_mc);
         addEventListener("NextAnimation",this.PlayNextAnimation);
      }
      
      override public function PlayNextAnimation() : *
      {
         super.PlayNextAnimation();
         if(NextInQueue == InfoPanelArray.length)
         {
            this.BottomDivider_mc.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
         }
      }
      
      private function Open() : void
      {
         if(!this._openStarted && this._dataReady && this.visible)
         {
            this._openStarted = true;
            this.gotoAndPlay(WorkshopUtils.OPEN_FRAME);
            OpenBackgroundAnimation(this.Background_mc);
         }
      }
      
      private function OnResourcesDataUpdate(param1:FromClientDataEvent) : void
      {
         this._dataReady = param1.data.bSearchedResources;
         this.ResourcesSection_mc.NoResources_mc.visible = param1.data.aAreaResources.length == 0;
         this.ResourcesSection_mc.ResourcesList_mc.entryData = param1.data.aAreaResources;
         this.Background_mc.height = this.TitleSection_mc.height + this.ResourcesSection_mc.height;
         this.BottomDivider_mc.y = this.Background_mc.height - 1;
         this.Open();
      }
   }
}
