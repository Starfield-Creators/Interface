package
{
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   public class SkillRequirement extends SharedLibraryUserLoaderClip
   {
      
      public static const SET_LOADER:String = "SkillRequirement_SetLoader";
       
      
      public var Info_mc:MovieClip;
      
      private const PATCH_RANK:String = "Rank";
      
      private var _artName:String = "";
      
      private var _row:uint = 0;
      
      private var _rank:uint = 0;
      
      private var _hasSkill:Boolean = false;
      
      public function SkillRequirement()
      {
         super();
         this.centerClip = true;
      }
      
      private function get artName() : String
      {
         return this._artName;
      }
      
      private function get row() : uint
      {
         return this._row;
      }
      
      private function get rank() : uint
      {
         return this._rank;
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
      
      override public function LoadClip(param1:Object, param2:String = "SkillRequirement_SetLoader") : void
      {
         super.LoadClip(param1,param2);
      }
      
      override protected function UpdateData(param1:Object) : void
      {
         GlobalFunc.SetText(this.Info_mc.Name_mc.Text_tf,param1.sName);
         GlobalFunc.SetText(this.Info_mc.Rank_mc.Text_tf,"$$RANK " + param1.uRank);
         this.artName = param1.sArtName;
         this.row = param1.uRow;
         this.rank = param1.uRank;
         this.hasSkill = param1.bHasSkill;
      }
      
      override protected function ClipSetup() : void
      {
         _clipInstance = _sharedLibrary.LoadClip("Patch_Icon_" + this.row);
         var _loc1_:MovieClip = _sharedLibrary.LoadClip(this.artName,"Patch_" + this.row + "_Default");
         if(_clipInstance.PatchArtClip_mc != null)
         {
            _clipInstance.PatchArtClip_mc.addChild(_loc1_);
         }
         _loc1_.gotoAndStop("Rank" + this.rank);
         if(_clipInstance.PatchBackground_mc != null)
         {
            _clipInstance.PatchBackground_mc.gotoAndStop("Rank" + this.rank);
         }
         this.RefreshValidState();
      }
      
      private function RefreshValidState() : void
      {
         if(clipInstance != null)
         {
            clipInstance.PatchArtClip_mc.alpha = this._hasSkill ? 1 : CraftingUtils.FADED_SKILL;
            clipInstance.PatchBackground_mc.alpha = this._hasSkill ? 1 : CraftingUtils.FADED_SKILL;
            clipInstance.gotoAndStop("highlightOff");
            this.Info_mc.alpha = this._hasSkill ? 1 : CraftingUtils.FADED_SKILL;
         }
      }
   }
}
