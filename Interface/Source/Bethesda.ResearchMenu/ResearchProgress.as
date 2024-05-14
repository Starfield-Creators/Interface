package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextLineMetrics;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ResearchProgress extends MovieClip
   {
      
      public static const NO_PROGRESS:String = "NoProgress";
      
      public static const IN_PROGRESS:String = "InProgress";
      
      public static const CLOSE:String = "Close";
       
      
      public var NoProgress_mc:MovieClip;
      
      public var InProgress_mc:MovieClip;
      
      private var _numInProgress:uint = 0;
      
      private var ProjectListCharLimit:uint;
      
      private const HEADER_PADDING:Number = 40;
      
      private const PROJECT_LIST_CHAR_LIMIT:uint = 69;
      
      private const PROJECT_LIST_CHAR_LIMIT_LRG:uint = 57;
      
      private const CONTINUE_TEXT_CHAR_COUNT:uint = 7;
      
      public function ResearchProgress()
      {
         this.ProjectListCharLimit = this.PROJECT_LIST_CHAR_LIMIT;
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.NoProgress_mc.Header_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function UpdateProjectList(param1:Array, param2:uint) : void
      {
         var _loc7_:uint = 0;
         this._numInProgress = param1.length;
         var _loc3_:* = "";
         var _loc4_:uint = 0;
         while(_loc4_ < this._numInProgress)
         {
            if((_loc7_ = uint(_loc3_.length)) > this.ProjectListCharLimit)
            {
               break;
            }
            _loc3_ += param1[_loc4_];
            if(_loc4_ < this._numInProgress - 1)
            {
               _loc3_ += ", ";
            }
            _loc4_++;
         }
         if(_loc3_.length > this.ProjectListCharLimit || _loc4_ < this._numInProgress)
         {
            _loc3_ = this.FindAndReplaceLastComma(_loc3_);
         }
         GlobalFunc.SetText(this.InProgress_mc.ProgressList_mc.Text_tf,_loc3_);
         GlobalFunc.SetText(this.NoProgress_mc.Header_mc.Text_tf,param2 > 0 ? "$Research_NoneInProgress" : "$Research_AllResearchComplete");
         var _loc5_:TextLineMetrics = this.NoProgress_mc.Header_mc.Text_tf.getLineMetrics(0);
         this.NoProgress_mc.HeaderBG_mc.width = _loc5_.width + this.HEADER_PADDING;
         var _loc6_:String = this._numInProgress > 0 ? IN_PROGRESS : NO_PROGRESS;
         if(currentFrameLabel != _loc6_)
         {
            gotoAndStop(_loc6_);
         }
      }
      
      private function FindAndReplaceLastComma(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:int = param1.lastIndexOf(", ");
         if(_loc3_ != -1)
         {
            _loc2_ = param1.slice(0,_loc3_);
            if(_loc2_.length <= this.ProjectListCharLimit - this.CONTINUE_TEXT_CHAR_COUNT)
            {
               _loc2_ += ", [...]";
            }
            else
            {
               _loc2_ = this.FindAndReplaceLastComma(_loc2_);
            }
         }
         return _loc2_;
      }
      
      public function PlayClosingAnimation() : void
      {
         if(this._numInProgress > 0)
         {
            gotoAndPlay(IN_PROGRESS + CLOSE);
         }
         else
         {
            gotoAndPlay(NO_PROGRESS + CLOSE);
         }
      }
   }
}
