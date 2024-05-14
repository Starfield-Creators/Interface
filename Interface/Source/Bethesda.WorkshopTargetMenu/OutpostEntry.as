package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class OutpostEntry extends MovieClip
   {
       
      
      public var OutpostName_mc:MovieClip;
      
      public var OutpostLocation_mc:MovieClip;
      
      public var OutpostDistance_mc:MovieClip;
      
      public var LinkedIcon_mc:MovieClip;
      
      public var SelectedPip_mc:MovieClip;
      
      private const SELECTED_FRAME_LABEL:String = "selected";
      
      private const UNSELECTED_FRAME_LABEL:String = "unselected";
      
      private const LINKED_FRAME_LABEL:String = "_Linked";
      
      private const UNLINKED_FRAME_LABEL:String = "_Unlinked";
      
      private const PRECISION:uint = 1;
      
      private var _currentLink:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _expanded:Boolean = false;
      
      public function OutpostEntry()
      {
         super();
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function set expanded(param1:Boolean) : void
      {
         this._expanded = this.expanded;
      }
      
      public function get currentLink() : Boolean
      {
         return this._currentLink;
      }
      
      public function set currentLink(param1:Boolean) : void
      {
         this._currentLink = param1;
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
         var _loc1_:String = String((this.selected ? this.SELECTED_FRAME_LABEL : this.UNSELECTED_FRAME_LABEL) + (this.currentLink ? this.LINKED_FRAME_LABEL : this.UNLINKED_FRAME_LABEL));
         if(currentFrameLabel != _loc1_)
         {
            gotoAndStop(_loc1_);
         }
         var _loc2_:String = this.selected ? this.SELECTED_FRAME_LABEL : this.UNSELECTED_FRAME_LABEL;
         if(this.SelectedPip_mc.currentFrameLabel != _loc2_)
         {
            this.SelectedPip_mc.gotoAndStop(_loc2_);
         }
      }
      
      public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.OutpostName_mc.text_tf,param1.sName);
         GlobalFunc.SetText(this.OutpostLocation_mc.text_tf,param1.sPlanet + ", " + param1.sSystem);
         GlobalFunc.SetText(this.OutpostDistance_mc.text_tf,GlobalFunc.FormatNumberToString(param1.fDistanceInLY,this.PRECISION) + " $$LY");
         this.currentLink = param1.bCurrentLink;
      }
   }
}
