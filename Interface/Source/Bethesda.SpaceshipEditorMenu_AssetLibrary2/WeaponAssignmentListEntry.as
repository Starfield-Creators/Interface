package
{
   import Shared.AS3.BSScrollingTreeEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   
   public class WeaponAssignmentListEntry extends BSScrollingTreeEntry
   {
      
      private static const WEAPON_GROUP:String = "WeaponGroup";
      
      private static const WEAPON:String = "Weapon";
      
      private static const OPEN:String = "open";
      
      private static const OPEN_SELECTED:String = "openSelected";
      
      private static const CLOSE:String = "close";
      
      private static const CLOSE_SELECTED:String = "closeSelected";
       
      
      public var WeaponGroupVisuals_mc:MovieClip;
      
      public var WeaponVisuals_mc:MovieClip;
      
      public function WeaponAssignmentListEntry()
      {
         super();
         Extensions.enabled = true;
      }
      
      public static function IsWeaponGroup(param1:Object) : Boolean
      {
         return param1.hasOwnProperty("aWeapons");
      }
      
      public function get showingWeaponGroup() : Boolean
      {
         return currentLabel == WEAPON_GROUP;
      }
      
      private function get activeVisuals() : MovieClip
      {
         return this.showingWeaponGroup ? this.WeaponGroupVisuals_mc : this.WeaponVisuals_mc;
      }
      
      private function get activeVisualsText() : TextField
      {
         return this.activeVisuals.EntryText_mc.text_tf;
      }
      
      private function get weaponGroupText() : TextField
      {
         return this.WeaponGroupVisuals_mc.GroupText_mc.text_tf;
      }
      
      override public function get animationClip() : MovieClip
      {
         return this.showingWeaponGroup ? this.WeaponGroupVisuals_mc : this.WeaponVisuals_mc;
      }
      
      override public function get expandAnimName() : String
      {
         return selected ? OPEN_SELECTED : super.expandAnimName;
      }
      
      override public function get collapseAnimName() : String
      {
         return selected ? CLOSE_SELECTED : super.collapseAnimName;
      }
      
      override public function get expanded() : Boolean
      {
         return CollapseIcon_mc.currentLabel == OPEN_SELECTED || CollapseIcon_mc.currentLabel == super.expandAnimName;
      }
      
      private function ShowWeaponGroup() : void
      {
         gotoAndStop(WEAPON_GROUP);
      }
      
      private function ShowWeapon() : void
      {
         gotoAndStop(WEAPON);
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         if(IsWeaponGroup(param1))
         {
            GlobalFunc.SetText(this.weaponGroupText,"$W",false,false,0,false,0,new Array(GlobalFunc.FormatNumberToString(param1.uGroupNum)));
            this.ShowWeaponGroup();
         }
         else
         {
            this.ShowWeapon();
         }
         if(param1.sText != undefined)
         {
            GlobalFunc.SetText(this.activeVisualsText,param1.sText);
         }
         else
         {
            GlobalFunc.SetText(this.activeVisualsText,"");
         }
      }
      
      override public function onRollover() : void
      {
         super.onRollover();
         this.UpdateCollapseIcon();
      }
      
      override public function onRollout() : void
      {
         super.onRollout();
         this.UpdateCollapseIcon();
      }
      
      public function UpdateCollapseIcon() : void
      {
         if(CollapseIcon_mc.visible)
         {
            ShowCollapseIcon(this.expanded);
         }
      }
   }
}
