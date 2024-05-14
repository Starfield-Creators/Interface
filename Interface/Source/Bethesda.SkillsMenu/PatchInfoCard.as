package
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class PatchInfoCard extends MovieClip
   {
       
      
      public var CurrentRank_mc:MovieClip;
      
      public var Locked_mc:MovieClip;
      
      public var SkillDescriptionText_mc:MovieClip;
      
      public var ChallengeProgress_mc:MovieClip;
      
      public var InfoCardBackground_mc:MovieClip;
      
      public var TranslationHelper_tf:TextField;
      
      private var RightPanelDescription_tf:TextField = null;
      
      public function PatchInfoCard()
      {
         super();
         this.RightPanelDescription_tf = this.Locked_mc.UnlockDesc_mc.text_tf;
         stage.addEventListener(PatchClip.PATCH_SELECTION_CHANGED,this.onSelectionChanged);
      }
      
      private function GetTierText(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 1:
               _loc2_ = "BASIC";
               break;
            case 2:
               _loc2_ = "ADVANCED";
               break;
            case 3:
               _loc2_ = "EXPERT";
               break;
            case 4:
               _loc2_ = "MASTER";
         }
         return _loc2_;
      }
      
      private function GetCategoryText(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 1:
               _loc2_ = "Combat";
               break;
            case 2:
               _loc2_ = "Science";
               break;
            case 3:
               _loc2_ = "Tech";
               break;
            case 4:
               _loc2_ = "Physical";
               break;
            case 5:
               _loc2_ = "Social";
         }
         return _loc2_;
      }
      
      private function GetTranslatedCategoryText(param1:uint) : String
      {
         this.TranslationHelper_tf.text = "$" + this.GetCategoryText(param1);
         return this.TranslationHelper_tf.text;
      }
      
      private function GetTranslatedCategoryTierText(param1:uint, param2:uint) : String
      {
         this.TranslationHelper_tf.text = "$" + this.GetCategoryText(param1).toUpperCase() + "_SKILLS_" + this.GetTierText(param2);
         return this.TranslationHelper_tf.text;
      }
      
      public function onSelectionChanged(param1:CustomEvent) : *
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.visible = param1.params.onRollOver;
         if(param1.params.onRollOver)
         {
            this.InfoCardBackground_mc.visible = true;
            this.Locked_mc.visible = !param1.params.data.bAvailable;
            GlobalFunc.SetText(this.Locked_mc.LockedText_mc.text_tf,"$LOCKED");
            if(this.Locked_mc.visible)
            {
               TextFieldEx.setTextAutoSize(this.SkillDescriptionText_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               GlobalFunc.SetText(this.SkillDescriptionText_mc.text_tf,param1.params.data.sDescription);
               TextFieldEx.setTextAutoSize(this.RightPanelDescription_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               if(param1.params.data.uRequiredPurchasesToUnlock > 0 && param1.params.data.uSkillGroup > 1)
               {
                  _loc2_ = this.GetTranslatedCategoryText(param1.params.data.uCategory);
                  _loc3_ = this.GetTranslatedCategoryTierText(param1.params.data.uCategory,param1.params.data.uSkillGroup);
                  TextFieldEx.setTextAutoSize(this.RightPanelDescription_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
                  GlobalFunc.SetText(this.RightPanelDescription_tf,param1.params.data.uRequiredPurchasesToUnlock == 1 ? "$LOCKED_SKILL_TEXT_SINGLE" : "$LOCKED_SKILL_TEXT",false,false,0,false,0,[param1.params.data.uRequiredPurchasesToUnlock.toString(),_loc2_,_loc3_]);
               }
               else
               {
                  GlobalFunc.SetText(this.RightPanelDescription_tf,"");
               }
               this.SkillDescriptionText_mc.visible = true;
               this.ChallengeProgress_mc.visible = false;
            }
            else if(param1.params.data.RequirementsA.length > 0 || param1.params.data.uRank == param1.params.data.uRankCount)
            {
               this.SkillDescriptionText_mc.visible = false;
               this.ChallengeProgress_mc.visible = true;
               TextFieldEx.setTextAutoSize(this.ChallengeProgress_mc.ChallengeDesc_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               if(param1.params.data.uRank == param1.params.data.uRankCount)
               {
                  this.ChallengeProgress_mc.ProgressNum_mc.visible = false;
                  this.ChallengeProgress_mc.ProgressMeter_mc.visible = false;
                  GlobalFunc.SetText(this.ChallengeProgress_mc.ChallengeDesc_mc.text_tf,"$SkillMaxedOut");
               }
               else
               {
                  this.ChallengeProgress_mc.ProgressNum_mc.visible = true;
                  this.ChallengeProgress_mc.ProgressMeter_mc.visible = true;
                  GlobalFunc.SetText(this.ChallengeProgress_mc.ProgressNum_mc.text_tf,"(" + param1.params.data.RequirementsA[0].uCurrentRepetitions + "/" + param1.params.data.RequirementsA[0].uMaxRepetitions + ")");
                  GlobalFunc.SetText(this.ChallengeProgress_mc.ChallengeDesc_mc.text_tf,param1.params.data.RequirementsA[0].text);
                  this.ChallengeProgress_mc.ProgressMeter_mc.gotoAndStop(GlobalFunc.Lerp(101,1,param1.params.data.RequirementsA[0].fPercentComplete));
               }
            }
            else if(param1.params.data.sDescription.length > 0)
            {
               this.SkillDescriptionText_mc.visible = true;
               this.ChallengeProgress_mc.visible = false;
               TextFieldEx.setTextAutoSize(this.SkillDescriptionText_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               GlobalFunc.SetText(this.SkillDescriptionText_mc.text_tf,param1.params.data.sDescription);
            }
            else
            {
               this.SkillDescriptionText_mc.visible = false;
               this.ChallengeProgress_mc.visible = false;
            }
            this.CurrentRank_mc.visible = param1.params.data.bAvailable;
            if(this.CurrentRank_mc.visible)
            {
               TextFieldEx.setTextAutoSize(this.CurrentRank_mc.RankDesc_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               GlobalFunc.SetText(this.CurrentRank_mc.CurrentRankText_mc.text_tf,"$CURRENT_RANK");
               GlobalFunc.SetText(this.CurrentRank_mc.RankNum_mc.text_tf,"(" + param1.params.data.uRank + "/" + param1.params.data.uRankCount + ")");
               if(param1.params.data.uRank == 0)
               {
                  GlobalFunc.SetText(this.CurrentRank_mc.RankDesc_mc.text_tf,"$UNLOCK");
                  GlobalFunc.SetText(this.CurrentRank_mc.RankDesc_mc.text_tf,this.CurrentRank_mc.RankDesc_mc.text_tf.text + " " + param1.params.data.RankDataA[0].sDescription);
               }
               else
               {
                  GlobalFunc.SetText(this.CurrentRank_mc.RankDesc_mc.text_tf,param1.params.data.RankDataA[param1.params.data.uRank - 1].sDescription);
               }
            }
         }
      }
   }
}
