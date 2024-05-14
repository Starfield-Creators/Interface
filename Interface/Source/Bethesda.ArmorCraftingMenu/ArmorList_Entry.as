package
{
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ArmorList_Entry extends DirectoryList_Entry
   {
       
      
      public var EquippedIcon_mc:MovieClip;
      
      public var Resist1_mc:MovieClip;
      
      public var Resist2_mc:MovieClip;
      
      public var Resist3_mc:MovieClip;
      
      private const MAX_RES_TYPES:uint = 3;
      
      public function ArmorList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Resist1_mc.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Resist2_mc.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Resist3_mc.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         super.SetEntryText(param1);
         this.EquippedIcon_mc.visible = param1.bIsEquipped;
         var _loc2_:Array = [this.Resist1_mc,this.Resist2_mc,this.Resist3_mc];
         CraftingUtils.PopulateDirectoryDamageClips(param1.aElementalStats,_loc2_);
      }
   }
}
