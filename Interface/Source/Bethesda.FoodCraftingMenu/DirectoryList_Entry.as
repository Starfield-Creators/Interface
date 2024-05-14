package
{
   import Components.ImageFixture;
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class DirectoryList_Entry extends BSContainerEntry
   {
      
      public static var unselectedColor:uint = 0;
      
      public static var selectedColor:uint = 0;
      
      public static var dimmedColor:uint = 0;
      
      public static const DIMMED_SELECTED_LABEL:String = "selectedDimmed";
      
      public static const DIMMED_UNSELECTED_LABEL:String = "unselectedDimmed";
       
      
      public var Name_mc:MovieClip;
      
      public var Mass_mc:MovieClip;
      
      public var Value_mc:MovieClip;
      
      public var Icon_mc:ImageFixture;
      
      public var Tagged_mc:MovieClip;
      
      private var _shouldDim:Boolean = false;
      
      private var _largeTextMode:Boolean = false;
      
      public function DirectoryList_Entry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Mass_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Value_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setVerticalAlign(this.Name_mc.Text_tf,TextFieldEx.VALIGN_CENTER);
         this.Icon_mc.centerClip = true;
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.BSASSERT(param1 != null,"DirectoryList_Entry: SetEntryText requires a valid Entry!");
         this._shouldDim = param1.bMissingComponents;
         if(this._largeTextMode)
         {
            GlobalFunc.SetTruncatedMultilineText(this.Name_mc.Text_tf,param1.sName,true);
         }
         else
         {
            GlobalFunc.SetText(this.Name_mc.Text_tf,param1.sName);
         }
         GlobalFunc.SetText(this.Mass_mc.Text_tf,param1.fWeight.toFixed(param1.uWeightPrecision));
         GlobalFunc.SetText(this.Value_mc.Text_tf,param1.uValue.toString());
         this.Icon_mc.LoadImageFixtureFromUIData(param1.iconImage,CraftingUtils.CRAFTING_IMAGE_BUFFER);
         if(this.Tagged_mc != null)
         {
            this.Tagged_mc.visible = param1.bTrackingCreatedItem;
         }
      }
      
      override public function onRollover() : void
      {
         var _loc1_:String = this._shouldDim ? DIMMED_SELECTED_LABEL : selectedFrameLabel;
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndPlay(_loc1_);
         }
         this.Name_mc.Text_tf.textColor = selectedColor;
      }
      
      override public function onRollout() : void
      {
         var _loc1_:String = this._shouldDim ? DIMMED_UNSELECTED_LABEL : unselectedFrameLabel;
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndPlay(_loc1_);
         }
         this.Name_mc.Text_tf.textColor = this._shouldDim ? dimmedColor : unselectedColor;
      }
   }
}
