package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ExplorationEntry extends MovieClip
   {
      
      public static const EXPLORATION_TYPE_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const EXPLORATION_TYPE_STAR_SYSTEMS_VISITED:uint = EnumHelper.GetEnum();
      
      public static const EXPLORATION_TYPE_PLANETS_MOONS_SCANNED:uint = EnumHelper.GetEnum();
      
      public static const EXPLORATION_TYPE_PLANETS_MOON_EXPLORED:uint = EnumHelper.GetEnum();
      
      public static const EXPLORATION_TYPE_ORGANICS_SCANNED:uint = EnumHelper.GetEnum();
       
      
      public var Name_mc:MovieClip;
      
      public var Stats_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      private const STAR_SYSTEM_VISITED_LABEL:String = "StarSystemsVisited";
      
      private const PLANETS_MOONS_SCANNED_LABEL:String = "PlanetMoonsScanned";
      
      private const PLANETS_MOONS_EXPLORED_LABEL:String = "PlanetsMoonsExplored";
      
      private const ORGANICS_SCANNED_LABEL:String = "OrganicsScanned";
      
      public function ExplorationEntry()
      {
         super();
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function get Stats_tf() : TextField
      {
         return this.Stats_mc.Text_tf;
      }
      
      public function SetEntry(param1:Object) : *
      {
         GlobalFunc.SetText(this.Name_tf,param1.sText);
         GlobalFunc.SetText(this.Stats_tf,param1.uCount);
         switch(param1.uType)
         {
            case EXPLORATION_TYPE_STAR_SYSTEMS_VISITED:
               this.Icon_mc.gotoAndStop(this.STAR_SYSTEM_VISITED_LABEL);
               break;
            case EXPLORATION_TYPE_PLANETS_MOONS_SCANNED:
               this.Icon_mc.gotoAndStop(this.PLANETS_MOONS_SCANNED_LABEL);
               break;
            case EXPLORATION_TYPE_PLANETS_MOON_EXPLORED:
               this.Icon_mc.gotoAndStop(this.PLANETS_MOONS_EXPLORED_LABEL);
               break;
            case EXPLORATION_TYPE_ORGANICS_SCANNED:
               this.Icon_mc.gotoAndStop(this.ORGANICS_SCANNED_LABEL);
         }
      }
   }
}
