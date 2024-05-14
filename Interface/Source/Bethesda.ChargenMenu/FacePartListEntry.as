package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSStepper;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.Components.ButtonControls.ButtonBar.ButtonBar;
   import Shared.Components.ButtonControls.ButtonData.ButtonBaseData;
   import Shared.Components.ButtonControls.ButtonData.UserEventData;
   import Shared.Components.ButtonControls.ButtonFactory.ButtonFactory;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class FacePartListEntry extends BSContainerEntry
   {
      
      private static const MAX_GENOME_TYPES:int = 6;
      
      private static const STANDARD_TYPE:uint = EnumHelper.GetEnum(0);
      
      private static const POST_BLEND_TYPE:uint = EnumHelper.GetEnum();
      
      private static var Type:uint = STANDARD_TYPE;
      
      public static const STEPPER_VALUE_CHANGED:String = "FacePartEntry_StepperValueChanged";
       
      
      public var FacePartStepper_mc:BSStepper;
      
      public var FaceEntryText_mc:MovieClip;
      
      public var CheckSymbol_mc:MovieClip;
      
      public var ButtonBar_mc:ButtonBar;
      
      public var Genome0_mc:MovieClip;
      
      public var Genome1_mc:MovieClip;
      
      public var Genome2_mc:MovieClip;
      
      public var Genome3_mc:MovieClip;
      
      public var Genome4_mc:MovieClip;
      
      public var Genome5_mc:MovieClip;
      
      private var PresetCount:uint = 0;
      
      private var CurrentPreset:uint = 0;
      
      private var RefinementType:uint;
      
      private var DataName:String = "";
      
      private var StepperID:uint = 4294967295;
      
      private var LastValue:uint = 4294967295;
      
      private var sCallback:String;
      
      private var sRollOnCallback:String;
      
      private var sRollOffCallback:String;
      
      private var bRolledOn:Boolean = false;
      
      public function FacePartListEntry()
      {
         this.RefinementType = FacePage.REFINEMENT_NONE;
         this.sCallback = new String();
         this.sRollOnCallback = new String();
         this.sRollOffCallback = new String();
         super();
         this.FacePartStepper_mc.stationaryArrows = true;
         this.FacePartStepper_mc.addEventListener(BSStepper.VALUE_CHANGED,this.onPresetChanged);
         this.ButtonBar_mc.Initialize(ButtonBar.JUSTIFY_RIGHT,15);
         ButtonFactory.AddToButtonBar("BasicButton",new ButtonBaseData("$REFINE",[new UserEventData("Accept",null)]),this.ButtonBar_mc);
      }
      
      override public function set itemIndex(param1:int) : *
      {
         super.itemIndex = param1;
         var _loc2_:int = 0;
         while(_loc2_ < MAX_GENOME_TYPES)
         {
            this["Genome" + _loc2_.toString() + "_mc"].visible = _loc2_ == param1 % MAX_GENOME_TYPES;
            _loc2_++;
         }
      }
      
      public function get stepperIndex() : uint
      {
         return this.FacePartStepper_mc.index;
      }
      
      public function get stepperListLength() : int
      {
         return this.FacePartStepper_mc.options.length;
      }
      
      override protected function get baseTextField() : TextField
      {
         return (this.FacePartStepper_mc as MovieClip).LabelField_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc3_:uint = 0;
         super.SetEntryText(param1);
         GlobalFunc.SetText(this.baseTextField,!!param1.UILocalizedName ? String(param1.UILocalizedName.toUpperCase()) : String(param1.Name.toUpperCase()),true);
         this.StepperID = param1.ID;
         this.PresetCount = param1.PresetCount;
         this.DataName = param1.uType == FacePage.POST_BLEND ? String(param1.ReferenceName) : String(param1.Name);
         this.RefinementType = param1.uRefinementType;
         Type = param1.uType;
         var _loc2_:Array = new Array();
         if(param1.PresetCount <= 1)
         {
            _loc2_.push("");
            this.FacePartStepper_mc.Cursor_mc.visible = false;
         }
         else
         {
            _loc3_ = 1;
            while(_loc3_ <= param1.PresetCount)
            {
               _loc2_.push(_loc3_.toString());
               _loc3_++;
            }
            this.FacePartStepper_mc.Cursor_mc.visible = true;
         }
         this.FacePartStepper_mc.options = _loc2_;
         this.sCallback = param1.sCallbackName;
         this.sRollOnCallback = param1.sRollOnCallbackName;
         this.sRollOffCallback = param1.sRollOffCallbackName;
         if(this.PresetCount > 0)
         {
            this.CheckSymbol_mc.visible = false;
            this.FacePartStepper_mc.index = param1.CurrentPreset;
            this.FacePartStepper_mc.textField.visible = true;
            this.LastValue = this.FacePartStepper_mc.index;
         }
         else
         {
            this.CheckSymbol_mc.visible = false;
            this.FacePartStepper_mc.textField.visible = false;
         }
         if(selected && param1.uRefinementType != FacePage.REFINEMENT_NONE || (param1.uType != FacePage.POST_BLEND || this.FacePartStepper_mc.index > 0))
         {
            gotoAndStop("SelectedRefinements");
         }
      }
      
      public function onPresetChanged() : *
      {
         if(Type == POST_BLEND_TYPE)
         {
            stage.dispatchEvent(new CustomEvent(STEPPER_VALUE_CHANGED,{
               "strDataName":this.DataName,
               "iIndex":this.FacePartStepper_mc.index
            },true,true));
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(this.sCallback,{
            "uNewPresetID":this.StepperID,
            "iValueDiff":this.FacePartStepper_mc.index - this.LastValue,
            "uCurrentValue":this.FacePartStepper_mc.index,
            "sName":this.DataName
         }));
         CharGenMenu.characterDirty = true;
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_TRAIT_SELECT);
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
      
      public function shouldShowPostBlendRefine() : Boolean
      {
         return Type != FacePage.POST_BLEND || this.FacePartStepper_mc.index > 0;
      }
      
      override public function onRollover() : void
      {
         var _loc1_:String = this.RefinementType != FacePage.REFINEMENT_NONE && this.shouldShowPostBlendRefine() ? "SelectedRefinements" : selectedFrameLabel;
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndPlay(_loc1_);
         }
         this.FacePartStepper_mc.onRollover();
         if(!this.bRolledOn && this.sRollOnCallback && this.sRollOnCallback.length > 0)
         {
            this.bRolledOn = true;
            BSUIDataManager.dispatchEvent(new Event(this.sRollOnCallback));
         }
      }
      
      override public function onRollout() : void
      {
         super.onRollout();
         this.FacePartStepper_mc.onRollout();
         if(Boolean(this.sRollOffCallback) && this.sRollOffCallback.length > 0)
         {
            this.bRolledOn = false;
            BSUIDataManager.dispatchEvent(new Event(this.sRollOffCallback));
         }
      }
      
      public function SetNextCursorRefreshIsAnimation(param1:Boolean) : *
      {
         this.FacePartStepper_mc.nextCursorRefreshIsAnimation = param1;
      }
   }
}
