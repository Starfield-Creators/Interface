package
{
   import Components.ImageFixture;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class BuildObjectList_Entry extends BSContainerEntry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var Cross_mc:MovieClip;
      
      public var Variant_mc:MovieClip;
      
      public var VariantBG_mc:MovieClip;
      
      public var NewIcon_mc:MovieClip;
      
      public var Image_mc:ImageFixture;
      
      private var _disabled:* = false;
      
      private var _selected:* = false;
      
      public function BuildObjectList_Entry()
      {
         super();
         this.Image_mc.centerClip = true;
         TextFieldEx.setVerticalAlign(this.baseTextField,TextFieldEx.VALIGN_CENTER);
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function set disabled(param1:Boolean) : *
      {
         this._disabled = param1;
      }
      
      override public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : *
      {
         this._selected = param1;
      }
      
      override public function get selectedFrameLabel() : String
      {
         if(this.disabled)
         {
            return "selectedDisabled";
         }
         return "selected";
      }
      
      override public function get unselectedFrameLabel() : String
      {
         if(this.disabled)
         {
            return "unselectedDisabled";
         }
         return "unselected";
      }
      
      override protected function get baseTextField() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc2_:Object = WorkshopUtils.GetCurrentVariantData(param1);
         GlobalFunc.SetTruncatedMultilineText(this.baseTextField,_loc2_.name);
         GlobalFunc.SetText(this.Variant_mc.Text_tf,_loc2_.count);
         var _loc3_:* = WorkshopUtils.GetHasVariants(param1) > 0;
         this.Variant_mc.visible = _loc3_;
         this.VariantBG_mc.visible = _loc3_;
         this.Image_mc.LoadImageFixtureFromUIData(_loc2_.iconImage,WorkshopUtils.GRID_ICON_TEXTURE_BUFFER);
         this.disabled = !_loc2_.buildReqsMet || !_loc2_.skillReqsMet;
         this.Cross_mc.visible = !_loc2_.skillReqsMet;
         this.NewIcon_mc.visible = false;
         this.RefreshRollover();
      }
      
      override public function onRollover() : void
      {
         this.selected = true;
         super.onRollover();
      }
      
      override public function onRollout() : void
      {
         this.selected = false;
         super.onRollout();
      }
      
      private function RefreshRollover() : void
      {
         if(this.selected)
         {
            this.onRollover();
         }
         else
         {
            this.onRollout();
         }
      }
   }
}
