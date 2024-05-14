package
{
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import flash.display.MovieClip;
   
   public class SkillClip extends SharedLibraryUserLoaderClip
   {
       
      
      private var _artName:String = "";
      
      private var _type:uint = 0;
      
      private var _rank:uint = 0;
      
      public function SkillClip()
      {
         super();
      }
      
      override protected function UpdateData(param1:Object) : void
      {
         this._artName = param1.sImageName;
         this._type = param1.uType;
         this._rank = param1.uRank;
         _refreshClip = true;
      }
      
      override protected function ClipSetup() : void
      {
         _clipInstance = _sharedLibrary.LoadClip(this._artName);
         var _loc1_:MovieClip = _sharedLibrary.LoadClip("Patch_Icon_" + String(this._type));
         if(_loc1_ != null)
         {
            _clipInstance.addChild(_loc1_);
            _loc1_.gotoAndStop("highlightOff");
         }
         _clipInstance.gotoAndStop("Rank" + String(this._rank));
         if(_loc1_.PatchBackground_mc != null)
         {
            _loc1_.PatchBackground_mc.gotoAndStop("Rank" + String(this._rank));
         }
         var _loc2_:* = _clipInstance.width / _clipInstance.height;
         var _loc3_:* = BoundClip_mc.width;
         BoundClip_mc.width = BoundClip_mc.height * _loc2_;
         BoundClip_mc.x += (_loc3_ - BoundClip_mc.width) / 2;
      }
   }
}
