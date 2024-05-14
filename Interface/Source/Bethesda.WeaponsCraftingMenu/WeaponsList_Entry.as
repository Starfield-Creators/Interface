package
{
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class WeaponsList_Entry extends DirectoryList_Entry
   {
       
      
      public var EquippedIcon_mc:MovieClip;
      
      public var Damage1_mc:MovieClip;
      
      public var Damage2_mc:MovieClip;
      
      private const MAX_DMG_TYPES:uint = 2;
      
      public function WeaponsList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Damage1_mc.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Damage2_mc.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         this.EquippedIcon_mc.visible = param1.bIsEquipped;
         var _loc2_:Array = [this.Damage1_mc,this.Damage2_mc];
         CraftingUtils.PopulateDirectoryDamageClips(param1.aElementalStats,_loc2_);
      }
   }
}
