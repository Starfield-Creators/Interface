package
{
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ContentLoaders.SymbolLoaderClip;
   import Shared.GlobalFunc;
   import Shared.PowerTypes;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ArtifactPowersWidget extends BSDisplayObject
   {
       
      
      public var UnlockText_mc:MovieClip;
      
      public var UnlockTextBG_mc:MovieClip;
      
      public var ArtifactPower_mc:SymbolLoaderClip;
      
      public function ArtifactPowersWidget()
      {
         super();
         this.ArtifactPower_mc.onLoadAttemptComplete = this.onPowerLoadAttemptComplete;
      }
      
      private function onPowerLoadAttemptComplete() : void
      {
         if(this.ArtifactPower_mc.symbolInstance != null)
         {
            this.ArtifactPower_mc.symbolInstance.gotoAndPlay("Open");
         }
         gotoAndPlay("Open");
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("HUDArtifactPowerUnlockData",this.OnArtifactPowerUnlocked);
      }
      
      private function OnArtifactPowerUnlocked(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = null;
         if(Boolean(param1.data.sKey) && PowerTypes.IsArtifactPower(param1.data.sKey))
         {
            GlobalFunc.SetText(this.UnlockText_mc.text_tf,param1.data.sDisplayName,false,false,0,true,10);
            this.UnlockTextBG_mc.BGShape_mc.width = this.UnlockText_mc.width;
            this.UnlockTextBG_mc.BGShape_mc.x = -this.UnlockTextBG_mc.BGShape_mc.width / 2;
            addEventListener("OpenAnimComplete",this.UnlockOpenAnimationDone);
            _loc2_ = param1.data.sKey + "Anim";
            this.ArtifactPower_mc.LoadSymbol(_loc2_);
         }
      }
      
      private function UnlockOpenAnimationDone(param1:Event) : void
      {
         removeEventListener("OpenAnimComplete",this.UnlockOpenAnimationDone);
         addEventListener("CloseAnimComplete",this.UnlockCloseAnimationDone);
         if(this.ArtifactPower_mc.symbolInstance != null)
         {
            this.ArtifactPower_mc.symbolInstance.gotoAndPlay("Close");
         }
         gotoAndPlay("Close");
      }
      
      private function UnlockCloseAnimationDone(param1:Event) : void
      {
         removeEventListener("CloseAnimComplete",this.UnlockCloseAnimationDone);
      }
   }
}
