package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public final class CrewSkillsContainer extends MovieClip
   {
       
      
      public var IconSizer_mc:MovieClip;
      
      public var Name_tf:TextField;
      
      public var StarHolder_mc:MovieClip;
      
      public var SkillClip_mc:SkillClip;
      
      private var Stars_OrigX:Number;
      
      private const STAR_SPACING:Number = 4;
      
      private const SKILLCLIP_YOFFSET:* = 40;
      
      private var Type:uint = 0;
      
      private var CurrRank:uint = 1;
      
      public function CrewSkillsContainer()
      {
         super();
         this.Stars_OrigX = this.StarHolder_mc.x;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function SetIcon(param1:String, param2:Object) : void
      {
         GlobalFunc.SetText(this.Name_tf,param1,false);
         var _loc3_:Object = new Object();
         _loc3_.sImageName = param2.sImageName;
         _loc3_.uType = this.Type;
         _loc3_.uRank = this.CurrRank;
         this.SkillClip_mc.clipYOffset = this.SKILLCLIP_YOFFSET;
         this.SkillClip_mc.centerClip = true;
         this.SkillClip_mc.LoadClip(_loc3_);
      }
      
      public function SetType(param1:uint) : void
      {
         this.Type = param1;
      }
      
      public function SetRank(param1:uint) : void
      {
         var _loc4_:CrewSkillsStar = null;
         GlobalFunc.ClearClipOfChildren(this.StarHolder_mc);
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < param1)
         {
            (_loc4_ = new CrewSkillsStar()).name = "Star" + _loc3_;
            _loc4_.x = _loc2_;
            _loc2_ += _loc4_.width + this.STAR_SPACING;
            this.StarHolder_mc.addChild(_loc4_);
            _loc3_++;
         }
         _loc2_ -= this.STAR_SPACING;
         this.StarHolder_mc.x = this.Stars_OrigX - _loc2_ / 2;
         this.CurrRank = param1;
      }
   }
}
