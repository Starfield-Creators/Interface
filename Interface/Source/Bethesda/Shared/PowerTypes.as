package Shared
{
   public class PowerTypes
   {
      
      public static const ARTIFACT_POWER_ALIEN_REANIM:String = "ArtifactPower_AlienReanim";
      
      public static const ARTIFACT_POWER_ANTI_GRAVITY_FIELD:String = "ArtifactPower_AntiGravityField";
      
      public static const ARTIFACT_POWER_CREATE_VACUUM:String = "ArtifactPower_CreateVacuum";
      
      public static const ARTIFACT_POWER_CREATORS_PEACE:String = "ArtifactPower_CreatorsPeace";
      
      public static const ARTIFACT_POWER_EARTH_BOUND:String = "ArtifactPower_Earthbound";
      
      public static const ARTIFACT_POWER_ELEMENTAL_BLAST:String = "ArtifactPower_ElementalBlast";
      
      public static const ARTIFACT_POWER_ETERNAL_HARVEST:String = "ArtifactPower_EternalHarvest";
      
      public static const ARTIFACT_POWER_GRAV_DASH:String = "ArtifactPower_GravDash";
      
      public static const ARTIFACT_POWER_GRAV_WAVE:String = "ArtifactPower_GravWave";
      
      public static const ARTIFACT_POWER_GRAV_WELL:String = "ArtifactPower_GravWell";
      
      public static const ARTIFACT_POWER_INNER_DEMON:String = "ArtifactPower_InnerDemon";
      
      public static const ARTIFACT_POWER_LIFE_FORCED:String = "ArtifactPower_LifeForced";
      
      public static const ARTIFACT_POWER_MOON_FORM:String = "ArtifactPower_MoonForm";
      
      public static const ARTIFACT_POWER_PARALLEL_SELF:String = "ArtifactPower_ParallelSelf";
      
      public static const ARTIFACT_POWER_PARTICLE_BEAM:String = "ArtifactPower_ParticleBeam";
      
      public static const ARTIFACT_POWER_PERSONAL_ATMO:String = "ArtifactPower_PersonalAtmo";
      
      public static const ARTIFACT_POWER_PHASED_TIME:String = "ArtifactPower_PhasedTime";
      
      public static const ARTIFACT_POWER_PRECOGNITION:String = "ArtifactPower_Precognition";
      
      public static const ARTIFACT_POWER_REACTIVE_SHIELD:String = "ArtifactPower_ReactiveShield";
      
      public static const ARTIFACT_POWER_SENSE_STAR_STUFF:String = "ArtifactPower_SenseStarStuff";
      
      public static const ARTIFACT_POWER_SOLAR_FLARE:String = "ArtifactPower_SolarFlare";
      
      public static const ARTIFACT_POWER_SUNLESS_SPACE:String = "ArtifactPower_SunlessSpace";
      
      public static const ARTIFACT_POWER_SUPER_NOVA:String = "ArtifactPower_Supernova";
      
      public static const ARTIFACT_POWER_VOID_FORM:String = "ArtifactPower_VoidForm";
       
      
      public function PowerTypes()
      {
         super();
      }
      
      public static function IsArtifactPower(param1:String) : Boolean
      {
         switch(param1)
         {
            case PowerTypes.ARTIFACT_POWER_ALIEN_REANIM:
            case PowerTypes.ARTIFACT_POWER_ANTI_GRAVITY_FIELD:
            case PowerTypes.ARTIFACT_POWER_CREATE_VACUUM:
            case PowerTypes.ARTIFACT_POWER_CREATORS_PEACE:
            case PowerTypes.ARTIFACT_POWER_EARTH_BOUND:
            case PowerTypes.ARTIFACT_POWER_ELEMENTAL_BLAST:
            case PowerTypes.ARTIFACT_POWER_ETERNAL_HARVEST:
            case PowerTypes.ARTIFACT_POWER_GRAV_DASH:
            case PowerTypes.ARTIFACT_POWER_GRAV_WAVE:
            case PowerTypes.ARTIFACT_POWER_GRAV_WELL:
            case PowerTypes.ARTIFACT_POWER_INNER_DEMON:
            case PowerTypes.ARTIFACT_POWER_LIFE_FORCED:
            case PowerTypes.ARTIFACT_POWER_MOON_FORM:
            case PowerTypes.ARTIFACT_POWER_PARALLEL_SELF:
            case PowerTypes.ARTIFACT_POWER_PARTICLE_BEAM:
            case PowerTypes.ARTIFACT_POWER_PERSONAL_ATMO:
            case PowerTypes.ARTIFACT_POWER_PHASED_TIME:
            case PowerTypes.ARTIFACT_POWER_PRECOGNITION:
            case PowerTypes.ARTIFACT_POWER_REACTIVE_SHIELD:
            case PowerTypes.ARTIFACT_POWER_SENSE_STAR_STUFF:
            case PowerTypes.ARTIFACT_POWER_SOLAR_FLARE:
            case PowerTypes.ARTIFACT_POWER_SUNLESS_SPACE:
            case PowerTypes.ARTIFACT_POWER_SUPER_NOVA:
            case PowerTypes.ARTIFACT_POWER_VOID_FORM:
               return true;
            default:
               return false;
         }
      }
   }
}
