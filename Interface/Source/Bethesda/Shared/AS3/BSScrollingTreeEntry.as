package Shared.AS3
{
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   
   public class BSScrollingTreeEntry extends BSContainerEntry
   {
       
      
      public var LocationSpacer_mc:MovieClip;
      
      public var CollapseIcon_mc:MovieClip;
      
      public function BSScrollingTreeEntry()
      {
         super();
         Extensions.enabled = true;
         this.HideCollapseIcon();
      }
      
      public function get expandAnimName() : String
      {
         return "open";
      }
      
      public function get collapseAnimName() : String
      {
         return "close";
      }
      
      public function get childSpacerWidth() : Number
      {
         return this.LocationSpacer_mc.width;
      }
      
      public function get expanded() : Boolean
      {
         return this.CollapseIcon_mc.currentLabel == this.expandAnimName;
      }
      
      public function ShowCollapseIcon(param1:Boolean) : *
      {
         this.CollapseIcon_mc.visible = true;
         this.CollapseIcon_mc.gotoAndStop(param1 ? this.expandAnimName : this.collapseAnimName);
      }
      
      public function HideCollapseIcon() : *
      {
         this.CollapseIcon_mc.visible = false;
      }
      
      public function CanBeFocusedInParentEntriesOnly() : Boolean
      {
         return false;
      }
      
      public function IsEntryFocusable() : Boolean
      {
         return true;
      }
   }
}
