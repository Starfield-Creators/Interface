package
{
   import Shared.EnumHelper;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   
   public class CraftingUtils
   {
      
      public static const CREATE_BUTTON_HIT:String = "CreateButton_Hit";
      
      public static const CONFIRM_POPUP_ACCEPT:String = "ConfirmationPopup_Accept";
      
      public static const CONFIRM_POPUP_CANCEL:String = "ConfirmationPopup_Cancel";
      
      public static const PLAY_ROLL_ON_ANIMS:String = "PlayRollOnAnims";
      
      public static const ROLL_ON_FINISHED:String = "RollOnFinished";
      
      public static const EXIT_BENCH_ANIMATION:String = "ExitBenchAnimation";
      
      public static const NO_STATE:int = EnumHelper.GetEnum(-1);
      
      public static const INVENTORY_STATE:int = EnumHelper.GetEnum();
      
      public static const SLOTS_STATE:int = EnumHelper.GetEnum();
      
      public static const MODS_STATE:int = EnumHelper.GetEnum();
      
      public static const CONFIRMING_STATE:int = EnumHelper.GetEnum();
      
      public static const BUTTON_SPACING:uint = 10;
      
      public static const LIST_SPACING:uint = 3;
      
      public static const PRECISION:Number = 1;
      
      public static const FADED_DIRECTORY:Number = 0.2;
      
      public static const FADED_SKILL:Number = 0.5;
      
      public static const CRAFTING_IMAGE_BUFFER:String = "CraftingIconTextureBuffer";
      
      public static const DRUGS_COLOR:uint = 12040119;
      
      public static const DRUGS_SECONDARY_COLOR:uint = 6842990;
      
      public static const FOOD_COLOR:uint = 4231254;
      
      public static const FOOD_SECONDARY_COLOR:uint = 2113577;
      
      public static const WEAPONS_COLOR:uint = 11752748;
      
      public static const ARMOR_COLOR:uint = 9804155;
      
      public static const INDUSTRIAL_COLOR:uint = 2467002;
      
      public static const INDUSTRIAL_SECONDARY_COLOR:uint = 1333862;
      
      public static const SELECTED_TEXT_COLOR_DARK:uint = 790813;
      
      public static const SELECTED_TEXT_COLOR_LIGHT:uint = 16777215;
      
      public static const EXIT_BENCH_EVENT:String = "CraftingMenu_ExitBench";
      
      public static const SELECTED_RECIPE_EVENT:String = "CraftingMenu_SelectedRecipe";
      
      public static const CRAFT_ITEM_EVENT:String = "CraftingMenu_CraftItem";
      
      public static const INSTALL_MOD_EVENT:String = "CraftingMenu_InstallMod";
      
      public static const VIEW_MOD_ITEM_EVENT:String = "CraftingMenu_ViewingModdableItem";
      
      public static const SELECT_MOD_ITEM_EVENT:String = "CraftingMenu_SelectedModdableItem";
      
      public static const SELECT_MODSLOT_EVENT:String = "CraftingMenu_SelectedModSlot";
      
      public static const SELECT_MOD_EVENT:String = "CraftingMenu_SelectedMod";
      
      public static const REVERT_MOD_EVENT:String = "CraftingMenu_RevertedModdedItem";
      
      public static const HIGHLIGHT_3D_EVENT:String = "CraftingMenu_Highlight3D";
      
      public static const REVERT_HIGHLIGHT_EVENT:String = "CraftingMenu_RevertHighlight";
      
      public static const SET_INSPECT_CONTROLS_EVENT:String = "CraftingMenu_SetInspectControls";
      
      public static const RENAME_ITEM_EVENT:String = "CraftingMenu_RenameItem";
      
      public static const TOGGLE_TRACKING_EVENT:String = "CraftingMenu_ToggleTracking";
       
      
      public function CraftingUtils()
      {
         super();
      }
      
      public static function PopulateCardDamageClips(param1:Object, param2:Object, param3:Array) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc4_:* = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:uint = 0;
         while(_loc6_ < InventoryItemUtils.ET_ITEM_CARD_COUNT)
         {
            _loc7_ = 0;
            _loc8_ = uint(InventoryItemUtils.GetElementByItemCardSortOrder(_loc6_));
            _loc9_ = 0;
            while(_loc9_ < param1.length)
            {
               if(param1[_loc9_].iElementalType == _loc8_)
               {
                  _loc7_ = Number(param1[_loc9_].fValue);
                  break;
               }
               _loc9_++;
            }
            if((_loc5_ = param3[_loc4_]) != null)
            {
               if(_loc7_ > 0)
               {
                  _loc4_++;
                  _loc5_.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(_loc8_));
                  _loc5_.Stat_mc.SetData(InventoryItemUtils.GetElementalLocString(_loc8_),_loc7_.toFixed(CraftingUtils.PRECISION),param2[InventoryItemUtils.GetElementByItemCardSortOrder(_loc8_)]);
                  _loc5_.visible = true;
               }
               else if(param1.length == 0 && _loc8_ == InventoryItemUtils.ET_PHYSICAL)
               {
                  _loc4_++;
                  _loc5_.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(InventoryItemUtils.ET_PHYSICAL));
                  _loc5_.Stat_mc.SetData(InventoryItemUtils.GetElementalLocString(InventoryItemUtils.ET_PHYSICAL),"--",0);
                  _loc5_.visible = true;
               }
            }
            _loc6_++;
         }
         while(_loc4_ < InventoryItemUtils.ET_ITEM_CARD_COUNT)
         {
            if((_loc5_ = param3[_loc4_]) != null)
            {
               _loc5_.visible = false;
            }
            _loc4_++;
         }
      }
      
      public static function PopulateDirectoryDamageClips(param1:Object, param2:Array) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc3_:* = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         while(_loc5_ < InventoryItemUtils.ET_ITEM_CARD_COUNT)
         {
            _loc6_ = 0;
            _loc7_ = uint(InventoryItemUtils.GetElementByItemCardSortOrder(_loc5_));
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               if(param1[_loc8_].iElementalType == _loc7_)
               {
                  _loc6_ = Number(param1[_loc8_].fValue);
                  break;
               }
               _loc8_++;
            }
            if((_loc4_ = param2[_loc3_]) != null)
            {
               if(_loc6_ > 0)
               {
                  _loc3_++;
                  GlobalFunc.SetText(_loc4_.Value_mc.Text_tf,_loc6_.toFixed(0));
                  _loc4_.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(_loc7_));
                  _loc4_.visible = true;
               }
               else if(param1.length == 0 && _loc7_ == InventoryItemUtils.ET_PHYSICAL)
               {
                  _loc3_++;
                  GlobalFunc.SetText(_loc4_.Value_mc.Text_tf,"--");
                  _loc4_.Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(InventoryItemUtils.ET_PHYSICAL));
                  _loc4_.visible = true;
               }
            }
            _loc5_++;
         }
         while(_loc3_ < InventoryItemUtils.ET_ITEM_CARD_COUNT)
         {
            if((_loc4_ = param2[_loc3_]) != null)
            {
               _loc4_.visible = false;
            }
            _loc3_++;
         }
      }
   }
}
