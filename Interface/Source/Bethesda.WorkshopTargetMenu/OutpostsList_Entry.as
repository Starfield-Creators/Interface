package
{
   import Shared.AS3.BSScrollingTreeEntry;
   import flash.display.MovieClip;
   
   public class OutpostsList_Entry extends BSScrollingTreeEntry
   {
      
      private static const FRAME_LABEL_OUTPOST:String = "Outpost";
      
      private static const FRAME_LABEL_TARGET:String = "Target";
       
      
      public var OutpostEntry_mc:OutpostEntry;
      
      public var TargetEntry_mc:TargetEntry;
      
      public function OutpostsList_Entry()
      {
         super();
      }
      
      public static function IsOutpost(param1:Object) : Boolean
      {
         return param1.hasOwnProperty("aTargets");
      }
      
      public function get showingOutpost() : Boolean
      {
         return currentFrameLabel == FRAME_LABEL_OUTPOST;
      }
      
      override public function get animationClip() : MovieClip
      {
         return this.showingOutpost ? this.OutpostEntry_mc : this.TargetEntry_mc;
      }
      
      override public function get expanded() : Boolean
      {
         return this.OutpostEntry_mc.expanded;
      }
      
      override public function get selected() : Boolean
      {
         return this.animationClip.selected;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         if(IsOutpost(param1))
         {
            gotoAndStop(FRAME_LABEL_OUTPOST);
            this.OutpostEntry_mc.SetEntryText(param1);
         }
         else
         {
            gotoAndStop(FRAME_LABEL_TARGET);
            this.TargetEntry_mc.SetEntryText(param1);
         }
      }
      
      override public function ShowCollapseIcon(param1:Boolean) : *
      {
         this.OutpostEntry_mc.expanded = param1;
         gotoAndStop(FRAME_LABEL_OUTPOST);
      }
      
      override public function HideCollapseIcon() : *
      {
         gotoAndStop(FRAME_LABEL_TARGET);
      }
      
      override public function onRollover() : void
      {
         this.OutpostEntry_mc.selected = true;
         this.TargetEntry_mc.selected = true;
      }
      
      override public function onRollout() : void
      {
         this.OutpostEntry_mc.selected = false;
         this.TargetEntry_mc.selected = false;
      }
   }
}
