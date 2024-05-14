package Shared
{
   public class BSGalaxyTypes
   {
      
      public static const BT_UNDEFINED:uint = 0;
      
      public static const BT_STAR:uint = 1;
      
      public static const BT_PLANET:uint = 2;
      
      public static const BT_MOON:uint = 3;
      
      public static const BT_SATELLITE:uint = 4;
      
      public static const BT_ASTEROID_BELT:uint = 5;
      
      public static const BT_STATION:uint = 6;
      
      private static const BodyLabelsA:* = ["$Unknown Type","$Star","$Planet","$Moon","$Satellite","$Asteroid Belt","$Station"];
      
      public static const RS_COMMON:uint = 0;
      
      public static const RS_UNCOMMON:uint = 1;
      
      public static const RS_RARE:uint = 2;
      
      public static const RS_EXOTIC:uint = 3;
      
      public static const SCARCITY_COUNT:uint = 4;
      
      private static const ScarcityLabelsA:* = ["$Common","$Uncommon","$Rare","$Exotic","$Unique","$Unknown Type"];
      
      public static const SL_NOT_SCANNED:int = -1;
      
      public static const SL_MINIMAL:int = 0;
      
      public static const SL_BASIC:int = 1;
      
      public static const SL_ADVANCED:int = 2;
      
      public static const SL_COMPLETE:int = 3;
       
      
      public function BSGalaxyTypes()
      {
         super();
      }
      
      public static function GetBodyTypeLabel(param1:uint) : String
      {
         if(param1 > BT_STATION)
         {
            param1 = 0;
         }
         return BodyLabelsA[param1];
      }
      
      public static function GetScarcityLabel(param1:uint) : String
      {
         if(param1 >= ScarcityLabelsA.length - 1)
         {
            param1 = ScarcityLabelsA.length - 1;
         }
         return ScarcityLabelsA[param1];
      }
   }
}
