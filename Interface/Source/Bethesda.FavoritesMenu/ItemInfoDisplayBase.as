package
{
   import Shared.GlobalFunc;
   import Shared.InventoryItemUtils;
   import flash.display.MovieClip;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ItemInfoDisplayBase extends MovieClip
   {
       
      
      public var ItemName_mc:MovieClip;
      
      public var AmmoType_mc:MovieClip;
      
      public var AmmoAmount_mc:MovieClip;
      
      public var DamageTypeHolder_mc:MovieClip;
      
      public var ItemNameBg_mc:MovieClip;
      
      private var OrigItemNameBGWidth:Number = 0;
      
      protected var AMMO_NAME_TO_COUNT_SPACING:Number = 0;
      
      protected var AMMO_COUNT_TO_DAMAGE_SPACING:Number = 0;
      
      protected var NAME_BG_SPACING:Number = 50;
      
      private const DAMAGE_TYPE_SPACING:Number = 15;
      
      public function ItemInfoDisplayBase()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.ItemName_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AmmoType_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.AmmoAmount_mc.text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.OrigItemNameBGWidth = this.ItemNameBg_mc.width;
         this.InitializeSpacings();
      }
      
      public function UpdateDisplay(param1:Object) : void
      {
         this.ResetVisiblities();
         this.SetItemNameFromInfo(param1);
         if(param1.bIsEquippable)
         {
            this.PopulateDamageType(param1.aElementalStats);
            this.PopulateAmmoInfo(param1.sAmmoName,param1.uAmmoCount);
         }
         this.RepositionElements();
      }
      
      protected function ResetVisiblities() : void
      {
         this.ItemName_mc.visible = false;
         this.AmmoType_mc.visible = false;
         this.AmmoAmount_mc.visible = false;
         this.DamageTypeHolder_mc.visible = false;
         this.ItemNameBg_mc.visible = false;
      }
      
      protected function SetItemNameFromInfo(param1:Object) : void
      {
         if(param1.sName.length == 0)
         {
            this.SetItemName("$EMPTY SLOT",0);
         }
         else
         {
            this.SetItemName(param1.sName,param1.uCount);
         }
      }
      
      protected function SetItemName(param1:String, param2:uint) : void
      {
         GlobalFunc.SetText(this.ItemName_mc.text_tf,param1,false);
         if(param2 > 1)
         {
            this.ItemName_mc.text_tf.appendText(" (" + param2 + ")");
         }
         this.ItemName_mc.visible = true;
         this.ItemNameBg_mc.width = Math.max(this.ItemName_mc.text_tf.textWidth + this.NAME_BG_SPACING,this.OrigItemNameBGWidth);
         this.ItemNameBg_mc.visible = true;
      }
      
      protected function PopulateDamageType(param1:Array) : void
      {
         var _loc4_:DamageType = null;
         while(param1.length < this.DamageTypeHolder_mc.numChildren)
         {
            this.DamageTypeHolder_mc.removeChildAt(this.DamageTypeHolder_mc.numChildren - 1);
         }
         while(param1.length > this.DamageTypeHolder_mc.numChildren)
         {
            this.DamageTypeHolder_mc.addChild(new DamageType());
         }
         var _loc2_:DamageType = null;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            (_loc4_ = this.DamageTypeHolder_mc.getChildAt(_loc3_) as DamageType).Icon_mc.gotoAndStop(InventoryItemUtils.GetElementalLabel(param1[_loc3_].iElementalType));
            GlobalFunc.SetText(_loc4_.text_tf,Math.floor(param1[_loc3_].fValue).toString(),false);
            if(_loc2_ == null)
            {
               _loc4_.x = 0;
            }
            else
            {
               _loc4_.x = _loc2_.x + _loc2_.text_tf.x + _loc2_.text_tf.textWidth + this.DAMAGE_TYPE_SPACING;
            }
            _loc2_ = _loc4_;
            _loc3_++;
         }
         this.DamageTypeHolder_mc.visible = true;
      }
      
      protected function PopulateAmmoInfo(param1:String, param2:uint) : void
      {
         var _loc3_:uint = 999;
         var _loc4_:uint = 3;
         if(param1.length != 0)
         {
            GlobalFunc.SetText(this.AmmoType_mc.text_tf,param1,false);
            if(param2 > _loc3_)
            {
               GlobalFunc.SetText(this.AmmoAmount_mc.text_tf,"(" + _loc3_.toString() + "+)",false);
            }
            else
            {
               GlobalFunc.SetText(this.AmmoAmount_mc.text_tf,"(" + GlobalFunc.PadNumber(param2,_loc4_) + ")",false);
            }
            this.AmmoType_mc.visible = true;
            this.AmmoAmount_mc.visible = true;
         }
         else
         {
            this.AmmoType_mc.visible = false;
            this.AmmoAmount_mc.visible = false;
         }
      }
      
      protected function InitializeSpacings() : void
      {
         var _loc1_:TextLineMetrics = this.AmmoType_mc.text_tf.getLineMetrics(0);
         this.AMMO_NAME_TO_COUNT_SPACING = this.AmmoAmount_mc.x - this.AmmoType_mc.x - _loc1_.x - _loc1_.width;
         var _loc2_:TextLineMetrics = this.AmmoAmount_mc.text_tf.getLineMetrics(0);
         this.AMMO_COUNT_TO_DAMAGE_SPACING = this.DamageTypeHolder_mc.x - this.AmmoAmount_mc.x - _loc2_.x - _loc2_.width;
      }
      
      protected function RepositionElements() : void
      {
      }
   }
}
