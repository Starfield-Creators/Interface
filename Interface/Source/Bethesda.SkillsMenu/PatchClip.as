package
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PatchClip extends MovieClip
   {
      
      public static const PATCH_SELECTION_CHANGED:String = "PatchSelectionChanged";
      
      public static const PATCH_SELECTED:String = "PatchSelected";
       
      
      public var SkillNameplate_mc:MovieClip;
      
      public var PatchBackground_mc:MovieClip;
      
      public var RollOnOffCatcher_mc:MovieClip;
      
      public var SkillHighlight_mc:MovieClip;
      
      public var PatchArtClip_mc:MovieClip;
      
      public var Highlight_mc:MovieClip;
      
      private const UNLOCKED_SCALE:Number = 1.25;
      
      private const LOCKED_SCALE:Number = 1.1;
      
      private const AVAILABLE_SCALE:Number = 1.1;
      
      private const Y_OFFSET:Number = 15;
      
      private const SELECTED_Y_OFFSET:Number = 10;
      
      private const HIGHLIGHT_SELECTED_Y_OFFSET:Number = 6;
      
      private var YOriginal:Number = 0;
      
      private var HighlightYOriginal:Number = 0;
      
      private var Selected:Boolean = false;
      
      private var Data:Object;
      
      private var Selectable:Boolean = true;
      
      private var RolledOver:Boolean = false;
      
      public function PatchClip()
      {
         this.Data = new Object();
         super();
         this.RollOnOffCatcher_mc.addEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut);
         this.RollOnOffCatcher_mc.addEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver);
         this.RollOnOffCatcher_mc.addEventListener(MouseEvent.CLICK,this.OnMouseClick);
         this.SkillHighlight_mc.visible = false;
         this.scaleX = this.AVAILABLE_SCALE;
         this.scaleY = this.AVAILABLE_SCALE;
         this.YOriginal = this.PatchBackground_mc.y;
         this.PatchBackground_mc.y = this.YOriginal + this.Y_OFFSET;
         this.SkillHighlight_mc.y = this.YOriginal + this.Y_OFFSET;
         this.PatchArtClip_mc.y = this.YOriginal + this.Y_OFFSET;
         this.HighlightYOriginal = this.Highlight_mc.y;
      }
      
      public function set selectable(param1:*) : *
      {
         this.Selectable = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this.Selectable;
      }
      
      public function SetData(param1:Object) : *
      {
         this.Data = param1;
         this.scaleX = !!this.Data.bAvailable ? (this.Data.uRank > 0 ? this.UNLOCKED_SCALE : this.AVAILABLE_SCALE) : this.LOCKED_SCALE;
         this.scaleY = !!this.Data.bAvailable ? (this.Data.uRank > 0 ? this.UNLOCKED_SCALE : this.AVAILABLE_SCALE) : this.LOCKED_SCALE;
         if(stage && this.Data != null && this.selectable)
         {
            stage.dispatchEvent(new CustomEvent(PATCH_SELECTION_CHANGED,{
               "onRollOver":this.RolledOver,
               "data":this.Data
            },true,true));
         }
      }
      
      public function QData() : Object
      {
         return this.Data;
      }
      
      private function OnMouseRollOut(param1:Event) : *
      {
         this.PatchBackground_mc.y = this.YOriginal + this.Y_OFFSET;
         this.SkillHighlight_mc.y = this.YOriginal + this.Y_OFFSET;
         this.PatchArtClip_mc.y = this.YOriginal + this.Y_OFFSET;
         this.Highlight_mc.y = this.HighlightYOriginal;
         this.Selected = false;
         this.SkillNameplate_mc.visible = this.Selected;
         this.SkillHighlight_mc.visible = this.Selected;
         stage.dispatchEvent(new CustomEvent(PATCH_SELECTION_CHANGED,{"onRollOver":false},true,true));
         this.RolledOver = false;
      }
      
      private function OnMouseRollOver(param1:Event) : *
      {
         if(this.selectable)
         {
            this.PatchBackground_mc.y = this.YOriginal + this.SELECTED_Y_OFFSET;
            this.SkillHighlight_mc.y = this.YOriginal + this.SELECTED_Y_OFFSET;
            this.PatchArtClip_mc.y = this.YOriginal + this.SELECTED_Y_OFFSET;
            this.Highlight_mc.y = this.HighlightYOriginal - this.HIGHLIGHT_SELECTED_Y_OFFSET;
            this.Selected = true;
            this.SkillNameplate_mc.visible = this.Selected;
            this.SkillHighlight_mc.visible = this.Selected;
            parent.setChildIndex(this,parent.numChildren - 1);
            if(this.RolledOver == false)
            {
               stage.dispatchEvent(new CustomEvent(PATCH_SELECTION_CHANGED,{
                  "onRollOver":true,
                  "data":this.Data
               },true,true));
               this.RolledOver = true;
            }
            GlobalFunc.PlayMenuSound("UIMenuSkillsSkillFocus");
         }
      }
      
      private function OnMouseClick(param1:Event) : *
      {
         if(this.selectable)
         {
            stage.dispatchEvent(new CustomEvent(PATCH_SELECTED,{"data":this.Data},true,true));
         }
      }
      
      public function QSelected() : Boolean
      {
         return this.Selected;
      }
   }
}
