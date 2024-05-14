package
{
   import Shared.AS3.Inventory.DeltaStat;
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class BuildItemInfoCard extends MovieClip
   {
       
      
      public var Header_mc:MovieClip;
      
      public var Description_mc:MovieClip;
      
      public var Message_mc:MovieClip;
      
      public var Mass_mc:DeltaStat;
      
      public var Value_mc:DeltaStat;
      
      public function BuildItemInfoCard()
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
      
      public function PopulateCard(param1:Object) : void
      {
         this.Header_mc.gotoAndStop(InventoryItemUtils.GetFrameLabelFromRarity(param1.uRarity));
         GlobalFunc.SetText(this.ItemName_tf,param1.sName);
         if(param1.uRarity == InventoryItemUtils.RARITY_STANDARD)
         {
            GlobalFunc.SetText(this.Rarity_tf,"");
         }
         else
         {
            GlobalFunc.SetText(this.Rarity_tf,"$ItemRarity_" + InventoryItemUtils.GetFrameLabelFromRarity(param1.uRarity));
         }
         GlobalFunc.SetText(this.Description_mc.Text_tf,param1.sDescription);
         this.Mass_mc.SetData("$MASS",param1.fWeight.toFixed(param1.uWeightPrecision));
         this.Value_mc.SetData("$VALUE",param1.uValue.toString());
      }
      
      public function ShowDisabledMessage(param1:Boolean) : void
      {
         GlobalFunc.SetText(this.Message_mc.Text_tf,param1 ? "$WorkshopBuilder_RequiresScanning" : "");
      }
   }
}
