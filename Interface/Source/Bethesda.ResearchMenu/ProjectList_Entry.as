package
{
   import Shared.AS3.BSContainerEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ProjectList_Entry extends BSContainerEntry
   {
       
      
      public var NewIcon_mc:MovieClip;
      
      public var InProgressMarker_mc:MovieClip;
      
      public var ProgressIndicator_mc:MovieClip;
      
      public var EntryAmount_mc:MovieClip;
      
      public var EntryName_mc:MovieClip;
      
      private var _newProject:Boolean = false;
      
      private var _originalNameY:Number;
      
      private var _largeTextMode:Boolean = false;
      
      private var _nameCharacterLimit:uint = 0;
      
      private const SELECTED_TEXT_COLOR:uint = 16777215;
      
      private const UNSELECTED_TEXT_COLOR:uint = 4343626;
      
      private const NAME_MAX_LENGTH_LRG:uint = 48;
      
      private const PROGRESS_MAX_LENGTH_LRG:uint = 48;
      
      public function ProjectList_Entry()
      {
         super();
         this._originalNameY = this.EntryName_mc.y;
         if(this._largeTextMode)
         {
            this._nameCharacterLimit = this.NAME_MAX_LENGTH_LRG;
            GlobalFunc.SetText(this.ProgressIndicator_mc.Completed_mc.text_tf,"$Completed",false,false,this.PROGRESS_MAX_LENGTH_LRG);
            GlobalFunc.SetText(this.ProgressIndicator_mc.Blocked_mc.text_tf,"$Blocked",false,false,this.PROGRESS_MAX_LENGTH_LRG);
         }
         else
         {
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(this.EntryName_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         var _loc9_:TextLineMetrics = null;
         var _loc10_:Number = NaN;
         var _loc2_:Number = GlobalFunc.RoundDecimal(param1.fProgressPercentage * 100,0);
         GlobalFunc.SetText(this.EntryAmount_mc.Text_tf,_loc2_ + "%");
         GlobalFunc.SetText(this.EntryName_mc.Text_tf,param1.sName,false,false,this._nameCharacterLimit);
         if(this.EntryName_mc.Text_tf.numLines == 1)
         {
            _loc9_ = this.EntryName_mc.Text_tf.getLineMetrics(0);
            _loc10_ = (Border_mc.height - _loc9_.height) / 2;
            this.EntryName_mc.y = _loc10_;
         }
         else
         {
            this.EntryName_mc.y = this._originalNameY;
         }
         this._newProject = param1.bIsNew;
         this.NewIcon_mc.visible = this._newProject;
         var _loc3_:* = _loc2_ >= 100;
         var _loc4_:* = _loc2_ != 0;
         var _loc5_:Boolean = Boolean(param1.bIsLocked) || !param1.bHasRequiredSkills;
         var _loc6_:Boolean = !_loc3_ && !_loc5_ && Boolean(param1.bHasAnyMaterials);
         var _loc7_:String = ResearchUtils.NOT_STARTED_FRAME_LABEL;
         if(_loc3_)
         {
            _loc7_ = ResearchUtils.COMPLETED_FRAME_LABEL;
         }
         else if(_loc6_)
         {
            _loc7_ = ResearchUtils.MATERIAL_AVAILABLE_FRAME_LABEL;
         }
         else if(_loc4_)
         {
            _loc7_ = ResearchUtils.IN_PROGRESS_FRAME_LABEL;
         }
         if(this.InProgressMarker_mc.currentFrameLabel != _loc7_)
         {
            this.InProgressMarker_mc.gotoAndStop(_loc7_);
         }
         var _loc8_:String = _loc3_ ? ResearchUtils.COMPLETED_FRAME_LABEL : (_loc5_ ? ResearchUtils.BLOCKED_FRAME_LABEL : ResearchUtils.NONE_FRAME_LABEL);
         if(this.ProgressIndicator_mc.currentFrameLabel != _loc8_)
         {
            this.ProgressIndicator_mc.gotoAndStop(_loc8_);
         }
      }
      
      override public function onRollover() : void
      {
         if(this._newProject && this.NewIcon_mc.currentFrameLabel != selectedFrameLabel)
         {
            this.NewIcon_mc.gotoAndStop(selectedFrameLabel);
         }
         super.onRollover();
         this.EntryName_mc.Text_tf.textColor = this.SELECTED_TEXT_COLOR;
      }
      
      override public function onRollout() : void
      {
         if(this._newProject && this.NewIcon_mc.currentFrameLabel != unselectedFrameLabel)
         {
            this.NewIcon_mc.gotoAndStop(unselectedFrameLabel);
         }
         super.onRollout();
         this.EntryName_mc.Text_tf.textColor = this.UNSELECTED_TEXT_COLOR;
      }
   }
}
