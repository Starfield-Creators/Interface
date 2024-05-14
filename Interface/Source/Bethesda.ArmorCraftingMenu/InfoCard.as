package
{
   import Shared.AS3.Inventory.DeltaStat;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class InfoCard extends MovieClip
   {
       
      
      public var Header_mc:MovieClip;
      
      public var Description_mc:MovieClip;
      
      public var Mass_mc:DeltaStat;
      
      public var Value_mc:DeltaStat;
      
      private var LargeTextMode:* = false;
      
      public function InfoCard()
      {
         super();
         TextFieldEx.setTextAutoSize(this.ItemName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Rarity_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      private function get ItemName_tf() : TextField
      {
         return this.Header_mc.Text_mc.Name_tf;
      }
      
      private function get Rarity_tf() : TextField
      {
         return this.Header_mc.Text_mc.Rarity_tf;
      }
      
      public function set largeTextMode(param1:Boolean) : *
      {
         this.LargeTextMode = param1;
      }
      
      public function get largeTextMode() : Boolean
      {
         return this.LargeTextMode;
      }
      
      public function PopulateCard(param1:Object) : void
      {
         var _loc2_:String = InventoryItemUtils.GetFrameLabelFromRarity(param1.uRarity);
         this.Header_mc.gotoAndStop(_loc2_);
         GlobalFunc.SetText(this.ItemName_tf,param1.sName);
         var _loc3_:String = "";
         if(param1.WeaponInfo)
         {
            _loc3_ = String(param1.WeaponInfo.sWeaponType);
         }
         if(param1.uRarity == InventoryItemUtils.RARITY_STANDARD)
         {
            GlobalFunc.SetText(this.Rarity_tf,_loc3_);
         }
         else if(_loc3_.length == 0)
         {
            GlobalFunc.SetText(this.Rarity_tf,"$ItemRarity_" + _loc2_);
         }
         else
         {
            GlobalFunc.SetText(this.Rarity_tf,"$WeaponRarityAndType_" + _loc2_ + " {0}",false,false,0,false,0,new Array(_loc3_));
         }
         GlobalFunc.SetText(this.Description_mc.Text_tf,param1.sDescription);
         this.Mass_mc.SetData(!!this.LargeTextMode ? "$MASS_LRG" : "$MASS",param1.fWeight.toFixed(param1.uWeightPrecision));
         this.Value_mc.SetData(!!this.LargeTextMode ? "$VALUE_LRG" : "$VALUE",param1.uValue.toString());
      }
   }
}
