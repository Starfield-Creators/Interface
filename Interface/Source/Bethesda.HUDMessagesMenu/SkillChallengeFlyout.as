package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.Components.ContentLoaders.LibraryLoader;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class SkillChallengeFlyout extends MovieClip
   {
      
      private static const FADE_IN:String = "FadeIn";
      
      private static const START_FILL_UP:String = "StartFillUp";
      
      private static const FADE_OUT_COMPLETE:String = "FadeOutComplete";
      
      private static const FILL_UP_TIME:Number = 1000;
      
      private static const MAX_PROGRESS_BAR_WIDTH:Number = 350;
      
      private static const CATEGORY_PATCH_SCALE_X:Number = 0.97;
      
      private static const CATEGORY_PATCH_SCALE_Y:Number = 0.97;
      
      private static const CATEGORY_PATCH_X:Number = 40.75;
      
      private static const CATEGORY_PATCH_Y:Number = 51.75;
       
      
      public var SkillName_mc:MovieClip;
      
      public var SkillDescription_mc:MovieClip;
      
      public var Repetitions_mc:MovieClip;
      
      public var CategoryImageStub_mc:MovieClip;
      
      public var ProgressBar_mc:MovieClip;
      
      private var QueuedFlyouts:Vector.<Object>;
      
      private var PreviousCategory:uint = 0;
      
      private var PreviousArtName:String = "";
      
      private var CurrentFlyoutData:Object;
      
      private var SkillPatchLibraryLoader:LibraryLoader = null;
      
      private var FillUpProgressBar:Boolean = false;
      
      private var StartTimeForFill:Number = 0;
      
      private var SkillPatchClip:MovieClip = null;
      
      private var CategoryPatchClip:MovieClip = null;
      
      public function SkillChallengeFlyout()
      {
         super();
         this.visible = false;
         this.QueuedFlyouts = new Vector.<Object>();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.SkillDescription_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.SkillPatchLibraryLoader = new LibraryLoader(LibraryLoaderConfig.SKILL_PATCHES_LIBRARY_CONFIG);
         this.SkillPatchLibraryLoader.addEventListener(this.SkillPatchLibraryLoader.loadCompleteEventName,this.OnLibraryLoaded);
         BSUIDataManager.Subscribe("SkillChallengeUpdateData",this.onSkillChallengeUpdate);
      }
      
      public function get SkillName_tf() : TextField
      {
         return this.SkillName_mc.SkillName_tf;
      }
      
      public function get SkillDescription_tf() : TextField
      {
         return this.SkillDescription_mc.SkillDescription_tf;
      }
      
      public function get Repetitions_tf() : TextField
      {
         return this.Repetitions_mc.Repetitions_tf;
      }
      
      private function OnLibraryLoaded(param1:Event) : *
      {
         this.SkillPatchLibraryLoader.removeEventListener(this.SkillPatchLibraryLoader.loadCompleteEventName,this.OnLibraryLoaded);
         this.ProcessQueue();
      }
      
      public function onSkillChallengeUpdate(param1:FromClientDataEvent) : *
      {
         var _loc2_:Object = null;
         if(param1.data.strFullName.length > 0)
         {
            _loc2_ = param1.data;
            this.QueuedFlyouts.push(_loc2_);
         }
         if(!visible)
         {
            this.ProcessQueue();
         }
      }
      
      private function ProcessQueue() : *
      {
         var _loc1_:Class = null;
         if(this.SkillPatchLibraryLoader.isLoaded())
         {
            if(this.QueuedFlyouts.length > 0)
            {
               this.CurrentFlyoutData = this.QueuedFlyouts.shift();
               GlobalFunc.SetText(this.SkillName_tf,this.CurrentFlyoutData.strFullName);
               GlobalFunc.SetText(this.SkillDescription_tf,this.CurrentFlyoutData.strDescription);
               GlobalFunc.SetText(this.Repetitions_tf,this.CurrentFlyoutData.uiCurrentRepetitions.toString() + "/" + this.CurrentFlyoutData.uiMaxRepetitions.toString());
               if(this.CurrentFlyoutData.sArtName != this.PreviousArtName)
               {
                  if(this.CategoryPatchClip != null)
                  {
                     this.removeChild(this.CategoryPatchClip);
                  }
                  _loc1_ = getDefinitionByName("Patch_Container_" + this.CurrentFlyoutData.uiCategory) as Class;
                  this.CategoryPatchClip = new _loc1_();
                  this.CategoryPatchClip.SkillNameplate_mc.visible = false;
                  this.CategoryPatchClip.mouseEnabled = false;
                  this.CategoryPatchClip.mouseChildren = false;
                  addChild(this.CategoryPatchClip);
                  if(this.CurrentFlyoutData.sArtName != "")
                  {
                     this.SkillPatchClip = this.SkillPatchLibraryLoader.LoadClip(this.CurrentFlyoutData.sArtName);
                     this.CategoryPatchClip.PatchArtClip_mc.addChild(this.SkillPatchClip);
                  }
                  this.CategoryPatchClip.scaleX = CATEGORY_PATCH_SCALE_X;
                  this.CategoryPatchClip.scaleY = CATEGORY_PATCH_SCALE_Y;
                  this.CategoryPatchClip.x = CATEGORY_PATCH_X;
                  this.CategoryPatchClip.y = CATEGORY_PATCH_Y;
                  this.CategoryPatchClip.alpha = 0;
               }
               if(this.SkillPatchClip)
               {
                  this.SkillPatchClip.gotoAndStop("Rank" + this.CurrentFlyoutData.uRank);
               }
               this.PreviousCategory = this.CurrentFlyoutData.uiCategory;
               this.PreviousArtName = this.CurrentFlyoutData.sArtName;
               this.SetFillBarToValue(this.CurrentFlyoutData.uiPreviousRepetitions);
               visible = true;
               this.FillUpProgressBar = false;
               gotoAndStop(FADE_IN);
               if(!hasEventListener(Event.ENTER_FRAME))
               {
                  addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               }
               if(this.CurrentFlyoutData.uiCurrentRepetitions >= this.CurrentFlyoutData.uiMaxRepetitions)
               {
                  GlobalFunc.PlayMenuSound("UIChallengeCompletionA");
               }
            }
            else
            {
               visible = false;
               if(hasEventListener(Event.ENTER_FRAME))
               {
                  removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               }
            }
         }
      }
      
      protected function OnStartFillUp() : *
      {
         this.StartTimeForFill = getTimer();
         this.FillUpProgressBar = true;
      }
      
      protected function OnStartFadeOut() : *
      {
         if(this.CurrentFlyoutData)
         {
            if(this.CurrentFlyoutData.uiCurrentRepetitions >= this.CurrentFlyoutData.uiMaxRepetitions)
            {
               GlobalFunc.PlayMenuSound("UIChallengeCompletionB");
            }
         }
      }
      
      protected function OnFadeOutComplete() : *
      {
         this.ProcessQueue();
      }
      
      private function SetFillBarToValue(param1:Number) : *
      {
         var _loc2_:Number = NaN;
         if(this.CurrentFlyoutData.uiMaxRepetitions != 0)
         {
            _loc2_ = GlobalFunc.Clamp(param1 / Number(this.CurrentFlyoutData.uiMaxRepetitions),0,1);
            this.ProgressBar_mc.Fill_mc.width = MAX_PROGRESS_BAR_WIDTH * _loc2_;
         }
      }
      
      private function onEnterFrame(param1:Event) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         gotoAndStop(currentFrame + 1);
         if(this.CategoryPatchClip)
         {
            this.CategoryPatchClip.alpha = this.CategoryImageStub_mc.alpha;
         }
         if(this.FillUpProgressBar)
         {
            _loc2_ = getTimer() - this.StartTimeForFill;
            _loc3_ = Math.min(_loc2_ / FILL_UP_TIME,1);
            _loc4_ = this.CurrentFlyoutData.uiPreviousRepetitions + _loc3_ * (this.CurrentFlyoutData.uiCurrentRepetitions - this.CurrentFlyoutData.uiPreviousRepetitions);
            this.SetFillBarToValue(_loc4_);
            if(_loc3_ >= 1)
            {
               this.FillUpProgressBar = false;
            }
         }
      }
   }
}
