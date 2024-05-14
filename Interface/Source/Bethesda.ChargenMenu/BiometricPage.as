package
{
   import Shared.AS3.BSStepper;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class BiometricPage extends MovieClip implements IChargenPage
   {
       
      
      public var FacialFeatures_mc:BSStepper;
      
      public var NoteBiometric_mc:MovieClip;
      
      public var PersonnelRecord_mc:MovieClip;
      
      private var Initialized:Boolean = false;
      
      public function BiometricPage()
      {
         super();
         this.FacialFeatures_mc.stationaryArrows = true;
         this.FacialFeatures_mc.confirmBeforeChange = true;
      }
      
      public function onRollOverFacialFeatures() : *
      {
         this.SetFocus(this.FacialFeatures_mc);
      }
      
      public function UpdateData(param1:Object) : *
      {
         var _loc4_:String = null;
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < param1.uCharacterPresetCount)
         {
            _loc4_ = "";
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         this.FacialFeatures_mc.options = _loc2_;
         if(!this.Initialized && param1.uCharacterPresetCount > 0)
         {
            this.Initialized = true;
            this.FacialFeatures_mc.index = Math.floor(Math.random() * param1.uCharacterPresetCount);
            this.onPresetChanged();
         }
         this.updateRecordNumberText();
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return false;
      }
      
      public function onEnterPage() : *
      {
         gotoAndPlay("Open");
         this.SetFocus(this.FacialFeatures_mc);
         this.FacialFeatures_mc.addEventListener(BSStepper.VALUE_CHANGED,this.onPresetChanged,false,0,true);
         this.FacialFeatures_mc.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverFacialFeatures,false,0,true);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler,false,0,true);
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetCameraPosition",{"uNewCameraPositions":CharGenMenu.PRESET_CAMERA_POSITION}));
      }
      
      public function onExitPage() : *
      {
         gotoAndPlay("Close");
         this.FacialFeatures_mc.removeEventListener(BSStepper.VALUE_CHANGED,this.onPresetChanged);
         this.FacialFeatures_mc.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverFacialFeatures);
         removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
      }
      
      public function InitFocus() : *
      {
         this.SetFocus(this.FacialFeatures_mc);
      }
      
      public function onToggleLeft() : *
      {
      }
      
      public function onToggleRight() : *
      {
      }
      
      public function onPresetChangeLeft() : *
      {
      }
      
      public function onPresetChangeRight() : *
      {
         this.FacialFeatures_mc.PressHandler();
      }
      
      private function SetFocus(param1:MovieClip) : *
      {
         if(param1 != null)
         {
            stage.focus = param1;
            switch(param1)
            {
               case this.FacialFeatures_mc:
                  GlobalFunc.PlayMenuSound(GlobalFunc.FOCUS_SOUND);
                  this.FacialFeatures_mc.onRollover();
            }
         }
      }
      
      private function onPresetChanged() : *
      {
         this.updateRecordNumberText();
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_PresetChange",{"uSelectedPreset":this.FacialFeatures_mc.index}));
         GlobalFunc.PlayMenuSound("UIMenuChargenPersonnelRecord");
      }
      
      private function updateRecordNumberText() : *
      {
         GlobalFunc.SetText((this.FacialFeatures_mc as MovieClip).PersonalRecordNum_mc.text_tf,(this.FacialFeatures_mc.index + 1).toString());
      }
      
      private function onCancel() : *
      {
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.onCancel();
         }
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
      }
      
      private function onAccept() : *
      {
      }
   }
}
