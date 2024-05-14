package Shared.AS3.QuickContainer
{
   import Shared.AS3.BSContainerEntry;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class QuickContainerListEntry extends BSContainerEntry
   {
      
      public static var IsStealing:Boolean = false;
       
      
      public var Contraband_mc:MovieClip;
      
      public var Stolen_mc:MovieClip;
      
      public var Tagged_mc:MovieClip;
      
      public var Text_mc:MovieClip;
      
      private var itemRarity:int;
      
      private const NAME_MAX_LENGTH:uint = 39;
      
      private const NAME_TRUNCATION_FOR_ICONS_BASE:* = 1;
      
      private const NAME_TRUNCATION_PER_ICON:* = 2;
      
      private const NAME_TRUNCATION_FOR_RARITY_SYMBOL:* = 5;
      
      public function QuickContainerListEntry()
      {
         this.itemRarity = InventoryItemUtils.RARITY_STANDARD;
         super();
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Text_mc.Text_tf;
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
         var _loc2_:String = String(param1.sName);
         if(param1.uCount > 1)
         {
            _loc2_ += " (" + param1.uCount + ")";
         }
         return _loc2_;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.itemRarity = param1.uRarity;
         var _loc2_:Number = 25;
         var _loc3_:Number = 5;
         this.Contraband_mc.visible = param1.bContraband;
         this.Stolen_mc.visible = !param1.bContraband && (IsStealing || Boolean(param1.bStolen));
         this.Tagged_mc.visible = param1.bIsTagged;
         var _loc4_:* = (this.Tagged_mc.visible ? 1 : 0) + (this.Stolen_mc.visible || this.Contraband_mc.visible ? 1 : 0);
         var _loc5_:* = this.NAME_MAX_LENGTH;
         if(_loc4_ > 0)
         {
            _loc5_ -= this.NAME_TRUNCATION_PER_ICON * _loc4_ + this.NAME_TRUNCATION_FOR_ICONS_BASE;
         }
         if(param1.uRarity > 0)
         {
            _loc5_ -= this.NAME_TRUNCATION_FOR_RARITY_SYMBOL;
         }
         maxCharactersToDisplay = _loc5_;
         super.SetEntryText(param1);
         var _loc6_:Number = this.baseTextField.x + this.baseTextField.textWidth + _loc2_;
         if(this.Contraband_mc.visible)
         {
            this.Contraband_mc.x = _loc6_;
            _loc6_ += this.Contraband_mc.width + _loc3_;
         }
         if(this.Stolen_mc.visible)
         {
            this.Stolen_mc.x = _loc6_;
            _loc6_ += this.Stolen_mc.width + _loc3_;
         }
         if(this.Tagged_mc.visible)
         {
            this.Tagged_mc.x = _loc6_;
            _loc6_ += this.Tagged_mc.width + _loc3_;
         }
         onRollout();
      }
   }
}
