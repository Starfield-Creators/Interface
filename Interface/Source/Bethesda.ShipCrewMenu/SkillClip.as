package
{
   import Shared.Components.ContentLoaders.SharedLibraryUserLoaderClip;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class SkillClip extends SharedLibraryUserLoaderClip
   {
      
      private static var LargeTextMode:Boolean = false;
       
      
      public var Name_mc:MovieClip;
      
      public var Rank_mc:MovieClip;
      
      private var _artName:String = "";
      
      private var _type:uint = 0;
      
      private var _rank:uint = 0;
      
      public function SkillClip()
      {
         super();
      }
      
      public static function set largeTextMode(param1:Boolean) : *
      {
         LargeTextMode = param1;
      }
      
      public function get Name_tf() : TextField
      {
         return this.Name_mc.Text_tf;
      }
      
      public function SetActive(param1:Boolean) : void
      {
         gotoAndStop(param1 ? "Active" : "Inactive");
         if(LargeTextMode)
         {
            TextFieldEx.setVerticalAlign(this.Name_mc.Text_tf,TextFieldEx.VALIGN_CENTER);
         }
      }
      
      override protected function UpdateData(param1:Object) : void
      {
         GlobalFunc.SetText(this.Name_tf,param1.sName);
         this._artName = param1.iconImage.sImageName;
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
         _clipInstance.x = _clipInstance.width / 2 - 3;
         this.Rank_mc.gotoAndStop(this._rank);
      }
   }
}
