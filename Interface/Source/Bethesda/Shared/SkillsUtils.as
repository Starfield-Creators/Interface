package Shared
{
   public class SkillsUtils
   {
      
      public static const COMBAT:uint = EnumHelper.GetEnum(1);
      
      public static const SCIENCE:uint = EnumHelper.GetEnum();
      
      public static const TECH:uint = EnumHelper.GetEnum();
      
      public static const PHYSICAL:uint = EnumHelper.GetEnum();
      
      public static const SOCIAL:uint = EnumHelper.GetEnum();
      
      public static const SKILL_PATCH_TEXTURES_PATH:String = "Textures/Interface/SkillPatches/";
       
      
      public function SkillsUtils()
      {
         super();
      }
      
      public static function GetFullSkillPatchImageName(param1:String, param2:uint) : String
      {
         return SKILL_PATCH_TEXTURES_PATH + param1 + "_Full_Rank" + param2 + ".dds";
      }
      
      public static function GetFullDefaultSkillPatchName(param1:uint) : String
      {
         return "PatchFull_" + param1 + "_Default";
      }
   }
}
