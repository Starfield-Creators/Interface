package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ResearchSkillsSection extends MovieClip
   {
       
      
      public var Header_mc:MovieClip;
      
      public var Skill0_mc:ProjectSkillRequirement;
      
      public var Skill1_mc:ProjectSkillRequirement;
      
      public var NoSkills_mc:MovieClip;
      
      private const MAX_SKILLS:uint = 2;
      
      public function ResearchSkillsSection()
      {
         super();
         GlobalFunc.SetText(this.Header_mc.Text_tf,"$RequiredSkills");
      }
      
      public function UpdateSkills(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = 0;
         while(_loc2_ < this.MAX_SKILLS && _loc2_ < param1.length)
         {
            _loc3_ = this.GetSkillClip(_loc2_);
            _loc3_.LoadClip(param1[_loc2_]);
            _loc3_.visible = true;
            _loc2_++;
         }
         while(_loc2_ < this.MAX_SKILLS)
         {
            _loc3_ = this.GetSkillClip(_loc2_);
            _loc3_.visible = false;
            _loc2_++;
         }
         this.NoSkills_mc.visible = param1.length == 0;
      }
      
      public function HideSkills() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.MAX_SKILLS)
         {
            _loc2_ = this.GetSkillClip(_loc1_);
            _loc2_.visible = false;
            _loc1_++;
         }
         this.NoSkills_mc.visible = true;
      }
      
      private function GetSkillClip(param1:uint) : ProjectSkillRequirement
      {
         return this["Skill" + param1 + "_mc"];
      }
   }
}
