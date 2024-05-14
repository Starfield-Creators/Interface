package
{
   import flash.geom.Point;
   import flash.text.TextLineMetrics;
   
   public class FavoriteAssigningInfoDisplay extends ItemInfoDisplayBase
   {
       
      
      public function FavoriteAssigningInfoDisplay()
      {
         super();
      }
      
      override protected function RepositionElements() : void
      {
         var _loc7_:DamageType = null;
         var _loc1_:TextLineMetrics = AmmoType_mc.text_tf.getLineMetrics(0);
         var _loc2_:TextLineMetrics = AmmoAmount_mc.text_tf.getLineMetrics(0);
         var _loc3_:Number = 0;
         var _loc4_:Point = new Point(0,0);
         var _loc5_:Number = 0;
         AmmoType_mc.x = _loc4_.x;
         AmmoType_mc.y = _loc4_.y;
         if(AmmoType_mc.visible)
         {
            _loc4_.x += _loc1_.x + _loc1_.width + AMMO_NAME_TO_COUNT_SPACING;
         }
         AmmoAmount_mc.x = _loc4_.x;
         AmmoAmount_mc.y = _loc4_.y;
         if(AmmoAmount_mc.visible)
         {
            _loc4_.x += _loc2_.x + _loc2_.width + AMMO_COUNT_TO_DAMAGE_SPACING;
         }
         DamageTypeHolder_mc.x = _loc4_.x;
         DamageTypeHolder_mc.y = _loc4_.y;
         if(DamageTypeHolder_mc.numChildren > 0)
         {
            _loc7_ = DamageTypeHolder_mc.getChildAt(DamageTypeHolder_mc.numChildren - 1) as DamageType;
            _loc4_.x += _loc7_.x + _loc7_.text_tf.x + _loc7_.text_tf.textWidth;
         }
         _loc3_ = _loc4_.x;
         var _loc6_:Number = _loc3_ / 2;
         AmmoType_mc.x -= _loc6_;
         AmmoAmount_mc.x -= _loc6_;
         DamageTypeHolder_mc.x -= _loc6_;
         if(_loc3_ > ItemNameBg_mc.width)
         {
            ItemNameBg_mc.width = _loc3_;
         }
      }
   }
}
