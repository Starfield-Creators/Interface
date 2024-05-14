package
{
   import Shared.AS3.Inventory.InvItemCard;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HUDRolloverItemCard extends MovieClip
   {
       
      
      public var ItemCard_mc:InvItemCard;
      
      public var AdditionalIcons_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private var _headerHeight:Number = 0;
      
      private var _additionalIconsOffset:Number = 0;
      
      public function HUDRolloverItemCard()
      {
         super();
         this._headerHeight = this.ItemCard_mc.Header_mc.height;
         this._additionalIconsOffset = this.AdditionalIcons_mc.y;
      }
      
      public function get VerticalAnchorPoint() : Number
      {
         return this.y + this.Background_mc.y + this._headerHeight;
      }
      
      public function get CardBottomRight() : Point
      {
         return new Point(this.x + this.Background_mc.width,this.y + this.Background_mc.y + this.Background_mc.height);
      }
      
      public function ApplyData(param1:Object, param2:Number) : void
      {
         if(param1.bShouldCompareItems)
         {
            this.ItemCard_mc.SetItemData(param1.ItemData,param1.CompareItemData);
         }
         else
         {
            this.ItemCard_mc.SetItemData(param1.ItemData,param1.ItemData);
         }
         this.Background_mc.height = this.ItemCard_mc.GetVisibleHeight();
         var _loc3_:Number = (stage.stageHeight - this.Background_mc.height) / 2 - param2 * 2 + this.y;
         this.ItemCard_mc.y = _loc3_;
         this.Background_mc.y = _loc3_;
         this.AdditionalIcons_mc.Contraband_mc.visible = param1.bContraband;
         this.AdditionalIcons_mc.Stealing_mc.visible = !param1.bContraband && param1.bStealing;
         this.AdditionalIcons_mc.Tagged_mc.visible = param1.bIsTrackedForCrafting;
         var _loc4_:Number = 5;
         var _loc5_:Number = 0;
         if(this.AdditionalIcons_mc.Contraband_mc.visible)
         {
            this.AdditionalIcons_mc.Contraband_mc.x = _loc5_;
            _loc5_ += this.AdditionalIcons_mc.Contraband_mc.width + _loc4_;
         }
         if(this.AdditionalIcons_mc.Stealing_mc.visible)
         {
            this.AdditionalIcons_mc.Stealing_mc.x = _loc5_;
            _loc5_ += this.AdditionalIcons_mc.Stealing_mc.width + _loc4_;
         }
         if(this.AdditionalIcons_mc.Tagged_mc.visible)
         {
            this.AdditionalIcons_mc.Tagged_mc.x = _loc5_;
            _loc5_ += this.AdditionalIcons_mc.Tagged_mc.width + _loc4_;
         }
         this.AdditionalIcons_mc.y = this._additionalIconsOffset + _loc3_;
      }
   }
}
