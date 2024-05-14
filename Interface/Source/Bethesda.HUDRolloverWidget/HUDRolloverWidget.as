package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.RolloverReticle;
   import flash.display.MovieClip;
   
   public class HUDRolloverWidget extends BSDisplayObject
   {
       
      
      public var RolloverActivationHolder_mc:MovieClip;
      
      public var Reticle_mc:MovieClip;
      
      public var RolloverActivation_mc:HUDRolloverActivationWidget;
      
      private var Shown:Boolean = false;
      
      private var ShouldShowReticle:Boolean = true;
      
      private var ReticleObject:RolloverReticle;
      
      public function HUDRolloverWidget()
      {
         super();
         this.Reticle_mc.visible = false;
         this.RolloverActivation_mc = this.RolloverActivationHolder_mc.RolloverActivation_mc;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         this.ReticleObject = new RolloverReticle(this);
         this.ReticleObject.SetAnchor(this.RolloverActivation_mc.ContainerLineAnchor_mc.x,this.RolloverActivation_mc.ContainerLineAnchor_mc.y);
         this.ReticleObject.SetReticleRadius(this.Reticle_mc.width / 2);
         BSUIDataManager.Subscribe("HUDRolloverActivationData",this.OnActivationDataChanged);
         BSUIDataManager.Subscribe("HUDRolloverData",this.OnRolloverDataChanged);
         BSUIDataManager.Subscribe("HUDRolloverItemData",this.OnRolloverItemsChanged);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            _loc3_ = this.RolloverActivation_mc.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      public function SetVisibility(param1:Boolean) : void
      {
         this.visible = param1;
         if(!param1)
         {
            if(!this.Shown && this.RolloverActivationHolder_mc.currentFrameLabel != "off")
            {
               this.RolloverActivationHolder_mc.gotoAndStop("off");
            }
         }
      }
      
      public function get show() : Boolean
      {
         return this.Shown;
      }
      
      public function set show(param1:Boolean) : void
      {
         if(param1 != this.Shown)
         {
            if(param1)
            {
               this.RolloverActivationHolder_mc.gotoAndPlay("rollOn");
            }
            else
            {
               this.RolloverActivationHolder_mc.gotoAndPlay("rollOff");
            }
            if(this.ShouldShowReticle && param1)
            {
               this.Reticle_mc.visible = true;
               this.ReticleObject.SetReticleLocation(this.Reticle_mc.x,this.Reticle_mc.y);
               this.ReticleObject.BeginUpdatingLineAnim();
            }
            else
            {
               this.Reticle_mc.visible = false;
               this.ReticleObject.Clear();
            }
            this.Shown = param1;
         }
      }
      
      private function OnActivationDataChanged(param1:FromClientDataEvent) : void
      {
         this.ShouldShowReticle = param1.data.uMode != HUDRolloverActivationWidget.SCANNER_INVENTORY && param1.data.uMode != HUDRolloverActivationWidget.SCANNER_SINGLE_ITEM_WITH_CARD;
         this.RolloverActivation_mc.ApplyActivationData(param1.data);
         this.ReticleObject.SetAnchor(this.RolloverActivation_mc.ContainerLineAnchor_mc.x,this.RolloverActivation_mc.ContainerLineAnchor_mc.y);
         this.show = param1.data.bShowRolloverActivation;
      }
      
      private function OnRolloverDataChanged(param1:FromClientDataEvent) : void
      {
         this.Reticle_mc.x = param1.data.fScreenX - x;
         this.Reticle_mc.y = param1.data.fScreenY - y;
         if(this.show && this.ShouldShowReticle)
         {
            this.ReticleObject.SetReticleLocation(this.Reticle_mc.x,this.Reticle_mc.y);
         }
      }
      
      private function OnRolloverItemsChanged(param1:FromClientDataEvent) : void
      {
         this.RolloverActivation_mc.ApplyContainerData(param1.data);
      }
   }
}
