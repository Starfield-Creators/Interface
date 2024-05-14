package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   
   public class InvCategory extends BSContainerEntry
   {
      
      private static var CharactersPerLine:int = 24;
       
      
      public var Count_mc:MovieClip;
      
      public var TypeIcon_mc:MovieClip;
      
      public var Title_mc:MovieClip;
      
      public var Subtitle_mc:MovieClip;
      
      public var iFilterFlag:int = -1;
      
      private var itemRarity:int;
      
      private var greyOutUnequipped:Boolean = false;
      
      public function InvCategory()
      {
         this.itemRarity = InventoryItemUtils.RARITY_STANDARD;
         super();
         Extensions.enabled = true;
         maxCharactersToDisplay = CharactersPerLine;
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         CharactersPerLine = param1 ? 26 : 24;
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Title_mc.Text_tf;
      }
      
      private function get Count_tf() : TextField
      {
         return this.Count_mc.Text_tf;
      }
      
      private function get Subtitle_tf() : TextField
      {
         return this.Subtitle_mc.Text_tf;
      }
      
      override public function get selectedFrameLabel() : String
      {
         var _loc1_:* = InventoryItemUtils.GetFrameLabelFromRarity(this.itemRarity) + "Selected";
         if(this.greyOutUnequipped)
         {
            _loc1_ += "Unequipped";
         }
         return _loc1_;
      }
      
      override public function get unselectedFrameLabel() : String
      {
         var _loc1_:* = InventoryItemUtils.GetFrameLabelFromRarity(this.itemRarity);
         if(this.greyOutUnequipped)
         {
            _loc1_ += "Unequipped";
         }
         return _loc1_;
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sName;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         this.TypeIcon_mc.gotoAndStop(this.GetIconFrameFromFilter(param1.iFilterFlags));
         GlobalFunc.SetText(this.Count_tf,(param1.uTotalItemCount - (!!param1.bHasGold ? 1 : 0)).toString());
         if(param1.bShowFeaturedItem)
         {
            if(param1.sFeaturedItemName.length == 0)
            {
               GlobalFunc.SetText(this.baseTextField,"$Category_NoFeaturedItem");
               this.greyOutUnequipped = true;
            }
            else
            {
               GlobalFunc.SetText(this.baseTextField,param1.sFeaturedItemName,false,false,CharactersPerLine);
               this.greyOutUnequipped = false;
            }
            GlobalFunc.SetText(this.Subtitle_tf,param1.sName,false,false,CharactersPerLine);
            this.itemRarity = param1.uFeaturedItemRarity;
         }
         else
         {
            GlobalFunc.SetText(this.Subtitle_tf,"");
            this.itemRarity = InventoryItemUtils.RARITY_STANDARD;
            this.greyOutUnequipped = false;
         }
         onRollout();
      }
      
      private function GetIconFrameFromFilter(param1:int) : String
      {
         var _loc2_:String = "Misc";
         if(param1 == InventoryItemUtils.ICF_NEW_ITEMS)
         {
            _loc2_ = "New";
         }
         else if(param1 == InventoryItemUtils.ICF_ALL)
         {
            _loc2_ = "All";
         }
         else if((param1 & InventoryItemUtils.ICF_WEAPONS) != 0)
         {
            _loc2_ = "Weapons";
         }
         else if((param1 & InventoryItemUtils.ICF_AMMO) != 0)
         {
            _loc2_ = "Ammo";
         }
         else if((param1 & InventoryItemUtils.ICF_SPACESUITS) != 0)
         {
            _loc2_ = "Spacesuits";
         }
         else if((param1 & InventoryItemUtils.ICF_BACKPACKS) != 0)
         {
            _loc2_ = "Packs";
         }
         else if((param1 & InventoryItemUtils.ICF_HELMETS) != 0)
         {
            _loc2_ = "Helmets";
         }
         else if((param1 & InventoryItemUtils.ICF_APPAREL) != 0)
         {
            _loc2_ = "Apparel";
         }
         else if((param1 & InventoryItemUtils.ICF_THROWABLES) != 0)
         {
            _loc2_ = "Throwables";
         }
         else if((param1 & InventoryItemUtils.ICF_AID) != 0)
         {
            _loc2_ = "Aid";
         }
         else if((param1 & InventoryItemUtils.ICF_NOTES) != 0)
         {
            _loc2_ = "Notes";
         }
         else if((param1 & InventoryItemUtils.ICF_RESOURCES) != 0)
         {
            _loc2_ = "Resources";
         }
         return _loc2_;
      }
   }
}
