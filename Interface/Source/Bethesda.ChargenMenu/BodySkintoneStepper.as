package
{
   import Shared.AS3.BSStepper;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class BodySkintoneStepper extends MovieClip
   {
      
      private static const MAX_GENOME_TYPES:int = 6;
       
      
      public var FacePartStepper_mc:BSStepper;
      
      public var Border_mc:MovieClip;
      
      public var FaceEntryText_mc:MovieClip;
      
      public var CheckSymbol_mc:MovieClip;
      
      public var Genome0_mc:MovieClip;
      
      public var Genome1_mc:MovieClip;
      
      public var Genome2_mc:MovieClip;
      
      public var Genome3_mc:MovieClip;
      
      public var Genome4_mc:MovieClip;
      
      public var Genome5_mc:MovieClip;
      
      private var PresetCount:uint = 0;
      
      private var CurrentPreset:uint = 0;
      
      private var PresetTextA:Array;
      
      private var StepperID:uint = 4294967295;
      
      private var LastValue:uint = 4294967295;
      
      private var sCallback:String;
      
      public function BodySkintoneStepper()
      {
         this.PresetTextA = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"];
         this.sCallback = new String();
         super();
         this.FacePartStepper_mc.stationaryArrows = true;
         this.FacePartStepper_mc.addEventListener(BSStepper.VALUE_CHANGED,this.onPresetChanged);
      }
      
      public function get stepperIndex() : uint
      {
         return this.FacePartStepper_mc.index;
      }
      
      public function get stepperListLength() : int
      {
         return this.FacePartStepper_mc.options.length;
      }
      
      protected function get baseTextField() : TextField
      {
         return (this.FacePartStepper_mc as MovieClip).LabelField_tf;
      }
      
      public function SetData(param1:Object) : void
      {
         GlobalFunc.SetText(this.baseTextField,param1.Name.toUpperCase(),true);
         this.StepperID = param1.ID;
         this.PresetCount = param1.PresetCount;
         this.FacePartStepper_mc.options = this.PresetTextA.slice(0,this.PresetCount);
         this.sCallback = param1.sCallbackName;
         if(this.PresetCount > 0 && param1.uRefinementType != FacePage.SLIDER_PLUS)
         {
            this.FacePartStepper_mc.index = param1.CurrentPreset;
            this.FacePartStepper_mc.textField.visible = true;
            this.LastValue = this.FacePartStepper_mc.index;
         }
         else
         {
            this.CheckSymbol_mc.visible = false;
            this.FacePartStepper_mc.textField.visible = false;
         }
      }
      
      public function onPresetChanged() : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(this.sCallback,{
            "uNewPresetID":this.StepperID,
            "iValueDiff":this.FacePartStepper_mc.index - this.LastValue
         }));
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_TRAIT_SELECT);
         CharGenMenu.characterDirty = true;
      }
      
      public function get presetCount() : uint
      {
         return this.PresetCount;
      }
      
      public function get currentPreset() : uint
      {
         return this.CurrentPreset;
      }
      
      public function set currentPreset(param1:uint) : *
      {
         this.CurrentPreset = param1;
         this.FacePartStepper_mc.index = this.CurrentPreset;
      }
      
      public function onRollover() : void
      {
         super.onRollover();
         this.FacePartStepper_mc.onRollover();
      }
      
      public function onRollout() : void
      {
         super.onRollout();
         this.FacePartStepper_mc.onRollout();
      }
      
      public function SetNextCursorRefreshIsAnimation(param1:Boolean) : *
      {
         this.FacePartStepper_mc.nextCursorRefreshIsAnimation = param1;
      }
   }
}
