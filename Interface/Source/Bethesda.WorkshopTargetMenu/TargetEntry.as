package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class TargetEntry extends MovieClip
   {
       
      
      public var TargetName_mc:MovieClip;
      
      public var TargetPip_mc:MovieClip;
      
      public var LinkedIcon_mc:MovieClip;
      
      private const SELECTED_FRAME_LABEL:String = "selected";
      
      private const UNSELECTED_FRAME_LABEL:String = "unselected";
      
      private const LINKED_FRAME_LABEL:String = "_Linked";
      
      private const UNLINKED_FRAME_LABEL:String = "_Unlinked";
      
      private var _currentTarget:Boolean = false;
      
      private var _selected:Boolean = false;
      
      public function TargetEntry()
      {
         super();
      }
      
      public function get currentTarget() : Boolean
      {
         return this._currentTarget;
      }
      
      public function set currentTarget(param1:Boolean) : void
      {
         this._currentTarget = param1;
         this.UpdateHighlight();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this.UpdateHighlight();
      }
      
      private function UpdateHighlight() : void
      {
         var _loc1_:String = String((this.selected ? this.SELECTED_FRAME_LABEL : this.UNSELECTED_FRAME_LABEL) + (this.currentTarget ? this.LINKED_FRAME_LABEL : this.UNLINKED_FRAME_LABEL));
         if(currentFrameLabel != _loc1_)
         {
            gotoAndStop(_loc1_);
         }
         var _loc2_:String = this.selected ? this.SELECTED_FRAME_LABEL : this.UNSELECTED_FRAME_LABEL;
         if(this.TargetPip_mc.currentFrameLabel != _loc2_)
         {
            this.TargetPip_mc.gotoAndStop(_loc2_);
         }
      }
      
      public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.TargetName_mc.text_tf,param1.sName);
         this.currentTarget = param1.bCurrentTarget;
      }
   }
}
