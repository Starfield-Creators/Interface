package Shared
{
   import flash.text.TextField;
   
   public class InventoryItemUtils
   {
      
      public static const IIT_WEAPON:int = EnumHelper.GetEnum(0);
      
      public static const IIT_ARMOR:int = EnumHelper.GetEnum();
      
      public static const IIT_CONSUMABLE:int = EnumHelper.GetEnum();
      
      public static const IIT_SPELL:int = EnumHelper.GetEnum();
      
      public static const IIT_MISC:int = EnumHelper.GetEnum();
      
      public static const IIT_COUNT:int = EnumHelper.GetEnum();
      
      public static const ET_PHYSICAL:int = EnumHelper.GetEnum(0);
      
      public static const ET_ELECTRIC:int = EnumHelper.GetEnum();
      
      public static const ET_ELECTROMAGNETIC:int = EnumHelper.GetEnum();
      
      public static const ET_ENERGY:int = EnumHelper.GetEnum();
      
      public static const ET_COUNT:int = EnumHelper.GetEnum();
      
      public static const ET_ITEM_CARD_COUNT:int = ET_COUNT - 1;
      
      public static const ICF_NONE:int = 0;
      
      public static const ICF_NEW_ITEMS:int = 1 << EnumHelper.GetEnum(0);
      
      public static const ICF_WEAPONS:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_AMMO:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_SPACESUITS:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_BACKPACKS:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_HELMETS:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_APPAREL:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_THROWABLES:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_AID:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_NOTES:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_RESOURCES:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_SPELLS:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_MISC:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_FAVORITES:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_BUY_BACK:int = 1 << EnumHelper.GetEnum();
      
      public static const ICF_COUNT:int = EnumHelper.GetEnum();
      
      public static const ICF_ALL:int = 4294967295;
      
      public static const ICF_ALL_BUT_SPELLS:* = ICF_ALL ^ ICF_SPELLS;
      
      public static const CM_NONE:* = 0;
      
      public static const CM_GIVE_ITEMS:* = 1 << 0;
      
      public static const CM_TAKE_ITEMS:* = 1 << 1;
      
      public static const CM_BOTH:* = CM_GIVE_ITEMS | CM_TAKE_ITEMS;
      
      public static const RARITY_STANDARD:int = EnumHelper.GetEnum(0);
      
      public static const RARITY_RARE:int = EnumHelper.GetEnum();
      
      public static const RARITY_EPIC:int = EnumHelper.GetEnum();
      
      public static const RARITY_LEGENDARY:int = EnumHelper.GetEnum();
      
      public static const TYPE_NAME_WEAPON:String = "weapon";
      
      public static const TYPE_NAME_ARMOR:String = "armor";
      
      public static const TYPE_NAME_CONSUMABLE:String = "consumable";
      
      public static const TYPE_NAME_MISC:String = "misc";
      
      public static const SORT_NONE:int = EnumHelper.GetEnum(0);
      
      public static const SORT_NAME:int = EnumHelper.GetEnum();
      
      public static const SORT_KEY_STAT:int = EnumHelper.GetEnum();
      
      public static const SORT_VALUE:int = EnumHelper.GetEnum();
      
      public static const SORT_WEIGHT:int = EnumHelper.GetEnum();
      
      public static const SORT_TYPE:int = EnumHelper.GetEnum();
      
      public static const SORT_AMMO:int = EnumHelper.GetEnum();
       
      
      public function InventoryItemUtils()
      {
         super();
      }
      
      public static function GetTypeName(param1:int) : String
      {
         switch(param1)
         {
            case IIT_WEAPON:
               return TYPE_NAME_WEAPON;
            case IIT_ARMOR:
               return TYPE_NAME_ARMOR;
            case IIT_CONSUMABLE:
               return TYPE_NAME_CONSUMABLE;
            case IIT_MISC:
            default:
               return TYPE_NAME_MISC;
         }
      }
      
      public static function GetElementalLocString(param1:int) : String
      {
         switch(param1)
         {
            case ET_PHYSICAL:
               return "$ABBREVIATED_PHYSICAL";
            case ET_ELECTRIC:
               return "$ABBREVIATED_ELECTRIC";
            case ET_ELECTROMAGNETIC:
               return "$ABBREVIATED_ELECTROMAGNETIC";
            case ET_ENERGY:
               return "$ABBREVIATED_ENERGY";
            default:
               return "[invalid]";
         }
      }
      
      public static function GetElementalLabel(param1:int) : String
      {
         switch(param1)
         {
            case ET_PHYSICAL:
               return "physical";
            case ET_ELECTROMAGNETIC:
               return "em";
            case ET_ENERGY:
               return "energy";
            default:
               return "[invalid]";
         }
      }
      
      public static function GetElementByItemCardSortOrder(param1:int) : int
      {
         switch(param1)
         {
            case 0:
               return ET_PHYSICAL;
            case 1:
               return ET_ENERGY;
            case 2:
               return ET_ELECTROMAGNETIC;
            default:
               return ET_ELECTRIC;
         }
      }
      
      public static function GetElementItemCardSortOrder(param1:int) : int
      {
         switch(param1)
         {
            case ET_PHYSICAL:
               return 0;
            case ET_ENERGY:
               return 1;
            case ET_ELECTROMAGNETIC:
               return 2;
            default:
               return 3;
         }
      }
      
      public static function GetFrameLabelFromRarity(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case InventoryItemUtils.RARITY_RARE:
               _loc2_ = "Rare";
               break;
            case InventoryItemUtils.RARITY_EPIC:
               _loc2_ = "Epic";
               break;
            case InventoryItemUtils.RARITY_LEGENDARY:
               _loc2_ = "Legendary";
               break;
            default:
               _loc2_ = "Normal";
         }
         return _loc2_;
      }
      
      public static function CreateCompareArrayForElemStats(param1:Object, param2:Object) : Array
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:Array = new Array();
         var _loc4_:uint = 0;
         while(_loc4_ < InventoryItemUtils.ET_COUNT)
         {
            _loc3_[_loc4_] = 0;
            _loc4_++;
         }
         for each(_loc5_ in param1.aElementalStats)
         {
            _loc3_[GetElementItemCardSortOrder(_loc5_.iElementalType)] = _loc5_.fValue;
         }
         if(param2 != null)
         {
            for each(_loc6_ in param2.aElementalStats)
            {
               _loc3_[GetElementItemCardSortOrder(_loc6_.iElementalType)] = _loc3_[GetElementItemCardSortOrder(_loc6_.iElementalType)] - _loc6_.fValue;
            }
         }
         return _loc3_;
      }
      
      public static function RetrieveModsToDisplay(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = new Array();
         if(param1 != null)
         {
            for each(_loc3_ in param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function GetNonLegendaryModCount(param1:Array) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            for each(_loc3_ in param1)
            {
               if(!_loc3_.bLegendary)
               {
                  _loc2_++;
               }
            }
         }
         return _loc2_;
      }
      
      public static function BuildModDescriptionString(param1:Array, param2:TextField = null) : String
      {
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:* = "";
         var _loc4_:Array = new Array();
         if(param1 != null)
         {
            for each(_loc6_ in param1)
            {
               if(_loc6_.bLegendary)
               {
                  if(_loc3_.length > 0)
                  {
                     _loc3_ += "\n\n";
                  }
                  _loc3_ += _loc6_.sName;
                  _loc3_ += ": " + _loc6_.sDescription;
               }
               else
               {
                  _loc4_.push("• " + _loc6_.sName);
               }
            }
         }
         var _loc5_:* = _loc3_;
         if(_loc4_.length > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc5_ += "\n\n";
            }
            _loc7_ = 0;
            if(param2)
            {
               GlobalFunc.SetText(param2,_loc5_);
               _loc8_ = param2.getLineMetrics(0);
               _loc9_ = (param2.height - param2.textHeight) / _loc8_.height;
               if((_loc10_ = (param2.height - param2.textHeight) / _loc8_.height) < _loc4_.length)
               {
                  _loc10_--;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc4_.length && _loc7_ < _loc10_)
               {
                  if(_loc7_ > 0)
                  {
                     _loc5_ += "\n";
                  }
                  _loc5_ += _loc4_[_loc7_];
                  _loc7_++;
               }
               if((_loc11_ = _loc4_.length - _loc7_) == 1)
               {
                  _loc5_ += "\n- 1 Additional $$Mod";
               }
               else if(_loc11_ > 0)
               {
                  _loc5_ += "\n- " + String(_loc11_) + " Additional $$Mods";
               }
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_.length)
               {
                  if(_loc7_ > 0)
                  {
                     _loc5_ += "\n";
                  }
                  _loc5_ += _loc4_[_loc7_];
                  _loc7_++;
               }
            }
         }
         return _loc5_;
      }
   }
}
