package
{
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class ProjectSkillRequirement extends SharedLibraryUserLoaderClip
   {
      
      public static const REQUEST_LOADER:String = "ResearchSkill_RequestLibrary";
       
      
      public var Locked_mc:MovieClip;
      
      public var Name_mc:MovieClip;
      
      public var Rank_mc:MovieClip;
      
      private var _artName:String = "";
      
      private var _row:uint = 0;
      
      private var _rank:uint = 0;
      
      private var _hasSkill:Boolean = false;
      
      public function ProjectSkillRequirement()
      {
         super();
         this.centerClip = true;
      }
      
      private function set hasSkill(param1:Boolean) : void
      {
         this._hasSkill = param1;
         var _loc2_:Boolean = !_refreshClip && clipInstance != null;
         if(_loc2_)
         {
            this.RefreshValidState();
         }
      }
      
      private function set artName(param1:String) : void
      {
         if(this._artName != param1)
         {
            this._artName = param1;
            _refreshClip = true;
         }
      }
      
      private function set row(param1:uint) : void
      {
         if(this._row != param1)
         {
            this._row = param1;
            _refreshClip = true;
         }
      }
      
      private function set rank(param1:uint) : void
      {
         if(this._rank != param1)
         {
            this._rank = param1;
            _refreshClip = true;
         }
      }
      
      override public function LoadClip(param1:Object, param2:String = "ResearchSkill_RequestLibrary") : void
      {
         super.LoadClip(param1,param2);
      }
      
      override protected function UpdateData(param1:Object) : void
      {
         GlobalFunc.SetText(this.Name_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.Rank_mc.Text_tf,"$$RANK " + param1.uRank);
         this.artName = param1.sArtName;
         this.row = param1.uRow;
         this.rank = param1.uRank;
         this.hasSkill = param1.bHasSkill;
      }
      
      override protected function ClipSetup() : void
      {
         _clipInstance = _sharedLibrary.LoadClip("Patch_Icon_" + this._row);
         var _loc1_:MovieClip = _sharedLibrary.LoadClip(this._artName,"Patch_" + this._row + "_Default");
         if(_clipInstance.PatchArtClip_mc != null)
         {
            _clipInstance.PatchArtClip_mc.addChild(_loc1_);
         }
         _loc1_.gotoAndStop("Rank" + this._rank);
         if(_clipInstance.PatchBackground_mc != null)
         {
            _clipInstance.PatchBackground_mc.gotoAndStop("Rank" + this._rank);
         }
         this.RefreshValidState();
      }
      
      private function RefreshValidState() : void
      {
         var _loc1_:MovieClip = null;
         this.Locked_mc.visible = !this._hasSkill;
         if(clipInstance != null)
         {
            _loc1_ = clipInstance.PatchArtClip_mc;
            if(this._hasSkill)
            {
               if(_loc1_ != null)
               {
                  _loc1_.alpha = 1;
               }
               clipInstance.gotoAndStop("highlightOff");
            }
            else
            {
               if(_loc1_ != null)
               {
                  _loc1_.alpha = 0.5;
               }
               clipInstance.gotoAndStop("highlightRed");
            }
         }
      }
   }
}
