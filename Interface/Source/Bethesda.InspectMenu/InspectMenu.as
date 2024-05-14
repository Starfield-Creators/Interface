package
{
   import Components.PlanetInfoCard.PlanetInfoCard;
   import Components.PlanetInfoCard.PlanetInfoResourceIcon;
   import Shared.AS3.BSDisplayObject;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class InspectMenu extends BSDisplayObject
   {
      
      private static const RESOURCE_NAMEPLATE_PADDING:uint = 20;
      
      private static const RESOURCE_NAMEPLATE_OFFSET:uint = 25;
      
      private static const RESOURCE_ICON_SIZE:uint = 25;
      
      private static const TAGGED_ICON_PADDING:uint = 8;
       
      
      public var BodyPOIs:InspectMenuMarkers;
      
      public var PlanetData_mc:PlanetInfoCard;
      
      public var ScanWarning_mc:MovieClip;
      
      public var ResourceNameplate_mc:MovieClip;
      
      public var ExtremeWarning_mc:ExtremeWarningBox;
      
      private var InspectedBodyID:uint = 0;
      
      private var bResourceNameShown:Boolean = false;
      
      public function InspectMenu()
      {
         super();
      }
      
      public function OpenView() : *
      {
         this.BodyPOIs.Reset();
         this.BodyPOIs.visible = true;
         this.visible = true;
         this.ResourceNameplate_mc.gotoAndStop("off");
      }
      
      public function CloseView() : *
      {
         this.visible = false;
         this.BodyPOIs.visible = false;
      }
      
      public function OpenDataWindow() : *
      {
         this.PlanetData_mc.Open();
      }
      
      public function CloseDataWindow() : *
      {
         this.PlanetData_mc.Close();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         _loc3_ = this.PlanetData_mc.ProcessUserEvent(param1,param2);
         if(!_loc3_)
         {
            _loc3_ = this.BodyPOIs.ProcessUserEvent(param1,param2);
         }
         return _loc3_;
      }
      
      override public function onAddedToStage() : void
      {
         super.onAddedToStage();
         BSUIDataManager.Subscribe("StarMapMenuPlanetInspectData",function(param1:FromClientDataEvent):*
         {
            UpdateBodyInspectView(param1.data);
         });
         BSUIDataManager.Subscribe("StarmapInspectBodyInfoProvider",function(param1:FromClientDataEvent):*
         {
            PlanetData_mc.SetBodyInfo(param1.data);
            ExtremeWarning_mc.Update(param1.data);
         });
         this.ResourceNameplate_mc.ResourceContainer_mc.ResourceIcon_mc.width = RESOURCE_ICON_SIZE;
         this.ResourceNameplate_mc.ResourceContainer_mc.ResourceIcon_mc.height = RESOURCE_ICON_SIZE;
         this.ResourceNameplate_mc.ResourceContainer_mc.ResourceIcon_mc.gotoAndStop("Known");
         this.PlanetData_mc.SetUseTraitIcons(true);
      }
      
      public function UpdateBodyInspectView(param1:Object) : *
      {
         this.UpdateWidgets(param1);
         this.UpdateResourceNameplate(param1);
      }
      
      public function SetInspectedBodyID(param1:uint) : *
      {
         this.InspectedBodyID = param1;
      }
      
      private function UpdateWidgets(param1:Object) : *
      {
         this.PlanetData_mc.UpdateScanButton(param1.bShowSurveyor,param1.bNewScanAvailable);
      }
      
      private function UpdateResourceNameplate(param1:Object) : *
      {
         var _loc2_:Number = NaN;
         if(Boolean(param1.bShowResourceName) && param1.sHoveredResourceName != this.ResourceNameplate_mc.NameplateText_mc.text_tf.text)
         {
            GlobalFunc.SetText(this.ResourceNameplate_mc.NameplateText_mc.text_tf,param1.HoveredResourceA[0].sName);
         }
         if(this.bResourceNameShown != param1.bShowResourceName)
         {
            this.bResourceNameShown = param1.bShowResourceName;
            if(this.bResourceNameShown)
            {
               this.ResourceNameplate_mc.x = mouseX + RESOURCE_NAMEPLATE_OFFSET;
               this.ResourceNameplate_mc.y = mouseY;
               this.ResourceNameplate_mc.gotoAndPlay("resource_hover");
               this.ResourceNameplate_mc.Tagged_mc.visible = param1.HoveredResourceA[0].bTagged;
               _loc2_ = this.ResourceNameplate_mc.ResourceContainer_mc.ResourceIcon_mc.width + this.ResourceNameplate_mc.NameplateText_mc.text_tf.textWidth + RESOURCE_NAMEPLATE_PADDING;
               if(this.ResourceNameplate_mc.Tagged_mc.visible)
               {
                  _loc2_ += this.ResourceNameplate_mc.Tagged_mc.width;
               }
               this.ResourceNameplate_mc.Mask_mc.MaskBase_mc.width = _loc2_;
               this.ResourceNameplate_mc.NameplateText_mc.text_tf.width = _loc2_;
               this.ResourceNameplate_mc.selectedTextBackground_mc.width = _loc2_;
               this.ResourceNameplate_mc.selectedTextBackground_mc.visible = true;
               this.ResourceNameplate_mc.Tagged_mc.x = this.ResourceNameplate_mc.NameplateText_mc.x + this.ResourceNameplate_mc.NameplateText_mc.text_tf.textWidth + TAGGED_ICON_PADDING;
               param1.HoveredResourceA[0].bTagged = false;
               (this.ResourceNameplate_mc.ResourceContainer_mc.ResourceIcon_mc as PlanetInfoResourceIcon).SetResource(param1.HoveredResourceA[0]);
            }
            else
            {
               this.ResourceNameplate_mc.gotoAndPlay("resource_close");
               this.ResourceNameplate_mc.selectedTextBackground_mc.visible = false;
            }
         }
      }
   }
}
