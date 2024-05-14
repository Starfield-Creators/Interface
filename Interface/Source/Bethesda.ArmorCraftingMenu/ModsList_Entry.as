package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.TextFieldEx;
   
   public class ModsList_Entry extends BSContainerEntry
   {
      
      public static const DIMMED_SELECTED_LABEL:String = "selectedDimmed";
      
      public static const DIMMED_UNSELECTED_LABEL:String = "unselectedDimmed";
       
      
      public var Installed_mc:MovieClip;
      
      public var Component_mc:MovieClip;
      
      private var _shouldDim:Boolean = false;
      
      private var _currentlyInstalled:Boolean = false;
      
      public function ModsList_Entry()
      {
         super();
         TextFieldEx.setTextAutoSize(this.Component_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         GlobalFunc.SetText(this.Installed_mc.Text_tf,"$INSTALLED");
      }
      
      private function get installedFrameLabel() : String
      {
         return "installed";
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         GlobalFunc.SetText(this.Component_mc.Text_tf,param1.sName);
         this._currentlyInstalled = param1.bCurrentlyInstalled;
         this.Installed_mc.visible = this._currentlyInstalled;
         this._shouldDim = param1.bMissingComponents;
      }
      
      override public function onRollover() : void
      {
         var _loc1_:String = this._currentlyInstalled ? selectedFrameLabel : (this._shouldDim ? DIMMED_SELECTED_LABEL : selectedFrameLabel);
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndPlay(_loc1_);
         }
      }
      
      override public function onRollout() : void
      {
         var _loc1_:String = this._currentlyInstalled ? this.installedFrameLabel : (this._shouldDim ? DIMMED_UNSELECTED_LABEL : unselectedFrameLabel);
         if(animationClip.currentFrameLabel != _loc1_)
         {
            animationClip.gotoAndPlay(_loc1_);
         }
      }
   }
}
