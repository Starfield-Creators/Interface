package
{
   import Components.ImageFixture;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ModulePaletteEntry extends BSContainerEntry
   {
       
      
      public var Module_mc:MovieClip;
      
      public var ModuleInfoSmall_mc:MovieClip;
      
      public var ModuleInfoMedium_mc:MovieClip;
      
      private var BaseModuleName:String;
      
      private var BaseModuleIcon:Object;
      
      private var ModuleDisabled:Boolean = false;
      
      public function ModulePaletteEntry()
      {
         super();
         this.ModuleInfoMedium_mc.visible = false;
         this.ModuleInfoSmall_mc.visible = true;
         this.ModuleIcon.centerClip = true;
      }
      
      private function get ModuleText() : TextField
      {
         return this.Module_mc.Text_mc.text_tf;
      }
      
      private function get SmallInfoText1() : TextField
      {
         return this.ModuleInfoSmall_mc.Text1_mc.text_tf;
      }
      
      private function get MediumInfoText() : TextField
      {
         return this.ModuleInfoMedium_mc.Text_mc.text_tf;
      }
      
      private function get ModuleIcon() : ImageFixture
      {
         return this.Module_mc.Icon_mc;
      }
      
      public function get ModuleVariantGroup() : ModulePaletteVariantGroup
      {
         return this.Module_mc.VariantGroup_mc;
      }
      
      public function get IsDisabled() : Boolean
      {
         return this.ModuleDisabled;
      }
      
      override public function get selectedFrameLabel() : String
      {
         return "Active";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         return "Normal";
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.BSASSERT(param1 != null,"BSContainerEntry: SetEntryText requires a valid Entry!");
         this.SetModuleText(param1.text);
         this.BaseModuleName = param1.text;
         if(param1.bDiscounted)
         {
            this.SetSmallInfoText("+" + param1.iStat1);
         }
         else
         {
            this.SetSmallInfoText(param1.iStat1);
         }
         this.SetModuleIcon(param1.iconImage);
         this.BaseModuleIcon = param1.iconImage;
         this.ModuleDisabled = param1.bDisabled;
         this.Module_mc.DisabledFilter_mc.visible = this.ModuleDisabled;
         this.ModuleInfoSmall_mc.DisabledFilter_mc.visible = this.ModuleDisabled;
         this.ModuleVariantGroup.SetVisiblePips(param1.iVariants);
      }
      
      private function SetModuleText(param1:String) : void
      {
         GlobalFunc.SetText(this.ModuleText,param1);
      }
      
      private function SetSmallInfoText(param1:String) : void
      {
         GlobalFunc.SetText(this.SmallInfoText1,param1);
      }
      
      private function SetMediumInfoText(param1:String) : void
      {
         GlobalFunc.SetText(this.MediumInfoText,param1);
      }
      
      private function SetModuleIcon(param1:Object) : *
      {
         this.ModuleIcon.LoadImageFixtureFromUIData(param1,"ShipBuilderIconTextureBuffer");
      }
      
      public function UpdateVariantData(param1:Number, param2:String, param3:Object) : *
      {
         this.ModuleVariantGroup.SetActivePip(param1);
         this.SetModuleText(param2);
         this.SetModuleIcon(param3);
      }
      
      override public function onRollover() : void
      {
         if(this.Module_mc.currentFrameLabel != this.selectedFrameLabel)
         {
            this.Module_mc.gotoAndPlay(this.selectedFrameLabel);
         }
         if(this.ModuleInfoSmall_mc.currentFrameLabel != this.selectedFrameLabel)
         {
            this.ModuleInfoSmall_mc.gotoAndPlay(this.selectedFrameLabel);
         }
         if(this.ModuleInfoMedium_mc.currentFrameLabel != this.selectedFrameLabel)
         {
            this.ModuleInfoMedium_mc.gotoAndPlay(this.selectedFrameLabel);
         }
         this.ModuleVariantGroup.SetHighlightState(true);
         this.SetModuleText(this.BaseModuleName);
         this.SetModuleIcon(this.BaseModuleIcon);
      }
      
      override public function onRollout() : void
      {
         if(this.Module_mc.currentFrameLabel != this.unselectedFrameLabel)
         {
            this.Module_mc.gotoAndPlay(this.unselectedFrameLabel);
         }
         if(this.ModuleInfoSmall_mc.currentFrameLabel != this.unselectedFrameLabel)
         {
            this.ModuleInfoSmall_mc.gotoAndPlay(this.unselectedFrameLabel);
         }
         if(this.ModuleInfoMedium_mc.currentFrameLabel != this.unselectedFrameLabel)
         {
            this.ModuleInfoMedium_mc.gotoAndPlay(this.unselectedFrameLabel);
         }
         this.ModuleVariantGroup.SetHighlightState(false);
         this.SetModuleText(this.BaseModuleName);
         this.SetModuleIcon(this.BaseModuleIcon);
      }
   }
}
