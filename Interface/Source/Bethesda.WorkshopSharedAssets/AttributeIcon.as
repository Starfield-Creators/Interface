package
{
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.WorkshopUtils;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class AttributeIcon extends SharedLibraryUserLoaderClip
   {
      
      public static const SET_LOADER:String = "AttributeIcon_SetLoader";
       
      
      public var Info_mc:MovieClip;
      
      private var _artName:String = "";
      
      private var _row:uint = 0;
      
      private var _rank:uint = 0;
      
      private var _hasSkill:Boolean = false;
      
      private var _largeTextMode:Boolean = false;
      
      public function AttributeIcon()
      {
         super();
         this.centerClip = true;
         if(!this._largeTextMode)
         {
            Extensions.enabled = true;
            TextFieldEx.setTextAutoSize(this.Info_mc.Name_mc.Text_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      private function get artName() : String
      {
         return this._artName;
      }
      
      private function get row() : uint
      {
         return this._row;
      }
      
      public function get rank() : uint
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
      
      public function set rank(param1:uint) : void
      {
         if(this._rank != param1)
         {
            this._rank = param1;
            _refreshClip = true;
         }
      }
      
      override public function LoadClip(param1:Object, param2:String = "AttributeIcon_SetLoader") : void
      {
         super.LoadClip(param1,param2);
      }
      
      override protected function UpdateData(param1:Object) : void
      {
         WorkshopUtils.SetSingleLineText(this.Info_mc.Name_mc.Text_tf,param1.sName,this._largeTextMode);
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
      
      protected function RefreshValidState() : void
      {
         var _loc1_:MovieClip = null;
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
               this.Info_mc.gotoAndStop("valid");
            }
            else
            {
               if(_loc1_ != null)
               {
                  _loc1_.alpha = 0.5;
               }
               clipInstance.gotoAndStop("highlightRed");
               this.Info_mc.gotoAndStop("invalid");
            }
         }
      }
   }
}
