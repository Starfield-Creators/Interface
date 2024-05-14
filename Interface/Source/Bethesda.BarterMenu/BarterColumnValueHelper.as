package
{
   import Shared.EnumHelper;
   import Shared.InventoryItemUtils;
   
   public class BarterColumnValueHelper
   {
      
      public static const VIEW_TYPE_WEAPON:int = EnumHelper.GetEnum(0);
      
      public static const VIEW_TYPE_THROWABLE:int = EnumHelper.GetEnum();
      
      public static const VIEW_TYPE_ARMOR:int = EnumHelper.GetEnum();
      
      public static const VIEW_TYPE_CONSUMABLE:int = EnumHelper.GetEnum();
      
      public static const VIEW_TYPE_MISC:int = EnumHelper.GetEnum();
      
      public static const VIEW_TYPE_COUNT:int = EnumHelper.GetEnum();
      
      private static var ColumnInfoByType:Array = new Array();
      
      private static var ColumnIndexesByType:Array = new Array();
       
      
      public function BarterColumnValueHelper()
      {
         super();
      }
      
      public static function InitHelper() : void
      {
         var _loc1_:uint = 0;
         if(ColumnInfoByType.length == 0)
         {
            ColumnInfoByType[VIEW_TYPE_WEAPON] = [{
               "headerText":"$InvCompareLabel_Value",
               "getSortValFunc":getItemValue,
               "displayValFunc":"DisplayItemVal",
               "sortType":InventoryItemUtils.SORT_VALUE
            },{
               "headerText":"$InvCompareLabel_Dmg",
               "getSortValFunc":getItemDamageVal,
               "displayValFunc":"DisplayWeaponDmg",
               "sortType":InventoryItemUtils.SORT_KEY_STAT
            },{
               "headerText":"$InvCompareLabel_Mass",
               "getSortValFunc":getItemMass,
               "displayValFunc":"DisplayItemMass",
               "sortType":InventoryItemUtils.SORT_WEIGHT
            },{
               "headerText":"$InvCompareLabel_Dmg",
               "getSortValFunc":getItemType,
               "displayValFunc":"DisplayWeaponDmg",
               "sortType":InventoryItemUtils.SORT_TYPE
            },{
               "headerText":"$InvCompareLabel_Ammo",
               "getSortValFunc":getItemAmmo,
               "displayValFunc":"DisplayItemAmmo",
               "sortType":InventoryItemUtils.SORT_AMMO
            }];
            ColumnInfoByType[VIEW_TYPE_THROWABLE] = [{
               "headerText":"$InvCompareLabel_Dmg",
               "getSortValFunc":getItemDamageVal,
               "displayValFunc":"DisplayWeaponDmg",
               "sortType":InventoryItemUtils.SORT_KEY_STAT
            },{
               "headerText":"$InvCompareLabel_Mass",
               "getSortValFunc":getItemMass,
               "displayValFunc":"DisplayItemMass",
               "sortType":InventoryItemUtils.SORT_WEIGHT
            },{
               "headerText":"$InvCompareLabel_Value",
               "getSortValFunc":getItemValue,
               "displayValFunc":"DisplayItemVal",
               "sortType":InventoryItemUtils.SORT_VALUE
            }];
            ColumnInfoByType[VIEW_TYPE_ARMOR] = [{
               "headerText":"$InvCompareLabel_Value",
               "getSortValFunc":getItemValue,
               "displayValFunc":"DisplayItemVal",
               "sortType":InventoryItemUtils.SORT_VALUE
            },{
               "headerText":"$InvCompareLabel_DR",
               "getSortValFunc":getItemArmorVal,
               "displayValFunc":"DisplayWeaponDR",
               "sortType":InventoryItemUtils.SORT_KEY_STAT
            },{
               "headerText":"$InvCompareLabel_Mass",
               "getSortValFunc":getItemMass,
               "displayValFunc":"DisplayItemMass",
               "sortType":InventoryItemUtils.SORT_WEIGHT
            }];
            ColumnInfoByType[VIEW_TYPE_CONSUMABLE] = [{
               "headerText":"$InvCompareLabel_Value",
               "getSortValFunc":getItemValue,
               "displayValFunc":"DisplayItemVal",
               "sortType":InventoryItemUtils.SORT_VALUE
            },{
               "headerText":"$InvCompareLabel_Mass",
               "getSortValFunc":getItemMass,
               "displayValFunc":"DisplayItemMass",
               "sortType":InventoryItemUtils.SORT_WEIGHT
            }];
            ColumnInfoByType[VIEW_TYPE_MISC] = [{
               "headerText":"$InvCompareLabel_Value",
               "getSortValFunc":getItemValue,
               "displayValFunc":"DisplayItemVal",
               "sortType":InventoryItemUtils.SORT_VALUE
            },{
               "headerText":"$InvCompareLabel_Mass",
               "getSortValFunc":getItemMass,
               "displayValFunc":"DisplayItemMass",
               "sortType":InventoryItemUtils.SORT_WEIGHT
            }];
         }
         if(ColumnIndexesByType.length == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < VIEW_TYPE_COUNT)
            {
               ColumnIndexesByType.push(0);
               _loc1_++;
            }
         }
      }
      
      public static function GetViewTypeFromFilterFlag(param1:int) : int
      {
         var _loc2_:int = VIEW_TYPE_MISC;
         switch(param1)
         {
            case InventoryItemUtils.ICF_WEAPONS:
               _loc2_ = VIEW_TYPE_WEAPON;
               break;
            case InventoryItemUtils.ICF_THROWABLES:
               _loc2_ = VIEW_TYPE_THROWABLE;
               break;
            case InventoryItemUtils.ICF_SPACESUITS:
            case InventoryItemUtils.ICF_BACKPACKS:
            case InventoryItemUtils.ICF_HELMETS:
            case InventoryItemUtils.ICF_APPAREL:
               _loc2_ = VIEW_TYPE_ARMOR;
               break;
            case InventoryItemUtils.ICF_AID:
               _loc2_ = VIEW_TYPE_CONSUMABLE;
         }
         return _loc2_;
      }
      
      public static function ResetColumnIndex(param1:int) : void
      {
         var _loc2_:int = GetViewTypeFromFilterFlag(param1);
         ColumnIndexesByType[_loc2_] = 0;
      }
      
      public static function SetColumnBySortType(param1:int, param2:int) : void
      {
         var _loc3_:int = GetViewTypeFromFilterFlag(param1);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < ColumnInfoByType[_loc3_].length)
         {
            if(ColumnInfoByType[_loc3_][_loc5_].sortType == param2)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         ColumnIndexesByType[_loc3_] = _loc4_;
      }
      
      public static function GetColumnHeaderString(param1:int) : String
      {
         var _loc2_:int = GetViewTypeFromFilterFlag(param1);
         var _loc3_:int = int(ColumnIndexesByType[_loc2_]);
         return ColumnInfoByType[_loc2_][_loc3_].headerText;
      }
      
      public static function GetColumnSortVal(param1:int, param2:Object) : Number
      {
         var _loc3_:int = GetViewTypeFromFilterFlag(param1);
         var _loc4_:int = int(ColumnIndexesByType[_loc3_]);
         return ColumnInfoByType[_loc3_][_loc4_].getSortValFunc(param2);
      }
      
      public static function GetColumnDisplayFuncName(param1:int) : String
      {
         var _loc2_:int = GetViewTypeFromFilterFlag(param1);
         var _loc3_:int = int(ColumnIndexesByType[_loc2_]);
         return ColumnInfoByType[_loc2_][_loc3_].displayValFunc;
      }
      
      private static function getItemMass(param1:Object) : Number
      {
         return param1.fWeight;
      }
      
      private static function getItemValue(param1:Object) : Number
      {
         return param1.uValue;
      }
      
      private static function getItemType(param1:Object) : Number
      {
         return param1.sBaseName;
      }
      
      private static function getItemAmmo(param1:Object) : Number
      {
         return param1.sAmmoType;
      }
      
      private static function getItemDamageVal(param1:Object) : Number
      {
         var _loc3_:* = undefined;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1.aElementalStats)
         {
            _loc2_ += _loc3_.fValue;
         }
         return _loc2_;
      }
      
      private static function getItemArmorVal(param1:Object) : Number
      {
         var _loc3_:* = undefined;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1.aElementalStats)
         {
            _loc2_ += _loc3_.fValue;
         }
         return _loc2_;
      }
   }
}
