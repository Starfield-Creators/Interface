package
{
   import Components.ImageFixture;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class BuildList_Entry extends BSContainerEntry
   {
       
      
      public var Name_mc:MovieClip;
      
      public var Mass_mc:MovieClip;
      
      public var Value_mc:MovieClip;
      
      public var Built_mc:MovieClip;
      
      public var RequiresScan_mc:MovieClip;
      
      public var Icon_mc:ImageFixture;
      
      public var Tagged_mc:MovieClip;
      
      private var _currentlyBuilt:Boolean = false;
      
      private var _playerKnowledge:Boolean = false;
      
      private var _trackingCreatedItem:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private const BUILT_FRAME_LABEL:String = "currentlyBuilt";
      
      private const SCANNING_FRAME_LABEL:String = "requiresScanning";
      
      private const SELECTED_TEXT_COLOR:uint = 790813;
      
      private const UNSELECTED_TEXT_COLOR:uint = 13153632;
      
      public function BuildList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Mass_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Built_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.RequiresScan_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setVerticalAlign(this.Name_mc.Text_tf,TextFieldEx.VALIGN_CENTER);
         this.Icon_mc.centerClip = true;
      }
      
      override public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.Name_mc.Text_tf,param1.sName);
         this._currentlyBuilt = param1.bCurrentlyBuilt;
         this._playerKnowledge = param1.bPlayerKnowledge;
         this._trackingCreatedItem = param1.bTrackingCreatedItem;
         this.Tagged_mc.visible = this._trackingCreatedItem;
         var _loc2_:String = GlobalFunc.FormatNumberToString(param1.fWeight,1);
         GlobalFunc.SetText(this.Mass_mc.Text_tf,_loc2_);
         var _loc3_:* = param1.uValue + " C";
         GlobalFunc.SetText(this.Value_mc.Text_tf,_loc3_);
         this.Icon_mc.LoadImageFixtureFromUIData(param1.iconImage,"WorkshopBuilderIconTextureBuffer");
         if(this.selected)
         {
            this.onRollover();
         }
         else
         {
            this.onRollout();
         }
      }
      
      override public function onRollover() : void
      {
         this._selected = true;
         var _loc1_:String = "selected" + (this._currentlyBuilt ? this.BUILT_FRAME_LABEL : "") + (this._playerKnowledge ? "" : this.SCANNING_FRAME_LABEL);
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndStop(_loc1_);
         }
         this.Name_mc.Text_tf.textColor = this.SELECTED_TEXT_COLOR;
      }
      
      override public function onRollout() : void
      {
         this._selected = false;
         var _loc1_:String = "unselected" + (this._currentlyBuilt ? this.BUILT_FRAME_LABEL : "") + (this._playerKnowledge ? "" : this.SCANNING_FRAME_LABEL);
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndStop(_loc1_);
         }
         this.Name_mc.Text_tf.textColor = this.UNSELECTED_TEXT_COLOR;
      }
   }
}
