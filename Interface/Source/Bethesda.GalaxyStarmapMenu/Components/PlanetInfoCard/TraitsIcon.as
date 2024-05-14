package Components.PlanetInfoCard
{
   import Shared.Components.ContentLoaders.LibraryLoader;
   import Shared.Components.ContentLoaders.LibraryLoaderConfig;
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TraitsIcon extends MovieClip
   {
      
      private static var TraitIconsLoader:LibraryLoader = null;
      
      private static const ICON_SIZE:int = 54;
      
      private static const NAMEPLATE_X_OFFSET:Number = 30;
      
      private static const NAMEPLATE_X_OFFSET_LRG:Number = 43;
      
      public static const TRAIT_UNKNOWN:int = EnumHelper.GetEnum(-1);
      
      public static const TRAIT_GRAVITATIONAL_ANOMALY:int = EnumHelper.GetEnum();
      
      public static const TRAIT_EXTINCTION_EVENT:int = EnumHelper.GetEnum();
      
      public static const TRAIT_TURBULENT_LITHOSPHERE:int = EnumHelper.GetEnum();
      
      public static const TRAIT_SONOROUS_LITHOSPHERE:int = EnumHelper.GetEnum();
      
      public static const TRAIT_SOLAR_STORM_SEASONS:int = EnumHelper.GetEnum();
      
      public static const TRAIT_SLUSHY_SUBSURFACE_SEAS:int = EnumHelper.GetEnum();
      
      public static const TRAIT_SENTIENT_MICROBIAL_COLONIES:int = EnumHelper.GetEnum();
      
      public static const TRAIT_PSYCHOTROPIC_BIOTA:int = EnumHelper.GetEnum();
      
      public static const TRAIT_PRISMATIC_PLUMES:int = EnumHelper.GetEnum();
      
      public static const TRAIT_PRIMED_FOR_LIFE:int = EnumHelper.GetEnum();
      
      public static const TRAIT_PELTED_FIELDS:int = EnumHelper.GetEnum();
      
      public static const TRAIT_GLOBAL_GLACIAL_RECESSION:int = EnumHelper.GetEnum();
      
      public static const TRAIT_FROZEN_ECOSYSTEM:int = EnumHelper.GetEnum();
      
      public static const TRAIT_EMERGING_TECHTONICS:int = EnumHelper.GetEnum();
      
      public static const TRAIT_ECOLOGICAL_CONSORTIUM:int = EnumHelper.GetEnum();
      
      public static const TRAIT_DISEASED_BIOSPHERE:int = EnumHelper.GetEnum();
      
      public static const TRAIT_CORALLINE_LANDMASS:int = EnumHelper.GetEnum();
      
      public static const TRAIT_CONTINUAL_CONDUCTOR:int = EnumHelper.GetEnum();
      
      public static const TRAIT_CHARRED_ECOSYSTEM:int = EnumHelper.GetEnum();
      
      public static const TRAIT_BOLIDE_BOMBARDMENT:int = EnumHelper.GetEnum();
      
      public static const TRAIT_AMPHIBIOUS_FOOTHOLD:int = EnumHelper.GetEnum();
      
      public static const TRAIT_AERIFORM_LIFE:int = EnumHelper.GetEnum();
      
      public static const TRAIT_CRYSTALLINE_CRUST:int = EnumHelper.GetEnum();
      
      public static const TRAIT_ENERGETIC_RIFTING:int = EnumHelper.GetEnum();
      
      public static const TRAIT_PRIMORDIAL_NETWORK:int = EnumHelper.GetEnum();
      
      public static const TRAIT_GASEOUS_FONT:int = EnumHelper.GetEnum();
      
      public static const TRAIT_BOILED_SEAS:int = EnumHelper.GetEnum();
       
      
      public var TraitDisplayName:String = "$UNKNOWN";
      
      public var TraitType:int;
      
      public var TraitsImage_mc:MovieClip;
      
      public var PlanetInfoHoverNameplate_mc:HoverNameplate;
      
      private var LoadTrait:Boolean = false;
      
      public function TraitsIcon()
      {
         this.TraitType = TRAIT_UNKNOWN;
         super();
         if(TraitIconsLoader == null)
         {
            TraitIconsLoader = new LibraryLoader(LibraryLoaderConfig.PLANET_TRAITS_LIBRARY_CONFIG);
         }
         TraitIconsLoader.addEventListener("PlanetTraitIconsLibrary_Loaded",this.OnTraitIconLibraryLoaded);
         addEventListener(MouseEvent.MOUSE_OVER,this.onHoverOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onHoverOff);
      }
      
      internal function get NameplateXOffset() : Number
      {
         return NAMEPLATE_X_OFFSET;
      }
      
      private function onHoverOver(param1:Event) : *
      {
         this.PlanetInfoHoverNameplate_mc.Open(this.TraitDisplayName,localToGlobal(new Point(0,0)),this.NameplateXOffset);
      }
      
      private function onHoverOff(param1:Event) : *
      {
         this.PlanetInfoHoverNameplate_mc.Close();
      }
      
      public function OnTraitIconLibraryLoaded(param1:Event) : *
      {
         if(this.LoadTrait)
         {
            this.LoadIcon(this.TraitDisplayName,this.TraitType);
         }
      }
      
      public function LoadIcon(param1:String, param2:int) : void
      {
         this.ClearTrait();
         this.TraitDisplayName = param1;
         this.TraitType = param2;
         var _loc3_:MovieClip = TraitIconsLoader.LoadClip(this.GetSymbolName(this.TraitType));
         if(_loc3_ != null)
         {
            this.TraitsImage_mc = _loc3_;
            this.TraitsImage_mc.width = this.TraitsImage_mc.height = ICON_SIZE;
            addChild(this.TraitsImage_mc);
            gotoAndStop("Discovered");
            this.LoadTrait = false;
         }
         else
         {
            this.LoadTrait = true;
         }
      }
      
      public function ClearTrait() : *
      {
         if(this.TraitsImage_mc != null)
         {
            removeChild(this.TraitsImage_mc);
            this.TraitsImage_mc = null;
            this.TraitDisplayName = "$UNKNOWN";
            gotoAndStop("Unknown");
         }
      }
      
      public function GetSymbolName(param1:int) : *
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case TRAIT_UNKNOWN:
               break;
            case TRAIT_GRAVITATIONAL_ANOMALY:
               _loc2_ = "GravitationalAnomaly";
               break;
            case TRAIT_EXTINCTION_EVENT:
               _loc2_ = "ExtinctionEvent";
               break;
            case TRAIT_TURBULENT_LITHOSPHERE:
               _loc2_ = "TurbulentLithosphere";
               break;
            case TRAIT_SONOROUS_LITHOSPHERE:
               _loc2_ = "SonorousLithosphere";
               break;
            case TRAIT_SOLAR_STORM_SEASONS:
               _loc2_ = "SolarStormSeasons";
               break;
            case TRAIT_SLUSHY_SUBSURFACE_SEAS:
               _loc2_ = "SlushySubsurfaceSeas";
               break;
            case TRAIT_SENTIENT_MICROBIAL_COLONIES:
               _loc2_ = "SentientMicrobialColonies";
               break;
            case TRAIT_PSYCHOTROPIC_BIOTA:
               _loc2_ = "PsychotropicBiota";
               break;
            case TRAIT_PRISMATIC_PLUMES:
               _loc2_ = "PrismaticPlumes";
               break;
            case TRAIT_PRIMED_FOR_LIFE:
               _loc2_ = "PrimedForLife";
               break;
            case TRAIT_PELTED_FIELDS:
               _loc2_ = "PeltedFields";
               break;
            case TRAIT_GLOBAL_GLACIAL_RECESSION:
               _loc2_ = "GlobalGlacialRecession";
               break;
            case TRAIT_FROZEN_ECOSYSTEM:
               _loc2_ = "FrozenEcosystem";
               break;
            case TRAIT_EMERGING_TECHTONICS:
               _loc2_ = "EmergingTectonics";
               break;
            case TRAIT_ECOLOGICAL_CONSORTIUM:
               _loc2_ = "EcologicalConsortium";
               break;
            case TRAIT_DISEASED_BIOSPHERE:
               _loc2_ = "DiseasedBiosphere";
               break;
            case TRAIT_CORALLINE_LANDMASS:
               _loc2_ = "CorallineLandmass";
               break;
            case TRAIT_CONTINUAL_CONDUCTOR:
               _loc2_ = "ContinualConductor";
               break;
            case TRAIT_CHARRED_ECOSYSTEM:
               _loc2_ = "CharredEcosystem";
               break;
            case TRAIT_BOLIDE_BOMBARDMENT:
               _loc2_ = "BolideBombardment";
               break;
            case TRAIT_AMPHIBIOUS_FOOTHOLD:
               _loc2_ = "AmphibiousFoothold";
               break;
            case TRAIT_AERIFORM_LIFE:
               _loc2_ = "AeriformLife";
               break;
            case TRAIT_CRYSTALLINE_CRUST:
               _loc2_ = "CrystallineCrust";
               break;
            case TRAIT_ENERGETIC_RIFTING:
               _loc2_ = "EnergeticRifting";
               break;
            case TRAIT_PRIMORDIAL_NETWORK:
               _loc2_ = "PrimordialNetwork";
               break;
            case TRAIT_GASEOUS_FONT:
               _loc2_ = "GaseousFont";
               break;
            case TRAIT_BOILED_SEAS:
               _loc2_ = "BoiledSeas";
               break;
            default:
               GlobalFunc.TraceWarning("Unknown trait type given: " + param1);
         }
         return _loc2_;
      }
   }
}
