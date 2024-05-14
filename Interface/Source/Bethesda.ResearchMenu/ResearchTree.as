package
{
   import Components.DisplayList;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ResearchTree extends MovieClip
   {
       
      
      public var Header_mc:MovieClip;
      
      public var MainProject_mc:ProjectName_Entry;
      
      public var Arrow_mc:MovieClip;
      
      public var LinkedProjectsList_mc:DisplayList;
      
      private var _treeStartPos:Number = 0;
      
      private var _linkedSectionSpacing:uint = 46;
      
      private var _horizontalTree:Boolean = false;
      
      public function ResearchTree()
      {
         super();
         this._treeStartPos = this.MainProject_mc.y;
         GlobalFunc.SetText(this.Header_mc.Text_tf,"$Research_Tree");
         this.LinkedProjectsList_mc.Configure(ResearchTree_Entry,ResearchUtils.TREE_COLUMNS,ResearchUtils.TREE_ROWS,ResearchUtils.TREE_COLUMNS_SPACING,ResearchUtils.TREE_ROWS_SPACING);
         this.MainProject_mc.gotoAndStop("selected");
      }
      
      public function UpdateTreeData(param1:Object, param2:Boolean) : void
      {
         var _loc4_:ResearchTree_Entry = null;
         this.ShowTree(true);
         GlobalFunc.SetText(this.MainProject_mc.Name_mc.Text_tf,param1.sName);
         this.LinkedProjectsList_mc.entryData = param1.aLinkedProjects;
         this.Arrow_mc.visible = param1.aLinkedProjects.length > 0;
         if(this._horizontalTree)
         {
            if(param2)
            {
               this.MainProject_mc.x = this._treeStartPos;
               this.Arrow_mc.x = this.MainProject_mc.x + this.MainProject_mc.width + (this._linkedSectionSpacing - this.Arrow_mc.width) / 2;
               this.LinkedProjectsList_mc.x = this.MainProject_mc.x + this.MainProject_mc.width + this._linkedSectionSpacing;
            }
            else
            {
               this.LinkedProjectsList_mc.x = this._treeStartPos;
               this.Arrow_mc.x = this.LinkedProjectsList_mc.x + this.LinkedProjectsList_mc.width + (this._linkedSectionSpacing - this.Arrow_mc.width) / 2;
               this.MainProject_mc.x = this.LinkedProjectsList_mc.x + this.LinkedProjectsList_mc.width + this._linkedSectionSpacing;
            }
         }
         else if(param2)
         {
            this.MainProject_mc.y = this._treeStartPos;
            this.Arrow_mc.y = this.MainProject_mc.y + this.MainProject_mc.height + (this._linkedSectionSpacing - this.Arrow_mc.height) / 2;
            this.LinkedProjectsList_mc.y = this.MainProject_mc.y + this.MainProject_mc.height + this._linkedSectionSpacing;
         }
         else
         {
            this.LinkedProjectsList_mc.y = this._treeStartPos;
            this.Arrow_mc.y = this.LinkedProjectsList_mc.y + this.LinkedProjectsList_mc.height + (this._linkedSectionSpacing - this.Arrow_mc.height) / 2;
            this.MainProject_mc.y = this.LinkedProjectsList_mc.y + this.LinkedProjectsList_mc.height + this._linkedSectionSpacing;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.LinkedProjectsList_mc.totalEntryClips)
         {
            if((_loc4_ = this.LinkedProjectsList_mc.GetClipByIndex(_loc3_) as ResearchTree_Entry) != null)
            {
               _loc4_.ShowProgressInfo(!param2);
            }
            _loc3_++;
         }
      }
      
      public function ShowTree(param1:Boolean) : void
      {
         this.MainProject_mc.visible = param1;
         this.Arrow_mc.visible = param1;
         this.LinkedProjectsList_mc.visible = param1;
      }
   }
}
