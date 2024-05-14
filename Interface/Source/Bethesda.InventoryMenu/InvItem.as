package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class InvItem extends BSContainerEntry
   {
      
      public static var LargeTextMode:Boolean = false;
      
      public static var CurrFilter:int = InventoryItemUtils.ICF_ALL;
       
      
      public var Name_mc:MovieClip;
      
      public var Count_mc:MovieClip;
      
      public var EquippedIcon_mc:MovieClip;
      
      public var NewItem_mc:MovieClip;
      
      public var ContrabandIcon_mc:MovieClip;
      
      public var StolenIcon_mc:MovieClip;
      
      public var FavoriteIcon_mc:MovieClip;
      
      public var DMGIcons_mc:MovieClip;
      
      public var CompareValue_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      private var itemRarity:int;
      
      public function InvItem()
      {
         this.itemRarity = InventoryItemUtils.RARITY_STANDARD;
         super();
         Extensions.enabled = true;
         if(!LargeTextMode)
         {
            TextFieldEx.setTextAutoSize(this.Count_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.Compare_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         maxCharactersToDisplay = LargeTextMode ? 21 : 22;
         twoLineText = true;
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         LargeTextMode = param1;
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      private function get Count_tf() : TextField
      {
         return this.Count_mc.Text_tf;
      }
      
      private function get Compare_tf() : TextField
      {
         return this.CompareValue_mc.Text_tf;
      }
      
      override public function get selectedFrameLabel() : String
      {
         return InventoryItemUtils.GetFrameLabelFromRarity(this.itemRarity) + "Selected";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         return InventoryItemUtils.GetFrameLabelFromRarity(this.itemRarity);
      }
      
      override protected function TryGetEntryText(param1:Object) : String
      {
         return param1.sName;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc5_:TextLineMetrics = null;
         super.SetEntryText(param1);
         if(param1.uCount > 1)
         {
            GlobalFunc.SetText(this.Count_tf,param1.uCount.toString());
            this.Count_mc.visible = true;
         }
         else
         {
            this.Count_mc.visible = false;
         }
         this.itemRarity = param1.uRarity;
         this.EquippedIcon_mc.visible = Boolean(param1.bIsEquipped) && (param1.iFilterFlag & InventoryItemUtils.ICF_AMMO) == 0;
         this.NewItem_mc.visible = !param1.bHasBeenViewed;
         this.ContrabandIcon_mc.visible = param1.bContraband;
         this.StolenIcon_mc.visible = !param1.bContraband && Boolean(param1.bStolen);
         this.FavoriteIcon_mc.visible = (param1.iFilterFlag & InventoryItemUtils.ICF_FAVORITES) != 0;
         this.Tagged_mc.visible = param1.bIsTagged;
         var _loc2_:Number = this.Tagged_mc.width * 2 / 3;
         var _loc3_:Number = this.Count_mc.x;
         if(this.Count_mc.visible)
         {
            _loc5_ = this.Count_tf.getLineMetrics(0);
            _loc3_ -= _loc5_.width + _loc2_;
         }
         if(this.NewItem_mc.visible)
         {
            this.NewItem_mc.Internal_mc.x = (_loc3_ - this.NewItem_mc.width) / this.NewItem_mc.scaleX;
            _loc3_ -= this.NewItem_mc.width + _loc2_;
         }
         if(this.Tagged_mc.visible)
         {
            this.Tagged_mc.x = _loc3_;
            _loc3_ -= this.Tagged_mc.width + _loc2_;
         }
         if(this.ContrabandIcon_mc.visible)
         {
            this.ContrabandIcon_mc.x = _loc3_;
            _loc3_ -= this.ContrabandIcon_mc.width + _loc2_;
         }
         else if(this.StolenIcon_mc.visible)
         {
            this.StolenIcon_mc.x = _loc3_;
            _loc3_ -= this.StolenIcon_mc.width + _loc2_;
         }
         if(this.FavoriteIcon_mc.visible)
         {
            this.FavoriteIcon_mc.Internal_mc.x = (_loc3_ - this.FavoriteIcon_mc.width) / this.FavoriteIcon_mc.scaleX;
            _loc3_ -= this.FavoriteIcon_mc.width + _loc2_;
         }
         var _loc4_:String = InvColumnValueHelper.GetColumnDisplayFuncName(CurrFilter);
         if(this[_loc4_] != undefined)
         {
            this[InvColumnValueHelper.GetColumnDisplayFuncName(CurrFilter)](param1);
         }
         else
         {
            GlobalFunc.SetText(this.Compare_tf,param1.uValue.toString());
         }
         this.DMGIcons_mc.visible = false;
         onRollout();
      }
      
      private function DisplayWeaponDmg(param1:Object) : void
      {
         if(param1.aElementalStats.length > 0)
         {
            GlobalFunc.SetText(this.Compare_tf,param1.aElementalStats[0].fValue.toFixed(0));
         }
         else
         {
            GlobalFunc.SetText(this.Compare_tf,"--");
         }
      }
      
      private function DisplayWeaponDR(param1:Object) : void
      {
         if(param1.aElementalStats.length > 0)
         {
            GlobalFunc.SetText(this.Compare_tf,param1.aElementalStats[0].fValue.toFixed(0));
         }
         else
         {
            GlobalFunc.SetText(this.Compare_tf,"--");
         }
      }
      
      private function DisplayItemMass(param1:Object) : void
      {
         GlobalFunc.SetText(this.Compare_tf,param1.fWeight.toFixed(param1.uWeightPrecision));
      }
      
      private function DisplayItemVal(param1:Object) : void
      {
         GlobalFunc.SetText(this.Compare_tf,param1.uValue.toString());
      }
      
      private function DisplayNoValue(param1:Object) : void
      {
         GlobalFunc.SetText(this.Compare_tf,param1.WeaponInfo.sBaseName);
      }
      
      private function DisplayItemAmmo(param1:Object) : void
      {
         GlobalFunc.SetText(this.Compare_tf,!!param1.WeaponInfo.sAmmoType.length ? String(param1.WeaponInfo.sAmmoType) : "--",false,false,LargeTextMode ? 10 : 0);
      }
   }
}
