package
{
   import Components.ImageFixture;
   import Shared.Components.ContentLoaders.LibraryLoader;
   import Shared.GlobalFunc;
   import Shared.SkillsUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BackgroundSkill extends MovieClip
   {
       
      
      public var SkillsDesc_mc:MovieClip;
      
      public var SkillsName_mc:MovieClip;
      
      public var BonusSkillImage_mc:ImageFixture;
      
      private var SkillsName_tf:TextField;
      
      private var SkillsDesc_tf:TextField;
      
      private var SkillPatchLibraryLoader:LibraryLoader = null;
      
      public function BackgroundSkill()
      {
         super();
         Extensions.enabled = true;
         this.SkillsName_tf = this.SkillsName_mc.text_tf;
         TextFieldEx.setTextAutoSize(this.SkillsName_tf,"shrink");
         this.SkillsDesc_tf = this.SkillsDesc_mc.text_tf;
         TextFieldEx.setTextAutoSize(this.SkillsDesc_tf,"shrink");
         this.BonusSkillImage_mc.centerClip = true;
      }
      
      public function SetLibraryLoader(param1:LibraryLoader) : *
      {
         this.SkillPatchLibraryLoader = param1;
      }
      
      public function BackgroundSkillInfo(param1:Object = null) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            GlobalFunc.SetText(this.SkillsName_tf,"");
            GlobalFunc.SetText(this.SkillsDesc_tf,"");
            this.BonusSkillImage_mc.Unload();
         }
         else
         {
            GlobalFunc.SetText(this.SkillsName_tf,param1.sName,false,true);
            GlobalFunc.SetText(this.SkillsDesc_tf,param1.sDescription);
            _loc2_ = "";
            switch(param1.uCategory)
            {
               case 1:
                  _loc2_ = "$COMBAT";
                  break;
               case 2:
                  _loc2_ = "$SCIENCE";
                  break;
               case 3:
                  _loc2_ = "$TECH";
                  break;
               case 4:
                  _loc2_ = "$PHYSICAL";
                  break;
               case 5:
                  _loc2_ = "$SOCIAL";
            }
            if(this.SkillPatchLibraryLoader != null)
            {
               this.BonusSkillImage_mc.errorClassName = SkillsUtils.GetFullDefaultSkillPatchName(param1.uCategory);
               this.BonusSkillImage_mc.LoadInternal(SkillsUtils.GetFullSkillPatchImageName(param1.sArtName,1),"ChargenBackgroundSkillsBuffer");
            }
         }
      }
   }
}
