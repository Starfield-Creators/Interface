package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.AS3.BSScrollingConfigParams;
   import Shared.AS3.BSScrollingContainer;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.ScrollingEvent;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.PlatformUtils;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import scaleform.gfx.TextFieldEx;
   
   public class FacePage extends MovieClip implements IChargenPage
   {
      
      public static const SLIDER_LIST:uint = EnumHelper.GetEnum(0);
      
      public static const SLIDER_PLUS:uint = EnumHelper.GetEnum();
      
      public static const CHECKBOX_LIST:uint = EnumHelper.GetEnum();
      
      public static const REFINEMENT_NONE:uint = EnumHelper.GetEnum();
      
      public static const STANDARD:uint = EnumHelper.GetEnum(0);
      
      public static const POST_BLEND:uint = EnumHelper.GetEnum();
      
      private static const SLIDER_ENTRY_HEIGHT:Number = 30;
      
      private static const SLIDER_LISTS_BUFFER:Number = 40;
      
      private static var Refining:Boolean = false;
      
      public static const SLIDER_KEY_MOVEMENT_PERCENT:Number = 0.05;
       
      
      public var PostBlendSliderList_mc:BSScrollingContainer;
      
      public var FacePartSliderList_mc:BSScrollingContainer;
      
      public var AdditionalSlidersList_mc:BSScrollingContainer;
      
      public var FacePartList_mc:FacePartList;
      
      public var FaceTraitsList_mc:BSScrollingContainer;
      
      public var FacialEditPopup_mc:MovieClip;
      
      public var HeadPartPlusSelector_mc:MovieClip;
      
      private var StepperOrderA:Array;
      
      private var SculptRegionsA:Array;
      
      private var PresetRegionsA:Array;
      
      private var MarkingsSlotsA:Array;
      
      private var CurrentSex:uint = 0;
      
      private var uiController:uint = 0;
      
      public function FacePage()
      {
         this.StepperOrderA = new Array();
         this.SculptRegionsA = new Array();
         this.PresetRegionsA = new Array();
         this.MarkingsSlotsA = [21,22];
         super();
         var _loc1_:Dictionary = new Dictionary();
         _loc1_["CharGen_SkintoneChange"] = EnumHelper.GetEnum(0);
         _loc1_[50] = EnumHelper.GetEnum();
         _loc1_["CharGen_HairChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_HairColorChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_FacialHairChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_FacialHairColorChange"] = EnumHelper.GetEnum();
         _loc1_[30] = EnumHelper.GetEnum();
         _loc1_["CharGen_EyeColorChange"] = EnumHelper.GetEnum();
         _loc1_[66] = EnumHelper.GetEnum();
         _loc1_["CharGen_BrowColorChange"] = EnumHelper.GetEnum();
         _loc1_[62] = EnumHelper.GetEnum();
         _loc1_[34] = EnumHelper.GetEnum();
         _loc1_[26] = EnumHelper.GetEnum();
         _loc1_[72] = EnumHelper.GetEnum();
         _loc1_[22] = EnumHelper.GetEnum();
         _loc1_["CharGen_TeethChange"] = EnumHelper.GetEnum();
         _loc1_[38] = EnumHelper.GetEnum();
         _loc1_[82] = EnumHelper.GetEnum();
         _loc1_[56] = EnumHelper.GetEnum();
         _loc1_["CharGen_MakeupChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_MarkingsChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_JewelryChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_JewelryColorChange"] = EnumHelper.GetEnum();
         _loc1_["CharGen_PostBlendFaceChange"] = EnumHelper.GetEnum();
         this.StepperOrderA.push(_loc1_);
         var _loc2_:Dictionary = new Dictionary();
         _loc2_["CharGen_SkintoneChange"] = EnumHelper.GetEnum(0);
         _loc2_[23] = EnumHelper.GetEnum();
         _loc2_["CharGen_HairChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_HairColorChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_FacialHairChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_FacialHairColorChange"] = EnumHelper.GetEnum();
         _loc2_[64] = EnumHelper.GetEnum();
         _loc2_["CharGen_EyeColorChange"] = EnumHelper.GetEnum();
         _loc2_[60] = EnumHelper.GetEnum();
         _loc2_["CharGen_BrowColorChange"] = EnumHelper.GetEnum();
         _loc2_[71] = EnumHelper.GetEnum();
         _loc2_[50] = EnumHelper.GetEnum();
         _loc2_[56] = EnumHelper.GetEnum();
         _loc2_[46] = EnumHelper.GetEnum();
         _loc2_[41] = EnumHelper.GetEnum();
         _loc2_["CharGen_TeethChange"] = EnumHelper.GetEnum();
         _loc2_[37] = EnumHelper.GetEnum();
         _loc2_[33] = EnumHelper.GetEnum();
         _loc2_[29] = EnumHelper.GetEnum();
         _loc2_["CharGen_MakeupChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_MarkingsChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_JewelryChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_JewelryColorChange"] = EnumHelper.GetEnum();
         _loc2_["CharGen_PostBlendFaceChange"] = EnumHelper.GetEnum();
         this.StepperOrderA.push(_loc2_);
         var _loc3_:BSScrollingConfigParams = new BSScrollingConfigParams();
         _loc3_.VerticalSpacing = 50;
         _loc3_.EntryClassName = "FacePartListEntry";
         _loc3_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.FacePartList_mc.Configure(_loc3_);
         this.FacePartList_mc.addEventListener(ScrollingEvent.SELECTION_CHANGE,this.SelectionChange);
         var _loc4_:BSScrollingConfigParams;
         (_loc4_ = new BSScrollingConfigParams()).VerticalSpacing = 0;
         _loc4_.EntryClassName = "FacePartSliderListEntry";
         _loc4_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.FacePartSliderList_mc.Configure(_loc4_);
         this.FacePartSliderList_mc.visible = false;
         this.FacePartSliderList_mc.addEventListener(ScrollingEvent.LIST_WOULD_HAVE_SCROLLED,this.onFacePartSliderListWouldHaveScrolled);
         this.FacePartSliderList_mc.addEventListener(ScrollingEvent.ENTRY_MOUSE_DOWN,this.onFacePartSliderListPressed);
         _loc4_.EntryClassName = "AdditionalSlidersEntry";
         this.AdditionalSlidersList_mc.Configure(_loc4_);
         this.AdditionalSlidersList_mc.visible = false;
         this.AdditionalSlidersList_mc.addEventListener(ScrollingEvent.LIST_WOULD_HAVE_SCROLLED,this.onAdditionalSliderListWouldHaveScrolled);
         this.AdditionalSlidersList_mc.addEventListener(ScrollingEvent.ENTRY_MOUSE_DOWN,this.onAdditionalSliderListPressed);
         _loc4_.EntryClassName = "PostBlendSliderListEntry";
         this.PostBlendSliderList_mc.Configure(_loc4_);
         this.PostBlendSliderList_mc.visible = false;
         this.PostBlendSliderList_mc.addEventListener(ScrollingEvent.ENTRY_MOUSE_DOWN,this.onPostBlendSliderListPressed);
         var _loc5_:BSScrollingConfigParams;
         (_loc5_ = new BSScrollingConfigParams()).VerticalSpacing = 0;
         _loc5_.EntryClassName = "MarkingsEntry";
         _loc5_.TextOption = TextFieldEx.TEXTAUTOSZ_SHRINK;
         this.FaceTraitsList_mc.Configure(_loc5_);
         this.FaceTraitsList_mc.addEventListener(ScrollingEvent.ITEM_PRESS,this.OnItemPress);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,1);
         this.HeadPartPlusSelector_mc.visible = false;
         BSUIDataManager.Subscribe("ChargenMetadata",this.OnChargenMetaDataChanged);
         this.FacePartList_mc.addEventListener(MouseEvent.ROLL_OVER,this.onPresetListRollover);
      }
      
      public static function set refining(param1:Boolean) : *
      {
         Refining = param1;
      }
      
      private function Refine(param1:Boolean) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         Refining = param1;
         if(param1)
         {
            if(Boolean(this.FacePartList_mc.selectedEntry) && this.FacePartList_mc.selectedEntry.uType == POST_BLEND)
            {
               _loc3_ = this.PostBlendSliderList_mc.GetClipByIndex(this.PostBlendSliderList_mc.selectedClipIndex);
               if(_loc3_)
               {
                  (_loc3_ as BSContainerEntry).onRollover();
               }
            }
            else if(Boolean(this.FacePartList_mc.selectedEntry) && this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_LIST)
            {
               _loc3_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
               if(_loc3_)
               {
                  (_loc3_ as BSContainerEntry).onRollover();
               }
            }
            _loc2_ = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
            if(_loc2_)
            {
               (_loc2_ as BSContainerEntry).onRollout();
            }
         }
         else
         {
            if(Boolean(this.FacePartList_mc.selectedEntry) && this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_LIST)
            {
               _loc3_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
               if(Boolean(_loc3_) && !_loc3_.IsMouseDraggingSlider())
               {
                  (_loc3_ as BSContainerEntry).onRollout();
               }
            }
            _loc2_ = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
            if(_loc2_)
            {
               (_loc2_ as BSContainerEntry).onRollover();
            }
         }
      }
      
      public function IsSliderListActive() : Boolean
      {
         return this.FacePartSliderList_mc.visible;
      }
      
      private function OnItemPress() : *
      {
         var _loc1_:MovieClip = this.FaceTraitsList_mc.GetClipByIndex(this.FaceTraitsList_mc.selectedClipIndex);
         (_loc1_ as MarkingsEntry).onClick();
      }
      
      public function onMouseWheel(param1:MouseEvent) : *
      {
         this.FacePartList_mc.onMouseWheel(param1);
         param1.stopPropagation();
         param1.stopImmediatePropagation();
      }
      
      private function OnChargenMetaDataChanged(param1:FromClientDataEvent) : void
      {
         this.CurrentSex = param1.data.Sex;
         this.SculptRegionsA.splice(0);
         this.PresetRegionsA.splice(0);
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.FacialBoneRegionsA.length)
         {
            if(param1.data.FacialBoneRegionsA[_loc2_].IsSculptRegion)
            {
               this.SculptRegionsA[this.StepperOrderA[param1.data.Sex][param1.data.FacialBoneRegionsA[_loc2_].ID]] = GlobalFunc.CloneObject(param1.data.FacialBoneRegionsA[_loc2_]);
            }
            else
            {
               this.PresetRegionsA.push(GlobalFunc.CloneObject(param1.data.FacialBoneRegionsA[_loc2_]));
            }
            _loc2_++;
         }
         var _loc3_:* = 0;
         while(_loc3_ < this.SculptRegionsA.length)
         {
            if(this.SculptRegionsA[_loc3_])
            {
               this.SculptRegionsA[_loc3_].presetCount = this.PresetRegionsA.length;
            }
            _loc3_++;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < param1.data.StepperDataA.length)
         {
            this.SculptRegionsA[this.StepperOrderA[param1.data.Sex][param1.data.StepperDataA[_loc4_].sCallbackName]] = param1.data.StepperDataA[_loc4_];
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.data.StepperDataA.length)
         {
            if(param1.data.StepperDataA[_loc4_].sCallbackName == "CharGen_PostBlendFaceChange")
            {
               this.SculptRegionsA[this.StepperOrderA[param1.data.Sex][param1.data.StepperDataA[_loc4_].sCallbackName] + param1.data.StepperDataA[_loc4_].uIndex] = GlobalFunc.CloneObject(param1.data.StepperDataA[_loc4_]);
            }
            _loc4_++;
         }
         this.FacePartList_mc.InitializeEntries(this.SculptRegionsA);
         this.Refine(Refining);
         this.UpdateSublistSelection();
      }
      
      public function onKeyDownHandler(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.LEFT)
         {
            if(stage.focus == this.FacePartList_mc)
            {
               this.onPresetLeft();
            }
            else if(this.GetFocusIsRefinementSliders())
            {
               this.onSliderLeft(false);
            }
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            if(stage.focus == this.FacePartList_mc)
            {
               this.onPresetRight();
            }
            else if(this.GetFocusIsRefinementSliders())
            {
               this.onSliderRight(false);
            }
         }
      }
      
      public function onKeyUpHandler(param1:KeyboardEvent) : *
      {
         if(this.GetFocusIsRefinementSliders())
         {
            if(param1.keyCode == Keyboard.LEFT)
            {
               this.onSliderLeft(true);
            }
            else if(param1.keyCode == Keyboard.RIGHT)
            {
               this.onSliderRight(true);
            }
         }
      }
      
      private function onPresetLeft() : *
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:PostBlendSliderListEntry = null;
         var _loc1_:MovieClip = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
         var _loc2_:FacePartListEntry = _loc1_ as FacePartListEntry;
         if(_loc2_)
         {
            if(_loc2_.stepperIndex > 0)
            {
               _loc2_.SetNextCursorRefreshIsAnimation(true);
               --_loc2_.FacePartStepper_mc.index;
               _loc3_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND ? String(this.FacePartList_mc.selectedEntry.ReferenceName) : String(this.FacePartList_mc.selectedEntry.Name);
               BSUIDataManager.dispatchEvent(new CustomEvent(this.FacePartList_mc.selectedEntry.sCallbackName,{
                  "uNewPresetID":(this.FacePartList_mc.selectedEntry.ID != undefined ? this.FacePartList_mc.selectedEntry.ID : 0),
                  "iValueDiff":-1,
                  "uCurrentValue":_loc2_.FacePartStepper_mc.index,
                  "sName":_loc3_
               }));
               CharGenMenu.characterDirty = true;
               if(this.FacePartList_mc.selectedEntry.uType == POST_BLEND)
               {
                  _loc4_ = 0;
                  while(_loc4_ < this.PostBlendSliderList_mc.totalEntryClips)
                  {
                     if((_loc6_ = this.PostBlendSliderList_mc.GetClipByIndex(_loc4_) as PostBlendSliderListEntry).isColorOption)
                     {
                        _loc6_.subType = this.FacePartList_mc.selectedIndex;
                        break;
                     }
                     _loc4_++;
                  }
                  _loc5_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND ? String(this.FacePartList_mc.selectedEntry.ReferenceName) : String(this.FacePartList_mc.selectedEntry.Name);
                  stage.dispatchEvent(new CustomEvent(FacePartListEntry.STEPPER_VALUE_CHANGED,{
                     "strDataName":_loc5_,
                     "iIndex":_loc2_.stepperIndex
                  },true,true));
               }
               GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_TRAIT_SELECT);
            }
         }
      }
      
      private function onPresetRight() : *
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:PostBlendSliderListEntry = null;
         var _loc1_:MovieClip = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
         var _loc2_:FacePartListEntry = _loc1_ as FacePartListEntry;
         if(_loc2_)
         {
            if(_loc2_.stepperIndex < _loc2_.stepperListLength - 1)
            {
               _loc2_.SetNextCursorRefreshIsAnimation(true);
               _loc2_.FacePartStepper_mc.index += 1;
               _loc3_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND ? String(this.FacePartList_mc.selectedEntry.ReferenceName) : String(this.FacePartList_mc.selectedEntry.Name);
               BSUIDataManager.dispatchEvent(new CustomEvent(this.FacePartList_mc.selectedEntry.sCallbackName,{
                  "uNewPresetID":(this.FacePartList_mc.selectedEntry.ID != undefined ? this.FacePartList_mc.selectedEntry.ID : 0),
                  "iValueDiff":1,
                  "uCurrentValue":_loc2_.FacePartStepper_mc.index,
                  "sName":_loc3_
               }));
               CharGenMenu.characterDirty = true;
               if(this.FacePartList_mc.selectedEntry.uType == POST_BLEND)
               {
                  _loc4_ = 0;
                  while(_loc4_ < this.PostBlendSliderList_mc.totalEntryClips)
                  {
                     if((_loc6_ = this.PostBlendSliderList_mc.GetClipByIndex(_loc4_) as PostBlendSliderListEntry).isColorOption)
                     {
                        _loc6_.subType = _loc2_.FacePartStepper_mc.index;
                        break;
                     }
                     _loc4_++;
                  }
                  _loc5_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND ? String(this.FacePartList_mc.selectedEntry.ReferenceName) : String(this.FacePartList_mc.selectedEntry.Name);
                  stage.dispatchEvent(new CustomEvent(FacePartListEntry.STEPPER_VALUE_CHANGED,{
                     "strDataName":_loc5_,
                     "iIndex":_loc2_.stepperIndex
                  },true,true));
               }
               GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_TRAIT_SELECT);
            }
         }
      }
      
      private function onSliderLeft(param1:Boolean) : *
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:MovieClip = null;
         if(!param1)
         {
            _loc2_ = stage.focus == this.AdditionalSlidersList_mc;
            _loc3_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND;
            _loc4_ = null;
            if(_loc3_)
            {
               _loc4_ = this.PostBlendSliderList_mc.GetClipByIndex(this.PostBlendSliderList_mc.selectedClipIndex);
            }
            else if(_loc2_)
            {
               _loc4_ = this.AdditionalSlidersList_mc.GetClipByIndex(this.AdditionalSlidersList_mc.selectedClipIndex);
            }
            else
            {
               _loc4_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
            }
            _loc4_.onLeft();
            if(!_loc3_ && !_loc2_)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetSlider",{
                  "uSliderIndex":this.FacePartSliderList_mc.selectedEntry.ID,
                  "fSliderValue":_loc4_.sliderValue
               }));
               CharGenMenu.characterDirty = true;
            }
         }
      }
      
      private function onSliderRight(param1:Boolean) : *
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:MovieClip = null;
         if(!param1)
         {
            _loc2_ = stage.focus == this.AdditionalSlidersList_mc;
            _loc3_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND;
            _loc4_ = null;
            if(_loc3_)
            {
               _loc4_ = this.PostBlendSliderList_mc.GetClipByIndex(this.PostBlendSliderList_mc.selectedClipIndex);
            }
            else if(_loc2_)
            {
               _loc4_ = this.AdditionalSlidersList_mc.GetClipByIndex(this.AdditionalSlidersList_mc.selectedClipIndex);
            }
            else
            {
               _loc4_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
            }
            _loc4_.onRight();
            if(!_loc3_ && !_loc2_)
            {
               BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetSlider",{
                  "uSliderIndex":this.FacePartSliderList_mc.selectedEntry.ID,
                  "fSliderValue":_loc4_.sliderValue
               }));
               CharGenMenu.characterDirty = true;
            }
         }
      }
      
      private function GetFocusIsRefinementSliders() : Boolean
      {
         return stage.focus == this.FacePartSliderList_mc || stage.focus == this.AdditionalSlidersList_mc || stage.focus == this.PostBlendSliderList_mc;
      }
      
      public function UpdateData(param1:Object) : *
      {
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(param2 == false)
         {
            if(param1 == "Accept")
            {
               if(stage.focus == this.HeadPartPlusSelector_mc || this.GetFocusIsRefinementSliders())
               {
                  GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE);
                  this.onCancel();
               }
               else
               {
                  this.onAccept();
               }
            }
            else if(param1 == "Cancel")
            {
               this.onCancel();
               GlobalFunc.PlayMenuSound(GlobalFunc.CANCEL_SOUND);
            }
         }
         return false;
      }
      
      public function onAccept() : *
      {
         var _loc2_:MovieClip = null;
         var _loc1_:CharGenMenu = this.GetCharGenMenu();
         if(this.FacePartList_mc.selectedEntry.uType == POST_BLEND)
         {
            _loc2_ = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
            if(_loc2_.shouldShowPostBlendRefine())
            {
               stage.focus = this.PostBlendSliderList_mc;
               if(_loc1_ != null)
               {
                  _loc1_.UpdateButtons();
               }
               this.PostBlendSliderList_mc.selectedIndex = 0;
               this.Refine(true);
               this.UpdateSublistSelection();
               stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            }
         }
         else if(this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_PLUS)
         {
            this.HeadPartPlusSelector_mc.InitializeSliders(this.FacePartList_mc.selectedEntry.SlidersA,this.CurrentSex);
            this.HeadPartPlusSelector_mc.active = true;
            stage.focus = this.HeadPartPlusSelector_mc;
            this.HeadPartPlusSelector_mc.addEventListener(HeadPartsPlusSelector.CANCEL_CLICKED,this.onCancel);
            this.HeadPartPlusSelector_mc.SetFocus(true);
            this.Refine(true);
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else if(this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_LIST)
         {
            stage.focus = this.FacePartSliderList_mc;
            if(_loc1_ != null)
            {
               _loc1_.UpdateButtons();
            }
            this.Refine(true);
            this.UpdateSublistSelection();
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else if(this.FacePartList_mc.selectedEntry.uRefinementType == CHECKBOX_LIST && stage.focus != this.FaceTraitsList_mc)
         {
            this.FaceTraitsList_mc.InitializeEntries(this.FacePartList_mc.selectedEntry.EntriesA);
            this.FaceTraitsList_mc.selectedIndex = 0;
            stage.focus = this.FaceTraitsList_mc;
            this.Refine(true);
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE);
      }
      
      public function SelectionChange() : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = false;
         var _loc4_:Array = null;
         var _loc5_:MovieClip = null;
         var _loc6_:FacePartListEntry = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         var _loc11_:MovieClip = null;
         if(this.FacePartList_mc.selectedEntry)
         {
            _loc1_ = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
            _loc2_ = !this.HeadPartPlusSelector_mc.visible && this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_PLUS;
            _loc3_ = this.FacePartList_mc.selectedEntry.uType == POST_BLEND;
            this.HeadPartPlusSelector_mc.visible = !_loc3_ && this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_PLUS;
            this.PostBlendSliderList_mc.visible = _loc3_ && (!_loc1_ || _loc1_.stepperIndex > 0);
            this.FacePartSliderList_mc.visible = !_loc3_ && this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_LIST;
            this.AdditionalSlidersList_mc.visible = !_loc3_ && this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_LIST && Boolean(this.FacePartList_mc.selectedEntry.AdditionalSlidersA) && this.FacePartList_mc.selectedEntry.AdditionalSlidersA.length > 0;
            this.FaceTraitsList_mc.visible = !_loc3_ && this.FacePartList_mc.selectedEntry.uRefinementType == CHECKBOX_LIST;
            if(this.FacePartList_mc.selectedEntry.uRefinementType == SLIDER_LIST)
            {
               if(_loc3_)
               {
                  this.PostBlendSliderList_mc.ClearEntryList();
                  _loc4_ = new Array();
                  _loc6_ = (_loc5_ = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex)) as FacePartListEntry;
                  if(Boolean(this.FacePartList_mc.selectedEntry.IntensitySlidersA) && this.FacePartList_mc.selectedEntry.IntensitySlidersA.length > 0)
                  {
                     (_loc7_ = new Object()).sliderDataA = this.FacePartList_mc.selectedEntry.IntensitySlidersA.slice(0,this.FacePartList_mc.selectedEntry.IntensitySlidersA.length);
                     _loc7_.arrayIndex = !!_loc6_ ? _loc6_.stepperIndex : 0;
                     _loc7_.isIntensitySlider = true;
                     _loc7_.fIntensity = !!_loc6_ ? this.FacePartList_mc.selectedEntry.IntensitySlidersA[_loc6_.stepperIndex] : 0;
                     _loc7_.bIsColorOption = false;
                     _loc4_.push(_loc7_);
                  }
                  if(Boolean(this.FacePartList_mc.selectedEntry.ColorSlidersA) && this.FacePartList_mc.selectedEntry.ColorSlidersA.length > 0)
                  {
                     if(_loc6_.stepperIndex < this.FacePartList_mc.selectedEntry.ColorSlidersA.length && !this.FacePartList_mc.selectedEntry.ColorSlidersA[_loc6_.stepperIndex].bIsEmptyColor)
                     {
                        (_loc8_ = new Object()).sliderDataA = this.FacePartList_mc.selectedEntry.ColorSlidersA.slice(0,this.FacePartList_mc.selectedEntry.ColorSlidersA.length);
                        _loc8_.arrayIndex = !!_loc6_ ? _loc6_.stepperIndex : 0;
                        _loc8_.bIsColorOption = true;
                        _loc4_.push(_loc8_);
                     }
                  }
                  this.PostBlendSliderList_mc.InitializeEntries(_loc4_);
               }
               else
               {
                  this.FacePartSliderList_mc.ClearEntryList();
                  _loc9_ = GlobalFunc.CloneObject(this.FacePartList_mc.selectedEntry);
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_.SlidersA.length)
                  {
                     _loc9_.SlidersA[_loc10_].Name = _loc9_.SlidersA[_loc10_].UILocalizedName.toUpperCase();
                     _loc10_++;
                  }
                  this.FacePartSliderList_mc.InitializeEntries(_loc9_.SlidersA);
                  if((Boolean(_loc11_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex))) && !_loc11_.IsMouseDraggingSlider())
                  {
                     (_loc11_ as BSContainerEntry).onRollout();
                  }
                  this.AdditionalSlidersList_mc.ClearEntryList();
                  this.AdditionalSlidersList_mc.InitializeEntries(this.FacePartList_mc.selectedEntry.AdditionalSlidersA);
               }
            }
            else if(_loc2_)
            {
               this.HeadPartPlusSelector_mc.SetFocus(false);
               if(this.uiController == PlatformUtils.PLATFORM_PC_KB_MOUSE)
               {
                  this.HeadPartPlusSelector_mc.InitializeSliders(this.FacePartList_mc.selectedEntry.SlidersA,this.CurrentSex);
               }
            }
            if(this.FacePartSliderList_mc.visible && this.FacePartSliderList_mc.selectedIndex < 0)
            {
               this.FacePartSliderList_mc.selectedIndex = 0;
            }
            else if(this.PostBlendSliderList_mc.visible && this.PostBlendSliderList_mc.selectedIndex < 0)
            {
               this.PostBlendSliderList_mc.selectedIndex = 0;
            }
            this.UpdateSublistSelection();
            this.AdditionalSlidersList_mc.y = this.FacePartSliderList_mc.y + this.FacePartSliderList_mc.itemsShown * SLIDER_ENTRY_HEIGHT + SLIDER_LISTS_BUFFER;
         }
      }
      
      public function onCancel() : *
      {
         var _loc1_:CharGenMenu = null;
         if(this.GetFocusIsRefinementSliders())
         {
            stage.focus = this.FacePartList_mc;
            _loc1_ = this.GetCharGenMenu();
            if(_loc1_ != null)
            {
               _loc1_.UpdateButtons();
            }
            this.Refine(false);
            this.UpdateSublistSelection();
         }
         else if(stage.focus == this.HeadPartPlusSelector_mc)
         {
            this.HeadPartPlusSelector_mc.active = false;
            stage.focus = this.FacePartList_mc;
            this.HeadPartPlusSelector_mc.SetFocus(false);
            this.HeadPartPlusSelector_mc.removeEventListener(HeadPartsPlusSelector.CANCEL_CLICKED,this.onCancel);
            this.Refine(false);
         }
         else if(stage.focus == this.FaceTraitsList_mc)
         {
            this.FaceTraitsList_mc.visible = false;
            stage.focus = this.FacePartList_mc;
            this.Refine(false);
         }
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,1);
      }
      
      public function onPresetListRollover() : *
      {
         this.onCancel();
      }
      
      public function onEnterPage() : *
      {
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         stage.focus = this.FacePartList_mc;
         this.FacePartList_mc.selectedIndex = 0;
         gotoAndPlay("Open");
         BSUIDataManager.dispatchEvent(new CustomEvent("CharGen_SetCameraPosition",{"uNewCameraPositions":CharGenMenu.FACE_CAMERA_POSITION}));
         this.FacePartList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         this.FacePartSliderList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayRefineFocusSound);
         this.FaceTraitsList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayRefineFocusSound);
         this.AdditionalSlidersList_mc.addEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayRefineFocusSound);
      }
      
      public function onExitPage() : *
      {
         this.onCancel();
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         gotoAndPlay("Close");
         this.FacePartList_mc.removeEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayFocusSound);
         var _loc1_:MovieClip = this.FacePartList_mc.GetClipByIndex(this.FacePartList_mc.selectedClipIndex);
         _loc1_.onRollout();
         this.FacePartSliderList_mc.removeEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayRefineFocusSound);
         this.FaceTraitsList_mc.removeEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayRefineFocusSound);
         this.AdditionalSlidersList_mc.removeEventListener(ScrollingEvent.PLAY_FOCUS_SOUND,this.PlayRefineFocusSound);
      }
      
      public function OnControlMapChanged(param1:Object) : void
      {
         this.uiController = param1.uiController;
      }
      
      public function InitFocus() : *
      {
         stage.focus = this.FacePartList_mc;
      }
      
      private function GetCharGenMenu() : CharGenMenu
      {
         var _loc1_:CharGenMenu = null;
         if(parent != null)
         {
            _loc1_ = parent as CharGenMenu;
         }
         return _loc1_;
      }
      
      public function onChangeButtonHit() : *
      {
         if(stage.focus == this.FacePartList_mc)
         {
            this.onPresetRight();
         }
         else if(this.GetFocusIsRefinementSliders())
         {
            this.onSliderRight(false);
         }
      }
      
      public function onFacePartSliderListPressed(param1:ScrollingEvent) : *
      {
         this.FacePartSliderList_mc.selectedIndex = param1.CurrentIndex;
         stage.focus = this.FacePartSliderList_mc;
         this.UpdateSublistSelection();
      }
      
      public function onAdditionalSliderListPressed(param1:ScrollingEvent) : *
      {
         this.AdditionalSlidersList_mc.selectedIndex = param1.CurrentIndex;
         stage.focus = this.AdditionalSlidersList_mc;
         this.UpdateSublistSelection();
      }
      
      public function onPostBlendSliderListPressed(param1:ScrollingEvent) : *
      {
         this.PostBlendSliderList_mc.selectedIndex = param1.CurrentIndex;
         stage.focus = this.PostBlendSliderList_mc;
         this.UpdateSublistSelection();
      }
      
      private function PlayFocusSound() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_FOCUS);
      }
      
      private function PlayRefineFocusSound() : *
      {
         GlobalFunc.PlayMenuSound(CharGenMenu.CHARGEN_MENU_SOUND_REFINE_FOCUS);
      }
      
      private function onFacePartSliderListWouldHaveScrolled(param1:ScrollingEvent) : *
      {
         if(param1.CurrentIndex > param1.PreviousIndex && this.AdditionalSlidersList_mc.visible == true)
         {
            stage.focus = this.AdditionalSlidersList_mc;
            this.AdditionalSlidersList_mc.selectedIndex = 0;
            this.UpdateSublistSelection();
         }
      }
      
      private function onAdditionalSliderListWouldHaveScrolled(param1:ScrollingEvent) : *
      {
         if(param1.CurrentIndex < param1.PreviousIndex)
         {
            stage.focus = this.FacePartSliderList_mc;
            this.UpdateSublistSelection();
         }
      }
      
      private function UpdateSublistSelection() : *
      {
         var _loc1_:MovieClip = null;
         if(stage.focus == this.FacePartSliderList_mc)
         {
            _loc1_ = this.AdditionalSlidersList_mc.GetClipByIndex(this.AdditionalSlidersList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollout();
            }
            _loc1_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollover();
            }
         }
         else if(stage.focus == this.AdditionalSlidersList_mc)
         {
            _loc1_ = this.AdditionalSlidersList_mc.GetClipByIndex(this.AdditionalSlidersList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollover();
            }
            _loc1_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollout();
            }
         }
         else if(stage.focus == this.PostBlendSliderList_mc)
         {
            _loc1_ = this.PostBlendSliderList_mc.GetClipByIndex(this.PostBlendSliderList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollover();
            }
         }
         else
         {
            _loc1_ = this.AdditionalSlidersList_mc.GetClipByIndex(this.AdditionalSlidersList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollout();
            }
            _loc1_ = this.FacePartSliderList_mc.GetClipByIndex(this.FacePartSliderList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollout();
            }
            _loc1_ = this.PostBlendSliderList_mc.GetClipByIndex(this.PostBlendSliderList_mc.selectedClipIndex);
            if(Boolean(_loc1_) && !_loc1_.IsMouseDraggingSlider())
            {
               (_loc1_ as BSContainerEntry).onRollout();
            }
         }
      }
   }
}
